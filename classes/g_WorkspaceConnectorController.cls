global class g_WorkspaceConnectorController {
    
	public static Boolean personAccountsEnabled = Schema.sObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
	
	@RemoteAction
	global static String IsPersonAccountEnabled()
	{
		if (personAccountsEnabled == true)
			return 'true';
		return 'false';	
	}
 
    @RemoteAction
    global static String findContactFromcase(String caseId)
    {
        system.debug('findContactFromcase using  ' + caseId);
        if (caseId == null || caseId == '')
        	return null;       
        String query;
        List<Case> cases = null;
        List<List<SObject>> cobjects = null;
        try {
        	//List<Case> cases = [SELECT ContactId FROM Case WHERE Id= :caseId];   
        	query = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Case(ContactId WHERE Id = \'' + caseId + '\')';
        	cobjects = search.query(query);
        	if (cobjects != null && !cobjects.isEmpty())
        	{
	        	cases = ((List<Case>)cobjects[0]);
         		if(cases != null && !cases.isEmpty()) {
	               // return the first case found (should only be one)                            
	               for (Case c : cases) {
	                   return c.ContactId;
	               } 
	           	}
        	}
        } catch(QueryException e){
            return null; 
        }
        return null; 
    }
  

    @RemoteAction
    global static Object findObjectFromANI(String ANI)
    {
        system.debug('*** findObjectFromANIfor '+ANI); 
        Integer listSize = 0; 
        //List<SObject> objList;
        SObject obj_found = null;     
        try{
            
            List<List<SObject>> aobjects = [FIND :ANI IN PHONE FIELDS RETURNING Account];
            if (!aobjects.isEmpty()){
              List<Account> accounts = ((List<Account>)aobjects[0]);
              listSize = accounts.size();
              system.debug('*** accounts listSize = ' + listSize);
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize != 0){
                  for (List<SObject> objList : aobjects)
                      for (SObject aobj : objList){
                        obj_found = aobj;
                        system.debug('*** findObjectFromANI account = '+ obj_found.Id);
                  } 
              }
            }  

            List<List<SObject>> cobjects = [FIND :ANI IN PHONE FIELDS RETURNING Contact];
            if (!cobjects.isEmpty()){
              List<Contact> contacts= ((List<Contact>)cobjects[0]);
              listSize = contacts.size();
              system.debug('*** contacts listSize = ' + listSize);
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize == 1 && obj_found != null){
                    return 'multiple found';
              }
              if(listSize != 0){
                  for (List<SObject> objList : cobjects)
                      for (SObject cobj : objList){
                        obj_found = cobj;
                        system.debug('*** findObjectFromANI contact = '+ obj_found.Id);
                      } 
                  }
            }                     

            List<List<SObject>> lobjects = [FIND :ANI IN PHONE FIELDS RETURNING Lead];
            if (!lobjects.isEmpty()){
              List<Lead> leads= ((List<Lead>)lobjects[0]);
              listSize = leads.size();
              system.debug('*** leads listSize = ' + listSize);              
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize == 1 && obj_found != null){
                    return 'multiple found';
              }
              if(listSize != 0){                            
                  for (List<SObject> objList : lobjects)
                      for (SObject lobj: objList){
                        obj_found = lobj;
                        system.debug('*** findObjectFromANI lead= '+obj_found.Id);
                      } 
              }
            }
            
            if(obj_found != null)              
                return obj_found; 
            return 'not found';

        }
        catch(QueryException e){
            return 'not found'; 
        }        
    }
    
    @RemoteAction
    global static Object findObjectFromANIByType(String ANI, String searchObjectType)
    {
        system.debug('*** findObjectFromANIByType for ANI - '+ ANI + ', searchObjectType - ' + searchObjectType);
        Integer listSize = 0;      
        String query;   
        try{        	
        	List<List<SObject>> aobjects = null;        	
            if (personAccountsEnabled == false){
	        	query='FIND :ANI IN PHONE FIELDS RETURNING Account(Id, Name,Phone)';  
            }/*
            else{
            	if (searchObjectType == 'personaccount'){
            		query='FIND :ANI IN PHONE FIELDS RETURNING Account(Id, Name, Phone, IsPersonAccount, PersonEmail where IsPersonAccount = true)'; 
            	}
            	else{
            		query='FIND :ANI IN PHONE FIELDS RETURNING Account(Id, Name, Phone, IsPersonAccount, PersonEmail)'; 
            	}            	
            }*/
            aobjects = search.query(query);
            
            if (aobjects != null && !aobjects.isEmpty()){
            	List<Account> accounts = ((List<Account>)aobjects[0]);
              	listSize = accounts.size();
              	system.debug('*** findObjectFromANIByType accounts listSize = ' + listSize);
              	if(listSize != 0){              	
                    return accounts;
              	}
            }            
            return 'not found';
        }
        catch(Exception e){
            return 'not found'; 
        }        
    }
    
    
    @RemoteAction
    global static Object findContactFromANI(String ANI)
    {
    	system.debug('*** findContactFromANI '+ANI);    
        if (ANI == null || ANI=='')
    		return null;   
        try{                                  
            List<List<SObject>> cobjects = [FIND :ANI IN PHONE FIELDS RETURNING Contact];
            Integer listSize = cobjects.size();
            system.debug('*** listSize = ' + listSize);
            if(listSize > 1){
                    return 'multiple found'; //not expected
            }
            if (!cobjects.isEmpty()){
              List<Contact> contacts = ((List<Contact>)cobjects[0]);
              listSize = contacts.size();
              system.debug('*** contacts listSize = ' + listSize);
              if(listSize > 1){
                    return 'multiple found';
              }
              if(listSize == 0){
                  return 'not found';
              }
              for (List<SObject> objList : cobjects)
                  for (SObject cobj : objList){
                    system.debug('*** findContactFromANI contact = '+ cobj.Id);
                    return cobj;
                  } 
            }
        }
        catch(Exception e){
            return null; 
        } 
        return null;        
    }

    @RemoteAction
    global static Object findContactFromEmailAddress(String address)
    {
		system.debug('*** findObjectFromEmailAddress' + address);   
		if (address == null || address=='')
    		return null; 
    	String query;   
    	List<Contact> contacts = null;
    	List<List<SObject>> cobjects = null;   
		try {
		    //List<Contact> objects = [select name from contact where email= :address ];
		    query = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Contact(Name WHERE email = \'' + address + '\')';
        	cobjects = search.query(query);
		    if (cobjects != null && !cobjects.isEmpty())
        	{
        		contacts = ((List<Contact>)cobjects[0]);			    
			    if(contacts != null && !contacts.isEmpty()) {
			    	Integer listSize = contacts.size();
			    	if (listSize == 1){
						for (Contact obj : contacts) {
						    system.debug('*** findContactFromEmailAddress contact = '+ obj.Name);
						    return obj;
						}
			    	}
			    }      
        	}
		}
		catch(QueryException e){
		    return null; 
		}  
		return null;       
    }
    
    @RemoteAction
    global static Object findContactFromChatAddress(String theName)
    {
        system.debug('*** findObjectFromChatAddress' + theName); 
        if (theName == null || theName=='')
    		return null; 
    	String query;   
    	List<Contact> contacts = null;
    	List<List<SObject>> cobjects = null;  
        try {
            //List<Contact> objects = [select name from contact where name= :theName];
            query = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Contact(Name WHERE name = \'' + theName + '\')';
        	cobjects = search.query(query);
        	if (cobjects != null && !cobjects.isEmpty())
        	{
        		contacts = ((List<Contact>)cobjects[0]);			    
			    if(contacts != null && !contacts.isEmpty()) {
			    	Integer listSize = contacts.size();
			    	if (listSize == 1){
						for (Contact obj : contacts) {
						    system.debug('*** findContactFromChatAddress contact = '+ obj.Name);
						    return obj;
						}
			    	}
			    }      
        	}
        }
        catch(QueryException e){
            return null; 
        } 
        return null; 
    }

        
    @RemoteAction
    global static Object findContactFromWorkItemAddress(String theName)
    {
        system.debug('*** findContactFromWorkItemAddress' + theName);  
        if (theName == null || theName=='')
    		return null; 
    	String query;   
    	List<Contact> contacts = null;
    	List<List<SObject>> cobjects = null;       
        try {
        	query = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Contact(Name WHERE name = \'' + theName + '\')';
        	cobjects = search.query(query);
        	if (cobjects != null && !cobjects.isEmpty())
        	{
        		contacts = ((List<Contact>)cobjects[0]);			    
			    if(contacts != null && !contacts.isEmpty()) {
			    	Integer listSize = contacts.size();
			    	if (listSize == 1){
						for (Contact obj : contacts) {
						    system.debug('*** findContactFromWorkItemAddress contact = '+ obj.Name);
						    return obj;
						}
			    	}
			    }      
        	}
        }
        catch(QueryException e){
            return null; 
        }
        return null;         
    }    


    @RemoteAction
    global static Object findContactFromOpenMediaAddress(String theName)
    {
        system.debug('*** findContactFromOpenMediaAddress' + theName); 
        if (theName == null || theName=='')
    		return null; 
    	String query;   
    	List<Contact> contacts = null;
    	List<List<SObject>> cobjects = null;        
        try {
        	query = 'FIND \'* OR *\' IN ALL FIELDS RETURNING Contact(Name WHERE name = \'' + theName + '\')';
        	cobjects = search.query(query);
        	if (cobjects != null && !cobjects.isEmpty())
        	{
        		contacts = ((List<Contact>)cobjects[0]);			    
			    if(contacts != null && !contacts.isEmpty()) {
			    	Integer listSize = contacts.size();
			    	if (listSize == 1){
						for (Contact obj : contacts) {
						    system.debug('*** findContactFromOpenMediaAddress contact = '+ obj.Name);
						    return obj;
						}
			    	}
			    }      
        	}            
            return null; 
        }
        catch(QueryException e){
            return null; 
        } 
        return null;        
    }
    
        
    @RemoteAction
    global static Object findAccountFromOpenMediaAddress(String theName, String searchObjectType)
    {
        system.debug('*** findAccountFromOpenMediaAddress' + theName + ', searchObjectType - ' + searchObjectType);
        return findObjectByType('Name', theName, searchObjectType);
    }
 
 
 
 	@RemoteAction 
 	global static String createActivity(Map<String,String> activityMap, String searchObjectType){
        system.debug('*** createActivity' );
        String result = 'not found';
                        
        String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
        String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
        String leadPrefix = Schema.SObjectType.Lead.getKeyPrefix(); 
        String casePrefix = Schema.SObjectType.Case.getKeyPrefix(); 
        String taskPrefix = Schema.SObjectType.Task.getKeyPrefix(); 
        
        system.debug('*** createActivity accountPrefix = ' + accountPrefix);
        system.debug('*** createActivity contactPrefix = ' + contactPrefix);
        system.debug('*** createActivity leadPrefix = ' + leadPrefix);
        system.debug('*** createActivity casePrefix = ' + casePrefix);
        system.debug('*** createActivity taskPrefix = ' + taskPrefix);

        system.debug('*** duration = ' + activityMap.get('Call Duration'));
        String callType = activityMap.get('IXN Type');
        String mediaType = activityMap.get('Media Type');
        String d = activityMap.get('DATE');
        system.debug('*** d   '+ d);
        if(d == '0001-01-01 00:00:00')
        	d = '';
        String subject = callType + ' ' + mediaType + ' ' + d; 
        String objectToUse = '';
        String duration = activityMap.get('Call Duration');
        Integer durationInSecs = Integer.valueOf(duration);
                
        DateTime startDate=null;
        try{
        	startDate = (activityMap.get('StartDate')=='' && activityMap.get('StartDate')==null) ? null : dateTime.valueOf(activityMap.get('StartDate'));
        }catch(Exception e) {
        	system.debug(e); 
        }
        system.debug('*** start date = ' + startDate);

        DateTime endDate=null;
        try{
        	endDate = (activityMap.get('EndDate')=='' && activityMap.get('EndDate')==null) ? null : dateTime.valueOf(activityMap.get('EndDate'));
        }catch(Exception e) {
        	system.debug(e); 
        }
        
        system.debug('*** end date = ' + endDate);
        
        if(activityMap.get('sfdc Object Id')!= ''){
                system.debug('*** createActivity sfdc Object Id = ' + activityMap.get('sfdc Object Id'));
                objectToUse = activityMap.get('sfdc Object Id');
        }
        else
        	system.debug('*** createActivity sfdc Object Id is empty ' );
       
        system.debug('*** createActivity for objectToUse ' + objectToUse);      
        
        String prefix = '';
        if(objectToUse != '')
            prefix = objectToUse.substring(0, 3);
        system.debug('*** prefix = '+prefix);
        
        Task t = new Task (
	          Type = 'Call',
	          Status = 'Completed',
	          Subject = subject,
	          CallDurationInSeconds = durationInSecs,            
	          //Start__c = startDate,  //If we want to use the start of the interaction
	          //End__c = endDate,  //If we want to use the end of the interaction
	          Description = activityMap.get('Comments'),
	          CallDisposition = activityMap.get('Disposition'),
	          CallObject = activityMap.get('GenesysId')
	        );  
          
		try{
	        if(prefix == accountPrefix || prefix == casePrefix){
	          	system.debug('*** create task for account or case as the sfdcobjectId');
	           	system.debug('*** create task Related to - WhatId = ' + objectToUse);
	          	t.put('WhatId',objectToUse);
	        }
	        else{
	        	if(prefix == contactPrefix || prefix == leadPrefix){
	        		system.debug('*** create task for contact or lead as the sfdcobjectId');
	           		system.debug('*** create task Name - WhoId = ' + objectToUse);
	          		t.put('WhoId',objectToUse);
	        	}
	        }
	              
	        if(prefix == contactPrefix)
	        {
	        	//Following SOQL should not be causing issues with encryption	
	          	Contact contact= [SELECT AccountId, Id FROM Contact WHERE Id= :objectToUse];
	          	system.debug('*** create task for contact');
	          	system.debug('*** create task Related to - WhatId for conact.AccountId= ' + contact.AccountId);
	          	t.put('WhatId',contact.AccountId); 
	        }
	        
	        if (prefix == casePrefix && personAccountsEnabled == false)
	        {
	        	String contactId = findContactFromcase(objectToUse);
	        	if (contactId != null && contactId != '')
	        	{
	        		system.debug('*** create task Name - WhoId = ' + contactId);
	        		t.put('WhoId',contactId);
	        	}        		
	        }
	        
	        String caseId = activityMap.get('sfdcCaseId');
	        if(caseId != '')
	        {
	        	system.debug('*** case Id is exists');
	        	system.debug('*** create task Related to - WhatId is assigned as caseId = ' + caseId);
	        	t.put('WhatId',caseId);
	        }                  
	        String mySFDCfield = '';
	        String mySFDCvalue = '';
	        for (Integer index=1; index<=5; index++){
	        	if (activityMap.get('SFDC'+index+'field') != '' && (activityMap.get('SFDC'+index+'field') != null) && activityMap.get('SFDC'+index+'value') != '' && activityMap.get('SFDC'+index+'value') != null)
		        {
		            mySFDCfield = activityMap.get('SFDC'+index+'field');
		            mySFDCvalue = activityMap.get('SFDC'+index+'value');
		            system.debug('*** mySFDCfield ' + mySFDCfield + ' -- mySFDCvalue ' + mySFDCvalue);
		            t.put(mySFDCfield,mySFDCvalue);
		        }
	        }  
                            
        	insert t;
        }
        catch(QueryException e){
        	return result; 
        }
        system.debug('*** Task id = '  +t.Id);
        result = t.Id;
        return result;
     }


	//search for an activity by Genesys Interaction Id
 	@RemoteAction
    global static String findActivity(String connID)
    {
        system.debug('findActivity using  ' + connID);
        String returnValue = null; 
        if(connID == null)
        	return  returnValue;     
        try {
    		system.debug('findActivity using  current userId = ' + UserInfo.getUserId());
    		//For transfer/conference calls, each agent involved can create activities where CallObjects are the same but they are 
        	//assigned to differentusers(agents).  To see if a new activity should be create, make sure no activity with the same connId and assignee
        	//already exists.
        	
        	//The following SOQL should not be conflicting with encryption
           	List<Task> tasks = [SELECT Id FROM Task WHERE CallObject= :connID AND OwnerId = :UserInfo.getUserId()];            
           	if(tasks != null && !tasks.isEmpty()) {
           		system.debug('findActivity tasks size=  ' + tasks.size());
               	// return the first case found (should only be one)                            
               	for (Task t : tasks) {
               		 system.debug('findActivity return task Id=  ' + t.Id);
                   return t.Id;
               	} 
           }
        } catch(QueryException e){
        	system.debug('findActivity exception occurrred ' + e.getMessage());
            return returnValue; 
        }
        return returnValue; 
    }
    
    // Update activity 
    @RemoteAction
    global static String updateActivity(String taskID,Map<String,String> activityMap)
    {
        system.debug('updateActivity using  taskID = ' + taskID);
        String returnValue = 'ERROR task Id ' + taskID +' not found';
        if(taskID == null)
        	return  returnValue; 
      	 String accountPrefix = Schema.SObjectType.Account.getKeyPrefix();
        String contactPrefix = Schema.SObjectType.Contact.getKeyPrefix();
        String leadPrefix = Schema.SObjectType.Lead.getKeyPrefix(); 
        String casePrefix = Schema.SObjectType.Case.getKeyPrefix(); 
        String taskPrefix = Schema.SObjectType.Task.getKeyPrefix(); 
        
        system.debug('*** updateActivity accountPrefix = ' + accountPrefix);
        system.debug('*** updateActivity contactPrefix = ' + contactPrefix);
        system.debug('*** updateActivity leadPrefix = ' + leadPrefix);
        system.debug('*** updateActivity casePrefix = ' + casePrefix);
        system.debug('*** updateActivity taskPrefix = ' + taskPrefix);

        
        try {
           Task myTask = [SELECT Id, Description FROM Task WHERE Id = :taskID];            
           if(myTask != null) {
           		//Subject, Comments, Call Result, Call Duration, Name, RelatedTo
           		String callType = activityMap.get('IXN Type');
				String mediaType = activityMap.get('Media Type');
        		String d = activityMap.get('DATE');
        		system.debug('*** d   '+ d);
        		if(d == '0001-01-01 00:00:00')
        			d = '';
        		String subject = callType + ' ' + mediaType + ' ' + d;
        		myTask.put('Subject',subject);
        		String comments = activityMap.get('Comments');
        		//String comments = myTask.Description;
        		//comments = comments + '\n' + activityMap.get('Comments');
        		myTask.put('Description',comments);
        		String callDisposition = activityMap.get('Disposition');
        		myTask.put('CallDisposition',callDisposition);
        		String duration = activityMap.get('Call Duration');
        		Integer durationInSecs = Integer.valueOf(duration);
        		myTask.put('CallDurationInSeconds',durationInSecs);
        		
        		String objectToUse = '';
        		if(activityMap.get('sfdc Object Id')!= ''){
                	system.debug('*** createActivity sfdc Object Id = ' + activityMap.get('sfdc Object Id'));
                	objectToUse = activityMap.get('sfdc Object Id');
        		}
        		String prefix = '';
        		if(objectToUse != '')
           			prefix = objectToUse.substring(0, 3);
        		system.debug('*** prefix = '+prefix);
        		if(prefix == accountPrefix || prefix == casePrefix){
          			system.debug('*** update task for account or case');
          			myTask.put('WhatId',objectToUse);
        		}
        		else{
        			if(prefix == contactPrefix || prefix == leadPrefix){
	        			system.debug('*** Update task for contact or lead as the sfdcobjectId');
	           			system.debug('*** Update task Name - WhoId = ' + objectToUse);
	          			myTask.put('WhoId',objectToUse);
        			}
        		}
              
		        if(prefix == contactPrefix)
		        {
		          Contact contact= [SELECT AccountId, Id FROM Contact WHERE Id= :objectToUse];
		          system.debug('*** create task for contact');
		          myTask.put('WhatId',contact.AccountId); 
		        }
		        
		        if (prefix == casePrefix && personAccountsEnabled == false)
				{
					String contactId = findContactFromcase(objectToUse);
					if (contactId != null && contactId != '')
					{
						system.debug('*** create task Name - WhoId = ' + contactId);
						myTask.put('WhoId',contactId);
					}        		
				}
		        
		        String caseId = activityMap.get('sfdcCaseId');
		        if(caseId != '')
		        	myTask.put('WhatId',caseId);

           		update myTask;
				returnValue = 'success';

           }
        } catch(DmlException e){
        	System.debug('*** An unexpected error has occurred: ' + e.getMessage());
            returnValue = 'ERROR An unexpected error has occurred: ' + e.getMessage();
        }
        return returnValue; 
    }    	
    
     
     
    @RemoteAction      
    global static String createCase(Map<String,String> caseMap)
    {        
        system.debug('*** createCase');
        String result = 'case not created';
        String ixnType = caseMap.get('IXN Type');
        String mediaType = caseMap.get('Media Type');
        String subject = ixnType + ' ' + mediaType + ' ' + caseMap.get('DATE'); 
		
        Case c = new Case (
        	Subject = subject,
        	Priority = 'Medium',
        	Origin = ixnType       	
        );   
        
        try{                        
                insert c;
        }
        catch(QueryException e){
                 return result; 
        }
        system.debug('*** Case id = '  +c.Id);
        result = c.Id;
        return result;
    }  
      
    @RemoteAction      
	global static String addAttachment(String objectId, String descriptionText, String nameText, String mimeType, Blob attachmentBody, String attachmentId)
    {        
        system.debug('***addAttachment objectId: ' + objectId + ' descriptionText: ' + descriptionText + ' nameText: ' + nameText + ' mimeType: ' + mimeType + 'attachmentId: '  + attachmentId);
        try{           
 
   			    if(attachmentBody != null) {
                    Attachment att = getAttachment(attachmentId);
                    
                    String newBody = '';
                    if(att.Body != null) {
                        newBody = EncodingUtil.base64Encode(att.Body);
                    }
                    
                    String newAttachmentBody = EncodingUtil.base64Encode(attachmentBody);                    
                    
                    newBody += newAttachmentBody;
                    
                    att.Body = EncodingUtil.base64Decode(newBody);
                    //att.Body = Blob.valueOf(newBody);                    
                    
                    if(attachmentId == null) {
                    	system.debug('*** First time through');
                        att.Name = nameText;
                        att.parentId = objectId;
                    }
                    upsert att;
                    return att.Id;
                } else {
                    return 'error';
                }
        }
        catch(QueryException e){
            system.debug('*** addAttachment error ' + e);
            return 'error';
        }
    }
    
	private static Attachment getAttachment(String attId) 
	{
        list<Attachment> attachments = [SELECT Id, Body
                                        FROM Attachment 
                                        WHERE Id =: attId];
        if(attachments.isEmpty()) {
            Attachment a = new Attachment();
            return a;
        } else {
            return attachments[0];
        }
    }

   @RemoteAction
   global static Object findCaseObject(String searchFieldName, String searchFieldValue){
        system.debug('*** findCaseObject: searchFieldName - ' + searchFieldName +', searchFieldValue - ' + searchFieldValue);
        Object result = null;
        if(searchFieldName == '' || searchFieldValue == '')
			return result;
			
		List<List<SObject>> cObjects = null;
        String query;
        String lowerFieldName = searchFieldName.toLowerCase();
        try{
        	
        	//query = 'SELECT Id, ContactId, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate FROM Case WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\'';
        	if (lowerFieldName != 'contactid' && lowerFieldName != 'casenumber' && lowerFieldName != 'subject' && 
        		lowerFieldName != 'account.name' && lowerFieldName != 'contact.name' && lowerFieldName != 'createddate')
	           	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Case(Id, ContactId, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate, ' + searchFieldName + ' WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\')';
	        else
	        	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Case(Id, ContactId, CaseNumber, Subject, Account.Name, Contact.Name, CreatedDate WHERE ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
	          		
           	system.debug('*** Case query = ' + query);   
           	
           	cObjects = search.query(query);
			if (cObjects != null){          
	           	List<Case> all_cases = ((List<Case>)cObjects[0]);		          
           		if (all_cases != null && !all_cases.isEmpty()){ 
           			Integer listSize = all_cases.size();
	        		system.debug('*** Case Count = ' + listSize);
	        		result = all_cases;
	        	}
			}             
        }
        catch(QueryException e){
        	system.debug('*** QueryException ' + e); 
        }        
        return result;
    } 
    
    @RemoteAction
    global static Object findCaseObjectMapSearch(Map<String,String> searchMap, Boolean searchAllFields){
       system.debug('*** findCaseObjectMapSearch:  searchAllFields - ' + searchAllFields);	
        Integer totalCount = 0;
        List<Case> all_cases = new List<Case>();
        if (searchMap != null && searchMap.size() > 0){
	    	for (String mySFDCfield: searchMap.keySet())
	        {        	
	        	if (mySFDCfield != '' && mySFDCfield != null){
	        		String mySFDCvalue = searchMap.get(mySFDCfield); 
		        	if (mySFDCvalue != '' && mySFDCvalue != null)
		        	{
		        		system.debug('*** findCaseObjectMapSearch: searchFieldName - ' + mySFDCfield +', searchFieldValue - ' + mySFDCvalue );
		        		Object resultObj = findCaseObject(mySFDCfield,mySFDCvalue);
		        		if (resultObj != null)
		        		{
		        			List<Case> result = (List<Case>)resultObj;
		        			Integer listSize = result.size();
		        			system.debug('*** findCaseObjectMapSearch:  result size= ' + listSize);		        			
				          	if (listSize > 0){
					          	for (Case r: result){
					          		Boolean alreadyAdded = false;
					          		for(Case c: all_cases){
					          			if (r.Id == c.Id){
					          				alreadyAdded = true;
					          				break;
					          			}
					          		}
					          		if (alreadyAdded == false){
					          			all_cases.add(r);
					          		}
					          	}				          	    
			        			// If search till first result, stop the search 	  
			        			if  (searchAllFields == false)
			        			{
		        					system.debug('*** findCaseObjectMapSearch:  Found some result, stop the search');  
		        					break;    
		        				} 
				          	}    			
		        		}			         
		        	}
		        	else
		        		system.debug('*** findCaseObjectMapSearch: go on to next check');
	        	}
	        } //for loop
	        system.debug('*** findCaseObjectMapSearch: search completed');     
	        if (all_cases != null)
	        	system.debug('*** findCaseObjectMapSearch: all_cases.size() :' + all_cases.size()); 
	        return all_cases; 
        } 
        return null;   
    } 
    
    @RemoteAction
    global static Object findObject(String searchFieldName, String searchFieldValue){
        system.debug('*** findObject: searchFieldName - ' + searchFieldName +', searchFieldValue - ' + searchFieldValue);
        Object result = null;
        Integer aListSize = 0, cListSize = 0, lListSize = 0;
        List<Account> accounts = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<Lead> leads = new List<Lead>();
        
        List<List<SObject>> cObjects = null;
        List<List<SObject>> aObjects = null;
        List<List<SObject>> lObjects = null; 
        
        searchFieldName = searchFieldName.removeEnd('\"').removeStart('\"');
        searchFieldValue = searchFieldValue.removeEnd('\"').removeStart('\"');
        
        if(searchFieldName == '' || searchFieldValue == '')
        	return result;
        String query;
        String lowerFieldName = searchFieldName.toLowerCase();
        	
        //check account
        try{
        	if (lowerFieldName != 'name' && lowerFieldName != 'phone' && lowerFieldName != 'account.name' && lowerFieldName != 'account.phone')
	           	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name,Phone,' + searchFieldName + ' WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\')';
	        else
	        	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name,Phone' + ' WHERE ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
	          		
           	system.debug('*** Account query = ' + query);            
           	aObjects = search.query(query);
			if (aObjects != null){          
	           	accounts =((List<Account>)aObjects[0]);		          
           	}    
          	
            if (accounts != null){
                aListSize = accounts.size();
                if(aListSize == 1){                   
                	system.debug('*** Found one account match');   
                    system.debug('***  Id = ' + accounts[0].Id);
                    system.debug('***  Name = '+ accounts[0].Name);
                    system.debug('*** Phone = '+ accounts[0].Phone);               
                }
            }
        }
        catch(Exception e){
        	system.debug('*** Exception account search' + e);
        }
        
        //check contact
        try{
        	
			if (lowerFieldName != 'name' && lowerFieldName != 'phone' && lowerFieldName != 'contact.name' && lowerFieldName != 'contact.phone')
	           	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Contact(Id, Name,Phone,' + searchFieldName + ' WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\')';
	        else
	        	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Contact(Id, Name,Phone' + ' WHERE ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
	           		
           	system.debug('*** Contact query = ' + query);            
           	cObjects = search.query(query);
			if (cObjects != null){          
	           	contacts =((List<Contact>)cObjects[0]);		          
           	}         
	        if (contacts != null){
	            cListSize = contacts.size();
	            if(cListSize == 1){	           
	            	system.debug('*** Found one contact match');  	             
	                system.debug('***  Id = ' + contacts[0].Id);
	                system.debug('***  Name = '+ contacts[0].Name);
	                system.debug('*** Phone = '+ contacts[0].Phone);	
	            }
	        }
        }
        catch(Exception e){
        	system.debug('*** Exception ' + e); 
        }
        
        //check lead
        try{
        	if (lowerFieldName != 'name' && lowerFieldName != 'phone' && lowerFieldName != 'lead.name' && lowerFieldName != 'lead.phone')
	           	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Lead(Id, Name,Phone,' + searchFieldName + ' WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\')';
	        else
	        	query='FIND \'* OR *\' IN ALL FIELDS RETURNING Lead(Id, Name,Phone' + ' WHERE ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
	          
	        system.debug('*** Lead query = ' + query);            
           	lObjects = search.query(query);
			if (lObjects != null){          
	           	leads =((List<Lead>)lObjects[0]);		          
           	}
	        if (leads != null){
	            lListSize = leads.size();
	            if(lListSize == 1){
	            	system.debug('*** Found one lead match');  
	                system.debug('***  Id = ' + leads[0].Id);
	                system.debug('***  Name = '+ leads[0].Name);
	                system.debug('*** Phone = '+ leads[0].Phone);	                
	            }
	        }
        }
        catch(Exception e){
        	system.debug('*** Exception ' + e); 
        }
        
        
        Integer total = aListSize + cListSize + lListSize;
        system.debug('*** findObject total search result(s) = ' + total);
        
        if (total == 0)
        	return 'not found';
        else if (total == 1){
        	if (aListSize == 1)
        		return accounts[0];
        	else if (cListSize == 1)
        		return contacts[0];
        	else
        		return leads[0];
        }
        else 
        	return 'multiple found';   
    }  
    
    
    //Overload function using Map of field/field values
    @RemoteAction
    global static Object findObjectMapSearch(Map<String,String> searchMap, Boolean searchAllFields ){
        Object result = null;
        Integer totalCount = 0;
    	for (String mySFDCfield: searchMap.keySet())
        {
        	if (mySFDCfield != '' && mySFDCfield != null)
        	{
        		String mySFDCvalue = searchMap.get(mySFDCfield); 
	        	if (mySFDCvalue != '' && mySFDCvalue != null)
	        	{
	        		system.debug('*** findObjectMapSearch: mySFDCfield - ' + mySFDCfield +', mySFDCvalue - ' + mySFDCvalue);
	        		result = findObject(mySFDCfield,mySFDCvalue);
	        		if (result != null && result != 'not found')
	        		{
	        			if (result == 'multiple found')
	        				return result;
	        			else //only one found for the current field and field-value
	        			{
	        				if  (searchAllFields == false)
	        					break;
	        				else{
	        					totalCount ++;
	        					if (totalCount > 1)
	        						return 'multiple found';
	        				}
	        			}     			
	        		}		         
	        	}
	        	else
	        		system.debug('*** findObjectMapSearch go on to next check');
	        	
        	}
        	
        }
        return result;     
        
    }  
    
    
    @RemoteAction
    global static Object findObjectByType(String searchFieldName, String searchFieldValue, String searchObjectType){
    	system.debug('*** findObjectByType: searchFieldName - ' + searchFieldName +', searchFieldValue - ' + searchFieldValue +', searchObjectType - ' + searchObjectType);
 		
    	List<Account> account_results = new List<Account>();
    	
        if(searchFieldName == '' || searchFieldValue == '')
        	return account_results;     
       
       	String lowerFieldName = searchFieldName.toLowerCase();
        String query;
        if (personAccountsEnabled == false)
        {
	        try{
	        	if (lowerFieldName != 'name' && lowerFieldName != 'phone' && lowerFieldName != 'account.name' && lowerFieldName != 'account.phone')
	           		query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name,Phone,' + searchFieldName + ' WHERE ' + searchFieldName  + ' = \'' + searchFieldValue + '\')';
	           	else
	           		query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name,Phone' + ' WHERE ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
	           		
	           	system.debug('*** Account query = ' + query);            
	           	List<List<sObject>> searchList = search.query(query);
				if (searchList != null){          
		           	List<Account> accounts =((List<Account>)searchList[0]);
		            if (!accounts.isEmpty()){
		                Integer listSize = accounts.size();
		                system.debug('*** Account Count = ' + listSize);
		                if(listSize != 0){					
			            	account_results.addAll(accounts);
			            	return  account_results; //RETURN IF ANY RESULTS CAME
				        }
		            }
	           	}
	        }
	        catch(QueryException e){
	        	system.debug('*** QueryException ' + e);        	
	        }
        }  
        /*else
        {
	        try{	        	
	        	if (searchObjectType == 'personaccount'){	
	           		if(lowerFieldName != 'name' && lowerFieldName != 'phone' && lowerFieldName != 'account.name' && lowerFieldName != 'account.phone' && lowerFieldName != 'ispersonaccount' && lowerFieldName != 'personemail'){
		           		query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name, Phone, IsPersonAccount, PersonEmail,'+searchFieldName+' WHERE IsPersonAccount = true AND ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
	           		}  
		           	else{
		           		query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name, Phone, , IsPersonAccount, PersonEmail WHERE IsPersonAccount = true AND ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
		           	}
	        	}
	        	else{ //Business and Person Account both
	       			if(lowerFieldName != 'name' && lowerFieldName != 'phone' && lowerFieldName != 'account.name' && lowerFieldName != 'account.phone' && lowerFieldName != 'ispersonaccount' && lowerFieldName != 'personemail')
		           		query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name,Phone, IsPersonAccount, PersonEmail,'+searchFieldName+ ' WHERE ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
		           	else
		           		query='FIND \'* OR *\' IN ALL FIELDS RETURNING Account(Id, Name, Phone, IsPersonAccount, PersonEmail WHERE ' + searchFieldName + ' = \'' + searchFieldValue + '\')';
	   
	        	}
	        	system.debug('*** Account query = ' + query);  
	        	List<List<sObject>> searchList = search.query(query);
	           
	           	if (searchList != null){          
		           	List<Account> accounts =((List<Account>)searchList[0]);
		            if (!accounts.isEmpty()){
		                Integer listSize = accounts.size();
		                system.debug('*** Account Count = ' + listSize);
		                if(listSize != 0){					
			            	account_results.addAll(accounts);
			            	return  account_results; //RETURN IF ANY RESULTS CAME
				        }
		            }
	           	}
	        }
	        catch(QueryException e){
	        	system.debug('*** QueryException ' + e);        	
	        }
        }*/  
        return account_results;
    }  
    
    
    //Overload function using Map of field/field values
    @RemoteAction
    global static Object findObjectByTypeMapSearch(Map<String,String> searchMap, Boolean searchAllField, String searchObjectType){
   		system.debug('*** findObjectByTypeMapSearch: searchAllField - ' + searchAllField +', searchObjectType - ' + searchObjectType);
 	  	List<Account> account_results = new List<Account>();
    	for (String mySFDCfield: searchMap.keySet())
        {
        	if (mySFDCfield != '' && mySFDCfield != null){
        		String mySFDCvalue = searchMap.get(mySFDCfield); 
	        	if (mySFDCvalue != '' && mySFDCvalue != null)
	        	{
	        		system.debug('*** findObjectByTypeMapSearch: searchFieldName - ' + mySFDCfield +', searchFieldValue - ' + mySFDCvalue +', searchObjectType - ' + searchObjectType);
	        		Object resultObj = findObjectByType(mySFDCfield,mySFDCvalue, searchObjectType);
	        		if (resultObj != null)
	        		{
	        			List<Account> result =  (List<Account>)resultObj;
	        			Integer listSize = result.size();
	        			system.debug('*** findObjectByTypeMapSearch:  result size= ' + listSize);    
	        			if (listSize > 0){		        			
		        			for (Account r: result){
				          		Boolean alreadyAdded = false;
				          		for(Account ar: account_results){
				          			if (ar.Id == r.Id){
				          				alreadyAdded = true;
				          				break;
				          			}
				          		}
				          		if (alreadyAdded == false){
				          			account_results.add(r);
				          		}
				          	}
		        			// If search till first result, stop the search 	  
		        			if  (searchAllField == false)
		        			{
		        				system.debug('*** findObjectByTypeMapSearch:  Found some result, stop the search');  
		        				break;    
		        			} 		
	        			}	
	        		}		         
	        	}
	        	else
	        		system.debug('*** findObjectByTypeMapSearch: go on to next check');
        	}
        	
        } 
        system.debug('*** findObjectByTypeMapSearch: search completed');     
        return account_results;
    } 

  
    @RemoteAction
    global static String testConnection()
    {   
    	return 'Active';
    }
     

}