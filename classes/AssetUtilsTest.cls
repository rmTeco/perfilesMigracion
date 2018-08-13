@isTest
public class AssetUtilsTest {
    
    @testSetup private static void gerenateData() {
        
        AssetsMinimalDateFilter__c assetMin = new AssetsMinimalDateFilter__c(Name = 'FilterDate', AssetMinDate__c = Date.today());
        insert assetMin;
        
        Account acc = new Account(Name = 'Customer', vlocity_cmt__EnableAutopay__c = true, vlocity_cmt__AutoPaymentAmount__c  = 'Full Balance', Phone = '123245');
        insert acc;
        
        // Asset asst = new Asset(Name = 'Asset', AccountId = acc.Id);
        // insert asst;
        List<Order> listOrder = TestDataFactory.createOrders(1,acc);
        Order order = listOrder[0];
        List<Product2> product = TestDataFactory.createProduct(1);
        List<Asset> assets = TestDataFactory.createAssets(1,product.get(0),acc);
        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithAsset(1,order,assets.get(0));
        assets[0].vlocity_cmt__OrderProductId__c = orderItems[0].Id;
        update assets;

        Case c = new Case(AssetId = assets[0].Id);
        insert c;

        Asset assetaux = [SELECT vlocity_cmt__OrderProductId__r.OrderId FROM Asset WHERE Id = :assets[0].Id LIMIT 1];
        System.debug(assetaux);
        Order orderaux = [SELECT Id, OriginStoreLocation__c, CreatedDate, DeliveryDate__c, Delivery_Method__c, vlocity_cmt__OriginatingChannel__c
                         FROM Order
                        WHERE Id = : assetaux.vlocity_cmt__OrderProductId__r.OrderId];
        System.debug(orderaux);
    }
    
    @isTest private static void testInvoke() {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options;
        
        Id assId = [SELECT Id FROM Asset LIMIT 1].Id;
        inputMap.put('Id', assId);

        AssetUtils au = new AssetUtils();

        Test.startTest();
        	au.invokeMethod('getNegotiations', inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest private static void testInvoke2() {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options;
        
        Id assId = [SELECT Id FROM Asset LIMIT 1].Id;
        inputMap.put('Id', assId);

        AssetUtils au = new AssetUtils();

        Test.startTest();
        	au.invokeMethod(null, inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest private static void testNegotiation(){       
        AssetUtils.Negotiation assUtil = new AssetUtils.Negotiation();
        
        assUtil.Name = '';
        assUtil.negDate = Date.today();
        assUtil.negNumber = '';
        assUtil.negType = '';
        assUtil.status = '';
    }

    @isTest private static void getOrdersByAsset(){
        Id assetId = [SELECT Id FROM Asset LIMIT 1].Id;
        AssetUtils utils = new AssetUtils();
        List<OrderItem> orders = utils.getOrdersByAsset(assetId);
    }

    @isTest private static void getOrderByAsset(){
        Id assetId = [SELECT Id FROM Asset LIMIT 1].Id;
        Order order = AssetUtils.getOrderByAsset(assetId);
    }

    @isTest private static void getCasesByAsset(){
        Id assetId = [SELECT Id FROM Asset LIMIT 1].Id;
        AssetUtils utils = new AssetUtils();
        List<Case> cases = utils.getCasesByAsset(assetId);
    }
}