/**
 * Este servicio recibe un identificador de cliente (MSISDN o SubscriberId) y devuelve
 * el status y fecha del status del Asset (Plan).
 *
 * @Author: Alejandro Salord (Certa Consulting)
 * @Version: 1.0
 * @see: PFTA-8884
 *
 * @Version: 1.1
 * @Author: Jose Rojas
 * Se cambia el url de exposición del servicio 
 */
@RestResource(urlMapping='/v1/integrationprocedure/obtener/EstadoLinea/*')
global with sharing class IFS_S495_getServiceStatus {
    private static final Boolean K_DEBUG_ON = true; 
    private static String guId = null;

    @HttpPost
    global static void getData() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        JSONRequest jrq = null;
        res.addHeader('Content-Type', 'application/json');

        writeLog ('REQ', req.requestBody.toString());

        try {
            res.statuscode = 200;
            //-- Procesamiento de parametros
            try {
                jrq = (JSONRequest)JSON.deserialize(req.requestBody.toString(),JSONRequest.class);
            }
            catch (Exception e) {
                throw new CalloutException(e.getMessage());
            }
            
            checkContrato(jrq);

            String respuesta = JSON.serialize(procesar(jrq));
            res.responseBody = Blob.valueOf(respuesta); //<--- Proceso y respondo.
        
            writeLog ('RES', 200 + ';' + respuesta);
            
        }
        catch (FunctionalException fe) {
            res.statuscode = 417;
            String respuesta = JSON.serialize(getRespuestaNoOk(fe.codDP, fe.getMessage()));
            res.responseBody = Blob.valueOf(respuesta);
            writeLog ('RES', res.statuscode + ';' + respuesta);
        }
        catch (CalloutException ce) {
            res.statuscode = 400;
            String respuesta = JSON.serialize(getRespuestaNoOk('400', ce.getMessage()));
            res.responseBody = Blob.valueOf(respuesta);
            writeLog ('RES', res.statuscode + ';' + respuesta);
        }
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S495', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S495', pTipo, guId, '', pDatos);  
        }
    }


    /**
     * @Objetivo: Secuencia principal del servicio. Aqui proceso con el request 
     * ya validado.
     */
    private static Map<String, Object> procesar (JSONRequest pJrq) {
        Map<String, Object> respuestaOk = new Map<String, Object>();
        List<Map<String, Object>> lstMotivos = new List<Map<String, Object>>();
        try {
            printDebug('Entre en procesar() - pJrq --> ' + pJrq);

            Asset asset = null;
            if (!String.isBlank(pJrq.servicio.identificadorRecurso)) {
                asset = [SELECT Status, Sub_Status__c, vlocity_cmt__ActivationDate__c, vlocity_cmt__DisconnectDate__c, Suspend_Date_Time__c, LastModifiedDate FROM Asset WHERE MSISDN__c = :pJrq.servicio.identificadorRecurso];
            }
            else {
                asset = [SELECT Status, Sub_Status__c, vlocity_cmt__ActivationDate__c, vlocity_cmt__DisconnectDate__c, Suspend_Date_Time__c, LastModifiedDate FROM Asset WHERE Subscription_Id__c = :pJrq.servicio.codSuscripcion];
            }

            if (asset == null) {
                throw new FunctionalException('No se encontro plan asociado al identificadorRecurso o subscriptionId');
            }

            //-- Si esta suspendido busco la fecha de suspencion y el motivo.
            if (asset.Status != null && asset.Status.equalsIgnoreCase('SUSPENDED')) {
                Map<String, Object> motivo = new Map<String, Object>();
                motivo.put('fechaMotivo', dateTimeFormat(asset.Suspend_Date_Time__c));
                motivo.put('motivo', asset.Sub_Status__c);
                lstMotivos.add(motivo);
                respuestaOk.put('motivos', lstMotivos);
                respuestaOk.put('fechaEstado', dateTimeFormat(asset.Suspend_Date_Time__c));
            }
            else if (asset.Status != null && asset.Status.equalsIgnoreCase('Active')) {  //-- Si esta activo busco la fecha en que se activo.
                respuestaOk.put('fechaEstado', dateTimeFormat(asset.vlocity_cmt__ActivationDate__c));
            }    
            else if (asset.Status != null && asset.Status.equalsIgnoreCase('Inactive')) {  //-- Si esta inactivo busco la fecha en que se desconecto.
                respuestaOk.put('fechaEstado', dateTimeFormat(asset.vlocity_cmt__DisconnectDate__c));
            }    
            else {    
                respuestaOk.put('fechaEstado', dateTimeFormat(asset.LastModifiedDate)); //-- Por ahora por cualquier otro estado busco la fecha de ultima modificación.
            }

            respuestaOk.put('estadoProducto', asset.Status);

            return respuestaOk;
        }
        catch (Exception e) {
            String stackTrace = e.getStackTraceString();
            printDebug('===========================================================================');
            printDebug(stackTrace);
            printDebug('===========================================================================');
            throw new FunctionalException('Error al procesar - ' + e.getMessage());
        }
    }

    /**
     * @Objetivo: Convertir la fecha al formato esperado en el IDD.
     */
    private static String dateTimeFormat (DateTime pDT) {
        if (pDT != null) {
            return pDT.format('yyyy-MM-dd HH:mm:ss');
        }
        else {
            return '';
        }
    }

    /**
     * @Objetivo: Verifica que el request cumpla con lo establecido
     * en el IDD.
     */
    private static void checkContrato (JSONRequest pJrq) {
        printDebug('Entre en checkContrato() - pJrq --> ' + pJrq);
        if (pJrq == null) {
            throw new CalloutException('El request vino nulo');
        }
        if (pJrq.servicio == null) {
            throw new CalloutException('El choice de identificacion vino nulo');
        }
        if (String.isBlank(pJrq.servicio.codSuscripcion) && String.isBlank(pJrq.servicio.identificadorRecurso)) {
            throw new CalloutException('El choice vino vacio');
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
     * @Objetivo: Imprimir mensajes en el canal debug.
     */
    private static void printDebug(String pMsj) {
        if (K_DEBUG_ON) {
            System.debug(pMsj);
        }
    }

    /**
     * @Objetivo: Para saber que codigo mandar debo poder
     *            diferenciar una excepcion funcional de
     *            otro tipo de excepciones.
     */
    private class FunctionalException extends Exception {
        public String codDP {set;get;} {codDP = '417';}
    }

    class JSONRequest {
        public ServicioClass servicio;
    }

    class ServicioClass {
        public String codSuscripcion;
        public String identificadorRecurso;
    }
}