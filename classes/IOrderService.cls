public interface IOrderService {
    Id CreateFromAssets(Id accountId, Set<Id> assetIds);
    void Submit(Set<Id> orderIds);
}