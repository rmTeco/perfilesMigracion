@IsTest
public class Vlocity_PricingRulesImplementation_Test {
    
    @IsTest static void priceLineItems_Test(){
  
        Vlocity_PricingRulesImplementation testedClass = new Vlocity_PricingRulesImplementation(); 
        Product2 prod = TestDataFactory.createProduct(1)[0]; 
        List<Account> acc = TestDataFactory.createAccounts(1, 'Consumer'); 
        List<Asset> lstAsset = TestDataFactory.createAssets(2, acc.get(0));
        List<Order> lstOrder = TestDataFactory.createOrders(2, acc.get(0));
        List<OrderItem> lstOrderItem = TestDataFactory.createOrderItemsWithAsset(2, lstOrder.get(0), lstAsset.get(0));
        
        Test.startTest();
            testedClass.priceLineItems(prod, lstOrderItem);
        Test.stopTest();
    }
  
}