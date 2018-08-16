/**
 * @Author: Julia Carranza
 * @Description: This test tests the AttributesByProfileController Class.
 */
@isTest
public class AttributesByProfileControllerTest {

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

		AttributesByProfile__c ab1 = new AttributesByProfile__c(AccountAttributes__c = (jubilado + ';' + estrategico + ';' + menor), ContactAttributes__c = (vip + ';' + prensa), SetupOwnerId = userProfile.Id);
	        
		Test.StartTest(); 

		Database.Insert(ab1);

		PageReference pageRef1 = Page.AttributesByProfile; 
	    AttributesByProfileController cont1 = new AttributesByProfileController();

	    cont1.selectedProfile = ab1.Id;
        cont1.refillPage();
        cont1.cancel();
        cont1.save();

		Test.StopTest();
	}
}

/*
@isTest
public class attributesLandingControllerTest {

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

        AttributesRules__c ar1 = new AttributesRules__c(Name = 'ar1', Attribute1__c = jubilado, Attribute2__c = menor, Object__c = account);
		AttributesRules__c ar2 = new AttributesRules__c(Name = 'ar2', Attribute1__c = estrategico, Attribute2__c = prensa, Object__c = contact);
		
		AttributesByProfile__c ab1 = new AttributesByProfile__c(AccountAttributes__c = (jubilado + ';' + estrategico + ';' + menor), ContactAttributes__c = (vip + ';' + prensa), SetupOwnerId = userProfile.Id);
        
		Test.StartTest(); 

        Database.Insert(ar1);
		Database.Insert(ar2);
		Database.Insert(aw1);
		Database.Insert(aw2);
		Database.Insert(aw3);
		Database.Insert(aw4);
		Database.Insert(ab1);
	    
	    PageReference pageRef1 = Page.attributesLanding; 
	    attributesLandingController cont1 = new attributesLandingController();

        cont1.refillPage();
        cont1.newrule();
        cont1.selectedRuleId = ar1.Id;
        cont1.DeleteRule();
        cont1.selectedProfileId = ab1.Id;
        cont1.DeleteProfile();
        cont1.newProfile();
        cont1.EditProfile();
        cont1.weighingEdit();

	    Test.StopTest();
	}
}*/