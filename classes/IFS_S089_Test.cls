@isTest
public class IFS_S089_Test {
    @isTest static  void testGetCallout() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=200;        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Map<String,Object> mapTest = new map<String,Object>();

        Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('gus','tav','ou','cau','rou','zei');
        
        Map<String,Object> MapReview = new map<String,Object>();
        
        MapReview.put('idPuntoDeVenta','pdv001');
        MapReview.put('codDeposito','cd001');
        MapReview.put('codMarca','cdm001');
        MapReview.put('codFamiliaProducto','cfp001');
        MapReview.put('nmu','nmu001');
        MapReview.put('codigoStock','cs001');
        mapTest.put('httpStatusCode', '201');
      	mapTest.put('listaExistencias',MapReview);
        system.assertEquals(mapTest.size(), MapResponse.size());
        system.assertEquals(mapTest.keySet(), MapResponse.keySet());
        
        //for(String Cons : MapReview.keySet()){
          //  system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        //}
        
        // MapReview.equals(MapResponse)  
    }
    /*
    @isTest static  void testGetCalloutErrorCode400() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=400;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Bad Request. La solicitud contiene sintaxis errónea y no debería repetirse.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode401() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=401;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Unauthorized. Usuario no autorizado. Falló la autenticación.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode403() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=403;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Forbidden. No tiene los privilegios para hacer la solicitud que desea.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode404() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=404;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Recurso no encontrado. El servicio no encuentra el recurso solicitado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode405() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=405;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Method not allowed. El método solicitado no es soportado por el servicio.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode408() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=408;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Request Timeout. No se obtuvo respuesta de la plataforma servidora.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode418() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=418;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error controlado. Error funcional o de plataforma que se encuentra especificado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        
        @isTest static  void testGetCalloutErrorCode500() {
        IFS_S089_conseguirDisponibilidadMock mock= new IFS_S089_conseguirDisponibilidadMock();
        mock.status=500;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S089_conseguirDisponibilidad.conseguirDisponibilidad('venta', 'codeDep', 'codeMarc', 'codFamProd', 'NM', 'codStock');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no controlado.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }}
        */
        
}