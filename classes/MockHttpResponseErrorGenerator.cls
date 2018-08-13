@isTest(seeAllData = false)
public with sharing class MockHttpResponseErrorGenerator implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake error response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Status":"ERROR", "mensaje":"Error en el llamado al servicio"}');
        res.setStatusCode(500);
        return res;
    }
}