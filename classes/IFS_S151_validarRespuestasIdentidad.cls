public class IFS_S151_validarRespuestasIdentidad {
    
    public static Map<String,Object> validarRespuestasIdentidad(String ticket, String token, Map<String,Object> Respuesta ){
        List<Respuesta> Respuestas = new List<Respuesta>();
        for(String Cons : Respuesta.keySet()){
            Respuesta Answer = new Respuesta();
            Answer.CodConsulta=Cons;
            Answer.CodRespuesta=(String)Respuesta.get(Cons);
            Respuestas.add(Answer);
        }
        
        validarRespuestasIdentidadJSON jsonParse = new validarRespuestasIdentidadJSON();
        jsonParse.listaRespuestas = Respuestas;
        jsonParse.ticket = ticket;
        jsonParse.token = token;
        String body = JSON.serialize(jsonParse);
        HttpResponse response = makePostCallout(body);
        system.debug(response.getBody());
        //Map<String, Object> responseNode=new Map<String,Object>();
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        responseNode.put('httpStatusCode',(String.valueOf(response.getStatusCode())));
        return responseNode;
    }
    
    public static HttpResponse makePostCallout(String body) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        List<EndPointService__c> endPoints = [select Name, EndPoint__c from EndPointService__c where Name = 'IFS_s151' limit 1];
        EndPointService__c endpoint;
        if(endPoints.size()>0){
            endpoint = endPoints[0];
        }
        
        if(endpoint != null){
            request.setEndpoint(endpoint.EndPoint__c);
        }
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        //request.setEndpoint('http://52.67.109.234:8080/S151_verifyAnswers_ReportesOnline/cliente/preguntas/respuestas/validar');
        String authorizationHeader = IFS_AuthorizationHeader.giveHeader();
        request.setHeader('Authorization', authorizationHeader);
        request.setBody(body);
        HttpResponse response = http.send(request);
        system.debug(response);
        system.debug(response.getBody());
        ///https://prodgonogo.personal.com.ar/cliente/preguntas/respuestas/validar

        
        return response;
        
    }     
    
    public class Respuesta {
        String codConsulta {get;set;}
        String codRespuesta {get;set;}
        
        
    }
    
    public class validarRespuestasIdentidadJSON{
        
        public String ticket {get;set;}
        public String token {get;set;}
        public List<Respuesta> listaRespuestas {get;set;}
        
        
    }
}