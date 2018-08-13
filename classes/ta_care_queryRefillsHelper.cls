/**
* Created by Kleytman Aular 22/11/2017
*
* Implements VlocityOpenInterface
* Provides the needed logic to support OS JSON VOI translation
*
* Objects: None - JSON translation for OS
*
* Important: The method uses a VlocityOpenInterface integration structure
*
* Version: 1.1
*/

global with sharing class ta_care_queryRefillsHelper implements vlocity_cmt.VlocityOpenInterface {
    
    global ta_care_queryRefillsHelper(){}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try {
            if (methodName.Equals('GetRefillHistory')) {
                GetRefillHistory(inputMap, outMap, options);
            }
        }
        catch(Exception ex) { outMap.put('error', ex.getStackTraceString()); result = false; }
        return result;
    }
    
    global void GetRefillHistory(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        // Vlocity Integration Procedure Obj
        //vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        /*
        
        // ***** *****  BUG  PFTA-10332 *********************** ////////////
        Map<String, Object> bodyNewMap = (Map<String,Object>) inputMap.get('body');
        String codSubcript = (String) inputMap.get('codSuscript');  
        Map<String, Object> resultNew = (Map<String,Object>) bodyNewMap.get('resultado'); 
        
        
        Map<String, Object> codiT = (Map<String, Object>) resultNew.get('codigoDeAcceso');
        System.debug('result new_' + resultNew + '--' + codiT);
        
        codiT.put('identificadorRecurso', codSubcript);
        
        bodyNewMap.put('resultado',resultNew);
        bodyNewMap.put('fechaDesde', Date.today() - 5 );
        bodyNewMap.put('fechaHasta', Date.today());
        
        inputMap.put('body',bodyNewMap );
        System.debug('New Data' + inputMap);
        
        // ***** *****  //// ***********************
        
        */
        
        //  ***** ***** PFTA-11669 *********************** ////////////
       
       String dateFromString, dateUntilString; 
       System.debug('New Data' + inputMap);
       
       if((String.valueOf(inputMap.get('startDateFilter')) == null) && (String.valueOf(inputMap.get('endDateFilter')) == null))
          {
            Date dateFrom = Date.today() - 5;
            Date dateUntil = Date.today();
            dateFromString = string.valueOf(dateFrom)+' 00:00:00';
            dateUntilString = string.valueOf(dateUntil)+' 23:59:59';
          }
         else 
         {
            dateFromString = String.valueOf(inputMap.get('startDateFilter'));
            dateUntilString = String.valueOf(inputMap.get('endDateFilter'));
         }
                // PARAMETROS TOMADOS DE LA CARD
        String   codMaxCons = (string)inputMap.get('cantidadMaxConsulta');
    	String	codItems = (string)inputMap.get('cantidadItemsConsulta');
    	String	codPag = (string)inputMap.get('referenciaItemPaginado');
    	String	codSus = (string)inputMap.get('codSuscriptor'); 
           
        string args = '{"body":{"cantidadItemsConsulta":'+codItems+',"cantidadMaxConsulta": '+codMaxCons+',"fechaDesde":"'+dateFromString+'","fechaHasta":"'+dateUntilString+'","referenciaItemPaginado":'+codPag+',"resultado":{"codigoAccesoSuscriptor":{"codSuscripcion":"'+codSus+'"}}}}' ;	
        
        //string args = '{"body":{"cantidadItemsConsulta":'+codItems+',"cantidadMaxConsulta": '+codMaxCons+',"fechaDesde":"'+dateFromString+'","fechaHasta":"'+dateUntilString+'","referenciaItemPaginado":'+codPag+'},"codSuscript":"'+codSus+'"}' ;		
	    
		Map<String, Object> input = (Map<String, Object>)JSON.deserializeUntyped(args);
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        System.debug('INPUT EN FORMATO JSON' + input);
    
	    
        // ***** *****  //// ***********************
        
        
        // Getting S141 data from IP
        if(!Test.isRunningTest()){
            integProcServ.invokeMethod('IFS_S141', input, outMap, options);
        }
        
        System.debug('IFS_S141_result_' + outMap); 
        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        System.debug('result--_'+result);
        if(!(result.get('detalle') == null))
        {
            Map<String, Object> objectNewResult = new Map<String, Object>();
            result.put('codError', '201');
            result.put('descError', 'msg');
            objectNewResult.put('ListInfoRecarga', result);
            outMap.put('IPResult',objectNewResult);
        }
        else 
        {
            List<Object> refills = (List<Object>)result.get('ListInfoRecarga');
            List<Object> refills2 = new List<Object>();
            for (Object r : refills){
                Map<String, Object> rmap = (Map<String, Object>)r;
                Map<String, Object> periodo = new Map<String, Object>();
                Map<String, Object> bonusHdr = new Map<String, Object>();
                List<Object> bonus = new List<Object>();
                if (rmap.containsKey('PeriodoRecarga')) {
                    periodo = (Map<String, Object>)rmap.get('PeriodoRecarga');
                    System.debug(periodo);
                    bonusHdr = (Map<String, Object>)periodo.get('ListaBonusBalance');
                    System.debug(bonusHdr);
                    bonus = (List<Object>)bonusHdr.get('BonusBalance');
                    
                } else {
                    bonusHdr.put('ListaBonusBalance',bonus);
                    periodo.put('PeriodoRecarga', bonusHdr);
                }
                
                if (bonus.size() > 0){
                    rmap.put('Bonus', 'Con Beneficios');
                }else{
                    rmap.put('Bonus', 'Sin Beneficios');
                }
                
                
                refills2.add(rmap);
                
            }
            system.debug(json.serialize(refills2));
            result.put('ListInfoRecarga', refills2);
            outMap.put('IPResult', result);
            System.debug(outMap);
        }
        /*
        if(!outMap.get('errorCode').equals('INVOKE-200')){
                
        }else{
            System.debug('Not There are register');
            result.put('errorCode', '210');
            result.put('descError', 'Not There are register');
            outMap.put('IPResult',result);
        }  */
        
    }
/*
    
    global void queryRefillHistoryCallTester(String event){
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        
        Object argsOK = (Object)'{ "resultado": { "codigoDeAcceso": { "identificadorRecurso": "3435161523" } }, "cantidadItemsConsulta": 5, "referenciaItemPaginado": 0, "cantidadMaxConsulta": 5 }';
        Object argsERROR = (Object)'{ "resultado": { "codigoDeAcceso": { "identificadorRecurso": "34351523" } }, "cantidadItemsConsulta": 5, "referenciaItemPaginado": 0, "cantidadMaxConsulta": 5 }';
        
        if(event=='OK'){
            inputMap.put('body',argsOK);
        } else if(event=='ERROR'){
            inputMap.put('body',argsERROR);
        }
        
        System.debug('Inputmap: ' + inputMap);
        
        GetRefillHistory(inputMap, outMap, options);
    }
*/
    
}