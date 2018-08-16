global class XOMUpdateAssetAccount implements vlocity_cmt.XOMOrchestrationInterfaces.IAutoTask {

	global void executeBatch(List<vlocity_cmt__orchestrationItem__c> items) {
	//       List<vlocity_cmt__FulfilmentRequestLine__c> ffRequestLines = new List<vlocity_cmt__FulfilmentRequestLine__c>();
		try{
			//Id orderId = items[0].vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id;
			System.debug('items 0 :'+ items[0]);
			System.debug('vlocity_cmt__OrderItemId__r '+ items[0].vlocity_cmt__OrderItemId__r);
			System.debug('itemOrderId '+ items[0].vlocity_cmt__OrderItemId__r.OrderId);
			//System.debug('orderId' + orderId);
			
			Set<Id> orderIds = new Set<Id>();
			Set<Id> orchestrationItemsIds = new Set<Id>();
			for(vlocity_cmt__orchestrationItem__c item : items) {
				orchestrationItemsIds.add(item.Id);
			//	orderIds.add(item.vlocity_cmt__OrderItemId__r.OrderId);
			}
			List<vlocity_cmt__OrchestrationItem__c> orchestrationItems = [SELECT id, vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id
   			 FROM vlocity_cmt__OrchestrationItem__c 
   			 WHERE  
       		 vlocity_cmt__OrchestrationItem__c.Id in :orchestrationItemsIds];
			System.debug('orchestrationItems :'+ orchestrationItems);

       		 for(vlocity_cmt__OrchestrationItem__c orchItem : orchestrationItems)
       		 {
				orderIds.add(orchItem.vlocity_cmt__OrchestrationPlanId__r.vlocity_cmt__OrderId__r.Id);
       		 }

			System.debug('orderIds' + orderIds);
			List<Order> orders = [Select Id, (Select Id, vlocity_cmt__AssetId__c, vlocity_cmt__BillingAccountId__c, vlocity_cmt__ServiceAccountId__c From OrderItems) From Order Where Id in :orderIds];
			System.debug('orders' + orders);

			//List<Order> orders = [Select Id, (Select Id, vlocity_cmt__BillingAccountId__c, vlocity_cmt__ServiceAccountId__c From OrderItems), vlocity_cmt__AccountId__c From Order where id = :orderId];

			Map<string, OrderItem> mapOfOrderItems = new Map<string, OrderItem>();
			List<Id> assetIds = new List<Id>();
			string[] assetiIdsArray;
			for(Order order : orders)
	        {
	        	for(OrderItem oi : order.OrderItems) {
	        		mapOfOrderItems.put(oi.vlocity_cmt__AssetId__c, oi);
	        		assetIds.add(oi.vlocity_cmt__AssetId__c);
	        	}
	        }
	        assetiIdsArray = assetIds;
			System.debug('assetiIdsArray '+assetiIdsArray);
	        System.debug('mapOfOrderItems '+mapOfOrderItems);
	        System.debug('mapOfOrderItemsKeySet '+mapOfOrderItems.keySet());
	        List<Asset> assets = [SELECT Id, vlocity_cmt__BillingAccountId__c, vlocity_cmt__ServiceAccountId__c  FROM Asset WHERE Id in :assetIds];
			System.debug('assets '+assets);
	        for(Asset a : assets) {
	        	a.AccountId = mapOfOrderItems.get(a.Id).vlocity_cmt__BillingAccountId__c;
	        	a.vlocity_cmt__BillingAccountId__c = mapOfOrderItems.get(a.Id).vlocity_cmt__BillingAccountId__c;
	        	a.vlocity_cmt__ServiceAccountId__c = mapOfOrderItems.get(a.Id).vlocity_cmt__ServiceAccountId__c;
	        }
	        update assets;
		}

		catch(Exception ex){
			System.debug(ex);
		}

   }
}