public with sharing class taSalesLogValidationIdentityExtension {

    public List<Crossobject__c> logs{get;set;}

    public taSalesLogValidationIdentityExtension(ApexPages.StandardController controller){
        Id orderId = controller.getId();
        RecordType recordTypeLog = [SELECT Id, Name FROM RecordType WHERE name = 'Log Identity Validation'];
        // paymentMethods = [SELECT vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c , vlocity_cmt__Amount__c FROM vlocity_cmt__PaymentAdjustment__c WHERE Order__c =: orderId];
        logs = [SELECT PickList1__c, DateTime1__c, Account__c, Account__r.Name, Checkbox1__c
                FROM Crossobject__c 
                WHERE Order__c =: orderId
                AND RecordTypeId = :recordTypeLog.Id
                ORDER BY DateTime1__c DESC];
    }
}