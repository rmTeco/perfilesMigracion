public with sharing class CPQService {
    public static Id AssetToOrder(Id accountId, DateTime requestDate, Set<Id> assetIds) {
        return Service().AssetToOrder(accountId, requestDate, assetIds);
    }

    public static String SubmitOrder(Id orderId) {
        return Service().SubmitOrder(orderId);
    }

    private static ICPQService Service() {
        return (ICPQService) Application.Service.NewInstance(ICPQService.Class);
    }
}