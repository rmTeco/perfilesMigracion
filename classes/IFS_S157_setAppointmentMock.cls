@isTest
global class IFS_S157_setAppointmentMock implements HttpCalloutMock {
    public Integer status {get;set;}
        // Implement this interface method
         global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString='{"EstadoOperacion":"e001","FechaHoraFinReserva":"201707011259","FechaHoraInicioReserva":"201707011259","FechaHoraMensaje":"2017070112258","NumeroReserva":"222","UsuarioReservado":"user1"}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
}