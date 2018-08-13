public class CasesSelector extends ApplicationSelector {
    public Schema.SObjectType GetSObjectType() {
        return Case.SObjectType;
    }

    public List<Schema.SObjectField> GetSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Case.Id,
            Case.Status,
            Case.Type,
            Case.SubType__c,
            Case.Reason,
            Case.ParentId,
            Case.AccountId,
            Case.Order__c
        };
    }

    public List<Case> SelectById(Set<Id> caseIds) {
        return (List<Case>) this.SelectSObjectsById(caseIds);
    }

    public List<Case> SelectByOrderId(Set<Id> orderIds) {
        return (List<Case>) Database.Query(
            this.NewQueryFactory().SetCondition('Order__c IN :orderIds').ToSOQL()
        );
    }

    public List<Case> SelectByOrderIdWithAsset(Set<Id> orderIds) {
        fflib_QueryFactory casesQueryFactory = this.NewQueryFactory();
       
        new AssetsSelector().ConfigureQueryFactoryFields(
            casesQueryFactory,
            Case.AssetId.GetDescribe().GetRelationshipName());

        return (List<Case>) Database.Query(
            casesQueryFactory.SetCondition('Order__c IN :orderIds').ToSOQL()
        );
    }
}