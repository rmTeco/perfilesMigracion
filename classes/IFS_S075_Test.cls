@isTest
private class IFS_S075_Test {
    
    @isTest static  void testGetCalloutErrorCode201() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=200;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapReview = new map<String,Object>();
        
        Map<String,Object> mapTest = new map<String,Object>();
        Map<String,Object> mapaAux = new map<String,Object>();
        Map<String,Object> mapaTarget = new map<String,Object>();
        Map<String,Object> mapTest4 = new map<String,Object>();
        Map<String,Object> mapTest5 = new map<String,Object>();

        mapaTarget.put('User',mapTest4);
        mapaTarget.put('RawData',mapTest5);
        
        mapTest.put('das',mapaAux);
        mapaAux.put('Target',mapaTarget);
        
        mapReview.put('zez','das');
        mapReview.put('httpStatusCode','200');
        
        Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
       
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        
        
    }
        /*
    @isTest static  void testGetCalloutErrorCode400() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=400;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.');
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
        
        @isTest static  void testGetCalloutErrorCode401() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=401;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Unauthorized. Usuario no autorizado. Falló la autenticación.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode403() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=403;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Forbidden. No tiene los privilegios para hacer la solicitud que desea.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode404() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=404;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Recurso no encontrado. El servicio no encuentra el recurso solicitado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode405() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=405;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Method not allowed. El método solicitado no es soportado por el servicio.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode408() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=408;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Request Timeout. No se obtuvo respuesta de la plataforma servidora.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode418() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=418;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error controlado. Error funcional o de plataforma que se encuentra especificado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
         @isTest static  void testGetCalloutErrorCode500() {
        IFS_S075_sendEmailMock mock= new IFS_S075_sendEmailMock();
        mock.status=500;        
        Test.setMock(HttpCalloutMock.class, mock);              
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S075_sendEmail.sendEmail(mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no controlado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}    */
        
        
}