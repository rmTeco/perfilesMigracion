public class ProductsSelector extends ApplicationSelector {
    public Schema.SObjectType GetSObjectType() {
        return Product2.SObjectType;
    }

    public List<Schema.SObjectField> GetSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Product2.Id,
            Product2.Tangible__c
        };
    }

    public List<Product2> SelectById(Set<Id> productIds) {
        return (List<Product2>) this.SelectSObjectsById(productIds);
    }
}