@isTest
private class IFS_S171_Test {
        @isTest static  void testGetCallout() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=201;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        
        Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        
        Map<String,Object> MapReview = new map<String,Object>();
        
        
        MapReview.put('CodeEstado','cod001');
        MapReview.put('DescripcionEstado','descripcion1');
        mapReview.put('httpStatusCode','200');
        
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        
        //for(String Cons : MapReview.keySet()){
        //  system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        //}
        
        // MapReview.equals(MapResponse)  
    }
    /*
    @isTest static  void testGetCalloutErrorCode400() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=400;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        
        try
        {
             Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode401() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=401;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
             Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Unauthorized. Usuario no autorizado. Falló la autenticación.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode403() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=403;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
             Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Forbidden. No tiene los privilegios para hacer la solicitud que desea.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode404() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=404;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
             Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Recurso no encontrado. El servicio no encuentra el recurso solicitado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode405() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=405;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
             Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Method not allowed. El método solicitado no es soportado por el servicio.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode408() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=408;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
             Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Request Timeout. No se obtuvo respuesta de la plataforma servidora.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode418() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=418;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error controlado. Error funcional o de plataforma que se encuentra especificado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode500() {
        IFS_S171_validateEMailMock mock= new IFS_S171_validateEMailMock();
        mock.status=500;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
             Map<String,Object> MapResponse = IFS_S171_validateEMail.validateEMail('mail');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no controlado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}*/
}