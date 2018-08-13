public class IFS_S038_updateCycle {
    
    public static Map<String,Object> updateCycle(String body, String identificador){
        HttpResponse response = makePostCallout(body);
        //system.debug(response); 
        //system.debug(response.getStatusCode());
        //system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        responseNode.put('idCuenta', identificador);
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
        //request.setEndpoint('https://prodgonogo.personal.com.ar/cuenta/cicloFacturacion');

        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());
        
        return response;
        
    }     
}