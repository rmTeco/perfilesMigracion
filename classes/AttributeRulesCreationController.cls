public class AttributeRulesCreationController {

	public AttributesRules__c record {get;set;}
    public List<SelectOption> objectsList{get;set;}
    public List<SelectOption> attribute1List{get;set;}
    public List<SelectOption> attribute2List{get;set;}
    public String accountString = Label.Account;
    public String contactString = label.Contact;
    
    public AttributeRulesCreationController(){
 
    	objectsList = new List<SelectOption>();
    	record = new AttributesRules__c();

    	objectsList.add(new selectoption(accountString,accountString));
    	objectsList.add(new selectoption(contactString,contactString));
    	record.object__c = accountString;
    	fillAttributesList();
   	}

   	private void fillAttributesList(){
   		
   		attribute1List = new List<SelectOption>();
    	attribute2List = new List<SelectOption>();
    	
   		Schema.DescribeFieldResult fieldResult;
        if(record.object__c == accountString){
        	fieldResult = Account.Attributes__c.getDescribe();
        }
        if(record.object__c == contactString){
        	fieldResult = Contact.Attributes__c.getDescribe();
        }
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			attribute1List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));
			attribute2List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));
		}
    }

   	private void restart(){
   		//Restart default values after Saving
   		record = new AttributesRules__c();
 		record.object__c = accountString;
   		fillAttributesList();
   	}

    public PageReference refillAttributesList(){
    	fillAttributesList();
    	return null;
    }

    public Pagereference cancel(){
    	
        return Page.attributesLanding;
    }

    public Pagereference save(){

    	//Validates the rule attributes are not the same attribute
    	if(record.attribute1__c == record.attribute2__c){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.EqualAttributeError));
            return null;
    	}
    	//Validates the rule doesn't exist yet
    	List<AttributesRules__c> existing = [SELECT Id, name FROM AttributesRules__c
    										  WHERE object__c = :record.object__c
    										    AND ( attribute1__c = :record.attribute1__c OR attribute2__c = :record.attribute1__c)
    										    AND ( attribute1__c = :record.attribute2__c OR attribute2__c = :record.attribute2__c)];
    	if(!existing.isEmpty()){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.AttributesRuleAlreadyExist));
            return null;
    	}

    	//Selects the max value in order to create the new record key
    	List<AttributesRules__c> nameList = [SELECT Id, name FROM AttributesRules__c
    										  ORDER BY name DESC LIMIT 1];
    	if(nameList.isEmpty()){
    		record.name = '00000';
    	}else{
    		record.name = createKey(nameList[0].name);
    	}
    	insert record;
    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,Label.RuleSavingSucces));
    	restart();
    	return null;
    }

    //Creates autonum string key for Custom Settings
    static String createKey(String input){

    	//Get Max Value and add 1
    	Integer index = Integer.valueOf(input);
    	index++;
    	//Transforme to XXXXX
    	String result;
    	if(index < 10){
    		result = '0000' + String.valueOf(index);
    	}
    	if(index < 100 && index >= 10){
    		result = '000' + String.valueOf(index);
    	}
    	if(index < 1000 && index >= 100){
    		result = '00' + String.valueOf(index);
    	}
    	if(index < 10000 && index >= 1000){
    		result = '0' + String.valueOf(index);
    	}
    	if(index < 100000 && index >= 10000){
    		result = String.valueOf(index);
    	}
    	return result;
    }
}