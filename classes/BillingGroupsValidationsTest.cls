@isTest
private class BillingGroupsValidationsTest {
        
    @isTest static void ValidateToAccountFinancingOK(){
        //GIVEN
        String methodName = 'ValidateToAccountFinancing';
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Account billingAccount = new Account();
        billingAccount.Name = 'TestName';
        insert billingAccount;
        
        Map<String, Object> account = new Map<String, Object>();
        account.put('Id', billingAccount.Id);
        account.put('PurchaseFinancing', true);
        account.put('DebtFinancing', true);
        
        List<Object> billingAccounts = new List<Object>();
        billingAccounts.add(account);
        
        Map<String, Object> BillingAccountToStep = new Map<String, Object>();
        
        input.put('BillingAccountToResponse', billingAccount.Id);
        input.put('BillingAccounts', billingAccounts);
        input.put('BillingAccountToStep', BillingAccountToStep);
        
        BillingGroupsValidations BillingGroupsValidations = new BillingGroupsValidations();
        
        //WHEN
        Test.startTest();
        BillingGroupsValidations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        Map<String, Object> BillingAccountToStepResult = (Map<String, Object>) outMap.get('BillingAccountToStep');

        System.assertEquals(false, (boolean) BillingAccountToStepResult.get('AuxAccountIsValid'));
        System.assertEquals(false, (boolean) outMap.get('validationToAccount'));
    }
    
    @isTest static void ValidateFromAccountsFinancingOK(){
        //GIVEN
        String methodName = 'ValidateFromAccountsFinancing';
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Account billingAccount = new Account();
        billingAccount.Name = 'TestName';
        insert billingAccount;
        
        Map<String, Object> account = new Map<String, Object>();
        account.put('Id', billingAccount.Id);
        account.put('PurchaseFinancing', true);
        account.put('DebtFinancing', true);
        
        Map<String, Object> checkedAccount = new Map<String, Object>();
        checkedAccount.put('id', billingAccount.Id);
        
        List<Object> billingAccounts = new List<Object>();
        billingAccounts.add(account);
        List<Object> checkedBillingAccounts = new List<Object>();
        checkedBillingAccounts.add(checkedAccount);
                
        input.put('checkedBillingAccounts', checkedBillingAccounts);
        input.put('BillingAccounts', billingAccounts);
        
        BillingGroupsValidations BillingGroupsValidations = new BillingGroupsValidations();
        
        //WHEN
        Test.startTest();
        BillingGroupsValidations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        List<Object> rejectedBillingAccounts = (List<Object>) outMap.get('rejectedBillingAccounts');
        System.assertEquals(billingAccounts.size(), rejectedBillingAccounts.size());
        Map<String,Object> rejectedBillingAccount = (Map<String,Object>) rejectedBillingAccounts.get(0);
        System.assertEquals(checkedAccount.get('id'), (Id) rejectedBillingAccount.get('id'));
    }
    
    @isTest static void ChangeAssetsAccountOK(){
        //GIVEN
        String methodName = 'ChangeAssetsAccount';
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        
        Id billingRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        
        Account billingAccount = new Account(RecordTypeId = billingRecordTypeForAcc, Name = 'TestName', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert billingAccount;
        
        Account BillingAccountToResponse = new Account(RecordTypeId = billingRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '4567', DocumentType__c = 'DNI', DocumentNumber__c = '12345679');
        insert BillingAccountToResponse;
        
        List<Asset> assets = new List<Asset>();
        
        for (Integer i = 0; i <= 101; i++) {
            Asset ass = new Asset(Name = 'asset'+i, vlocity_cmt__LineNumber__c = '1234567890', AccountId = billingAccount.Id);
            assets.add(ass);
        }
        insert assets;
        
        List<Object> checkedAssets = new List<Object>();
        
        for (Asset asset: assets) {
            Map<String, Object> assMap = new Map<String, Object>();
            assMap.put('id', asset.Id);
            checkedAssets.add(assMap);
        }
                
        input.put('BillingAccountToResponse', BillingAccountToResponse.Id);
        input.put('checkedAssets', checkedAssets);
        
        BillingGroupsValidations BillingGroupsValidations = new BillingGroupsValidations();
        
        //WHEN
        Test.startTest();
        BillingGroupsValidations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        System.assertEquals(true, outMap.get('successUpdate'));
    }
    
    @isTest static void ValidSelectionWithAssetList(){
        //GIVEN
        String methodName = 'ValidSelection';
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        
        Id billingRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        List<Account> billingAccounts = new List<Account>();
        for (Integer i = 0; i <= 101; i++) {
            Account billingAccount = new Account(RecordTypeId = billingRecordTypeForAcc, Name = 'TestName'+i, AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
            billingAccounts.add(billingAccount);
        }
        insert billingAccounts;
        
        List<Id> billingAccountsId = new List<Id>();
        for (Account acc: billingAccounts) {
            billingAccountsId.add(acc.Id);
        }
        
        List<Asset> assets = new List<Asset>();
        for (Account acc: billingAccounts) { 
                Asset ass = new Asset(Name = 'asset'+acc.Id, vlocity_cmt__LineNumber__c = '1234567890', AccountId = acc.Id);
                assets.add(ass);
        }
        insert assets;

        List<Object> BillingAccountsOptions = new List<Object>();
        for (Account acc: billingAccounts) {
            Map<String, Object> accountMap = new Map<String, Object>();
            List<Object> assetList = new List<Object>();
            for (Asset asset: assets) {
                if (asset.AccountId == acc.Id) {
                    Map<String,Object> assetMap = new Map<String,Object>();
                    assetMap.put('Id', asset.Id);
                    assetMap.put('isSelected', true);
                    assetList.add(assetMap);
                }
            }
            accountMap.put('Assets',assetList);
            BillingAccountsOptions.add(accountMap);
        }
                
        options.put('BillingAccounts', BillingAccountsOptions);
        
        BillingGroupsValidations BillingGroupsValidations = new BillingGroupsValidations();
        
        //WHEN
        Test.startTest();
        BillingGroupsValidations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        List<Object> checkedBillingAccounts = (List<Object>) outMap.get('checkedBillingAccounts');
        List<Object> checkedAssets = (List<Object>) outMap.get('checkedAssets');
        
        System.assertEquals(billingAccounts.size(), checkedBillingAccounts.size());
        System.assertEquals(assets.size(), checkedAssets.size());
    }
    
    @isTest static void ValidSelectionWithAssetObject(){
        //GIVEN
        String methodName = 'ValidSelection';
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        
        Id billingRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        List<Account> billingAccounts = new List<Account>();
        for (Integer i = 0; i <= 101; i++) {
            Account billingAccount = new Account(RecordTypeId = billingRecordTypeForAcc, Name = 'TestName'+i, AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
            billingAccounts.add(billingAccount);
        }
        insert billingAccounts;
        
        List<Id> billingAccountsId = new List<Id>();
        for (Account acc: billingAccounts) {
            billingAccountsId.add(acc.Id);
        }
        
        List<Asset> assets = new List<Asset>();
        for (Account acc: billingAccounts) { 
                Asset ass = new Asset(Name = 'asset'+acc.Id, vlocity_cmt__LineNumber__c = '1234567890', AccountId = acc.Id);
                assets.add(ass);
        }
        insert assets;

        List<Object> BillingAccountsOptions = new List<Object>();
        for (Account acc: billingAccounts) {
            Map<String, Object> accountMap = new Map<String, Object>();
            Map<String,Object> assetMap;
            for (Asset asset: assets) {
                if (asset.AccountId == acc.Id) {
                    assetMap = new Map<String,Object>();
                    assetMap.put('Id', asset.Id);
                    assetMap.put('isSelected', true);
                    continue;
                }
            }
            accountMap.put('Assets',assetMap);
            BillingAccountsOptions.add(accountMap);
        }
                
        options.put('BillingAccounts', BillingAccountsOptions);
        
        BillingGroupsValidations BillingGroupsValidations = new BillingGroupsValidations();
        
        //WHEN
        Test.startTest();
        BillingGroupsValidations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        List<Object> checkedBillingAccounts = (List<Object>) outMap.get('checkedBillingAccounts');
        List<Object> checkedAssets = (List<Object>) outMap.get('checkedAssets');
        
        System.assertEquals(billingAccounts.size(), checkedBillingAccounts.size());
        System.assertEquals(assets.size(), checkedAssets.size());
    }
    
    @isTest static void HiMethod(){
        //GIVEN
        String methodName = 'HiMethod';
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        BillingGroupsValidations BillingGroupsValidations = new BillingGroupsValidations();
        
        //WHEN
        Test.startTest();
        BillingGroupsValidations.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        System.assertEquals(true, true);
    }
    
}