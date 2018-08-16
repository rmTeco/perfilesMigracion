public class AttributeCrossObjectExtension {
    
    public CrossObject__c record {get;set;}
    public List<SelectOption> RecordTypePicklist {get;set;}    
    public List<SelectOption> RecordTypeAdded {get;set;}    
    
    public AttributeCrossObjectExtension(ApexPages.StandardController stdCon){
        RecordTypePicklist = new list <SelectOption>();    
        RecordTypeAdded = new list <SelectOption>();    
        List<RecordType> RecordTypeList = new list <RecordType>();
        RecordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Account'];
    
        for(RecordType type : RecordTypeList){
            RecordTypePicklist.add(new selectoption(type.Id,type.DeveloperName));
        }
    }
    
    public pageReference save(){
        List<RecordType> RecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c'
                                                                 AND DeveloperName = 'Account_Attribute'];
        record.RecordTypeId = RecordType[0].Id;
        for(SelectOption so : RecordTypeAdded){
            record.String2__c = record.String2__c + so.getValue() + ';';
        }
        System.Debug('Yamil ' + record.String2__c);
        return null;
    }
}