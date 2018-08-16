@isTest
public class ContactTriggerHandlerTest {
	static testMethod void myUnitTest(){
		String jubilado = 'Jubilado';
		String estrategico = 'Estratégico';
		String menor = 'Menor';
		String vip = 'VIP';
        String prensa = 'Prensa';
		String account = 'Account';
        String contact = 'Contact';

        String userId = UserInfo.getUserId();
        Id userProfileId = Id.valueOf(UserInfo.getProfileId());
        Profile userProfile = [SELECT Name FROM Profile WHERE Id = :userProfileId];

		AttributesWeighing__c aw1 = new AttributesWeighing__c(Name = 'aw1', Attribute__c = jubilado, Object__c = account, Weighing__c = 1);
		AttributesWeighing__c aw2 = new AttributesWeighing__c(Name = 'aw2', Attribute__c = estrategico, Object__c = account, Weighing__c = 2);
		AttributesWeighing__c aw3 = new AttributesWeighing__c(Name = 'aw3', Attribute__c = menor, Object__c = account, Weighing__c = 3);
		AttributesWeighing__c aw4 = new AttributesWeighing__c(Name = 'aw4', Attribute__c = vip, Object__c = contact, Weighing__c = 4);
        AttributesWeighing__c aw5 = new AttributesWeighing__c(Name = 'aw5', Attribute__c = prensa, Object__c = contact, Weighing__c = 5);
        AttributesByProfile__c ab1 = new AttributesByProfile__c(AccountAttributes__c = (jubilado + '; ' + estrategico + '; ' + menor), ContactAttributes__c = (vip + '; ' + prensa), SetupOwnerId = userProfile.Id);
        
		Test.startTest();

		Database.Insert(aw1);
		Database.Insert(aw2);
		Database.Insert(aw3);
		Database.Insert(aw4);
        Database.Insert(ab1);
	
        Contact contact1 = new Contact(LastName='Contact1', Attributes__c=vip);
		//Attribute__c autocompletes with VIP (Contact Trigger)
		Database.Insert(contact1);

		contact1.Attributes__c = '';
        Database.update(contact1);

        contact1.Attributes__c = vip + ';' + estrategico;
        Database.update(contact1);
        
		Test.stopTest();

	}
}