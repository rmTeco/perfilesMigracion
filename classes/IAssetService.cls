public interface IAssetService {
    Id Suspend(Id accountId, Set<Id> assetIds, SuspensionReason suspensionReason);
    Id Resume(Id accountId, Set<Id> assetIds);
}