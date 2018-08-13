public with sharing class taSalesPaymentMethodsExtension {

	public List<vlocity_cmt__PaymentAdjustment__c> paymentMethods{get;set;}

	public taSalesPaymentMethodsExtension(ApexPages.StandardController controller){
		Id orderId = controller.getId();
		paymentMethods = [SELECT vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c , vlocity_cmt__Amount__c FROM vlocity_cmt__PaymentAdjustment__c WHERE Order__c =: orderId];
	}
}