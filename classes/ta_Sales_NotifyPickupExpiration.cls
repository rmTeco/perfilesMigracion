global with sharing class ta_Sales_NotifyPickupExpiration implements Database.Batchable<sObject>, Schedulable{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        /*Expiration date?*/
        //vlocity_cmt__PrimaryContactId__c
        String query = 'SELECT Id, vlocity_cmt__ExpirationDate__c, Account.vlocity_cmt__ContactPreferences__c, Account.vlocity_cmt__PrimaryContactId__c FROM Order'; /* WHERE Delivery_Method_Service__c=\'Retiro\' AND Status=\'Activated\'';*/
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        PlazoEsperaPickup__c plazo = PlazoEsperaPickup__c.getAll().values()[0];

        List<Order> orders = (List<Order>) scope;
        List<Order> ordersToNotify = new List<Order>();
        if(plazo != null){
            for(Order o: orders){
                if(o.vlocity_cmt__ExpirationDate__c != null){
                    if(o.vlocity_cmt__ExpirationDate__c.addDays(-((Integer)plazo.DiasDeEspera__c)) == Date.today()){
                        ordersToNotify.add(o);
                    }
                }
            }
        }
        List<CrossObject__c> crossObjects = new List<CrossObject__c>();
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'EmailToSend'];

        RecordType trackingrt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'SMSTracking'];

        CrossObject__c smsTemplateConfig = [SELECT Id, String1__c FROM CrossObject__c WHERE Picklist1__c = 'Vencimiento de Pickup' AND RecordType.Name = 'SMS Template' LIMIT 1];

        Set<Id> contactIds = new Set<Id>();
        for(Order o: ordersToNotify){
            contactIds.add(o.Account.vlocity_cmt__PrimaryContactId__c);
        }

        Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, Phone, Email FROM Contact WHERE Id IN :contactIds]);

        for(Order o: ordersToNotify){
            if(o.Account.vlocity_cmt__ContactPreferences__c != null){
                Contact con = contacts.get(o.Account.vlocity_cmt__PrimaryContactId__c);
                if(o.Account.vlocity_cmt__ContactPreferences__c.indexOf('eMail') != -1){
                    crossObjects.add(new CrossObject__c(Email1__c = con.Email, RecordTypeId = rt.Id, Picklist1__c = 'Vencimiento de Pickup'));
                }else if(o.Account.vlocity_cmt__ContactPreferences__c.indexOf('SMS') != -1){
                    /*String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ text +'"}}';
                    Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
                    Map<String, Object> output = new Map<String, Object>();
                    Map<String, Object> options2 = new Map<String, Object>();
                    vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                    integProcServ.invokeMethod('IFS_S159', input, output, options2);*/
                    crossObjects.add(new CrossObject__c(String1__c = con.Phone, String2__c = smsTemplateConfig.String1__c, RecordTypeId = trackingrt.Id, DateTime1__c = System.now(), Picklist1__c = 'Vencimiento de Pickup', Status__c = 'Pendiente'));
                }
            }
        }

        insert crossObjects;
    }

    global void finish(Database.BatchableContext BC) {
        
    }

    public void execute(Schedulablecontext ctx){
        ta_Sales_NotifyPickupExpiration batch = new ta_Sales_NotifyPickupExpiration();
        Database.executeBatch(batch);
    }

}