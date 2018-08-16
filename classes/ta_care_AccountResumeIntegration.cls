/**
* Created by Kleytman Aular 2018-01-18
*
* Implements VlocityOpenInterface
* Provides the needed logic to support OS JSON VOI translation
*
* Objects: None - JSON translation for OS
*
* Important: The method uses a VlocityOpenInterface integration structure
*
* Version: 1.0
*/

global without sharing class ta_care_AccountResumeIntegration implements vlocity_cmt.VlocityOpenInterface {
    
    global ta_care_AccountResumeIntegration(){}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try {
            if (methodName.Equals('GetAccountResumeIntegration')) {
                GetAccountResumeIntegration(inputMap, outMap, options);
            }
            if (methodName.Equals('GetAccountResumeIntegration2')) {
                GetAccountResumeIntegration2(inputMap, outMap, options);
            }
            if (methodName.Equals('GetAccountResumeIntegration3')) {
                GetAccountResumeIntegration3(inputMap, outMap, options);
            }
        }catch(Exception ex) {
            outMap.put('error', ex.getStackTraceString()); 
            System.debug('ex --> '+ex);
            result = false; 
        } 
        
        return result;
    }
    
    global void GetAccountResumeIntegration(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        inputMap = ( Map<string, Object>)inputMap.get('body');
        Map<String,Object> inputMapS018 = new Map<String,Object>();
        Map<String,Object> inputMapS024 = new Map<String,Object>();
        Map<String,Object> inputMapS059 = new Map<String,Object>();
        
        inputMapS018.put('body', inputMap.get('bodyS018'));
        inputMapS024.put('body', inputMap.get('bodyS024'));
        inputMapS059.put('body', inputMap.get('bodyS059'));

        System.debug(inputMapS018);
        System.debug(inputMapS024);
        System.debug(inputMapS059);

        Map<String,Object> outMapS018 = new Map<String,Object>();
        Map<String,Object> outMapS024 = new Map<String,Object>();
        Map<String,Object> outMapS059 = new Map<String,Object>();

        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S018', inputMapS018, outMapS018, options);}
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S024', inputMapS024, outMapS024, options);}
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S059', inputMapS059, outMapS059, options);}

        System.debug(outMapS018);
        System.debug(outMapS024);
        System.debug(outMapS059);

        Map<String, Object> resultS018 = (Map<String, Object>)outMapS018.get('IPResult');
        Map<String, Object> resultS024 = (Map<String, Object>)outMapS024.get('IPResult');
        Map<String, Object> resultS059 = (Map<String, Object>)outMapS059.get('IPResult');
        
        Map<String, Object> outResult = new Map<String, Object>();
        
        outResult.put('datosBalance', resultS018);
        outResult.put('datosFacturas', resultS024);
        outResult.put('datosPagos', resultS059);

        outMap.put('IPResult', outResult);

        
               
    }
    
    global void GetAccountResumeIntegration2(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        inputMap = (Map<string, Object>)inputMap.get('body');
        System.debug('inputMap: ' + inputMap);

        Map<String,Object> outMapS018 = new Map<String,Object>();
        Map<String,Object> outMapS024 = new Map<String,Object>();
        Map<String,Object> outMapS059 = new Map<String,Object>();

        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S018',new Map<String,Object>{'body' => inputMap.get('bodyS018')}, outMapS018, options);}
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S024',new Map<String,Object>{'body' => inputMap.get('bodyS024')}, outMapS024, options);}
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S059',new Map<String,Object>{'body' => inputMap.get('bodyS059')}, outMapS059, options);}

		if(Test.isRunningTest()){
			String args = '{"listaInfoFactura":[{"numTotalRegistros":"string","codRazon":"string","rutaFactura":"string","numSuscriptor":"1380001003300004","direccionCliente":"Av. Congreso 3940","nombreActor":"Juan Perez","listaInfoDetalleFactura":[{"codEstadoComprobante":"O","codMoneda":"ARS","importeEnDisputa":"0.0000","importeComprobanteImpago":"500.0000","importeComprobante":"500.0000","codCargo":"string","tipoCargo":"recurrente","codComprobante":"10006200230001"}],"codEstadoComprobante":"O","fechaCierreComprobante":"2018-02-01 00:00:00","fechaVencimientoComprobante":"2018-02-10 00:00:00","fechaEmisionComprobante":"2018-01-02 00:00:00","codMoneda":"ARS","importeEnDisputa":"0.0000","importePendienteImpuestoFactura":"0.0000","importeImpuestoFactura":"230.23000","importeComprobanteImpago":"1050.7800","importeComprobante":"1050.7800","fechaCorteFacturacion":"2018-01-31 00:00:00","fechaInicioFacturacion":"2018-01-01 00:00:00","cicloFacturacion":"20180101","numeroComprobanteLegal":"0001A12345678","numeroComprobante":"10006200230001","codComprobante":"10006200230001","codAccionNegocio":"Orden de Prod","identificadorRecurso":"13800010010","codSuscripcion":"1380001003300004","codCliente":"1380001003300002","idCuenta":"1380001003300001"},{"numTotalRegistros":"string","codRazon":"string","rutaFactura":"string","numSuscriptor":"1380001003300003","direccionCliente":"Av. Congreso 3940","nombreActor":"Juan Perez","listaInfoDetalleFactura":[{"codEstadoComprobante":"O","codMoneda":"ARS","importeEnDisputa":"0.0000","importeComprobanteImpago":"400.0000","importeComprobante":"400.0000","codCargo":"string","tipoCargo":"recurrente","codComprobante":"10006200230041"},{"codEstadoComprobante":"C","codMoneda":"ARS","importeEnDisputa":"0.0000","importeComprobanteImpago":"570.7800","importeComprobante":"570.7800","codCargo":"string","tipoCargo":"recurrente","codComprobante":"10006200230044"}],"codEstadoComprobante":"C","fechaCierreComprobante":"2017-01-01 00:00:00","fechaVencimientoComprobante":"2017-12-10 00:00:00","fechaEmisionComprobante":"2017-12-02 00:00:00","codMoneda":"ARS","importeEnDisputa":"0.0000","importePendienteImpuestoFactura":"0.0000","importeImpuestoFactura":"130.23000","importeComprobanteImpago":"970.7800","importeComprobante":"970.7800","fechaCorteFacturacion":"2017-11-31 00:00:00","fechaInicioFacturacion":"2017-11-01 00:00:00","cicloFacturacion":"20171201","numeroComprobanteLegal":"0001A12344232","numeroComprobante":"10006200230221","codComprobante":"10006200230221","codAccionNegocio":"Orden de Prod","identificadorRecurso":"13800010110","codSuscripcion":"1380001003300014","codCliente":"1380001003300002","idCuenta":"1380001003300001"}]}';
			Map<String, Object> resultAux = (Map<String, Object>)JSON.deserializeUntyped(args);
			outMapS024.put('IPResult', resultAux);
			args = '{"listaInfoPagos":{"infoPago":[{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567111","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2017-07-04 00:00:00","importePago":"300.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235435","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"300.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"string","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567813","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2017-07-05 00:00:00","importePago":"400.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876546","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"400.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"swing","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567890","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-05 00:00:00","importePago":"785.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235433","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"785.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"CHE","codMotivoRecarga":"1","infoVoucher":{"numeroSerie":"9876543"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"CHE","ultimosDigitosTarjeta":"5478","codEntidadTC":"","nombreEntidadFinanciera":"001","fechaVencimientoTarjeta":"","codSeguridadTarjeta":"","nroCheque":"1234659987","fechaEmisionCheque":"2018-01-01","cantidadCuotasTarjeta":"0"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567895","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-20 00:00:00","importePago":"436.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876543","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"785.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"EFE","codMotivoRecarga":"1","infoVoucher":{"numeroSerie":"12345678"},"infoBanco":{"codEntidadFinanciera":"string","codSucursalEntidad":"string","codMedioPago":"EFE","ultimosDigitosTarjeta":"string","codEntidadTC":"string","nombreEntidadFinanciera":"string","fechaVencimientoTarjeta":"string","codSeguridadTarjeta":"string","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"string"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567899","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-28 00:00:00","importePago":"300.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235435","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"300.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"string","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567913","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-30 00:00:00","importePago":"400.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876546","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"400.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"swing","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"}]}}';
			resultAux = (Map<String, Object>)JSON.deserializeUntyped(args);
			outMapS059.put('IPResult', resultAux);
			
		}	
	
        Map<String, Object> outResult =  new Map<String, Object>{'datosBalance' => (Map<String, Object>)outMapS018.get('IPResult')};
        Map<String, Object> resultS024 = (Map<String, Object>)outMapS024.get('IPResult');
        Map<String, Object> resultS059 = (Map<String, Object>)outMapS059.get('IPResult');

        List<Object> invoices = (List<Object>)resultS024.get('listaInfoFactura');
        Map<String, Object> paymentsMap = (Map<String, Object>)resultS059.get('listaInfoPagos');
        List<Object> payments = (List<Object>)paymentsMap.get('infoPago');
        List<Object> transactions = new List<Object>();
        
        for (Object t : invoices){
            Map<String, Object> tMap = (Map<String, Object>)t;
            Map<String, Object> tMap2 = new Map<String, Object>();
            tMap2.put('fechaEmisionComprobante', tMap.get('fechaEmisionComprobante'));
            tMap2.put('fechaVencimientoComprobante', tMap.get('fechaVencimientoComprobante'));
            tMap2.put('tipoDocumento', tMap.get('codAccionNegocio'));
            tMap2.put('numeroComprobanteLegal', tMap.get('numeroComprobanteLegal'));
            tMap2.put('importeComprobante', tMap.get('importeComprobante'));
            tMap2.put('Acumulado', 0);
            tMap2.put('originalData', tMap);
            transactions.add(tMap2);
        }
        
        for (Object p : payments){
            Map<String, Object> pMap = (Map<String, Object>)p;
            Map<String, Object> pMap2 = new Map<String, Object>();
            pMap2.put('fechaEmisionComprobante', pMap.get('fechaAplicacionPago'));
            pMap2.put('fechaVencimientoComprobante', pMap.get('fechaAplicacionPago'));
            pMap2.put('tipoDocumento', pMap.get('tipoTransaccionPago'));
            pMap2.put('numeroComprobanteLegal', pMap.get(''));
            pMap2.put('importeComprobante', pMap.get('importePago'));
            pMap2.put('Acumulado', 0);
            pMap2.put('originalData', pMap);
            transactions.add(pMap2);
        }
        
        outResult.put('transacciones', transactions);
        outMap.put('IPResult', outResult);
        
    }
    
    global void GetAccountResumeIntegration3(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        try{
        inputMap = (Map<string, Object>)inputMap.get('body');
        System.debug('inputMap: ' + inputMap);

        Map<String,Object> outMapS018 = new Map<String,Object>();
        Map<String,Object> outMapS024 = new Map<String,Object>();
        Map<String,Object> outMapS059 = new Map<String,Object>();

        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        Map<String, Object> outResult =  new Map<String, Object>();
        if(!Test.isRunningTest()){
            
            integProcServ.invokeMethod('IFS_S018',new Map<String,Object>{'body' => inputMap.get('bodyS018')}, outMapS018, options);
            Map<String, Object> resultS018 = (Map<String, Object>)outMapS018.get('IPResult');
            if(resultS018.get('detalle') == null)
            {
                System.debug('outMapS018: '+ String.valueOf(outMapS018));
                outResult.put('datosBalance', (Map<String, Object>)outMapS018.get('IPResult'));
            }
            else
            {
                outResult.put('datosBalance', 'Sin datos');
            }
            integProcServ.invokeMethod('IFS_S024',new Map<String,Object>{'body' => inputMap.get('bodyS024')}, outMapS024, options);
            Map<String, Object> resultS024 = (Map<String, Object>)outMapS024.get('IPResult');
            if(resultS024.get('detalle') == null)
            {
                outResult.put('comprobantes', (Map<String, Object>)outMapS024.get('IPResult'));
            }
            else
            {
                System.debug('outMapS024: '+ String.valueOf(outMapS024));
                outResult.put('comprobantes', 'Sin datos');
            }
            
            integProcServ.invokeMethod('IFS_S059',new Map<String,Object>{'body' => inputMap.get('bodyS059')}, outMapS059, options);
            Map<String, Object> resultS059 = (Map<String, Object>)outMapS059.get('IPResult');
            if(resultS059.get('detalle') == null)
            {
                System.debug('outMapS059: '+ String.valueOf(outMapS059));
                outResult.put('pagos', (Map<String, Object>)outMapS059.get('IPResult'));
            }
            else
            {
                outResult.put('pagos', 'Sin datos');
            }
        }

        System.debug('outMapS018'+outMapS018);
        System.debug('outMapS024'+outMapS024);
        System.debug('outMapS059'+outMapS059);
        
		if(Test.isRunningTest()){
			String args = '{"listaInfoFactura":[{"numTotalRegistros":"string","codRazon":"string","rutaFactura":"string","numSuscriptor":"1380001003300004","direccionCliente":"Av. Congreso 3940","nombreActor":"Juan Perez","listaInfoDetalleFactura":[{"codEstadoComprobante":"O","codMoneda":"ARS","importeEnDisputa":"0.0000","importeComprobanteImpago":"500.0000","importeComprobante":"500.0000","codCargo":"string","tipoCargo":"recurrente","codComprobante":"10006200230001"}],"codEstadoComprobante":"O","fechaCierreComprobante":"2018-02-01 00:00:00","fechaVencimientoComprobante":"2018-02-10 00:00:00","fechaEmisionComprobante":"2018-01-02 00:00:00","codMoneda":"ARS","importeEnDisputa":"0.0000","importePendienteImpuestoFactura":"0.0000","importeImpuestoFactura":"230.23000","importeComprobanteImpago":"1050.7800","importeComprobante":"1050.7800","fechaCorteFacturacion":"2018-01-31 00:00:00","fechaInicioFacturacion":"2018-01-01 00:00:00","cicloFacturacion":"20180101","numeroComprobanteLegal":"0001A12345678","numeroComprobante":"10006200230001","codComprobante":"10006200230001","codAccionNegocio":"Orden de Prod","identificadorRecurso":"13800010010","codSuscripcion":"1380001003300004","codCliente":"1380001003300002","idCuenta":"1380001003300001"},{"numTotalRegistros":"string","codRazon":"string","rutaFactura":"string","numSuscriptor":"1380001003300003","direccionCliente":"Av. Congreso 3940","nombreActor":"Juan Perez","listaInfoDetalleFactura":[{"codEstadoComprobante":"O","codMoneda":"ARS","importeEnDisputa":"0.0000","importeComprobanteImpago":"400.0000","importeComprobante":"400.0000","codCargo":"string","tipoCargo":"recurrente","codComprobante":"10006200230041"},{"codEstadoComprobante":"C","codMoneda":"ARS","importeEnDisputa":"0.0000","importeComprobanteImpago":"570.7800","importeComprobante":"570.7800","codCargo":"string","tipoCargo":"recurrente","codComprobante":"10006200230044"}],"codEstadoComprobante":"C","fechaCierreComprobante":"2017-01-01 00:00:00","fechaVencimientoComprobante":"2017-12-10 00:00:00","fechaEmisionComprobante":"2017-12-02 00:00:00","codMoneda":"ARS","importeEnDisputa":"0.0000","importePendienteImpuestoFactura":"0.0000","importeImpuestoFactura":"130.23000","importeComprobanteImpago":"970.7800","importeComprobante":"970.7800","fechaCorteFacturacion":"2017-11-31 00:00:00","fechaInicioFacturacion":"2017-11-01 00:00:00","cicloFacturacion":"20171201","numeroComprobanteLegal":"0001A12344232","numeroComprobante":"10006200230221","codComprobante":"10006200230221","codAccionNegocio":"Orden de Prod","identificadorRecurso":"13800010110","codSuscripcion":"1380001003300014","codCliente":"1380001003300002","idCuenta":"1380001003300001"}]}';
			Map<String, Object> resultAux = (Map<String, Object>)JSON.deserializeUntyped(args);
			outMapS024.put('IPResult', resultAux);
			args = '{"listaInfoPagos":{"infoPago":[{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567111","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2017-07-04 00:00:00","importePago":"300.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235435","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"300.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"string","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567813","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2017-07-05 00:00:00","importePago":"400.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876546","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"400.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"swing","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567890","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-05 00:00:00","importePago":"785.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235433","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"785.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"CHE","codMotivoRecarga":"1","infoVoucher":{"numeroSerie":"9876543"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"CHE","ultimosDigitosTarjeta":"5478","codEntidadTC":"","nombreEntidadFinanciera":"001","fechaVencimientoTarjeta":"","codSeguridadTarjeta":"","nroCheque":"1234659987","fechaEmisionCheque":"2018-01-01","cantidadCuotasTarjeta":"0"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567895","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-20 00:00:00","importePago":"436.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876543","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"785.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"EFE","codMotivoRecarga":"1","infoVoucher":{"numeroSerie":"12345678"},"infoBanco":{"codEntidadFinanciera":"string","codSucursalEntidad":"string","codMedioPago":"EFE","ultimosDigitosTarjeta":"string","codEntidadTC":"string","nombreEntidadFinanciera":"string","fechaVencimientoTarjeta":"string","codSeguridadTarjeta":"string","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"string"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567899","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-28 00:00:00","importePago":"300.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235435","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"300.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"string","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567913","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-30 00:00:00","importePago":"400.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876546","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"400.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"swing","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"}]}}';
			resultAux = (Map<String, Object>)JSON.deserializeUntyped(args);
			outMapS059.put('IPResult', resultAux);
			
		}	
       
        /*Map<String, Object> outResult =  new Map<String, Object>{'datosBalance' => (Map<String, Object>)outMapS018.get('IPResult')};
		outResult.put('comprobantes', (Map<String, Object>)outMapS024.get('IPResult'));
		outResult.put('pagos', (Map<String, Object>)outMapS059.get('IPResult'));*/
        outMap.put('IPResult', outResult);
            System.debug('outMap --> '+outMap);

        }catch(Exception ex)
        {
            System.debug('Ocurrio un error en ta_care_AccountResumeIntegration.GetAccountResumeIntegration3');
            throw ex;
        }
    }
    
/*
    global void GetAccountResumeIntegrationTester(){
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        
        Object args = (Object)'{"bodyS018":{"codigoCuentaAcceso":{"codCuenta":"1380001003300001"}},"bodyS059":{"accesoCuenta":{"identificadorRecurso":"string","idCuenta":"1380001003300001","codCuenta":"1380001003300001","condicionPago":"string"},"txid":"123456","cantidadItemsConsulta":0,"referenciaItemPaginado":0,"cantidadMaxConsulta":0,"fechaDesde":"2018-01-01 00:00:00","fechaHasta":"2018-01-31 00:00:00"},"bodyS024":{"codAcceso":{"codAccesoCuenta":{"identificadorRecurso":"","idCuenta":"1380001003300001","codCuenta":"1380001003300001"},"condicionPago":"2"},"tipoConsulta":{"cicloFacturacion":"20180101","periodoTiempo":{"fechaDesde":"2018-01-01 00:00:00","fechaHasta":"2018-01-31 00:00:00","tipoConsulta":"1"},"consultaPendientes":"Y"},"numTotalRegistros":"string","numRegistroInicial":"string","cantRegistrosMostrar":"string"}}';
        
        inputMap.put('body',args);
        
        System.debug('Inputmap: ' + inputMap);
        
        GetAccountResumeIntegration(inputMap, outMap, options);
    }
    
*/

}