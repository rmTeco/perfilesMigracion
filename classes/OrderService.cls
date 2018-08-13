public with sharing class OrderService {
    public static Id CreateFromAssets(Id accountId, Set<Id> assetIds) {
        return Service().CreateFromAssets(accountId, assetIds);
    }

    public static void Submit(Set<Id> orderIds) {
        Service().Submit(orderIds);
    }
    
    private static IOrderService Service() {
        return (IOrderService) Application.Service.NewInstance(IOrderService.Class);
    }
}