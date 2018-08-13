@isTest 
global class IFS_S238_getCPEModemInformationMock implements HttpCalloutMock {
    public Integer status {get;set;}
        // Implement this interface method
         global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"return":"retorno1"}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}