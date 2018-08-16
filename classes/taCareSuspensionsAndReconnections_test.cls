@isTest
public class taCareSuspensionsAndReconnections_test {

    @isTest
    static void createListChildCasesUnfraudBA_test() {
        
        //esta test debe enviar DRId_Case y una lista de BillingAccs. assert equals de casos creados con Subject = Suspension/Habilitacion por Administrativo
        String methodName = 'createListChildCasesUnfraudBA';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object>empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        Case caseParent = new Case();
        caseParent.description = 'testCase';
        caseParent.subject = 'testCase';
        insert caseParent;
        
        List<Account> listAccount = TestDataFactory.createAccounts(1);
        
        String idTest = (String)listAccount[0].Id;
        String nameTest = (String)listAccount[0].Name;
       
        string BillingAccs = '[{"Fraud": false,"Status": "Active","Id":"'+idTest+'","$$hashKey": "object:613","Name":"'+nameTest+'","vlcSelected": true}]';
        List<Object> responseNode = (List<Object>) JSON.deserializeUntyped(BillingAccs);
        
        
        options.put('DRId_Case',caseParent.Id);
        options.put('BillingAccs',responseNode);
               

        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
        List<Case> childCases = [SELECT CaseNumber from Case where Subject =: 'Suspension/Habilitacion por Administrativo'];
        system.assertEquals(true,childCases.size()>0);
    }
    
    @isTest
    static void createListChildCasesFraudBA_test() {
        
        //esta test debe enviar DRId_Case y una lista de FraudBillingAccs. assert equals de casos creados con Subject = Suspension/Habilitacion por Administrativo
        String methodName = 'SuspencreateListChildCasesFraudBAdAssets';//'createListChildCasesFraudBA';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        Case caseParent = new Case();
        caseParent.description = 'testCase';
        caseParent.subject = 'testCase';
        insert caseParent;
        
        List<Account> listAccount = TestDataFactory.createAccounts(1);
        
        String idTest = (String)listAccount[0].Id;
        String nameTest = (String)listAccount[0].Name;
       
        string FraudBillingAccs = '[{"Fraud": false,"Status": "Active","Id":"'+idTest+'","$$hashKey": "object:613","Name":"'+nameTest+'","vlcSelected": true}]';
        List<Object> responseNode = (List<Object>) JSON.deserializeUntyped(FraudBillingAccs);
        
        
        options.put('DRId_Case',caseParent.Id);
        options.put('FraudBillingAccs',responseNode);       

        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
        List<Case> childCases = [SELECT CaseNumber from Case where Subject =: 'Suspension/Habilitacion por Administrativo'];
        system.assertEquals(true,childCases.size()>0);
        
    }
    
    @isTest
    static void createListChildCasesAssets_test() {
        
        //esta test debe enviar DRId_Case y una lista de AssetsM. assert equals de casos creados con Subject = Suspension/Habilitacion por Administrativo
        String methodName = 'createListChildCasesAssets';//'createListChildCasesFraudBA';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        Case caseParent = new Case();
        caseParent.description = 'testCase';
        caseParent.subject = 'testCase';
        insert caseParent;
        
        List<Account> listAccount = TestDataFactory.createAccounts(1);
        List<Asset> listAsset = TestDataFactory.createAssets(1,listAccount[0],'111111');
        String idTest = (String)listAsset[0].Id;
        
        string AssetsM = '[{"Name": "Simcard","isValid": true,"AssetId": "'+idTest+'","$$hashKey": "object:601","vlcSelected": true}]';
        List<Object> responseNode = (List<Object>) JSON.deserializeUntyped(AssetsM);
        Id postsalesId = Schema.SObjectType.Case.GetRecordTypeInfosByName().Get('Postsales').GetRecordTypeId();
        
        options.put('DRId_Case',caseParent.Id);
        options.put('AssetsM',responseNode);
        options.put('RecordTypeId',postsalesId);
               
        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
        List<Case> childCases = [SELECT CaseNumber from Case where Subject =: 'Suspension/Habilitacion por Administrativo'];
        system.assertEquals(true,childCases.size()>0);
        
        
    }
    
    @isTest
    static void createOrder_test() {
        
        //esta test debe enviar lista de selectedAsset. crear Orden dentro del output. assert equals de orderItem.vlocity_cmt__SubAction__c = Suspend-Cliente .
        String methodName = 'createOrder';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        
        string args = '{"isValid":true,"Status":"Active","NumberLine":"1168405934","Name":"Simcard","AssetId":"02i6C0000002csJQAQ"}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(args);
        inputMap.put('selectedAsset',responseNode);
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null); 
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        
        
        List<Order> ord = TestDataFactory.createOrders(1, accs[0]);
        
        Pricebook2 price = TestDataFactory.createPriceBook('PriceBookTest');
        List<OrderItem> ordItem = TestDataFactory.createOrderItem(1, ord[0]);   
        
        
        args = '{"ordId": "'+ordItem[0].OrderId+'","Name":"OrdItemObj"}';
        responseNode = (Map<String, Object>) JSON.deserializeUntyped(args);
        inputMap.put('orderItem',responseNode);
        
        args = '{"Radio1-SuspensionOrReconnection":"Suspension"}';
        responseNode = (Map<String, Object>) JSON.deserializeUntyped(args);
        inputMap.put('Step1-SuspensionOrReconnection',responseNode);
        
        
        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
        List<OrderItem> updatedOrderItems = [SELECT Id, vlocity_cmt__SubAction__c FROM OrderItem WHERE Id = :ordItem[0].Id];
        
        //System.assertEquals('Suspend-Cliente',updatedOrderItems[0].vlocity_cmt__SubAction__c);
        
        
    }
    
    @isTest
    static void createOrderBackOffice_test() {
        
        //esta test debe enviar lista de selectedAsset. crear Orden dentro del output. assert equals de orderItem.vlocity_cmt__SubAction__c = Suspend-Cliente .
        String methodName = 'createOrderBackoffice';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null); 
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> ord = TestDataFactory.createOrders(1, accs[0]);
        Pricebook2 price = TestDataFactory.createPriceBook('PriceBookTest');
        List<OrderItem> ordItem = TestDataFactory.createOrderItem(1, ord[0]);
       
        /*string CtxId = (string)accs[0].Id;
        inputMap.put('ContextId',CtxId);
        List<Asset> asstLst = TestDataFactory.createAssets(1,accs[0],'1168405934');
        system.debug(asstLst[0].Id);
        string AsstId = (string)asstLst[0].Id;
        */
        inputMap.put('ContextId','0016C000009IOSI');
        string step3 = '{"AssetsM":[{"Name": "Simcard","isValid": true,"AssetId": "02i6C0000002h3jQAA","$$hashKey": "object:601","vlcSelected": true}]}';
        Map<String,Object> responseNode2 = (Map<String,Object>) JSON.deserializeUntyped(step3);
        inputMap.put('Step3',responseNode2);
        
        string step2 = '{"optionSelectAsset":"linea"}';
        Map<String,Object> responseNode3 = (Map<String,Object>) JSON.deserializeUntyped(step2);
        inputMap.put('Step2-SelectAssetOrDocument',responseNode3);
        
        string args = '{"isValid":true,"Status":"Active","NumberLine":"1168405934","Name":"Simcard","AssetId":"02i6C0000002h3jQAA"}';
        Map<String, Object> responseNode4 = (Map<String, Object>) JSON.deserializeUntyped(args);
        inputMap.put('selectedAsset',responseNode4);
        
        string testX = '{"SelectSuspensionOrReconnection":"Suspension"}';
        Map<String,Object> responseNodeX = (Map<String,Object>) JSON.deserializeUntyped(testX);
        inputMap.put('Step1-SelectSuspensionOrReconnection',responseNodeX);
    
        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
        List<OrderItem> updatedOrderItems = [SELECT Id, vlocity_cmt__SubAction__c FROM OrderItem WHERE Id = :ordItem[0].Id];
        
        //System.assertEquals('Suspend-Cliente',updatedOrderItems[0].vlocity_cmt__SubAction__c);
        
        
    }
    
    @isTest static void submitOrder_test() {
        
        //esta test debe enviar DRId_Case y una lista de BillingAccs. assert equals de casos creados con Subject = Suspension/Habilitacion por Administrativo
        String methodName = 'SubmitOrders';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object>empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
            
        //string args = '';
        //Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(args);
        inputMap.put('idOrdenCreada','8016C0000008Xiv');
               

        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
    }
    
    @isTest static void SuspendAssets_test() {
        
        String methodName = 'SuspendAssets';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        List<Account> listAccount = TestDataFactory.createAccounts(1);
        List<Asset> listAsset = TestDataFactory.createAssets(1,listAccount[0]);
        
        inputMap.put('ContextId',listAccount[0].Id);
        options.put('AssetToResumeId',listAsset[0].Id);
               
        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
    }
    
    @isTest static void ResumeAssets_test() {
        
        String methodName = 'ResumeAssets';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        List<Account> listAccount = TestDataFactory.createAccounts(1);
        List<Asset> listAsset = TestDataFactory.createAssets(1,listAccount[0]);
        
        inputMap.put('ContextId',listAccount[0].Id);
        options.put('AssetToResumeId',listAsset[0].Id);
               
        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
    }
    
    @isTest static void getSuspendedDevicesByAccountId_test() {
        
        String methodName = 'getSuspendedDevicesByAccountId';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        List<Account> listAccount = TestDataFactory.createAccounts(1);
        inputMap.put('ContextId',listAccount[0].Id);
        
        Id transactionHistoryRecordTypeId = Schema.SObjectType.Transaction_History__c.getRecordTypeInfosByName().get('Asset Transaction History').getRecordTypeId();
        Map<String, Id> recordTypeIdMap = new Map<String, Id>();
        recordTypeIdMap.put('Id', transactionHistoryRecordTypeId);
        inputMap.put('RecordType', recordTypeIdMap);
        

        List<Transaction_History__c> listTransactions = TestDataFactory.CreateTransactionHistory(2,listAccount[0].Id,'Siniestro','Suspensión','Active',transactionHistoryRecordTypeId);

        List<Product2> listProducts = TestDataFactory.createProduct(1);
        Product2 myProduct = listProducts[0];
        myProduct.vlocity_cmt__Type__c = 'dispositivo';
        myProduct.Family = 'Movil';
        update myProduct;
        
        List<Asset> listAsset = TestDataFactory.createAssets(1, myProduct,listAccount[0]);
        
        Transaction_History__c firstTransaction = listTransactions[0];
        firstTransaction.imei__c = '908090898989898';
        update firstTransaction;
        Transaction_History__c secondTransaction = listTransactions[1];
        secondTransaction.Asset__c = listAsset[0].Id;
        update secondTransaction;
        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
        
    }

    @isTest
    static void createTrasactionHistory_test() {
        
        String methodName = 'createTrasactionHistory';
        Map<String,Object> output = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        
        
        Id transactionHistoryRecordTypeId = Schema.SObjectType.Transaction_History__c.getRecordTypeInfosByName().get('Asset Transaction History').getRecordTypeId();
        String transactionHistoryRecordTypeIdString = (String)transactionHistoryRecordTypeId;
        
        string jsonTransaction = '{"Description":"Suspensión","Imei":"864345677654345","NewStatus":"Active","Type":"Siniestro","SinisterType":"Hurto"}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(jsonTransaction);
        responseNode.put('RecordType', transactionHistoryRecordTypeIdString);
        List<Account> listAccount = TestDataFactory.createAccounts(1);
        
        responseNode.put('AccountId',listAccount[0].Id);
        options.put('transactionHistory',responseNode);
        
        
        taCareSuspensionsAndReconnections testedClass = new taCareSuspensionsAndReconnections();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, output, options);
        Test.stopTest(); 
        
        String testAccountId = (String)listAccount[0].Id; 
        transaction_history__c outMapNode = (transaction_history__c) output.get('TransactionHistoryCreate');
        system.assertEquals(testAccountId,outMapNode.Account__c);
        
    }

    @IsTest
    private static void WhenGetAssetByIMEICalledAnAssetMustBeReturned() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        AssetsSelector mockAssetsSelector = (AssetsSelector) mocks.Mock(AssetsSelector.Class);
        
        Id assetId = fflib_IDGenerator.Generate(Asset.SObjectType);
        Id accountId = fflib_IDGenerator.Generate(Account.SObjectType);
        String imei = '573948579348734';
        Set<String> assetImeis = new Set<String> { imei };
        List<Asset> assets = new List<Asset> { 
            new Asset( Id = assetId, Imei__c = imei, AccountId = accountId, Status = 'Active') 
        };

        String methodName = 'GetAssetByIMEI';
        Map<String,Object> output = new Map<String, Object>();
        Map<String,Object> input = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        options.put('IMEI', imei);

        mocks.StartStubbing();
        mocks.when(mockAssetsSelector.SObjectType()).ThenReturn(Asset.SObjectType);
        mocks.When(mockAssetsSelector.SelectByIMEI(assetImeis)).ThenReturn(assets);
        mocks.StopStubbing();

        Application.Selector.SetMock(mockAssetsSelector);         

        // When
        TaCareSuspensionsAndReconnections suspensionAndReconnections = new TaCareSuspensionsAndReconnections();
        suspensionAndReconnections.InvokeMethod(methodName, input, output, options);
        
        // Then
        ((AssetsSelector) mocks.Verify(mockAssetsSelector, 1)).SelectByIMEI(assetImeis);
        System.AssertEquals(assets[0].Id, output.Get('AssetId'));
        System.AssertEquals(assets[0].AccountId, output.Get('AccountId'));
        System.AssertEquals(assets[0].Status, output.Get('Status'));
    }
}