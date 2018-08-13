@isTest 
global class IFS_S156_getAvailableDatesMock implements HttpCalloutMock {
     public Integer status {get;set;}
        // Implement this interface method
         global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String jsonString='{"EstadoOperacion":"e001", "FechaHoraMensaje":"201707011259", "VentanaReserva":[{"FechaHoraFinReserva":"201707011159", "FechaHoraInicioReserva":"201707011059","NumeroReserva":"222"}]}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}