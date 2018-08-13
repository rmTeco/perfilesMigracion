@isTest
public class IFS_S279_changeServiceState_Test {
    @isTest static  void testGetCallout() {
        IFS_S279_changeServiceStateMock mock = new IFS_S279_changeServiceStateMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Map<String,Object> MapResponse = IFS_S279_changeServiceState.changeServiceState('00043', '28294321', 'Active');
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