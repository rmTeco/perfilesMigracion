@RestResource(urlMapping = '/OwnershipChanges')
global with sharing class OwnershipChangesRest {
	
	/*
	params :
	String orderId 
	String accountId
	String contextId
	return: Response
	*/
	@HttpPut
	global static void addOrderLine() {
		
		String orderId = '';
		String accountId = '';
		String contextId = '';
		String assetId = '';
		String orderItemId = '';
		Object assetMap = null;
		Map<String, Object> assetInfoMap;
		OrderResponse orderResp = null;
		RestResponse res;
		
		try {
			res = RestContext.response;
			Blob body = RestContext.request.requestBody;
	        Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(body.toString());
	        
	        orderId = (String)bodyMap.get('OrderId');
	        accountId = (String)bodyMap.get('AccountId');
	        contextId = (String)bodyMap.get('ContextId');
	        assetMap = (Object)bodyMap.get('Asset');
	        assetInfoMap = (Map<String, Object>)assetMap;
			assetId = String.valueOf(assetInfoMap.get('Id'));
			
			if (String.isNotBlank(orderId) && String.isNotBlank(accountId) && String.isNotBlank(contextId) && assetMap != null) {
			
				Map<String,Object> inputMap = new Map<String,Object>();
				Map<String,Object> outMap = new Map<String,Object>();
				Map<String,Object> options = new Map<String,Object>();
				
				inputMap.put('ContextId', contextId);
				inputMap.put('Asset', assetMap);
				inputMap.put('AccountId' , accountId);
				inputMap.put('OrderId', orderId);
				
				//system.debug('body ' + body.toString());
				
				OwnerShipChangesService owc = new OwnerShipChangesService();
				if(Test.isRunningTest() == false) {
					owc.invokeMethod('addOrderLineRest', inputMap, outMap, options);
				}
				
				// This method must be called after addOrderLineRest invoke
				Set<String> orderItemIdSet = new Set<String>();
				getOrderItemId(orderId, assetId, orderItemIdSet);
				system.debug('OrderSet: ' + orderItemIdSet);
				if (orderItemIdSet != null && orderItemIdSet.isEmpty() == false) {
					List<String> orderItemIdList = new List<String>(orderItemIdSet);
					orderResp = new OrderResponse(orderItemIdList.get(0), assetId, orderId, 'OK');
				} else {
					orderResp = new OrderResponse(null, assetId, orderId, 'Fail: Order Item not found');
				}
			} else {
				orderResp = new OrderResponse(orderItemId, assetId, orderId, 'Parameters cannot be null or empty');
			}
			res.responseBody = Blob.valueOf(JSON.serialize(orderResp));
		} catch (Exception ex) {
			system.debug('Error: ' + ex);
			orderResp = new OrderResponse(orderItemId, assetId, orderId, 'FAIL');
			res.responseBody = Blob.valueOf(JSON.serialize(orderResp));
		}
	}
	
	private static void getOrderItemId(String orderId, String assetId, Set<String> orderItemIdSet) {
		if (String.isNotBlank(orderId) && String.isNotBlank(assetId)) {
			for (OrderItem oi : [SELECT Id FROM OrderItem WHERE OrderId = :orderId AND vlocity_cmt__AssetId__c = :assetId]) {
				orderItemIdSet.add(oi.Id);
			}
		}
	}
	
	global class OrderResponse {
		
		global Object orderItemId {get; set;}
		global String assetId {get; set;}
		global String orderId {get; set;}
		global String msg {get; set;}
		
		public OrderResponse(String orderItemId, String assetId, String orderId, String msg) {
			this.orderItemId = orderItemId;
			this.assetId =  assetId;
			this.orderId = orderId;
			this.msg = msg;
		}
	}
}