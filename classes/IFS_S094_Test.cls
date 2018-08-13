@isTest
private class IFS_S094_Test {
    
    @isTest static  void testGetCallout() {
        IFS_S094_getSerializedByWarehouseMock mock = new IFS_S094_getSerializedByWarehouseMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> MapResponse = IFS_S094_getSerializedByWarehouse.getSerializedByWarehouse('DNI', '28294321', 'M', '1994/01/02');
        Map<String,Object> MapReview = new map<String,Object>();
        Map<String,Object> MapAux = new map<String,Object>();
        
        
        MapAux.put('NMU','nmu001');
        MapAux.put('numeroSerie','ser001');
        MapAux.put('nrodespacho','des001');
        MapAux.put('anioImportacion','0');
        MapAux.put('paisOrigen','arg');
        MapAux.put('paisProcedencia','arg');
        MapAux.put('aduanaIngreso','in001');
        MapAux.put('codDeposito','dep01');
        MapAux.put('codigoStock','sto01');
        
        MapReview.put('listaDeSeriados',MapAux);
        MapReview.put('httpStatusCode','200');
        

        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        //for(String Cons : MapReview.keySet()){
          //  system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        //}

}

}