global without sharing class ta_care_PaymentRecord implements vlocity_cmt.VlocityOpenInterface {
    
    global ta_care_PaymentRecord(){}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try {
            if (methodName.Equals('GetPaymentRecord')) {
                GetPaymentRecord(inputMap, outMap, options);
            }
        }catch(Exception ex) {
            outMap.put('error-->', ex.getStackTraceString()); 
            result = false; 
        } 
        
        return result;
    }
    
    global void GetPaymentRecord(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        System.debug('inputMap: ' + inputMap);
        
        Map<String, String> listMedioPago = new Map<String, String>();
        listMedioPago.put('EFE','Efectivo');
        listMedioPago.put('TAR','Tarjeta de crédito');
        listMedioPago.put('CHE','Cheque');
        listMedioPago.put('CHD','Cheque diferido');
        listMedioPago.put('GPO','Giro postal'); 
        listMedioPago.put('BON','Bonos');
        listMedioPago.put('CAN','Canje publicitario');
        listMedioPago.put('RET','Retenciones');
        listMedioPago.put('DCA','Descuento de comisiones a agentes');
        listMedioPago.put('DCB','Descuento de comisiones bancarias');
        listMedioPago.put('MEP','Transferencia bancaria vía MEP');
        listMedioPago.put('PAG','Pagare');
        listMedioPago.put('CVM','Compensación mayorista');
        listMedioPago.put('TVR','Puntos TravelPass');
        listMedioPago.put('DFP','Débito próxima factura');
        listMedioPago.put('DCM','Descuento comisión mayorista');
        listMedioPago.put('PCM','Compensación minorista');
        listMedioPago.put('CHB','Cheque con boleta');
        listMedioPago.put('EFB','Efectivo con boleta');
        listMedioPago.put('DAI','Doc ajuste interno');
        listMedioPago.put('CMB','Comision bancaria');
        listMedioPago.put('PDC','Desistimiento cobro');
        listMedioPago.put('RPE','IVA');
        listMedioPago.put('CLP','Club Personal');
        listMedioPago.put('DDO','Descuento docs');
        listMedioPago.put('ACA','Ajuste Cta Agte/VT');
        listMedioPago.put('DSA','Débito saldo cliente');
        listMedioPago.put('CNC','Compensación Nota de Crédito');
        listMedioPago.put('PRE','Préstamo');
        listMedioPago.put('REC','Recarga');
        listMedioPago.put('TRA','Transferencia'); 
        listMedioPago.put('FOR','Pago forzado - Payment in force');
        listMedioPago.put('AJU','Ajuste');
        listMedioPago.put('PCR','Reverso de recarga - Payment cancellation due to recharge reversal');
        listMedioPago.put('DEB','Tarjeta de débito');
        listMedioPago.put('BNF','Bonificado');
        
        Map<String, String> estadoPago = new Map<String, String>();
        estadoPago.put('ANU','Anulado');
        estadoPago.put('MOD','Modificado');
        estadoPago.put('TRN','Transferido');
        estadoPago.put('IMP','Imputado');
        estadoPago.put('PEN','Pendiente de imputación'); 
        estadoPago.put('ERR','Pago fallido');
        
        Map<String, String> listCodPago = new Map<String, String>();
        listCodPago.put('ARS','Peso argentino');
        listCodPago.put('DOL','Dólar');
        listCodPago.put('EUR','Euro');
        listCodPago.put('EUR','Real');
        
        Map<String,Object> outMapS059 = new Map<String,Object>();

        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        if(!Test.isRunningTest()){integProcServ.invokeMethod('IFS_S059',new Map<String,Object>{'body' => inputMap.get('body')}, outMapS059, options);}

		if(Test.isRunningTest()){
			String args = '{"listaInfoPagos":{"infoPago":[{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567111","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2017-07-04 00:00:00","importePago":"300.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235435","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"300.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"string","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567813","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2017-07-05 00:00:00","importePago":"400.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876546","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"400.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"swing","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567890","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-05 00:00:00","importePago":"785.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235433","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"785.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"CHE","codMotivoRecarga":"1","infoVoucher":{"numeroSerie":"9876543"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"CHE","ultimosDigitosTarjeta":"5478","codEntidadTC":"","nombreEntidadFinanciera":"001","fechaVencimientoTarjeta":"","codSeguridadTarjeta":"","nroCheque":"1234659987","fechaEmisionCheque":"2018-01-01","cantidadCuotasTarjeta":"0"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567895","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-20 00:00:00","importePago":"436.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876543","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_VOICE_CHARGECODE","importeComprobante":"785.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"EFE","codMotivoRecarga":"1","infoVoucher":{"numeroSerie":"12345678"},"infoBanco":{"codEntidadFinanciera":"string","codSucursalEntidad":"string","codMedioPago":"EFE","ultimosDigitosTarjeta":"string","codEntidadTC":"string","nombreEntidadFinanciera":"string","fechaVencimientoTarjeta":"string","codSeguridadTarjeta":"string","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"string"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112345","idCliente":"13800010001","codSuscripcion":"13800010002","identificadorRecurso":"1140587458","txId":"1234567899","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-28 00:00:00","importePago":"300.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFT","montoCuotaConvenioCta":"0.0000","numeroComprobante":"1235435","codComprobante":"0001","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"300.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"string","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"},{"idCuenta":"1380001000112346","idCliente":"13800010001","codSuscripcion":"13800010005","identificadorRecurso":"1140587459","txId":"1234567913","tipoTransaccionPago":"OnLine","fechaAplicacionPago":"2018-01-30 00:00:00","importePago":"400.0000","codMoneda":"ARS","monedaExtranjera":{"importePago":"0.0000","codMoneda":"ARS"},"tasaDeCambio":"0.0000","listaDetallesPagos":{"detallePago":[{"tipoPago":"PFV","montoCuotaConvenioCta":"0.0000","numeroComprobante":"9876546","codComprobante":"0003","tipoItemComprobante":"","codCargo":"C_BILL_MEDIUM_CHARGE_CODE","importeComprobante":"400.0000","listaImpuestos":{"impuestos":[{"codImpuesto":"string","importeImpuestoAplicado":"string"}]},"montoDescuentoPrecioProducto":"0.0000"}]},"codMedioPago":"TAR","codMotivoRecarga":"swing","infoVoucher":{"numeroSerie":"string"},"infoBanco":{"codEntidadFinanciera":"0340","codSucursalEntidad":"040","codMedioPago":"TAR","ultimosDigitosTarjeta":"4545454545455478","codEntidadTC":"VISA","nombreEntidadFinanciera":"ICBC","fechaVencimientoTarjeta":"2023-05","codSeguridadTarjeta":"333","nroCheque":"string","fechaEmisionCheque":"string","cantidadCuotasTarjeta":"1"},"codCanal":"3","modoAcceso":"3","estadoPago":"IMP","codRespuesta":"0","codUsuario":"u591234","codGerencia":"string","userReversa":{"codUsuario":"string","codGerencia":"string"},"periodoTiempo":"Mensual","cicloVida":{"listaStatusCicloVidaAnt":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}],"ListaStatusCicloVida":[{"descripcionEstadoSuscripcion":"string","fechaExpiracionSuscripcion":"string","estadoSuscripcion":"string"}]},"infoCambioBalance":{"elementoInfoCambioBalance":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","saldoBalance":"string","nuevoBal":{"saldoBalance":"string"},"codMoneda":"ARS"}]},"infoRecargaBonus":{"listaUnidadesLibres":{"listaUnidadLibre":[{"codPaqueteUnidadesLibres":"string","codUsoUnidadesLibres":"string","descUsoUnidadesLibres":"string","codUnidadDeMedida":"string","descUnidadMedida":"string","cantUnidadesLibres":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]},"listaBalances":{"listaUnidadLibre":[{"codTipoBalance":"string","codBalance":"string","nombreBalance":"string","cantUnidadesLibres":"string","codMoneda":"string","fechaVigenciaDesdeProdAdq":"string","fechaVigenciaHastaProdAdq":"string"}]}},"listaDatosAdicionales":{"datosAdicionales":[{"nombreParametro":"string","valorParametro":"string"}]},"montoValidadoPago":"string","saldoBalance":"string","importeImpuestoAplicado":"string","codPuntoDeVenta":"string"}]}}';
			Map<String, Object> resultAux = (Map<String, Object>)JSON.deserializeUntyped(args);
			outMapS059.put('IPResult', resultAux);
			
		}	
        
        Map<String, Object> outResult =  new Map<String, Object>();
        Map<String, Object> resultS059 = (Map<String, Object>)outMapS059.get('IPResult');
        System.debug('resultS059 : '+resultS059);
        Map<String, Object> paymentsMap = (Map<String, Object>)resultS059.get('listaInfoPagos');
        System.debug('paymentsMap : '+paymentsMap);
        List<Object> payments = (List<Object>)paymentsMap.get('infoPago');
        System.debug('payments : '+payments);
        Map<String, Object> payment = (Map<String, Object>)payments[0];
        
        
        String valueEstadoPago = (String)payment.get('estadoPago');
        String valueEstPagList = estadoPago.get(valueEstadoPago);
        payment.remove('estadoPago');
        payment.put('estadoPago',valueEstPagList);
        
        String valueCodPago = (String)payment.get('codMoneda');
        String valueCodPagList = listCodPago.get(valueCodPago);
        payment.remove('codMoneda');
        payment.put('codMoneda',valueCodPagList);
        
        Object infoBancos = payment.get('infoBanco');
        
        String valueCodMedPay = (String)payment.get('codMedioPago');
        if(valueCodMedPay != null){
        if(valueCodMedPay == 'TAR'){
            List<CreditCardsBins__c> creditCardType = [SELECT Id,CredicardTypeId__c, name FROM CreditCardsBins__c WHERE name = 'AMERICAN EXPRESS'];
            String valueCreditCard = (String)((Map<String, Object>)infoBancos).get('codEntidadTC');
            if(creditCardType.size()>0 && valueCreditCard == creditCardType[0].CredicardTypeId__c){
                String numCreditTar = (String)((Map<String, Object>)infoBancos).get('ultimosDigitosTarjeta');
                String lastNumCredTar = numCreditTar.substring(11,15);
                ((Map<String, Object>)infoBancos).remove('ultimosDigitosTarjeta');
                ((Map<String, Object>)infoBancos).put('ultimosDigitosTarjeta',lastNumCredTar);
            }else{
                String numCreditTar = (String)((Map<String, Object>)infoBancos).get('ultimosDigitosTarjeta');
                String lastNumCredTar = numCreditTar.substring(13,16);
                ((Map<String, Object>)infoBancos).remove('ultimosDigitosTarjeta');
                ((Map<String, Object>)infoBancos).put('ultimosDigitosTarjeta',lastNumCredTar);
            }
        }else if(infoBancos != null){
            String numCreditTar = (String)((Map<String, Object>)infoBancos).get('ultimosDigitosTarjeta');
                ((Map<String, Object>)infoBancos).remove('ultimosDigitosTarjeta');
                ((Map<String, Object>)infoBancos).put('ultimosDigitosTarjeta','null');
                
        }
        
        String valueCodList = listMedioPago.get(valueCodMedPay);
        payment.remove('codMedioPago');
        payment.put('codMedioPago',valueCodList);
    }
        outMap.put('IPResult', resultS059);
        
    }

}