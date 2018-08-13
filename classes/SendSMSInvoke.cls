global with sharing class SendSMSInvoke implements vlocity_cmt.VlocityOpenInterface {
    
    global SendSMSInvoke(){}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try {
            if (methodName.Equals('sendSmsIntegration')) {
                sendSmsIntegration(inputMap, outMap, options);
            } 
        }
        catch(Exception ex) { outMap.put('error', ex.getStackTraceString()); result = false; }
        return result;
    }
    
    global void sendSmsIntegration(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        
        // Vlocity Integration Procedure Obj
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        // Getting S141 data from IP 
        if(!Test.isRunningTest()){
            integProcServ.invokeMethod('IFS_S159', inputMap, outMap, options);
        }

        
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