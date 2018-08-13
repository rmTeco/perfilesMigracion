public class Application {
    public static final fflib_Application.UnitOfWorkFactory UnitOfWork = new fflib_Application.UnitOfWorkFactory(
        new List<SObjectType> {
            Asset.SObjectType,
            Transaction_History__c.SObjectType,
            Order.SObjectType,
            OrderItem.SObjectType,
            Case.SObjectType      
        }
    );

    public static final fflib_Application.ServiceFactory Service = new fflib_Application.ServiceFactory(
        new Map<Type, Type> {
            IAssetService.Class => AssetServiceImpl.Class,
            IOrderService.Class => OrderServiceImpl.Class,
            ICPQService.Class => CPQServiceImpl.Class
        }
    );

    public static final fflib_Application.SelectorFactory Selector = new fflib_Application.SelectorFactory(
        new Map<SOBjectType, Type> {
            Asset.SOBjectType => AssetsSelector.Class,
            Order.SOBjectType => OrdersSelector.Class,
            OrderItem.SOBjectType => OrderItemsSelector.Class,
            Case.SObjectType => CasesSelector.Class
        }
    );

    public static final fflib_Application.DomainFactory Domain = new fflib_Application.DomainFactory(
        Application.Selector,
        new Map<SOBjectType, Type> {
            Order.SObjectType => Orders.Constructor.Class,
            Asset.SObjectType => Assets.Constructor.Class,
            Transaction_History__c.SObjectType => TransactionsHistory.Constructor.Class,
            OrderItem.SObjectType => OrderItems.Constructor.Class
        }
    );
}