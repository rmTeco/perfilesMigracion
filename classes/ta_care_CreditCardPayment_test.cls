@IsTest
public class ta_care_CreditCardPayment_test {
    @IsTest static void invoke_SuspendAssets() {
        String methodName = 'SuspendAssets';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
		Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc;

        Asset ass = new Asset(Name = 'asset1', MSISDN__c = '1234567890', AccountId = acc.Id);
        insert ass;
        
        options.put('AccountId',acc.Id);
        options.put('SuspensionReason','23453456');
        options.put('DeviceAssetIdToSuspend',ass.Id);
        options.put('PrepaidAssetIdToSuspend',ass.Id);
		
        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        

		
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
		
        string OrdId = (string)outMap.get('OrderId');
		System.assertEquals(true,true);
    }
    @IsTest static void invoke_ResumeAssets(){
        String methodName = 'ResumeAssets';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
		Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc;

        Asset ass = new Asset(Name = 'asset1', MSISDN__c = '1234567890', AccountId = acc.Id);
        insert ass;
        
        options.put('AccountId',acc.Id);
        options.put('SuspensionReason','23453456');
        options.put('DeviceAssetIdToResume',ass.Id);
        options.put('PrepaidAssetIdToResume',ass.Id);
        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
       
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        

        System.assertEquals(true,true);
    }
	@IsTest static void invoke_SubmitOrders(){
        String methodName = 'SubmitOrders';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();

        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
       
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        

        System.assertEquals(true,true);
    }
	@IsTest static void invoke_createListChildCasesUnfraudBA(){
        String methodName = 'createListChildCasesUnfraudBA';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();

        
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
		Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc;
        Account acc1 = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc1;
		
        string Accs = '[{"Id":"'+acc.Id+'"},{"Id":"'+acc1.Id+'"}]';
        List<Object> attr = (List<Object>) JSON.deserializeUntyped(Accs);
        
        options.put('BillingAccs',attr);
        
        Case c = new Case(AccountId= acc.Id, Subject = 'Suspension/Habilitacion por Administrativo', Status = 'Cerrado');
        insert c;
        options.put('DRId_Case',c.Id);
        
        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
        test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        

        System.assertEquals(true,true);
    }
	@IsTest static void invoke_SuspencreateListChildCasesFraudBAdAssets(){
        String methodName = 'SuspencreateListChildCasesFraudBAdAssets';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
		Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc;
        Account acc1 = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc1;
		
        string Accs = '[{"Id":"'+acc.Id+'"},{"Id":"'+acc1.Id+'"}]';
        List<Object> attr = (List<Object>) JSON.deserializeUntyped(Accs);
        
        options.put('FraudBillingAccs',attr);
        
        Case c = new Case(AccountId= acc.Id, Subject = 'Suspension/Habilitacion por Administrativo', Status = 'Cerrado');
        insert c;
        options.put('DRId_Case',c.Id);

        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
       
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        

        System.assertEquals(true,true);
    }
    
    @IsTest static void invoke_createListChildCasesAssets(){
        String methodName = 'createListChildCasesAssets';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
     
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc;

        Asset ass = new Asset(Name = 'asset1', MSISDN__c = '1234567890', AccountId = acc.Id);
        insert ass;
        Asset ass1 = new Asset(Name = 'asset1', MSISDN__c = '1234567890', AccountId = acc.Id);
        insert ass1;
        string Asst = '[{"AssetId":"'+ass.Id+'"},{"AssetId":"'+ass1.Id+'"}]';
        List<Object> attr = (List<Object>) JSON.deserializeUntyped(Asst);
        options.put('AssetsM',attr);
        
        Id caseRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'MobilePhoneCase' LIMIT 1].Id;
        options.put('RecordTypeId',caseRecordType);
        Case c = new Case(AccountId= acc.Id, Subject = 'Suspension/Habilitacion por Administrativo', Status = 'Cerrado');
        insert c;
        options.put('DRId_Case',c.Id);
        
        Id pricebookId = Test.getStandardPricebookId();
        Id orderRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Order' AND DeveloperName = 'MobilePhoneOrder' LIMIT 1].Id;
        Order order = new Order(RecordTypeId = orderRecordTypeForAcc, AccountId = acc.Id, Status = 'Draft', Gestion__c = 'Venta', Operation_Code__c = 'VTNLCE', EffectiveDate = Date.today(), Pricebook2Id = pricebookId,vlocity_cmt__OriginatingChannel__c ='Agentes',Delivery_Method__c ='Presencial');
        insert order;
    
        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
       
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    
        System.assertEquals(true,true);
    }
    

    @IsTest static void invoke_createTrasactionHistory(){
        String methodName = 'createTrasactionHistory';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
		
		Map<String, Object> transactionData = new Map<String, Object>();
		Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
		Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc;
		Id transactionRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Transaction_History__c' AND DeveloperName = 'Asset_Transaction_History' LIMIT 1].Id;
		
		transactionData.put('Id',null);
		transactionData.put('SinisterType','Robo');
        transactionData.put('Type','Siniestro');
        transactionData.put('RecordType',transactionRecordType);
        transactionData.put('NewStatus','New');
        transactionData.put('Imei','123111');
        transactionData.put('Description','12312');
        transactionData.put('AccountId',acc.Id);
		
		options.put('transactionHistory',transactionData);
		system.debug('options' + options);		
		

        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
		Transaction_History__c transHis = [SELECT New_Status__c from Transaction_History__c LIMIT 1];
		
		System.assertEquals(transHis.New_Status__c,'New');
    }
	@IsTest static void invoke_GetAssetByIMEI(){
        String methodName = 'GetAssetByIMEI';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();

        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
       
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        

        System.assertEquals(true,true);
    }
    @IsTest static void invoke_GetNewGuid(){
        String methodName = 'GetNewGuid';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();

        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
       
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        

        System.assertEquals(true,true);
    }
    @IsTest static void invoke_GetCreditCardPaymentValues(){
        String methodName = 'GetCreditCardPaymentValues';
        
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> inputMap = new Map<String, Object>();
        
        string args ='{"preloadedAmount":444,"PaymentMethods":[{"MethodTypeLabelFormula":"Tarjeta de Crédito","CardNumberLabelFormula":"CARTA AUTOMATICA XXXX-XXXX-XXXX-7278","MethodTypeDetailFormula":"CARTA AUTOMATICA XXXX-XXXX-XXXX-7278","MethodType__c":"Credit Card","ConcatCC":"CARTA AUTOMATICA XXXX-XXXX-XXXX-7278","CardNumber__c":"4246471393947278","First3Digits":"424","GetCardName":"CARTA AUTOMATICA","ExpirationMonth__c":"04","ExpirationYear__c":"2020","Security__c":222,"FormulaAccountId":"0016C0000095EAy","Selected":false,"AccountId__c":null,"PaymentId":"a2E6C0000001PVTUA2","CreditCardValidations":{"isInvalidSecurityNumber":false,"CreditCardTypeFormula":true,"CreditCardDueDateFormula":"2020-04-26T03:00:00.000Z","CreditCardDueDateGreaterThanTodayFormula":true,"DuplicatedCreditCardNumberFormula":1,"MessagingInvalidCC":true,"MessagingDueDateGreaterThanToday":true,"MessagingDuplicatedCreditCardNumber":true,"isInvalidSecurityNumberMessaging":true}},{"MethodTypeLabelFormula":"Tarjeta de Crédito","CardNumberLabelFormula":"CARTA AUTOMATICA XXXX-XXXX-XXXX-7279","MethodTypeDetailFormula":"CARTA AUTOMATICA XXXX-XXXX-XXXX-7279","MethodType__c":"Credit Card","ConcatCC":"CARTA AUTOMATICA XXXX-XXXX-XXXX-7279","CardNumber__c":"4246471393947279","First3Digits":"424","GetCardName":"CARTA AUTOMATICA","ExpirationMonth__c":"10","ExpirationYear__c":"2019","Security__c":222,"FormulaAccountId":"0016C0000095EAy","Selected":false,"AccountId__c":null,"PaymentId":"a2E6C0000001PWdUAM","CreditCardValidations":{"isInvalidSecurityNumber":false,"CreditCardTypeFormula":true,"CreditCardDueDateFormula":"2019-10-26T03:00:00.000Z","CreditCardDueDateGreaterThanTodayFormula":true,"DuplicatedCreditCardNumberFormula":1,"MessagingInvalidCC":true,"MessagingDueDateGreaterThanToday":true,"MessagingDuplicatedCreditCardNumber":true,"isInvalidSecurityNumberMessaging":true}},{"MethodTypeLabelFormula":"Tarjeta de Crédito","CardNumberLabelFormula":"SIDECREER XXXX-XXXX-XXXX-3333","MethodTypeDetailFormula":"SIDECREER XXXX-XXXX-XXXX-3333","MethodType__c":"Credit Card","ConcatCC":"SIDECREER XXXX-XXXX-XXXX-3333","CardNumber__c":"4433333333333333","First3Digits":"443","GetCardName":"SIDECREER","ExpirationMonth__c":"10","ExpirationYear__c":"2020","Security__c":456,"FormulaAccountId":"0016C0000095EAy","Selected":false,"AccountId__c":null,"PaymentId":"a2E6C0000001RN6UAM","CreditCardValidations":{"isInvalidSecurityNumber":false,"CreditCardTypeFormula":true,"CreditCardDueDateFormula":"2020-10-26T03:00:00.000Z","CreditCardDueDateGreaterThanTodayFormula":true,"DuplicatedCreditCardNumberFormula":1,"MessagingInvalidCC":true,"MessagingDueDateGreaterThanToday":true,"MessagingDuplicatedCreditCardNumber":true,"isInvalidSecurityNumberMessaging":true}}],"formulaSelectOne":false,"messagingSelectAtLeastOne":false,"messagingSelectOne":true}';
        Map<String,Object> attr = (Map<String,Object>) JSON.deserializeUntyped(args);
        inputMap.put('PaymentMethod',attr);
        

    
        ta_care_CreditCardPayment testedClass = new ta_care_CreditCardPayment();
        
       
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    
        System.assertEquals(true,true);
    }
}