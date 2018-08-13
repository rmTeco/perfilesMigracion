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
        
        codAcces.put('identificadorRecurso', codSubcript);
        
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
        Map<String, Object> resultChild2  = (Map<String, Object>) result.get('result');
        System.debug('result init-- ' + result );
        if(resultChild2 != null && resultChild2.get('detalle') != null){
            
            Map<String, Object> objectNewResult = new Map<String, Object>();
            result.put('codError', '201');
            result.put('descError', 'msg');
            objectNewResult.put('listaDetallePrestamo', result);
            outMap.put('IPResult',objectNewResult);
        }else{
            List<Object> refillsSOS = (List<Object>)result.get('listaDetallePrestamo');
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
            System.debug(outMap);
        }        
    }
    
    global void getPacksHistoryDetail(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        // Vlocity Integration Procedure Obj
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
         // ***** *****  BUG  PFTA-10332 *********************** ////////////
        Map<String, Object> bodyNewMap = (Map<String,Object>) inputMap.get('body');
        String codSubcript = (String) inputMap.get('codSubcript');  
        System.debug('result new_' + codSubcript);
        Map<String, Object> codAcces = (Map<String,Object>) bodyNewMap.get('codigoAcceso');
        
        codAcces.put('identificadorRecurso', codSubcript);
        
        bodyNewMap.put('codigoAcceso',codAcces);
        bodyNewMap.put('fechaDesde', Date.today() - 5 );
        bodyNewMap.put('fechaHasta', Date.today());
        
        inputMap.put('body',bodyNewMap );
        System.debug('New Data' + inputMap);
        //*******************  --------  **************** ///////
        
        // Getting S139 data from IP
        if(!Test.isRunningTest()){
            integProcServ.invokeMethod('IFS_S139', inputMap, outMap, options);           
        }        
        System.debug('Answer S139' + outMap);
        
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        Map<String, Object> resultChild2  = (Map<String, Object>) result.get('result');
        System.debug('result init--_' + resultChild2 );
        
        if(resultChild2 != null && resultChild2.get('detalle') != null){
            
            Map<String, Object> objectNewResult = new Map<String, Object>();
            Map<String, Object> objectchildResult = new Map<String, Object>();
            result.put('codError', '201');
            result.put('descError', 'msg');
            objectNewResult.put('detalleDeMovimientosLista',objectchildResult);
            Map<String, Object> objectchild2Result = (Map<String, Object>)objectNewResult.get('detalleDeMovimientosLista');
            // System.debug('objectchild2Result --' + objectchild2Result);
            objectchild2Result.put('elementoDetalleDeMovimientos',result);
            System.debug('objectNewResult_-' + objectNewResult );
            outMap.put('IPResult',objectNewResult);
            
        }else{
            Map<String, Object> refillsHistory = (Map<String, Object>)result.get('detalleDeMovimientosLista');
            List<Object> detailMov =  (List<Object>) refillsHistory.get('elementoDetalleDeMovimientos');
            System.debug('detailMov__' + detailMov);
            List<Object> refillsHistory2 = new List<Object>();
            //List<Object> detailUnidd = new List<Object>();
            for (Object rd : detailMov){
                refillsHistory2.add(rd);
               /* List<Object> listDetail = (List<Object>) rd.get('promocionTasadaLista');
                for (Object dd : listDetail ){
                    detailUnidd.add(dd);
                }*/
            }
            System.debug('refillsHistory2_'+ refillsHistory2);
            //System.debug('detailUnidd__' + detailUnidd);
            result.put('elementoDetalleDeMovimientos', refillsHistory2);
            outMap.put('IPResult', result);
            System.debug(outMap);     
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