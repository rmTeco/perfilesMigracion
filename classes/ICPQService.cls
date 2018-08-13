public interface ICPQService {
    Id AssetToOrder(Id accountId, DateTime requestDate, Set<Id> assetIds);
    String SubmitOrder(Id orderId);
}