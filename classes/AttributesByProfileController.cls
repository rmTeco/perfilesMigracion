public class AttributesByProfileController {
	
	public AttributesbyProfile__c record {get;set;}
    public List<SelectOption> account1List{get;set;}
    public List<SelectOption> account2List{get;set;}
    public List<SelectOption> contact1List{get;set;}
    public List<SelectOption> contact2List{get;set;}
    public String accountString = Label.Account;
    public String contactString = label.Contact;
    public String selectedProfile {get;set;}

    public AttributesByProfileController(){

        selectedProfile = System.currentPagereference().getParameters().get('Id');

    	record = new AttributesByProfile__c();
    	fillAttributesList();
   	}
 
   	private void fillAttributesList(){
   		
        if(selectedProfile != null){
            List<AttributesbyProfile__c> profileList = [SELECT Id, SetupOwnerId, 
                                                               AccountAttributes__c, ContactAttributes__c
                                                         FROM AttributesbyProfile__c
                                                         WHERE Id = :selectedProfile];
            record = profileList[0];
        }

   		account1List = new List<SelectOption>();
    	account2List = new List<SelectOption>();
    	
        contact1List = new List<SelectOption>();
        contact2List = new List<SelectOption>();
        
   		Schema.DescribeFieldResult fieldResultAccount;
        Schema.DescribeFieldResult fieldResultContact;
        fieldResultAccount = Account.Attributes__c.getDescribe();
        fieldResultContact = Contact.Attributes__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultAccount.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
            
            if(record.AccountAttributes__c != null){
                if(record.AccountAttributes__c.contains(pickListVal.getLabel())){
                    account2List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));    
                }
                else{
                    account1List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));
                }
            }
            else{
                account1List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));
            }
            
        }
        ple = fieldResultContact.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            if(record.AccountAttributes__c != null){
                if(record.ContactAttributes__c.contains(pickListVal.getLabel())){
                    contact2List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));    
                }
                else{
                    contact1List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));
                }
            }
            else{
                contact1List.add(new selectoption(pickListVal.getLabel(),pickListVal.getLabel()));
            }
        }
        record.AccountAttributes__c = null;
        record.ContactAttributes__c = null;
    }

    public PageReference refillPage(){
    	fillAttributesList();
    	return null;
    }

    public Pagereference cancel(){	
        return Page.attributesLanding;
    }

    private Boolean validatesExistence(){

        if(selectedProfile != null){
            return false;
        }
    	List<AttributesByProfile__c> exist = [SELECT Id FROM AttributesByProfile__c
    										   WHERE SetupOwnerId =:record.SetupOwnerId];
    	if(exist.isEmpty()){
    		return false;
    	}
    	return true;
    }

    public Pagereference save(){
    	if(!validatesExistence()){
            for(SelectOption profile : account2List){
                if(record.AccountAttributes__c == null){
                    record.AccountAttributes__c = profile.getValue();
                }else{
        		  record.AccountAttributes__c = record.AccountAttributes__c + '; ' + profile.getValue(); 
                }	
            }
            for(SelectOption profile : contact2List){
                if(record.ContactAttributes__c == null){
                    record.ContactAttributes__c = profile.getValue();
                }else{
                   record.ContactAttributes__c = record.ContactAttributes__c + '; ' + profile.getValue();  
                }
            }
            upsert record;
    		return Page.attributesLanding;
    	}
    	else{
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.ProfileAlreadyExist));
    		return null;		
    	}
    }
}