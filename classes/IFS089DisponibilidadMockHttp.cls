@isTest
public class IFS089DisponibilidadMockHttp implements HttpCalloutMock {
    // Implement this interface method
    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"listaExistencias":[{"codNMU":"PTNG","marcaProducto":"TP","codFamiliaProducto":"TAN","codDeposito":"CS0134001","listaPorCodigoStock":[{"stockProducto":"MTPL","cantidadExistente":"10","cantidadDisponible":"0"},{"stockProducto":"MTRE","cantidadExistente":"2","cantidadDisponible":"2"}]},{"codNMU":"PGPSGP98I","marcaProducto":"TP","codFamiliaProducto":"S16","codDeposito":"CS0134001","listaPorCodigoStock":[{"stockProducto":"MTPL","cantidadExistente":"10","cantidadDisponible":"5"},{"stockProducto":"MTRE","cantidadExistente":"2","cantidadDisponible":"2"}]},{"codNMU":"PGP00001I","marcaProducto":"TP","codFamiliaProducto":"S64","codDeposito":"CS0134001","listaPorCodigoStock":[{"stockProducto":"MTPL","cantidadExistente":"2","cantidadDisponible":"0"},{"stockProducto":"MTRE","cantidadExistente":"0","cantidadDisponible":"0"}]}]}');
        res.setStatusCode(200);
        return res;
    }
}