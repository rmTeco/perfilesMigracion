@isTest
global class IFS_S151_validarRespuestasIdentidadMock implements HttpCalloutMock {
    public Integer status {get;set;}
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"preguntas":{"cantidadRespuesta":"10"},"preguntasCorrectas":{"cantidadRespuesta":"10"},"porcentajeAcierto":{"porcentajeRespuesta":"3"},"porcentajeAciertoObtenido":{"porcentajeRespuesta":"30"},"codConsulta":"CON001","tiempoRespuesta":"2","respuesta":"Correcto"}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
    
}