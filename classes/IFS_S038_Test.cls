@isTest
private class IFS_S038_Test {
    @isTest static  void testGetCallout() {
        IFS_S038_updateCycleMock mock = new IFS_S038_updateCycleMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> MapResponse = IFS_S038_updateCycle.updateCycle('001', '28294321');
        Map<String,Object> MapReview = new map<String,Object>();
        
        MapReview.put('codError','e001');
        MapReview.put('httpStatusCode','200');

        //system.assertEquals(MapReview.size(), MapResponse.size());
        //system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        for(String Cons : MapReview.keySet()){
            system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }

}
}