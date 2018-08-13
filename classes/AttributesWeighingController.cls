public class AttributesWeighingController {
	
	public AttributesWeighing__c record {get;set;}
    public List<SelectOption> objectsList{get;set;}
    public List<AttributesWeighing__c> attributesList{get;set;}
    public String accountString = Label.Account;
    public String contactString = label.Contact;
    
    public AttributesWeighingController(){

        attributesList = new List<AttributesWeighing__c>();
    	objectsList = new List<SelectOption>();
    	record = new AttributesWeighing__c();

    	objectsList.add(new selectoption(accountString,accountString));
    	objectsList.add(new selectoption(contactString,contactString));
    	record.object__c = accountString;
    	attributesList = fillAttributesList(record.object__c);
   	}

    
   	public static List<AttributesWeighing__c> fillAttributesList(String inputObject){

   		List<String> schemaAttributes = new List<String>();
        List<AttributesWeighing__c> weighingList = new List<AttributesWeighing__c>();
   		Schema.DescribeFieldResult fieldResult;
        if(inputObject== Label.Account){
        	fieldResult = Account.Attributes__c.getDescribe();
        }
        if(inputObject == Label.Contact){
        	fieldResult = Contact.Attributes__c.getDescribe();
        }
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			String aux = pickListVal.getLabel();
			schemaAttributes.add(aux);
		}
		weighingList = [SELECT Id, Name, object__c, attribute__c, weighing__c
		 			      FROM AttributesWeighing__c
		 				 WHERE Attribute__c IN :schemaAttributes
		 				   AND object__c =:inputObject ORDER BY weighing__c DESC];
        
        if(schemaAttributes.size()!=weighingList.size()){
            //If the Multipicklist has a new value which is not into the custom settings
            for(String schema : schemaAttributes){
                Boolean exist = false;
                for(AttributesWeighing__c attribute : weighingList){
                    if(attribute.attribute__c == schema){
                        exist = true;
                        break;
                    }
                }
                if(!exist){
                    AttributesWeighing__c newRecord = new AttributesWeighing__c();
                    newRecord.Name = inputObject + '_' +schema;
                    newRecord.Object__c = inputObject;
                    newRecord.Attribute__c = schema;
                    newRecord.Weighing__c = 0;
                    weighingList.add(newRecord);
                }
            }
        }

        return weighingList;
    }

    public PageReference refillAttributesList(){
    	attributesList = new List<AttributesWeighing__c>();
        attributesList = fillAttributesList(record.object__c);
    	return null;
    }

    public Pagereference cancel(){
    	
        return Page.attributesLanding;
    }

    public Pagereference save(){
    	upsert attributesList;
    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,Label.WeighingSave));
    	fillAttributesList(record.object__c);
    	return null;
    }
}