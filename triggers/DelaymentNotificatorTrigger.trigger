trigger DelaymentNotificatorTrigger on Case(after update) {
system.debug('DelaymentNotificatorTrigger');

    if (Trigger.isUpdate) {

        String methodName = 'SendDelayNotification'; 
        Map<String,Object> inputMap = new  Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();        
        
        list<Case> cases = Trigger.new;        
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Technical_Service' AND SobjectType = 'Case' LIMIT 1].Id;

        if(billingRecordTypeId !=null){
       		for(Case caso:cases){
	            if (caso.Status == 'En espera de ejecución' && caso.RecordTypeId == billingRecordTypeId) {
	                inputMap.put('caseNumber', caso.CaseNumber);                
	                inputMap.put('caseId', caso.Id);                
	                
	                ta_techCare_Delay_Notification delayNotification = new ta_techCare_Delay_Notification();               
	                delayNotification.invokeMethod(methodName, inputMap, outMap, options);
	         
	           	}	           	
        	} 	
        }
       
    }
    
}