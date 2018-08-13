@isTest
global class IFS_S150_obtenerPreguntasIdentidadMock implements HttpCalloutMock {
    public Integer status {get;set;}   
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString = '{"ticket":"ticket1","descripcionInteraccionNegocio":"descripcion1","numeroDocumento":"12456789","cuil":{"numeroDocumento":"12456789"},"nombre":"nombre1", "apellido":"apellido1", "descripcionIntervaloTiempo":"descripcion1","tiempoRespuesta":"20","preguntas":[]}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}