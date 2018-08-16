@isTest

private class g_CustomCaseLookupController_Test {
	static testMethod void search_Test() {
		//Create Account test data
		g_CustomCaseLookupController lookup = new g_CustomCaseLookupController();
		Id [] fixedSearchResults = new Id[4];
		
		Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        insert acc;
        fixedSearchResults[0] = acc.Id;
	
		Contact con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333', Email = 'john.doer@somewhere.com');
		con.AccountId = acc.Id;  //account id 
		insert con; 
		fixedSearchResults[1] = con.Id;
		
		Case test_case1 = new Case(Subject = 'test_subject1', AccountID = acc.Id, ContactId = con.Id);
		insert test_case1;
		fixedSearchResults[2] = test_case1.Id;
		
		Case test_case2 = new Case(Subject = 'test_subject2', AccountID = acc.Id, ContactId = con.Id);
		insert test_case2;
		fixedSearchResults[3] = test_case2.Id; 
		
		Test.setFixedSearchResults(fixedSearchResults);
		
		PageReference pageRef = Page.g_CustomCaseLookup;	
	    pageRef.getParameters().put('lksrch','');
	    pageRef.getParameters().put('ixnId','2222222');
	    pageRef.getParameters().put('inServiceCloudConsole','false');
	    pageRef.getParameters().put('frm','');
	    pageRef.getParameters().put('txt','');
	    Test.setCurrentPage(pageRef);
				
		lookup.caseNumber = '12345678';
		lookup.Subject = 'test';    
		
		PageReference pr = lookup.search();
		System.assert(lookup.case_results.size() != 0);		
		
		lookup.caseNumber = '';
		lookup.Subject = 'subject444';   
	}  
	
	static testMethod void loadSearchResults_Test() {
		//Create Account test data
		g_CustomCaseLookupController lookup = new g_CustomCaseLookupController();
		Id [] fixedSearchResults = new Id[4];
		
		Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        insert acc;
        fixedSearchResults[0] = acc.Id;
	
		Contact con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333', Email = 'john.doer@somewhere.com');
		con.AccountId = acc.Id;  //account id 
		insert con; 
		fixedSearchResults[1] = con.Id;
		
		Case test_case1 = new Case(Subject = 'test_subject1', AccountID = acc.Id, ContactId = con.Id);
		insert test_case1;
		fixedSearchResults[2] = test_case1.Id;
		
		Case test_case2 = new Case(Subject = 'test_subject2', AccountID = acc.Id, ContactId = con.Id);
		insert test_case2;
		fixedSearchResults[3] = test_case2.Id; 
		
		Test.setFixedSearchResults(fixedSearchResults);	
					
		lookup.caseNumber = '12345678';
		lookup.Subject = 'test'; 
		
		lookup.searchString = '[{"Id":"0016A005TPTqQAO000","Contact.Name":"Jane Smith","Account.Phone":"5125", "CaseNumber":"12345678"}]';
		lookup.loadSearchResults(lookup.searchString);	
		System.assert(lookup.case_results.size() != 0);		
	}  
	
	static testMethod void performSearch_Test() {
		//Create Account test data
		g_CustomCaseLookupController lookup = new g_CustomCaseLookupController();
		
		Id [] fixedSearchResults = new Id[4];
		
		Account acc = new Account(Name = 'testAccount',Phone = '5555'); 
        insert acc;
        fixedSearchResults[0] = acc.Id;
	
		Contact con = new Contact(FirstName = 'John', LastName = 'Doer', Phone = '4444', MobilePhone = '3333', Email = 'john.doer@somewhere.com');
		con.AccountId = acc.Id;  //account id 
		insert con; 
		fixedSearchResults[1] = con.Id;
		
		Case test_case1 = new Case(Subject = 'test_subject1', AccountID = acc.Id, ContactId = con.Id);
		insert test_case1;
		fixedSearchResults[2] = test_case1.Id;
		
		Case test_case2 = new Case(Subject = 'test_subject2', AccountID = acc.Id, ContactId = con.Id);
		insert test_case2;
		fixedSearchResults[3] = test_case2.Id; 
		
		Test.setFixedSearchResults(fixedSearchResults);   		
				
		lookup.caseNumber = '12345678';
		lookup.Subject = 'test'; 
	
		lookup.performSearch();
		System.assert(lookup.case_results.size() != 0);		
		
		lookup.caseNumber = 'yyyyyyyyyyyyyyyyyyyyyy';
		lookup.Subject = ''; 
		lookup.performSearch();
		System.assert(lookup.case_results.size() == 0);	
		
		lookup.caseNumber = '';
		lookup.Subject = ''; 
		lookup.search();
		System.assert(lookup.case_results.size() == 0);			
	} 
	
	static testMethod void getFormTag_Test() {
		g_CustomCaseLookupController lookup = new g_CustomCaseLookupController();
		lookup.getFormTag();
	}
	
	static testMethod void getTextBox_Test() {
		g_CustomCaseLookupController lookup = new g_CustomCaseLookupController();
		lookup.getTextBox();
	}
}