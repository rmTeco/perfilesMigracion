@isTest
public with sharing class taSalesOrderConfigurationTest {
	public static testmethod void unitTest1(){
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
}