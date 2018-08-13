public with sharing class taAssetsByOrderExtension {

	public List<Asset> assets{get;set;}

	public taAssetsByOrderExtension(ApexPages.StandardController controller){
		Id orderId = controller.getId();
		assets = [SELECT Product2.Name, Product2.Family, Name FROM Asset WHERE vlocity_cmt__OrderId__c =: orderId AND Status = 'Active'];
	}
}