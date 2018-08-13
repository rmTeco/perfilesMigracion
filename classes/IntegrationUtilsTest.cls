@isTest(seeAllData = false)
public with sharing class IntegrationUtilsTest {

    static testMethod void TestCreateBody() {
        MockupFactory.generate();
        Account acc = [SELECT RecordTypeId, Name, AccountNumber FROM Account WHERE Name = 'Sample Account' and AccountNumber = '1234' LIMIT 1];
        acc.AccountIntegrationId__c = '1234567890'; 
        Test.startTest();
        IntegrationUtils.createBodyCustomerCreation(acc);
        IntegrationUtils.createBodyBillingAccountCreation(acc);
        Test.stopTest();
    }
}