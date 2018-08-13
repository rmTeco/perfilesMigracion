@isTest
private class IFS_S121_Test {
    
    @isTest static  void testGetCallout() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=200;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2,'zoz', 'xav', 'gus', 'fau', 'fed', 2, 'zez');
        Map<String,Object> MapReview = new map<String,Object>();
        Map<String,Object> MapListaNumeros = new map<String,Object>();
        mapObject num = new mapObject();
        /* num.IdReserva='reserva1';
num.numeroLinea='numero1';
List<Object> listaAux= new List<Object>();
listaAux.add(num);
MapReview.put('ListaNumeros',listaAux);*/
        Object Numeros;
        Object second;
        MapListaNumeros.put('IdReserva','reserva1');
        MapListaNumeros.put('numeroLinea','numero1');
        Numeros=MapListaNumeros;
        system.debug('Objecto second');
        second=Numeros;
        system.debug(second);
        num.contents=MapListaNumeros;
        MapReview.put('ListaNumeros',num);
        MapReview.put('httpStatusCode', '200');
        
        system.debug('Objecto abstracto');
        //      system.debug(Numeros);
        system.debug('Objecto real');
        system.debug(MapResponse.get('ListaNumeros'));
        system.debug('Mapa de Review');
        system.debug(MapReview);
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        system.debug('Size de review luego response');
        system.debug(MapReview.size());
        system.debug(MapResponse.size());
        system.debug('keyset de review luego response');
        
        system.debug(MapReview.keySet());
        system.debug(MapResponse.keySet());
        system.debug(' review luego response');
        
        system.debug(MapReview);
        system.debug(MapResponse);
        system.debug(MapResponse.get('ListaNumeros'));
        system.assertEquals(MapReview.keyset(), MapResponse.keyset());
        /*for(String Cons : MapReview.keySet()){
String var1;
String var2;
var1=MapReview.get(Cons)
}*/
    }
/*    
    @isTest static  void testGetCalloutErrorCode400() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=400;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode401() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=401;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Unauthorized. Usuario no autorizado. Falló la autenticación.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode403() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=403;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Forbidden. No tiene los privilegios para hacer la solicitud que desea.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode404() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=404;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Recurso no encontrado. El servicio no encuentra el recurso solicitado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode405() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=405;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Method not allowed. El método solicitado no es soportado por el servicio.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode408() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=408;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Request Timeout. No se obtuvo respuesta de la plataforma servidora.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode418() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=418;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error controlado. Error funcional o de plataforma que se encuentra especificado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
    
    @isTest static  void testGetCalloutErrorCode500() {
        IFS_S121_numerosDisponiblesMock mock= new IFS_S121_numerosDisponiblesMock();
        mock.status=500;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S121_numerosDisponibles.numerosDisponibles(2, 'venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 3, 'codStock', 'test');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no controlado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}    */
    
    
    private class mapObject {
        map<String,Object> contents{get;set;}
        /*
String IdReserva {get;set;}
String numeroLinea {get;set;}*/
    }
}