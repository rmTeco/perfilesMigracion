@isTest
public class Vlocity_PricingHybridImplementationTest{
    
    @isTest
    public static void testMethod1(){
        Vlocity_PricingHybridImplementation PHI = new Vlocity_PricingHybridImplementation();
        List<Account> acc = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> lstOrder = TestDataFactory.createOrders(2, acc.get(0));
        List<Product2> lstProd = TestDataFactory.createProduct(2);
        List<Asset> lstAsset = TestDataFactory.createAssets(2, acc.get(0));
        List<OrderItem> lstOrderItem = TestDataFactory.createOrderItemsWithAsset(2, lstOrder.get(0), lstAsset.get(0));
        String methodName = 'priceLineItems';
        Map<String,Object> input = new Map<String,Object>();
        input.put('parent', lstAsset.get(0));
        input.put('itemList', lstOrderItem);
        Map<String,Object> output = new Map<String,Object>();
        output.put('Test', lstOrderItem.get(0));
        Map<String,Object> options = new Map<String,Object>();
        options.put('Test', lstOrderItem.get(0));
        PHI.invokeMethod(methodName, input, output, options);
    }
    
    @isTest public static void testMethod2(){
        Vlocity_PricingHybridImplementation PHI = new Vlocity_PricingHybridImplementation();
        String methodName = 'test';
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        PHI.invokeMethod(methodName, input, output, options);
    }
}