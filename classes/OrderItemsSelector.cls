public class OrderItemsSelector extends ApplicationSelector {
    public Schema.SObjectType GetSObjectType() {
        return OrderItem.SObjectType;
    }

    public List<Schema.SObjectField> GetSObjectFieldList() {
        return new List<Schema.SObjectField> {
            OrderItem.Id,
            OrderItem.Vlocity_cmt__AssetId__c
        };
    }

    public List<OrderItem> SelectById(Set<Id> orderItemIds) {
        return (List<OrderItem>) this.SelectSObjectsById(orderItemIds);
    }

    public List<OrderItem> SelectByOrderId(Set<Id> orderIds) {
        return (List<OrderItem>) Database.Query(
            this.NewQueryFactory().SetCondition('OrderId IN :orderIds').ToSOQL()
        );
    }

    public List<OrderItem> SelectByOrderIdWithAsset(Set<Id> orderIds) {
        fflib_QueryFactory orderItemsQueryFactory = this.NewQueryFactory();
       
        new AssetsSelector().ConfigureQueryFactoryFields(
            orderItemsQueryFactory,
            OrderItem.vlocity_cmt__AssetId__c.GetDescribe().GetRelationshipName());

        return (List<OrderItem>) Database.Query(
            orderItemsQueryFactory.SetCondition('OrderId IN :orderIds').ToSOQL()
        );
    }
}