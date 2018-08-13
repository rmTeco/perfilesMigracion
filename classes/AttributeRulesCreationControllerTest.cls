/**
 * @Author: Julia Carranza
 * @Description: This test tests the attributesLandingController Class.
 */
@isTest
public class AttributeRulesCreationControllerTest {
  static testMethod void myUnitTest(){
    String jubilado = 'Jubilado';
    String estrategico = 'Estratégico';
    String menor = 'Menor';
    String vip = 'VIP';
        String prensa = 'Prensa';
    String account = 'Account';
        String contact = 'Contact';

        AttributesRules__c ar1 = new AttributesRules__c(Name = '0000', Attribute1__c = jubilado, Attribute2__c = menor, Object__c = account);
    //AttributesRules__c ar2 = new AttributesRules__c(Name = 'ar2', Attribute1__c = estrategico, Attribute2__c = prensa, Object__c = contact);
    
    Test.StartTest(); 

        Database.Insert(ar1);
    
    PageReference pageRef1 = Page.AttributeRulesCreation; 
      AttributeRulesCreationController cont1 = new AttributeRulesCreationController();

        cont1.record.Id = ar1.Id;
        cont1.record.attribute1__c = ar1.attribute1__c;
        cont1.record.attribute2__c = ar1.attribute2__c;
        cont1.refillAttributesList();
        cont1.cancel();
        cont1.save();

        cont1.record.Id = Null;
        cont1.record.attribute1__c = estrategico;
        cont1.record.attribute2__c = prensa;
        cont1.refillAttributesList();
        cont1.cancel();
        cont1.save();

      Test.StopTest();
  }
}