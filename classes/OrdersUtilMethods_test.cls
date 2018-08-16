@isTest
public class OrdersUtilMethods_test {

	@isTest
    static void getOrdersWithContactInfo_test() {	
	
		String methodName = 'getOrdersWithContactInfo';
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        OrdersUtilMethods testedClass = new OrdersUtilMethods();
		
		Id usId = userinfo.getUserId();
		TestDataFactory.setTeamMember('Test', usId, null);   
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> parentOrders = TestDataFactory.createOrders(1, accs[0]);
		
		
		
		vlocity_cmt__BusinessSite__c bs = [SELECT Id, Channel_Type__c FROM vlocity_cmt__BusinessSite__c];
        
		parentOrders[0].TrackingStatus__c = 'Cobrado';
		parentOrders[0].Delivery_Method__c = 'Store Pick Up';
		parentOrders[0].PickUpStoreLocation__c = bs.Id;
		System.debug(bs);
		update parentOrders;
		
        
		//String ordStatus = (String)JSON.deserializeUntyped('"rrr"'); 
		inputMap.put('orderStatus','Cobrado');
		
		
		
		Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
	
	
	}
	
    @isTest
    static void OrderItemsAreAllPrepaid_test() {
		
		Id usId = userinfo.getUserId();
		TestDataFactory.setTeamMember('Test', usId, null);   
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> parentOrders = TestDataFactory.createOrders(1, accs[0]);
        List<OrderItem> childOrderItems = TestDataFactory.createOrderItem(1, parentOrders[0]);
        List<Product2> prod = TestDataFactory.createProduct(1);
        prod[0].vlocity_cmt__Type__c = 'Plan Prepago';
        update prod;
        childOrderItems[0].vlocity_cmt__Product2Id__c = prod[0].Id; 
        update childOrderItems;
		vlocity_cmt__BusinessSite__c bs = [SELECT Id, Channel_Type__c FROM vlocity_cmt__BusinessSite__c];
		parentOrders[0].TrackingStatus__c = 'Cobrado';
		parentOrders[0].Delivery_Method__c = 'Store Pick Up';
		parentOrders[0].PickUpStoreLocation__c = bs.Id;
		
		update parentOrders;
		
		List<OrderItem> orderItems = [SELECT Id, Product2Id, Product2.vlocity_cmt__Type__c FROM OrderItem WHERE OrderId =: parentOrders[0].Id];
		Id prodId = orderItems[0].Product2Id;
		List<Product2> productItems = [SELECT Id, vlocity_cmt__Type__c FROM Product2 WHERE Id = :prodId];
		productItems[0].vlocity_cmt__Type__c = 'Plan Prepago';
		update productItems;
		System.assertEquals(true,OrdersUtilMethods.OrderItemsAreAllPrepaid(parentOrders[0].Id));
		
	}
}