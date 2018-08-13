public class OrderServiceImpl implements IOrderService {
    public Id CreateFromAssets(Id accountId, Set<Id> assetIds) {
        return CPQService.AssetToOrder(accountId, DateTime.Now(), assetIds);
    }

    public void Submit(Set<Id> orderIds) {
        for (Id orderId : orderIds)
            CPQService.SubmitOrder(orderId);
    }
}