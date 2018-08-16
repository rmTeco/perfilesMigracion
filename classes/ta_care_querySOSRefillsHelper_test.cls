@isTest
public class ta_care_querySOSRefillsHelper_test {
    
    @IsTest static void invoke_GetRefillSOSHistory_empty(){
        String methodName = 'GetRefillSOSHistory';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        String jsonInputString = '{"body":{"codigoAcceso":{"codSuscripcion":"string", "identificadorRecurso":"13800001139"}, "listaDatosAdicionales":[{"nombreParametro":"string", "valorParametro":"string"}]}, "codSuscript":"13800001139"}';
        String ipRes2 = '{"resumenPrestamo":{"pagoTotalParcial":"3200","marcaEnListaNegra":"N","fechaIngresoListaNegra":"","listaDatosAdicionales":[{"nombreParametro":"C_USAGEAMOUNT","valorParametro":"0"}]},"listaDetallePrestamo":[{"txId":"21212121212121212121212121212121","montoPrestamo":"754","fechaAltaProductoAdq":"2015-06-10 10:10:10","cargoUso":"123.45","precioProducto":"754","estadoPrestamoAdq":"C","importePago":"20","importePrestamoImpago":"754","fechaVtoPagoPrestamo":"2016-03-01","codPaqueteUnidadesLibres":"02","tipoUnidadesLibres":"string","cantUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","fechaVigenciaHastaProdAdq":"2016-12-31"},{"txId":"65656565656656565656565656565656","montoPrestamo":"20","fechaAltaProductoAdq":"2017-01-10 10:10:10","cargoUso":"1500","precioProducto":"1500","estadoPrestamoAdq":"C","importePago":"20","importePrestamoImpago":"1500","fechaVtoPagoPrestamo":"2017-10-01","codPaqueteUnidadesLibres":"03","tipoUnidadesLibres":"string","cantUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","fechaVigenciaHastaProdAdq":"2017-12-31"}],"listaDetalleReembolso":[{"montoPrestamo":"20","fechaAltaProductoAdq":"2015-06-10 10:10:10","fechaPago":"2017-09-01","formaCancelacionPrestamo":"RECARGA"},{"montoPrestamo":"20","fechaAltaProductoAdq":"2017-01-10 10:10:10","fechaPago":"2017-10-01","formaCancelacionPrestamo":"RECARGA"}]}';
        Map<String, Object> outMap2 = (Map<String, Object>)JSON.deserializeUntyped(ipRes2);
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonInputString);
        outMap.put('IPResult',outMap2);
        System.debug('Result - Input -'+input );
        ta_care_querySOSRefillsHelper testedClass = new ta_care_querySOSRefillsHelper();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
		
        system.debug('outMap: '+outMap);
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        List<Object> refillsSOS = (List<Object>)result.get('listaDetallePrestamo');
		Map<String,Object> recordMap = (Map<String,Object>) refillsSOS[0]; 
		
        System.assertEquals('Cerrado', recordMap.get('estado'));
    }
    
    @IsTest static void invoke_GetRefillSOSHistory_error(){
        String methodName = 'GetRefillSOSHistory';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        String jsonInputString = '{"body":{"codigoAcceso":{"codSuscripcion":"string", "identificadorRecurso":"13800001139"}, "listaDatosAdicionales":[{"nombreParametro":"string", "valorParametro":"string"}]}, "codSuscript":"13800001139"}';
        String ipRes2 = '{"detalle": [{"mensaje": "Codigo: VAL0382505 - xxxxxxxxxxxxxxxxxxx","campo": "Error"},{"mensaje": "MDWOSB12 TST1 - mdwtpbust1.**o","campo": "Backend"},{"mensaje": "373025427","campo": "txId"}],"mensaje": "La validacion del Schema no fue exitosa","codigo": "DP-382505"}';
        Map<String, Object> outMap2 = (Map<String, Object>)JSON.deserializeUntyped(ipRes2);
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonInputString);
        outMap.put('IPResult',outMap2);
        System.debug('Result - Input -'+input );
        ta_care_querySOSRefillsHelper testedClass = new ta_care_querySOSRefillsHelper();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
		
        system.debug('outMap: '+outMap);
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        System.debug('detalle result: ' + result);
        System.debug('detalle error: ' + result.get('detalle'));
        List<Object> errorSOS = (List<Object>)result.get('detalle');
		
        //System.assert(errorSOS != null);
    }
    
    @IsTest static void test_getPacksHistoryDetail(){
        String methodName = 'getPacksHistoryDetail';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        String jsonInputString = '{"body":{"codigoAcceso":{"codSuscripcion":"string", "identificadorRecurso":"13800001139"}, "listaDatosAdicionales":[{"nombreParametro":"string", "valorParametro":"string"}]}, "codSuscript":"13800001139"}';
        String ipRes2 = '{"detalleDeMovimientosLista": { "elementoDetalleDeMovimientos": [{"descripcionTipoEvento": "Recarga","numeroOrigen": "1520603333","nombreProducto": "Plan Nacional","fechaHoraFinTrafico": "2016-09-03 14:24:00","fechaTasacionTrafico": "2016-09-03 14:12:00","importeTasado": "18.3400","detalleDeUnidadesLibresTasadasLista": {"elementoDetalleDeUnidadesLibresTasada": {"codUsoUnidadesLibres": "02","cantUnidadesLibresTas": "8",      "codUnidadDeMedida": "VECES","fechaVigenciaHastaProdAdq": "2017-11-08 15:00:00","nombreProducto": "","codProducto": ""}},"promocionTasadaLista": { "codTipoBalance": "2244","saldoBalance": "15.0000","fechaVigenciaHastaProdAdq": "20160905","nombreProducto": "PRT-006T","codProducto": "001050145744"},"saldoBalance": "521","saldoSuscripcionComprado": "20","descripcion": "Recarga"}]}}';
        Map<String, Object> outMap2 = (Map<String, Object>)JSON.deserializeUntyped(ipRes2);
        Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonInputString);
        outMap.put('IPResult',outMap2);
        System.debug('Result - Input -'+input );
        ta_care_querySOSRefillsHelper testedClass = new ta_care_querySOSRefillsHelper();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
		
        System.debug('outMap: '+outMap);
     
    }

}