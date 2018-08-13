@isTest
public class BillingCycleChangeValidation_test{

    @isTest static void checkIfBillingAccIsDunning_OK(){
        String methodName = 'checkIfBillingAccIsDunning';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName1');
        billingAccount.put('Dunning', false);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName2');
        billingAccount.put('Dunning', false);

        billingAccounts.add(billingAccount);

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> dunningAccounts = (List<Map<String, String>>) outMap.get('DunningAccName');

        System.assertEquals(0, dunningAccounts.size());
        System.assertEquals(false, (boolean) outMap.get('ShowError'));
    }

    @isTest static void checkIfBillingAccIsDunning_Error(){
        String methodName = 'checkIfBillingAccIsDunning';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName1');
        billingAccount.put('Dunning', false);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName2');
        billingAccount.put('Dunning', true);

        billingAccounts.add(billingAccount);

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> dunningAccounts = (List<Map<String, String>>) outMap.get('DunningAccName');

        System.assertEquals(1, dunningAccounts.size());
        System.assertEquals(true, (boolean) outMap.get('ShowError'));
    }

    @isTest static void checkIfBillingAccIsPurchaseFinancing_OK(){
        String methodName = 'checkIfBillingAccIsPurchaseFinancing';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName1');
        billingAccount.put('PurchaseFinancing', false);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName2');
        billingAccount.put('PurchaseFinancing', false);

        billingAccounts.add(billingAccount);

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> purchaseFinancingAccName = (List<Map<String, String>>) outMap.get('PurchaseFinancingAccName');

        System.assertEquals(0, purchaseFinancingAccName.size());
        System.assertEquals(false, (boolean) outMap.get('ShowError'));
    }

    @isTest static void checkIfBillingAccIsPurchaseFinancing_Error(){
        String methodName = 'checkIfBillingAccIsPurchaseFinancing';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName1');
        billingAccount.put('PurchaseFinancing', true);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName2');
        billingAccount.put('PurchaseFinancing', true);

        billingAccounts.add(billingAccount);

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> purchaseFinancingAccName = (List<Map<String, String>>) outMap.get('PurchaseFinancingAccName');

        System.assertEquals(2, purchaseFinancingAccName.size());
        System.assertEquals(true, (boolean) outMap.get('ShowError'));
    }

    @isTest static void calculateCyclingApproval_OK(){
        String methodName = 'calculateCyclingApproval';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();

        Account objAcc1 = new Account(Name = 'TestAccount1');
        Account objAcc2 = new Account(Name = 'TestAccount2');
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc1.Name);
        billingAccount.put('Id', objAcc1.Id);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc2.Name);
        billingAccount.put('Id', objAcc2.Id);

        billingAccounts.add(billingAccount);

        insertBillingDataTrimCustomSetting();

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals(null, outMap.get('error'));
        System.assertEquals('2', outMap.get('CyclingLimitDay'));
    }

    @isTest static void calculateCyclingApproval_Excep(){
        String methodName = 'calculateCyclingApproval';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();

        Account objAcc1 = new Account(Name = 'TestAccount1');
        Account objAcc2 = new Account(Name = 'TestAccount2');
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc1.Name);
        billingAccount.put('Id', objAcc1.Id);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc2.Name);
        billingAccount.put('Id', objAcc2.Id);

        billingAccounts.add(billingAccount);

        //insertBillingDataTrimCustomSetting();

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('error'));
        System.assertEquals(null, outMap.get('CyclingLimitDay'));
    }

    @isTest static void calculateCyclingApproval_OK_WithHistory(){
        String methodName = 'calculateCyclingApproval';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;

        Account objAcc1 = new Account(Name = 'TestAccount1');
        objAcc1.RecordTypeId = billingRecordTypeId;
        insert objAcc1;

        Account objAcc2 = new Account(Name = 'TestAccount2');
        objAcc2.RecordTypeId = billingRecordTypeId;
        insert objAcc2;

        createAccountHistory(objAcc1);
        createAccountHistory(objAcc2);
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc1.Name);
        billingAccount.put('Id', objAcc1.Id);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc2.Name);
        billingAccount.put('Id', objAcc2.Id);

        billingAccounts.add(billingAccount);

        insertBillingDataTrimCustomSetting();

        input.put('SelectedBillingAccounts', billingAccounts);

        Test.startTest();
        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals(null, outMap.get('error'));
        System.assertEquals('2', outMap.get('CyclingLimitDay'));
    }

    @isTest static void generateActiveWithServicesBAs_OK(){
        String methodName = 'generateActiveWithServicesBAs';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;

        Account objAcc1 = new Account(Name = 'TestAccount1');
        objAcc1.RecordTypeId = billingRecordTypeId;
        insert objAcc1;

        Account objAcc2 = new Account(Name = 'TestAccount2');
        objAcc2.RecordTypeId = billingRecordTypeId;
        insert objAcc2;

        Product2 prod = new Product2(Name = 'TestName');
        insert prod;

        Asset assetProd = new Asset(Product2Id=prod.Id, AccountId=objAcc1.Id, Name='TestNameAsset');
        insert assetProd;

        List<Object> assetList = new List<Object>();
        Map<String, Object> assetItem = new Map<String, Object>();
        assetItem.put('Status', 'Active');
        assetList.add(assetItem);
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc1.Name);
        billingAccount.put('Id', objAcc1.Id);
        billingAccount.put('Assets', assetList);
        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc2.Name);
        billingAccount.put('Id', objAcc2.Id);
        billingAccounts.add(billingAccount);

        input.put('BillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();
        Test.startTest();

        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals(null, outMap.get('error'));
    }

    @isTest static void returnSelectedBAs_OK(){
        String methodName = 'returnSelectedBAs';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();

        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        
        Account objAcc1 = new Account(Name = 'TestAccount1');
        objAcc1.RecordTypeId = billingRecordTypeId;
        insert objAcc1;

        Account objAcc2 = new Account(Name = 'TestAccount2');
        objAcc2.RecordTypeId = billingRecordTypeId;
        insert objAcc2;

        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc1.Name);
        billingAccount.put('Id', objAcc1.Id);
        billingAccount.put('isSelected', true);
        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc2.Name);
        billingAccount.put('Id', objAcc2.Id);
        billingAccount.put('isSelected', true);
        billingAccounts.add(billingAccount);

        input.put('BillingAccounts', billingAccounts);

        Test.startTest();
        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals(false, outMap.get('ShowError'));
    }

    @isTest static void returnSelectedBAs_Error(){
        String methodName = 'returnSelectedBAs';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        
        Account objAcc1 = new Account(Name = 'TestAccount1');
        objAcc1.RecordTypeId = billingRecordTypeId;
        insert objAcc1;

        Account objAcc2 = new Account(Name = 'TestAccount2');
        objAcc2.RecordTypeId = billingRecordTypeId;
        insert objAcc2;

        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc1.Name);
        billingAccount.put('Id', objAcc1.Id);
        billingAccount.put('isSelected', true);
        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc2.Name);
        billingAccount.put('Id', objAcc2.Id);
        billingAccount.put('isSelected', false);
        billingAccounts.add(billingAccount);

        input.put('BillingAccounts', billingAccounts);

        Test.startTest();
        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals(true, outMap.get('ShowError'));
    }

    @isTest static void CreateTasks_OK(){
        String methodName = 'CreateTasks';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Case testCase = new Case();
        insert testCase;

        input.put('CaseId', testCase.Id);

        List<Object> billingAccounts = new List<Object>();
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
        
        Account objAcc1 = new Account(Name = 'TestAccount1');
        objAcc1.RecordTypeId = billingRecordTypeId;
        insert objAcc1;

        Account objAcc2 = new Account(Name = 'TestAccount2');
        objAcc2.RecordTypeId = billingRecordTypeId;
        insert objAcc2;

        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc1.Name);
        billingAccount.put('Id', objAcc1.Id);
        billingAccount.put('isSelected', true);
        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', objAcc2.Name);
        billingAccount.put('Id', objAcc2.Id);
        billingAccount.put('isSelected', false);
        billingAccounts.add(billingAccount);

        Map<String, Object> newBillingCycle = new Map<String, Object>();
        NewBillingCycle.put('BillingCycleSelect','14');

        input.put('NewBillingCycle', newBillingCycle);
        input.put('SelectedBillingAccounts', billingAccounts);

        Test.startTest();
        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals(null, outMap.get('error'));
    }

    @isTest static void CreateTasks_Excep(){
        String methodName = 'CreateTasks';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertNotEquals(null, outMap.get('error'));
    }
    
    @isTest static void checkIfBillingAccIsDebtFinancing_OK(){
        String methodName = 'checkIfBillingAccIsDebtFinancing';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName1');
        billingAccount.put('DebtFinancing', false);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName2');
        billingAccount.put('DebtFinancing', false);

        billingAccounts.add(billingAccount);

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> debtFinancingAccName = (List<Map<String, String>>) outMap.get('DebtFinancingAccName');

        System.assertEquals(0, debtFinancingAccName.size());
        System.assertEquals(false, (boolean) outMap.get('ShowError'));
    }

    @isTest static void checkIfBillingAccIsDebtFinancing_Error(){
        String methodName = 'checkIfBillingAccIsDebtFinancing';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Object> billingAccounts = new List<Object>();
        
        Map<String, Object> billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName1');
        billingAccount.put('DebtFinancing', true);

        billingAccounts.add(billingAccount);

        billingAccount = new Map<String, Object>();
        billingAccount.put('Name', 'TestName2');
        billingAccount.put('DebtFinancing', true);

        billingAccounts.add(billingAccount);

        input.put('SelectedBillingAccounts', billingAccounts);

        BillingCycleChangeValidation classToBeTested = new BillingCycleChangeValidation();

        Test.startTest();
        classToBeTested.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> debtFinancingAccName = (List<Map<String, String>>) outMap.get('DebtFinancingAccName');

        System.assertEquals(2, debtFinancingAccName.size());
        System.assertEquals(true, (boolean) outMap.get('ShowError'));
    }

    static void insertBillingDataTrimCustomSetting(){
        vlocity_cmt__BillingDataTrim__c setting = new vlocity_cmt__BillingDataTrim__c();
        
        setting.Name = 'a';
        setting.BillCycleMaxDays__c = 2;
        setting.vlocity_cmt__TrimDate__c = Date.today();
        
        insert setting;
    }

    static Account createAccount(){
        Account objAcc = new Account(Name = 'TestAccount');

        insert objAcc;

        return objAcc;
    }

    static void createAccountHistory(Account objAcc){
        AccountHistory accHist = new AccountHistory(AccountId = objAcc.Id, Field='Billing_Day__c');

        insert accHist;
    }
}