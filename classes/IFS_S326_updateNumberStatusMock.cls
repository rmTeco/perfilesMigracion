@isTest
global class IFS_S326_updateNumberStatusMock implements HttpCalloutMock {
    public Integer status {get;set;}
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"codigoResultado":"result001", "descripcionError":"error001"}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}