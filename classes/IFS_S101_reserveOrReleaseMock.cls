global class IFS_S101_reserveOrReleaseMock implements HttpCalloutMock{
         public Integer status {get;set;}
        // Implement this interface method
         global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"codigoResultado":"res001","descripcionResultado":"resultado1","listaResultado":[{"codNMU":"nmu001","codDeposito":"depo001","estado":"estado1"}]}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}