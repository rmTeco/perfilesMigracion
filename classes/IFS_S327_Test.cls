@isTest
private class IFS_S327_Test {
    @isTest static  void testGetCallout() {
        IFS_S327_getNumberStatusMock mock = new IFS_S327_getNumberStatusMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> MapResponse = IFS_S327_getNumberStatus.getNumberStatus(1145693266);
        Map<String,Object> MapReview = new map<String,Object>();
        
        MapReview.put('estado','e001a');
        MapReview.put('httpStatusCode','200');

        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        for(String Cons : MapReview.keySet()){
            system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }

}
}