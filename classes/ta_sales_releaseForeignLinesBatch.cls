global with sharing class ta_sales_releaseForeignLinesBatch implements Database.Batchable<sObject>, Schedulable{
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT AccountId, ContactId FROM Asset WHERE Contact.DocumentType__c = \'PAS\' AND Contact.PermanencyDueDate__c < TODAY';
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
   		List<Asset> assets = (List<Asset>) scope;
   		Pricebook2 pb2 = [SELECT Id, Name, IsActive FROM PriceBook2 WHERE IsStandard=True LIMIT 1];
   		PriceBookEntry pbe = [SELECT Id FROM PriceBookEntry LIMIT 1];
   		Map<Id, Order> orderByAccount = new Map<Id, Order>();
   		Map<Id, List<OrderItem>> itemsByAccount = new Map<Id, List<OrderItem>>();
   		List<OrderItem> oisToInsert = new List<OrderItem>();
   		for(Asset ass: assets){
   			if(!orderByAccount.keySet().contains(ass.AccountId)){
   				orderByAccount.put(ass.AccountId, new Order(AccountId = ass.AccountId, Pricebook2Id = pb2.Id, Status = 'Draft', EffectiveDate = Date.Today()));
   				List<OrderItem> items = new List<OrderItem>();
   				itemsByAccount.put(ass.AccountId, items);
   			}
   			List<OrderItem> ois = itemsByAccount.get(ass.AccountId);
   			ois.add(new OrderItem(Quantity = 1, vlocity_cmt__Action__c = 'Disconnect', UnitPrice = 0, PricebookEntryId = pbe.Id));
   		}
   		insert orderByAccount.values();
   		for(Id accountId: orderByAccount.keySet()){
   			Order o = orderByAccount.get(accountId);
   			for(OrderItem oi: itemsByAccount.get(accountId)){
   				oi.OrderId = o.Id;
   			}
   			oisToInsert.addAll(itemsByAccount.get(accountId));
   		}
   		insert oisToInsert;
   		for(Order o: orderByAccount.values()){
   			//vlocity_cmt.SimpleDecompositionManager.startOrderProcessing(o.Id)
   			vlocity_cmt.SimpleDecompositionController.decomposeOrder(o.Id);
   		}
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

	public void execute(Schedulablecontext ctx){
        ta_sales_releaseForeignLinesBatch batch = new ta_sales_releaseForeignLinesBatch();
        Database.executeBatch(batch);
    }
}