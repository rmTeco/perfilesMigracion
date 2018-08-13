@isTest
private class IFS_S151_Test {
    
    @isTest static  void testGetCallout() {
        IFS_S151_validarRespuestasIdentidadMock mock= new IFS_S151_validarRespuestasIdentidadMock();
        mock.status=200;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        Recurso.put('test','test2');
        Map<String,Object> MapResponse = IFS_S151_validarRespuestasIdentidad.validarRespuestasIdentidad('estructura1', 'recurso1', Recurso);
        Map<String,Object> MapReview = new map<String,Object>();
        Map<String,Object> MapAcierto = new map<String,Object>();
        Map<String,Object> MapAciertoObtenido = new map<String,Object>();
        Map<String,Object> MapPreguntas = new map<String,Object>();
        Map<String,Object> MapPreguntasCorrectas = new map<String,Object>();
        MapAcierto.put('porcentajeRespuesta','3');
        MapAciertoObtenido.put('porcentajeRespuesta','30');
        MapPreguntas.put('cantidadRespuesta','10');
        MapPreguntasCorrectas.put('cantidadRespuesta','10');
        MapReview.put('codConsulta','CON001');
        MapReview.put('porcentajeAcierto',MapAcierto);
        MapReview.put('porcentajeAciertoObtenido',MapAciertoObtenido);
        MapReview.put('preguntas',MapPreguntas);
        MapReview.put('preguntasCorrectas',MapPreguntasCorrectas);
        MapReview.put('respuesta','Correcto');
        MapReview.put('tiempoRespuesta','2');
        MapReview.put('httpStatusCode','200');
        String bodyRest = JSON.serialize(MapResponse);
        String bodyRev = JSON.serialize(MapReview);
        
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        for(String Cons : MapReview.keySet()){
            system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }}/*
    @isTest static  void testGetCalloutErrorCode190() {
        IFS_S151_validarRespuestasIdentidadMock mock= new IFS_S151_validarRespuestasIdentidadMock();
        mock.status=190;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S151_validarRespuestasIdentidad.validarRespuestasIdentidad('estructura1', 'recurso1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error del Proveedor del Servicio') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode381() {
        IFS_S151_validarRespuestasIdentidadMock mock= new IFS_S151_validarRespuestasIdentidadMock();
        mock.status=381;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S151_validarRespuestasIdentidad.validarRespuestasIdentidad('estructura1', 'recurso1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('No se encontraron datos para mostrar') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode60131() {
        IFS_S151_validarRespuestasIdentidadMock mock= new IFS_S151_validarRespuestasIdentidadMock();
        mock.status=60131;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S151_validarRespuestasIdentidad.validarRespuestasIdentidad('estructura1', 'recurso1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Timeout') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode100002() {
        IFS_S151_validarRespuestasIdentidadMock mock= new IFS_S151_validarRespuestasIdentidadMock();
        mock.status=100002;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S151_validarRespuestasIdentidad.validarRespuestasIdentidad('estructura1', 'recurso1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error de Autorización. El usuario no tiene los permisos necesario para ejecutar el servicio') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCode100001() {
        IFS_S151_validarRespuestasIdentidadMock mock= new IFS_S151_validarRespuestasIdentidadMock();
        mock.status=100001;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S151_validarRespuestasIdentidad.validarRespuestasIdentidad('estructura1', 'recurso1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error de autorización. Falló al autenticar el usuario X') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    @isTest static  void testGetCalloutErrorCodeUndefined() {
        IFS_S151_validarRespuestasIdentidadMock mock= new IFS_S151_validarRespuestasIdentidadMock();
        mock.status=150;        
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> Recurso = new Map<String,Object>();
        try
        {
            Map<String,Object> MapResponse = IFS_S151_validarRespuestasIdentidad.validarRespuestasIdentidad('estructura1', 'recurso1', Recurso);
        }
        catch(Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Error no definido por ADS') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }} 
    
    */
}