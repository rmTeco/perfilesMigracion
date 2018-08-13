@IsTest
public class PaymentMethodTriggerHandlerTest {
    @IsTest static void processPaymentMethodUpdatesTest(){
            System.debug('ENTRO PaymentMethodTriggerHandlerTest.processPaymentMethodUpdatesTest');
        
            List<Account> testAccount = TestDataFactory.createAccounts(1,'Consumer');
            List<vlocity_cmt__PaymentMethod__c> testPaymentMethod = TestDataFactory.createPaymentMethod(4,testAccount[0]);
        
            testPaymentMethod[0].vlocity_cmt__MethodType__c = 'Credit Card';
            Update testPaymentMethod[0];
            
            Test.startTest();
            PaymentMethodTriggerHandler.processPaymentMethodUpdates(testPaymentMethod);
            Test.stopTest();
        
            system.assertEquals( testAccount[0].Id, testPaymentMethod[0].vlocity_cmt__AccountId__c);
                
        }
}