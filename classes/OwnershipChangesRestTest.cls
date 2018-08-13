@isTest
public class OwnershipChangesRestTest {

  /*@TestSetup
  static void prepareDate() {

    
    
    
    OrderItem ordItem = new OrderItem(OrderId = ordId, vlocity_cmt__AssetId__c = asstId, Quantity = 1);
    insert ordItem;
  }*/

  /*@isTest
  static void addOrderLineGeneralException() {

    try {
      Test.startTest();
        RestRequest req = new RestRequest();
            req.requestURI  = '/services/apexrest/ownershipchanges';
            req.httpMethod = 'PUT';
            RestContext.request = req;
            
            OwnershipChangesRest.addOrderLine();
          Test.stopTest();
    } catch (system.AssertException assEx) {
      system.debug('Error');
    }
  }*/  

  @isTest
  static void addOrderLine_OK() {
    List<Account> lstConsAccs = TestDataFactory.createAccounts(1, 'Consumer');
    List<Account> lstBillAccs = TestDataFactory.createAccounts(1, 'Billing');

    List<Product2> lstProds = TestDataFactory.createProduct(1);
    List<Asset> lstAssets = TestDataFactory.createAssets(1, lstProds[0], lstConsAccs[0]);
    List<Order> lstOrders = TestDataFactory.createOrders(1, lstConsAccs[0]);
    List<OrderItem> lstOrdIt = TestDataFactory.createOrderItemsWithAsset(3, lstOrders[0], lstAssets[0]);
    
    Test.startTest();
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

        req.requestURI  = '/services/apexrest/OwnershipChanges';
        req.httpMethod = 'PUT';
        
        req.requestBody = Blob.valueOf('{"OrderId": "' + lstOrders[0].Id + '","Asset": {"Id": "' + lstAssets[0].Id + '"},"AccountId": "' + lstConsAccs[0].Id +'","ContextId": "' + lstBillAccs[0].Id + '"}');
        
        RestContext.request = req;
        RestContext.response = res;

        OwnershipChangesRest.addOrderLine();
        
        Test.stopTest();

        Blob respBody = RestContext.response.responseBody;
        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(respBody.toString());
          
        String msg = (String)bodyMap.get('msg');

        System.assertEquals('OK', msg);
  }
  
  @isTest
  static void addOrderLine_NoLineItems() {
    List<Account> lstConsAccs = TestDataFactory.createAccounts(1, 'Consumer');
    List<Account> lstBillAccs = TestDataFactory.createAccounts(1, 'Billing');

    List<Order> lstOrders = TestDataFactory.createOrders(1, lstConsAccs[0]);
    //List<OrderItem> lstOrdIt = TestDataFactory.createOrderItem(3, lstOrders[0]);
    List<Product2> lstProds = TestDataFactory.createProduct(1);
    List<Asset> lstAssets = TestDataFactory.createAssets(1, lstProds[0], lstConsAccs[0]);
    
    Test.startTest();
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

        req.requestURI  = '/services/apexrest/OwnershipChanges';
        req.httpMethod = 'PUT';
        
        req.requestBody = Blob.valueOf('{"OrderId": "' + lstOrders[0].Id + '","Asset": {"Id": "' + lstAssets[0].Id + '"},"AccountId": "' + lstConsAccs[0].Id +'","ContextId": "' + lstBillAccs[0].Id + '"}');
        
        RestContext.request = req;
        RestContext.response = res;

        OwnershipChangesRest.addOrderLine();
        
        Test.stopTest();

        Blob respBody = RestContext.response.responseBody;
        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(respBody.toString());
          
        String msg = (String)bodyMap.get('msg');

        System.assertEquals('Fail: Order Item not found', msg);
  }

  @isTest
  static void addOrderLine_NullParameters() {
    List<Account> lstConsAccs = TestDataFactory.createAccounts(1, 'Consumer');
    List<Account> lstBillAccs = TestDataFactory.createAccounts(1, 'Billing');

    Test.startTest();
    
    RestRequest req = new RestRequest();
    RestResponse res = new RestResponse();

        req.requestURI  = '/services/apexrest/OwnershipChanges';
        req.httpMethod = 'PUT';
        
        req.requestBody = Blob.valueOf('{"OrderId": "","Asset": {"Id": ""},"AccountId": "","ContextId": ""}');
        
        RestContext.request = req;
        RestContext.response = res;

        OwnershipChangesRest.addOrderLine();
        
        Test.stopTest();

        Blob respBody = RestContext.response.responseBody;
        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(respBody.toString());
          
        String msg = (String)bodyMap.get('msg');

        System.assertEquals('Parameters cannot be null or empty', msg);
  }
}