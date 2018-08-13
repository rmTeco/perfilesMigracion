@isTest
private class IFS_S150_Test {
    @isTest static  void testGetCallout() {
        IFS_S150_obtenerPreguntasIdentidadMock mock = new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        Map<String,Object> MapReview = new map<String,Object>();
        Map<String,Object> MapDocumento = new map<String,Object>();
        List<Object> dummy = new List <Object>();
        MapDocumento.put('numeroDocumento','12456789');
        MapReview.put('apellido','apellido1');
        MapReview.put('cuil',MapDocumento);
        MapReview.put('descripcionInteraccionNegocio','descripcion1');
        MapReview.put('descripcionIntervaloTiempo','descripcion1');
        MapReview.put('nombre','nombre1');
        MapReview.put('numeroDocumento','12456789');
        MapReview.put('preguntas',dummy);
        MapReview.put('ticket','ticket1');
        MapReview.put('tiempoRespuesta','20');
        MapReview.put('httpStatusCode', '200');
        
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        for(String Cons : MapReview.keySet()){
            system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }
        
        // MapReview.equals(MapResponse)  
    }/*
    @isTest static  void testGetCalloutErrorCode227() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=227;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no definido por ADS') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode323() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=323;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Tipo de documento No Homologado') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode608() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=608;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Documento Invalido') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode450() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=450;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('El genero ingresado no es correcto') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode381() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=381;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('No se encontraron datos para mostrar') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode190() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=190;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error del proveedor del Servicio') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode30() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=30;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('El documento ingresado corresponde a un menor de edad') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode451() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=451;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('El documento se encuentra bloqueado') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode452() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=452;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Validacion rechazada para el documento ingresado') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode453() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=453;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Fecha de nacimiento incorrecta') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode454() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=454;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('El documento ingresado corresponde a un fallecido') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode474() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=452;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('El documento ingresado corresponde a un habeas data') ? true : false;

        }} 
    
    
    @isTest static  void testGetCalloutErrorCodeUndefined() {
        IFS_S150_obtenerPreguntasIdentidadMock mock= new IFS_S150_obtenerPreguntasIdentidadMock();
        mock.status=150;        
        Test.setMock(HttpCalloutMock.class, mock);
        try
        {
            Map<String,Object> MapResponse = IFS_S150_obtenerPreguntasIdentidad.obtenerPreguntasIdentidad('DNI', '28294321', 'M', '1994/01/02', 'COD001', 'token1');
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no definido por ADS') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    */
    
}