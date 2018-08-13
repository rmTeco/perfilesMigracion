@isTest
private class IFS_S101_Test {
    
    @isTest static  void testGetCallout() {
        IFS_S101_reserveOrReleaseMock mock = new IFS_S101_reserveOrReleaseMock(); 
        mock.status=200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> RecursoList = new Map<String,Object>();
        Map<String,Object> Recurso = new Map<String,Object>();
        Recurso.put('codNMU','a');
        Recurso.put('codDeposito','a');
        Recurso.put('cantidad',2);
        RecursoList.put('test',Recurso);
        Test.setMock(HttpCalloutMock.class, mock);
        
        Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', RecursoList);
        
        Map<String,Object> MapReview = new map<String,Object>();
        
        mapReview.put('codigoResultado','res001');
        mapReview.put('descripcionResultado','resultado1');
        mapReview.put('httpStatusCode','200');
        
        Map <String,Object> lista = new map<String,Object>();
        
        lista.put('codNMU','nmu001');
        lista.put('codDeposito','depo001');
        lista.put('estado','estado1');
        
        mapReview.put('listaResultado', lista);
        
    }
    
    
    /*
    @isTest static  void testGetCalloutErrorCode400() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=400;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode401() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=401;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Unauthorized. Usuario no autorizado. Falló la autenticación.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode403() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=403;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Forbidden. No tiene los privilegios para hacer la solicitud que desea.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode404() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=404;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Recurso no encontrado. El servicio no encuentra el recurso solicitado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode405() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=405;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Method not allowed. El método solicitado no es soportado por el servicio.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode408() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=408;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Request Timeout. No se obtuvo respuesta de la plataforma servidora.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode418() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=418;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error controlado. Error funcional o de plataforma que se encuentra especificado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode500() {
        IFS_S101_reserveOrReleaseMock mock= new IFS_S101_reserveOrReleaseMock();
        mock.status=500;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S101_reserveOrRelease.reserveOrRelease('operacion1', 'codApp1', 'idOperacion1', 'codPDV1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no controlado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}*/
    
}