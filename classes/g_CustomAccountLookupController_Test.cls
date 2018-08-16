@isTest

private class g_CustomAccountLookupController_Test {

    static testMethod void search_Test() {
       //Create Account test data
		g_CustomAccountLookupController lookup = new g_CustomAccountLookupController();
		
		//assigning Name only, creates business account
		Id [] fixedSearchResults= new Id[3];
		Account acc0 = new Account(Name = 'test Account0', Phone = '1111'); 
		insert acc0;		
        fixedSearchResults[0] = acc0.Id;    
		
		Account acc1 = new Account(Name = 'test Account1', Phone = '2222'); 
		insert acc1;
		fixedSearchResults[1] = acc1.Id;    
		
		Account acc2 = new Account(Name = 'test Account2', Phone = '3333'); 
		insert acc2;
		fixedSearchResults[2] = acc2.Id;  
		
		//This is necessary to create search results when querying by SOSL
		Test.setFixedSearchResults(fixedSearchResults);		
		
		lookup.Name = 'test';
		System.debug('*** Name = ' + lookup.Name );
		
		lookup.Phone = '1111';
		System.debug('*** Phone = ' + lookup.Phone );
		
		lookup.search();
		System.debug('*** results 1 - size = ' + lookup.Account_results.size());
		
		lookup.searchString = '[{"Id":"0016A000005TPTqQAO","Name":"JaneMyAmpersands SmithMyPlus","Phone":"5125"}]';
		

		PageReference pageRef = Page.g_CustomAccountLookup;	
	    pageRef.getParameters().put('lksrch','');
	    pageRef.getParameters().put('ixnId','1234567');
	    pageRef.getParameters().put('inServiceCloudConsole','false');
	    pageRef.getParameters().put('searchObjectType','Account');
	    pageRef.getParameters().put('lookupNumber','5555');
	    pageRef.getParameters().put('frm','');
	    pageRef.getParameters().put('txt','');
	    Test.setCurrentPage(pageRef);
		
	
		System.debug('*** results = ' + lookup.Account_results);
		System.assert(lookup.Account_results.size() != 0);
		
		PageReference pr = lookup.search();
		
		System.debug('*** results = ' + lookup.Account_results);
		System.assert(lookup.Account_results.size() != 0);	
		
		lookup.Name = '';
		lookup.Phone='6666'	;
		
		lookup.search();	
		System.assert(lookup.Account_results.size() != 0);
	}
	
	static testMethod void loadSearchResults_Test() {
       //Create Account test data
		g_CustomAccountLookupController lookup = new g_CustomAccountLookupController();
		//Create Account test data
		//assigning Name only, creates business account
		Id [] fixedSearchResults= new Id[3];
		Account acc0 = new Account(Name = 'test Account0', Phone = '1111'); 
		insert acc0;		
        fixedSearchResults[0] = acc0.Id;    
		
		Account acc1 = new Account(Name = 'test Account1', Phone = '2222'); 
		insert acc1;
		fixedSearchResults[1] = acc1.Id;    
		
		Account acc2 = new Account(Name = 'test Account2', Phone = '3333'); 
		insert acc2;
		fixedSearchResults[2] = acc2.Id;  	
		
		
		//This is necessary to create search results when querying by SOSL
		Test.setFixedSearchResults(fixedSearchResults);		
		
		lookup.searchString = '[{"Id":"0016A000005TPTqQAO","Name":"Jane Smith","Phone":"5125"}]';
		PageReference pr = lookup.search();
	
		System.debug('*** results = ' + lookup.Account_results);
		System.assert(lookup.Account_results.size() == 0);
	
		lookup.Phone='5555'	;
		lookup.search();	
		System.assert(lookup.Account_results.size() != 0);
		
		lookup.loadSearchResults(lookup.searchString);	
		System.assert(lookup.Account_results.size() != 0);	
	}
	
	static testMethod void performSearch_Test() {
        //Create Account test data
		g_CustomAccountLookupController lookup = new g_CustomAccountLookupController();
		
		//assigning Name only, creates business account
		Id [] fixedSearchResults= new Id[3];
		Account acc0 = new Account(Name = 'test Account0', Phone = '1111'); 
		insert acc0;		
        fixedSearchResults[0] = acc0.Id;    
		
		Account acc1 = new Account(Name = 'test Account1', Phone = '2222'); 
		insert acc1;
		fixedSearchResults[1] = acc1.Id;    
		
		Account acc2 = new Account(Name = 'test Account2', Phone = '3333'); 
		insert acc2;
		fixedSearchResults[2] = acc2.Id; 
		
		//This is necessary to create search results when querying by SOSL
		Test.setFixedSearchResults(fixedSearchResults);		
		
		lookup.Name = 'test Account1';
		lookup.Phone='3333'	;
		
		lookup.searchString = '[{"Id":"0016A000005TPTqQAO","Name":"Jane Smith","Phone":"5125"}]';
		System.debug('*** isPersonAccountEnabled = ' + lookup.isPersonAccountEnabled);

		lookup.performSearch();	
		System.assert(lookup.Account_results.size() != 0);	
	}
	
	static testMethod void searcha_Test() {
       //Create Account test data
		g_CustomAccountLookupController lookup = new g_CustomAccountLookupController();
		
		//assigning Name only, creates business account
		Id [] fixedSearchResults= new Id[3];
		Account acc0 = new Account(Name = 'test Account0', Phone = '1111'); 
		insert acc0;		
        fixedSearchResults[0] = acc0.Id;    
		
		Account acc1 = new Account(Name = 'test Account1', Phone = '2222'); 
		insert acc1;
		fixedSearchResults[1] = acc1.Id;    
		
		Account acc2 = new Account(Name = 'test Account2', Phone = '3333'); 
		insert acc2;
		fixedSearchResults[2] = acc2.Id; 
			
		//This is necessary to create search results when querying by SOSL
		Test.setFixedSearchResults(fixedSearchResults);		
		
		lookup.Name = 'test';
		lookup.Phone='5555'	;
		
		lookup.searchString = '[{"Id":"0016A000005TPTqQAO","Name":"Jane Smith","Phone":"5125"}]';
		PageReference pr = lookup.search();
		
		System.debug('*** results = ' + lookup.Account_results);
		System.assert(lookup.Account_results.size() != 0);
			
		lookup.loadSearchResults(lookup.searchString);	
		System.assert(lookup.Account_results.size() != 0);
		
		lookup.performSearch();	
		System.assert(lookup.Account_results.size() != 0);	
		System.debug('*** results = ' + lookup.Account_results);

		
		lookup.searchString = '';
		lookup.Name = 'test Account2';
		lookup.Phone='6666'	;
		pr = lookup.search();	
		System.assert(lookup.Account_results.size() != 0);
	}
	static testMethod void getFormTag_Test() {
		g_CustomAccountLookupController lookup = new g_CustomAccountLookupController();
		lookup.getFormTag();
	}
	
	static testMethod void getTextBox_Test() {
		g_CustomAccountLookupController lookup = new g_CustomAccountLookupController();
		lookup.getTextBox();
	}
	
	static testMethod void test_getAccount(){
		//Create Account test data
		g_CustomAccountLookupController lookup = new g_CustomAccountLookupController();
		
		//assigning Name only, creates business account
		Id [] fixedSearchResults= new Id[3];
		Account acc0 = new Account(Name = 'test Account0', Phone = '1111'); 
		insert acc0;		
        fixedSearchResults[0] = acc0.Id;    
		
		Account acc1 = new Account(Name = 'test Account1', Phone = '2222'); 
		insert acc1;
		fixedSearchResults[1] = acc1.Id;    
		
		Account acc2 = new Account(Name = 'test Account2', Phone = '3333'); 
		insert acc2;
		fixedSearchResults[2] = acc2.Id;
		
		//This is necessary to create search results when querying by SOSL
		Test.setFixedSearchResults(fixedSearchResults);		
		
		lookup.Name = 'test';
		
		PageReference pageRef = Page.g_CustomAccountLookup;	
		
		lookup.search();	
		System.assert(lookup.Account_results.size() != 0);
		List<g_AccountWrapper> myresult = null;   
		if (lookup.Account_results.size() != 0) {
        	Set<Account> myAccountSet = new Set<Account>();
            myresult = new List<g_AccountWrapper>();
            myAccountSet.addAll(lookup.Account_results);
            for (Account c : myAccountSet) {
            	g_AccountWrapper gc = new g_AccountWrapper(c);
            	if (myresult.size() > 0){
            		Account a = gc.getAccount();
            		gc.compareto(myresult[0]);
            	}
            	myresult.add(gc);
            }          
        }		
  }
		

}