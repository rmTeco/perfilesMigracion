public class IFS_S239_getLocalLoopInformation {

    public static Map<String,Object> getLocalLoopInformation(String sw, String codU, String noLin, String ciu, String codAp, String codSer){
        
        getLocalLoopInformationJSON jsonParse = new getLocalLoopInformationJSON();
        jsonParse.swk = sw;
        jsonParse.codUsuario = codU;
        jsonParse.nroLinea = noLin;
        jsonParse.fechaHoraInteraccion = ciu;
        jsonParse.codAplicacion = codAp;
        jsonParse.codServicio = codSer;
        
        String body = JSON.serialize(jsonParse);
        HttpResponse response = makePostCallout(body);
        system.debug(response.getBody());
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s239' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
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
    
    public class getLocalLoopInformationJSON{
        
        public String swk {get;set;}
        public String codUsuario {get;set;}
        public String nroLinea {get;set;}
        public String fechaHoraInteraccion {get;set;}
        public String codAplicacion {get;set;}
        public String codServicio {get;set;}
        
    }
    
}