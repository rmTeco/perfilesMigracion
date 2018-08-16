@IsTest
public class ta_care_queryRefillsHelper_test {
    @IsTest static void invoke_GetRefillHistory_empty(){
        String methodName = 'GetRefillHistory';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        ta_care_queryRefillsHelper testedClass = new ta_care_queryRefillsHelper();
        
        String jsonInputString = '{"body":{"cantidadItemsConsulta":"5", "cantidadMaxConsulta":"5", "fechaDesde":"2018-06-15 00:00:00", "fechaHasta":"2018-06-18 00:00:00", "referenciaItemPaginado":"0", "resultado":{"codigoAccesoSuscriptor":{"identificadorRecurso":"3435161523"}}}, "codSuscript":"3435161523"}';
        String jsonString = '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        Map<String, Object> outMap2 = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        Map<String, Object> inputMap1 = (Map<String, Object>) JSON.deserializeUntyped(jsonInputString);
        outMap.put('IPResult', outMap2);
        System.debug('inputMap1 _ _ ' + inputMap1);
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap1, outMap, options);
        Test.stopTest();
        
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        List<Object> refills = (List<Object>)result.get('ListInfoRecarga');
        Map<String,Object> recordMap = (Map<String,Object>) refills[0]; 
        
        System.debug(' recordMap_' +  recordMap.get('Bonus'));
        //System.assertEquals('Con Beneficios', recordMap.get('Bonus'));
    }

}