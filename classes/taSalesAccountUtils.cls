global with sharing class taSalesAccountUtils implements vlocity_cmt.VlocityOpenInterface{

	public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getAccountAddresses')){
                getAccountAddresses(input, outMap, options);
            }
            if(methodName.equals('removeAddress')){
                removeAddress(input, outMap);
            }
            if(methodName.equals('getAuthorizedContacts')){
                getAuthorizedContacts(input, outMap, options);
            }
            if(methodName.equals('saveAuthorizedContacts')){
                saveAuthorizedContacts(input, outMap, options);
            }
        }
        catch(Exception e)
        {
            System.debug('taSalesAccountUtils:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    public void getAuthorizedContacts(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        String idOrder = (String)options.get('IdOrder');
        String postOfficeFlag = (String)options.get('PostOfficeFlag');
        String contactNodeName = (String)options.get('ContactNodeName');
        String deliveryMethodServiceNodeName = (String)options.get('DeliveryMethodServiceNodeName');
        Order order = [SELECT Id, vlocity_cmt__ShippingName__c FROM Order WHERE Id =: idOrder];
        System.debug(order.vlocity_cmt__ShippingName__c);
        if (postOfficeFlag == 'NO')//Para lograr compatibilidad en Delivery. Retiro en sucursal y envio.
            order.vlocity_cmt__ShippingName__c = order.vlocity_cmt__ShippingName__c.remove('PO');
        System.debug(order.vlocity_cmt__ShippingName__c);
        Map<String, Object> postOfficeSelection = new Map<String, Object>();
        try
        {
            Map<String, Object> contact = (Map<String, Object>) JSON.deserializeUntyped(order.vlocity_cmt__ShippingName__c);
            postOfficeSelection.put(contactNodeName, contact);
        }
        catch(Exception e)
        {
            List<Object> contactsList = (List<Object>) JSON.deserializeUntyped(order.vlocity_cmt__ShippingName__c);
            postOfficeSelection.put(contactNodeName, contactsList);
        }
        outMap.put(deliveryMethodServiceNodeName, postOfficeSelection);
    }

    public void saveAuthorizedContacts(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('saveAuthorizedContacts');
        System.debug('options: ' + options);
        String idOrder = (String)options.get('IdOrder');
        String shippingName;
        try
        {
            Map<String, Object> authorizedContact = (Map<String, Object>)options.get('AuthorizedContacts');
            shippingName = JSON.serialize(authorizedContact);
        }
        catch(Exception e)
        {
            List<Object> authorizedContacts = (List<Object>)options.get('AuthorizedContacts');
            shippingName = JSON.serialize(authorizedContacts);
        }
        //shippingName = shippingName.remove('PO');//Para lograr compatibilidad en Delivery. Retiro en sucursal y envio.
        System.debug('shippingName: ' + shippingName);
        Order order = new Order();
        order.Id = idOrder;
        order.vlocity_cmt__ShippingName__c = shippingName;
        System.debug('order.vlocity_cmt__ShippingName__c: ' + order.vlocity_cmt__ShippingName__c);
        update order;
    }

    //GET ACCOUNT ID, GET ORDERS FOR ACCOUNT, RETURN COLLECTION OF DISTINCT ADDRESSES
    public void getAccountAddresses(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('getAccountAddresses');
    	String accountId = (String)options.get('accountId');
        System.debug('accountId: ' + accountId);
    	List<Order> orders = [SELECT Id, ShippingAditionalInformation__c, ShippingCity, ShippingApartment__c, ShippingFloor__c, ShippingPostalCode, ShippingStreet1__c, ShippingStreet2__c, ShippingStateCode, ShippingStreet__c, ShippingStreetNumber__c, vlocity_cmt__ShippingState__c FROM Order WHERE AccountId =: accountId AND AddressHidden__c = false];
        Map<String, OrderAddress> addresses = new Map<String, OrderAddress>();
    	for(Order o: orders){
            OrderAddress oa = new OrderAddress(o);
            if(oa.orderString != 'nullnullnullnullnullnullnullnullnullnullnull'){
                OrderAddress existingOa = addresses.get(oa.orderString);
                if(existingOa == null){
                    existingOa = oa;
                }else{
                    existingOa.addOrderId(o.Id);
                }
                addresses.put(oa.orderString, existingOa);
            }
    	}

    	List<Map<String, Object>> distinctAddresses = new List<Map<String, Object>>();
    	for(OrderAddress uniqueAddress: addresses.values()){
    		Order o = uniqueAddress.o;
    		Map<String, Object> jsonMap = new Map<String, Object>();
    		jsonMap.put('ShippingAditionalInformation', o.ShippingAditionalInformation__c);
    		jsonMap.put('ShippingCity', o.ShippingCity);
    		jsonMap.put('ShippingApartment', o.ShippingApartment__c);
    		jsonMap.put('ShippingFloor', o.ShippingFloor__c);
    		jsonMap.put('ShippingPostalCode', o.ShippingPostalCode);
    		jsonMap.put('ShippingStreet1', o.ShippingStreet1__c);
    		jsonMap.put('ShippingStreet2', o.ShippingStreet2__c);
    		jsonMap.put('ShippingStateCode', o.ShippingStateCode);
    		jsonMap.put('ShippingStreet', o.ShippingStreet__c);
    		jsonMap.put('ShippingStreetNumber', o.ShippingStreetNumber__c);
            jsonMap.put('ShippingState', o.vlocity_cmt__ShippingState__c);
            jsonMap.put('OrderIds', uniqueAddress.orderIds);
            distinctAddresses.add(jsonMap);
    	}
        System.debug('distinctAddresses: ' + distinctAddresses);

    	outMap.put('addresses', distinctAddresses);
    }

    public void removeAddress(Map<String, Object> input, Map<String, Object> outMap){
        Map<String, Object> shippingAddressData = (Map<String, Object>)input.get('ShippingAddressData');
        Map<String, Object> address = (Map<String, Object>)shippingAddressData.get('Address');
        List<Object> ids = (List<Object>) address.get('Ids');
        List<Order> orders = new List<Order>();
        for(Object str: ids){
            Id orderId = Id.valueOf((String)str);
            orders.add(new Order(Id = orderId, AddressHidden__c = true));
        }
        update orders;
        address.put('showDeleted', 'true');
        shippingAddressData.put('Address', address);
        outMap.put('ShippingAddressData', shippingAddressData);

    }

    public class OrderAddress implements Comparable{
    	public Order o;
    	public String orderString;
        public Set<String> orderIds;

    	public OrderAddress(Order ord){
    		o = ord;
    		orderString = o.ShippingAditionalInformation__c + o.ShippingCity + o.ShippingApartment__c + o.ShippingFloor__c + o.ShippingPostalCode + o.ShippingStreet1__c + o.ShippingStreet2__c + o.ShippingStateCode + o.ShippingStreet__c + o.ShippingStreetNumber__c + o.vlocity_cmt__ShippingState__c;
            orderIds = new Set<String>();
            addOrderId(o.Id);
        }

        public void addOrderId(String orderId){
            orderIds.add(orderId);
        }

    	public Integer compareTo(Object obt){
    		OrderAddress ob = (OrderAddress)obt;
    		String s = orderString;
    		if(orderString == ob.orderString) return 0;
    		return 1;
    	}
    }
}