@isTest
global with sharing class taSalesPaymentMethodsExtensionTest {

  @isTest static void constructorTest(){
    Account acc = TestDataFactory.createAccounts(1)[0];
    Order ord = TestDataFactory.createOrders(1, acc)[0];

        Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '1001',
            vlocity_cmt__AccountId__c = acc.Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethod;

    List<vlocity_cmt__PaymentAdjustment__c> paymAdj = TestDataFactory.createPaymentAdjustments(1, acc, ord, objPaymentMethod, 0);

    ApexPages.currentPage().getParameters().put('lc',ord.id);
    ApexPages.StandardController stdLead = new ApexPages.StandardController(ord);

    taSalesPaymentMethodsExtension testClass = new taSalesPaymentMethodsExtension(stdLead);

    System.assertEquals(testClass.paymentMethods[0].Id, paymAdj[0].Id);
  }
}