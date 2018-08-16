/**
 * Este servicio devuelve los casos y ordenes abiertos para un determinado
 * MSISDN o subscritptionId. Esta consulta es para ser realizada por los canales IVR o USSD.
 *
 * @Author: Alejandro Salord (Certa Consulting).
 * @see: PFTA-10094 (Jira)
 * @version: 0.1
 *
 */
@RestResource(urlMapping='/v1/integrationprocedure/getPendingCasesOrders/*')
global with sharing class IFS_S500_getPendingCasesOrders {

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
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S500', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S500', pTipo, guId, '', pDatos); 
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

            Asset asset = null;
            if (!String.isBlank(jsonBody.choiceId.nroLinea)) {
                asset = getProductPlanByMsisdn(jsonBody.choiceId.nroLinea);
            }
            else {
                asset = getProductPlanBySubscriptionId(jsonBody.choiceId.subscriberId);
            }

            if (asset == null) {
                throw new FunctionalException('Fallo al obtener obtener el AccountId.');
            }

            ToJson response = new ToJson();
            List<Case>  lstCases  = getOpenCases (asset.Id);    
            List<Order> lstOrders = getPendingOrders (asset.AccountId);

            for (Case lcase : lstCases) {
                GestionClass gestion = new GestionClass();
                gestion.numero = lcase.CaseNumber;
                gestion.fecha = lcase.CreatedDate != null ? lcase.CreatedDate.format('yyyy-MM-dd') : '';
                gestion.estado = lcase.Status;
                gestion.tipo = lcase.Type != null ? lcase.Type : '';
                gestion.subTipo = lcase.Reason != null ? lcase.Reason : '';
                response.lstGestion.add(gestion);
            }

            for (Order lorder : lstOrders) {
                OrdenClass orderc = new OrdenClass();
                orderc.numero = lorder.OrderNumber;
                orderc.fecha = lorder.CreatedDate != null ? lorder.CreatedDate.format('yyyy-MM-dd') : '';
                orderc.estado = lorder.Status;
                orderc.tipoGestion = lorder.Gestion__c != null ? lorder.Gestion__c : '';
                response.lstOrdenes.add(orderc);
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
            ro.resultMessage = JSON.serialize(getRespuestaNoOk(fe.codDP, fe.getMessage()));
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

        if (pJson.choiceId == null) {
            printDebug('El campo choiceId vino vacio o nulo'); 
            throw new CalloutException('El campo choiceId vino vacio o nulo.');
        }

        if (String.isBlank(pJson.choiceId.subscriberId) && String.isBlank(pJson.choiceId.nroLinea)) {
            printDebug('El subscriber y el nroLinea no vinieron o estan vacios, como es un choice alguno tiene que venir con valor'); 
            throw new CalloutException('Error en la validacion de los atributos del request. El choice vino vacio y debe contener al menos uno de los dos datos [subscriberId o nroLinea]');
        }
    }

    /**
     * El objetivo de este metodo es obtener el Asset Plan.
     * La busqueda se hace por MSISDN__c
     */
    private static Asset getProductPlanByMsisdn (String pNroLinea) {
        printDebug('Entre a getAccountIdByMsisdn()');
        try {
            List<Asset> asset = [SELECT Id, AccountId  FROM Asset WHERE MSISDN__c = :pNroLinea];
            if (asset.size()>0) {
                return asset.get(0);
            }
            else {
                throw new FunctionalException('Numero de Linea inexistente [ ' + pNroLinea + ' ]');
            }
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }    
    }

    /**
     * El objetivo de este metodo es obtener el Asset Plan.
     * La busqueda se hace por Subscription_Id__c
     */
    private static Asset getProductPlanBySubscriptionId(String pSuscriberId) {
        printDebug('Entre en getProductPlanBySubscriptionId()');
        try {
            List<Asset> asset = [SELECT Id, AccountId FROM Asset WHERE Subscription_Id__c = :pSuscriberId];
            if (asset.size()>0) {
                return asset.get(0);
            }
            else {
                throw new FunctionalException('Suscriber Id inexistente [ ' + pSuscriberId + ' ]');
            }
        }
        catch (Exception e) {
            throw new FunctionalException(e.getMessage());
        }    
    }


    /**
     * Dado un accountId devuelve todas las ordenes draft y In Process
     */
    private static List<Order> getPendingOrders (Id pAccountId) {
        printDebug('Entre en getPendingOrders()');
        try {
            List<Order> lstOrders = [SELECT OrderNumber, CreatedDate, Status, Gestion__c FROM Order WHERE AccountId = :pAccountId AND  Status IN ('Draft', 'In Progress')];
            return lstOrders;
        }
        catch (Exception e) {
            printDebug('--------------- Error: ' + e.getMessage());
            throw e;
        }
    }

    /**
     * Dado un Asset Id devolver todos los casos pendiente para ese asset.
     */
    private static List<Case> getOpenCases (Id pAssetId) {
        printDebug('Entre en getOpenCases()');
        try {
            List<Case> lstCases = [SELECT CaseNumber, CreatedDate, Status, Type, Reason FROM Case WHERE AssetId = :pAssetId AND IsClosed = false];
            return lstCases;
        }
        catch (Exception e) {
            printDebug('--------------- Error: ' + e.getMessage());
            throw e;
        }
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
        public String codDP {set;get;} {codDP = '417';}
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
        public String subscriberId;
        public String nroLinea;
    }

    //-- Clases para soportar el response --//
    private class ToJson {
        public List<GestionClass> lstGestion = null;
        public List<OrdenClass> lstOrdenes = null;
        public ToJson () {
            lstGestion = new List<GestionClass>();
            lstOrdenes = new List<OrdenClass>();
        }
    }

    private class GestionClass {
        public String numero = null;
        public String fecha = null;
        public String estado = null;
        public String tipo = null;
        public String subTipo = null;
    }

    private class OrdenClass {
        public String numero = null;
        public String fecha = null;
        public String estado = null;
        public String tipoGestion = null;
    }
}