@isTest
global class IFS_S094_getSerializedByWarehouseMock implements HttpCalloutMock {
    public Integer status {get;set;}
        // Implement this interface method
         global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"listaDeSeriados":[{"NMU":"nmu001","numeroSerie":"string","nrodespacho": "des001","anioImportacion":0,"paisOrigen":"arg","paisProcedencia":"arg","aduanaIngreso":"in001","codDeposito": "dep01","codigoStock": "sto01"}]}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}