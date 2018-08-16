/**
 * @Author: Julia Carranza
 * @Description: This test tests the AttributesWeighingController Class.
 */
@isTest
public class AttributesWeighingControllerTest {

		static testMethod void myUnitTest(){
		String jubilado = 'Jubilado';
		String estrategico = 'Estratégico';
		String menor = 'Menor';
		String vip = 'VIP';
        String prensa = 'Prensa';
		String account = 'Account';
        String contact = 'Contact';

		AttributesWeighing__c aw1 = new AttributesWeighing__c(Name = 'aw1', Attribute__c = jubilado, Object__c = account, Weighing__c = 1);
		AttributesWeighing__c aw2 = new AttributesWeighing__c(Name = 'aw2', Attribute__c = estrategico, Object__c = account, Weighing__c = 2);
		AttributesWeighing__c aw3 = new AttributesWeighing__c(Name = 'aw3', Attribute__c = menor, Object__c = account, Weighing__c = 3);
		AttributesWeighing__c aw4 = new AttributesWeighing__c(Name = 'aw4', Attribute__c = vip, Object__c = contact, Weighing__c = 4);
        AttributesWeighing__c aw5 = new AttributesWeighing__c(Name = 'aw5', Attribute__c = prensa, Object__c = contact, Weighing__c = 5);

		Test.StartTest(); 

		Database.Insert(aw1);
		Database.Insert(aw2);
		Database.Insert(aw3);
		Database.Insert(aw4);
	    
	    PageReference pageRef1 = Page.AttributesWeighing; 
	    attributesWeighingController cont1 = new attributesWeighingController();

	    cont1.refillAttributesList();
	    cont1.cancel();
	    cont1.save();

	    Test.StopTest();
	}

    //PageReference pageRef3 = Page.AttributesByProfile;
    //PageReference pageRef4 = Page.AttributeRulesCreation;
    /*attributesWeighingController cont2 = new attributesWeighingController();
    cont2.refillAttributesList();
    cont2.cancel();
    cont2.save();*/
}