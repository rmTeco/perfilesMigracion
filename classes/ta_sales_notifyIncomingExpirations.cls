global with sharing class ta_sales_notifyIncomingExpirations implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        MessagingConfig__c msgCon = MessagingConfig__c.getInstance('Default');
        DateTime daysto = Date.Today().addDays((Integer)(msgCon.DaysBeforeExpiration__c + 1));
        String query = 'SELECT Id, Email, Account.vlocity_cmt__ContactPreferences__c, Phone FROM Contact WHERE PermanencyDueDate__c = ' + daysto.format('YYYY-MM-dd');
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Contact> contacts = (List<Contact>) scope;
        List<CrossObject__c> crossObjects = new List<CrossObject__c>();
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'EmailToSend'];

        RecordType trackingrt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'SMSTracking'];

        CrossObject__c smsTemplateConfig = [SELECT Id, String1__c FROM CrossObject__c WHERE Picklist1__c = 'Vencimiento de plazo de permanencia' AND RecordType.Name = 'SMS Template' LIMIT 1];
        

        for(Contact c: contacts){
            if(c.Account.vlocity_cmt__ContactPreferences__c != null){
                if(c.Account.vlocity_cmt__ContactPreferences__c.indexOf('eMail') != -1){
                    crossObjects.add(new CrossObject__c(Email1__c = c.Email, RecordTypeId = rt.Id, Picklist1__c = 'Vencimiento de plazo de permanencia'));
                }else if(c.Account.vlocity_cmt__ContactPreferences__c.indexOf('SMS') != -1){
                    /*String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ text +'"}}';
                    Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
                    Map<String, Object> output = new Map<String, Object>();
                    Map<String, Object> options2 = new Map<String, Object>();
                    vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                    integProcServ.invokeMethod('IFS_S159', input, output, options2);*/
                    crossObjects.add(new CrossObject__c(String1__c = c.Phone, String2__c = smsTemplateConfig.String1__c, RecordTypeId = trackingrt.Id, DateTime1__c = System.now(), Picklist1__c = 'Vencimiento de plazo de permanencia', Status__c = 'Pendiente'));
                }
            }
        }

        insert crossObjects;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    public void execute(Schedulablecontext ctx){
        ta_sales_notifyIncomingExpirations batch = new ta_sales_notifyIncomingExpirations ();
        Database.executeBatch(batch);
    }
}