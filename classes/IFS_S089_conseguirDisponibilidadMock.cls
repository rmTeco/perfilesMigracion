@isTest
global class IFS_S089_conseguirDisponibilidadMock implements HttpCalloutMock {
    public Integer status {get;set;}
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"listaExistencias": [{"codNMU":"nmu001","marcaProducto": "marca","codFamiliaProducto": "cfp001","codDeposito": "cd001","listaPorCodigoStock": [{"stockProducto": "stock1","cantidadExistente": 0,"cantidadDisponible": 0}]}]}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}