@isTest
public class MockHttpResponseGeneratorOrderController implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String headerThor = 'THORSESSIONV1=cc59e02b-c50c-4cab-aa97-d9c9881e3362; Domain=dev.ta.xom.vloc-dev.com; Path=/; HttpOnly;THORSESSIONV1=deleteMe; Domain=dev.ta.xom.vloc-dev.com; Path=/; Max-Age=0; Expires=Sun, 20-May-2018 00:36:39 GMT;THORSESSIONV1=ccc640a0-8276-4c8b-9e7f-4a1b1d803ab7; Domain=dev.ta.xom.vloc-dev.com; Path=/; HttpOnly';
        res.setHeader('Set-Cookie', headerThor);
        
        res.setBody('{"created":"2018-05-12T02:23:59.239112Z","lastTaskMovement":"2018-05-12T02:23:59.239112Z","state":"IN_PROGRESS","milestones":[],"nonMilestones":[{"name":"Conciliador","updated":"2018-05-12T02:23:59.239112Z","state":"FATALLY_FAILED","falloutDetails":"2018-05-12 02:57:13.037514+00 fatally failed: didnt complete in 600000ms","manualQueueName":"Inbox Tecnico"}]}');
        res.setStatusCode(200);
        return res;
    }

}