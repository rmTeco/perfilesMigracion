@isTest
public class AccountTriggersTest {

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
                                   SegmentLevel1__c = 'Hogar',
                                   SegmentLevel2__c = '1 TV');
        // Test Insert
        Test.startTest();
        Database.SaveResult result = Database.insert(acc,false);
        acc.SegmentLevel1__c = 'Sólo Móvil';
        acc.SegmentLevel2__c = 'Black';
        Database.SaveResult result2 = Database.update(acc,false);
        Test.stopTest();
                //List<Account> lstCuentas = [SELECT segmentUniqueCode__c FROM Account WHERE Id = :acc.Id LIMIT 1];
                //string strvalor1 = lstCuentas[0].segmentUniqueCode__c;
                //system.debug('lstCuentas ===> '+lstCuentas);
                //system.debug('strvalor1 ===> '+strvalor1);
        //System.assertEquals('Black',[SELECT segmentUniqueCode__c FROM Account WHERE Id = :acc.Id LIMIT 1][0].segmentUniqueCode__c);
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
        //System.assert(insertedAccount2.CustomerIntegrationId__c == Decimal.valueOf('10000000002'));
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
        //System.assert(insertedAccount1.AccountIntegrationId__c == '1000000000110001');
        Account insertedAccount2 = [SELECT Id, AccountIntegrationId__c FROM Account WHERE Id =: acc3.Id LIMIT 1];
        //System.assert(insertedAccount2.AccountIntegrationId__c == '1000000000110002');
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
    }

    /**
     * @Author: Julia Carranza
     * @Description: This test tests the attributesWeighingValidation and the updateAttributeAccountField method consequently.
     */
    @isTest static void attributesWeighingValidation() {
        String jubilado = 'Jubilado';
        String estrategico = 'Estratégico';
        String menor = 'Menor';
        String vip = 'VIP';
        String prensa = 'Prensa';
        String account = 'Account';
        String contact = 'Contact';
        String socioClub = 'Socio Club';
 
        String userId = UserInfo.getUserId();
        Id userProfileId = Id.valueOf(UserInfo.getProfileId());
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId];

        AttributesWeighing__c aw1 = new AttributesWeighing__c(Name = 'aw1', Attribute__c = jubilado, Object__c = account, Weighing__c = 1);
        AttributesWeighing__c aw2 = new AttributesWeighing__c(Name = 'aw2', Attribute__c = estrategico, Object__c = account, Weighing__c = 2);
        AttributesWeighing__c aw3 = new AttributesWeighing__c(Name = 'aw3', Attribute__c = menor, Object__c = account, Weighing__c = 3);
        AttributesWeighing__c aw4 = new AttributesWeighing__c(Name = 'aw4', Attribute__c = vip, Object__c = contact, Weighing__c = 4);
        AttributesWeighing__c aw5 = new AttributesWeighing__c(Name = 'aw5', Attribute__c = prensa, Object__c = contact, Weighing__c = 5);
        AttributesWeighing__c att1 = new AttributesWeighing__c(Name = '01', Object__c = account, Attribute__c = socioClub, Weighing__c = 1);
        AttributesByProfile__c ab1 = new AttributesByProfile__c(AccountAttributes__c = (jubilado + '; ' + estrategico + '; ' + menor + '; ' + socioClub), ContactAttributes__c = (vip + '; ' + prensa), SetupOwnerId = userProfile.Id);

        Test.startTest();

        Database.Insert(aw1);
        Database.Insert(aw2);
        Database.Insert(aw3);
        Database.Insert(aw4);
        Database.Insert(att1);
        Database.Insert(ab1);

        Contact contact1 = new Contact(LastName='Contact1', Attributes__c=vip);
        //Attribute__c autocompletes with VIP (Contact Trigger)
        Database.Insert(contact1);
        
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        Account account1 = new Account(Name='current1', Attributes__c = jubilado, RecordTypeId = devRecordTypeId, vlocity_cmt__PrimaryContactId__c = Null);
        Account account2 = new Account(Name='current2', Attributes__c = jubilado, RecordTypeId = devRecordTypeId, vlocity_cmt__PrimaryContactId__c = contact1.Id);
        //Attribute__c from account1 autocompletes with jubilado because it has no contact.
        //Attribute__c from account2 autocompletes with VIP because of the contact.
        List<Account> listAcc = new List<Account>();
        listAcc.add(account1);
        listAcc.add(account2);
        insert account1;
        
        for(Account acc : listAcc){
            acc.Attributes__c = estrategico;
        }
        account1.Attributes__c = estrategico;
        update account1;

        contact1.Attributes__c = '';
        //listAcc[1].Attributes__c = menor;

        Database.update(contact1);
        //Database.update(listAcc[1]);

        account1.Attributes__c = '';
        //listAcc[1].Attributes__c = '';
        Database.update(listAcc[0]);
        //Database.update(listAcc[1]);

        account1.Attributes__c = (jubilado + ';' + estrategico);
        Database.update(listAcc[0]);

        Test.stopTest();
    }

    /**
     * @Author: Julia Carranza
     * @Description: This test tests the AttributesUsage Class for the Account Object.
     */
    @isTest static void checkObjectAttributesRules(){
        String jubilado = 'Jubilado';
        String estrategico = 'Estratégico';
        String menor = 'Menor';
        String vip = 'VIP';
        String prensa = 'Prensa';
        String account = 'Account';
        String contact = 'Contact';
        String socioClub = 'Socio Club';
        
        String userId = UserInfo.getUserId();
        Id userProfileId = Id.valueOf(UserInfo.getProfileId());
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId];

        AttributesWeighing__c aw1 = new AttributesWeighing__c(Name = 'aw1', Attribute__c = jubilado, Object__c = account, Weighing__c = 1);
        AttributesWeighing__c aw2 = new AttributesWeighing__c(Name = 'aw2', Attribute__c = estrategico, Object__c = account, Weighing__c = 2);
        AttributesWeighing__c aw3 = new AttributesWeighing__c(Name = 'aw3', Attribute__c = menor, Object__c = account, Weighing__c = 3);
        AttributesWeighing__c aw4 = new AttributesWeighing__c(Name = 'aw4', Attribute__c = vip, Object__c = contact, Weighing__c = 4);
        AttributesWeighing__c aw5 = new AttributesWeighing__c(Name = 'aw5', Attribute__c = prensa, Object__c = contact, Weighing__c = 5);
        AttributesWeighing__c att1 = new AttributesWeighing__c(Name = '01', Object__c = account, Attribute__c = socioClub, Weighing__c = 6);
        AttributesWeighing__c aw6 = new AttributesWeighing__c(Name = 'aw6', Attribute__c = estrategico, Object__c = contact, Weighing__c = 7);
        AttributesByProfile__c ab1 = new AttributesByProfile__c(AccountAttributes__c = (jubilado + '; ' + estrategico + '; ' + menor + '; ' + socioClub), ContactAttributes__c = (vip + '; ' + estrategico + ';' + prensa), SetupOwnerId = userProfile.Id);
        
        Test.startTest();

        Database.Insert(aw1);
        Database.Insert(aw2);
        Database.Insert(aw3);
        Database.Insert(aw4);
        Database.Insert(att1);
        Database.Insert(aw5);
        Database.Insert(aw6);
        Database.Insert(ab1);

        Contact contact1 = new Contact(LastName='Contact1', Attributes__c = vip);
        Database.Insert(contact1);

        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        Account account1 = new Account(Name='current1', Attributes__c = jubilado, RecordTypeId = devRecordTypeId, vlocity_cmt__PrimaryContactId__c = Null);
        Database.Insert(account1);

        //contact1.Attributes__c = vip + ';' + estrategico;
        //account1.Attributes__c = jubilado + ';' + estrategico;
        //Database.update(contact1);
        //Database.update(account1);

        Test.stopTest();
    }
}