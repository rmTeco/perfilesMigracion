@isTest
private class ta_sales_CancelUnretrievedOrdersBTest {

    @testSetup 
    static void setup() {
		SalesOrderAnnulmentTimeout__c timeout = new SalesOrderAnnulmentTimeout__c();
		timeout.TimeoutDays__c = 5;
		timeout.name = 'Nombre';
		insert timeout;
		
		List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
		Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
		vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(RecordTypeId = idRecordType, vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
		insert StoreLocations;
		TestDataFactory.createPaymentMethodTypes();
		TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
		List<Order>OrdList = TestDataFactory.createOrders(3,AccList[0]);
		
		Datetime pastCDate= Datetime.now().addDays(-10);
		
		for (Order order:OrdList){
            order.PickUpStoreLocation__c = StoreLocations.id;
            order.TrackingStatus__c = 'Inicial';
            order.Delivery_Method__c ='Store Pick Up';
            Test.setCreatedDate(order.Id, pastCDate);
            order.Received224_Date__c = Date.Today().addDays(-20);
            order.status = 'Draft';

        }
		update OrdList;
		
		List<OrderHistory> historias = new List<OrderHistory>();
		
		for (Order order: OrdList){
		    OrderHistory historia = new OrderHistory();
		    historia.OrderId = order.id;
		    historia.field = 'TrackingStatus__c';
		    historias.add(historia);
		}
		insert historias;
	
		
}
    
    @isTest
    static void test1() {        
        Test.startTest();
        ta_sales_CancelUnretrievedOrdersBatch uca = new ta_sales_CancelUnretrievedOrdersBatch();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(3, [select count() from Order where Name LIKE 'TestOrder%' AND Status='Cancelled' AND TrackingStatus__c = 'Pendiente de Anulación de Pago por Vencimiento de Plazo de Retiro']);
    }
   
}