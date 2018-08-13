@isTest
private class ta_sales_CancelAbandonedOrdersBatchTest {

    @testSetup 
    static void setup() {
        List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
        insert StoreLocations;
        TestDataFactory.createPaymentMethodTypes();
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Order>OrdList = TestDataFactory.createOrders(10,AccList[0]);
        TASalesCodeValue__c CodeValues = new TASalesCodeValue__c(Name= 'TimeoutOV', Value__c= '24');
        insert CodeValues;

        Datetime pastCDate= Datetime.now().addDays(-2);

        for (Order order:OrdList){
            order.PickUpStoreLocation__c = StoreLocations.id;
            order.Delivery_Method__c ='Store Pick Up';
            Test.setCreatedDate(order.Id, pastCDate);

        }
        update OrdList;
        
    }
    @isTest
    static void test1() {        
        Test.startTest();
        ta_sales_CancelAbandonedOrdersBatch uca = new ta_sales_CancelAbandonedOrdersBatch();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        System.debug('Test FDL: Order:' + [select Name, Status, TrackingStatus__c from Order]);
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Order where Name LIKE 'TestOrder%' AND Status='Cancelled' AND TrackingStatus__c = 'Cancelada - Timeout']);
    }
    @isTest
    static void test2() {        
        List<Order>OrdList = [SELECT Id FROM Order WHERE Name like 'TestOrder%'];
        for (Order order:OrdList){
            order.TrackingStatus__c = 'Pendiente de pago';
            order.PreInvoiceNumber__c= '12345';
        }
        update OrdList;

        
        Test.startTest();
        ta_sales_CancelAbandonedOrdersBatch uca = new ta_sales_CancelAbandonedOrdersBatch();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Order where Name LIKE 'TestOrder%' AND Status='Cancelled' AND TrackingStatus__c = 'Cancelada - Timeout Caja']);
    }
    @isTest
    static void test3() {        
        List<Order>OrdList = [SELECT Id FROM Order WHERE Name like 'TestOrder%'];
        for (Order order:OrdList){
            order.TrackingStatus__c = 'Pago No Concretado';
            order.PreInvoiceNumber__c= '12345';
        }
        update OrdList;

        
        Test.startTest();
        ta_sales_CancelAbandonedOrdersBatch uca = new ta_sales_CancelAbandonedOrdersBatch();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Order where Name LIKE 'TestOrder%' AND Status='Cancelled' AND TrackingStatus__c = 'Cancelada - Timeout']);
    }
    
}