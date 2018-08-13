@isTest
private class IFS_S238_Test {
    @isTest static  void testGetCallout() {
        IFS_S238_getCPEModemInformationMock mock= new IFS_S238_getCPEModemInformationMock();
        mock.status=201;        
        Test.setMock(HttpCalloutMock.class, mock);
        
        Map<String,Object> MapResponse = IFS_S238_getCPEModemInformation.getCPEModemInformation('StringTest');   
        
        Map<String,Object> MapReview = new map<String,Object>();
        
        MapReview.put('return','retorno1');
        MapReview.put('httpStatusCode','201');

        
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        
        for(String Cons : MapReview.keySet()){
          system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }
        
         MapReview.equals(MapResponse);  
    }
}