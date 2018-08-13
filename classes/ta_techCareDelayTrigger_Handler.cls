public with sharing class ta_techCareDelayTrigger_Handler {

	public  void DelayNotificationTrigger(List<Case> triggerNew){
        String methodName = 'SendDelayNotification'; 
        Map<String,Object> inputMap = new  Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();        
        
        List<Case> cases = triggerNew;        
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Technical_Service' AND SobjectType = 'Case' LIMIT 1].Id;

        if(billingRecordTypeId !=null){
       		for(Case caso:cases){
	            if (caso.Status == 'En espera de ejecución' && caso.RecordTypeId == billingRecordTypeId) {
	                inputMap.put('caseNumber', caso.CaseNumber);                
	                inputMap.put('caseId', caso.Id);
                	inputMap.put('SuppliedPhone', (caso.SuppliedPhone) == null ? '' : (String) caso.SuppliedPhone);
                	inputMap.put('caseMail', (caso.ContactEmail) == null ? '' : (String) caso.ContactEmail);
                	inputMap.put('contactPhoneNumber', (caso.Contact.MobilePhone) == null ? '' : (String) caso.Contact.MobilePhone);
                	inputMap.put('contactMail', (caso.Contact.Email) == null ? '' : (String) caso.Contact.Email);	                           
	                
	                ta_techCare_Delay_Notification delayNotification = new ta_techCare_Delay_Notification();               
	                delayNotification.invokeMethod(methodName, inputMap, outMap, options);	         
	           	}	           	
        	} 	
        }
	}

}