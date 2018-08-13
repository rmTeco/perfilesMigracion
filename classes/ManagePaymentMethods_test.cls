@isTest
public class ManagePaymentMethods_test {
    
    @isTest
    static void testUpdateStatusCard(){
        String methodName = 'updateStatusCard';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Account acc = new Account(Name = 'test');
		insert acc;
		vlocity_cmt__PaymentMethod__c paymentMethodForTest = 
            new vlocity_cmt__PaymentMethod__c(vlocity_cmt__AccountId__c = acc.Id,
                                             vlocity_cmt__MethodType__c = 'Tarjeta de Credito');
        insert paymentMethodForTest;
        input.put('PaymentId', paymentMethodForTest.Id);
        
        Test.startTest();
        ManagePaymentMethods classToBeTested = new ManagePaymentMethods();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

    }
    
    @isTest
    static void testGetAccountIdUpdate(){
        String methodName = 'getAccountId';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> automaticDebitAction = new Map<String, Object>();
        automaticDebitAction.put('SelectedAutomaticDebitAction', 'Update');
        input.put('AutomaticDebitAction', automaticDebitAction);
        Account acc = new Account(Name = 'test');
		insert acc;
        
        input.put('BillingAccountToResponse', acc.Id);

        ManagePaymentMethods classToBeTested = new ManagePaymentMethods();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
    }
    
    @isTest
    static void testGetAccountId(){
        String methodName = 'getAccountId';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> automaticDebitAction = new Map<String, Object>();
        automaticDebitAction.put('SelectedAutomaticDebitAction', '');
        input.put('AutomaticDebitAction', automaticDebitAction);
        Account acc = new Account(Name = 'test');
		insert acc;
		Map<String, Object> BillingAccounts = new Map<String, Object>();
		BillingAccounts.put('1', acc);
        
        input.put('BillingAccounts', BillingAccounts);

        ManagePaymentMethods classToBeTested = new ManagePaymentMethods();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
    }

}