public class TransactionsHistorySelector extends ApplicationSelector {
    public Schema.SObjectType GetSObjectType() {
        return Transaction_History__c.SObjectType;
    }

    public List<Schema.SObjectField> GetSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Transaction_History__c.Id,
            Transaction_History__c.Sinister_type__c,
            Transaction_History__c.Asset__c,
            Transaction_History__c.Subscribe_Date__c,
            Transaction_History__c.Type__c
            
        };
    }

    public override String GetOrderBy() {
        return 'Subscribe_Date__c';
    }

    public List<Transaction_History__c> SelectById(Set<Id> transactionHistoryIds) {
        return (List<Transaction_History__c>) this.SelectSObjectsById(transactionHistoryIds);
    }

    public List<Transaction_History__c> SelectByAssetId(Set<Id> assetIds) {
        return (List<Transaction_History__c>) Database.Query(
            this.NewQueryFactory().SetCondition('Asset__c IN :assetIds').ToSOQL()
        );
    }

    public List<Transaction_History__c> SelectByAssetIdAndStatus(Set<Id> assetIds, String status) {
        return (List<Transaction_History__c>) Database.Query(
            this.NewQueryFactory().SetCondition('Asset__c IN :assetIds AND New_Status__c = :status').ToSOQL()
        );
    }

    public List<Transaction_History__c> SelectActiveByAssetIdAndType(Set<Id> assetIds, String type) {
        return (List<Transaction_History__c>) Database.Query(
            this.NewQueryFactory().SetCondition('Asset__c IN :assetIds AND New_Status__c = \'Active\' AND Type__c = :type').ToSOQL()
        );
    }
}