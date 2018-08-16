@isTest
global class IFS_S139_DetalleDeMovimientosMock implements HttpCalloutMock {
    public Integer status {get;set;}
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        String jsonString = '{"detalleDeMovimientosLista":{"elementoDetalleDeMovimientos": [{"descripcionTipoEvento": "Recarga","numeroOrigen": "1520603333","nombreProducto": "Plan Nacional","fechaHoraFinTrafico": "2016-09-03 14:24:00","fechaTasacionTrafico": "2016-09-03 14:12:00","importeTasado": "18.3400","detalleDeUnidadesLibresTasadasLista":{"elementoDetalleDeUnidadesLibresTasada": {"codUsoUnidadesLibres": "02","cantUnidadesLibresTas": "8","codUnidadDeMedida": "VECES","fechaVigenciaHastaProdAdq": "2017-11-08 15:00:00","nombreProducto": "","codProducto": ""}},"promocionTasadaLista": {"codTipoBalance": "2244","saldoBalance": "15.0000","fechaVigenciaHastaProdAdq": "20160905","nombreProducto": "PRT-006T","codProducto": "001050145744"},"saldoBalance": "521","saldoSuscripcionComprado": "20","descripcion": "Recarga"}],"cantidadItemsConsulta": "3","referenciaItemPaginado": "0","cantidadMaxConsulta": "2"}}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        response.setStatusCode(status);
        return response;
    }
}