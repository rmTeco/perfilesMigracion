@isTest
public class IFS121MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"httpStatusCode" : "200", "listaNumeros":[{"nroLinea":"1148745678","idReserva":""}]}');
        res.setStatusCode(200);
        return res;
    }
}