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
        //Map<String,Object> input = new Map<String,Object>();
        //Map<String,Object> options = new Map<String,Object>();
        //Map<String,Object> outputMap = new Map<String,Object>();
        Map<String, Object> mapSOS;
        List<Object> listSOS = new List<Object>();

        Map<String, Object> response = new Map<String, Object>();
        
        Map<string, string> estados = new Map<string, string>();
        estados.put('O', 'Abierto');
        estados.put('C', 'Cerrado');

        try
        {
            String codSuscripcion = String.valueOf(inputMap.get('codSuscriptor'));
            String jsonString = '{"body":{"codigoAcceso":{"codSuscripcion":"'+codSuscripcion+'"}}}';

            System.debug('Request S440: '+jsonString);
            Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(jsonString);

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S440', input, outMap, options);
            System.debug('Response S440: '+outMap);

            Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');

            System.debug('IPResult: '+result);

            if(result.get('detalle') == null)
            { 
                List<Object> listaDetallePrestamo = (List<Object>)result.get('listaDetallePrestamo');
                List<Object> listaDetalleReembolso = (List<Object>)result.get('listaDetalleReembolso');

                if(listaDetallePrestamo == null)
                {
                    //throw new FuncException('No se pudo obtener el detalle del prestamo.');
                    mapSOS = new Map<String, Object>();
                    mapSOS.put('codError', '201');
                    mapSOS.put('descError', 'Ocurrio un error al intentar obtener el historial.');
                    listSOS.add(mapSOS);
                }
                else
                { 
                    if(listaDetalleReembolso == null)
                    {
                        //throw new FuncException('No se pudo obtener el detalle del prestamo.');
                        mapSOS = new Map<String, Object>();
                        mapSOS.put('codError', '201');
                        mapSOS.put('descError', 'Ocurrio un error al intentar obtener el historial.');
                        listSOS.add(mapSOS);
                    }
                    else
                    {
                        for(Object objPrestamo : listaDetallePrestamo)
                        {   
                            mapSOS = new Map<String, Object>();
                            Map<String, Object> prestamoMap = (Map<String, Object>)objPrestamo;

                            
                            mapSOS.put('estado', estados.get(String.valueOf(prestamoMap.get('estadoPrestamoAdq')) == '' ? 'Sin datos' : String.valueOf(prestamoMap.get('estadoPrestamoAdq'))));
                            mapSOS.put('fechaAltaProductoAdq', String.valueOf(prestamoMap.get('fechaAltaProductoAdq')) == '' ? 'Sin datos' : String.valueOf(prestamoMap.get('fechaAltaProductoAdq')));
                            mapSOS.put('montoPrestamo', String.valueOf(prestamoMap.get('montoPrestamo')) == '' ? 'Sin datos' : String.valueOf(prestamoMap.get('montoPrestamo')));
                            mapSOS.put('fechaVtoPagoPrestamo', 'Hola soy un hardcode');

                            for(Object objReembolso : listaDetalleReembolso)
                            {
                                Map<String, Object> reembolsoMap = (Map<String, Object>)objReembolso;
                                if (prestamoMap.get('fechaAltaProductoAdq').equals(reembolsoMap.get('fechaAltaProductoAdq')))
                                {
                                    mapSOS.put('fechaPago', String.valueOf(reembolsoMap.get('fechaPago')) == '' ? 'Sin datos' : String.valueOf(reembolsoMap.get('fechaPago')));
                                    break;
                                }
                                else
                                {
                                    mapSOS.put('fechaPago', String.valueOf(prestamoMap.get('fechaPago')) == '' ? 'Sin datos' : String.valueOf(prestamoMap.get('fechaPago')));
                                }
                            }
                            listSOS.add(mapSOS);
                        }
                    }
                }
            }
            else
            {
                mapSOS = new Map<String, Object>();
                mapSOS.put('codError', '201');
                mapSOS.put('descError', 'No hay registros en los ultimos 5 dias.');
                listSOS.add(mapSOS);
            }
                        
            response.put('listaDetallePrestamo', listSOS);
            outMap.put('IPResult', response);
            System.debug('outMap: '+outMap);        
        }
        catch(Exception ex)
        {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
        }
    }
   /*
    global void GetRefillSOSHistory(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        map<string, string> estados = new map<string, string>();
        estados.put('O', 'Abierto');
        estados.put('C', 'Cerrado');
        
        // Vlocity Integration Procedure Obj
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
         // ***** *****  BUG  PFTA-10332 *********************** ////////////
        Map<String, Object> bodyNewMap = (Map<String,Object>) inputMap.get('body');
        /* Nuevo */ //String codSubcript = (String) inputMap.get('codSuscript');  
        /* Nuevo */ //System.debug('result new_' + codSubcript);
        /* Nuevo */ //Map<String, Object> codAcces = (Map<String,Object>) bodyNewMap.get('codigoAcceso');
        
        /* Nuevo */ //codAcces.put('identificadorRecurso', codSubcript);
        
        /* Nuevo */ //bodyNewMap.put('codigoAcceso',codAcces);
        //bodyNewMap.put('fechaDesde', Date.today() - 3 );
       //bodyNewMap.put('fechaHasta', Date.today());
    /*    
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
            
        } 
        System.debug('outMap -->'+outMap);
    }
    */
    
    global void GetRefillSOSHistory2(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('GetRefillSOSHistory2');
        Try{
        	// Vlocity Integration Procedure Obj
        	vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        	System.debug('inputMap --> ' + inputMap);
        	if(!Test.isRunningTest()){
             	integProcServ.invokeMethod('IFS_S440', inputMap, outMap, options);        
        	}
        	System.debug('outMap -->'+outMap);
            /*Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        	Map<String, Object> resultChild2  = (Map<String, Object>) result.get('result');
            System.debug('resultChild2 --> ' + resultChild2 );
            if(resultChild2 != null && resultChild2.get('detalle') != null){
                system.debug('PRIMERO');
            	Map<String, Object> objectNewResult = new Map<String, Object>();
           	 	result.put('codError', '201');
            	result.put('descError', 'msg');
            	objectNewResult.put('listaDetallePrestamo', result);
            	outMap.put('IPResult',objectNewResult);
            }*/
            
        }
        catch(Exception ex)
        {
            System.debug('Error: '+ ex.getMessage());
            throw ex;
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