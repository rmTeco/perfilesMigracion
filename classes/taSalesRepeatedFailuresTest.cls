@isTest
private class taSalesRepeatedFailuresTest{
    
    @isTest
    static void invoke_RepeatedFailures_OK(){

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Account account = TestDataFactory.CreateAccounts(1)[0];
        List<Order> orders = TestDataFactory.CreateOrders(3, account);
        Asset asset = TestDataFactory.CreateAssets(1, account)[0];
        List<Case> expectedCases = TestDataFactory.CreateCases(3, account.Id, asset.Id, 'TestSubject');
        List<OrderItem> orderItems;
        RepeatedFailures__c objRepeatedFail = new RepeatedFailures__c();
        objRepeatedFail.Name = 'Failures';
        objRepeatedFail.Number_Failures__c = 3.0;
        insert objRepeatedFail;
        list<Product2> lstProduct = [SELECT Id,Name FROM Product2];
        for(Order objOrder : orders)
        {
            orderItems = TestDataFactory.createOrderItem(1, objorder);
        }
        list<OrderItem> objOrderItem = [SELECT Id,Product2Id FROM OrderItem];
        for (OrderItem itemx: orderItems)
        {
            itemx.vlocity_cmt__Product2Id__c = lstProduct[0].Id;
            update orderItems;
        }
        
        Set<Id> expectedOrderIds = new Map<Id, Order>(orders).KeySet();

        Test.startTest();
        taSalesRepeatedFailures testClass = new taSalesRepeatedFailures();
        options.put('assetId',asset.Id);
        taSalesRepeatedFailures.invokeMethod('RepeatedFailures', inputMap, outMap, options);
        Test.stopTest();
    }
}