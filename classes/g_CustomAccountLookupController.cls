global class g_CustomAccountLookupController{
    public List<Account> Account_results {get;set;} // search results
    public List<Account> PersonAccount_results {get;set;} // search results
  
    public string searchString {get;set;} // search keyword, set either by invoking page or via URI
    public static string ixnId {get;set;} // interaction id
    public string inServiceCloudConsole {get;set;} // set in constructor 
    public string Name {get;set;} //set by invoking page 
    public string Phone {get;set;} 
    public string lookupNumber {get; set; }
    public string PersonEmail {get;set;}   
    
    public string searchObjectType {get;set;}
    	 
    public Boolean isPersonAccountEnabled {get {
    		return g_WorkspaceConnectorController.personAccountsEnabled;
    	}
    }    
 
    
    public Boolean displayAsBusinessAccount{ get {    
    	return g_WorkspaceConnectorController.personAccountsEnabled && searchObjectType == 'account';
    	}
    }
  
    public g_CustomAccountLookupController() {
        // get the current search string
        searchString = System.currentPageReference().getParameters().get('lksrch');
        if (searchString != null && searchString != ''){
			searchString = searchString.removeEnd('\"').removeStart('\"');
			searchString = searchString.replaceAll('MyAmpersand','\\&'); 
	    	searchString = searchString.replaceAll('SingleQuote','\\\'');
	    	searchString = searchString.replaceAll('MyPlus','\\+');
			system.debug('*** g_CustomAccountLookupController searchString ' + searchString);
		}
		else
			searchString = '';     
        
        ixnId = System.currentPageReference().getParameters().get('ixnId');
        inServiceCloudConsole = System.currentPageReference().getParameters().get('inServiceCloudConsole');
        searchObjectType =  System.currentPageReference().getParameters().get('searchObjectType');
        lookupNumber = System.currentPageReference().getParameters().get('lookupNumber');
		Phone = lookupNumber;
		Name = '';
        
        system.debug('*** CustomAccountLookupController ixnId ' + ixnId);
        system.debug('*** CustomAccountLookupController inServiceCloudConsole '+inServiceCloudConsole);
        system.debug('*** CustomAccountLookupController search for '+searchString);   
        system.debug('*** CustomAccountLookupController searchObjectType '+searchObjectType);   
          
        if (searchString != null && searchString != '') {
            loadSearchResults(searchString);
        }
        else
        	performSearch();        
    }    
    
    // performs the keyword search
    global PageReference search() {
        system.debug('*** search');
        runSearch();
        return null;
    }
    
  
    // prepare the query and issue the search command
    private void runSearch() {
        system.debug('*** runSearch');
        performSearch();         
    } 
    
     public void loadSearchResults(string searchString) {
  		system.debug('*** loadSearchResults for ' + searchString);
 
        List<List<SObject>> cobjects = null;
        List<List<SObject>> personCobjects = null;
      
        Account_results = new List<Account>();
        PersonAccount_results = new List<Account>();   
        Integer listSize = 0;  
        
      
    	try{
            List<Account> allResults = (List<Account>)System.JSON.deserialize(searchString, List<Account>.class);
            system.debug('*** loadSearchResults List<Account> allResults: ' + allResults);
            if (isPersonAccountEnabled == false){            	
            	Account_results.addAll((List<Account>) allResults);
            	system.debug('*** loadSearchResults: Only Business Accounts' );
            }
            /*else{
            	system.debug('*** performSearch: Business and Person Accounts' );
            	for (Account c : allResults) {
               		if (c.IsPersonAccount == false){
               			 Account_results.add(c);
               		}
               		else{
               			PersonAccount_results.add(c);
               		}
            	}	            	
            }*/
            system.debug('*** loadSearchResults: Account_results from searchString = ' + Account_results);
            /*if (isPersonAccountEnabled == true){
            	system.debug('*** PersonAccount_results from searchString = ' + PersonAccount_results);
            }*/
    	}
    	catch (Exception e) {
            system.debug('*** loadSearchResults: ERROR = ' + e); 
        }
        populateResultsByType();        
    }
  
    // run the search and save the records found. 
    public void performSearch(){
		system.debug('*** performSearch for ' + searchString);
        system.debug('*** performSearch for AccountName = ' + Name);
        system.debug('*** performSearch for Phone = ' + Phone);
        
        List<List<SObject>> cobjects = null;
        List<List<SObject>> personCobjects = null;
      
        Account_results = new List<Account>();
        PersonAccount_results = new List<Account>();   
        Integer listSize = 0; 
        
        //search by Name 
        if (Name != null && Name != '') {        	
    	 	string term = '%' + Name + '%'; 
            system.debug('*** Search by name only:  term = ' + term);
            List<Account> Account_result = null;
            List<Account> PersonAccount_result = null;
            String accountQuery = '';
            String personQuery = '';            
            try {
	            if (isPersonAccountEnabled == false){
	            	accountQuery = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name,Phone WHERE Name like \'' + term + '\')';
	            	system.debug('***accountQuery = ' + accountQuery); 
	            	cobjects = search.query(accountQuery);
	            	if (cobjects != null && cobjects.size() > 0)
	            		Account_result = ((List<Account>)cobjects[0]);
	            }
	            /*else{
	            	accountQuery = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name,Phone, PersonEmail WHERE IsPersonAccount = false and Name like \'' + term + '\')';
	            	personQuery = 'FIND \'* OR *\'  IN ALL FIELDS RETURNING Account(Id, Name,Phone, PersonEmail WHERE IsPersonAccount = true and Name like \'' + term + '\')';

	            	system.debug('***accountQuery = ' + accountQuery); 
	            	system.debug('***personQuery = ' + personQuery);
	            	
	            	cobjects = search.query(accountQuery);
	            	Account_result = ((List<Account>)cobjects[0]);
	            	
	            	personCobjects = search.query(personQuery);
	            	PersonAccount_result = ((List<Account>)personCobjects[0]);
	            	
	            	
	            	if (PersonAccount_result != null){
	            		PersonAccount_results.addAll(PersonAccount_result);
	            		listSize = PersonAccount_results.size(); 
		            	system.debug('*** Person Account Count = ' + listSize);
		            	if (listSize > 0)
		            		system.debug('***PersonAccount_result = ' + PersonAccount_results);            		
	            	}
	            	else
	            		system.debug('*** Person Account Count = 0'); 
	            }*/  
	            
	            //Remove duplicates
	            if (Account_result != null && Account_result.size() > 0){
	            	for (Account a: Account_result){
		          		Boolean alreadyAdded = false;
		          		for(Account r: account_results){
		          			if (r.Id == a.Id){
		          				alreadyAdded = true;
		          				break;
		          			}
		          		}
		          		if (alreadyAdded == false){
		          			account_results.add(a);
		          		}
	          		}
	            }

	            listSize = Account_results.size(); 
	            system.debug('*** performSearch: Business Account Count = ' + Account_results.size());
	            if (listSize > 0)
		        	system.debug('*** performSearch: Business Account_result = ' + Account_results);
            }
             catch (Exception e) {
            	system.debug('*** performSearch: ERROR = ' + e); 
        	}
            
        }
        //search by phone
       	if (Phone != null && Phone != '') {   
       		system.debug('*** performSearch: Search by phone only:  phone = ' + Phone);
        	try {
                      
            	listSize = 0;
            	if (isPersonAccountEnabled == false){
                	cobjects = [FIND :Phone IN PHONE FIELDS RETURNING Account(Id, Name,Phone)];
            	}
            	/*else{
            		String accountQuery = 'FIND :Phone IN PHONE FIELDS RETURNING Account(Id, Name,Phone, PersonEmail WHERE IsPersonAccount = false)';
            		cobjects = search.query(accountQuery);
            		String personQuery = 'FIND :Phone IN PHONE FIELDS RETURNING Account(Id, Name,Phone, PersonEmail WHERE IsPersonAccount = true)';
            		personCobjects = search.query(personQuery);
            		List<Account> PersonAccount_result = ((List<Account>)personCobjects[0]);
            		if (PersonAccount_result != null && personAccount_result.size() > 0){
            			listSize = PersonAccount_result.size(); 
            			system.debug('*** Person Account Count = ' + listSize);
	            		//Remove duplicates
		            	for (Account a: PersonAccount_result){
			          		Boolean alreadyAdded = false;
			          		for(Account r: PersonAccount_results){
			          			if (r.Id == a.Id){
			          				alreadyAdded = true;
			          				break;
			          			}
			          		}
			          		if (alreadyAdded == false){
			          			PersonAccount_results.add(a);
			          		}
		          		}
            			listSize = PersonAccount_results.size(); 
            			system.debug('***PersonAccount_results = ' + PersonAccount_results);   
            		}
            		else
            			system.debug('*** Person Account Count = 0'); 
            	}*/            	                
                List<Account> Account_result = ((List<Account>)cobjects[0]);             
                if (Account_result != null && Account_result.size() > 0){
                	listSize = Account_result.size();
                	system.debug('*** performSearch: Account Count = ' + listSize);
                	//Remove duplicates
	            	for (Account a: Account_result){
		          		Boolean alreadyAdded = false;
		          		for(Account r: account_results){
		          			if (r.Id == a.Id){
		          				alreadyAdded = true;
		          				break;
		          			}
		          		}
		          		if (alreadyAdded == false){
		          			account_results.add(a);
		          		}
	          		}
	            }
                system.debug('*** performSearch: Business Account Count with Phone = ' + Account_results.size());
            }
            catch (Exception e) {
            	system.debug('*** performSearch: ERROR = ' + e); 
        	}
        }         
        populateResultsByType(); 
    }
    
    private void populateResultsByType(){
    	system.debug('*** populateResultsByType Count of Account_results= ' + Account_results.size());
         if (isPersonAccountEnabled == true){
         	 system.debug('*** Count of PersonAccount_results= ' + PersonAccount_results.size());
         }
        
        List<g_AccountWrapper> myresult = null;   
                  
        try {
            if (Account_results.size() != 0) {
                Set<Account> myAccountSet = new Set<Account>();
                myresult = new List<g_AccountWrapper>();
                myAccountSet.addAll(Account_results);
                for (Account c : myAccountSet) {
                    myresult.add(new g_AccountWrapper(c));
                }
                myresult.sort();

                Account_results.clear();
                for (g_AccountWrapper g_c : myresult) {
                    Account_results.add(g_c.getAccount());
                }
            }
        }
        catch (Exception e) {
            system.debug('*** ERROR = ' + e); 
        }
        
        try {
            if (PersonAccount_results.size() != 0) {
                Set<Account> myPersonAccountSet = new Set<Account>();
                myresult = new List<g_AccountWrapper>();
                myPersonAccountSet.addAll(PersonAccount_results);
                for (Account c : myPersonAccountSet) {
                    myresult.add(new g_AccountWrapper(c));
                }
                myresult.sort();

                PersonAccount_results.clear();
                for (g_AccountWrapper g_c : myresult) {
                    PersonAccount_results.add(g_c.getAccount());
                }
            }
        }
        catch (Exception e) {
            system.debug('*** ERROR = ' + e); 
        }
    	
    }
    
    
    // used by the visualforce page to send the link to the right dom element
    public string getFormTag() {
        return System.currentPageReference().getParameters().get('frm');
    }
      
    // used by the visualforce page to send the link to the right dom element for the text box
    public string getTextBox() {
        return System.currentPageReference().getParameters().get('txt');
    }
}