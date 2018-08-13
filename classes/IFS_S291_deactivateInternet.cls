public class IFS_S291_deactivateInternet {
    
    public static Map<String,Object> deactivateInternet(String txId, String codServ){
        
        String message='codServicio='+codServ;
        if(String.isEmpty(message)){
            message='';
        }
        system.debug(message);

        HttpResponse response = makePostCallout(message, txId);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body, String id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s291' limit 1];
        EndPointService__c endpoint;
        String campo = 'txId';
        IFS_EndpointFixer fixer = new IFS_EndpointFixer();
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        if(endpoint != null){
            endpoint.EndPoint__c=fixer.FixEndpointGetService(campo, id, endpoint,body);
            //endpoint.EndPoint__c=fixer.FixEndpoint(campo, id, endpoint);
            request.setEndpoint(endpoint.EndPoint__c);        }
        //request.setEndpoint('https://prodgonogo.personal.com.ar/inventario/disponibilidad/puntoVenta/{codPuntoVenta}');
        //request.setEndpoint('https://demo9538567.mockable.io/getQuestions');
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());        
        
        return response;
        
    }     
    
}