@isTest
public class TaxConditionChanges_test {

    @isTest static void PopulateIIBBExemptionsAllProvinces_OK(){
        String methodName = 'PopulateIIBBExemptionsAllProvinces';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TaxConditionChanges objTaxCondChanges = new TaxConditionChanges();

        Test.startTest();
        String idTaxCond = createTaxCondition();

        options.put('DRId_TaxCondition__c', idTaxCond);

        objTaxCondChanges.invokeMethod(methodName, input, outMap, options);
        
        List<TaxConditionDetail__c> taxCondDetList = [SELECT Id, Name FROM TaxConditionDetail__c];

        Test.stopTest();

        Schema.DescribeFieldResult fieldResult = TaxConditionDetail__c.Jurisdiction__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        system.assertEquals(ple.size(), taxCondDetList.size());
        system.assertEquals(null, (String) outMap.get('error'));
    }

    @isTest static void PopulateIIBBExemptionsAllProvinces_Excep(){
        String methodName = 'PopulateIIBBExemptionsAllProvinces';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TaxConditionChanges objTaxCondChanges = new TaxConditionChanges();

        Test.startTest();

        options.put('DRId_TaxCondition__c', -1);

        objTaxCondChanges.invokeMethod(methodName, input, outMap, options);

        Test.stopTest();

        system.assertNotEquals('', (String) outMap.get('error'));
    }

    @isTest static void Save_DNI_OK(){
        String methodName = 'Save';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selectTaxCondToModify = new Map<String, Object>();
        Map<String, Object> taxConditionChange = new Map<String, Object>();

        taxConditionChange.put('TaxConditionChange', 'DNI');
        selectTaxCondToModify.put('TaxConditionBlock', taxConditionChange);
        input.put('Step_2_Select_Tax_Condition_To_Modify', selectTaxCondToModify);

        Test.startTest();

        TaxConditionChanges objTaxCondChanges = new TaxConditionChanges();
        objTaxCondChanges.invokeMethod(methodName, input, outMap, options);

        Test.stopTest();

        system.assertEquals(null, (String) outMap.get('error'));
    }

    @isTest static void Save_DNI_Consumer_OK(){
        String methodName = 'Save';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selectTaxCondToModify = new Map<String, Object>();
        Map<String, Object> taxConditionChange = new Map<String, Object>();

        taxConditionChange.put('TaxConditionChange', 'DNI');
        selectTaxCondToModify.put('TaxConditionBlock', taxConditionChange);
        
        Map<String, Object> objContact = new Map<String, Object>();
        Map<String, Object> objConsumer = new Map<String, Object>();
        Map<String, Object> objAccount = new Map<String, Object>();
        //String idAccount = createAccount();
        
        List<Account> idAccount = TestDataFactory.createAccounts(1,'Consumer');
        idAccount[0].AccountIntegrationId__c=null;
        Update idAccount; 
        objAccount.put('Id', idAccount[0].Id);

        objConsumer.put('Account', objAccount);
        objContact.put('Consumer', objConsumer);


        input.put('Contact', objContact);
        input.put('Step_2_Select_Tax_Condition_To_Modify', selectTaxCondToModify);
        Test.startTest();

        TaxConditionChanges objTaxCondChanges = new TaxConditionChanges();
        objTaxCondChanges.invokeMethod(methodName, input, outMap, options);

        Test.stopTest();

        system.assertNotEquals(null, (String) outMap.get('NewAccountId'));
        system.assertEquals(null, (String) outMap.get('error'));
    }

    @isTest static void Save_DNI_Consumer_Excep(){
        String methodName = 'Save';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selectTaxCondToModify = new Map<String, Object>();
        Map<String, Object> taxConditionChange = new Map<String, Object>();

        taxConditionChange.put('TaxConditionChange', 'DNI');
        selectTaxCondToModify.put('TaxConditionBlock', taxConditionChange);
        
        Map<String, Object> objContact = new Map<String, Object>();
        Map<String, Object> objConsumer = new Map<String, Object>();
        Map<String, Object> objAccount = new Map<String, Object>();
        //String idAccount = createAccount();
        objAccount.put('Id', -1);

        objConsumer.put('Account', objAccount);
        objContact.put('Consumer', objConsumer);


        input.put('Contact', objContact);
        input.put('Step_2_Select_Tax_Condition_To_Modify', selectTaxCondToModify);

        Test.startTest();

        TaxConditionChanges objTaxCondChanges = new TaxConditionChanges();
        objTaxCondChanges.invokeMethod(methodName, input, outMap, options);

        Test.stopTest();

        system.assertEquals(null, (String) outMap.get('NewAccountId'));
        system.assertEquals(null, (String) outMap.get('error'));
    }

    @isTest static void Save_CUIT_Consumer_OK(){
        String methodName = 'Save';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> selectTaxCondToModify = new Map<String, Object>();
        Map<String, Object> taxConditionChange = new Map<String, Object>();

        taxConditionChange.put('TaxConditionChange', 'CUIT');
        selectTaxCondToModify.put('TaxConditionBlock', taxConditionChange);
        
        Map<String, Object> objContact = new Map<String, Object>();
        Map<String, Object> objConsumer = new Map<String, Object>();
        Map<String, Object> objAccount = new Map<String, Object>();
        String idAccount = createAccount();
        objAccount.put('Id', idAccount);

        objConsumer.put('Account', objAccount);
        objContact.put('Consumer', objConsumer);


        input.put('Contact', objContact);
        input.put('Step_2_Select_Tax_Condition_To_Modify', selectTaxCondToModify);

        Test.startTest();

        TaxConditionChanges objTaxCondChanges = new TaxConditionChanges();
        objTaxCondChanges.invokeMethod(methodName, input, outMap, options);

        Test.stopTest();

        system.assertEquals(null, (String) outMap.get('NewAccountId'));
        system.assertEquals(null, (String) outMap.get('error'));
    }

    static String createTaxCondition()
    {
        TaxCondition__c taxCond = new TaxCondition__c(Status__c='Activo');
        
        insert taxCond;

        return taxCond.Id;
    }

    static string createAccount(){
        Account objAcc = new Account(Name = 'TestAccount');

        insert objAcc;

        return objAcc.Id;
    }
}