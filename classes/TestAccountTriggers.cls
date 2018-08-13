@isTest
public class TestAccountTriggers {
/* 	
    static testMethod void TestAccountInsert(){
        
       	// Test Custom Setting Data
        List<Segments__c> segments = new List<Segments__c>();
        Segments__c seg = new Segments__c(Name = 'Black',
                                          segmentLevel1__c = 'Hogar',
                                   	      segmentLevel2__c = '1 TV');
        Segments__c seg2 = new Segments__c(Name = 'Premium',
                                          segmentLevel1__c = 'Sólo Móvil',
                                   	      segmentLevel2__c = 'Black');
        segments.add(seg);
        segments.add(seg2);
        insert segments;
        // Test data setup
        // Create an account with Segment = Black
        Account acc = new Account (Name='Test Account Black1',
                                   Segment_Level1__c = 'Hogar',
                                   Segment_Level2__c = '1 TV');
        // Test Insert
        Test.startTest();
        Database.SaveResult result = Database.insert(acc,false);
        acc.Segment_Level1__c = 'Sólo Móvil';
        acc.Segment_Level2__c = 'Black';
        Database.SaveResult result2 = Database.update(acc,false);
        Test.stopTest();
        
        System.assertEquals('Black',[SELECT segmentUniqueCode__c FROM Account WHERE Id = :acc.Id LIMIT 1][0].segmentUniqueCode__c);
    }

    static testMethod void checkInsertUniqueConsumerAccountTest() {
        MockupFactory.generate();
        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        Account acc = new Account (Name='New Test Account', RecordTypeId = consumerRecordTypeId, vlocity_cmt__PrimaryContactId__c = contact.Id);

        Test.startTest();
        try {
            insert acc;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.ConsumerAccountNotUniqueError) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }

    static testMethod void checkUpdateUniqueConsumerAccountTest() {
        MockupFactory.generate();
        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        Id businessRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business' AND SobjectType = 'Account' LIMIT 1].Id;
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        Account acc = new Account (Name='New Test Account', RecordTypeId = businessRecordTypeId, vlocity_cmt__PrimaryContactId__c = contact.Id);
        insert acc;

        Test.startTest();
        try {
            acc.RecordTypeId = consumerRecordTypeId;
            update acc;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.ConsumerAccountNotUniqueError) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }

    static testMethod void setCustomerAccountIntegrationIdTest() {
        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        Id businessRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business' AND SobjectType = 'Account' LIMIT 1].Id;

        Account acc = new Account (Name='New Test Account', RecordTypeId = businessRecordTypeId);
        Account acc2 = new Account (Name='New Test Account2', RecordTypeId = consumerRecordTypeId);

        Test.startTest();
        insert acc;
        insert acc2;

        Account insertedAccount1 = [SELECT Id, CustomerIntegrationId__c FROM Account WHERE Id =: acc.Id LIMIT 1];
        System.assert(insertedAccount1.CustomerIntegrationId__c == Decimal.valueOf('10000000001'));
        Account insertedAccount2 = [SELECT Id, CustomerIntegrationId__c FROM Account WHERE Id =: acc2.Id LIMIT 1];
        System.assert(insertedAccount2.CustomerIntegrationId__c == Decimal.valueOf('10000000002'));
        Test.stopTest();
    }

    static testMethod void setBillingAccountIntegrationIdTest() {
        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Billing' AND SobjectType = 'Account' LIMIT 1].Id;

        Account acc = new Account (Name='New Test Account', RecordTypeId = consumerRecordTypeId);
        insert acc;
        Account acc2 = new Account (Name='New Test Account2', RecordTypeId = billingRecordTypeId, ParentId = acc.Id);

        Test.startTest();
        insert acc2;

        Account acc3 = new Account (Name='New Test Account3', RecordTypeId = billingRecordTypeId, ParentId = acc.Id);
        insert acc3;

        Account insertedAccount1 = [SELECT Id, AccountIntegrationId__c FROM Account WHERE Id =: acc2.Id LIMIT 1];
        System.assert(insertedAccount1.AccountIntegrationId__c == '1000000000110001');
        Account insertedAccount2 = [SELECT Id, AccountIntegrationId__c FROM Account WHERE Id =: acc3.Id LIMIT 1];
        System.assert(insertedAccount2.AccountIntegrationId__c == '1000000000110002');
        Test.stopTest();
    }

    static testMethod void callIntegrationServicesTest() {
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Billing' AND SobjectType = 'Account' LIMIT 1].Id;
        Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;

        Account customerAccount = new Account(Name = 'Customer Account Test', RecordTypeId = consumerRecordTypeId);
        Account billingAccount = new Account(Name = 'Billing Account Test', RecordTypeId = billingRecordTypeId);

        Test.startTest();
        insert customerAccount;

        billingAccount.ParentId = customerAccount.Id;
        insert billingAccount;
        Test.stopTest();
    }*/
}