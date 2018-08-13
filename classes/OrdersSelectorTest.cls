@isTest
public class OrdersSelectorTest{

    public static Set<Id> getOrderSelectorIds(){
        List<Account> listAccount = TestDataFactory.createAccounts(1, 'Consumer');
        Set<Id> ordersIds;
        for(Account accountObj : listAccount)
        {
            List<Asset> listAsset = TestDataFactory.createAssets(1, accountObj);
            List<Order> listOrders = TestDataFactory.createOrders(1, accountObj);
            ordersIds = new Map<Id, Order>(listOrders).KeySet();

            Asset objAsset = (Asset)listAsset[0];
            Order objOrder = (Order)listOrders[0];
            List<OrderItem> listOrderItem = TestDataFactory.createOrderItemsWithAsset(1, objOrder, objAsset);
        }       

        return ordersIds;
    }

    @isTest
    public static void SelectById_Test(){
        OrdersSelector os = new OrdersSelector();
        List<Order> listOrder = os.SelectById(getOrderSelectorIds());

        System.assert(listOrder.size() == 1);
    }

    @isTest
    public static void SelectByIdWithOrderItems_Test(){
        OrdersSelector os = new OrdersSelector();
        List<Order> listOrder = os.SelectByIdWithOrderItems(getOrderSelectorIds());

        System.assert(listOrder.size() == 1);
    }

    @isTest
    public static void SelectByIdWithOrderItemsAndProducts_Test(){
        OrdersSelector os = new OrdersSelector();
        List<Order> listOrder = os.SelectByIdWithOrderItemsAndProducts(getOrderSelectorIds());

        System.assert(listOrder.size() == 1);
    }

    @isTest
    public static void SelectByIdWithOrderItemsProductsAndAssets_Test(){
        OrdersSelector os = new OrdersSelector();
        List<Order> listOrder = os.SelectByIdWithOrderItemsProductsAndAssets(getOrderSelectorIds());

        System.assert(listOrder.size() == 1);
    }

}