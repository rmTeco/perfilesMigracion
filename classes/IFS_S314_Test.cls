@isTest
private class IFS_S314_Test {
    @isTest static  void testGetCallout() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=201;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        mapTest.put('test','test2');
        Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        
        Map<String,Object> MapReview = new map<String,Object>();
        MapReview.put('codInteraccionNegocio','cod001');      
        mapReview.put('httpStatusCode','200');

        
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        
        //for(String Cons : MapReview.keySet()){
        //  system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        //}
        
        // MapReview.equals(MapResponse)  
    }    
    
    /*@isTest static  void testGetCalloutErrorCode400() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=400;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode401() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=401;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Unauthorized. Usuario no autorizado. Falló la autenticación.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode403() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=403;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Forbidden. No tiene los privilegios para hacer la solicitud que desea.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode404() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=404;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Recurso no encontrado. El servicio no encuentra el recurso solicitado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode405() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=405;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Method not allowed. El método solicitado no es soportado por el servicio.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode408() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=408;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Request Timeout. No se obtuvo respuesta de la plataforma servidora.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode418() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=418;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error controlado. Error funcional o de plataforma que se encuentra especificado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode500() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=500;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no controlado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    /////////////////////////////////////////////TESTs DE ERRORES DEL IDD//////////////////////////////////////////////////////
    @isTest static  void testGetCalloutErrorCode010() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=010;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no definido por Infotaiment.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode497() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=497;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error datos de autenticación.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode544() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=544;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error al validar los datos de entrada.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode551() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=551;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Servicio inactivo o inexistente.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode595() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=595;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error genérico en el sistema Infotaiment.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode601() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=601;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('El servicio no tiene configurado un canal para enviar el optin al usuario') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode602() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=602;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error al enviar pedido de confirmación al usuario') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode603() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=603;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Esperando confirmación del usuario.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode604() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=604;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('El usuario ya se encuentra suscripto.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode100002() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=100002;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error de Autorización. El usuario no tiene los permisos necesario para ejecutar el servicio.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode100003() {
        IFS_S314_addSuscriptionsMock mock= new IFS_S314_addSuscriptionsMock();
        mock.status=100003;        
        Test.setMock(HttpCalloutMock.class, mock);		        
        Map<String,Object> mapTest = new map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S314_addSuscriptions.addSuscriptions('a','b','c','d','e','f',mapTest);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Sesión vencida.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}*/
    
    
}