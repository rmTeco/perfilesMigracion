@isTest(seeAllData = false)
public with sharing class ta_sales_NewAccountTest {
    
    public static testMethod void calculateCreditRiskAndLimitForConsumerAccountTest() {
        MockupFactory.generate();
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('AccountType', 'Consumer');
        options.put('ContactId', contact.Id);
        
		Test.startTest();
		ta_sales_NewAccount tsna = new ta_sales_NewAccount();
		tsna.invokeMethod('CalculateCreditRiskAndLimit', inputMap, outMap, options);
		Test.stopTest();        
    }

    public static testMethod void calculateCreditRiskAndLimitForBusinessAccountTest() {
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap.put('ContactName', 'aName');
        auxMap.put('NewAccountDocumentType', 'DNI');
        auxMap.put('NewAccountDocumentNumber', '12345678');

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('AccountType', 'Business');
        inputMap.put('AccountData', auxMap);
        
		Test.startTest();
		ta_sales_NewAccount tsna = new ta_sales_NewAccount();
		tsna.invokeMethod('CalculateCreditRiskAndLimit', inputMap, outMap, options);
		Test.stopTest();        
    }

    public static testMethod void calculateCreditRiskAndLimitForContactTest() {
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap.put('FirstName', 'aName');
        auxMap.put('LastName', 'aLastName');
        auxMap.put('Gender', 'M');
        auxMap.put('DocumentType', 'DNI');
        auxMap.put('DocumentNumber', '12345678');

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('AccountType', 'Business');
        inputMap.put('Contact', auxMap);
        
		Test.startTest();
		ta_sales_NewAccount tsna = new ta_sales_NewAccount();
		tsna.invokeMethod('CalculateCreditRiskAndLimit', inputMap, outMap, options);
		Test.stopTest();        
    }
}