@RestResource(urlMapping='/v1/integrationprocedure/getLineDataValidation/*')
global with sharing class IFS_S435_getLineDataValidation {

    private static String guId = null;

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        res.addHeader('Content-Type', 'application/json');

        writeLog ('REQ', req.requestBody.toString());
        
        IFS_S435_getLineDataValidation_cls.ResultObj result = IFS_S435_getLineDataValidation_cls.getLineDataValidation(req.requestBody.toString());
        res.statuscode = result.resultCode;
        res.responseBody = result.resultMessage;

        writeLog ('RES', res.statuscode + ';' + EncodingUtil.base64Decode(EncodingUtil.base64Encode(res.responseBody)).toString());

    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S435', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S435', pTipo, guId, '', pDatos);  
        }
    }
    
}