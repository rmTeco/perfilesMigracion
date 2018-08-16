public class attributesLandingController {

	  public String record {get;set;}
    public List<SelectOption> objectsList{get;set;}
    public List<attributesWeighing__c> weighingList {get;set;}
    public List<attributesRules__c> rulesList {get;set;}
    public List<attributesByProfile__c> profilesList {get;set;}
    public String accountString = Label.Account;
    public String contactString = label.Contact;
	  public String selectedRuleId {get;set;}
	  public String selectedProfileId {get;set;}

    public attributesLandingController(){

    	objectsList = new List<SelectOption>();
    	
    	objectsList.add(new selectoption(accountString,accountString));
    	objectsList.add(new selectoption(contactString,contactString));
    	record = contactString;
    	refillPage();
    }

    public PageReference refillPage(){
    	fillWeighingList();
    	fillRulesList();
    	fillProfilesList();
    	return null;
    }

    //***************************
    // Attributes Weighing Block
    //***************************
    public void fillWeighingList(){
    	weighingList = new List<attributesWeighing__c>();
    	weighingList = AttributesWeighingController.fillAttributesList(record);
    }

    public Pagereference weighingEdit(){    	
      return Page.AttributesWeighing;
    }

    //***************************
    // Attributes Rules Block
    //***************************
    public void fillRulesList(){
    	rulesList = new List<attributesRules__c>();
    	rulesList = [SELECT Id, Name, Object__c,attribute1__c, attribute2__c FROM attributesRules__c
    				  WHERE object__c = :record ORDER BY attribute1__c];
    }

    public Pagereference newRule(){  	
        return Page.AttributeRulesCreation;
    }

    public void DeleteRule(){
      	// if for any reason we are missing the reference 
      	if (selectedRuleId == null) {
        	return;
      	}
      	// find the rule record within the collection
      	attributesRules__c tobeDeleted = null;
        for(attributesRules__c rule : rulesList){
        	if(rule.Id == selectedRuleId) {
          		tobeDeleted = rule;
        		break;
        	}
       	}
      	//if rule record found delete it
      	if (tobeDeleted != null) {
       		Delete tobeDeleted;
      	}
      	refillPage();
    }    
	
	  //***************************
    // Attributes Profiles Block
    //***************************
	  public void fillProfilesList(){
      profilesList = new List<attributesByProfile__c>();
    	profilesList = [SELECT Id, SetupOwnerId, AccountAttributes__c, ContactAttributes__c 
                        FROM AttributesByProfile__c ORDER BY SetupOwnerId];
    }

    public void DeleteProfile(){
        // if for any reason we are missing the reference 
      	if (SelectedProfileId == null) {
        	return;
      	}
      	// find the profile record within the collection
      	attributesByProfile__c tobeDeleted = null;
        for(attributesByProfile__c profile : profilesList){
        	if(profile.Id == SelectedProfileId) {
          		tobeDeleted = profile;
        		break;
        	}
       	}
      	//if profile record found delete it
      	if (tobeDeleted != null) {
       		Delete tobeDeleted;
      	}
      	refillPage();
    }

    public Pagereference EditProfile(){
        PageReference newpage = new Pagereference('/apex/AttributesByProfile?Id=' + SelectedProfileId);
        newpage.setRedirect(true);
        return newpage;
    }

    public PageReference newProfile(){
        return Page.AttributesByProfile;
    }
}