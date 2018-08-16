public class IFS_S038_updateCycle {
    
    private static String guId = null;
    
    public static Map<String,Object> updateCycle(String body, String identificador){
        Map<String, Object> responseNode = new Map<String, Object>();
        
        try {
            HttpResponse response = makePostCallout(body);
            responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
            responseNode.put('idCuenta', identificador);
        }
        catch (Exception e) {
            System.debug('Error --> ' + e.getMessage());
            System.debug(e.getStackTraceString());
            responseNode.put('httpStatusCode','500');
            responseNode.put('idCuenta', identificador);
        }

        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s038' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        HttpResponse response = http.send(request);

        System.debug(response);
        System.debug(response.getBody());
        
        writeLog ('REQ', null, null, 0);
        writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode());

        return response;
    }

    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pReq, String pRes, Integer pResStatus) {
        System.debug('Entre en writeLog - pTipo --> ' + pTipo + ' - pReq --> ' + pReq + ' - pRes --> ' + pRes + ' - pResStatus --> ' + pResStatus);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = String.isBlank(guId) ? GuidUtil.NewGuid() : guId;  
            IFS_LogRecord.record(dts, 'SERVICIO', 'S038', pTipo, guId, '', '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S038', pTipo, guId, '', datos);  
        }
    }
    
         
}