@isTest
global class IFS_S141_getRefillHistoryMockOk implements HttpCalloutMock {
    public Integer status {get;set;}
        // Implement this interface method
         global HTTPResponse respond(HTTPRequest request)  {
        
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
       // String jsonString='{"codError":"e001", "descError":"descripcion1"}'; respuesta
       // String jsonString='{"body":{"resultado":{"codigoDeAcceso":{"identificadorRecurso":"3435161523"}},"cantidadItemsConsulta":"0","referenciaItemPaginado":"0","cantidadMaxConsulta":"5","fechaDesde":"2017-10-10 00:00:00","fechaHasta":"2017-11-08 00:00:00"}}';
        String jsonString= '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        system.debug(responseNode);
        response.setBody(jsonString);
        
        
        response.setStatusCode(status);
        return response; 
    }
    
}