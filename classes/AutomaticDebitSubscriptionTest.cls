@isTest
private class AutomaticDebitSubscriptionTest {
	
	@isTest static void CreateTasksDebitActionAdhesion(){
		//GIVEN
		String methodName = 'CreateTasks';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
		//debitAction
		Map<String,Object> AutomaticDebitAction = new Map<String,Object>();
		String SelectedAutomaticDebitAction = 'Adhesion';
		AutomaticDebitAction.put('SelectedAutomaticDebitAction', SelectedAutomaticDebitAction);
		
		//BillingAccounts
		List<Object> BillingAccounts = new List<Object>();
		Account billingAccount = new Account();
		billingAccount.Name = 'TestName';
		insert billingAccount;
		
		Map<String,Object> billingAccountMap = new Map<String, Object>();
		billingAccountMap.put('Name', billingAccount.Name);
		billingAccountMap.put('Id', billingAccount.Id);
		billingAccountMap.put('isSelected', true);
		
        BillingAccounts.add(billingAccountMap);
        
        
        //PaymentMethods
        vlocity_cmt__PaymentMethod__c PaymentMethods = new vlocity_cmt__PaymentMethod__c();
        PaymentMethods.vlocity_cmt__MethodType__c = 'Tarjeta de Credito';
        PaymentMethods.vlocity_cmt__AccountId__c = billingAccount.Id;
        PaymentMethods.vlocity_cmt__CardType__c = 'VISA';
        PaymentMethods.vlocity_cmt__CardHolderName__c = 'TestHolderName';
        PaymentMethods.vlocity_cmt__CardNumber__c = '4000111111111111';
        PaymentMethods.vlocity_cmt__ExpirationMonth__c = '12';
        PaymentMethods.vlocity_cmt__ExpirationYear__c = '2020';
        PaymentMethods.vlocity_cmt__IsActive__c = true;
        insert PaymentMethods;
        
        Map<String, Object> PaymentMethodsMap = new Map<String, Object>();
        PaymentMethodsMap.put('Id', PaymentMethods.Id);
        PaymentMethodsMap.put('Selected', true);
        
        Map<String,Object> paymentsMap = new Map<String,Object>();
		paymentsMap.put('PaymentMethods', PaymentMethodsMap);
        
        //Case
        Case caseObj = new Case(
	    AccountId = billingAccount.Id,
	    Status = 'Nueva',
	    Origin = 'Telefónico');
	    insert caseObj;
		
        input.put('DRId_Case', caseObj.Id);
        input.put('PaymentMethod', paymentsMap);
        input.put('AutomaticDebitAction', AutomaticDebitAction);
        input.put('BillingAccounts', BillingAccounts);
        
        AutomaticDebitSubscription AutomaticDebitSubscription = new AutomaticDebitSubscription();
        
        String Subject = 'Débito automático: ' + billingAccount.Id;
        
        //WHEN
		Test.startTest();
        Boolean result = AutomaticDebitSubscription.invokeMethod(methodName, input, outMap, options);
        List<Task> taskList = [SELECT Id FROM Task WHERE Subject = :Subject AND Status = 'Not Started' AND WhatId = :caseObj.Id];
        Test.stopTest();
        
        //THEN
        System.assertEquals(false, result);
        System.assertEquals(1, taskList.size());
	}
	
	@isTest static void CreateTasksDebitActionUpdate(){
		//GIVEN
		String methodName = 'CreateTasks';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
		//debitAction
		Map<String,Object> AutomaticDebitAction = new Map<String,Object>();
		String SelectedAutomaticDebitAction = 'Update';
		AutomaticDebitAction.put('SelectedAutomaticDebitAction', SelectedAutomaticDebitAction);
		
		//BillingAccounts
		List<Object> BillingAccounts = new List<Object>();
		Account billingAccount = new Account();
		billingAccount.Name = 'TestName';
		insert billingAccount;
		
		Map<String,Object> billingAccountMap = new Map<String, Object>();
		billingAccountMap.put('Name', billingAccount.Name);
		billingAccountMap.put('Id', billingAccount.Id);
		billingAccountMap.put('isSelected', true);
		
        BillingAccounts.add(billingAccountMap);
        
        
        //PaymentMethods
        vlocity_cmt__PaymentMethod__c PaymentMethods = new vlocity_cmt__PaymentMethod__c();
        PaymentMethods.vlocity_cmt__MethodType__c = 'Tarjeta de Credito';
        PaymentMethods.vlocity_cmt__AccountId__c = billingAccount.Id;
        PaymentMethods.vlocity_cmt__CardType__c = 'VISA';
        PaymentMethods.vlocity_cmt__CardHolderName__c = 'TestHolderName';
        PaymentMethods.vlocity_cmt__CardNumber__c = '4000111111111111';
        PaymentMethods.vlocity_cmt__ExpirationMonth__c = '12';
        PaymentMethods.vlocity_cmt__ExpirationYear__c = '2020';
        PaymentMethods.vlocity_cmt__IsActive__c = true;
        insert PaymentMethods;
        
        Map<String, Object> PaymentMethodsMap = new Map<String, Object>();
        PaymentMethodsMap.put('Id', PaymentMethods.Id);
        PaymentMethodsMap.put('Selected', true);
        
        Map<String,Object> paymentsMap = new Map<String,Object>();
		paymentsMap.put('PaymentMethods', PaymentMethodsMap);
        
        //Case
        Case caseObj = new Case(
	    AccountId = billingAccount.Id,
	    Status = 'Nueva',
	    Origin = 'Telefónico');
	    insert caseObj;
		
        input.put('DRId_Case', caseObj.Id);
        input.put('PaymentMethod', paymentsMap);
        input.put('AutomaticDebitAction', AutomaticDebitAction);
        input.put('BillingAccounts', BillingAccounts);
        input.put('BillingAccountToResponse', billingAccount.Id);
        
        AutomaticDebitSubscription AutomaticDebitSubscription = new AutomaticDebitSubscription();
        
        String Subject = 'Débito automático: ' + billingAccount.Id;
        
        //WHEN
		Test.startTest();
        Boolean result = AutomaticDebitSubscription.invokeMethod(methodName, input, outMap, options);
        List<Task> taskList = [SELECT Id FROM Task WHERE Subject = :Subject AND Status = 'Not Started' AND WhatId = :caseObj.Id];
        Test.stopTest();
        
        //THEN
        System.assertEquals(false, result);
        System.assertEquals(1, taskList.size());
	}
	
	@isTest static void CreateTasksDebitActionStop(){
		//GIVEN
		String methodName = 'CreateTasks';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();        
		
		//debitAction
		Map<String,Object> AutomaticDebitAction = new Map<String,Object>();
		String SelectedAutomaticDebitAction = 'Stop';
		AutomaticDebitAction.put('SelectedAutomaticDebitAction', SelectedAutomaticDebitAction);
		
		//BillingAccounts
		List<Object> BillingAccounts = new List<Object>();
		Account billingAccount = new Account();
		billingAccount.Name = 'TestName';
		insert billingAccount;
		
		Map<String,Object> billingAccountMap = new Map<String, Object>();
		billingAccountMap.put('Name', billingAccount.Name);
		billingAccountMap.put('Id', billingAccount.Id);
		billingAccountMap.put('isSelected', true);
		
        
        
        //PaymentMethods
        vlocity_cmt__PaymentMethod__c PaymentMethods = new vlocity_cmt__PaymentMethod__c();
        PaymentMethods.vlocity_cmt__MethodType__c = 'Tarjeta de Credito';
        PaymentMethods.vlocity_cmt__AccountId__c = billingAccount.Id;
        PaymentMethods.vlocity_cmt__CardType__c = 'VISA';
        PaymentMethods.vlocity_cmt__CardHolderName__c = 'TestHolderName';
        PaymentMethods.vlocity_cmt__CardNumber__c = '4000111111111111';
        PaymentMethods.vlocity_cmt__ExpirationMonth__c = '12';
        PaymentMethods.vlocity_cmt__ExpirationYear__c = '2020';
        PaymentMethods.vlocity_cmt__IsActive__c = true;
        insert PaymentMethods;
        
        Map<String, Object> PaymentMethodsMap = new Map<String, Object>();
        PaymentMethodsMap.put('Id', PaymentMethods.Id);
        PaymentMethodsMap.put('Selected', true);
        
        Map<String,Object> paymentsMap = new Map<String,Object>();
		paymentsMap.put('PaymentMethods', PaymentMethodsMap);
		
		
		//BillingAccounts (...complete)
		billingAccountMap.put('AutoPaymentMethodIdFormula', PaymentMethods.Id);
        BillingAccounts.add(billingAccountMap);
        
        //Case
        Case caseObj = new Case(
	    AccountId = billingAccount.Id,
	    Status = 'Nueva',
	    Origin = 'Telefónico');
	    insert caseObj;
		
        input.put('DRId_Case', caseObj.Id);
        input.put('PaymentMethod', paymentsMap);
        input.put('AutomaticDebitAction', AutomaticDebitAction);
        input.put('BillingAccounts', BillingAccounts);
        input.put('BillingAccountToResponse', billingAccount.Id);
        
        AutomaticDebitSubscription AutomaticDebitSubscription = new AutomaticDebitSubscription();
        
        String Subject = 'Débito automático: ' + billingAccount.Id;
        
        //WHEN
		Test.startTest();
        Boolean result = AutomaticDebitSubscription.invokeMethod(methodName, input, outMap, options);
        List<Task> taskList = [SELECT Id FROM Task WHERE Subject = :Subject AND Status = 'Not Started' AND WhatId = :caseObj.Id];
        Test.stopTest();
        
        //THEN
        System.assertEquals(false, result);
        System.assertEquals(1, taskList.size());
	}
	
	@isTest static void CreateTasksDebitActionDelete(){
		//GIVEN
		String methodName = 'CreateTasks';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();        
		
		//debitAction
		Map<String,Object> AutomaticDebitAction = new Map<String,Object>();
		String SelectedAutomaticDebitAction = 'Delete';
		AutomaticDebitAction.put('SelectedAutomaticDebitAction', SelectedAutomaticDebitAction);
		
		//BillingAccounts
		List<Object> BillingAccounts = new List<Object>();
		Account billingAccount = new Account();
		billingAccount.Name = 'TestName';
		insert billingAccount;
		
		Map<String,Object> billingAccountMap = new Map<String, Object>();
		billingAccountMap.put('Name', billingAccount.Name);
		billingAccountMap.put('Id', billingAccount.Id);
		billingAccountMap.put('isSelected', true);
		
        
        
        //PaymentMethods
        vlocity_cmt__PaymentMethod__c PaymentMethods = new vlocity_cmt__PaymentMethod__c();
        PaymentMethods.vlocity_cmt__MethodType__c = 'Tarjeta de Credito';
        PaymentMethods.vlocity_cmt__AccountId__c = billingAccount.Id;
        PaymentMethods.vlocity_cmt__CardType__c = 'VISA';
        PaymentMethods.vlocity_cmt__CardHolderName__c = 'TestHolderName';
        PaymentMethods.vlocity_cmt__CardNumber__c = '4000111111111111';
        PaymentMethods.vlocity_cmt__ExpirationMonth__c = '12';
        PaymentMethods.vlocity_cmt__ExpirationYear__c = '2020';
        PaymentMethods.vlocity_cmt__IsActive__c = true;
        insert PaymentMethods;
        
        Map<String, Object> PaymentMethodsMap = new Map<String, Object>();
        PaymentMethodsMap.put('Id', PaymentMethods.Id);
        PaymentMethodsMap.put('Selected', true);
        
        Map<String,Object> paymentsMap = new Map<String,Object>();
		paymentsMap.put('PaymentMethods', PaymentMethodsMap);
		
		
		//BillingAccounts (...complete)
		billingAccountMap.put('AutoPaymentMethodIdFormula', PaymentMethods.Id);
        BillingAccounts.add(billingAccountMap);
        
        //Case
        Case caseObj = new Case(
	    AccountId = billingAccount.Id,
	    Status = 'Nueva',
	    Origin = 'Telefónico');
	    insert caseObj;
		
        input.put('DRId_Case', caseObj.Id);
        input.put('PaymentMethod', paymentsMap);
        input.put('AutomaticDebitAction', AutomaticDebitAction);
        input.put('BillingAccounts', BillingAccounts);
        input.put('BillingAccountToResponse', billingAccount.Id);
        
        AutomaticDebitSubscription AutomaticDebitSubscription = new AutomaticDebitSubscription();
        
        String Subject = 'Débito automático: ' + billingAccount.Id;
        
        //WHEN
		Test.startTest();
        Boolean result = AutomaticDebitSubscription.invokeMethod(methodName, input, outMap, options);
        List<Task> taskList = [SELECT Id FROM Task WHERE Subject = :Subject AND Status = 'Not Started' AND WhatId = :caseObj.Id];
        Test.stopTest();
        
        //THEN
        System.assertEquals(false, result);
        System.assertEquals(1, taskList.size());
	}
	
	@isTest static void getPaymentMethodsOneObject(){
		//GIVEN
		Map<String,Object> paymentsMap = new Map<String,Object>();
		Map<String,Object> PaymentMethods = new Map<String,Object>();
		
		paymentsMap.put('PaymentMethods', PaymentMethods);
		
		//WHEN
		Test.startTest();
        List<Object> result = AutomaticDebitSubscription.getPaymentMethods(paymentsMap);
        Test.stopTest();
        
        //THEN
        System.assertEquals(1, result.size());
	}
	
	@isTest static void getPaymentMethodsListObject(){
		//GIVEN
		Map<String,Object> paymentsMap = new Map<String,Object>();
		List<Object> PaymentMethods = new List<Object>();
		Map<String,Object> PaymentMethods1 = new Map<String,Object>();
		Map<String,Object> PaymentMethods2 = new Map<String,Object>();
		
		PaymentMethods.add(PaymentMethods1);
		PaymentMethods.add(PaymentMethods2);
		paymentsMap.put('PaymentMethods', PaymentMethods);
		
		//WHEN
		Test.startTest();
        List<Object> result = AutomaticDebitSubscription.getPaymentMethods(paymentsMap);
        Test.stopTest();
        
        //THEN
        System.assertEquals(2, result.size());
	}
	
	@isTest static void getPaymentMethodsNullObject(){
		//GIVEN
		Map<String,Object> paymentsMap = new Map<String,Object>();
		paymentsMap.put('PaymentMethods', null);
		
		//WHEN
		Test.startTest();
        List<Object> result = AutomaticDebitSubscription.getPaymentMethods(paymentsMap);
        Test.stopTest();
        
        //THEN
        System.assertEquals(null, result);
	}
	
}