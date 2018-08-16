global class ta_sales_jobSetup{

    public static void scheduleAll(){
        scheduleNotifications('00', '01');
        schedulePurge('00', '01');
        scheduleCheckPickup('00', '01');
        scheduleNotifyPickup('00', '01');
        scheduleCancelUnconfirmed('00', '03');
        scheduleCancelUnretrieved('00','01');
    }
    
    
    public static void scheduleCancelUnretrieved(String minute, String hour){
        ta_sales_CancelUnconfirmedOrdersBatch schedule = new ta_sales_CancelUnconfirmedOrdersBatch();
        system.schedule('ta_sales_CancelUnconfirmedOrdersBatch ' + System.Now(), getCronExpression(minute, hour), schedule);        
    }

    public static void scheduleCancelUnconfirmed(String minute, String hour){
        ta_sales_CancelUnretrievedOrdersBatch schedule = new ta_sales_CancelUnretrievedOrdersBatch();
        system.schedule('ta_sales_CancelUnretrievedOrdersBatch ' + System.Now(), getCronExpression(minute, hour), schedule);
    }

    public static void scheduleNotifications(String minute, String hour){
        ta_sales_notifyIncomingExpirations schedule = new ta_sales_notifyIncomingExpirations();
        system.schedule('ta_sales_notifyIncomingExpirations ' + System.Now(), getCronExpression(minute, hour), schedule);
    }

    public static void schedulePurge(String minute, String hour){
        ta_sales_purgeCrossObjects schedule = new ta_sales_purgeCrossObjects();
        system.schedule('ta_sales_purgeCrossObjects ' + System.Now(), getCronExpression(minute, hour), schedule);
    }

    public static void scheduleCheckPickup(String minute, String hour){
        ta_sales_CheckPickupTime schedule = new ta_sales_CheckPickupTime();
        system.schedule('ta_sales_CheckPickupTime ' + System.Now(), getCronExpression(minute, hour), schedule);
    }

    public static void scheduleNotifyPickup(String minute, String hour){
        ta_Sales_NotifyPickupExpiration schedule = new ta_Sales_NotifyPickupExpiration();
        system.schedule('ta_Sales_NotifyPickupExpiration ' + System.Now(), getCronExpression(minute, hour), schedule);
    }

    public static void taskTopicSetup(){
    	String Name = 'TasksTopic';
    	
    	if(Test.isRunningTest()) Name = 'Test';
    	
        List<PushTopic> pts = [SELECT Id FROM PushTopic WHERE Name = :Name];
        Database.delete(pts);

        PushTopic pushTopic = new PushTopic();
        pushTopic.Name = Name;
        pushtopic.Query = 'SELECT id, Type, TaskSubtype FROM Task';
        pushTopic.ApiVersion = 40.0;
        pushTopic.NotifyForOperationCreate = true;
        pushTopic.NotifyForOperationUpdate = true;
        pushTopic.NotifyForOperationUndelete = true;
        pushTopic.NotifyForOperationDelete = true;
        pushTopic.NotifyForFields = 'Referenced';
        insert pushTopic;
    }

    public static String getCronExpression(String mm, String hh){
        String seconds = '0';
        String minutes = mm.length() == 1 ? '0' + mm : mm;
        String hours = hh.length() == 1 ? '0' + hh : hh;
        String dayOfMonth = '*';
        String month = '*';
        String dayOfweek = '?';
        String optionalYear = '';
        String cronExpression = seconds + ' ' + minutes + ' ' + hours + ' ' + dayOfMonth + ' '+ month + ' ' + dayOfweek + ' ' + optionalYear;

        return cronExpression;
                
        /*FieloScheduleBatchMasterAccountRel t = new FieloScheduleBatchMasterAccountRel();
        system.schedule('FieloScheduleBatchMasterAccountRel '+System.Now(), CronExpression, t);*/
    }
}