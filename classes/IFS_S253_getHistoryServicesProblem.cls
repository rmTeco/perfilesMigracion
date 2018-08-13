public class IFS_S253_getHistoryServicesProblem {

    public static Map<String,Object> getHistoryServicesProblem(String txId, String nLin, String codSer, String days){
        String message;
        if(nLin!=null){
            message='nroLinea='+nLin+'&';}
        if(codSer!=null){
            message+='codServicio='+codSer+'&';
        }
            message+='dias='+days+'&';
        if(String.isEmpty(message)){
            message='';
        }
        message = message.removeEnd('&');
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
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s253' limit 1];
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
        ///Falta setear el endpoint de esta clase.
        ///https://prodgonogo.personal.com.ar/movil/numerosDisponibles
        //request.setEndpoint('https://prodgonogo.personal.com.ar/movil/numerosDisponibles');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug('POST response: '+response);

        return response;
        
    }     
    
}