public class AssetServiceImpl implements IAssetService {
    public Id Suspend(Id accountId, Set<Id> assetIds, SuspensionReason suspensionReason) {
        try {
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.NewInstance();
            OrdersSelector ordersSelector = (OrdersSelector) Application.Selector.NewInstance(Order.SObjectType);
                        
            Id orderId = OrderService.CreateFromAssets(accountId, assetIds);
            List<Order> orderList = ordersSelector.SelectByIdWithOrderItemsAndProducts(new Set<Id> { orderId });

            Orders orders = (Orders) Application.Domain.NewInstance(orderList);
            orders.ComposeSuspension(unitOfWork, suspensionReason);

            unitOfWork.CommitWork();

            return orderId;
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    public Id Resume(Id accountId, Set<Id> assetIds) {
        try {
            fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.NewInstance();
            OrdersSelector ordersSelector = (OrdersSelector) Application.Selector.NewInstance(Order.SObjectType);
            AssetsSelector assetsSelector = (AssetsSelector) Application.Selector.NewInstance(Asset.SObjectType);

            Map<Id, Asset> assetsWithActiveSuspension = new Map<Id, Asset>(assetsSelector.SelectByIdWithActiveSuspension(assetIds));

            Id orderId = OrderService.CreateFromAssets(accountId, assetIds);
            List<Order> orderList = ordersSelector.SelectByIdWithOrderItemsProductsAndAssets(new Set<Id> { orderId });

            Orders orders = (Orders) Application.Domain.NewInstance(orderList);
            orders.ComposeReconnection(unitOfWork, assetsWithActiveSuspension);

            unitOfWork.CommitWork();

            return orderId;
        }
        catch (Exception ex) {
            throw ex;
        }
    }
}