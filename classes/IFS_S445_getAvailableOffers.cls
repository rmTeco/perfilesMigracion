/**
 * Este servicio es el Listener de Http, donde se recibe el requerimiento y se devuelve la respuesta
 * enviada por la implementacion (IFS_S445_getAvailableOffers_cls.cls).
 *
 * @Author: Alejandro Salord (Certa Consulting).
 * @Version: 
 * @see: 
 */
@RestResource(urlMapping='/v1/integrationprocedure/getAvailableOffers/*')
global with sharing class IFS_S445_getAvailableOffers {

    private static String guId = null;

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;

        writeLog ('REQ', req.requestBody.toString());

        res.addHeader('Content-Type', 'application/json');
        IFS_S445_getAvailableOffers_cls.ResultObj result = IFS_S445_getAvailableOffers_cls.getAvailableOffers(req.requestBody.toString());
        res.statuscode = result.resultCode;
        res.responseBody = result.resultMessage;

        writeLog ('RES', result.resultCode + ';' + EncodingUtil.base64Decode(EncodingUtil.base64Encode(result.resultMessage)).toString());
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S445', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S445', pTipo, guId, '', pDatos);  
        }
    }
}