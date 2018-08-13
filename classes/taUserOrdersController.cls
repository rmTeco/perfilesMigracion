public with sharing class taUserOrdersController {
	public taUserOrdersController() {}

	public List<Order> getOrders(){
		Id userId = userInfo.getUserId();
		List<Order> orders = [SELECT Id, OrderNumber, Account.Name, Account.Id, Status, vlocity_cmt__OriginatingChannel__c FROM Order WHERE OwnerId =: userId];
		return orders;
	}
}