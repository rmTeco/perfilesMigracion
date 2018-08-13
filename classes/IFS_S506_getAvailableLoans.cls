/**
 * Este servicio devuelve los prestamos disponibles para un determinado
 * plan. Esta consulta es para ser realizada por los canales IVR o USSD.
 *
 * @Author: Alejandro Salord (Certa Consulting).
 * @see: PFTA-10987 (Jira).
 * @version: 0.1
 *
 */
@RestResource(urlMapping='/v1/integrationprocedure/getAvailableLoans/*')
global with sharing class IFS_S506_getAvailableLoans {

    //-- Defaults --
    private static boolean K_DEBUG_ON = true;    //-- Enable / Disable Class Debug Mode.
    private static String guId = null;

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;

        writeLog ('REQ', req.requestBody.toString());

        ResultObj result = procesar(req.requestBody.toString());

        res.addHeader('Content-Type', 'application/json');
        res.statuscode = result.resultCode;
        res.responseBody = Blob.valueOf(result.resultMessage);

        writeLog ('RES', result.resultCode + ';' + result.resultMessage);
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        printDebug('Entre en writeLog - pTipo --> ' + pTipo + ' - pDatos --> ' + pDatos);
        DateTime dt = DateTime.now();
        String dts = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            //-- IFS_LogRecord.record(dts, 'SERVICIO', 'S500', guId, pTipo, pDatos, ''); -- Se habilitara cuando este aprobada la historia.
        }
        else {
            //-- IFS_LogRecord.record(dts, 'SERVICIO', 'S500', guId, pTipo, '', pDatos); -- Se habilitara cuando este aprobada la historia.
        }
    }

    /**
     * Secuencia principal del servicio.
     */
    public static ResultObj procesar (String pJson) {
        printDebug('Entre en procesar - pJson --> ' + pJson);
        ResultObj ro = new ResultObj();
        try {
            FromJson jsonBody = (FromJSON)JSON.deserialize(pJson, FromJSON.class);
            checkContrato (jsonBody);

            Id product2Id = null;
            if (!String.isBlank(jsonBody.choiceId.nroLinea)) {
                product2Id = Id.valueOf(getProductPlanByMsisdn(jsonBody.choiceId.nroLinea));
            }
            else {
                product2Id = Id.valueOf(getProductPlanBySubscriptionId(jsonBody.choiceId.codSuscripcion));
            }

            if (product2Id == null) {
                throw new FunctionalException('Fallo al obtener el Id del Producto del Plan.');
            }

            List<vlocity_cmt__ProductChildItem__c> lstProductos = getSosProduct (product2Id);
            if (lstProductos == null) {
                throw new FunctionalException('Error al obtener los prodcutos prestamo');
            }

            ToJson response = new ToJson();
            for (vlocity_cmt__ProductChildItem__c cp : lstProductos) {
                String jsonAtt = cp.vlocity_cmt__ChildProductId__r.vlocity_cmt__JSONAttribute__c;
                OfertaClass oc = new OfertaClass();
                oc.esProvisionDirecta = getAttrValue (jsonAtt, 'FAN_ATTCAT_000042', 'FAN_ATT_000143', 'value__c') == 'true' ? 'S' : 'N';
                oc.codPrestamo = getAttrValue (jsonAtt, 'FAN_ATTCAT_000042', 'FAN_ATT_000148', 'value__c');
                oc.precioCargo = getAttrValue (jsonAtt, 'FAN_ATTCAT_000010', 'FAN_ATT_000147', 'value__c');
                oc.diasGracia = getAttrValue (jsonAtt, 'FAN_ATTCAT_000010', 'FAN_ATT_000146', 'value__c');
                oc.montoPrestamo = getAttrValue (jsonAtt, 'FAN_ATTCAT_000045', 'FAN_ATT_000145', 'value__c');
                oc.tipoOferta = cp.vlocity_cmt__ChildProductId__r.vlocity_cmt__Type__c;
                oc.familiaOferta = cp.vlocity_cmt__ParentProductId__r.Family;
                oc.descripcionOfertaProd = cp.vlocity_cmt__ChildProductId__r.Name;
                oc.codOfertaProducto = cp.vlocity_cmt__ChildProductId__r.ProductCode;

                response.listaPrestamos.add(oc);
            }

            ro.resultCode = 200;
            ro.resultMessage = JSON.serialize(response);
        }
        catch (CalloutException ce) {
            printDebug('Error --> ' + ce.getMessage());
            printDebug('Stacktrace --> ' + ce.getStackTraceString());
            ro.resultCode = 400;
            ro.resultMessage = JSON.serialize(getRespuestaNoOk('400', ce.getMessage()));
        }
        catch (FunctionalException fe) {
            printDebug('Error --> ' + fe.getMessage());
            printDebug('Stacktrace --> ' + fe.getStackTraceString());
            ro.resultCode = 417;
            ro.resultMessage = JSON.serialize(getRespuestaNoOk('417', fe.getMessage()));
        }
        catch (Exception e) {
            printDebug('Error --> ' + e.getMessage());
            printDebug('Stacktrace --> ' + e.getStackTraceString());
            ro.resultCode = 500;
            ro.resultMessage = JSON.serialize(getRespuestaNoOk('500', e.getMessage()));
        }

        return ro;
    }

    /**
     * Verifica que se cumpla el IDD.
     */
    private static void checkContrato (FromJSON pJson) {
        printDebug('Entre a checkContrato()');

        if (pJson == null) {
            printDebug('El json vino vacio o nulo'); 
            throw new CalloutException('Error en la validacion de los atributos del request. Vino vacio.');
        }

        if (String.isBlank(pJson.choiceId.codSuscripcion) && String.isBlank(pJson.choiceId.nroLinea)) {
            printDebug('El codSuscripcion y el nroLinea no vinieron o estan vacios, como es un choice alguno tiene que venir con valor'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El choice vino vacio y debe contener al menos uno de los dos datos [codSuscripcion o nroLinea]');
        }
    }

    /**
     * El objetivo de este metodo es obtener el id de prodcuto del plan.
     * La busqueda se hace por MSISDN__c
     */
    private static String getProductPlanByMsisdn (String pNroLinea) {
        printDebug('Entre a getAccountIdByMsisdn()');
        String accountId = null;
        
        try {
            List<Asset> asset = [SELECT Product2Id FROM Asset WHERE MSISDN__c = :pNroLinea];
            if (asset.size()>0) {
                return asset.get(0).Product2Id;
            }
            else {
                throw new FunctionalException('Error al obtener el Product2Id del nroLinea: ' + pNroLinea);
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener el Product2Id del nroLinea: ' + pNroLinea + '. Error: ' + e.getMessage());
        }    
    }

    /**
     * El objetivo de este metodo es obtener el id de prodcuto del plan.
     * La busqueda se hace por Subscription_Id__c
     */
    private static String getProductPlanBySubscriptionId(String pSuscriberId) {
        printDebug('Entre en getProductPlanBySubscriptionId()');
        try {
            List<Asset> asset = [SELECT Product2Id FROM Asset WHERE Subscription_Id__c = :pSuscriberId];
            if (asset.size()>0) {
                return asset.get(0).Product2Id;
            }
            else {
                throw new FunctionalException('Error al obtener el Product2Id del suscriberId: ' + pSuscriberId);
            }
        }
        catch (Exception e) {
            throw new FunctionalException('Error al obtener el Product2Id del codSuscripcion: ' + pSuscriberId + '. Error: ' + e.getMessage());
        }    
    }

    /**
     * Este metodo devuelve los datos del producto, producto hijo en un solo query.
     */
    private static List<vlocity_cmt__ProductChildItem__c> getSosProduct (Id pProductPlan) {
        List<vlocity_cmt__ProductChildItem__c> lstSosProduct = [
            SELECT vlocity_cmt__ParentProductId__r.Name, 
                    vlocity_cmt__ParentProductId__r.Family, 
                    vlocity_cmt__ParentProductId__r.vlocity_cmt__Type__c, 
                    vlocity_cmt__ChildProductId__r.vlocity_cmt__Type__c,  
                    vlocity_cmt__ChildProductId__r.Name, 
                    vlocity_cmt__ChildProductId__r.ProductCode, 
                    vlocity_cmt__ChildProductId__r.vlocity_cmt__JSONAttribute__c 
                    FROM 
                        vlocity_cmt__ProductChildItem__c 
                    WHERE 
                        vlocity_cmt__ParentProductId__c = :pProductPlan AND 
                        vlocity_cmt__ChildProductId__r.vlocity_cmt__Type__c = 'Prestamo'];

        if (lstSosProduct == null || lstSosProduct.isEmpty()) {
            throw new FunctionalException('No se encontro el producto Recarga SOS');
        }
        else {
            return lstSosProduct;
        }
    }

    /**
     * Esta funcion permite obtener de una estructura json ingresada como parametro
     * un atributo determinado, en este caso value__c dentro del tag FAN_ATTCAT_000045
     * devolviendo el valor contenido en value__c en una lista de string.
     * Tree:
     *        categorycode__c == FAN_ATTCAT_000045
     *              value__c --> valor a obtener.
     */
    private static String getAttrValue (String pJsonAttribute, String pCategoria, String pAttrUniqCode, String pFieldValueName) {
        System.debug('---- executing getAttrValue()');
        String retValue = '';
        if (String.isBlank(pJsonAttribute)) {
            return retValue;   
        }

        String valor = null;
        String campo = null;
        JSONParser parser = JSON.createParser(pJsonAttribute);
        Boolean eos = false; //-- End of search.
        while (parser.nextToken() != null && !eos) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'categorycode__c')) {
                if (parser.nextValue() != null) {
                    valor = parser.getText();
                    if (valor != null && valor == pCategoria){
                        valor = null;
                        System.debug('Encontre el tag: ' + pCategoria);
                        while (parser.nextToken() != null && !eos) {
                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'attributeuniquecode__c')) {
                                if (parser.nextValue() != null) {
                                    valor = parser.getText();
                                    if (valor != null && valor == pAttrUniqCode){
                                        valor = null;
                                        System.debug('Encontre el tag: ' + pAttrUniqCode);
                                        while (parser.nextToken() != null && !eos) {
                                            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == pFieldValueName)) {
                                                System.debug('... campo: ' + pFieldValueName);
                                                if (parser.nextValue() != null) {
                                                    retValue = parser.getText();
                                                    eos = true;
                                                    System.debug('... valor del campo ' + pFieldValueName + ' --> ' + retValue);
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

    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *           diferenciar una excepcion funcional de
     *           otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {

    }

    public class ResultObj {
		public Integer resultCode;
		public String resultMessage;
	}

    //-- Clases para soportar el request --//
    private class FromJson {
        public ChoiceClass choiceId;
    }

    private class ChoiceClass {
        public String codSuscripcion;
        public String nroLinea;
    }

    //-- Clases para soportar el response --//
    private class ToJson {
        public List<OfertaClass> listaPrestamos = null;
        public ToJson () {
            listaPrestamos = new List<OfertaClass>();
        }
    }

    private class OfertaClass {
        public String codOfertaProducto = null;
        public String descripcionOfertaProd = null;
        public String familiaOferta = null;
        public String tipoOferta = null;
        public String montoPrestamo = null;
        public String diasGracia = null;
        public String precioCargo = null;
        public String codPrestamo = null;
        public String esProvisionDirecta = null;
    }
}