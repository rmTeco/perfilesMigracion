global with sharing class ta_care_MarksManagement implements vlocity_cmt.VlocityOpenInterface{

    global ta_care_MarksManagement() {
        
    }
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if(methodName.equals('getMarks')){
                getMarks(input,outMap,options);
            }
            if(methodName.equals('upsertClientAttributeAssignments')){
                upsertClientAttributeAssignments(input,outMap,options);
            }
            if(methodName.equals('updateClientAttributeAssignments')){
                updateClientAttributeAssignments(input,outMap,options);
            }
            if(methodName.equals('setFraudAndValidAssetForContextIdAndAccountID')){
                setFraudAndValidAssetForContextIdAndAccountID(input,outMap,options);
            }
        }
        catch(Exception e)
        {
            System.debug('ta_care_MarksManagement:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }
    
    void getMarks (Map<String, Object> inputMap, Map<String, Object> outMap, Map<String,Object> options2) {
        /*
		System.debug(options2);
        String ContextId = (String)inputMap.get('ContextId');
        system.debug(ContextId);
        List<vlocity_cmt__AttributeAssignment__c> attrAssign = [select vlocity_cmt__AttributeId__c FROM vlocity_cmt__AttributeAssignment__c where vlocity_cmt__ObjectId__c = :ContextId];
        Set<Id> attrIds = new Set<Id>();
        for (vlocity_cmt__AttributeAssignment__c attrAssignList : attrAssign) {
            attrIds.add(attrAssignList.vlocity_cmt__AttributeId__c);
        }*/
        List<Map<String, String>> options = new List<Map<String, String>>();
        List<vlocity_cmt__Attribute__c> attr = [select Id, name from vlocity_cmt__Attribute__c where vlocity_cmt__AttributeCategoryId__r.name = 'Marks'];

        for (vlocity_cmt__Attribute__c attrList : attr) {
            Map <String, String> tempMap = new Map<String, String>();
            tempMap.put('name', attrList.Name);
            tempMap.put('value', attrList.Name);
            options.add(tempMap);            
        }
        outMap.put('options', options);
    }
    
    void upsertClientAttributeAssignments (Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options) {
		string ContextId = (string)options.get('ContextId');
        List<Account> accList = [Select Id from Account where ParentId =:ContextId];
        List<vlocity_cmt__AttributeAssignment__c> AttrAssList = new List<vlocity_cmt__AttributeAssignment__c>();
        Map<String, Object> Attributes= (Map<String, Object>) options.get('AttrAssignment');

		Account parentAcc = new Account();
        parentAcc.Id = ContextId;
        accList.add(parentAcc);
		
        string AttributeId = (String)Attributes.get('AttributeId');
        
        date startDate;
        date endDate;
        String modifiedDate;
        String modifiedDate2;
        String startDateString;
		String endDateString;
		
		startDateString = (String)Attributes.get('StartDate');
		modifiedDate = startDateString.replace('T', ' ');
		modifiedDate2 = modifiedDate.left(19);
		startDate = date.valueOf(modifiedDate2);
     
		system.debug(Attributes.get('EndDate'));
        if (Attributes.get('EndDate') != '') {
			System.debug('no deberia');
			endDateString = (String)Attributes.get('EndDate');
            modifiedDate = endDateString.replace('T', ' ');
            modifiedDate2 = modifiedDate.left(19);
            endDate = date.valueOf(modifiedDate2);
        }    
        
        boolean isParent = (boolean)Attributes.get('isParentMark');
        boolean hasBeenRemoved = (boolean)Attributes.get('hasBeenRemoved');
        string CategoryId = (string)Attributes.get('CategoryId');
               
        
        for (Account acc : accList){
            vlocity_cmt__AttributeAssignment__c attrAssignment = new vlocity_cmt__AttributeAssignment__c ();
            attrAssignment.vlocity_cmt__ObjectId__c= acc.Id;
            attrAssignment.isParentMark__c = isParent;
            attrAssignment.vlocity_cmt__AttributeCategoryId__c= CategoryId;
            attrAssignment.vlocity_cmt__AttributeId__c = AttributeId;
            attrAssignment.vlocity_cmt__AddDate__c = startDate;
			if (endDate != null) {
				attrAssignment.vlocity_cmt__RemoveDate__c = endDate;
			}
            attrAssignment.vlocity_cmt__RemovedFlag__c= hasBeenRemoved;
            AttrAssList.add(attrAssignment);            
        }
        
        insert AttrAssList;
        
        
    }
    void updateClientAttributeAssignments (Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options) {
	try{
		ID contextID = (ID)options.get('contextId');
		System.debug('contextID ' + contextID);
		ID markID = (ID)options.get('markID'); // id del vlocity attribute
		System.debug('markID ' + markID);
		boolean isDeleted = (boolean)options.get('isDeleted');
		System.debug('isDeleted ' + isDeleted);
		
		List<Account> childAccountList = [SELECT ID FROM Account WHERE ParentId =: contextID ];
		System.debug('childAccountList ' + childAccountList);
		Set<ID> setAccountsId = new Set<ID>();
        for(Account acc: childAccountList){
            setAccountsId.add(acc.id);
        }
		setAccountsId.add(contextID);
		System.debug('setAccountsId cargada ' + setAccountsId);
		List<vlocity_cmt__AttributeAssignment__c> marks = [SELECT id,name,vlocity_cmt__RemovedFlag__c,vlocity_cmt__AddDate__c,vlocity_cmt__RemoveDate__c,isParentMark__c,vlocity_cmt__ObjectId__c
															,vlocity_cmt__ObjectLink__c,vlocity_cmt__AttributeId__c,vlocity_cmt__AttributeCategoryId__c,vlocity_cmt__Data__c FROM vlocity_cmt__AttributeAssignment__c
															WHERE isParentMark__c = true AND vlocity_cmt__ObjectId__c in: setAccountsId AND vlocity_cmt__AttributeId__c =: markID];
	    System.debug('marks ' + marks);
		List<vlocity_cmt__AttributeAssignment__c> attAssigToUpdate = new List<vlocity_cmt__AttributeAssignment__c>();
		if(isDeleted){
		    System.debug('isDeleted');
			for(vlocity_cmt__AttributeAssignment__c attAssig: marks){
				attAssig.vlocity_cmt__RemovedFlag__c = true;
				attAssig.vlocity_cmt__RemoveDate__c = date.today();
				attAssigToUpdate.add(attAssig);
			}
		} else {
		    System.debug('NOisDeleted');
		    String endDateString = (String)options.get('endDate');
		    System.debug('endDateString ' + endDateString);
		    //startDateString = (String)Attributes.get('StartDate');
		    Date endDate;
		    if(endDateString != null)
		    {
		        System.debug('in if');
        		String modifiedDate = endDateString.replace('T', ' ');
        		String modifiedDate2 = modifiedDate.left(19);
        		endDate = date.valueOf(modifiedDate2);
    		    System.debug('endDate ' + endDate);
		        
		    }else{
		        endDate = null;
		    }
		    
		    
		    
		    //DateTime endDate = DateTime.parse(endDateString);
		    
			for(vlocity_cmt__AttributeAssignment__c attAssig: marks){
				attAssig.vlocity_cmt__RemoveDate__c = endDate;
				attAssigToUpdate.add(attAssig);
			}			
		}
        system.debug('attAssigToUpdate-->'+attAssigToUpdate);
		update attAssigToUpdate;
	}
	catch(Exception e){
		
	}
}

    void setFraudAndValidAssetForContextIdAndAccountID (Map<String, Object> input, Map<String, Object> outMap, Map<String,Object> options){
        try{
            System.debug('ENTRO EN setFraudAndValidAssetForContextIdAndAccountID ');
            System.debug('accountId 1 : ' + options.get('accountId'));
            ID accountID = (ID)options.get('accountId');
            Integer numberArray = (Integer)options.get('numberArray');
            System.debug('numberArray: ' + numberArray);
            
            if(numberArray > 1){
                List<Object> inputList = (List<Object>)options.get('BillingAccounts');
                for(Object t : inputList){
                    Map<String, Object> t1 = (Map<String, Object>)t;
                    if(t1.get('AccountId') == accountID){
                        outMap.put('CountValidAssets', t1.get('ActiveAssets') == false ? 0:1);
                        outMap.put('BillingAccounts', t1);
                    }
                }  
            }else {
                Map<String, Object> account = (Map<String, Object>)options.get('BillingAccounts');
                outMap.put('CountValidAssets', account.get('ActiveAssets') == false ? 0:1);
            }
            
            outMap.put('AccountIdExist',true);
            
        }
        catch(Exception e){
           System.debug('Error =' + e); 
           outMap.put('AccountIdExist',false);
        }
    }
}