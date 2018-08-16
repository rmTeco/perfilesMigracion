global class g_CustomCaseLookupController {
	public List<Case> case_results {get;set;} // search results
  
	public string searchString {get;set;} // search keyword, set either by invoking page or via URI
	public static string ixnId {get;set;} // interaction id 
	public string caseNumber {get;set;} //set by invoking page 
	public string subject {get;set;}    // set by invoking page
	public string createdDate {get;set;} 
	public string inServiceCloudConsole {get;set;} // set in constructor     
  
	public g_CustomCaseLookupController() {
		// get the current search string
		searchString = System.currentPageReference().getParameters().get('lksrch');
		if (searchString != null && searchString != ''){
			searchString = searchString.removeEnd('\"').removeStart('\"');
			searchString = searchString.replaceAll('MyAmpersand','\\&'); 
	    	searchString = searchString.replaceAll('SingleQuote','\\\'');
	    	searchString = searchString.replaceAll('MyPlus','\\+');
			system.debug('*** g_CustomCaseLookupController searchString ' + searchString);
		}
		else
			searchString = '';
		
		ixnId = System.currentPageReference().getParameters().get('ixnId');
		inServiceCloudConsole = System.currentPageReference().getParameters().get('inServiceCloudConsole');
		system.debug('*** CustomCaseLookupController ixnId ' + ixnId);
		system.debug('*** CustomCaseLookupController search for ' + searchString);     
		  
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
        case_results = new List<Case>();
        Integer listSize = 0;        
    	try{
            List<Case> allResults = (List<Case>)System.JSON.deserialize(searchString, List<Case>.class);
            system.debug('*** List<Case> allResults: ' + allResults);
           	
             case_results.addAll((List<Case>) allResults);
             system.debug('*** loadSearchResults: Only Business Accounts' );
           
    	}
    	catch (Exception e) {
            	system.debug('*** ERROR = ' + e); 
        }
    }
  
	// run the search and save the records found. 
	public void performSearch() {
		system.debug('*** performSearch on case');
		
		case_results = new List<Case>();
		Integer listSize = 0;
		system.debug('*** caseNumber = ' + caseNumber);
		system.debug('*** subject = ' + subject);
		system.debug('*** createdDate = ' + createdDate);
		List<List<SObject>> cobjects = null;
		string query;
		try {
			if (caseNumber != null && caseNumber != '') {
				//List<Case> case_results1 = [select Id, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate 
				//			from case where CaseNumber = :caseNumber];
				query = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Case(Id, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate WHERE  CaseNumber = \'' + caseNumber + '\')';
				system.debug('*** performSearch: query = ' + query); 
				cobjects = search.query(query);
				if (cobjects != null)
				{
					List<Case> case_results1 = ((List<Case>)cobjects[0]);  
					// Remove duplicates
		          	if (case_results1 != null && case_results1.size() > 0){
		          		system.debug('*** case_results1 size = ' + case_results1.size());
						system.debug('*** case_results1 = ' + case_results1);
			          	for (Case c1: case_results1){
			          		Boolean alreadyAdded = false;
			          		for(Case r: case_results){
			          			if (r.Id == c1.Id){
			          				alreadyAdded = true;
			          				break;
			          			}
			          		}
			          		if (alreadyAdded == false){
			          			case_results.add(c1);
			          		}
			          	}
		          	}
		          	else
		          		system.debug('*** case_results1 size = 0');
				}
			}          

			if (Subject != null && Subject != '') {
				string term = '%' + Subject + '%'; 				
				//List<Case> case_results2 = [select Id, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate 
				//			from case where Subject like :term];
				query = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Case(Id, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate WHERE  Subject like \'' + term + '\')';
				system.debug('*** performSearch: query = ' + query); 
				cobjects = search.query(query);
				if (cobjects != null)
				{
					List<Case> case_results2 = ((List<Case>)cobjects[0]); 
					// Remove duplicates
	          		if (case_results2 != null && case_results2.size() > 0){
	          			system.debug('*** case_results2 size = ' + case_results2.size());
						system.debug('*** case_results2 = ' + case_results2);
			          	for (Case c2: case_results2){
			          		Boolean alreadyAdded = false;
			          		for(Case r: case_results){
			          			if (r.Id == c2.Id){
			          				alreadyAdded = true;
			          				break;
			          			}
			          		}
			          		if (alreadyAdded == false){
			          			case_results.add(c2);
			          		}
			          	}
	          		}
	          		else
	          			system.debug('*** case_results2 size = 0');
	          	}          
			}
		}
		catch (QueryException e) {
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