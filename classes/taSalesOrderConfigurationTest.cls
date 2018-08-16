@isTest
public with sharing class taSalesOrderConfigurationTest
{
	@isTest static void unitTest1()
	{
		taSalesOrderConfiguration tsoc = new taSalesOrderConfiguration();
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> billingOrder = new Map<String, Object>();
		billingOrder.put('Delivery_Method', 'Delivery');
		inputMap.put('BillingOrder', billingOrder);
		inputMap.put('DeliveryDefaultBillingCycle', 14);
		Test.startTest();
		tsoc.invokeMethod('test', null, null, null);
		tsoc.invokeMethod('getBillingCycleByDeliveryMethod', inputMap, outMap, null);
		billingOrder.put('Delivery_Method', 'Delivery2');
		inputMap.put('BillingOrder', billingOrder);
		tsoc.invokeMethod('getBillingCycleByDeliveryMethod', inputMap, outMap, null);
		Test.stopTest();
	}
	@isTest static void unitTest2()
	{
    taSalesOrderConfiguration tsoc = new taSalesOrderConfiguration();
    List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
		List<Order> lstOrder = TestDataFactory.createOrders(2,AccList[0]);
    List<OrderItem> lstOrderItem =TestDataFactory.createOrderItemgetDeliveryMethod(1,lstOrder[0]);
    OrderItem OrderItem = TestDataFactory.CreateOrderItemParent(lstOrder[0].Id, lstOrderItem[0].vlocity_cmt__Product2Id__c);
    Map<String,Object> inputMap = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
    Map<String,Object> options = new Map<String,Object>();
    Test.startTest();
      options.put('orderId',lstOrder[0].Id);
      tsoc.invokeMethod('getDeliveryMethodByProduct', inputMap, outMap, options);
    Test.stopTest(); 
	}
}