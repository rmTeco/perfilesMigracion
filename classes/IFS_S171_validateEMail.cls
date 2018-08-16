public class IFS_S171_validateEMail {

    private static String guId = null;
    
    public static Map<String,Object> validateEMail(String mail){
        
        HttpResponse response = makePostCallout(mail);
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    /**
     * Wrapper del IFS_LogRecord.record
     */
    private static void writeLog (String pTipo, String pReq, String pRes, Integer pResStatus) {
        System.debug('Entre en writeLog - pTipo --> ' + pTipo + ' - pReq --> ' + pReq + ' - pRes --> ' + pRes + ' - pResStatus --> ' + pResStatus);
        String dts = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'', 'America/Argentina/Buenos_Aires');

        if (pTipo == 'REQ') {
            guId = String.isBlank(guId) ? GuidUtil.NewGuid() : guId;  
            IFS_LogRecord.record(dts, 'SERVICIO', 'S171', pTipo, guId, pReq, '');  
        }
        else {
            String datos = 'status code = ' + pResStatus + ' ; status = ; ';
            if (pResStatus < 300) {
                datos += 'request to DPW OK';
            }
            else {
                datos += 'request to DPW FAIL ; request body = ' + (String.isBlank(pReq)?'':pReq) + ' ; Response = ' + pRes;
            } 
            IFS_LogRecord.record(dts, 'SERVICIO', 'S171', pTipo, guId, '', datos);  
        }
    }
    
    public static HttpResponse makePostCallout(String id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s171' limit 1];
        String campo='email';
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        EndPointService__c endpoint;

        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }

        if(endpoint != null){
              endpoint.EndPoint__c=fixer.FixEndpoint(campo, id, endpoint);
              request.setEndpoint(endpoint.EndPoint__c);
        }
        
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());   

        writeLog ('REQ', '{"'+campo+'":"'+id+'"}', null, 0);
        writeLog ('RES', request.getBody(), response.getBody(), response.getStatusCode());

        return response;
    }     
}