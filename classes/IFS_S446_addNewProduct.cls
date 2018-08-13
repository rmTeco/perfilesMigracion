/**
 * Este es un servicio rest que permite dar de alta un pack via
 * canal "No CRM" - Canales: IVR, USSD, SMS. Para ello debe existir
 * un catalogo definido para ese canal.
 *
 * Nota: 
 * Para obtener el plan que me va a permitir crear la orden via el metodo assetToOrder
 * obtengo del campo Description (de la orden draft que me viene informada en el request.) 
 * el dato de MSISDN o subscriptionId.
 * Esta informacion fue guardada por la clase IFS_S445_getAvailableOffers_cls.cls
 * en el metodo: createOrder. Esto es necesario para no modificar el contrato (IDD)
 * cuando me invocan el dato que me pasan es el orderId creado en el servicio y de ahi
 * solo puedo sacar el AccountId, pero no el plan. Por eso esa informacion me queda disponible
 * en el campo Description de la orden.
 *
 * @Author: Alejandro Salord (Certa Consulting).
 * @Version: 
 * @see: 
 */
@RestResource(urlMapping='/v1/integrationprocedure/Sales_addNewProduct/*')
global with sharing class IFS_S446_addNewProduct {
    private static final boolean K_DEBUG_ON = true;
    private static String guId = null;

    private static final String K_GESTION = 'Compra de Pack';     //-- Gestion.
    private static final String K_TIPO_JOB = 'Job Request';
    private static final String K_ORDER_TEMPLATE_NAME = 'Pack IVR Order Template';
    private static final List<String> K_LISTA_CANALES = new List<String>{'IVR', 'USSD', 'SMS'};

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        FromJSON jsonBody;
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');
        
        writeLog ('REQ', req.requestBody.toString());

        try {
            res.statuscode = 200;
            try {
                jsonBody = new FromJSON();
                jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(), FromJSON.class);
            }
            catch (Exception e) {
                throw new CalloutException('Error al deserializar los parametros. Error: ' + e.getMessage());
            }    
            
            checkContrato (jsonBody); //-- Verifico que el contrato (IFS) se cumpla.

            procesar (jsonBody);  //-- Proceso el request.

            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaOk()));
        }
        catch (FunctionalException fe) {
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',fe.getMessage())));
        }
        catch (CalloutException ce) {
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('400',ce.getMessage())));
        }
        catch(Exception e){
            res.statuscode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('500',e.getMessage())));
        }
            
        writeLog ('RES', res.statuscode + ';' + EncodingUtil.base64Decode(EncodingUtil.base64Encode(res.responseBody)).toString());
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S446', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S446', pTipo, guId, '', pDatos);  
        }
    }

    /**
     * Funcion que devuelve respuesta Ok en el formato definido en el contrato (IDD).
     */
    private static Map<String, String> getRespuestaOk() {
        printDebug('Entre a getRespuestaOk()');
        Map<String, String> mapa = new Map<String, String>();
        return mapa;   
    }

    /**
     * Funcion que devuelve respuesta NO Ok en el formato definido en el contrato (IDD).
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
     * Verificar que se cumpla el contrato.
     * Si lo cumple termina y sino dispara la excepción: CalloutException.
     */
    private static void checkContrato (FromJSON pJson) {
        printDebug('Entre a checkContrato()');

        if (pJson == null) {
            printDebug('El json vino vacio o nulo'); 
            throw new CalloutException('Error en la validacion de los atributos del request. Vino vacio.');
        }

        String orderId  = pJson.orderId;
        String codCanal = pJson.codCanal;
        List<OfertaClass> lstOferta = pJson.lstOferta;

        if (String.isBlank(orderId)) {
            printDebug('El orderId no vino o esta vacio'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El orderId no vino o esta vacio');
        }

        if (String.isBlank(codCanal)) {
            printDebug('Canal nulo o vacio '); 
            throw new CalloutException('Error en la validacion de los atributos del request. El canal vino vacio');
        }

        if (!K_LISTA_CANALES.contains(codCanal)) {
            printDebug('canal no valido: ' + codCanal); 
            throw new CalloutException('Error en la validacion de los atributos del request. El canal debe contener algun valor de la lista: ' + K_LISTA_CANALES );
        }

        if (lstOferta == null || lstOferta.size()==0) {
            printDebug('La lista de ofertas seleccionadas vino nula o vacia'); 
            throw new CalloutException('La lista de ofertas seleccionadas vino nula o vacia');
        }
    }


    /**
     * Secuencia principal.
     */
    private static void procesar (FromJSON pJsonBody) {
        printDebug('Entre en proceso - pJsonBody --> ' + pJsonBody);

        try {
            String trackingNumber = pJsonBody.preFactura;
            Map<String, Object> datos = getAccountId(pJsonBody.orderId);
            String orderId = createOrder ((String)datos.get('accountId'),(String) datos.get('planId'), trackingNumber); //-- Creo la orden.
            List<OrderItem> lstTemplateOrderItems = getOrderItemsTemplate ();  //-- Obtengo los items del template.
            List<OfertaClass> lstOfertas = pJsonBody.lstOferta;    //-- Obtengo la lista de ofertas seleccionadas en el canal.
            for (Integer i=0; i<lstOfertas.size(); i++) { //-- Recorro las ofertas seleccionadas en el canal.
                try {
                    OfertaClass oferta = lstOfertas.get(i); //-- Obtengo la oferta de la lista.
                    printDebug('Procesando Oferta --> [ ' + i + ' ] - ' + oferta.idListaPrecio);
                    List<OrderItem> lstOfferStructure = getOfferStructure(oferta.idListaPrecio, lstTemplateOrderItems); //-- Obtengo del template la estructura de la oferta (Todos los items que la compone).
                    procesarOrden(lstOfferStructure, orderId, (String)datos.get('accountId')); //-- Proceso la orden creada.
                }
                catch (Exception e) {
                    printDebug(e.getMessage());
                }
            }
            insertJob (orderId, (String)datos.get('accountId'));
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }
    }


    /**
     * El objetivo de este metodo es procesar los items recibidos: asignarles la cuenta, rootitemid, etc e insertarlos en la lista de items.
     */
    private static void procesarOrden (List<OrderItem> pLstOfferStrucgture, String pOrderId, String pAccountId) {
        printDebug('Entre en procesarOrden - pOrderId --> ' + pOrderId);
        try {
            List<OrderItem> lstOrderItemsToBeInserted = new List<OrderItem>();
            String maxLN = getMaxLineNumber (pOrderId);
            String [] ln = maxLN.split('\\.');
            Integer lni = Integer.valueOf(ln[1]) + 1;
            printDebug('---- Nuevo ProductLineNumber --> ' + lni);
            String offerLN = ('0000' + lni).right(4); //-- Genero el LN de la oferta.
            for (OrderItem oi : pLstOfferStrucgture) {
                OrderItem oiNew = getOrderItemRecord (oi.Id);
                OrderItem oiClone = oiNew.clone(false, false, false, false);
                oiClone.orderId = pOrderId;
                oiClone.vlocity_cmt__Action__c = 'Add';
                oiClone.vlocity_cmt__ProvisioningStatus__c = 'New';
                String oiLineNumber = oiClone.vlocity_cmt__LineNumber__c;
                String [] lnClone = oiLineNumber.split('\\.');
                lnClone[0] = ln[0];   //-- Asigno Plan.
                lnClone[1] = offerLN; //-- Asigno Producto.
                String newLN = null;
                for (Integer i=0; i < lnClone.size(); i++ ) {
                    newLN = (newLN == null) ? lnClone[i] : newLN + '.' + lnClone[i];
                }
                oiClone.vlocity_cmt__LineNumber__c = newLN;
                oiClone.vlocity_cmt__BillingAccountId__c = pAccountId;
                oiClone.vlocity_cmt__ServiceAccountId__c = pAccountId;
                lstOrderItemsToBeInserted.add(oiClone);
            }
            if (lstOrderItemsToBeInserted != null && !lstOrderItemsToBeInserted.isEmpty()) {
                insert lstOrderItemsToBeInserted;
            }
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            printDebug('===========================================================================');
            printDebug(stackTrace);
            printDebug('===========================================================================');
            throw new FunctionalException('Error al procesar la orden. Error: ' + e.getMessage());
        }
    }

    /**
     * El objetivo de este metodo es buscar dentro de la lista de items del template la estructura de la oferta.
     */
    private static List<OrderItem> getOfferStructure(String pPriceBookEntryId, List<OrderItem> pLstTemplateItems) {
        List<OrderItem> lstReturn = null;
        for (Integer i=0; pLstTemplateItems != null && i < pLstTemplateItems.size(); i++) {
            OrderItem oi = pLstTemplateItems.get(i);
            if (Id.valueOf(pPriceBookEntryId) == oi.PricebookEntryId) { //-- Encontre el root de la oferta.
                if (lstReturn == null) {
                    lstReturn = new List<OrderItem>();
                }
                lstReturn.add(oi);
                System.debug(oi);
                lstReturn.addAll(getOfferChild (oi.vlocity_cmt__LineNumber__c, pLstTemplateItems));
                break;
            }
        }
        if (lstReturn == null) {
            throw new FunctionalException('No se encontro la oferta en la Orden Template.');
        }
        return lstReturn;
    }

    /**
     * El objetivo de este metodo es buscar todos los orderitems cuyo line number este coincidan con el primer parametro.
     */
    private static List<OrderItem> getOfferChild (String pLineNumber, List<OrderItem> pLstTemplateItems) {
        printDebug('---- getOfferChild() - pLineNumber --> ' + pLineNumber);
        List<OrderItem> lstReturn = new List<OrderItem>();
        String [] tree = pLineNumber.split('\\.');
        for (Integer i=0; pLstTemplateItems != null && i < pLstTemplateItems.size(); i++) {
            OrderItem oi = pLstTemplateItems.get(i);
            String oiLineNumber = oi.vlocity_cmt__LineNumber__c; 

            if (oiLineNumber == null) {
                continue;
            }

            String [] treeTmpl = oiLineNumber.split('\\.');

            if (treeTmpl.size() <= tree.size()) {
                continue;  //-- La consigna es que tiene que ser hijo esto es nivel mayor que el padre.
            }

            printDebug('tree --> ' + tree + ' - treeTmpl --> ' + treeTmpl);

            if (tree[0] == treeTmpl[0] && tree[1] == treeTmpl[1]) { //-- Encontre el root de la oferta.
                lstReturn.add(oi);
            }
        }
        return lstReturn;
    }

    /**
     * El objetivo de este metodo es oObtener el maximo LineNumber de una orden dada.
     */
    private static String getMaxLineNumber (Id pOrderId) {
        printDebug('---- getMaxLineNumber() - pOrderId --> ' + pOrderId);
        try {
            String query = 'SELECT MAX(vlocity_cmt__LineNumber__c) maxLine FROM OrderItem WHERE orderId = \'' + pOrderId + '\'';
            List<AggregateResult> lstMaxLN =  Database.query(query);
            printDebug('---- MaxLineNumber -> ' + lstMaxLN[0].get('maxLine'));
            return String.valueOf(lstMaxLN[0].get('maxLine'));
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            printDebug('===========================================================================');
            printDebug(stackTrace);
            printDebug('===========================================================================');
            throw new FunctionalException( 'Fallo al obtener el maximo line number de la orden ' + pOrderId + ' - Error:' + e.getMessage());
        }
    }


    /**
     * El objetivo de este metodo es obtener dada una orden, el id de cuenta.
     */
    private static Map<String, Object> getAccountId(String pOrderId) {
        printDebug('Entre en getAccountId - param:pOrderId --> ' + pOrderId);
        Order order = null;
        try {
            order = [SELECT vlocity_cmt__AccountId__c, Name, Description FROM Order WHERE Id = :pOrderId];
            if (order == null) {
                throw new FunctionalException('No existe.');
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener la orden draft ' + pOrderId + '. - ' + e.getMessage());
        }

        printDebug('Order Fields --> ' + JSON.serialize(order));

        String descripcion = String.valueOf(order.Description);
        if (String.isBlank(descripcion)) {
            throw new FunctionalException('No se pudo obtener el identificador del plan.');
        }
        String query = null;
        String [] datos = descripcion.split(':');
        if (datos != null && datos.size()==2) {
            if (datos[0].trim().equalsIgnoreCase('M')) {
                query = 'SELECT AccountId, vlocity_cmt__RootItemId__c FROM Asset WHERE MSISDN__c = \'' + datos[1].trim() + '\' LIMIT 1';
            }
            else if (datos[0].trim().equalsIgnoreCase('S')) {
                query = 'SELECT AccountId, vlocity_cmt__RootItemId__c FROM Asset WHERE Subscription_Id__c = \'' + datos[1].trim() + '\' LIMIT 1';
            }
            else {
                throw new FunctionalException('Tipo de identificador no valido obtenido de la orden draft --> ' + pOrderId);
            }
        }
        else {
            throw new FunctionalException('Fallo al obtener los datos del plan de la orden draft creada.');
        }

        Asset asset = (Asset)Database.query(query);
        if (asset != null) {
            Map<String, Object> respuesta = new Map<String, Object>();
            respuesta.put('accountId', asset.AccountId);
            respuesta.put('planId', asset.vlocity_cmt__RootItemId__c);
            return respuesta;
        }
        else {
            throw new FunctionalException('Fallo en la obtencion del plan.');
        }
    }
    
    /**
     * El objetivo de esta funcion es crear una orden invocando la API --> assetToOrder.
     */
    private static String createOrder (String pAccountId, String pPlanId, String pTrackingNumber) {
        printDebug('Entre a createOrder(assetToOrder)');
        try {
            String orderId = null;
            Map<String, Object> mapa = new Map<String, Object>();
            mapa.put('methodName', 'assetToOrder');
            mapa.put('subaction', 'assetToOrder');
            mapa.put('accountId', pAccountId);
            DateTime fo = DateTime.now();
            mapa.put('requestDate', fo.format('yyyy-MM-dd'));  
            mapa.put('id',pPlanId);

            printDebug('..... Crear orden - Inicio  ');
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
                Order order = [SELECT Id, Gestion__c, vlocity_cmt__TrackingNumber__c FROM Order WHERE Id = :orderId];
                if (order != null) {
                    order.Gestion__c = K_GESTION;
                    if (!String.isBlank(pTrackingNumber)) {
                        order.vlocity_cmt__TrackingNumber__c = pTrackingNumber; //-- Update trackingNumber.
                    }
                    order.RecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MobilePhoneOrder').getRecordTypeId();
                    update order;
                }
            }
            return orderId;
        } 
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            printDebug('===========================================================================');
            printDebug(stackTrace);
            printDebug('===========================================================================');
            throw new FunctionalException(e.getMessage());
        }
    }

    /**
     * El objetivo de este metodo es insertar en la tabla Crossobject__c un registro con los datos de la orden
     * para ser tomado por el job batch para submitir la orden.
     */
    private static void insertJob (Id pOrderId, Id pAccountId) {
        printDebug('Entre a insertJob - pOrderId --> ' + pOrderId + ' - pAccountId --> ' + pAccountId);
        try {
            Crossobject__c co = new Crossobject__c();
            co.order__c = pOrderId;
            co.CrossObjectName__c = K_TIPO_JOB + ' ' + pOrderId;
            co.Status__c = 'Pendiente';
            co.DateTime1__c = DateTime.now();
            co.Account__c = pAccountId;
            co.String1__c = 'Venta Packs - Canal: Externo - Orden Id: ' + pOrderId;
            co.RecordTypeId = Schema.SObjectType.Crossobject__c.getRecordTypeInfosByName().get('External Channel').getRecordTypeId();
            insert co;
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            printDebug('===========================================================================');
            printDebug(stackTrace);
            printDebug('===========================================================================');
            throw new FunctionalException('Error al insertar el request batch. - ' + e.getMessage());
        }
    }

    /**
     * El objetivo de este metodo es obtener los orderItems de la orden Template.
     */
    private static List<OrderItem> getOrderItemsTemplate () {
        try {
            List<OrderItem> lstOrderItems = [SELECT id, ProductCode__c, PricebookEntryId, vlocity_cmt__JSONAttribute__c, Product2.vlocity_cmt__SubType__c, vlocity_cmt__LineNumber__c, vlocity_cmt__ParentItemId__c, vlocity_cmt__RootItemId__c 
            FROM OrderItem WHERE order.Name = :K_ORDER_TEMPLATE_NAME ORDER BY vlocity_cmt__LineNumber__c]; 

            if (lstOrderItems == null || lstOrderItems.isEmpty()) {
                throw new FunctionalException('No se recuperaron items de la orden template.');
            }

            System.debug(lstOrderItems);

            return lstOrderItems;
        }
        catch (Exception e) {
            printDebug('Problemas de configuracion. No se encontro la Orden Template [ ' + K_ORDER_TEMPLATE_NAME + ' ]. Error: ' + e.getMessage());
            throw new FunctionalException('Problemas de configuracion. No se encontro la Orden Template.');
        }    
    }

    /**
     * El objetivo de este metodo es obtener el registro completo de un OrderItem.
     * Con esto evito tener que armar un query con todos los campos de un OrderItem.
     */
    private static OrderItem getOrderItemRecord (Id pOrderItemId) {
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
     * Metodo que recibe dos parámetros y los devuelve en formato Map<String, Object>
     */
    private static Map<String, Object> getMap(String pNombre, Object pValor) {
        System.debug('Entre a getMap()');
        Map<String, Object> mapa = new Map<String, Object>();
        mapa.put (pNombre, pValor);
        return mapa;
    }

    /**
     * Esta funcion es un wrapper del System.debug(o)
     * que permite setear cuando activarlo o no.
     */
    private static void printDebug(String pMensaje) {
        if (K_DEBUG_ON) {
            System.debug(pMensaje);
        }
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
    private class FromJSON {
        public String orderId; 
        public String codCanal;
        public String preFactura;
        public List<OfertaClass> lstOferta;
    }

    private class OfertaClass {
        public String idListaPrecio;
        public String cantidad;
    }


}