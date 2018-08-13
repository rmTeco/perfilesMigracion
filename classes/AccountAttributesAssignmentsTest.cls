@isTest
public class AccountAttributesAssignmentsTest {

    static testMethod void myUnitTest(){

        String jubilado = 'Jubilado';
        String estrategico = 'Estratégico';
        String menor = 'Menor';
        String vip = 'VIP';
        String prensa = 'Prensa';
        String socioClub = 'Socio Club';
        String account = 'Account';
        String contact = 'Contact';

        String userId = UserInfo.getUserId();
        Id userProfileId = Id.valueOf(UserInfo.getProfileId());
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId];

        AttributesByProfile__c ab1 = new AttributesByProfile__c(AccountAttributes__c = (jubilado + '; ' + estrategico + '; ' + menor + '; ' + socioClub), ContactAttributes__c = (vip + '; ' + prensa), SetupOwnerId = userProfile.Id);
        AttributesWeighing__c att1 = new AttributesWeighing__c(Name = '01', Object__c = account, Attribute__c = socioClub, Weighing__c = 1);
        AttributesWeighing__c att2 = new AttributesWeighing__c(Name = '02', Object__c = contact, Attribute__c = vip, Weighing__c = 2);
        insert ab1;
        insert att1;
        insert att2;

        Contact contact1 = new Contact(LastName='Contact1', Attributes__c=vip);
        Database.Insert(contact1);
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        Account account1 = new Account(Name = 'current1', Attributes__c = socioClub, RecordTypeId = devRecordTypeId, vlocity_cmt__PrimaryContactId__c = contact1.Id);
        Database.Insert(account1);

        Test.StartTest();
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        inputMap.put('ContextId',account1.Id);
        AccountAttributesAssignments.getAccountAttributes(inputMap,outMap);
        
        AccountAttributesAssignments class1 = new AccountAttributesAssignments();
        class1.invokeMethod('Name', inputMap, outMap, options);

        Test.StopTest();
    }
}