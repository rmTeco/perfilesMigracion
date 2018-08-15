@RestResource(urlMapping='/v1/integrationprocedure/CustomerCare_CustomerValidation_pinValidationSMS/*')
global with sharing class IFS_S158_pinValidationSMS {

    private static String guId = null;
    private static boolean K_DEBUG_ON = true;    //-- Enable / Disable Class Debug Mode.

    @HttpPost
    global static void getData() {
        FromJSON jsonBody;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        Map<String, String> msgSMS = new Map<String, String>();
        res.addHeader('Content-Type', 'application/json');

        writeLog ('REQ', req.requestBody.toString());

        try {
            jsonBody = (FromJSON)JSON.deserialize(req.requestBody.toString(),FromJSON.class);
            res.statuscode = 200;
            if (string.isBlank(jsonBody.pinValidationSMS.mensaje)) {
                CalloutException e = new CalloutException();
                e.setMessage('Mensaje vacio');
                throw e;
            }
            else {
                msgSMS.put('nroLinea',jsonBody.pinValidationSMS.nroLinea);
                msgSMS.put('mensaje',jsonBody.pinValidationSMS.mensaje);
                System.debug('msgSMS --------> ' + msgSMS);
                if(!Test.isRunningTest()){
                    System.debug('antes de entrar a  ---->taSalesSMSInteraction.ReceiveMessage' );
                    taSalesSMSInteraction taSales = new taSalesSMSInteraction();
                    Boolean sendOk = taSales.invokeMethod('ReceiveMessage',null,null, msgSMS);
                    System.debug('despues de salir de---->taSalesSMSInteraction.ReceiveMessage' + sendOk);
                }
            }
            writeLog ('RES', 200 + ';' + '{}');
        }
        catch(Exception e){
            res.statuscode = 417;
            res.responseBody = Blob.valueOf(JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
            
            writeLog ('RES', 417 + ';' + JSON.serialize(getRespuestaNoOk('417',e.getMessage())));
            
        }
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
            //IFS_LogRecord.record(dts, 'SERVICIO', 'S158', guId, pTipo, pDatos, '');  
        }
        else {
            //IFS_LogRecord.record(dts, 'SERVICIO', 'S158', guId, pTipo, '', pDatos);  
        }
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

    private static List<Map<String, String>> getRespuestaNoOk(String pCodigo, String pDescripcion) {
        System.debug('Entre a getRespuestaNoOk()');
        Map<String, String> mapa = new Map<String, String>();
        List<Map<String, String>> lstErrors = new List<Map<String, String>>();
        mapa.put('errorCode', pcodigo);
        mapa.put('message', pDescripcion);
        lstErrors.add(mapa);
        return lstErrors;   
    }

     public class FromJSON {
        public FromJSON_1 pinValidationSMS; 
    }
     public class FromJSON_1 {
        public String nroLinea; 
        public String mensaje; 
    }
}