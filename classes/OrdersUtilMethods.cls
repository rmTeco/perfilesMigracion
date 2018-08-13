global with sharing class OrdersUtilMethods implements vlocity_cmt.VlocityOpenInterface {
    
    public class wrapAccount {
            public Datetime createdDate {get;set;}
            public String deliveryMethod {get;set;}
            public Id orderId {get;set;}
            public String orderNumber {get;set;}
            public String status {get;set;}
            public String accountName {get; set;}
            public String contactName {get; set;}
     
            public wrapAccount(Order paramOrd, String acName, String ctName) {
                Order ord = paramOrd;
                createdDate = ord.CreatedDate;
                deliveryMethod = ord.Delivery_Method__c;
                orderId = ord.Id;
                orderNumber = ord.OrderNumber;
                status = ord.TrackingStatus__c;
                accountName = acName;
                contactName = ctName;
            }
        }

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('getOrdersWithContactInfo')){
                getOrdersWithContactInfo(inputMap, outMap);
            }
            result = false;  
        } 
        catch(Exception e)
        {
            System.debug('OrdersUtilMethods:invokeMethod -> exception: '+e);
            throw e;
        }
        return result;
    }

    
    global static void getOrdersWithContactInfo(Map<String,Object> inputMap, Map<String, Object> outMap)
    {
        try
        {
            System.debug('getOrdersWithContactInfo');
            Map<Id,Order> mapOrders = new Map<Id,Order>();
            List<wrapAccount> wrapAccountList = new List<wrapAccount>();
            Map<Id,Account> mapAccounts = new Map<Id,Account>();
            Set<Id> accountIds = new Set<Id>();
            
            String orderStatus = (String) inputMap.get('orderStatus');

            //PFTA-7438 - Store Pickup - Flujo de Derivacion - INI
            vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
            String channel = storeLocation.Channel_Type__c;
            Id userStoreLocationId = storeLocation.Id;

            if (channel == 'Agentes')
            {
                mapOrders = new Map<Id,Order>([ SELECT Id, OrderNumber, CreatedDate, Delivery_Method__c, TrackingStatus__c, Account.Id, Account.Name, Account.vlocity_cmt__PrimaryContactId__r.Name
                                            FROM Order
                                            WHERE TrackingStatus__c =: orderStatus
                                            AND Delivery_Method__c = 'Store Pick Up'
                                            AND PickUpStoreLocation__c =: userStoreLocationId]);
            }
            else
            {
                mapOrders = new Map<Id,Order>([ SELECT Id, OrderNumber, CreatedDate, Delivery_Method__c, TrackingStatus__c, Account.Id, Account.Name, Account.vlocity_cmt__PrimaryContactId__r.Name
                                            FROM Order
                                            WHERE TrackingStatus__c =: orderStatus
                                            AND (
                                                (PickUpStoreLocation__c =: userStoreLocationId)
                                                OR
                                                (OriginStoreLocation__c =: userStoreLocationId
                                                    AND PickUpStoreLocation__c =: null)
                                                )
                                            ]);
            }
            //PFTA-7438 - Store Pickup - Flujo de Derivacion - FIN
            String auxAccountName = '';
            String auxContactName = '';
            wrapAccountList = new List<wrapAccount>();
            
            for (Order ordObj : mapOrders.values())
            {
                auxAccountName = ordObj.Account.Name;
                auxContactName = ordObj.Account.vlocity_cmt__PrimaryContactId__r.Name;
                wrapAccount tempObj = new wrapAccount(ordObj, auxAccountName, auxContactName);
                wrapAccountList.add(tempObj);
            }
            
            outMap.put('ordersResult', wrapAccountList);
        }
        catch(Exception e)
        {
            System.debug('OrdersUtilMethods:getOrdersWithContactInfo -> exception: '+e);
            throw e;
        }
    }

    /**
     * Method to check if all the products of an order are prepaid products
     *
     * @param idOrder the id of the order to check
     *
     * @return true or false if the products are all prepaid or not
     */
    public static Boolean OrderItemsAreAllPrepaid(String idOrder) {
        System.debug('Order Items Are All Prepaid');

        Boolean allPrepaidItems = false;

        List<OrderItem> orderItems = [SELECT Id, Product2Id, Product2.vlocity_cmt__Type__c FROM OrderItem WHERE OrderId =: idOrder];
        Set<Id> setIdsPrepaidProductsInOrder = getIdsPlanProductsInOrder(orderItems);

        if (!setIdsPrepaidProductsInOrder.isEmpty()) {
            Boolean allPrepaidOrderItemsInAPlan = checkAllOrderItemsInAPlan(orderItems, setIdsPrepaidProductsInOrder);
            allPrepaidItems = allPrepaidOrderItemsInAPlan;
        }

        return allPrepaidItems;
    }

    /**
     * Method to get the ids of the order items that are a plan
     *
     * @param orderItems list of the products in the order
     *
     * @return set of ids of the order items that are a plan
     */
    private static Set<Id> getIdsPlanProductsInOrder(List<OrderItem> orderItems) {
        System.debug('Check Ids Plan Products In Order');


        Set<Id> setIdsPrepaidProductsInOrder = new Set<Id>();
        for (OrderItem ordItem : orderItems) {
            if (ordItem.Product2.vlocity_cmt__Type__c == 'Plan Prepago' )
                setIdsPrepaidProductsInOrder.add(ordItem.Product2Id);
        }

        return setIdsPrepaidProductsInOrder;
    }

    /**
     * Method to check if the products of the order are all part of a plan
     *
     * @param orderItems list of the products of the order
     * @param setIdsPlanProductsInOrder set of ids of the products in the order that are a plan
     *
     * @return true or false depending if all the products of the order are part of a plan or not
     */
    private static Boolean checkAllOrderItemsInAPlan(List<OrderItem> orderItems, Set<Id> setIdsPlanProductsInOrder) {
        System.debug('Check All Order Items are part of a Plan');

        // To avoid using recursion with SOQL inside, we do three different steps
        // First Step
        List<vlocity_cmt__ProductChildItem__c> prepaidProductChildItems = [SELECT Id, vlocity_cmt__ChildProductId__c FROM vlocity_cmt__ProductChildItem__c WHERE vlocity_cmt__ParentProductId__c IN :setIdsPlanProductsInOrder];
        Set<Id> setIdsProductChildItems = new Set<Id>();
        for (vlocity_cmt__ProductChildItem__c prodChildItem : prepaidProductChildItems) {
            setIdsProductChildItems.add(prodChildItem.vlocity_cmt__ChildProductId__c);
        }
        Set<Id> setIdsProductInOrderNotInFirstChildLevel = new Set<Id>();
        for (OrderItem productInOrder : orderItems) {
            if (productInOrder.Product2.vlocity_cmt__Type__c != 'Plan Prepago' && !setIdsProductChildItems.contains(productInOrder.Product2Id)) {
                setIdsProductInOrderNotInFirstChildLevel.add(productInOrder.Product2Id);
            }
        }

        // Second Step
        List<vlocity_cmt__ProductChildItem__c> secondLevelPrepaidProductChildItems = new List<vlocity_cmt__ProductChildItem__c>();
        if (!setIdsProductInOrderNotInFirstChildLevel.isEmpty()) {
            secondLevelPrepaidProductChildItems = [SELECT Id, vlocity_cmt__ChildProductId__c FROM vlocity_cmt__ProductChildItem__c WHERE vlocity_cmt__ParentProductId__c IN :setIdsProductChildItems];
        }
        Set<Id> setIdsSecondLevelProductChildItems = new Set<Id>();
        for (vlocity_cmt__ProductChildItem__c prodChildItem : secondLevelPrepaidProductChildItems) {
            setIdsSecondLevelProductChildItems.add(prodChildItem.vlocity_cmt__ChildProductId__c);
        }
        Set<Id> setIdsProductInOrderNotInSecondChildLevel = new Set<Id>();
        for (Id prodNotInOrderIds : setIdsProductInOrderNotInFirstChildLevel) {
            if (!setIdsSecondLevelProductChildItems.contains(prodNotInOrderIds)) {
                setIdsProductInOrderNotInSecondChildLevel.add(prodNotInOrderIds);
            }
        }

        // Third Step
        List<vlocity_cmt__ProductChildItem__c> thirdLevelPrepaidProductChildItems = new List<vlocity_cmt__ProductChildItem__c>();
        if (!setIdsProductInOrderNotInSecondChildLevel.isEmpty()) {
            thirdLevelPrepaidProductChildItems = [SELECT Id, vlocity_cmt__ChildProductId__c FROM vlocity_cmt__ProductChildItem__c WHERE vlocity_cmt__ParentProductId__c IN :setIdsSecondLevelProductChildItems];
        }
        Set<Id> setIdsThirdLevelProductChildItems = new Set<Id>();
        for (vlocity_cmt__ProductChildItem__c prodChildItem : thirdLevelPrepaidProductChildItems) {
            setIdsThirdLevelProductChildItems.add(prodChildItem.vlocity_cmt__ChildProductId__c);
        }
        Set<Id> setIdsProductInOrderNotInThirdChildLevel = new Set<Id>();
        for (Id prodNotInOrderIds : setIdsProductInOrderNotInSecondChildLevel) {
            if (!setIdsThirdLevelProductChildItems.contains(prodNotInOrderIds)) {
                setIdsProductInOrderNotInThirdChildLevel.add(prodNotInOrderIds);
            }
        }

        return (setIdsProductInOrderNotInThirdChildLevel.isEmpty());
    }
}