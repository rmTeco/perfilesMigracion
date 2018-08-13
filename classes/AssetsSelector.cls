public class AssetsSelector extends ApplicationSelector {
    public Schema.SObjectType GetSObjectType() {
        return Asset.SObjectType;
    }

    public List<Schema.SObjectField> GetSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Asset.Id,
            Asset.Status,
            Asset.Sub_Status__c,
            Asset.AccountId,
            Asset.CreatedDate,
            Asset.Vlocity_cmt__RootItemId__c,
            Asset.Imei__c
        };
    }

    public override String GetOrderBy() {
        return 'CreatedDate';
    }

    public List<Asset> SelectById(Set<Id> assetIds) {
        return (List<Asset>) this.SelectSObjectsById(assetIds);
    }

    public List<Asset> SelectByAccountId(Set<Id> accountIds) {
        return (List<Asset>) Database.Query(
            this.NewQueryFactory().SetCondition('AccountId IN :accountIds').ToSOQL()
        );
    }

    public List<Asset> SelectByIdWithActiveSuspension(Set<Id> assetIds) {
        fflib_QueryFactory assetsQueryFactory = this.NewQueryFactory();
        
        fflib_QueryFactory transactionsHistorySubQueryFactory = 
            new TransactionsHistorySelector().AddQueryFactorySubSelect(assetsQueryFactory);
        transactionsHistorySubQueryFactory.SetCondition('New_Status__c = \'Active\'');

        return (List<Asset>) Database.Query(
            assetsQueryFactory.SetCondition('Id IN :assetIds').ToSOQL()
        );
    }

    public List<Asset> SelectByOrderId(Set<Id> orderIds) {
        List<Asset> assets = new List<Asset>();
        List<OrderItem> orderItems = new OrderItemsSelector().SelectByOrderIdWithAsset(orderIds);

        for (OrderItem orderItem : orderItems)
            assets.add(orderItem.vlocity_cmt__AssetId__r);

        return assets;
    }

    public List<Asset> SelectByIMEI(Set<String> imeis) {
        return (List<Asset>) Database.Query(
            this.NewQueryFactory().SetCondition('Imei__c IN :imeis AND Status = \'Active\'').ToSOQL()
        );
    }
}