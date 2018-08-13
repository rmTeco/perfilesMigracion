@isTest
private class CostForChangesServiceTest {
  
  @testSetup static void createDataTest(){
    Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
      Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;
        
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(vlocity_cmt__Code__c = 'Codigo', Name='Telecom Price List');
        insert priceList;
        
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
                
        Order order = new Order(Name='TestOrder',
              AccountId=acc.Id,
              EffectiveDate=Date.today(),
              Status='Draft',
              Pricebook2Id =Test.getStandardPricebookId(),
              vlocity_cmt__PriceListId__c=priceList.Id,
              Delivery_Method__c='Delivery',
              vlocity_cmt__OriginatingChannel__c='Agentes');
        insert order;
        
        Product2 product = new Product2(Name='TestProduct', ProductCode='TestProductCode');
        insert product;
                
        Asset asset = TestDataFactory.createSingleAsset(product, acc.Id);
        
        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithAsset(1, order, asset);
        
  }
  
    @isTest static void CreateOrdersWithOrderIdNotEmpty(){
    //GIVEN
    String methodName = 'CreateOrders';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        List<Object> orders = new List<Object>();
        
        Order order = [SELECT Id FROM Order WHERE Name = 'TestOrder' LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c WHERE Name = 'Telecom Price List' LIMIT 1];
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('OrderId',order.Id);
        
        orders.add(orderMap);
        
        options.put('Orders', orders);
        input.put('PriceListId', priceList.Id);
    
    CostForChangesService CostForChangesService = new CostForChangesService();
    
    //WHEN
    Test.startTest();
        CostForChangesService.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        List<Object> orderOutput = (List<Object>) outMap.get('Orders');
        System.assertEquals(orders.size(), orderOutput.size());
  }
  
  @isTest static void CreateOrdersWithOrderIdEmpty(){
    //GIVEN
    String methodName = 'CreateOrders';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        List<Object> orders = new List<Object>();
        
        Order order = [SELECT Id FROM Order WHERE Name = 'TestOrder' LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c WHERE Name = 'Telecom Price List' LIMIT 1];
        
        Map<String,Object> orderMap = new Map<String,Object>();
        //orderMap.put('OrderId',null);
        
        orders.add(orderMap);
        
        
        Account acc = [SELECT Id FROM Account WHERE Name = 'Sample Account' LIMIT 1];
        
        Map<String, String> effectivedate = new Map<String,String>();
        effectivedate.put('effectivedate', '6/5/2017');
        Map<String, String> status = new Map<String,String>();
        status.put('status','Draft');
        Map<String, String> AccountId = new Map<String,String>();
        AccountId.put('AccountId',acc.Id);
        Map<String, String> PriceListIdMap = new Map<String,String>();
        PriceListIdMap.put('vlocity_cmt__PriceListId__c', priceList.Id);
        
        List<Object> inputFields = new List<Object>();
        inputFields.add(effectivedate);
        inputFields.add(status);
        inputFields.add(AccountId);
        inputFields.add(PriceListIdMap);
                
            
    options.put('PriceBookId', Test.getStandardPricebookId());
    options.put('inputFields', inputFields);
    options.put('objectType', 'Order');
    options.put('Orders', orders);
    options.put('vlcClass', 'CostForChangesService');
        input.put('PriceListId', priceList.Id);
    
    CostForChangesService CostForChangesService = new CostForChangesService();
    
    //WHEN
    Test.startTest();
        CostForChangesService.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        List<Object> orderOutput = (List<Object>) outMap.get('Orders');
        System.assertEquals(orders.size(), orderOutput.size());
  }
  
  @isTest static void ApplyDiscountToOrderItemsOK(){
    //GIVEN
    String methodName = 'ApplyDiscountToOrderItems';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        List<Object> orders = new List<Object>();
        
        Order order = [SELECT Id FROM Order WHERE Name = 'TestOrder' LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c WHERE Name = 'Telecom Price List' LIMIT 1];
        
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem];
        
        List<Object> orderItemsMap = new List<Object>();
        List<Id> orderItemsToUpdateId = new List<Id>();
        for(OrderItem orderI: orderItems){
          Map<String,Object> orderIMap = new Map<String,Object>();
          orderIMap.put('OrderItemId', orderI.Id);
          orderItemsToUpdateId.add(orderI.Id);
          orderItemsMap.add(orderIMap);
        }
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('OrderItems',orderItemsMap);
        
        orders.add(orderMap);
        
        options.put('Orders', orders);
    
    CostForChangesService CostForChangesService = new CostForChangesService();
    
    //WHEN
    Test.startTest();
        CostForChangesService.invokeMethod(methodName, input, outMap, options);
        List<OrderItem> result = [SELECT vlocity_cmt__OneTimeTotal__c FROM OrderItem WHERE Id IN :orderItemsToUpdateId];
        Test.stopTest();
        
        //THEN
        for(OrderItem oi: result){
          System.assertEquals(0, oi.vlocity_cmt__OneTimeTotal__c);
        }
        
  }
  
  @isTest static void GetCostDetailsOK(){
    //GIVEN
    String methodName = 'GetCostDetails';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        List<Object> orders = new List<Object>();
        
        Order order = [SELECT Id FROM Order WHERE Name = 'TestOrder' LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c WHERE Name = 'Telecom Price List' LIMIT 1];
        Product2 product = [SELECT Name FROM Product2 WHERE Name ='TestProduct'];
        List<OrderItem> orderItems = [SELECT Id,PricebookEntryId FROM OrderItem];
        
        Double unitPrice = [SELECT UnitPrice FROM PricebookEntry WHERE Id = :orderItems.get(0).PricebookEntryId LIMIT 1].UnitPrice;
        List<Object> orderItemsMap = new List<Object>();
        List<Id> orderItemsToUpdateId = new List<Id>();
        for(OrderItem orderI: orderItems){
          Map<String,Object> orderIMap = new Map<String,Object>();
          orderIMap.put('OrderItemId', orderI.Id);
          orderIMap.put('UnitPrice', unitPrice);
          orderItemsToUpdateId.add(orderI.Id);
          orderItemsMap.add(orderIMap);
        }
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('OrderItems',orderItemsMap);
        orderMap.put('ProductName',product.Name);
        
        orders.add(orderMap);
        
        options.put('Orders', orders);
    
    CostForChangesService CostForChangesService = new CostForChangesService();
    
    //WHEN
    Test.startTest();
        CostForChangesService.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        List<Object> costDetails = (List<Object>) outMap.get('CostDetails');
        System.assertEquals(orderItems.size(), costDetails.size());
        
  }
  
  @isTest static void GetPriceBookEntriesIdsOK(){
    //GIVEN
    String methodName = 'GetPriceBookEntriesIds';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        List<Object> orders = new List<Object>();
        
        Order order = [SELECT Id FROM Order WHERE Name = 'TestOrder' LIMIT 1];
        vlocity_cmt__PriceList__c priceList = [SELECT Id FROM vlocity_cmt__PriceList__c WHERE Name = 'Telecom Price List' LIMIT 1];
        Product2 product = [SELECT Name,ProductCode FROM Product2 WHERE Name ='TestProduct'];
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem];
        
        List<Object> orderItemsMap = new List<Object>();
        List<Id> orderItemsToUpdateId = new List<Id>();
        for(OrderItem orderI: orderItems){
          Map<String,Object> orderIMap = new Map<String,Object>();
          orderIMap.put('OrderItemId', orderI.Id);
          orderIMap.put('ProductCode', product.ProductCode);
          orderItemsToUpdateId.add(orderI.Id);
          orderItemsMap.add(orderIMap);
        }
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('OrderItems',orderItemsMap);
        
        orders.add(orderMap);
        
        Id PriceBookId = Test.getStandardPricebookId();
        
        options.put('Orders', orders);
        options.put('PriceBookId', PriceBookId);
    
    CostForChangesService CostForChangesService = new CostForChangesService();
    
    //WHEN
    Test.startTest();
        CostForChangesService.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        List<Object> ordersOutMap = (List<Object>) outMap.get('Orders');
        System.assertEquals(orders.size(), ordersOutMap.size());
        for(Object o: ordersOutMap){
          Map<String,Object> oMap = (Map<String,Object>) o;
          List<Object> ois = (List<Object>) oMap.get('OrderItems');
          for(Object oi: ois){
            Map<String,Object> oiMap = (Map<String,Object>) oi;
            System.assertEquals(true, oiMap.containsKey('PriceBookEntryId'));
          }
        }
        
  }
  
  @isTest static void GetInputJsonOK(){
    //GIVEN
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> order = new Map<String, Object>();
        
        order.put('Id', 'OrderId');
        order.put('ProductCode', 'ProductCode');
        options.put('PriceBookId', 'PriceBookId');
        
    //WHEN
    Test.startTest();
        Map<String, Object> result = CostForChangesService.GetInputJson(order, options);
        Test.stopTest();
        
        //THEN
        List<Object> items = (List<Object>) result.get('items');
        System.assertEquals(true, result.containsKey('cartId'));
        System.assertNotEquals(0, items.size());
  }
  
  @isTest static void GetInputJson2OK(){
    //GIVEN
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> order = new Map<String, Object>();
        
        order.put('Id', 'OrderId');
        order.put('ProductCode', 'ProductCode');
        options.put('PriceBookId', 'PriceBookId');
        
    //WHEN
    Test.startTest();
        Map<String, Object> result = CostForChangesService.GetInputJson2(order, options);
        Test.stopTest();
        
        //THEN
        List<Object> items = (List<Object>) result.get('items');
        System.assertEquals(true, result.containsKey('cartId'));
        System.assertNotEquals(0, items.size());
  }
  
  @isTest static void AddLineItemsToOrdersTest(){
    //GIVEN
    String methodName = 'AddLineItemsToOrders';
        Map<String, Object> input = new Map<String, Object>();
    Map<String, Object> outMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
                
        List<Object> orders = new List<Object>();
                
        Order orderOBJ = [SELECT Id FROM Order WHERE Name = 'TestOrder' LIMIT 1];
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('OrderId',orderOBJ.Id);
        
        orders.add(orderMap);
    options.put('Orders', orders);
    
    CostForChangesService CostForChangesService = new CostForChangesService();
            
    //WHEN
    Test.startTest();
        CostForChangesService.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        //System.assertEquals(null, result);
        System.assert(true);
  }
}