@isTest
public class OrderControllerMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"codigoResultado":"OK"}');
        res.setStatusCode(200);
        return res;
    }
}