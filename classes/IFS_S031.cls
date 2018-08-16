global class IFS_S031 implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('test')){
                test(inputMap, outMap, options);
            }
            
            result = false;  
        } 
        catch(Exception e)
        {
            throw e; 
            //result = false;
        }
        return result;
    }
    
    
     global static void test(map<String,Object> input, map<String,Object> output, map<String,Object> options){
       
       List <vlocity_cmt__PaymentAdjustment__c> payments = new List <vlocity_cmt__PaymentAdjustment__c>();
       String orderID = (String)input.get('IdOrder');
       
       Order orden = [select id, Account.AccountIntegrationId__c from Order where id =: orderID];
       
       payments = [select id from vlocity_cmt__PaymentAdjustment__c where Order__c =: orderID];
       
       Map<String,Object> body = new Map<String,Object>();
       
       //Map<String,Object> AccesoPorSubscriptor = new Map<String,Object>();
       //AccesoPorSubscriptor.put('codSuscripcion', '20140527145411');
       //body.put('accesoPorSubscriptor', AccesoPorSubscriptor);
       
       Map<String,Object> AccesoPorCuenta = new Map<String,Object>();
       //AccesoPorCuenta.put('identificadorRecurso','COMPLETAR');
       AccesoPorCuenta.put('idCuenta', orden.Account.AccountIntegrationId__c);
       //AccesoPorCuenta.put('codCuenta', 'COMPLETAR');
       //AccesoPorCuenta.put('condicionPago', 'COMPLETAR');
       body.put('accesoPorCuenta', AccesoPorCuenta);
       
       body.put('codAjuste', 'COMPLETAR');
       body.put('tipoOperacionAjuste', '1');
       body.put('codMotivoAjuste', '4');
       
       
       List<Map<String,Object>> listaAjusteBalance = new List<Map<String,Object>>();
       List<Map<String,Object>> listaAjusteUnidadesLibres = new List<Map<String,Object>>();
       List<Map<String,Object>> facturas = new List<Map<String,Object>>();
       List<Map<String,Object>> datosAdicionales = new List<Map<String,Object>>();
       List<Map<String,Object>> aplicarCompensacion = new List<Map<String,Object>>();
       
       
       for(vlocity_cmt__PaymentAdjustment__c pago : payments){
           
       Map<String,Object> listaAjusteBalanceObjeto = new Map<String,Object>();
       listaAjusteBalanceObjeto.put('codTipoBalance','C_MAIN_ACCOUNT');
       listaAjusteBalanceObjeto.put('codBalance','1123243343');
       listaAjusteBalanceObjeto.put('tipoAjuste','CREDITO');
       listaAjusteBalanceObjeto.put('montoAjuste', '324');
       listaAjusteBalanceObjeto.put('codMoneda', 'ARS');
       listaAjusteBalanceObjeto.put('fechaAjusteVigenciaDesde','2017-11-07 16:30:33');
       listaAjusteBalanceObjeto.put('fechaAjusteVigenciaHasta','2017-11-07 16:30:34');
       
       listaAjusteBalance.add(listaAjusteBalanceObjeto);
       
       Map<String,Object> listaAjusteUnidadesLibresObjeto = new Map<String,Object>();
       listaAjusteUnidadesLibresObjeto.put('codPaqueteUnidadesLibres','COMPLETAR');
       listaAjusteUnidadesLibresObjeto.put('codUsoUnidadesLibres','COMPLETAR');
       listaAjusteUnidadesLibresObjeto.put('tipoAjuste','CREDITO');
       listaAjusteUnidadesLibresObjeto.put('montoAjuste', 'COMPLETAR');
       listaAjusteUnidadesLibresObjeto.put('fechaAjusteVigenciaDesde','COMPLETAR');
       listaAjusteUnidadesLibresObjeto.put('fechaAjusteVigenciaHasta','COMPLETAR');
       
       listaAjusteUnidadesLibres.add(listaAjusteUnidadesLibresObjeto);
       
       Map<String,Object> listaFacturasObjeto = new Map<String,Object>();
       listaFacturasObjeto.put('numeroComprobante','COMPLETAR');
       listaFacturasObjeto.put('tipoItemComprobante','COMPLETAR');
       listaFacturasObjeto.put('tipoAjuste','CREDITO');
       listaFacturasObjeto.put('montoAjuste', 'COMPLETAR');
       listaFacturasObjeto.put('codMoneda','ARS');
       listaFacturasObjeto.put('cicloFacturacion','COMPLETAR');
       listaFacturasObjeto.put('fechaVencimientoFacturacion','COMPLETAR');
       
       facturas.add(listaFacturasObjeto);
           
           
       Map<String,Object> listaDatosAdicionalesObjeto = new Map<String,Object>();
       listaDatosAdicionalesObjeto.put('nombreParametro','COMPLETAR');
       listaDatosAdicionalesObjeto.put('valorParametro','COMPLETAR');
       
       datosAdicionales.add(listaDatosAdicionalesObjeto);
       
       
       Map<String,Object> aplicarCompensacionObjeto = new Map<String,Object>();
       
       aplicarCompensacionObjeto.put('fechaInterrupcionDesde', 'COMPLETAR');
       aplicarCompensacionObjeto.put('fechaInterrupcionHasta', 'COMPLETAR');
       aplicarCompensacionObjeto.put('porcentajeAjuste', 'COMPLETAR');
       
       Map<String,Object> producto = new Map<String,Object>();
       producto.put('codProducto', 'COMPLETAR');
       producto.put('secuenciaProductoAdquirido', 'COMPLETAR');
       
       aplicarCompensacionObjeto.put('producto', producto);
       
       aplicarCompensacion.add(aplicarCompensacionObjeto);
           
       }
       
       body.put('listaAjusteBalance', listaAjusteBalance);
       body.put('listaAjusteUnidadesLibres', listaAjusteUnidadesLibres);
       body.put('listaFacturas', facturas);
       body.put('listaDatosAdicionales', datosAdicionales);
       body.put('aplicarCompensacion', aplicarCompensacion);
       
       
       //------------------------------------------------------------------
       
       String bodySend = JSON.serialize(body);
       
       vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
       
       Map<String,Object> inMap = new Map<String,Object>();
       Map<String,Object> outMap = new Map<String,Object>();
       Map<String,Object> opt = new Map<String,Object>();
       
       inMap.put('body', bodySend);
       
       integProcService.invokeMethod('IFS_S031', inMap, outMap, opt);
       
       Map<String, Object> response = (Map<String, Object>)outMap.get('IPResult');
       system.debug('outMap');
       system.debug(outMap);
       output.put('IPResult', response);
       
    }

}