@isTest

public class OrderItemsSelectorTest {

    @isTest static void SelectById_Test (){
        
        List<Account> accList = TestDataFactory.createAccounts(1);
        List<Order> orderList = TestDataFactory.createOrders(1,accList[0]);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItem(1,orderList[0]);
        Set<Id> orderItemSetIds = New Set<Id>();
        orderItemSetIds.add(orderItemList[0].Id);
        
        OrderItemsSelector orderItemSelec = New OrderItemsSelector();
        
        Test.startTest();
        List<OrderItem> resultList = orderItemSelec.SelectById(orderItemSetIds);
        Test.stopTest();
        
        system.assertEquals(orderItemList[0].Id,resultList[0].Id);
    }

    @isTest static void SelectByOrderId_Test(){

        List<Account> accList = TestDataFactory.createAccounts(1);
        List<Order> orderList = TestDataFactory.createOrders(1,accList[0]);
        List<OrderItem> orderItemList = TestDataFactory.createOrderItem(1,orderList[0]);
        Set<Id> setIds = New Set<Id>();
        setIds.add(orderList[0].Id);
        
        OrderItemsSelector orderItemSelec = New OrderItemsSelector();
        
        Test.startTest();
        List<OrderItem> resultList = orderItemSelec.SelectByOrderId(setIds);
        Test.stopTest(); 

        system.assertEquals(orderItemList[0].Id,resultList[0].Id);
    }

    @isTest static void SelectByOrderIdWithAsset(){

        List<Account> accList = TestDataFactory.createAccounts(1);
        List<Order> orderList = TestDataFactory.createOrders(1,accList[0]);
        List<Asset> assetList = TestDataFactory.createAssets(1,accList[0],'1111223344');
        List<OrderItem> orderItemList = TestDataFactory.createOrderItemsWithAsset(1,orderList[0],assetList[0]);
        Set<Id> setIds = New Set<Id>();
        setIds.add(orderList[0].Id);
        
        OrderItemsSelector orderItemSelec = New OrderItemsSelector();
    
        Test.startTest();
        List<OrderItem> resultList = orderItemSelec.SelectByOrderIdWithAsset(setIds);
        Test.stopTest();
        List<OrderItem> orderItemQueryList = [SELECT ID,OrderId,vlocity_cmt__AssetId__r.AccountId  FROM OrderItem WHERE Id =: orderItemList[0].Id];
        system.assertEquals(orderItemQueryList[0].vlocity_cmt__AssetId__r.AccountId,resultList[0].vlocity_cmt__AssetId__r.AccountId);
        
    }
}