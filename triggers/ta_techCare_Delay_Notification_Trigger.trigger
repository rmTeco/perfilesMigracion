trigger ta_techCare_Delay_Notification_Trigger on Case(after update) {
system.debug('ta_techCare_Delay_Notification_Trigger');

    if (Trigger.isUpdate) {

    	ta_techCareDelayTrigger_Handler delayTriggerHandler = new ta_techCareDelayTrigger_Handler();
    	delayTriggerHandler.DelayNotificationTrigger(Trigger.new);
    	
       
    }
    
}