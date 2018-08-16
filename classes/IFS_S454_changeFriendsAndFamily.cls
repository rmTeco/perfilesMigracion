@RestResource(urlMapping='/v1/integrationprocedure/changeFriendsAndFamily/*')
global with sharing class IFS_S454_changeFriendsAndFamily {

    private static String guId = null;

    @HttpPost
    global static void getPost() {
        Http http = new Http();
        Map<String, Object> resultado = null;
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;

        writeLog ('REQ', req.requestBody.toString());

        res.addHeader('Content-Type', 'application/json');
        IFS_S454_changeFriendsAndFamily_cls ifsS454 = new IFS_S454_changeFriendsAndFamily_cls();
        IFS_S454_changeFriendsAndFamily_cls.ResultObj result = ifsS454.changeFriendsAndFamily(req.requestBody.toString());
        res.statuscode = result.resultCode;
        res.responseBody = Blob.valueOf(result.resultMessage);

        writeLog ('RES', result.resultCode + ';' + result.resultMessage);
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pDatos) {
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = GuidUtil.NewGuid(); //-- Calculo el Guid.
            IFS_LogRecord.record(dts, 'SERVICIO', 'S454', pTipo, guId, '', pDatos);  
        }
        else {
            IFS_LogRecord.record(dts, 'SERVICIO', 'S454', pTipo, guId, '', pDatos);  
        }
    }
}