@isTest(seeAllData = false)
public class taOrderBillingUpdateProcessTest {



    static testMethod void TestBillUpdateOrder_Agentes() {
        //generateMockupData();
        Account acc = new Account(Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;
        vlocity_cmt__BusinessSite__c store = new vlocity_cmt__BusinessSite__c();
        store.vlocity_cmt__OrganizationId__c = acc.Id;
        store.Channel_Type_3__c = 'Agentes';
        store.Channel_Type_2__c = 'Agentes';
        store.Channel_Type__c = 'Agentes';
        store.Channel__c = 'Físico';
        insert store;
        Id pricebookId = Test.getStandardPricebookId();
        
        Order order = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pricebookId,vlocity_cmt__OriginatingChannel__c ='Call Center',Delivery_Method__c ='Store Pick Up', OriginStoreLocation__c = store.Id);
        insert order;
        
        //Order order = [SELECT Id FROM Order LIMIT 1];
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('BillingOrder', order);

        Test.startTest();
        taOrderBillingUpdateProcess.BillUpdateOrder(order.Id);
		Test.stopTest();
        
        Order orderTest = [SELECT OriginStoreLocation__c, Delivery_Method__c,TrackingStatus__c FROM Order where Id =: order.Id];
        system.assertEquals('Preparar pedido',orderTest.TrackingStatus__c);
        
    }

    static testMethod void TestBillUpdateOrder_Agentes_Delivery() {
        //generateMockupData();
        Account acc = new Account(Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;
        vlocity_cmt__BusinessSite__c store = new vlocity_cmt__BusinessSite__c();
        store.vlocity_cmt__OrganizationId__c = acc.Id;
        store.Channel_Type_3__c = 'Agentes';
        store.Channel_Type_2__c = 'Agentes';
        store.Channel_Type__c = 'Agentes';
        store.Channel__c = 'Físico';
        insert store;
        Id pricebookId = Test.getStandardPricebookId();
        
        Order order = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pricebookId,vlocity_cmt__OriginatingChannel__c ='Call Center',Delivery_Method__c ='Delivery', OriginStoreLocation__c = store.Id);
        insert order;
        
        //Order order = [SELECT Id FROM Order LIMIT 1];
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('BillingOrder', order);

        Test.startTest();
        taOrderBillingUpdateProcess.BillUpdateOrder(order.Id);
		Test.stopTest();
        
        Order orderTest = [SELECT OriginStoreLocation__c, Delivery_Method__c,TrackingStatus__c FROM Order where Id =: order.Id];
        system.assertEquals('Preparar pedido',orderTest.TrackingStatus__c);
        
    }

    static testMethod void TestBillUpdateOrder_Exception() {
        //generateMockupData();
        Account acc = new Account(Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;
        vlocity_cmt__BusinessSite__c store = new vlocity_cmt__BusinessSite__c();
        store.vlocity_cmt__OrganizationId__c = acc.Id;
        store.Channel_Type_3__c = 'Agentes';
        store.Channel_Type_2__c = 'Agentes';
        store.Channel_Type__c = 'Agentes';
        store.Channel__c = 'Físico';
        insert store;
        Id pricebookId = Test.getStandardPricebookId();
        
        Order order = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pricebookId,vlocity_cmt__OriginatingChannel__c ='Call Center',Delivery_Method__c ='Delivery', OriginStoreLocation__c = store.Id, TrackingStatus__c = 'Pendiente de pago');
        insert order;

        Test.startTest();
        taOrderBillingUpdateProcess.BillUpdateOrder('123');
		Test.stopTest();
        
        Order orderTest = [SELECT OriginStoreLocation__c, Delivery_Method__c,TrackingStatus__c FROM Order where Id =: order.Id];
        system.assertEquals('Pendiente de pago',orderTest.TrackingStatus__c);
        
    }
    
    static testMethod void TestBillUpdateOrder_Oficinas() {
        Account acc = new Account(Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;
        vlocity_cmt__BusinessSite__c store = new vlocity_cmt__BusinessSite__c();
        store.vlocity_cmt__OrganizationId__c = acc.Id;
        store.Channel_Type_3__c = 'Oficinas Comerciales';
        store.Channel_Type_2__c = 'Oficinas Comerciales';
        store.Channel_Type__c = 'Oficinas Comerciales';
        store.Channel__c = 'Físico';
        insert store;
        Id pricebookId = Test.getStandardPricebookId();
        
        Order order = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pricebookId,vlocity_cmt__OriginatingChannel__c ='Call Center',Delivery_Method__c ='Store Pick Up', OriginStoreLocation__c = store.Id);
        insert order;
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('BillingOrder', order);

        Test.startTest();
        taOrderBillingUpdateProcess.BillUpdateOrder(order.Id);
		Test.stopTest();
        
        Order orderTest = [SELECT OriginStoreLocation__c, Delivery_Method__c,TrackingStatus__c FROM Order where Id =: order.Id];
        system.assertEquals('Preparar pedido',orderTest.TrackingStatus__c);
    }





   /* static testMethod void TestDeliverStorePickUp() {

        TaOrderBillingUpdateProcess taOrderBillingUpdateProcess = new TaOrderBillingUpdateProcess();

        generateMockupData();
        
        Order order = [SELECT Id FROM Order LIMIT 1];
        
        Map<String,Object> inputMap = new Map<String,Object>();
        inputMap.put('BillingOrder', order);


        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());

         taOrderBillingUpdateProcess.invokeMethod('Del',inputMap,null,null);

        taOrderBillingUpdateProcess.invokeMethod('DeliverStorePickUp',inputMap,null,null);
        taOrderBillingUpdateProcess.invokeMethod(null,null,null,null);

        Test.stopTest();
    }
*/




    public static void generateMockupData() {
        MockupFactory.generate();
        
        List<OrderItem> ordItemList = [SELECT Id FROM OrderItem];
        for(OrderItem ordItem : ordItemList) {
            ordItem.vlocity_cmt__SerialNumber__c = ordItem.Id;
        }
        update ordItemList;
    }
}