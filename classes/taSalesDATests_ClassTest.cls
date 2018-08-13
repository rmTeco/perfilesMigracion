@isTest
public class taSalesDATests_ClassTest {
    
    @testSetup
	static void setup() {
		Account acc = new Account(Name = 'test');
		insert acc;
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c();
        priceList.Name = 'Telecom Price List';
        priceList.vlocity_cmt__Code__c = 'Code-Test';
        insert priceList;
		Order ord = new Order(AccountId = acc.Id, EffectiveDate = date.today(), Status = 'Draft');
		insert ord;
	}
    
    public static testmethod void validateSuspensionsTest(){
		Order ord = [SELECT Id FROM Order LIMIT 1];
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> options = new Map<String, Object>();
		options.put('OrderId', ord.Id);
        
		Test.startTest();
		taSalesDATests tscc = new taSalesDATests();
		tscc.invokeMethod('ValidateSuspensions', inputMap, outMap, options);
		Test.stopTest();
	}
    
    public static testmethod void paymentRollbackTest(){
		Order order = [SELECT Id FROM Order LIMIT 1];
        Account acct = [SELECT Id FROM Account LIMIT 1];
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> options = new Map<String, Object>();
        
        vlocity_cmt__PaymentAdjustment__c payment = new vlocity_cmt__PaymentAdjustment__c(Order__c = order.Id,vlocity_cmt__AccountId__c = acct.Id);       
        insert payment;
  
        options.put('OrderId', payment.Order__c );
      
		Test.startTest();
		taSalesDATests tscc = new taSalesDATests();
		tscc.invokeMethod('PaymentRollback', inputMap, outMap, options);
		Test.stopTest();
	}
    
}