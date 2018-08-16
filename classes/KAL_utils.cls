global with sharing class KAL_utils {

    public static Order obtenerOrdenActualDelUsuario(String userId){
        
        Order ordenADevolver = new Order();

        system.debug(userId);

        User usuario = [select id, contactid, accountid from user where id=: userId];

        /*system.debug(userId);
        system.debug(usuario);
        system.debug(usuario.contactId);
        system.debug(usuario.accountid);/* */

        List<Order> ordenes = [select id, AccountId, ShippingEmailContact__c, OrderNumber, vlocity_cmt__EffectiveOrderTotal__c, vlocity_cmt__shippingName__c, 
                                OneTimeTotal_w_Tax__c, ShippingHomePhone__c, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, Delivery_Method__c 
                                from order 
                                where accountId =: usuario.accountid and  
                                status = 'Draft' and
                                vlocity_cmt__originatingchannel__c = 'E-Commerce'                
                                order by lastmodifieddate desc       
                                limit 1];
        if(ordenes.size() > 0) {
            ordenADevolver = ordenes[0];
        }

        return ordenADevolver;
    }

    /*  Métodos para: 
            - crear orden,
            - agregar productos a la misma y 
            - obtener sus precios.
        Nehuén Sola.
    */
    public static String crearOrden(String userId) {
        if(string.isBlank(userId)) {
            throw new KAL_Exception('El parámetro userId es obligatorio.');
        }
        
        String accountId = '';
        List<User> us = [Select Id, Name, AccountId From User Where Id = :userId];
        if(us.Size() > 0 && us[0].AccountId != null) {
            accountId = us[0].AccountId;
        } else {
            throw new KAL_Exception('El usuario no existe o no tiene una cuenta asociada.');
        }

        final String K_TA_PRICE_LIST_ID = getPriceListId('PRL_TELCOM');
        Pricebook2 Pricebook = getPriceBook();
        List<Map<String, Object>> lstInputParams = new List<Map<String, Object>>();
        Map<String, Object> pInputMap = new Map<String, Object>();
        String fecha = Date.Today().Month() +'/'+ Date.Today().Day() +'/'+ Date.Today().Year();
        String nombreCarrito = 'Carrito';
        if(!String.isBlank(us[0].Name)) {
            nombreCarrito += ' de ' + us[0].Name;
        }

        lstInputParams.add(getMap('Effectivedate', fecha));
        lstInputParams.add(getMap('status', 'Draft'));
        lstInputParams.add(getMap('vlocity_cmt__originatingchannel__c', 'E-Commerce'));
        lstInputParams.add(getMap('Name', nombreCarrito));
        lstInputParams.add(getMap('Delivery_Method__c', 'Delivery'));
        lstInputParams.add(getMap('AccountId', accountId));
        lstInputParams.add(getMap('vlocity_cmt__PriceListId__c', K_TA_PRICE_LIST_ID)); //-- Aqui fuerzo la lista de precios 
        lstInputParams.add(getMap('vlocity_cmt__Pricebook__c', Pricebook.Id));

        pInputMap.put('fields', 'Id');
        pInputMap.put('subaction', 'createOrder');
        pInputMap.put('inputFields', lstInputParams);
        pInputMap.put('objectType', 'Order');
        //pInputMap.put('methodName', 'createCart');

        //System.debug('..... Crear orden - Inicio ');
        system.debug(pInputMap);
        String orderId = null;
        Map<String, Object> outMap = new Map<String, Object>();
        vlocity_cmt.CpqAppHandler cpqAppHandlerService = new vlocity_cmt.CpqAppHandler();
        cpqAppHandlerService.invokeMethod('createCart', pInputMap, outMap, null);
        system.debug(outMap);    
        //System.debug('..... Crear orden - Despues de invocar el servicio ');    
        if (outMap == null || outMap.isEmpty()) {
            throw new KAL_Exception('Error al crear la orden, el servicio devolvio el mapa vacio');
        }

        //System.debug('..... Crear orden - Antes de empezar a recorrer el pbe list ');    
        vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);    
        List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;
        for(vlocity_cmt.JSONRecord record: pbeList){
            orderId = (String)record.fields.get('Id');
        }

        return orderId;
    }

    public static void agregarProductosAOrden(String idCarrito, List<String> idsPBE) {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> itemsMap = new Map<String, Object>();

        /* Consigo los PriceBook Entries */
        List<PricebookEntry> PBEs = [
            Select Id,IsActive,Pricebook2Id,Product2Id,UnitPrice 
            From PricebookEntry 
            Where Id In :idsPBE 
            And Pricebook2.Name = 'TA Price Book' 
            And isActive = true
        ];
        Set<String> setPBEIds = new Set<String>();
        if(PBEs.size() > 0) {
            for(PricebookEntry PBE : PBEs) {
                if(!setPBEIds.contains(PBE.Id)) {
                    setPBEIds.add(PBE.Id);
                }
            }
        } else {
            throw new KAL_Exception('No se encontraron los productos solicitados.');
        }

        /* Consigo los items que ya contenia el carrito (orden) */
        Boolean validar = false;
        List<OrderItem> itemsAActualizarCantidad = new List<OrderItem>();
        Map<String, OrderItem> itemsEnOrden = conseguirPrecios(idCarrito);
        if(itemsEnOrden.values().size() > 0) {
            validar = true;
        }

        List<Object> items = new List<Object>();
        // Itero sobre los items del carrito
        for(String idP : idsPBE) {
            itemsMap = new Map<String, Object>();
            itemsMap.put('itemId', Id.valueOf(idP));
            if(validar == true) {
                if(itemsEnOrden.containsKey(idP)) {
                    OrderItem item = itemsEnOrden.get(idP);
                    item.Quantity++;
                    itemsAActualizarCantidad.add(item);
                    break;
                }
            }
            items.add(itemsMap);
        }
        Id cartId = Id.valueOf(idCarrito);
        inputMap.put('items', items);
        inputMap.put('cartId', cartId);
        inputMap.put('validate', true); // set to false if validation is not required
        inputMap.put('price', true);    // set to false if pricing is not required

        if(items.size() > 0) {
            vlocity_cmt.CpqAppHandler cpqAppHandlerService = new vlocity_cmt.CpqAppHandler();
            cpqAppHandlerService.invokeMethod('postCartsItems', inputMap, outputMap, optionsMap);
        }

        Map<String, Object> objeto = new Map<String, Object>();
        List<Object> JSONResult = (List<Object>) outputMap.get('JSONResult');
        for(Object json : JSONResult) {
            objeto = (Map<String, Object>) json;
            if(objeto.get('records') == null) {
                break;
            }
        }
        //System.debug(objeto);

        if(itemsAActualizarCantidad.size() > 0) {
            try{
                update itemsAActualizarCantidad;
            }catch (Exception ex) {
                throw new KAL_Exception('ERROR: ' + ex.getMessage());
            }
        }
    }

    public static Map<String, OrderItem> conseguirPrecios(String idCarrito) {
        Id cartId = Id.valueOf(idCarrito);
        /* Usando API de Vlocity 
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('methodName', 'getCartLineItemPrices');
        inputMap.put('cartId', cartId);
        inputMap.put('priceDetailsFields', '');

        vlocity_cmt.CpqAppHandler cpqAppHandlerService = new vlocity_cmt.CpqAppHandler();
        cpqAppHandlerService.invokeMethod('getCartLineItemPrices', inputMap, outputMap, optionsMap);
        return outputMap;
        */
        
        /* Query a SFDC */
        List<OrderItem> objOrderItem = [SELECT Id, PricebookEntryId, Product2Id, vlocity_cmt__EffectiveOneTimeTotal__c, Quantity, UnitPrice, vlocity_cmt__AssetId__c FROM OrderItem WHERE OrderId = : idCarrito];
        Map<String, OrderItem> returnMap = new Map<String, OrderItem>();
        if(objOrderItem.size() > 0) {
            for(OrderItem ordItem : objOrderItem) {
                returnMap.put(ordItem.PricebookEntryId, ordItem);
            }
        }
        return returnMap;
    }

    //  Funciones auxiliares para tratamiento de ordenes:
    /**
     * Esta funcion recibe un Price List Code (Ej.: PRL_TELECOM) y
     * devuelve el Id de esa Price List para poder informarcelo a la orden Draft.
     */
    private static String getPriceListId (String pPriceListCode) {
        try {
            List<vlocity_cmt__PriceList__c> lstPriceList = [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = :pPriceListCode AND vlocity_cmt__IsActive__c = true];
            if (lstPriceList.size()>0) {
                return lstPriceList.get(0).id;
            }
            else {
                throw new KAL_Exception('Error al obtener el Price List Id para el Price List Code: ' + pPriceListCode);
            }
        }
        catch (Exception e) {
            throw new KAL_Exception('Error al obtener el Price List Id para el Price List Code: ' + pPriceListCode + '. Error: ' + e.getMessage());
        }    
    }
    /**
     * Servicio que recibe dos parámetros y los devuelve en formato Map<String, Object>
     */
    private static Map<String, Object> getMap(String pNombre, Object pValor) {
        Map<String, Object> mapa = new Map<String, Object>();
        mapa.put (pNombre, pValor);
        return mapa;
    }

    private void llamarIntegrationProcedure(String pServiceName, Map<String, Object> pBodyMap) {
        System.debug('Entre en callIntegrationProcedure()');
        try {
            Map<String,Object> inMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> optMap = new Map<String,Object>();

            inMap.put('body', pBodyMap);
            System.debug('inMap --> ' + JSON.serialize(inMap));
            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();

            integProcService.invokeMethod(pServiceName, inMap, outMap, optMap);
            try {
                Map<String, Object> response = (Map<String, Object>)outMap.get('IPResult');
                if (response.containsKey('codigo')) {
                    throw new CalloutException((String)response.get('codigo') + ' - ' + (String)response.get('mensaje'));
                }
            }
            catch (CalloutException ce) {
                throw ce;
            } 
            catch (TypeException te) {
                Object response = (Object)outMap.get('IPResult');
                system.debug('IPResult (String) --> ' + response);
                throw new CalloutException(te.getMessage());
            }
            catch (Exception e) {
                throw e;    
            }
        }
        catch (Exception e) {
            System.debug('Error al invocar el integration procedure ' + pServiceName + ' - Error: ' + e.getMessage());
            System.debug(e.getStackTraceString());
            throw new KAL_exception(e.getMessage());
        }
    }

    private static Pricebook2 getPriceBook() {
        List<Pricebook2> PB = [
            Select Id,Name,IsActive 
            From Pricebook2
            Where Name = 'TA Price Book' 
            And isActive = true
            Limit 1
        ];
        if(PB.size() == 0){
            throw new Kal_Exception('No se encontró el pricebook \'TA Price Book\'.');
        }
        return pb[0];
    }

}