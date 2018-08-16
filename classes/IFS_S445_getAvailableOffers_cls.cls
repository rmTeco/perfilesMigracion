/**
 * Este es un servicio rest que permite consultar las ofertas disponibles
 * para una determinada cuenta y un determinado canal. Para ello, crea una
 * orden draft y luego se aplica el metodo getCartItems.
 *
 * Nota: 
 *   Al crear la orden draft utilizando el metodo createCart se utlilza el campo
 * Description de la orden creada para guardar ahi el MSISDN o el subscriptionId
 * en el siguiente formato: <tipo>:<valor>. Ej.: M:1143211234
 * Para que lo pueda recuperar el servicio IFS_S446_addNewProduct.cls.
 *
 * @Author: Alejandro Salord (Certa Consulting).
 * @Version: 
 * @see: 
 */
public with sharing class IFS_S445_getAvailableOffers_cls {

    public static final boolean K_DEBUG_ON = true;

    public static ResultObj getAvailableOffers(string jsonInput){
        ResultObj resultObject;
        Map<String, Object> resultado;
        FromJSON jsonBody;
        printDebug('Entre a getAvailableOffers() --> '+ jsonInput);
        printDebug('User: ' + Userinfo.getName());

        try {
            try {
                jsonBody = (FromJSON)JSON.deserialize(jsonInput, FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Error: ' + e.getMessage());
            } 
            checkContrato (jsonBody); //-- Verifico que el contrato (IFS) se cumpla.

            String lorderId = null;
            try {
                resultado = createOrder(getInputParams(jsonBody), jsonBody);
                lorderId = (String)resultado.get('orderId');
                if (String.isBlank(lorderId)) {
                    throw new FunctionalException('Error al crear la orden');
                }
            }
            catch (Exception e) {
                throw new FunctionalException('Error al crear la orden draft');
            }

            resultObject = new ResultObj(200, Blob.valueOf(JSON.serialize(getAvailableOffersByCatalog (lorderId, jsonBody.codCanal, jsonBody.codCortoOferta, jsonBody.tipo, jsonBody.subTipo))));
            printDebug('Retorna: ' + resultObject);
            return resultObject;
        }
        catch (FunctionalException fe) {
            resultObject = new ResultObj(417, Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage()))));
            return resultObject;
        }
        catch (CalloutException ce) {
            resultObject = new ResultObj(400, Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage()))));
            printDebug('Retorna: ' + resultObject);
            return resultObject;
        }
        catch(Exception e){
            resultObject = new ResultObj(500, Blob.valueOf(JSON.serialize(getRespuestaNoOk('500',e.getMessage()))));
            printDebug('Retorna: ' + resultObject);
            return resultObject;

        }
    }



    /**
     * @Objetivo: Genera el body de response No OK.
     */
    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        printDebug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }
    
    /**
     * Objetivo: Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     */
    private static void checkContrato (FromJSON pJson) {
        printDebug('Entre a checkContrato()');

        if (pJson == null) {
            printDebug('El json vino vacio o nulo'); 
            throw new CalloutException('Error en la validacion de los atributos del request. Vino vacio.');
        }

        String subscriberId = null;
        String nroLinea = null;
        String idCliente = pJson.idCliente;
        String canal = pJson.codCanal;

        if (pJson.choiceId != null) {
            subscriberId = pJson.choiceId.subscriberId;
            nroLinea = pJson.choiceId.nroLinea;
        }

        if (String.isBlank(subscriberId) && String.isBlank(nroLinea)) {
            printDebug('El subscriberId y el nroLinea no vinieron o estan vacios, alguno debe venir.'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El choice vino vacio y debe contener al menos uno de los dos datos [idCliente o subscriberId o nroLinea]');
        }

        /*
         * Si viene un valor con mas de 11 caracteres o digitos lo trunco a 11 porque
         * el campo en la base es de 11.
         */
        if (idCliente != null && idCliente.length()>11) { 
            pJson.idCliente = idCliente.substring(0,11);
        }

        if (String.isBlank(canal)) {
            printDebug('canal nulo o vacio '); 
            throw new CalloutException('Error en la validacion de los atributos del request. El canal vino vacio');
        }

        if (!canal.equals('IVR') && !canal.equals('USSD') && !canal.equals('SMS')) {
            printDebug('canal no valido: ' + canal); 
            throw new CalloutException('Error en la validacion de los atributos del request. El canal debe contener algun valor de la lista: [IVR, USSD, SMS]');
        }
    }

    /**
     * Esta funcion arma los parametros para crear una orden draft.
     */
    private static Map<String,Object> getInputParams(FromJSON pJsonBody) {
        printDebug('Entre a getInputParams()');

        final String K_TA_PRICE_LIST_ID = getPriceListId ('PRL_TELCOM');                                                        
        Map<String, Object> mapa = new Map<String, Object>();
        List<Map<String, Object>> lstInputParams = new List<Map<String, Object>>();

        String idCliente = pJsonBody.idCliente;
        String subscriberId = (pJsonBody.choiceId != null) ? pJsonBody.choiceId.subscriberId : null;
        String nroLinea = (pJsonBody.choiceId != null) ? pJsonBody.choiceId.nroLinea : null;
        String codCanal = pJsonBody.codCanal;
        String accountId = null;

        if (!String.isEmpty(nroLinea)) {
            accountId = getAccountIdByMsisdn (nroLinea);
        }
        else if (!String.isEmpty(subscriberId)) {
            accountId = getAccountIdBySuscriber (subscriberId);
        }
        else {
            accountId = getAccountIdByIdCliente(idCliente); 
        }

        lstInputParams.add(getMap('Effectivedate', Date.today()));
        lstInputParams.add(getMap('status', 'Draft'));
        lstInputParams.add(getMap('Name', ''));
        lstInputParams.add(getMap('AccountId', accountId));
        lstInputParams.add(getMap('vlocity_cmt__PriceListId__c', K_TA_PRICE_LIST_ID)); //-- Aqui fuerzo la lista de precios 

        mapa.put('fields', 'Id,Name,EffectiveDate');
        mapa.put('subaction', 'createOrder');
        mapa.put('inputFields', lstInputParams);
        mapa.put('objectType', 'Order');
        mapa.put('methodName', 'createCart');

        return mapa;
    }

    /**
     * Esta funcion recibe un Price List Code (Ej.: PRL_TELECOM) y
     * devuelve el Id de esa Price List para poder informarcelo a la orden Draft.
     * Por ahora no es llamada ya que el Id de Price List esta hardcodeado, pero si 
     * se cambia la estrategia y hay que ir a buscar la lista de precios, el código de
     * lista de precios deberia venir informado en el request y con ese dato se deberá 
     * invocar esta funcion para obtener el Id.
     */
    private static String getPriceListId (String pPriceListCode) {
        printDebug('Entre en getPriceListId');

        try {
            List<vlocity_cmt__PriceList__c> lstPriceList = [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = :pPriceListCode AND vlocity_cmt__IsActive__c = true];
            if (lstPriceList.size()>0) {
                return lstPriceList.get(0).id;
            }
            else {
                throw new FunctionalException('Error al obtener el Price List Id para el Price List Code: ' + pPriceListCode);
            }
        }
        catch (Exception e) {
            printDebug('..... Error al obtener el Price List Id para el Price List Code: '  + pPriceListCode + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener el Price List Id para el Price List Code: ' + pPriceListCode + '. Error: ' + e.getMessage());
        }    
    }

    /**
     * Servicio que recibe dos parámetros y los devuelve en formato Map<String, Object>
     */
    private static Map<String, Object> getMap(String pNombre, Object pValor) {
        printDebug('Entre a getMap()');
        Map<String, Object> mapa = new Map<String, Object>();
        mapa.put (pNombre, pValor);
        return mapa;
    }

    /*
     * Esta funcion recibe un Map<String, Object> que contiene los datos que permiten
     * crear una order.
     */
    private static Map<String, Object> createOrder (Map<String, Object> pInputMap, FromJSON pJsonBody) {
        printDebug('Entre a createOrder()');

        try {
            printDebug('..... Crear orden - Inicio ');
            String orderId = null;
            Map<String, Object> outMap = new Map<String, Object>();
            vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
            appHandler.invokeMethod('createCart', pInputMap, outMap, null);
                
            printDebug('..... Crear orden - Despues de invocar el servicio ');    
            if (outMap == null || outMap.isEmpty()) {
                throw new FunctionalException('Error al crear la orden, el servicio devolvio el mapa vacio');
            }

            printDebug('..... Crear orden - Antes de empezar a recorrer el pbe list ');    
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);    
            List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;
            for(vlocity_cmt.JSONRecord record: pbeList){
                orderId = (String)record.fields.get('Id');
            }

            printDebug('..... Crear orden - Antes de guardar el order Id ');    

            Map<String, Object> retorno = new Map<String, Object>();
            retorno.put('orderId', orderId);

            if (!String.isBlank(orderId)) {
                String tipoId = 'E'; //-- Default - Error.
                String valorId = null;
                Order order = [SELECT Id, Description FROM Order WHERE Id = :orderId];
                if (order != null) {
                    if (!String.isBlank(pJsonBody.choiceId.nroLinea)) {
                        tipoId = 'M';
                        valorId = pJsonBody.choiceId.nroLinea;
                    }
                    else {
                        tipoId = 'S';
                        valorId = pJsonBody.choiceId.subscriberId;
                    }
                    order.Description = tipoId + ':' + valorId; 
                    update order;
                }
            }

            return retorno;
        }
        catch (Exception e) {
            printDebug('Error al crear la orden. Error: ' + e.getMessage());
            throw new FunctionalException(e.getMessage());
        }    
    }


    private static Map<String, Object> getAvailableOffersByCatalog (String pOrderId, String pCanal, String pCodCortoOferta, String pTipo, String pSubTipo) {
        printDebug('Entre a getAvailableOffersByCatalog()');
        Map<String, Object> resultado = new Map<String, Object>();

        try {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            List<Map<String, Object>> lstOfertas = new List<Map<String, Object>>();
            Map<String, Object> product2Attribute = null;

            
            printDebug('Voy a obtener el Id de catalogo correspondiente al canal: ' + pCanal);
            String catalogId = getCatalogIdByName (pCanal);
            
            input.put('cartId', pOrderId);
            input.put('category', catalogId);
            input.put('hierarchy', 2);
            input.put('fields','Id, ProductCode, UnitPrice, Name, vlocity_cmt__RecurringPrice__c');

            printDebug(JSON.serialize(input));

            printDebug('Voy a obtener los productos correspondiente al catalogo');

         
                if(!Test.isRunningTest()){ 
                    vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
                    Object status = appHandler.invokeMethod('getCartsProducts', input, outMap, null);
                }else{
                    outMap = MockupFactory.getCardsProductsTest();
                }
      
                if (outMap == null || outMap.isEmpty()) {
                    throw new FunctionalException('Error al obtener los productos disponibles para la orden: ' + pOrderId + ', el servicio devolvio el mapa vacio');
                }


                printDebug('Voy a recorrer el json pbe obtenido de la API');
                printDebug('Resultado recibido:');
                printDebug(String.valueOf(outMap));

                vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT); 

                if (result == null) {
                    throw new FunctionalException('Error al obtener la oferta por catalogo -  No se pudo obtener el campo vlocity_cmt.JSONResult para el orderId: ' + pOrderId);
                }   

                List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;
                
                printDebug('.... Antes de empezar a recorrer la lista de ofertas disponibles devuelta por el getCatalogInfoForProduct');
                printDebug('......... Recibi ' + pbeList.size() + ' ofertas');
                printDebug('pbeList --> ' + pbeList);

            
            //if(!Test.isRunningTest()){
                
                Integer i = 0;
                     
                for(vlocity_cmt.JSONRecord record: pbeList){

                    printDebug('record --> ' + record);

                    printDebug('.... Producto nro: ' + i++);
                    Map<String, Object> resultado1 = new Map<String, Object>();
                    String productCode = '';
                    String id = '';
                    String product2Id = '';
                    String Name = '';
                    String price = '';
                    String recurringPrice = '';



                if(!Test.isRunningTest()){                  
                    productCode = (String)record.fields.get('ProductCode'); //.get('value');
                    id = (String)((Map<String,Object>)record.fields.get('Id')).get('value');
                    product2Id = (String)(record.fields.get('Product2Id')); //.get('value');
                    Name = (String)(record.fields.get('Name')); //.get('value');
                    price = (String)(record.fields.get('UnitPrice')); //.get('value');
                    recurringPrice = String.valueOf(record.fields.get('vlocity_cmt__RecurringPrice__c')); //.get('value'));
                } else {
                    Product2 producto =[SELECT Id,name,ProductCode FROM Product2];
                    PricebookEntry priceBook =[SELECT Id,UnitPrice,vlocity_cmt__RecurringPrice__c FROM PricebookEntry];
                    productCode = (String)producto.ProductCode;
                    id = (String)priceBook.Id;
                    product2Id = (String)producto.Id;
                    Name = (String)producto.name;
                    price = String.valueOf(pricebook.UnitPrice);
                    recurringPrice = String.valueOf(priceBook.vlocity_cmt__RecurringPrice__c);
                }    
                    String precio = getPrecio(price, recurringPrice);
                    
                    printDebug('..... String ProductName vName: ' + Name);


                    String alicuota = '1'; //default
                    try {
                        product2Attribute = getProduct2Attributes (product2Id);

                        if (!String.isBlank(pCodCortoOferta)) {
                            String lshortCode = (String)product2Attribute.get('shortCode');
                            printDebug('Codigo corto request: ' + pCodCortoOferta + ' - Codigo corto obtenido: ' + lshortCode);
                            if (!pCodCortoOferta.equals(lshortCode)) {
                                printDebug('Elimino de la lista a mostrar porque no coincide el short code. Por parametro vino: ' + pCodCortoOferta + ' - Encontrado en los atributos: ' + lshortCode);
                                continue;
                            }
                        }

                        if (!String.isBlank(pTipo)) { //-- Agregado en version Idd 2.0
                            String ltipo = (String)product2Attribute.get('type');
                            printDebug('Tipo request -> ' + pTipo + ' - Tipo obtenido -> ' + ltipo);
                            if (!pTipo.equals(ltipo)) {
                                printDebug('Elimino de la lista a mostrar porque no coincide el Tipo.');
                                continue;
                            }
                        }    

                        if (!String.isBlank(pSubTipo)) { //-- Agregado en version Idd 2.0
                            String lsubTipo = (String)product2Attribute.get('subType');
                            printDebug('SubTipo request -> ' + pSubTipo + ' - SubTipo obtenido -> ' + lsubTipo);
                            if (!pSubTipo.equals(lsubTipo)) {
                                printDebug('Elimino de la lista a mostrar porque no coincide el SubTipo.');
                                continue;
                            }
                        }    

                        resultado1.put('esProvisionDirecta', product2Attribute.get('esProvisionDirecta'));
                        resultado1.put('lstCodOfertaRating', product2Attribute.get('lstCodOfertaRating'));
                        resultado1.put('lstCondicionPago', product2Attribute.get('lstCondicionPago'));
                        resultado1.put('subTipo', product2Attribute.get('subType'));
                        resultado1.put('tipo', product2Attribute.get('type'));
                        resultado1.put('familia', product2Attribute.get('family'));
                        alicuota = (String)product2Attribute.get('alicuota');
                    }
                    catch (Exception e) {
                        throw new FunctionalException('Error obteniendo el canal y la familia del producto: ' + name + '. Error: ' + e.getMessage());
                    }

                    resultado1.put('idListaPrecio', id);
                    resultado1.put('precioSinImp', precio);
                    resultado1.put('precioConImp', getPrecioConImp(precio, alicuota));
                    resultado1.put('descripcion', name);
                    resultado1.put('codOferta', productCode);

                    lstOfertas.add(resultado1);

                    printDebug('..... Agregado a la lista de ofertas el producto:  ' + name);
                }
            // }
            //   else {
            //       //-- Test Mode --
            //       List<String> lstCodOfertaRating = new List<String>();
            //       lstCodOfertaRating.add('PRE');
            //       List<String> lstCondicionPago = new List<String>();
            //       lstCodOfertaRating.add('10000201');
            //       Map<String, Object> resultadoTest = new Map<String, Object>();
            //       resultadoTest.put('esProvisionDirecta', 'S');
            //       resultadoTest.put('lstCodOfertaRating', lstCodOfertaRating);
            //       resultadoTest.put('lstCondicionPago', lstCodOfertaRating);

            //       resultadoTest.put('subTipo', 'SMS');
            //       resultadoTest.put('tipo', 'Pack');
            //       resultadoTest.put('familia', 'Movil');

            //       resultadoTest.put('idListaPrecio', '01u6C000000xZ2RQAU');
            //       resultadoTest.put('precioSinImp', 0.0);
            //       resultadoTest.put('precioConImp', 0.0);
            //       resultadoTest.put('descripcion', 'Pack 5000 SMS x 5 días');
            //       resultadoTest.put('codOferta', 'FAN_PRDA_00028');

            //       lstOfertas.add(resultadoTest);

            // }

            resultado.put('lstOferta', lstOfertas);
            resultado.put('orderId', pOrderId);

            return resultado;

        }
        catch (Exception e) {
            printDebug('............ getAvailableOffersByCatalog - Error al obtener la oferta por catalogo -  ' + e.getMessage());
            printDebug('............ getAvailableOffersByCatalog - \n' + e.getStackTraceString());
            throw new FunctionalException(e.getMessage());
        }

    }

    private static String getPrecio (String pPrecio1, String pPrecio2) {
        printDebug('Entre a getPrecio()');
        printDebug('.... Parametros: pPrecio1: ' + pPrecio1 + ' - pPrecio2: ' + pPrecio2);
        String p1 = null;
        String p2 = null;

        try {
            p1 = String.valueOf(Decimal.valueOf(pPrecio1));
        }
        catch (Exception e) {
            p1 = '0.00';
        }

        try {
            p2 = String.valueOf(Decimal.valueOf(pPrecio2));
        }
        catch (Exception e) {
            p2 = '0.00';
        }
        
        return (p1.equals('0.00') ? p2 : p1);
    }


    /**
     * Esta funcion permite desgrabarle a un importe una determinada alícuota
     * de impuesto.
     */
    private static String getPrecioConImp (String pPrecioSinImp, String pAlicuota) {
        printDebug('Entre a getPrecioConImp() - pPrecioSinImp --> ' + pPrecioSinImp + ' - pAlicuota --> ' + pAlicuota);
        try {
            Decimal d = Decimal.valueOf(pPrecioSinImp);
            Decimal dAlicuota = Decimal.valueOf(pAlicuota);
            dAlicuota.setScale(2);
            Decimal coeficiente = 1 + (dAlicuota / 100.0);
            d = d * coeficiente;
            return String.valueOf(d.setScale(2));
        }
        catch (Exception e) {
            printDebug('Error calculando precio con impuesto para el precio: ' + pPrecioSinImp + ' . Error: ' + e.getMessage());
            throw new FunctionalException('Error calculando precio con impuesto para el precio: ' + pPrecioSinImp + ' . Error: ' + e.getMessage());
        }    
    }

    /**
     * Esta funcion permite obtener una cuenta a traves de un número de linea.
     * ParamIn: pNroLinea --> Es el número de la linea.
     * ParamOut: String --> cuenta asociada al número de línea.
     */
    private static String getAccountIdByMsisdn (String pNroLinea) {
        printDebug('Entre a getAccountIdByMsisdn()');
        String accountId = null;
        
        try {
            List<Asset> asset = [SELECT Id, MSISDN__c, AccountId FROM Asset WHERE MSISDN__c = :pNroLinea];
            if (asset.size()>0) {
                return asset.get(0).AccountId;
            }
            else {
                throw new FunctionalException('Error al obtener el accountId del nroLinea: ' + pNroLinea);
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener el accountId del nroLinea: ' + pNroLinea + '. Error: ' + e.getMessage());
        }    
    }

    /**
     * Esta funcion permite obtener el Id de una cuenta a traves del Id de cliente externo
     * que se encuentran en el campo CustomerIntegrationId__c del objeto Account.
     */
    private static String getAccountIdByIdCliente(String pClienteId) {
        printDebug('Entre en getAccountIdByIdCliente()');
        try {
            Double idCliente = Double.valueOf(pClienteId);
            printDebug('------ Decimal idCliente --> ' + idCliente);
            List<Account> lstAccount = [SELECT Id FROM Account WHERE CustomerIntegrationId__c = :idCliente];
            if (lstAccount == null || lstAccount.size()==0) {
                throw new FunctionalException('No se encontro el Account Id para el Id de Cliente externo  ' + pClienteId);
            }
            return lstAccount[0].Id;
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener el accountId del Id de cliente externo ' + pClienteId + ' - ' + e.getMessage(), e);
        }
    }


    /**
     * Esta funcion permite obtener el Id de un catalogo dado
     * por ahora hay catalogos para IVR y USSD.
     */
    private static String getCatalogIdByName (String pCatalogName) {
        printDebug('Entre a getCatalogIdByName()');
        String catalogId = null;
        
        if (String.isBlank(pCatalogName)) {
            throw new CalloutException('El nombre del catalogo vino vacio [Canal]');
        }
        
        try {
            List<vlocity_cmt__Catalog__c> lstCatalog = [SELECT Id FROM vlocity_cmt__Catalog__c WHERE Name = :pCatalogName];
            if (lstCatalog.size()>0) {
                return lstCatalog.get(0).Id;
            }
            else {
                throw new FunctionalException('Error al obtener el Id del catalogo para el canal: ' + pCatalogName);
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener el Id del catalogo para el canal: ' + pCatalogName + '. Error: ' + e.getMessage());
        }    
    }

    /*
     * suscriberId todavia no existe en el objeto Asset (29/11/2017). Dejo preparada la rutina
     * para cuando lo agreguen, mientras tanto para poder compilar comentarie la linea en donde 
     * hago referencia.
     */
    private static String getAccountIdBySuscriber (String pSuscriberId) {
        printDebug('Entre a getAccountIdBySuscriber()');
        String accountId = null;
        
        if (String.isBlank(pSuscriberId)) {
            throw new CalloutException('El suscriberId vino vacio');
        }
        
        try {
            List<Asset> asset = [SELECT AccountId FROM Asset WHERE Subscription_Id__c = :pSuscriberId];
            if (asset.size()>0) {
                return asset.get(0).AccountId;
            }
            else {
                throw new FunctionalException('Error al obtener el accountId del suscriberId: ' + pSuscriberId);
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener el accountId del suscriberId: ' + pSuscriberId + '. Error: ' + e.getMessage());
        }    
    }

/*
 *  Nota: Este rutina no es invocada por un cambio en el diseño funcional de la interface.
 *        Lo dejo como comentario por si se reactiva y se necesita encontrar los descuentos
 *        para no empezar de cero.

    private Map<String, Object> getDescuentos (String pOrderId, String pId) {
        System.debug('Entre a getDescuentos()');
        Map<String, Object> retorno = new Map<String, Object>();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        vlocity_cmt.PricingElementServiceImplementation  priceHandler = new vlocity_cmt.PricingElementServiceImplementation ();
        priceHandler.invokeMethod('getPriceDetail', input, outMap, null);

        if (outMap == null || outMap.isEmpty()) {
            throw new FunctionalException('Error al obtener los descuentos para la orden: ' + pOrderId + ' - ItemId: ' + pId + ', el servicio devolvio el mapa vacio');
        }

        vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);    
        List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;
        
        for(vlocity_cmt.JSONRecord record: pbeList){
        }

        return retorno;   
    }
    */

    /**
     * Funcion con la que obtengo los atributos de un producto dado.
     * ParamIn : pProduct2Id --> Id de producto.
     * ParamOut: Map<String, Object> que contiene los siguiente datos:
     * --> type, subType, family, cod de ofertas Huawei y condiciones de pago. 
     */
    private static Map<String, Object> getProduct2Attributes (String pProduct2Id) {
        printDebug('Entre a getProduct2Attributes()');
        Map<String, Object> retorno = new Map<String, Object>();
        List<String> lstCodOfertaRating = new List<String>();

        try {
            Product2 producto = [SELECT vlocity_cmt__Type__c, vlocity_cmt__SubType__c, Family, vlocity_cmt__JSONAttribute__c, ID_Sistema_Origen__c FROM Product2  WHERE Id = :pProduct2Id];
            if (producto != null) {
                if (producto.ID_Sistema_Origen__c != null) {
                    lstCodOfertaRating.add(producto.ID_Sistema_Origen__c);
                }
                List<String> jsonAttribute = getFormaPago (producto.vlocity_cmt__JSONAttribute__c);
                String shortCode = getShortCode(producto.vlocity_cmt__JSONAttribute__c);
                retorno.put('type', producto.vlocity_cmt__Type__c);
                retorno.put('subType', producto.vlocity_cmt__SubType__c);
                retorno.put('family', producto.Family);
                retorno.put('lstCodOfertaRating', lstCodOfertaRating); 
                retorno.put('lstCondicionPago', jsonAttribute); 
                retorno.put('alicuota', getAlicuota(producto.vlocity_cmt__JSONAttribute__c));
                retorno.put('shortCode', shortCode);
                retorno.put('esProvisionDirecta', getProvisionDirectaAttr(producto.vlocity_cmt__JSONAttribute__c));

                printDebug('ProductId: ' + pProduct2Id + ' - Shortcode: ' + shortCode);

                printDebug(producto.vlocity_cmt__JSONAttribute__c);
                return retorno;
            }
            else {
                printDebug('Error al obtener atributos para el productId: ' + pProduct2Id);
                throw new FunctionalException('Error al obtener atributos para el productId: ' + pProduct2Id);
            }
        }
        catch (Exception e) {
            printDebug('Error al obtener atributos para el productId: ' + pProduct2Id + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener atributos para el productId: ' + pProduct2Id + '. Error: ' + e.getMessage());
        }

    }
    

    /*
     * Esta funcion permite obtener de una estructura json ingresada como parametro
     * un atributo determinado, en este caso value__c dentro del tag FAN_ATTCAT_000045
     * devolviendo el valor contenido en value__c en una lista de string.
     * Tree:
     *        categorycode__c == FAN_ATTCAT_000045
     *              value__c --> valor a obtener.
     */
    private static List<String> getFormaPago (String pJsonAttribute) {
        printDebug('Entre a getFormaPago()');
        List<String> lstFormaPago = new List<String>();
        if (String.isBlank(pJsonAttribute)) {
            return lstFormaPago;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'FAN_ATTCAT_000045'){
                        valor = null;
                        printDebug('Encontre el tag: FAN_ATTCAT_000045');
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value__c')) {
                                printDebug('... campo: value__c');
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    eos = true;
                                    printDebug('... valor del campo value__c --> ' + valor);
                                    String [] aValor = valor.split('[;]');
                                    for (Integer i=0; aValor != null && i < aValor.size(); i++) {
                                        if (aValor[i] != null && aValor[i] != 'null') {
                                            lstFormaPago.add(aValor[i]);
                                        }
                                    }
                                }    
                            }    
                        }    
                    }
                }    
            }
        }
        return lstFormaPago;
    }


    private static String getShortCode (String pJsonAttribute) {
        printDebug('Entre a getShortCode()');
        String shortCode = null;
        if (String.isBlank(pJsonAttribute)) {
            return shortCode;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'FAN_ATTCAT_000042'){
                        valor = null;
                        printDebug('Encontre el tag: FAN_ATTCAT_000042');
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    if (valor != null && valor == 'FAN_ATT_000144'){
                                        valor = null;
                                        printDebug('Encontre el tag: FAN_ATT_000144');
                                        while (parser.nextToken() != null && !eos) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value__c')) {
                                                printDebug('... campo: value__c');
                                                if (parser.nextValue() != null) {
                                                    shortCode = parser.getText();
                                                    eos = true;
                                                    printDebug('... valor del campo value__c --> ' + shortCode);
                                                }    
                                            }    
                                        }    
                                    }
                                }
                            }
                        }                
                    }
                }    
            }
        }
        return shortCode;
    }


    /**
     * @Objetivo: Dado un jsonAttribute devuelve el valor del atributo Provision Directa.
     */
    private static String getProvisionDirectaAttr (String pJsonAttribute) {
        printDebug('Entre a getProvisionDirectaAttr()');
        String isProvisionDirecta = 'N';
        if (String.isBlank(pJsonAttribute)) {
            return isProvisionDirecta;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'FAN_ATTCAT_000042'){
                        valor = null;
                        printDebug('Encontre el tag: FAN_ATTCAT_000042');
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    if (valor != null && valor == 'FAN_ATT_000143'){
                                        valor = null;
                                        printDebug('Encontre el tag: FAN_ATT_000143');
                                        while (parser.nextToken() != null && !eos) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value__c')) {
                                                printDebug('... campo: value__c');
                                                if (parser.nextValue() != null) {
                                                    isProvisionDirecta = parser.getText();
                                                    eos = true;
                                                    printDebug('... valor del campo value__c --> ' + isProvisionDirecta);
                                                }    
                                            }    
                                        }    
                                    }
                                }
                            }
                        }                
                    }
                }    
            }
        }
        return (isProvisionDirecta.equalsIgnoreCase('true')?'S':'N');
    }


    /*
     * Esta funcion permite obtener de una estructura json ingresada como parametro
     * un atributo determinado en este caso la alicuota.
     */
    private static String getAlicuota (String pJsonAttribute) {
        printDebug('Entre a getAlicuota()');
        printDebug('pJsonAttribute --> ' + pJsonAttribute);

        String alicuota = '1';
        if (String.isBlank(pJsonAttribute)) {
            return alicuota;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'FAN_ATT_000139'){
                        valor = null;
                        printDebug('Encontre el tag: FAN_ATT_000139');
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'valueinnumber__c')) {
                                printDebug('... campo: valueinnumber__c');
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    eos = true;
                                    printDebug('... valor del campo valueinnumber__c' + valor);
                                    alicuota = valor;
                               }    
                            }    
                        }    
                    }
                }    
            }
        }
        printDebug('Alicuota --> ' + alicuota);
        return alicuota;
    }

    /*
     * Esta funcion permite obtener de una estructura json ingresada como parametro
     * un atributo determinado, en este caso value__c dentro del tag FAN_ATTCAT_000045
     * devolviendo el valor contenido en value__c en una lista de string.
     * Tree:
     *      categorycode__c == FAN_ATTCAT_000042
     *            valueinnumber__c --> valor a obtener.
     */
    private static List<String> getCodOfertaRating (String pJsonAttribute) {
        printDebug('Entre a getCodOfertaRating()');
        List<String> lstCodOfertaRating = new List<String>();
        if (String.isBlank(pJsonAttribute)) {
            return lstCodOfertaRating;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == 'FAN_ATTCAT_000042'){
                        valor = null;
                        printDebug('Encontre el tag: FAN_ATTCAT_000042');
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'valueinnumber__c')) {
                                printDebug('... campo: valueinnumber__c');
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    eos = true;
                                    printDebug('... valor del campo valueinnumber__c' + valor);
                                    lstCodOfertaRating.add(valor);
                                }    
                            }    
                        }    
                    }
                }    
            }
        }
        return lstCodOfertaRating;
    }

    private static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }

    private static void printMapa(String pNombre,Map<String, Object> pMapa) {
        System.debug('##Inicio Imprimir Mapa '+ pNombre);
        
        for (String keys : pMapa.keySet()) {
            System.debug('Key:' + keys + ' Valor: ' + pMapa.get(keys));
        }
        System.debug('##Fin Imprimir Mapa');
    }

    /**
     * Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }

    /**
     * Clase en donde serializo los parámetros de entrada
     * del servicio.
     */
    
    public class ResultObj {
        public Integer resultCode;
        public Blob resultMessage;

        public ResultObj(Integer code, Blob msg) {
            this.resultCode = code;
            this.resultMessage = msg;
        }
    }

    private class FromJSON {
        public String subTipo;
        public String tipo;
        public String codCanal; 
        public String codCortoOferta;
        public ChoiceClass choiceId;
        public String idCliente;
    }

    private class ChoiceClass {
        public String subscriberId;
        public String nroLinea;
    }

}