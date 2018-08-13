public with sharing class AssetService {
    public static Id Suspend(Id accountId, Set<Id> assetIds, SuspensionReason suspensionReason) {
        return Service().Suspend(accountId, assetIds, suspensionReason);
    }

    public static Id Resume(Id accountId, Set<Id> assetIds) {
        return Service().Resume(accountId, assetIds);
    }

    private static IAssetService Service() {
        return (IAssetService) Application.Service.NewInstance(IAssetService.Class);
    }
}