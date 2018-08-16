@isTest(seeAllData = false)
public with sharing class taSalesCreateOrderControllerTest {

    static testmethod void createOrderTest(){
        MockupFactory.generate();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        options.put('idAccount', acc.Id);

        Test.startTest();
        taSalesCreateOrderController controller = new taSalesCreateOrderController();
        controller.invokeMethod('CreateOrder', inputMap, outputMap, options);
        taSalesCreateOrderController.CreateOrder(acc.Id, '');
        taSalesCreateOrderController.CreateOrder('1234567890', '');
        Test.stopTest();
        
        Order ord = [SELECT Id,Status,AccountId FROM Order LIMIT 1];
        system.assertEquals(ord.AccountId, acc.Id);
    }

    static testmethod void createOrderAndAccountTest(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Contact contact = new Contact(LastName = 'Sample Contact' + System.now());
        insert contact;
        options.put('contactId', contact.Id);
        Account account = new Account(Name = 'Test' + System.now());
        insert Account;
        options.put('accountId', account.Id);

        Test.startTest();
        taSalesCreateOrderController controller = new taSalesCreateOrderController();
        controller.invokeMethod('CreateOrderAndAccount', inputMap, outputMap, options);
        taSalesCreateOrderController.CreateOrderAndAccount(contact.Id,'');
        Test.stopTest();
        
        //Order ord = [SELECT Id, Status FROM Order LIMIT 1];
        //system.assertEquals(ord.Status, 'Draft');
    }

    static testmethod void createOrderAndBillingAccountTest(){
        MockupFactory.generate();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        options.put('idAccount', acc.Id);

        Test.startTest();
        taSalesCreateOrderController controller = new taSalesCreateOrderController();
        controller.invokeMethod('CreateOrderAndBillingAccount', inputMap, outputMap, options);
        taSalesCreateOrderController.CreateBillingAccount('123456789012345678');
        Test.stopTest();
        
        Account acco = [SELECT Id,recordtype.DeveloperName FROM Account where recordtype.DeveloperName = 'Billing' LIMIT 1];
        system.assertEquals(acco.recordtype.DeveloperName,'Billing');
    }

    static testmethod void checkIfPrepaidOrdItemsTest(){
        MockupFactory.generate();
        MockupFactory.generatePlanPrepago();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account billingAcc = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'Billing' LIMIT 1];
        options.put('billingAccountId', billingAcc.Id);
        List<Order> orderList = [SELECT Id FROM Order];
        options.put('idOrder', orderList.get(0).Id);

        Test.startTest();
        taSalesCreateOrderController controller = new taSalesCreateOrderController();
        taSalesCreateOrderController.CloneOrder(orderList.get(0).Id,True);
        controller.invokeMethod('CheckIfPrepaidOrdItems', inputMap, outputMap, options);
        options.put('idOrder', orderList.get(1).Id);
        controller.invokeMethod('CheckIfPrepaidOrdItems', inputMap, outputMap, options);
        Test.stopTest();
        
        system.assertEquals(outputMap.get('billingAccountId'),null);
        
    }
    
    
     static testmethod void cloneorderTest(){
        MockupFactory.generate();
        MockupFactory.generatePlanPrepago();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account billingAcc = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'Billing' LIMIT 1];
        options.put('idBillingAccount', billingAcc.Id);
        List<Order> orderList = [SELECT Id FROM Order];
        options.put('idOrder', orderList.get(0).Id);
        orderList.get(0).Status = 'Active';

        Test.startTest();
        taSalesCreateOrderController.CloneOrder(orderList.get(0).Id,True);
        taSalesCreateOrderController.CreateOrderAndBillingAccount(billingAcc.Id,'Test');
        Test.stopTest();
        
        Order ord = [SELECT Id,Status,Operation_Code__c from Order limit 1];
        system.assertEquals(ord.Status,'Draft');
        
    }
    static testmethod void CreateAnnulmentOrderTest(){
        string methodName= 'CreateAnnulmentOrder';
        MockupFactory.generate();
        MockupFactory.generatePlanPrepago();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        List<Order> orderList = [SELECT Id FROM Order];
        inputMap.put('orderId',orderList.get(0).Id);
        Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'Billing' LIMIT 1];
        
        Contact con = new Contact(AccountId=acc.Id,FirstName='Sample',LastName = 'Contact');
        insert con;
        
        Test.startTest();
        taSalesCreateOrderController controller= new taSalesCreateOrderController();
        controller.invokeMethod(methodName,inputMap,outputMap,options);
        taSalesCreateOrderController.CheckClientInBlackList(acc.Id,con.Id);
        taSalesCreateOrderController.CheckDunningAccount(acc.Id);
        taSalesCreateOrderController.UpdateDunningAccount(acc.Id,True);
        taSalesCreateOrderController.CheckAccountStatus(acc.Id,con.Id);
        taSalesCreateOrderController.CreateAccount(con.Id);
        Test.stopTest();
        
        Account acco= [SELECT Id,Name from Account where vlocity_cmt__PrimaryContactId__c =: con.Id];
        system.assertEquals('Sample Contact',acco.Name);
        
        
    }
}