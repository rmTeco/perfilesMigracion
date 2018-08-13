/**
 * Este es un servicio rest que permite realizar un MACD de Numeros Amigos sobre una 
 * cuenta determinada. Dicho request viene desde un canal No crm. Canales habilitados: 
 * IVR, USSD.
 *
 * @Author: Alejandro Salord (Certa Consulting).
 * @Version: 
 * @see: 
 */
public with sharing class IFS_S454_changeFriendsAndFamily_cls {

    //-- Defaults --
    private static final boolean K_DEBUG_ON = true;               //-- Enable / Disable Class Debug Mode.
    private static final String  K_COD_MONEDA = 'ARS';            //-- No tengo claro si se obtiene, Huawei espera este codigo.
    private static final String  K_GESTION = 'Numero Gratis';     //-- Gestion.
    private static final String  K_TIPO_JOB = 'Job Request';      //-- Type of job in the CrossObject__c Table.
    private static final String  K_ORDER_TEMPLATE_NAME = 'Friends&Family Order Template'; //-- Template Name.
    private static DateTime fo = DateTime.now(); //-- Fecha de la orden.
    private static final Integer K_DECIMAL_PLACES = 4; //-- Cantidad de lugares decimales para el precio.

    public ResultObj changeFriendsAndFamily(String jsonInput) {
        printDebug('Entre a changeFriendsAndFamily()');
		ResultObj resultObject;
        FromJSON jsonBody;

        try {
            try {
                jsonBody = (FromJSON)JSON.deserialize(jsonInput, FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Error: ' + e.getMessage());
            } 
        
            Integer action = checkContrato (jsonBody); 

            resultObject = new ResultObj(200, JSON.serialize(procesar(jsonBody, action)));
            printDebug('Retorna: ' + resultObject);
            return resultObject;

        }
        catch (FunctionalException fe) {
        	resultObject = new ResultObj(417, JSON.serialize(getRespuestaNoOk('417',fe.getMessage())));
            printDebug('Retorna: ' + resultObject);
        	return resultObject;
        }
        catch (CalloutException ce) {
            resultObject = new ResultObj(400, JSON.serialize(getRespuestaNoOk('400',ce.getMessage())));
            printDebug('Retorna: ' + resultObject);
            return resultObject;
        }
        catch(Exception e){
        	resultObject = new ResultObj(500, JSON.serialize(getRespuestaNoOk('500',e.getMessage())));
            printDebug('Retorna: ' + resultObject);
            return resultObject;
        }
    }

    /**
     * @Objetivo: Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     * Retorna: 1: Solo Alta - 2: Solo Baja - 3: Alta y Baja.
     */
    private Integer checkContrato (FromJSON pJson) {
        printDebug('Entre a checkContrato()');

        if (pJson == null) {
            printDebug('El json vino vacio o nulo'); 
            throw new CalloutException('Error en la validacion de los atributos del request. Vino vacio.');
        }

        if (String.isBlank(pJson.choiceId.subscriberId) && String.isBlank(pJson.choiceId.nroLinea)) {
            printDebug('El subscriber y el nroLinea no vinieron o estan vacios, como es un choice alguno tiene que venir con valor'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El choice vino vacio y debe contener al menos uno de los dos datos [subscriberId o nroLinea]');
        }

        if (pJson.lstOfertas == null || pJson.lstOfertas.size()==0) {
            printDebug('Error en la validacion de los atributos del request. Lista de ofertas vacia o nula.'); 
            throw new CalloutException('Error en la validacion de los atributos del request.  Lista de ofertas vacia o nula.');
        }

        Integer lalta = 0; 
        Integer lbaja = 0;

        try {
            for (Integer i=0; i<pJson.lstOfertas.size(); i++) {
                OfertaClass o = pJson.lstOfertas.get(i);
                if (o == null) {
                    throw new CalloutException('Lista de Ofertas con componentes nulos.');
                }
                if (String.isBlank(o.codOperacion)) {
                    throw new CalloutException('Lista de Ofertas, hay componentes con codOperacion nulo o vacio');
                }
                if (!o.codOperacion.equals('A') && !o.codOperacion.equals('B')) {
                    throw new CalloutException('Lista de Ofertas, hay componentes con valor de codOperacion distinto de A=Alta o B=Baja');
                }
                else {
                    lalta = (o.codOperacion.equals('A') || lalta == 1 ? 1 : 0); //-- Este es un flag que indica si vienen altas, con lo cual is viene A o ya vino siempre es 1.
                    lbaja = (o.codOperacion.equals('B') || lbaja == 1 ? 1 : 0); //-- Este es un flag que indica si vienen bajas, con lo cual is viene B o ya vino siempre es 1.
                }

                if (String.isBlank(o.ofertaId)) {
                    throw new CalloutException('Lista de Ofertas, hay componentes con ofertaId nulo o vacio.');
                }
                if (o.lstLineas == null || o.lstLineas.size()==0) {
                    throw new CalloutException('Lista de Numeros en objeto Oferta vino nulo o vacio.');
                }
                //-- Valido lista de lineas.
                for (Integer j=0; j<o.lstLineas.size(); j++) {
                    LineaClass linea = o.lstLineas.get(j);
                    if (linea == null) {
                        throw new CalloutException('La lista de numeros contiene valores nulos.');                            
                    }
                    if (o.codOperacion.equals('B') && String.isBlank(linea.assetId)) {
                        throw new CalloutException('El assetId vino vacio o nulo y su valor se necesita porque la operacion es Baja.');                            
                    }
                    if (String.isBlank(linea.nroLinea)) {
                        throw new CalloutException('Vino un valor de numero de linea nulo o vacio.');                            
                    }
                    if (o.codOperacion.equals('A') && String.isBlank(linea.tipoLinea)) {
                        throw new CalloutException('Vino un valor de tipo de linea nulo o vacio y es necesario porque la operacion es Alta.');                            
                    }
                }
            }
            if (lalta == 0 && lbaja == 0) {
                printDebug('--- No se encontro operaciones de Alta o Baja en el Request.'); 
                throw new CalloutException('No se encontro operaciones de Alta o Baja en el Request.');
            }
            if (lalta == 1 && lbaja == 0) {
                return (Integer)1;
            }
            else if (lalta == 0 && lbaja == 1) {
                return (Integer)2;
            }
            else {
                return (Integer)3;
            }
        }
        catch (Exception e) {
            printDebug('Error en la validacion de los atributos del request. ' + e.getMessage()); 
            throw new CalloutException('Error en la validacion de los atributos del request. ' + e.getMessage());
        }
    }

    /*
     * Esta funcion procesa el requerimiento una vez validados sus atributos.
     */
    private ToJson procesar (FromJSON pJsonBody, Integer pAction) {  
        printDebug('metodo procesar() - pAction --> ' + pAction);
        printLimitAndUsedSize();
        Boolean isSubmit = false;
        Boolean hayBajas = false;
        ToJson toJson = new ToJson();
        String accountId = null;
        String planId = null;
        Map<String, Object> outMap = null;
        String resultado = null;

        List<OrderItem> lstOrderItemsTemplate = getOrderItemsTemplate ();

        Map<String, Object> datosMap = null;
        //-- Obtengo el accountId por subscriber o por msisdn
        if (!String.isBlank(pJsonBody.choiceId.subscriberId)) {
            datosMap = getAccountIdBySubscriptorId(pJsonBody.choiceId.subscriberId);
        }
        else {
            datosMap = getAccountIdByMSISDN(pJsonBody.choiceId.nroLinea);
        }

        printLimitAndUsedSize();

        if (datosMap == null || datosMap.isEmpty()) {
            throw new FunctionalException('No se pudo obtener el Account Id y el Id del Plan');
        } 

        accountId = (String)datosMap.get('accountId');
        planId = (String)datosMap.get('rootItemId');

        if (pAction == 2 || pAction == 3) {
            //-- Si hay baja deberia genero el cargo a cobrar y si no puedo, aborto en este punto.
            try {
                invokeIFS_S298 (pJsonBody);
            }
            catch (Exception e) {
                throw new FunctionalException('Fallo en la gestion de cargo por baja. - ' + e.getMessage());
            }
        }

        //-- Creo la orden draft para la cuenta obtenida.
        String orderId = createOrder(accountId, planId); 

        if (String.isBlank(orderId)) {
            printDebug(' --- Error al crear la orden.');
            throw new FunctionalException('Error al crear la orden.');
        }

        printLimitAndUsedSize();

        List<OrderItem> lstOrderItems = getOrdenItems(orderId);
        if (lstOrderItems == null || lstOrderItems.isEmpty()) {
            printDebug(' --- No se pudo obtener los items de la orden para procesarlos - OrderId --> ' + orderId);
            throw new FunctionalException('No se pudo obtener los items de la orden para procesarlos - OrderId --> ' + orderId);
        }

        if (pAction == 1) {   //-- Viene solo Alta.
            procesarAltas (orderId, Id.valueOf(accountId), pJsonBody, lstOrderItems, lstOrderItemsTemplate, false);
            isSubmit = true;
        }
        else if (pAction == 2) {   //-- Viene solo baja.
            procesarBajas (orderId, pJsonBody, lstOrderItems);
            isSubmit = true;
        }
        else {  //-- Viene Altas y Bajas.
            printDebug('--- Vinieron Altas y Bajas');
            procesarBajas (orderId, pJsonBody, lstOrderItems);
            procesarAltas (orderId, Id.valueOf(accountId), pJsonBody, lstOrderItems, lstOrderItemsTemplate, true);
            isSubmit = true;
        } 

        printLimitAndUsedSize();

        if (isSubmit) { 
            insertJob (orderId, Id.valueOf(accountId));
        }
        toJson.codResultado = '0';
        toJson.descResultado = 'OK';
        return toJson;
    }


    /**
     * @Objetivo: Procesa las altas definidas en el request.
     */
    private void procesarAltas (Id pOrderId, Id pAccountId, FromJson pJsonBody, List<OrderItem> pLstOrderItems, List<OrderItem> pLstOrderItemsTemplate, Boolean pHayBajas) {
        printDebug('----- procesarAltas() - pOrderId --> ' + pOrderId + ' - pJsonBody --> ' + pJsonBody + ' - pLstOrderItems --> ' + pLstOrderItems + ' - pHayBajas --> ' + pHayBajas);
        String rootNumerosAmigosId = null;
        List<OrderItem> lstOrderItemsToBeInserted = new List<OrderItem>();
        for (Integer i=0; pJsonBody != null && i<pJsonBody.lstOfertas.size(); i++) {   //-- Recorro las ofertas.
            printDebug('-------- Obtengo lista de ofertas del request.');
            OfertaClass oferta = pJsonBody.lstOfertas.get(i);
            rootNumerosAmigosId = oferta.ofertaId;
            if (oferta.codOperacion != 'A') {
                continue; //-- Solo proceso Altas.
            }
    
            Asset asset = getAssetByAssetReferenceId (rootNumerosAmigosId);
            OrderItem oiNew = null;
            if (asset != null && asset.SubTipo_de_Producto__c != null) {
                oiNew = getOrderItemBySubType(asset.SubTipo_de_Producto__c, pLstOrderItemsTemplate);
            }
            if (oiNew == null) {
                throw new FunctionalException('No se pudo generar el OrderItem a insertar.');
            }
            printDebug('--------- Obtengo lista de lineas a dar de alta del request.');
            List<LineaClass> lstLineas = oferta.lstLineas;
            for (Integer a=0; lstLineas != null && a < lstLineas.size(); a++) {  //-- Recorro las lineas de la oferta.
                LineaClass linea = lstLineas.get(a);
                oiNew = getOrderItemRecord (oiNew.Id);
                OrderItem oiClone = oiNew.clone(false, false, false, false);
                String jsonAtt = oiClone.vlocity_cmt__JSONAttribute__c;
                oiClone.vlocity_cmt__JSONAttribute__c = updateItemsAttributes (jsonAtt, linea.nroLinea, linea.tipoLinea);
                oiClone.OrderId = pOrderId;
                oiClone.vlocity_cmt__Action__c = 'Add';
                oiClone.vlocity_cmt__ProvisioningStatus__c = 'New';
                OrderItem parentOrderItem = getNewOrderItems (pOrderId, asset.SubTipo_de_Producto__c);
                Integer childNumber = getChildremQuantity (parentOrderItem);
                oiClone.vlocity_cmt__LineNumber__c = getNewLineNumber(parentOrderItem.vlocity_cmt__LineNumber__c, childNumber);
                oiClone.vlocity_cmt__BillingAccountId__c = pAccountId;
                oiClone.vlocity_cmt__ServiceAccountId__c = pAccountId;
                lstOrderItemsToBeInserted.add(oiClone);
            }    
        }
        if (lstOrderItemsToBeInserted != null && !lstOrderItemsToBeInserted.isEmpty()) {
            insert lstOrderItemsToBeInserted; //-- Inserto los orderItems en la base.
        }
    }

    /**
     * @Procesa las bajas definidas en el request.
     */
    private void procesarBajas (Id pOrderId, FromJson pJsonBody, List<OrderItem> pLstOrderItems) {
        printDebug('--- procesarBajas()');
        for (Integer i=0; i<pJsonBody.lstOfertas.size(); i++) {
            OfertaClass oferta = pJsonBody.lstOfertas.get(i);
            if (oferta.codOperacion != 'B') {
                continue; //-- Solo proceso Bajas.
            }
            List<LineaClass> lstLineas = oferta.lstLineas;
            for (Integer a=0; lstLineas != null && a < lstLineas.size(); a++) {
                Map<String, Object> item = new Map<String, Object>();
                String assetId = String.valueOf(lstLineas[a].assetId);
                OrderItem oi = getOrderItemByAssetReferenceId(pLstOrderItems, assetId);
                if (oi == null) {
                    throw new FunctionalException('No posee Numeros Amigos para dar de Baja.');
                }
                else {
                    delOrderItem(pOrderId, oi.Id);
                }
            }    
        }    
    }

    /**
     * @Objetivo: Obtiene un item de una orden y lo marca como borrado.
     */
    private void delOrderItem(Id pOrderId, Id pItemId) {
        printDebug('Entre a delOrderItem() - pOrderId --> ' + pOrderId + ' - pItemId --> ' + pItemId);
        printLimitAndUsedSize();

        try {
            OrderItem orderItem = [SELECT Id, vlocity_cmt__Action__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__DisconnectDate__c FROM OrderItem WHERE Id = :pItemId AND orderId = :pOrderId];
            if (orderItem != null) {
                orderItem.vlocity_cmt__Action__c = 'Disconnect';
                orderItem.vlocity_cmt__ProvisioningStatus__c = 'Deleted';
                orderItem.vlocity_cmt__DisconnectDate__c = fo;  //-- Asigno la fecha de la orden.
                update orderItem;
            }
            else {
                throw new FunctionalException('Fallo al obtener el itemId --> ' + pItemId + ' de la orden draft --> ' + pOrderId + ' para setear los codigos de baja.');
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al eliminar item. Error: ' + e.getMessage());
        }
        printLimitAndUsedSize();
    }


    /**
     * @Objectivo: Obtener los Items de una orden.
     */
    private OrderItem getNewOrderItems (String pOrderId, String pSubType) {
        try {
            printDebug('Entre en getOrdersItems() - pOrderId --> ' + pOrderId + ' - pProductCode --> ' + pSubType);

            String productCode = 'FAN_PV_GFNF_VOZ';
            if (pSubType.equalsIgnoreCase('SMS')) {
                productCode = 'FAN_PV_GFNF_SMS';
            }

            printDebug('- ProductCode --> ' + productCode);

            return [SELECT id, vlocity_cmt__LineNumber__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c 
                    FROM OrderItem WHERE orderId = :pOrderId AND ProductCode__c = :productCode ORDER BY vlocity_cmt__LineNumber__c LIMIT 1];
        }
        catch (Exception e) {
            printDebug('---- ' + e.getMessage());
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Obtener la cantidad de ordenitem de un parent dado.
     */
    private Integer getChildremQuantity (OrderItem pParentOrderItem) {
        printDebug('Entre en getChildremQuantity');
        String query = 'SELECT count() FROM OrderItem WHERE vlocity_cmt__ParentItemId__c = \'' + pParentOrderItem + '\'';
        Integer childremCount = Database.countQuery(query);
        printDebug('---- childremCount --> ' + childremCount);
        if (childremCount == 0) {
            return 1;
        }
        else {
            return childremCount+1;
        }
    }

    /**
     * @Objetivo: A partir de un linenumber padre obtener el linenumber del hijo.
     */
    private String getNewLineNumber(String pParentLineNumber, Integer pChildNumber) {
        try {
            printDebug('Entre en getNewLineNumber() - pParentLineNumber --> ' + pParentLineNumber + ' - ' + pChildNumber);
            String newLevelStr = '0000' + pChildNumber;

            String [] levels = pParentLineNumber.split('\\.');
            Integer qLevels = levels.size();
            if (qLevels==3) {  
                String lLevel = levels[0] + '.' + levels[1] + '.' + levels[2] + '.' + newLevelStr.right(4); 
                return lLevel;
            }
            else {
                throw new FunctionalException('Fallo al determinar el LineNumber del OrderItem a Insertar.');
            }
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Devuelve un json actualizado con los datos de nroLinea y tipoLinea.
     */
    private String updateItemsAttributes (String pJsonAttribute, String pNroLinea, String pTipoLinea) {
        printDebug('Entre a updateItemsAttributes()');
        Map<String, Object> outMap = null;

        try {
            if (String.isBlank(pJsonAttribute)) {
                printDebug(' --- El JsonAttribute a actualizar vino vacio.');
                throw new FunctionalException('El JsonAttribute a actualizar vino vacio.');
            }

            Map<String, Object> jsonAttributes = (Map<String, Object>)JSON.deserializeUntyped(pJsonAttribute);
            if (jsonAttributes != null && !jsonAttributes.isEmpty()) {
                Set<String> attributesKeys = jsonAttributes.keySet();
                for(String attributeKey : attributesKeys){
                    List<Object> attributes = (List<Object>)jsonAttributes.get(attributeKey);
                    for(Object attribute : attributes){
                        Map<String, Object> mapAttribute = (Map<String, Object>) attribute;
                        String categoria = (String)mapAttribute.get('categorycode__c');
                        if (!String.isBlank(categoria) && categoria == 'FAN_ATTCAT_000047') {
                            printDebug('---- Encontre FAN_ATTCAT_000047');
                            String unicode = (String)mapAttribute.get('attributeuniquecode__c');
                            if (!String.isBlank(unicode) && unicode == 'FAN_ATT_000057') {
                                printDebug('---- ----- Encontre FAN_ATT_000057');
                                Map<String, Object> mapAttributeRunTimeInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                                if (mapAttributeRunTimeInfo != null) {
                                    mapAttributeRunTimeInfo.put('value', pNroLinea);
                                }
                            }
                            else if (!String.isBlank(unicode) && unicode == 'FAN_ATT_000129') {
                                printDebug('---- ----- Encontre FAN_ATT_000129');
                                Map<String, Object> mapAttributeRunTimeInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                                List<Object> lstTiposValues = (List<Object>)mapAttributeRunTimeInfo.get('values');
                                String tipo = pTipoLinea;
                                printDebug('----- Voy a buscar el tipo: ' + tipo);
                                Boolean encontre = false;
                                Map<String, Object> desconocidoValue = null;
                                for (Object tipoValue : lstTiposValues) {
                                    Map<String, Object> mapValue = (Map<String, Object>)tipoValue;
                                    String ltipo = (String)mapValue.get('value');
                                    if (!String.isBlank(ltipo) && ltipo.equalsIgnoreCase(tipo)) {
                                        mapAttributeRunTimeInfo.put('selectedItem', tipoValue);
                                        encontre = true;
                                        break;
                                    }
                                    else if (!String.isBlank(ltipo) && ltipo.equalsIgnoreCase('Desconocido')) {
                                        desconocidoValue = mapValue;
                                    }    
                                }
                                if (!encontre) {
                                    printDebug('No encontre valor asigno desconocido');
                                    mapAttributeRunTimeInfo.put('selectedItem', desconocidoValue);     
                                }
                            }
                        }        
                    }
                }    
            }

            return JSON.serialize(jsonAttributes);
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            printDebug('===========================================================================');
            printDebug(stackTrace);
            printDebug('===========================================================================');
            throw new FunctionalException('Error al actualizar los items de la orden. Error: ' + e.getMessage());
        }

    }


    /**
     * @Objetivo: Esta funcion obtiene el rootItemId del Asset buscandolo por subscritorId.
     */
    private Map<String, Object> getAccountIdBySubscriptorId (String pSubscritorId) {
        printDebug('Entre a getAccountIdBySubscriptorId()');
        String accountId = null;
        
        if (String.isBlank(pSubscritorId)) {
            printDebug(' ---- El pSubscritorId vino vacio');
            throw new CalloutException('El pSubscritorId vino vacio');
        }

        try {
            Asset asset = [SELECT AccountId, vlocity_cmt__RootItemId__c FROM Asset WHERE Subscription_Id__c = :pSubscritorId];
            if (asset != null) {
                Map<String, Object> respuesta = new Map<String, Object>();
                respuesta.put('accountId', asset.AccountId);
                respuesta.put('rootItemId', asset.vlocity_cmt__RootItemId__c);
                return respuesta;
            }
            else {
                throw new FunctionalException('Error al obtener el AccountId del SubscriptionId: ' + pSubscritorId);
            }
        }
        catch (Exception e) {
            printDebug(' ---- Error al obtener el AccountId del subscriptionId: ' + pSubscritorId + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener el AccountId del subscriptionId: ' + pSubscritorId + '. Error: ' + e.getMessage());
        }    
    }

    /**
     * @Objetivo: Esta funcion obtiene el rootItemId del Asset buscandolo por MSISDN.
     */
    private Map<String, Object> getAccountIdByMSISDN (String pNroLinea) {
        printDebug('Entre a getAccountIdByMSISDN()');

        if (String.isBlank(pNroLinea)) {
            printDebug(' ---- El pNroLinea vino vacio');
            throw new CalloutException('El pNroLinea vino vacio');
        }
        
        try {
            Asset asset = [SELECT AccountId, vlocity_cmt__RootItemId__c FROM Asset WHERE MSISDN__c = :pNroLinea];
            if (asset != null) {
                Map<String, Object> respuesta = new Map<String, Object>();
                respuesta.put('accountId', asset.AccountId);
                respuesta.put('rootItemId', asset.vlocity_cmt__RootItemId__c);
                return respuesta;
            }
            else {
                throw new FunctionalException('Error al obtener el AccountId del MSISDN: ' + pNroLinea);
            }
        }
        catch (Exception e) {
            printDebug(' --- Error al obtener el AccountId del MSISDN: ' + pNroLinea + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener el AccountId del MSISDN: ' + pNroLinea + '. Error: ' + e.getMessage());
        }    
    }


    /**
     * @Objetivo: Esta funcion obtiene un Asset by AssetId.
     */
    private Asset getAssetByAssetReferenceId (String pAssetReferenceId) {
        printDebug('Entre a getAssetByAssetReferenceId() - pAssetReferenceId --> ' + pAssetReferenceId);
        String accountId = null;

        if (String.isBlank(pAssetReferenceId)) {
            return null;
        }
        
        try {
            Asset asset = [SELECT vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c, SubTipo_de_Producto__c FROM Asset where vlocity_cmt__AssetReferenceId__c = :pAssetReferenceId];
            System.debug(asset);
            return asset;
        }
        catch (Exception e) {
            printDebug(' --- Error al obtener el Asset Hijo del AssetReferenceId: ' + pAssetReferenceId + '. Error: ' + e.getMessage());
            throw new FunctionalException('Error al obtener el Asset Hijo del AssetReferenceId: ' + pAssetReferenceId + '. Error: ' + e.getMessage());
        }    
    }


    /**
     * @Objetivo: funcion que crea una orden invocando la API --> assetToOrder.
     */
    private String createOrder (String pAccountId, String pPlanId) {
        printDebug('Entre a createOrder(assetToOrder)');
        try {
            String orderId = null;
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('methodName', 'assetToOrder');
            mapa.put('subaction', 'assetToOrder');
            mapa.put('accountId', pAccountId);
            mapa.put('requestDate', fo.format('yyyy-MM-dd'));  
            mapa.put('id',pPlanId);

            printDebug('..... Crear orden - Inicio  ');
            printDebug('mapa --> ' + mapa);

            Map<String, Object> outMap = new Map<String, Object>();
            vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
            appHandler.invokeMethod((String)mapa.get('methodName'), mapa, outMap, null);
                
            printDebug('..... Crear orden - Despues de invocar el servicio ');    
            if (outMap == null || outMap.isEmpty()) {
                throw new FunctionalException('Error al crear la orden, el servicio devolvio el mapa vacio');
            }

            printDebug('outMap --> ' + outMap);

            printDebug('..... Crear orden - Antes de empezar a recorrer el pbe list ');    
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);  
            List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;
            for(vlocity_cmt.JSONRecord record: pbeList){
                orderId = (String)record.fields.get('cartId');
            }
            
            if (String.isBlank(orderId)) {
                List<vlocity_cmt.JSONMessage> messageList = (List<vlocity_cmt.JSONMessage>)result.messages;
                String code = null;
                String message = null;
                for(vlocity_cmt.JSONMessage messageRecord: messageList){
                    code = messageRecord.code;
                    message = messageRecord.message;
                }
                if (!String.isBlank(code) && !String.isBlank(message)){
                    throw new FunctionalException(message + ' - [' + code + ']');
                }
            }
            else {
                Order order = [SELECT Id, Gestion__c FROM Order WHERE Id = :orderId];
                if (order != null) {
                    order.Gestion__c = K_GESTION;
                    order.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MobilePhoneOrder').getRecordTypeId();
                    update order;
                }
            }
            return orderId;
        } 
        catch (Exception e) {
            printDebug('............ createOrder - \n' + e.getStackTraceString());
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objectivo: Obtener todos los items de una orden creada.
     */
    private List<OrderItem> getOrdenItems (Id pOrderId) {
        printDebug('---- getOrdenItems() - pOrderId --> ' + pOrderId);
        try {
            List<OrderItem> lstOrderItem = [SELECT Id, vlocity_cmt__ParentItemId__c, PricebookEntryId, vlocity_cmt__AssetReferenceId__c, vlocity_cmt__Action__c, ProductCode__c, vlocity_cmt__SubAction__c, vlocity_cmt__JSONAttribute__c,  vlocity_cmt__ProvisioningStatus__c FROM OrderItem WHERE orderId = :pOrderId ];
            return lstOrderItem;
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Recibe una lista de OrderItems y devuelve el que contiene el pAssetId
     */
    private OrderItem getOrderItemByAssetReferenceId (List<OrderItem> pLstOrderItems, String pAssetId) {
        printDebug('---- getOrderItemByAssetReferenceId() - pLstOrderItems --> ' + pLstOrderItems + ' - pAssetId --> ' + pAssetId);
        if (pAssetId == null) {
            return null; //-- Puede venir en nulo.
        }
        for (Integer i=0; i < pLstOrderItems.size(); i++) {
            if (pLstOrderItems[i].vlocity_cmt__AssetReferenceId__c == pAssetId) {
                return pLstOrderItems[i];
            }
        }
        return null;
    }

    /**
     * @Objetivo: Obtener los orderItems de la orden Template.
     */
    private List<OrderItem> getOrderItemsTemplate () {
        try {
            List<OrderItem> lstOrderItems = [SELECT id, ProductCode__c, vlocity_cmt__JSONAttribute__c, Product2.vlocity_cmt__SubType__c, vlocity_cmt__LineNumber__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c 
            FROM OrderItem WHERE order.Name = :K_ORDER_TEMPLATE_NAME AND ProductCode__c LIKE 'FAN_PV_FNF_0000%' ORDER BY vlocity_cmt__LineNumber__c]; 

            if (lstOrderItems.isEmpty()) {
                throw new FunctionalException('No se recuperaron items de la orden template.');
            }
            if (lstOrderItems.size()<1) {
                throw new FunctionalException('No se recuperaron los items de la orden template para numeros amigos voz y sms.');
            }
            return lstOrderItems;
        }
        catch (Exception e) {
            printDebug('Problemas de configuracion. No se encontro la Orden Template. Error: ' + e.getMessage());
            throw new FunctionalException('Problemas de configuracion. No se encontro la Orden Template.');
        }    
    }

    /**
     * @Objetivo: Metodo que busca y devuelve el OrderItem correspondiente al SubType pasado
     *            de la lista de OrderITems Template.
     */
    private OrderItem getOrderItemBySubType(String pSubType, List<OrderItem> pLstItems) {
        printDebug('Entre en getOrderItemBySubType() - pSubType --> ' + pSubType + ' - pLstItems --> ' + pLstItems);
        for (Integer i=0; pLstItems != null && i < pLstItems.size(); i++) {
            OrderItem oi = pLstItems.get(i);
            printDebug(String.valueOf(oi));
            if (oi != null && oi.Product2.vlocity_cmt__SubType__c != null && oi.Product2.vlocity_cmt__SubType__c.equalsIgnoreCase(pSubType)) {
                return oi;
            }
        }
        throw new FunctionalException('No se encontro el OrdenItem en el Template para el subType ' + pSubType);
    }

    /**
     * @Objetivo: Obtengo el registro completo de un OrderItem.
     *            con esto evito tener que armar un query con todos los campos de un OrderItem.
     */
    private OrderItem getOrderItemRecord (Id pOrderItemId) {
        printDebug('Entre en getOrderItemRecord()');
        ID recordId = pOrderItemId;
        DescribeSObjectResult describeResult = recordId.getSObjectType().getDescribe();	
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );	
        String query =	  ' SELECT '  +	      
                        String.join( fieldNames, ',' )  +	  
                        ' FROM ' +	      
                        describeResult.getName() +	  
                        ' WHERE '  +	      
                        ' id = \'' + recordId + '\' LIMIT 1 '	;	
        List<SObject> records = Database.query( query );
        printDebug('Registro completo --> ' + records);
        return (OrderItem) records[0];    
    }

    /**
     * @Objetivo: Inserta en la tabla Crossobject__c para ser tomado
     *            por job batch para submitir la orden.
     */
    private static void insertJob (Id pOrderId, Id pAccountId) {
        try {
            Crossobject__c co = new Crossobject__c();
            co.order__c = pOrderId;
            co.CrossObjectName__c = K_TIPO_JOB + ' ' + pOrderId;
            co.Status__c = 'Pendiente';
            co.DateTime1__c = DateTime.now();
            co.Account__c = pAccountId;
            co.String1__c = 'F&F - Canal: Externo - Orden Id: ' + pOrderId;
            co.RecordTypeId = Schema.SObjectType.Crossobject__c.getRecordTypeInfosByName().get('External Channel').getRecordTypeId();
            insert co;
        }
        catch (Exception e) {
            throw new FunctionalException('Error al insertar el request batch. - ' + e.getMessage());
        }
    }

    /**
     * @Objetivo: Dado una estructra json attribute devuelve el value__c de un objeto identificado por
     *            el categoryCode y el attributeUnicCode.
     */
    private String getJSONValue (String pJsonAttribute, String pCategoryCode, String pAttributeUnicCode) {
        printDebug('Entre a getJSONValue');
        String retValue = null;
        if (String.isBlank(pJsonAttribute)) {
            throw new FunctionalException('Error al parsear jsonAttribute');
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == pCategoryCode){
                        valor = null;
                        System.debug('Encontre el tag: ' + pCategoryCode);
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    if (valor != null && valor == pAttributeUnicCode){
                                        valor = null;
                                        System.debug('Encontre el tag: ' + pAttributeUnicCode);
                                        while (parser.nextToken() != null && !eos) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'value__c')) {
                                                System.debug('... campo: value__c');
                                                if (parser.nextValue() != null) {
                                                    retValue = parser.getText();
                                                    eos = true;
                                                    System.debug('... valor del campo value__c --> ' + retValue);
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
        return retValue;
    }


    /**
     * @Objetivo: Arma la estructura de respuesta No Ok.
     */
    private List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        printDebug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

    /**
     * @Objetivo: Invocar la integracion S298 a Huawei para generar un cargo por baja de numero amigo.
     */
    private void invokeIFS_S298 (FromJSON pJsonBody) {
        printDebug('Entre en invokeIFS_S298');
        try {
            Map<String, Object> body = new Map<String, Object>();
            Map<String, Object> codAccesoCuenta = new Map<String, Object>();
            Map<String, Object> identificador = new Map<String, Object>();
            Map<String, Object> codCargo = new Map<String, Object>();
            Map<String, Object> objDeduccion = new Map<String, Object>(); 
            List<Map<String, Object>> lstInfoDeducTarifas = new List<Map<String, Object>>(); 

            if (!String.isBlank(pJsonBody.choiceId.nroLinea)) {
                identificador.put('identificadorRecurso', pJsonBody.choiceId.nroLinea);
            }
            else {
                identificador.put('codSuscripcion', pJsonBody.choiceId.subscriberId);
            }
            objDeduccion.put('codAccesoSuscriptor', identificador);
            body.put('objDeduccion', objDeduccion);
            body.put('infoDeducTarifas', lstInfoDeducTarifas);

            Product2 prod = [SELECT Id, Name, vlocity_cmt__JSONAttribute__c FROM Product2 WHERE ProductCode = 'FAN_PSERV_00007' LIMIT 1];
            PriceBookEntry priceBook = [SELECT UnitPrice FROM PricebookEntry WHERE ProductCode = 'FAN_PSERV_00007' AND IsActive = true LIMIT 1];
            String codCargoValue = getJSONValue (prod.vlocity_cmt__JSONAttribute__c, 'FAN_ATTCAT_000042', 'FAN_ATT_000084');
            codCargo.put('codCargo', codCargoValue);

            for (Integer i=0; i<pJsonBody.lstOfertas.size(); i++) {
                OfertaClass oferta = pJsonBody.lstOfertas.get(i);
                if (oferta.codOperacion != 'B') {
                    continue; //-- codOperacion != 'B' skip.
                }
                Map<String, Object> infoDeducTarifasMap = new Map<String, Object>();
                infoDeducTarifasMap.put('secuenciaProductoAdquirido', String.valueOf(i+1));
                infoDeducTarifasMap.put('codCargo', codCargoValue);
                DateTime fo = DateTime.now();
                infoDeducTarifasMap.put('fechaVenta', fo.format('yyyy-MM-dd hh:mm:ss'));
                infoDeducTarifasMap.put('precioCargo', formatPlaces(priceBook.UnitPrice, K_DECIMAL_PLACES));
                infoDeducTarifasMap.put('codMoneda', K_COD_MONEDA);
                lstInfoDeducTarifas.add(infoDeducTarifasMap);
            }

            if (!Test.isRunningTest()) {
                printDebug(JSON.serialize(body));
                callIntegrationProcedure ('IFS_S298', body);
            }
        }
        catch (Exception e) {
            throw e;
        }
    }

    /**
     * @Objetivo: Realiza el llamado al Integration Procedure.
     */
    private void callIntegrationProcedure (String pServiceName, Map<String, Object> pBodyMap) {
        printDebug('Entre en callIntegrationProcedure()');
        try {
            Map<String,Object> inMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> optMap = new Map<String,Object>();

            inMap.put('body', pBodyMap);
            printDebug('inMap --> ' + JSON.serialize(inMap));
            vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
            
            if (integProcService == null) {
                throw new FunctionalException('Fallo al instanciar el servicio de integracion: IntegrationProcedureService');
            }

            integProcService.invokeMethod(pServiceName, inMap, outMap, optMap);
            try {
                Map<String, Object> response = (Map<String, Object>)outMap.get('IPResult');
                printDebug('IPResult (Map<String, Object>) --> ' + response);
                if (response.containsKey('codigo')) {
                    throw new CalloutException((String)response.get('codigo') + ' - ' + (String)response.get('mensaje'));
                }
            }
            catch (CalloutException ce) {
                throw ce;
            } 
            catch (TypeException te) {
                Object response = (Object)outMap.get('IPResult');
                printDebug('IPResult (String) --> ' + response);
                throw new CalloutException(te.getMessage());
            }
            catch (Exception e) {
                throw e;
            }
        }
        catch (Exception e) {
            printDebug('Error al invocar el integration procedure ' + pServiceName + ' - Error: ' + e.getMessage());
            printDebug(e.getStackTraceString());
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * @Objetivo: Muestra el conusmo de heap size y DML + el limite.
     */
    private static void printLimitAndUsedSize() {
        printDebug('Heap Size --> ' + Limits.getHeapSize());
        printDebug('Queries --> ' + Limits.getQueries() + ' - Limit -->  ' + Limits.getLimitQueries());
    }

    /**
     * @Objetivo: Wrapper del System.debug que permite 
     *            setearle si imprime o no.
     */
    private static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
    }

    //-- Clases para soportar el request --//
    private class FromJson {
        public ChoiceClass choiceId;
        List<OfertaClass> lstOfertas;
    }

    private class ChoiceClass {
        public String subscriberId;
        public String nroLinea;
    }

    private class OfertaClass {
        public String codOperacion;
        public String ofertaId;
        List<LineaClass> lstLineas;
    }

    private class LineaClass {
        public String assetId;
        public String priceBookEntryId;
        public String nroLinea;
        public String tipoLinea;
    }

    //-- Clase para soportar el response --//

    private class ToJson {
        public String codResultado;
        public String descResultado;
    }

    public class ResultObj {
		public Integer resultCode;
		public String resultMessage;

		public ResultObj(Integer code, String msg) {
			this.resultCode = code;
			this.resultMessage = msg;
		}
	}

    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }

    ///-- Funciones de Libreria --//
    public static String formatPlaces(decimal dec, integer places) {
        String formatedString = dec.setScale(places).ToPlainString(); 
        return formatedString;
    }
   

}