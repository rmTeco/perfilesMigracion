global with sharing class ta_care_querySOSRefillsHelper implements vlocity_cmt.VlocityOpenInterface {
    
    global ta_care_querySOSRefillsHelper(){}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try {
            if (methodName.Equals('GetRefillSOSHistory')) {
                GetRefillSOSHistory(inputMap, outMap, options);
            }
            if (methodName.Equals('getPacksHistoryDetail')) {
                getPacksHistoryDetail(inputMap, outMap, options);
            }
        }
        catch(Exception ex) { outMap.put('error', ex.getStackTraceString()); result = false; }
        return result;
    }
    
   
    global void GetRefillSOSHistory(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        map<string, string> estados = new map<string, string>();
        estados.put('O', 'Abierto');
        estados.put('C', 'Cerrado');
        
        // Vlocity Integration Procedure Obj
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
         // ***** *****  BUG  PFTA-10332 *********************** ////////////
        Map<String, Object> bodyNewMap = (Map<String,Object>) inputMap.get('body');
        String codSubcript = (String) inputMap.get('codSuscript');  
        System.debug('result new_' + codSubcript);
        Map<String, Object> codAcces = (Map<String,Object>) bodyNewMap.get('codigoAcceso');
        
        codAcces.put('codSuscripcion', codSubcript);
        
        bodyNewMap.put('codigoAcceso',codAcces);
        //bodyNewMap.put('fechaDesde', Date.today() - 3 );
       //bodyNewMap.put('fechaHasta', Date.today());
        
        inputMap.put('body',bodyNewMap );
        System.debug('New Data' + inputMap);
        //*******************  --------  **************** ///////
        
        // Getting S_S440 data from IP
        if(!Test.isRunningTest()){
            integProcServ.invokeMethod('IFS_S440', inputMap, outMap, options);           
        }        
        System.debug('Answer S440: ' + outMap);
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
       // Map<String, Object> resultChild2  = (Map<String, Object>) result.get('result');
        System.debug('result init-- ' + result );
        if((result != null && result.get('detalle') != null)){
            
            result.put('codError', '201');
            result.put('descError', 'msg');      
            Map<String, Object> objectNewResult = new Map<String, Object>();
            objectNewResult.put('listaDetallePrestamo', result);
            outMap.put('IPResult',objectNewResult);
            
        }else{
            List<Object> refillsSOS = (List<Object>)result.get('listaDetallePrestamo');
            if(refillsSOS.isEmpty()){
              result.put('codError', '201');
              result.put('descError', 'NO DATA');  
              Map<String, Object> objectNewResult = new Map<String, Object>();
              objectNewResult.put('listaDetallePrestamo', result);
              outMap.put('IPResult',objectNewResult);
            }else{
                List<Object> Payments = (List<Object>)result.get('listaDetalleReembolso');
                List<Object> refillsSOS2 = new List<Object>();
                for (Object r : refillsSOS){
                    Map<String, Object> rMap = (Map<String, Object>)r;
                    rMap.put('estado', estados.get((string)rMap.get('estadoPrestamoAdq')));
                    for (Object p : Payments){
                        Map<String, Object> pMap = (Map<String, Object>)p;
                        if (rMap.get('fechaAltaProductoAdq').equals(pMap.get('fechaAltaProductoAdq'))){
                            rMap.put('fechaPago', pMap.get('fechaPago'));
                            break;
                        }
                    }
                    refillsSOS2.add(rMap);
                }
                result.put('listaDetallePrestamo', refillsSOS2);
                outMap.put('IPResult', result);
            }
            System.debug(outMap);
        }        
    }
    
    global void getPacksHistoryDetail(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        // Vlocity Integration Procedure Obj
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
         // ***** *****  BUG  PFTA-10332 *********************** ////////////
        String codSubcript = (String) inputMap.get('codSubcript');  
        System.debug('result new_' + codSubcript);
        
        Date dateFrom = Date.today() - 5;
        Date dateUntil = Date.today();
        String dateFromString = string.valueOf(dateFrom)+' 00:00:00';
        String dateUntilString = string.valueOf(dateUntil)+' 00:00:00';
        System.debug('fechasss_' + dateFromString +'__-' + dateUntilString);
        
        
        Map<String, Object> bodyMap = new Map<String, Object>();
        Map<String, Object> bodyNew2 = new Map<String, Object>();
        bodyMap.put('body',bodyNew2);
        Map<String, Object>  codigoAcceso = new Map<String, Object>();
        codigoAcceso.put('codSuscripcion',codSubcript);
        
        Map<String, Object> other = (Map<String, Object>) bodyMap.get('body');     
        other.put('cantidadItemsConsulta', '2');
        other.put('cantidadMaxConsulta', '3');
        other.put('codigoAcceso',codigoAcceso);
        other.put('fechaDesde', dateFromString);
        other.put('fechaHasta', dateUntilString);
        other.put('referenciaItemPaginado', '0');
 
        System.debug('New Data_s139' + bodyMap);
        //*******************  --------  **************** ///////
        
        // Getting S139 data from IP
        if(!Test.isRunningTest()){
            integProcServ.invokeMethod('IFS_S139', bodyMap, outMap, options);           
        }        
        System.debug('Answer S139' + outMap);
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
       // Map<String, Object> resultChild2  = (Map<String, Object>) result.get('result');
        System.debug('result init--_' + result );
        
        if((result != null && result.get('detalle') != null)){
            
            result.put('codError', '201');
            result.put('descError', 'msg');      
            Map<String, Object> objectNewResult = new Map<String, Object>();
            objectNewResult.put('detalleDeMovimientosLista', result);
            outMap.put('IPResult',objectNewResult);
   
        }else{
            Map<String, Object> detailMovi = (Map<String, Object>) result.get('detalleDeMovimientosLista');
            List<Object> elementDetailMov =  (List<Object>) detailMovi.get('elementoDetalleDeMovimientos');
            System.debug('elementDetailMov -' + elementDetailMov  );
            if(elementDetailMov.isEmpty()){
              result.put('codError', '201');
              result.put('descError', 'NO DATA');  
              Map<String, Object> objectNewResult = new Map<String, Object>();
              objectNewResult.put('detalleDeMovimientosLista', result);
              outMap.put('IPResult',objectNewResult);
            }else{
                result.put('detalleDeMovimientosLista',elementDetailMov);
                outMap.put('IPResult', result);
                System.debug(outMap);
            }     
        } 
    } 
    
    //used for testing service in SIT. data not valid in Desa.
    /*global void queryRefillSOSHistoryCallTester(String event){
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        
        Object argsOK = (Object)'{ "codigoAcceso": { "identificadorRecurso": "13800001139", "codSuscripcion": "string" }, "listaDatosAdicionales": [ { "nombreParametro": "string", "valorParametro": "string" } ] }';
        Object argsERROR = (Object)'{ "codigoAcceso": { "identificadorRecurso": "138001139", "codSuscripcion": "string" }, "listaDatosAdicionales": [ { "nombreParametro": "string", "valorParametro": "string" } ] }';
        
        if(event=='OK'){
            inputMap.put('body',argsOK);
        } else if(event=='ERROR'){
            inputMap.put('body',argsERROR);
        }
        
        System.debug('Inputmap: ' + inputMap);
        
        GetRefillSOSHistory(inputMap, outMap, options);
    }*/
    
}