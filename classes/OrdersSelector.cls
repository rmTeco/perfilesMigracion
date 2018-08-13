public class OrdersSelector extends ApplicationSelector {
    public Schema.SObjectType GetSObjectType() {
        return Order.SObjectType;
    }

    public List<Schema.SObjectField> GetSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Order.Id,
            Order.Status,
            Order.AccountId
        };
    }

    public List<Order> SelectById(Set<Id> orderIds) {
        return (List<Order>) this.SelectSObjectsById(orderIds);
    }

    public List<Order> SelectByIdWithOrderItems(Set<Id> orderIds) {
        fflib_QueryFactory ordersQueryFactory = this.NewQueryFactory();
        fflib_QueryFactory orderItemsSubQueryFactory = new OrderItemsSelector().AddQueryFactorySubSelect(ordersQueryFactory);

        return (List<Order>) Database.Query(
            ordersQueryFactory.SetCondition('Id IN :orderIds').ToSOQL()
        );
    }

    public List<Order> SelectByIdWithOrderItemsAndProducts(Set<Id> orderIds) {
        fflib_QueryFactory ordersQueryFactory = this.NewQueryFactory();
        fflib_QueryFactory orderItemsSubQueryFactory = new OrderItemsSelector().AddQueryFactorySubSelect(ordersQueryFactory);

        new ProductsSelector().ConfigureQueryFactoryFields(
            orderItemsSubQueryFactory,
            OrderItem.vlocity_cmt__Product2Id__c.GetDescribe().GetRelationshipName());

        return (List<Order>) Database.Query(
            ordersQueryFactory.SetCondition('Id IN :orderIds').ToSOQL()
        );
    }

    public List<Order> SelectByIdWithOrderItemsProductsAndAssets(Set<Id> orderIds) {
        fflib_QueryFactory ordersQueryFactory = this.NewQueryFactory();
        fflib_QueryFactory orderItemsSubQueryFactory = new OrderItemsSelector().AddQueryFactorySubSelect(ordersQueryFactory);

        new ProductsSelector().ConfigureQueryFactoryFields(
            orderItemsSubQueryFactory,
            OrderItem.vlocity_cmt__Product2Id__c.GetDescribe().GetRelationshipName());

        new AssetsSelector().ConfigureQueryFactoryFields(
            orderItemsSubQueryFactory,
            OrderItem.Vlocity_cmt__AssetId__c.GetDescribe().GetRelationshipName());

        return (List<Order>) Database.Query(
            ordersQueryFactory.SetCondition('Id IN :orderIds').ToSOQL()
        );
    }
}