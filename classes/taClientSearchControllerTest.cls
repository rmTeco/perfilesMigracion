@isTest(seeAllData = false)
public with sharing class taClientSearchControllerTest {

    static testmethod void updateContactTest() {
        Contact testContact = TestDataFactory.createContacts(1, null)[0];
        String newEmail = 'aNewEmail@test.com';

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        csc.valor = '';
        taClientSearchController.UpdateContact(testContact.Id, newEmail);
        Test.stopTest();

        Contact retContact = [SELECT Email FROM Contact WHERE Id = :testContact.Id][0];

        System.assertEquals(newEmail.toLowerCase(), retContact.Email);
    }

    static testmethod void checkClientInBlackListTest() {
        Account testAcc = TestDataFactory.createAccounts(1)[0];

        testAcc.DocumentNumber__c = '12345678';
        testAcc.DocumentType__c = 'DNI';
        update testAcc;

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        String resp = taClientSearchController.CheckClientInBlackList(testAcc.Id, testAcc.DocumentType__c, testAcc.DocumentNumber__c);
        Test.stopTest();

        //TODO: Assert
    }

    static testmethod void CheckDunningTest_NoOK(){
        Account testAcc = TestDataFactory.createAccounts(1)[0];
        String integId = testAcc.AccountIntegrationId__c;

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Boolean resp = taClientSearchController.CheckDunning(integId);
        Test.stopTest();

        System.assertEquals(false, resp);
    }

    static testmethod void GetIntegrationIdTest_OK(){
        Account testAcc = TestDataFactory.createAccounts(1)[0];

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        String resp = taClientSearchController.getIntegrationId(testAcc.Id);
        Test.stopTest();

        String integId = [SELECT AccountIntegrationId__c FROM Account WHERE Id = :testAcc.Id][0].AccountIntegrationId__c;

        System.assertEquals(integId, resp);
    }

    static testmethod void CreateOrderTest_OK(){
        Account testAcc = TestDataFactory.createAccounts(1, 'Consumer')[0];

        TestDataFactory.createPriceList('Telecom Price List');
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        taClientSearchController.createOrder(testAcc.Id);
        Test.stopTest();

        List<Order> lstOrder = [SELECT Id FROM Order WHERE AccountId = :testAcc.Id];

        System.assertEquals(1, lstOrder.size());
    }

    static testmethod void CreateOrderTest_Excep(){
        TestDataFactory.createPriceList('Telecom Price List');
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        taClientSearchController.createOrder('123');
        Test.stopTest();

        List<Order> lstOrder = [SELECT Id FROM Order];

        System.assertEquals(0, lstOrder.size());
    }

    static testmethod void UpdateDunningFromAccountTest_OK(){
        Account testAcc = TestDataFactory.createAccounts(1, 'Billing')[0];

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        taClientSearchController.UpdateDunningFromAccount(testAcc.Id, true);
        Test.stopTest();

        Account updatedAcc = [SELECT Dunning__c FROM Account WHERE Id = :testAcc.Id][0];

        System.assertEquals(true, updatedAcc.Dunning__c);
    }
    
     @IsTest static void CheckAccountsStatus_test (){
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Account> account = TestDataFactory.createAccounts(1, 'Consumer');
        //Contact contact = TestDataFactory.createContacts(1, account[0])[0];
        //Order order = TestDataFactory.createOrders(1, account[0])[0];
		//options.put('OrderId',order.Id);
        Test.startTest();
            String args = taClientSearchController.CheckAccountsStatus(account[0].Id,'38088068','DNI');
        Test.stopTest();
    }

    static testmethod void SearchContactsTest_OK(){
        String methodName = 'SearchContacts';
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Account> account = TestDataFactory.createAccounts(1, 'Consumer');
        Contact contact = TestDataFactory.createContacts(1, account[0])[0];
        contact.DocumentNumber__c = '34242234233';
        contact.DocumentType__c = 'DNI';
        contact.Gender__c = 'Masculino';
        account[0].vlocity_cmt__PrimaryContactId__c = contact.Id;
        update contact;
        update account;
        
        String ContactSearch = '{"Name":"adasd"}';
        String DocumentTypeSearch = 'DNI';
        String DocumentInputSearch = '34242234233';
        String GenderSearch = 'Masculino';
        Map<String,Object> ContactSearch2 = (Map<String,Object>)JSON.deserializeUntyped(ContactSearch);
        inputMap.put('ContactSearch',ContactSearch2);
        options.put('DocumentTypeSearch',DocumentTypeSearch);
        options.put('DocumentInputSearch',DocumentInputSearch);
        options.put('GenderSearch',GenderSearch);
        
        vlocity_cmt__DRBundle__c dr = new vlocity_cmt__DRBundle__c();
        dr.Name = 'ta-sales-DR-SearchContact';
        dr.vlocity_cmt__CheckFieldLevelSecurity__c = false;
        dr.vlocity_cmt__DeleteOnSuccess__c = false;
        dr.vlocity_cmt__DRMapName__c = 'ta-sales-DR-SearchContact';
        dr.vlocity_cmt__IgnoreErrors__c = false;
        dr.vlocity_cmt__InterfaceObject__c = 'json';
        dr.vlocity_cmt__IsDefaultForInterface__c = false;
        dr.vlocity_cmt__IsProcessSuperBulk__c = false;
        dr.vlocity_cmt__OverwriteAllNullValues__c = false;
        dr.vlocity_cmt__RollbackOnError__c = false;
        dr.vlocity_cmt__Type__c = 'Extract';
        dr.vlocity_cmt__UseAssignmentRules__c = false;
        insert dr;
        
        
        
        String dataJson = '{"GenderSearch":"' + GenderSearch + '", "DocumentTypeSearch":"' + DocumentTypeSearch + '", "DocumentInputSearch":"' + DocumentInputSearch + '"}';
        vlocity_cmt.DRProcessResult result = vlocity_cmt.DRGlobal.processObjectsJSON(dataJson, 'ta-sales-DR-SearchContact');
        System.debug(result);
        Map<String, Object> resultMap = result.convertToMap();
         System.debug(resultMap);

        Test.startTest();
        taClientSearchController csc = new taClientSearchController();
        csc.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        //System.assertEquals(true, updatedAcc.Dunning__c);
    }
}