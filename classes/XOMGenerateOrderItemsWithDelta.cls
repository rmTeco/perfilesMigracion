global with sharing class XOMGenerateOrderItemsWithDelta {
	global XOMGenerateOrderItemsWithDelta()
	{}

	webservice static string GenerateDelta(Id orderId)
	{
		try{
			List<OrderItem> newOrderItems = new List<OrderItem>();
			List<OrderItem> oldOrderItems = new List<OrderItem>();
			Set<Id> orderItemsToDelete = new Set<Id>();
			List<Order> orders = [Select Id, (Select Id, vlocity_cmt__AssetId__c,ProductCode__c,vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__ParentItemId__c,vlocity_cmt__ParentOrderProduct__c, vlocity_cmt__Action__c  From OrderItems) From Order Where Id = :orderId];

			for(Order order : orders)
			{
				for(OrderItem orderItem : order.OrderItems)
				{
					if(orderItem.vlocity_cmt__Action__c == 'Add')
					{
						newOrderItems.add(orderItem);
					}
					else if( orderItem.vlocity_cmt__Action__c == 'Disconnect')
					{
						oldOrderItems.add(orderItem);
					}
				}
			}
			System.debug('old' + oldOrderItems + 'new '+newOrderItems);
			for(Order order : orders)
			{
				for(OrderItem orderItem : order.OrderItems)
				{
					if(orderItem.vlocity_cmt__Action__c == 'Disconnect')
					{
						for(OrderItem newOrderItem : newOrderItems)
						{
							if(orderItem.ProductCode__c == newOrderItem.ProductCode__c)
							{
								orderItem.vlocity_cmt__Action__c = 'Modify';
								orderItem.vlocity_cmt__ProvisioningStatus__c = 'Modified';
								if(newOrderItem.vlocity_cmt__ParentItemId__c != null)
								{
									orderItem.vlocity_cmt__ParentItemId__c = newOrderItem.vlocity_cmt__ParentItemId__c;
								}
								orderItemsToDelete.add(newOrderItem.Id);
							}
							/*else if(orderItem.vlocity_cmt__ParentItemId__c == null &&  newOrderItem.vlocity_cmt__ParentItemId__c == null)
							{
								orderItemsToDelete.add(orderItem.Id);
								break;
							}*/
						}
					}
				}
			}

			/*for(Order order : orders)
			{
				for(OrderItem orderItem : order.OrderItems)
				{
					if(orderItem.vlocity_cmt__Action__c == 'Disconnect')
					{
						orderItem.vlocity_cmt__ParentItemId__c = null;
					}
				}
			}*/
			if(orderItemsToDelete.size() > 0)
			{
				for(Order order : orders)
				{
					update order.OrderItems;
				}
				delete [Select Id From OrderItem where id in :orderItemsToDelete];
			}
			return 'OK' +'newOrderItems: '+ newOrderItems +'oldOrderItems: '+ oldOrderItems+ 'orderItemsToDelete: ' +orderItemsToDelete;
		}
		catch(Exception ex){
			System.debug(ex);
			return 'error';
		}
	}

}