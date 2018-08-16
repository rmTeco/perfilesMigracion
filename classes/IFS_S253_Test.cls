@isTest
public class IFS_S253_Test {
	@isTest static  void testGetCallout() {
        IFS_S253_Mock mock = new IFS_S253_Mock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> MapResponse = IFS_S253_getHistoryServicesProblem.getHistoryServicesProblem('tx', 'codAc', 'codSer', 'tipoServ');
        Map<String,Object> MapReview = new map<String,Object>();
        
        MapReview.put('ticket', 'ticket1');
        MapReview.put('httpStatusCode','200');
        
        system.debug('map review');
        system.debug(MapReview);
        system.debug('map response');
        system.debug(MapResponse);
        
        system.assertEquals(MapReview.size(), MapResponse.size());
        system.assertEquals(MapReview.keySet(), MapResponse.keySet());
        for(String Cons : MapReview.keySet()){
            system.assertEquals(MapReview.get(Cons), MapResponse.get(Cons));
        }
        
    }
}