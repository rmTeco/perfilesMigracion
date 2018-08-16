@isTest(seeAllData = false)
public with sharing class MembershipStatusTest {
    static testmethod void invoquedMethodTest(){
        Test.startTest();
        MembershipStatus ms = new MembershipStatus();
        ms.invokeMethod('NotExistantMethod', null, null, null);
        Test.stopTest();
    }
    
    static testmethod void getMembershipStatusTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        

        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Billing' AND SobjectType = 'Account' LIMIT 1].Id;

        
        Account aParent = new Account(Name = 'TestMSConsumer', RecordTypeId = consumerRecordTypeId);
        insert aParent;
        
        Account aBilling = new Account(Name = 'TestMSBilling', RecordTypeId = billingRecordTypeId, ParentId = aParent.Id);
		insert aBilling;
        
        List<Account> accs = [SELECT Id, ParentId, Name, RecordType.DeveloperName FROM Account WHERE Name IN ('TestMSConsumer','TestMSBilling')];
        system.debug('accs: ' + accs);
        
        Asset asst = new Asset(Name = 'Asset', AccountId = aBilling.Id);
        insert asst;
        
        LoyaltyTransaction__c lt = new LoyaltyTransaction__c(Status__c ='Approved',
                                                             IsApprobed__c = true, Points__c = 40,
                                                             LoyaltyAccount__c = aParent.Id,
                                                             Asset__c = asst.Id);
        
        insert lt;

        Test.startTest();
        
        Object contextId = aParent.Id;
        inputMap.put('ContextId', contextId);
        system.debug('inputMap: '+ inputMap);
        MembershipStatus ms = new MembershipStatus();
        ms.invokeMethod('getMembershipStatus', inputMap, outMap, null);
        Test.stopTest();
    }
    
    static testmethod void getTransactionsTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        

        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Billing' AND SobjectType = 'Account' LIMIT 1].Id;

        
        Account aParent = new Account(Name = 'TestMSConsumer', RecordTypeId = consumerRecordTypeId);
        insert aParent;
        
        Account aBilling = new Account(Name = 'TestMSBilling', RecordTypeId = billingRecordTypeId, ParentId = aParent.Id);
		insert aBilling;
        
        List<Account> accs = [SELECT Id, ParentId, Name, RecordType.DeveloperName FROM Account WHERE Name IN ('TestMSConsumer','TestMSBilling')];
        system.debug('accs: ' + accs);
        
        Asset asst = new Asset(Name = 'Asset', AccountId = aBilling.Id);
        insert asst;
        
        LoyaltyTransaction__c lt = new LoyaltyTransaction__c(Status__c ='Approved',
                                                             IsApprobed__c = true, Points__c = 40,
                                                             LoyaltyAccount__c = aParent.Id,
                                                             Asset__c = asst.Id);
        
        insert lt;

        Test.startTest();
        
        Object contextId = aParent.Id;
        inputMap.put('ContextId', contextId);
        system.debug('inputMap: '+ inputMap);
        
        MembershipStatus ms = new MembershipStatus();
        ms.invokeMethod('getTransactions', inputMap, outMap, null);
        Test.stopTest();
    }
}