/*
(default customization: out of the box functionality)
Implement out of the box logic. Includes IWS events handling, event routing, search calls, screen pop calls.

Listens to events:
"workspace/message"

*/

(function(window, jQuery, undefined) {

var _log = Log ? Log.log : console.log;

jQuery.subscribe("workspace/message", processMessage);


function createAttDataArray(userData) {
	var businessAttributes = Workspace.getBusinessAttributes();
	var attData = new Array();
	$.each(userData, function(key, value) {
		if (! (key in businessAttributes)) {
			return;
		}
		var attr = $.extend(true, {}, businessAttributes[key]);
		attr.value = value;
        attData.push(attr);
	});
	return attData;
}

function showAttachedData(userData) {
    if (!userData) {
    	return;
    }

    Connector.showAttachedData(createAttDataArray(userData));
    if(Workspace.getAutoOpenDataDisplay == 'true')
    	sforce.interaction.setVisible(true);
}

////////////////////////////////////////////////////////////////////////////////////////
// event processing
//
// processMessage is called for all received communications from Interaction Workspace
// that contains valid work to be performed.
////////////////////////////////////////////////////////////////////////////////////////

function processMessage(obj) {
    if (obj.action == "OpenObject") {
        _log("in OpenObject");
        
    	if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
    	{
    		var Genesys_activeInteraction = (obj.id === undefined) ? "" : obj.id;
    		window.sessionStorage.setItem("Genesys_activeInteraction", Genesys_activeInteraction);
    		_log("setting Genesys_activeInteraction = " + Genesys_activeInteraction);
    	}
        if(Salesforce.inServiceCloudConsole())
        	showAttachedData(obj.userData);
        
        if(obj.caseScreenpop.toLowerCase() == "true"){
        	performCaseAction(obj);
        	return;
        }
        
        // open based on type attribute
        if (obj.type == "Voice") {
                // Inbound, internal or consult voice
                if (obj.calltype == "Inbound" || obj.calltype == "Internal" || obj.calltype == "Consult") {
                    _log("processMessage: Inbound Voice handling for caller ID = " + obj.source);
                    performInboundVoiceAction(obj);
                }

                // Outbound voice
                if (obj.calltype == "Outbound") {
                    _log("processMessage: Outbound Voice handling for party = " + obj.destination);
                    performOutboundVoiceAction(obj);
                }
                if (obj.calltype == "Unknown") {
                    _log("processMessage: Unknown, clickToDialNum = " + clickToDialNum + ", destination = " + obj.destination);
                    clickToDialNum = "";
                    //performOutboundVoiceAction(obj);
                }
        }
        else if (obj.type == "Email") {
            _log("processMessage: Email pop action");
            performEmailAction(obj);
        }
        else if (obj.type == "Chat") {
            _log("processMessage: Chat pop action");
            performChatAction(obj);
        }
        else if (obj.type == "InteractionWorkItem") {
            _log("processMessage: Workitem pop action for mediaType: " + obj.mediaType);
            performWorkItemAction(obj);
        }
        else if (obj.type == "Sms") {
            _log("processMessage: Sms pop action");
            performSmsAction(obj);
        }
        else if (obj.type == "WebCallback") {
            _log("processMessage: WebCallback pop action");
            performWebCallbackAction(obj);
        }
        else if (obj.type == "OpenMedia") {
            _log("processMessage: OpenMedia pop action");
            performOpenMediaAction(obj);
        }

    }
    else if (obj.action == "CreateActivity") {
    	//var ixnId = Salesforce.getIxnId(obj.id);
    	var objectIdForActivity = "";    	
    
    	var useFocusedRecord = obj.useFocusedRecord;
    	_log("useFocusedRecord " + useFocusedRecord);
	    
    	//if(useFocusedRecord!=null && (useFocusedRecord=="True" || useFocusedRecord=="true") && (!Salesforce.inServiceCloudConsole()))
    	if(useFocusedRecord!=null && useFocusedRecord.toLowerCase() == "true")
    	{
    	    sforce.interaction.getPageInfo(function(o) {
	    	if(o!=null && o.result!=null){	    		
	    	    var jsonResult = jQuery.parseJSON(o.result);
	    	    if(jsonResult!=null && jsonResult.objectId!=null){
	    		objectIdForActivity = jsonResult.objectId;
	    		_log("CreateActivity for connID " + obj.id + " using object " + objectIdForActivity);
	    		// create the task
	    		createTask(obj, objectIdForActivity);	    			
	    		return;
	    	    }
	    	}
    		prepareCreateTask(obj, objectIdForActivity);
	    });	    
	    clickToDialNum = "";
	    return;
    	}
    	else
    	{
    	    //check for attached data sfdcObjectId - if it is there, then use that
    	    if (obj.userData.sfdcObjectId != null){
    		objectIdForActivity = obj.userData.sfdcObjectId;
    		_log("CreateActivity for voice using object " + objectIdForActivity);
		
    		// create the task
    		createTask(obj, objectIdForActivity);
		        
    		clickToDialNum = "";
    		return;		        	    
    	    }
    	}
    	prepareCreateTask(obj, objectIdForActivity);
    }
    else if (obj.action == "MarkedDone") {
    	//TODO
    	//var ixnId = Salesforce.getIxnId(obj.id);
        //_log("MarkedDone for connID " + obj.id + " delete Windows - " + ixnId);
        //Salesforce.removeIxnWindow(ixnId);
    }
    else if (obj.action == "FocusTab") {
        _log("FocusTab for " + obj.id);
        //TODO
        //Salesforce.focusIxnTab(obj.id);
    }
    else if (obj.action == 'ConnectionDenied') {
    	//Don't reconnect if denied
    	_log("Connection denied, do not retry");
    	if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
    	{
    		window.sessionStorage.setItem("Genesys_sfdc_Banned", "True");
    	}
    }
    else if (obj.action == 'PerformSFDCRequest') {
    	_log("PerformSFDCRequest");
    }    
    
    clickToDialNum = "";
}


function prepareCreateTask(obj, objectIdForActivity)
{      
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;     
   
    _log("prepareCreateTask  searchObjectType= " + searchObjectType);
        
    if (obj.type == "Voice")
    { 
	clickToDialNum = "";
    	var lookupNumber='';
    	if (obj.calltype == "Inbound" || obj.calltype == "Internal"  || obj.calltype=="Consult" || obj.calltype=="Conference") {
	    lookupNumber = obj.source;
	    if (obj.role == 'RoleOrigination') {
	        lookupNumber = obj.destination;
	    }
	}
	else if(obj.calltype == "Outbound") {
	    lookupNumber = obj.destination;
	}		
    	//When no match is found for Case and no manual search is done, Activity should be an orphan Activity under the User.
    	var caseScreenpop = (obj.caseScreenpop === undefined) ? "" : obj.caseScreenpop;
    	if(caseScreenpop.toLowerCase() == "true"){
    	    _log("CreateActivity for voice under User since CaseNumber processing did not yield a match");
    	    createTask(obj, objectIdForActivity);
    	    return;
    	}
    }
    	
    var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
    _log("CreateActivity for " + obj.type + "  searchFieldsCount= " + searchFieldsCount);
    var searchAllFields = (obj.searchAllFields === undefined) ? true : (obj.searchAllFields.toLowerCase() == "true");    
    _log("CreateActivity for " + obj.type + "   searchAllFields= " + searchAllFields);
           
    if(searchFieldsCount > 0 || (obj.fieldName != undefined && obj.fieldValue != undefined)){    	    
	var searchFieldName = obj.fieldName;
	var searchFieldValue = obj.fieldValue;
	_log("CreateActivity for " + obj.type + " using search field " + searchFieldName + " for a value of " + searchFieldValue);
    	if (searchObjectType == 'account' || searchObjectType == 'personaccount'){
    	   if (searchFieldsCount > 0){    	
    	       var searchMap_ =  getSearchMap(obj, false)
    	       g_WorkspaceConnectorController.findObjectByTypeMapSearch(searchMap_, searchAllFields, searchObjectType, function(o) {
    		   if (o != null && o.length == 1) {
    		       objectIdForActivity = o[0].Id;
    		       _log("Id found " + objectIdForActivity);
    		   } 
    		   else {
    		       _log("Id not found ");
           	   }
    		   _log("CreateActivity for interaction Id " + obj.id + " using object " + objectIdForActivity);
    		   createTask(obj, objectIdForActivity);
    		   return;
    	       }); 
    	   }
    	   else{
    	       g_WorkspaceConnectorController.findObjectByType(searchFieldName,searchFieldValue, searchObjectType, function(o) {
    		   if (o != null && o.length == 1) {
    		       objectIdForActivity = o[0].Id;
    		       _log("Id found " + objectIdForActivity);
    		   } 
    		   else {
    		       _log("Id not found ");
    		   }
    		   _log("CreateActivity for interaction Id " + obj.id + " using object " + objectIdForActivity);
                   createTask(obj, objectIdForActivity);
                   return;
    	       });  
    	   }
    	}
    	else //searchObjectType is 'default'
    	{
    	    g_WorkspaceConnectorController.IsPersonAccountEnabled(function(result){
    		if (result == null || result == 'false'){
    		    if (searchFieldsCount > 0){	    		
    			var searchMap_ =  getSearchMap(obj, false)
    			g_WorkspaceConnectorController.findObjectMapSearch(searchMap_, searchAllFields, function(o) {
    			    _log("CreateActivity " + o);
    			    if (o != null &&  o != 'not found' &&  o !=  'multiple found' ){
    		    	    	objectIdForActivity = o.Id;
    		    	    	_log("Id found " + objectIdForActivity);
    			    } 
    			    else {
    				_log("Id not found ");
    			    }
    			    _log("CreateActivity for interaction Id " + obj.id + " using object " + objectIdForActivity);
        		    createTask(obj, objectIdForActivity);
        		    return;
    			}); 
    		    }
    		    else{
    			_log("CreateActivity for " + obj.type + " using search field for default setting");
    			g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {
    			    _log("CreateActivity " + o);
    			    if (o != null &&  o != 'not found' &&  o !=  'multiple found' ) {
    				objectIdForActivity = o.Id;
    		    	    	_log("Id found " + objectIdForActivity);
    			    } 
    			    else {
    				_log("Id not found ");
    			    }
    			    _log("CreateActivity for interaction Id " + obj.id + " using object " + objectIdForActivity);
        		    createTask(obj, objectIdForActivity);
        		    return;
    			});
    		    }
    		}
    	    });
    	}
    }
    if (obj.type == "Voice" && searchFieldsCount == 0 && (obj.fieldName == undefined || obj.fieldValue != undefined)){
        _log("CreateActivity for voice with lookup " + lookupNumber);
        if (searchObjectType == 'account' || searchObjectType == 'personaccount')
        {
            g_WorkspaceConnectorController.findObjectFromANIByType(lookupNumber, searchObjectType, function(o) {
        	if (o != null) {
        	    if (o == 'not found') {
        		_log("No results");
        	    }
        	    else{           		    
        		if (o.length == 1){
        		    objectIdForActivity = o[0].Id;
        		    _log("Id found " + objectIdForActivity);
        		}
        		else if(o.length > 1){           			
        		    _log("Multiple results");
        		}
        		else //0 match
        		    _log("No results");
        	    }
        	} 
        	else {
        	    _log("No results");
        	}
        	_log("CreateActivity for connID " + obj.id + " using object " + objectIdForActivity);
        	createTask(obj, objectIdForActivity);
        	return;
            });   
        }
        else //searchObjectType is 'default'
        { 
            g_WorkspaceConnectorController.IsPersonAccountEnabled(function(result){
        	if (result == null || result == 'false'){	 
        	    g_WorkspaceConnectorController.findObjectFromANI(lookupNumber, function(o) {
        		if (o != null) {
        		    if(o != 'not found' && o != 'multiple found'){
        			objectIdForActivity = o.Id;
        			_log("Id found " + objectIdForActivity);
        		    }
        		    else if(o == 'multiple found'){
                    		    _log("Multiple results");
                    		    //find the one with the most recent completed activity and create the task there
                    		    //findMostRecentlyCompletedActivity(lookupNumber, false, obj.id, obj);
                    		    //return;
        		    }
        		}
            		else{ //o is null
            		    _log("No results");
            		}		
        		_log("CreateActivity for connID " + obj.id + " using object " + objectIdForActivity);
            		createTask(obj, objectIdForActivity);
            		return;
        	    });
        	}
            });    	
        }	  
    }

    _log("CreateActivity for interaction Id " + obj.id + " using object " + objectIdForActivity);

    // create the task
    createTask(obj, objectIdForActivity);
}

////////////////////////////////////////////////////////////////////////////////////////
// Inbound and Outbound Voice handling
////////////////////////////////////////////////////////////////////////////////////////
/*Check the object type to search in
1 - default: Account, Contact, Lead
2 - account
3 - personaccount
*/ 
function searchByFieldAndType(searchFieldName,searchFieldValue, ixnId, searchObjectType)
{
    _log("searchByFieldAndType");       
    if (searchObjectType == 'account' || searchObjectType == 'personaccount')
    {
	g_WorkspaceConnectorController.findObjectByType(searchFieldName,searchFieldValue, searchObjectType, function(o) {  
	    if (o != null) {
		if (o.length == 1){
		    if (Salesforce.inServiceCloudConsole()) {
           	    	Salesforce.screenPop(o[0].Id); 
           	    }
           	    else 
           		Workspace.sendFocusChange(o[0].Id, true); //move screenpop so that it wasn't called while we were still sending events
           	         //inform workspace of SFobject id for subsequent use in activity creation and transfer
		    var newData = '{"sfdcObjectId":"' + o[0].Id + '","id":"' + ixnId + '"}';
		    Workspace.sendAttachData(newData);
   		}
   		else if(o.length > 1){
   		    _log("searchByFieldAndType Multiple entry, open the new search page");
   		    Salesforce.openSearchAccount(o,ixnId, searchObjectType, '');
   		}
   		else //0 match
   		    Salesforce.openSearchAccount("",ixnId, searchObjectType, '');
	    }
	    else { //o is null
   	         _log("searchByFieldAndType: No entry, open the new search page");           	    
   	         Salesforce.openSearchAccount("",ixnId , searchObjectType, '');
   	     }
	});	    
    }
    else // searchObjectType is 'default'
    {
	g_WorkspaceConnectorController.IsPersonAccountEnabled(function(result){
	    if (result == null || result == 'false'){	 
		g_WorkspaceConnectorController.findObject(searchFieldName,searchFieldValue, function(o) {  
		    if (o == null || o == 'not found'){
			_log("searchByFieldAndType: result = " + o);
       	         	//open search
       	         	Salesforce.openSearch("", ixnId); 
		    }
		    else if (o ==  'multiple found'){
			_log("searchByFieldAndType: result = " + o);
       	         	//open search
       	         	Salesforce.openSearchByFields(searchFieldName, searchFieldValue, ixnId);
		    }
		    else{			
			if (Salesforce.inServiceCloudConsole()) {
			    Salesforce.screenPop(o.Id); 
			}
			else{
			    Workspace.sendFocusChange(o.Id, true); //move screen pop so that it wasn't called while we were still sending events
			}
    	        	//inform workspace of SFobject id for subsequent use in activity creation and transfer
    	        	var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + ixnId + '"}';
    	        	Workspace.sendAttachData(newData);
		    } 
        	    
		});
	    }
	});
    }
}

function searchByFieldsListAndType(searchMap, searchAllFields, ixnId, searchObjectType)
{
    _log("searchByFieldsListAndType");       
    if (searchObjectType == 'account' || searchObjectType == 'personaccount')
    {
	g_WorkspaceConnectorController.findObjectByTypeMapSearch(searchMap, searchAllFields, searchObjectType, function(o) {  
	    if (o != null) {
		if (o.length == 1){
		    if (Salesforce.inServiceCloudConsole()) {
           	    	Salesforce.screenPop(o[0].Id); 
           	    }
           	    else 
           		Workspace.sendFocusChange(o[0].Id, true); //move screenpop so that it wasn't called while we were still sending events
           	         //inform workspace of SFobject id for subsequent use in activity creation and transfer
		    var newData = '{"sfdcObjectId":"' + o[0].Id + '","id":"' + ixnId + '"}';
		    Workspace.sendAttachData(newData);
   		}
   		else if(o.length > 1){
   		    _log("searchByFieldsListAndType Multiple entry, open the new search page");
   		    Salesforce.openSearchAccount(o,ixnId, searchObjectType, '');
   		}
   		else //0 match
   		    Salesforce.openSearchAccount("",ixnId, searchObjectType, '');
	    }
	    else { //o is null
   	         _log("searchByFieldsListAndType: No entry, open the new search page");           	    
   	         Salesforce.openSearchAccount("",ixnId , searchObjectType, '');
   	     }
	});	    
    }
    else // searchObjectType is 'default'
    {
	g_WorkspaceConnectorController.IsPersonAccountEnabled(function(result){
	    if (result == null || result == 'false'){	 
		g_WorkspaceConnectorController.findObjectMapSearch(searchMap, searchAllFields, function(o) {  
		    if (o == null || o == 'not found'){
			_log("searchByFieldsListAndType: result = " + o);
       	         	//open search
       	         	Salesforce.openSearch("", ixnId); 
		    }
		    else if (o ==  'multiple found'){
			_log("searchByFieldsListAndType: result = " + o);
       	         	//open search
       	         	Salesforce.openSearchByFieldsMap(searchMap, ixnId);
		    }
		    else{			
			if (Salesforce.inServiceCloudConsole()) {
			    Salesforce.screenPop(o.Id); 
			}
			else{
			    Workspace.sendFocusChange(o.Id, true); //move screen pop so that it wasn't called while we were still sending events
			}
    	        	//inform workspace of SFobject id for subsequent use in activity creation and transfer
    	        	var newData = '{"searchByFieldsListAndType sfdcObjectId":"' + o.Id + '","id":"' + ixnId + '"}';
    	        	Workspace.sendAttachData(newData);
		    } 
        	    
		});
	    }
	});
    }
}


function searchByLookupPhoneNumberAndType(lookupNumber, ixnId, searchObjectType)
{
    _log("Using lookupNumber = " + lookupNumber);
    if (searchObjectType == 'account' || searchObjectType == 'personaccount')
    {	    
	g_WorkspaceConnectorController.findObjectFromANIByType(lookupNumber, searchObjectType, function(o) {
	    if (o != null) {
		if (o == 'not found') {
		    Salesforce.openSearchAccount('', ixnId, searchObjectType, lookupNumber);
		    return;
		}
		else{           		    
		    if (o.length == 1){
  	    	 	if (Salesforce.inServiceCloudConsole()) {
       	    	 	    Salesforce.screenPop(o[0].Id); 
       	    	 	}
       	    	 	else 
       	    	 	    Workspace.sendFocusChange(o[0].Id, true); //move screenpop so that it wasn't called while we were still sending events
       	    	 	//inform workspace of SFobject id for subsequent use in activity creation and transfer
       	    	 	var newData = '{"sfdcObjectId":"' + o[0].Id + '","id":"' + ixnId + '"}';
       	    	 	Workspace.sendAttachData(newData);
		    }
		    else if(o.length > 1){           			
			_log("Multiple entry, open the new search page");
			Salesforce.openSearchAccount(o, ixnId, searchObjectType, lookupNumber);
		    }
		    else //0 match
			Salesforce.openSearchAccount('', ixnId, searchObjectType, lookupNumber);
		}

	    } 
	    else { // o is null
		_log("No records found with phone field containing: " + lookupNumber);
		Salesforce.openSearchAccount('', ixnId, searchObjectType, lookupNumber);
	    }
        });   
    }
    else //searchObjectType is 'default'
    {
	g_WorkspaceConnectorController.IsPersonAccountEnabled(function(result){
	    if (result == null || result == 'false'){	 
		g_WorkspaceConnectorController.findObjectFromANI(lookupNumber, function(o) {
        	    if (o != null) {
        		if (o == 'multiple found' || o == 'not found') {
        		    Salesforce.openSearch(lookupNumber, ixnId);
        		    return;
        		}
        		Salesforce.addIxnWindow(ixnId, o.Id);
        		if (Salesforce.inServiceCloudConsole()) {
        		    Salesforce.screenPop(o.Id); 
        		}
        		else 
        		    Workspace.sendFocusChange(o.Id, true); //move screen pop so that it wasn't called while we were still sending events
        		//inform workspace of SFobject id for subsequent use in activity creation and transfer
        		var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + ixnId + '"}';
        		Workspace.sendAttachData(newData);
        		} 
        	    else {  // o is null
        		_log("No records found with phone field containing: " + lookupNumber);
        	    }
		});
	    }
	});
    }    
}


function getSearchMap(obj, isCase) {
    _log("in getSearchMap isCase=" + isCase);  
    if (!isCase){
        var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
        _log("getSearchMap  searchFieldsCount= " + searchFieldsCount);
        
        if (searchFieldsCount > 0){
            var searchMap =  new Object();
            for (var index=1; index <= searchFieldsCount; index++ ){
        	var fieldKeyName = "search_SFDC" + index + "_field";
        	var valueKeyName =  "search_SFDC" + index + "_value";
        	var _SFDCfield= (obj[fieldKeyName] === undefined) ? "" : obj[fieldKeyName];
        	var _SFDCvalue = (obj[valueKeyName] === undefined) ? "" : obj[valueKeyName];
        	_log("getSearchMap  _SFDCfield: " + _SFDCfield + " _SFDCvalue: " + _SFDCvalue);      
        	searchMap[_SFDCfield] = _SFDCvalue;	
            }
            return searchMap;
        }      
    }
    else{
	var caseSearchFieldsCount =  (obj.caseSearchFieldsCount === undefined) ? 0 : parseInt(obj.caseSearchFieldsCount);  
        _log("getSearchMap  caseSearchFieldsCount= " + caseSearchFieldsCount);
        
        if (caseSearchFieldsCount > 0){
            var searchMap =  new Object();
            for (var index=1; index <= caseSearchFieldsCount; index++ ){
        	var fieldKeyName = "case_SFDC" + index + "_field";
        	var valueKeyName =  "case_SFDC" + index + "_value";
        	var _SFDCfield= (obj[fieldKeyName] === undefined) ? "" : obj[fieldKeyName];
        	var _SFDCvalue = (obj[valueKeyName] === undefined) ? "" : obj[valueKeyName];
        	_log("getSearchMap  _SFDCfield: " + _SFDCfield + " _SFDCvalue: " + _SFDCvalue);      
        	searchMap[_SFDCfield] = _SFDCvalue;	
            }
            return searchMap;
        }       
    }
    return null;
	
}

function getSearchMap2(obj, isCase) {
    _log("in getSearchMap isCase=" + isCase);  
    if (!isCase){
        var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
        _log("getSearchMap  searchFieldsCount= " + searchFieldsCount);
        
        if (searchFieldsCount > 1){
            var searchMap =  new Object();
            for (var index=2; index <= searchFieldsCount; index++ ){
        	var fieldKeyName = "search_SFDC" + index + "_field";
        	var valueKeyName =  "search_SFDC" + index + "_value";
        	var _SFDCfield= (obj[fieldKeyName] === undefined) ? "" : obj[fieldKeyName];
        	var _SFDCvalue = (obj[valueKeyName] === undefined) ? "" : obj[valueKeyName];
        	_log("getSearchMap  _SFDCfield: " + _SFDCfield + " _SFDCvalue: " + _SFDCvalue);      
        	searchMap[_SFDCfield] = _SFDCvalue;	
            }
            return searchMap;
        }      
    }
    else{
	var caseSearchFieldsCount =  (obj.caseSearchFieldsCount === undefined) ? 0 : parseInt(obj.caseSearchFieldsCount);  
        _log("getSearchMap  caseSearchFieldsCount= " + caseSearchFieldsCount);
        
        if (caseSearchFieldsCount > 0){
            var searchMap =  new Object();
            for (var index=1; index <= caseSearchFieldsCount; index++ ){
        	var fieldKeyName = "case_SFDC" + index + "_field";
        	var valueKeyName =  "case_SFDC" + index + "_value";
        	var _SFDCfield= (obj[fieldKeyName] === undefined) ? "" : obj[fieldKeyName];
        	var _SFDCvalue = (obj[valueKeyName] === undefined) ? "" : obj[valueKeyName];
        	_log("getSearchMap  _SFDCfield: " + _SFDCfield + " _SFDCvalue: " + _SFDCvalue);      
        	searchMap[_SFDCfield] = _SFDCvalue;	
            }
            return searchMap;
        }       
    }
    return null;
	
}




// screen pop for inbound voice. If role is RoleDestination, then this is inbound, if
// RoleOrigination, then it is an manual outbound dial
function performInboundVoiceAction(obj) {
    _log("in performInboundVoiceAction()");    

    // determine number to use based on role
    _log("performInboundVoiceAction Role is " + obj.role);
    var lookupNumber = obj.source;
    if (obj.role == 'RoleOrigination') {
        lookupNumber = obj.destination;
    }
    
    if(obj.calltype == "Consult" && obj.userData.primaryANI != undefined && obj.userData.primaryANI != ""){
	_log("Using primaryANI from Consult");
	lookupNumber = obj.userData.primaryANI;
    }

    if (Salesforce.screenPopUser(obj)) {
	return;
    }        
            
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performInboundVoiceAction  searchObjectType= " + searchObjectType);
    
    var searchAllFields = (obj.searchAllFields === undefined) ? true : (obj.searchAllFields.toLowerCase() == "true");        
    var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
	_log("performInboundVoiceAction  searchAllFields= " + searchAllFields);
    _log("performInboundVoiceAction  searchFieldsCount= " + searchFieldsCount);
	
	//Customization added
	if(obj.fieldName != undefined && obj.fieldValue != undefined)
	{
		_log("FieldName: [" + obj.fieldName + "] FieldValue: [" + obj.fieldValue + "]");
	}
	
    if (searchFieldsCount > 0)
	{
		_log("Get the custom search type");
		
		var fieldKeyName = "search_SFDC" + "1" + "_field";
		var valueKeyName =  "search_SFDC" + "1" + "_value";
		
		var _SFDCfield= (obj[fieldKeyName] === undefined) ? "" : obj[fieldKeyName];
		var _SFDCvalue = (obj[valueKeyName] === undefined) ? "" : obj[valueKeyName];
		
		_log("Custom Search Type: [" + _SFDCfield + ", " + _SFDCvalue + "]");
		
		if(String(_SFDCvalue) == "IDCuenta")
		{
			searchObjectType = "account";
			_log("custom searchObjectType= " + searchObjectType);
		}
		else if(String(_SFDCvalue) == "NOFAN")
		{
			//DO nothing
			return;
		}
		else
		{
			searchObjectType = "default";
			_log("custom searchObjectType= " + searchObjectType);
		}
		
		//Get the customized search map, ignores the first element
		var searchMap_ =  getSearchMap2(obj, false)
		
		searchByFieldsListAndType(searchMap_, searchAllFields, obj.id, searchObjectType)
    }
    else if(obj.fieldName != undefined && obj.fieldValue != undefined){
	var searchFieldName = obj.fieldName;
	var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
	_log("performInboundVoiceAction search field " + searchFieldName + " for a value of " + searchFieldValue);        	
	searchByFieldAndType(searchFieldName,searchFieldValue, obj.id, searchObjectType)
    }
    else{
	_log("performInboundVoiceAction search by ANI");     
	searchByLookupPhoneNumberAndType(lookupNumber, obj.id, searchObjectType); 	
    }
}

// screen pop for outbound voice
function performOutboundVoiceAction(obj) {
    _log("in performOutboundVoiceAction()");
    if (Salesforce.screenPopUser(obj)) {
        return;
    }

    var lookupNumber = obj.destination;
    _log("performOutboundVoiceAction using lookupNumber = " + lookupNumber);
    
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performOutboundVoiceAction  searchObjectType= " + searchObjectType); 
    
    var searchAllFields = (obj.searchAllFields === undefined) ? true : (obj.searchAllFields.toLowerCase() == "true");        
    var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
    _log("performOutboundVoiceAction  searchFieldsCount= " + searchFieldsCount);
	
	//Customization added
	if(obj.fieldName != undefined && obj.fieldValue != undefined)
	{
		_log("FieldName: [" + obj.fieldName + "] FieldValue: [" + obj.fieldValue + "]");
	}
    
    //Handle outbound campaign calls which do have attached data as well as outgoing calls which do not have valuable attached data
    if (searchFieldsCount > 0)
	{
		_log("Get the custom search type");
		
		var fieldKeyName = "search_SFDC" + "1" + "_field";
		var valueKeyName =  "search_SFDC" + "1" + "_value";
		
		var _SFDCfield= (obj[fieldKeyName] === undefined) ? "" : obj[fieldKeyName];
		var _SFDCvalue = (obj[valueKeyName] === undefined) ? "" : obj[valueKeyName];
		
		_log("Custom Search Type: [" + _SFDCfield + ", " + _SFDCvalue + "]");
		
		if(String(_SFDCvalue) == "IDCuenta")
		{
			searchObjectType = "account";
			_log("custom searchObjectType= " + searchObjectType);
		}
		else if(String(_SFDCvalue) == "NOFAN")
		{
			//DO nothing
			return;
		}
		else
		{
			searchObjectType = "default";
			_log("custom searchObjectType= " + searchObjectType);
		}
		
		//Get the customized search map, ignores the first element
		var searchMap_ =  getSearchMap2(obj, false)
		
		searchByFieldsListAndType(searchMap_, searchAllFields, obj.id, searchObjectType)
		
		//var searchMap_ =  getSearchMap(obj, false)
		//searchByFieldsListAndType(searchMap_, searchAllFields, obj.id, searchObjectType)
    }       
    else if(obj.fieldName != undefined && obj.fieldValue != undefined){
	var searchFieldName = obj.fieldName;
	var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
	_log("performOutboundVoiceAction search field " + searchFieldName + " for a value of " + searchFieldValue);        	
	searchByFieldAndType(searchFieldName,searchFieldValue, obj.id, searchObjectType)
    }
    else{
	_log("performOutboundVoiceAction search by DNIS");     
	searchByLookupPhoneNumberAndType(lookupNumber, obj.id, searchObjectType);
    }
    
}

////////////////////////////////////////////////////////////////////////////////////////
// Email handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for email

function performEmailAction(obj) {
    _log("in performEmailAction()");
    if (Salesforce.screenPopUser(obj)) {
        return;
    }
    var searchFieldName = "";
    var searchFieldValue = "";
    var lookupContact;
    
    /*Check the object type to search in
	1 - default: Account, Contact, Lead
	2 - account
	3 - personaccount
     */        
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performEmailAction  searchObjectType= " + searchObjectType);
    
    var searchAllFields = (obj.searchAllFields === undefined) ? true : (obj.searchAllFields.toLowerCase() == "true");        
    var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
    _log("performEmailAction  searchFieldsCount= " + searchFieldsCount);
    
    if (searchFieldsCount > 0){
	var searchMap_ =  getSearchMap(obj, false)
	searchByFieldsListAndType(searchMap_, searchAllFields, obj.id, searchObjectType)
    }    
    else{
	if(obj.source != undefined && obj.source != '') {
	    lookupContact = obj.source;
	    searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
	    searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
	}
	else{
	    if(obj.destination != undefined){
		var emailAddr = obj.destination;
    		//remove trailing ; or ,
    		var lastChar1 = emailAddr.lastIndexOf(";");
    		var lastChar2 = emailAddr.lastIndexOf(",");
    		if(lastChar1 == (emailAddr.length-1) || lastChar2 == (emailAddr.length-1)){
    			//remove last character
    			emailAddr = emailAddr.slice(0,-1);			
    		}			
    		_log("emailAddr " + emailAddr);
    		lookupContact = emailAddr;
    		searchFieldName = "email";
    		searchFieldValue = emailAddr;
	    }
	}
    
	_log("performEmailAction search field " + searchFieldName + " for a value of " + searchFieldValue);
	searchByFieldAndType(searchFieldName,searchFieldValue, obj.id, searchObjectType);
    }
}

////////////////////////////////////////////////////////////////////////////////////////
// Chat handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for chat
function performChatAction(obj) {
    _log("in performChatAction()");
    // check for attached data sfdcObjectId - if it is already there, then pop that
    if (Salesforce.screenPopUser(obj)) {
        return;
    }

    var name = obj.source;
    var searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
    var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
    _log("performChatAction search field " + searchFieldName + " for a value of " + searchFieldValue);
     
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performChatAction  searchObjectType= " + searchObjectType);	
    
    var searchAllFields = (obj.searchAllFields === undefined) ? true : (obj.searchAllFields.toLowerCase() == "true");        
    var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
    _log("performChatAction  searchFieldsCount= " + searchFieldsCount);
    
    if (searchFieldsCount > 0){
	var searchMap_ =  getSearchMap(obj, false)
	searchByFieldsListAndType(searchMap_, searchAllFields, obj.id, searchObjectType)
    }
    else{
        // using the source attribute locate the contact
        searchByFieldAndType(searchFieldName,searchFieldValue,obj.id, searchObjectType);
    }
}


////////////////////////////////////////////////////////////////////////////////////////
// WorkItem handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for WorkItem
function performWorkItemAction(obj) {
    _log("in performWorkItemAction()");
    // check for attached data sfdcObjectId - if it is already there, then pop that
    if (Salesforce.screenPopUser(obj)) {
        return;
    }

    var name = obj.source;
    var searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
    var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
    _log("performWorkItemAction search field " + searchFieldName + " for a value of " + searchFieldValue);   
    
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performWorkItemAction  searchObjectType= " + searchObjectType);
    
    // using the source attribute locate the contact
    searchByFieldAndType(searchFieldName,searchFieldValue, obj.id, searchObjectType);
}

////////////////////////////////////////////////////////////////////////////////////////
//SMS handling
////////////////////////////////////////////////////////////////////////////////////////

//screen pop for SMS
function performSmsAction(obj) {
     _log("in performSmsAction()");
     // check for attached data sfdcObjectId - if it is already there, then pop that
     if (Salesforce.screenPopUser(obj)) {
         return;
     }
    
     var name = obj.source;
     var searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
     var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
     _log(" performSmsAction search field " + searchFieldName + " for a value of " + searchFieldValue);
    
   
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performSmsAction  searchObjectType= " + searchObjectType);
    
    var searchAllFields = (obj.searchAllFields === undefined) ? true : (obj.searchAllFields.toLowerCase() == "true");        
    var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
    _log("performSmsAction  searchFieldsCount= " + searchFieldsCount);
    
    if (searchFieldsCount > 0){
	var searchMap_ =  getSearchMap(obj, false)
	searchByFieldsListAndType(searchMap_, searchAllFields, obj.id, searchObjectType)
    }    
    else{     
	searchByFieldAndType(searchFieldName,searchFieldValue, obj.id, searchObjectType);
    }
}

////////////////////////////////////////////////////////////////////////////////////////
//WebCallback handling
////////////////////////////////////////////////////////////////////////////////////////

//screen pop for WebCallback
function performWebCallbackAction(obj) {
    _log("in performWebCallbackAction()");
	
    //add startDate to interaction for Subject on Activity
    var startDate = getDateB();
    var newData = '{"startDate":"' + startDate + '","id":"' + obj.id + '"}';
    Workspace.sendAttachData(newData);
	
    // check for attached data sfdcObjectId - if it is already there, then pop that
    if (Salesforce.screenPopUser(obj)) {
	return;
    }

    var name = obj.source;
    var searchFieldName = (obj.fieldName === undefined) ? "" : obj.fieldName;
    var searchFieldValue = (obj.fieldValue === undefined) ? "" : obj.fieldValue;
    _log("performWebCallbackAction search field " + searchFieldName + " for a value of " + searchFieldValue);
	 
      
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performWebCallbackAction  searchObjectType= " + searchObjectType);
    
    var searchAllFields = (obj.searchAllFields === undefined) ? true : (obj.searchAllFields.toLowerCase() == "true");        
    var searchFieldsCount =  (obj.searchFieldsCount === undefined) ? 0 : parseInt(obj.searchFieldsCount);  
    _log("performEmailAction  searchFieldsCount= " + searchFieldsCount);
    
    if (searchFieldsCount > 0){
	var searchMap_ =  getSearchMap(obj, false)
	searchByFieldsListAndType(searchMap_, searchAllFields, obj.id, searchObjectType)
    }    
    else{
	searchByFieldAndType(searchFieldName,searchFieldValue, obj.id, searchObjectType);
    }
}

////////////////////////////////////////////////////////////////////////////////////////
// Open Media handling
////////////////////////////////////////////////////////////////////////////////////////

// screen pop for OpenMedia
function performOpenMediaAction(obj) {
    _log("in performOpenMediaAction()");
    // check for attached data sfdcObjectId - if it is already there, then pop that
    if (Salesforce.screenPopUser(obj)) {
        return;
    }

    var name = obj.source;
    
    var searchObjectType = (obj.searchObjectType === undefined) ? "default" : obj.searchObjectType;        
    _log("performOpenMediaAction  searchObjectType= " + searchObjectType);
    
    if (searchObjectType == 'account' || searchObjectType == 'personaccount'){
	searchByFieldAndType('Name', name, searchObjectType);
    }
    else{
	g_WorkspaceConnectorController.IsPersonAccountEnabled(function(result){
	    if (result == null || result == 'false'){	 
        	g_WorkspaceConnectorController.findContactFromOpenMediaAddress(name, function(o) {
        	    if (o != null) {
        	     	if (Salesforce.inServiceCloudConsole()) {
        	       		Salesforce.screenPop(o.Id); 
        	       	}
        	       	else Workspace.sendFocusChange(o.Id, true); //move screenpop so that it wasn't called while we were still sending events
        	        //inform workspace of SFobject id for subsequent use in activity creation and transfer
        	        var newData = '{"sfdcObjectId":"' + o.Id + '","id":"' + obj.id + '"}';
        	        Workspace.sendAttachData(newData);
        	    } else {
        		_log("performOpenMediaAction: No records found with Name containing: " + name);
        	        //open search
        	        Salesforce.openSearch("", obj.id); 
        	    }
        	});
	    }
	});
    }

}


////////////////////////////////////////////////////////////////////////////////////////
// Case handling
////////////////////////////////////////////////////////////////////////////////////////

function searchCaseByField(searchFieldName,searchFieldValue, ixnId)
{
    _log("in searchCaseByField");
    if(searchFieldName!= undefined && searchFieldValue != undefined){
    	 g_WorkspaceConnectorController.findCaseObject(searchFieldName,searchFieldValue, function(o) {
    	     if (o != null) {
    	    	 if (Salesforce.inServiceCloudConsole()) {
    	    		 if(o.ContactId != undefined){
      	    			Salesforce.screenPop(o.ContactId);
      	    			var newData = '{"sfdcObjectId":"' + o.ContactId + '","id":"' + ixnId + '"}';
      	    			Workspace.sendAttachData(newData); 
     	    		 }
    	    		 if(o.Id != undefined){
    	    			Salesforce.screenPop(o.Id);
    	    	        var newData = '{"sfdcCaseId":"' + o.Id + '","id":"' + ixnId + '"}';
    	    	        Workspace.sendAttachData(newData);
    	    		 }    	    			 
    	    	 }
    	    	  else{  
    	    	      if(o.ContactId != undefined){
 			var newData = '{"sfdcObjectId":"' + o.ContactId + '","id":"' + ixnId  + '"}';
 			Workspace.sendAttachData(newData); 
    	    	      }
    	    	      if(o.Id != undefined){
        	    	     Workspace.sendFocusChange(o.Id, true); //move screenpop so that it wasn't called while we were still sending events        	    	    
        	    	     var newData = '{"sfdcCaseId":"' + o.Id + '","id":"' + ixnId + '"}';
        	    	     Workspace.sendAttachData(newData);
    	    	      }    	   
    	    	  }
    	     } else {
    	         _log("performCaseAction: result = " + o);
    	         //open search
    	         Salesforce.openSearchCase("", ixnId); 
    	     }
    	 });
    }
    else
	Salesforce.openSearchCase("", ixnId); 
}

function searchCaseByFieldsList(searchMap, searchAllFields, ixnId)
{
    _log("in searchCaseByFieldsList" );
    g_WorkspaceConnectorController.findCaseObjectMapSearch(searchMap, searchAllFields, function(o) {
	if (o != null) {
	    if (o.length == 1){  
		_log("searchCaseByFieldsList:  One entry, open the case");
		if (Salesforce.inServiceCloudConsole()) {
		    if(o[0].ContactId != undefined){
			Salesforce.screenPop(o[0].ContactId);
			var newData = '{"sfdcObjectId":"' + o[0].ContactId + '","id":"' + ixnId + '"}';
			Workspace.sendAttachData(newData); 
		    }
		    if(o[0].Id != undefined){
			Salesforce.screenPop(o[0].Id);
			var newData = '{"sfdcCaseId":"' + o[0].Id + '","id":"' + ixnId + '"}';
			Workspace.sendAttachData(newData);
		    }    	    			 
		}
		else{  
		    if(o[0].ContactId != undefined){
			var newData = '{"sfdcObjectId":"' + o[0].ContactId + '","id":"' + ixnId  + '"}';
			Workspace.sendAttachData(newData); 
		    }
		    if(o[0].Id != undefined){
			Workspace.sendFocusChange(o[0].Id, true); //move screenpop so that it wasn't called while we were still sending events        	    	    
			var newData = '{"sfdcCaseId":"' + o[0].Id + '","id":"' + ixnId + '"}';
			Workspace.sendAttachData(newData);
		    }    	   
		}
	    }
	    else if(o.length > 1){
		_log("searchCaseByFieldsList:  Multiple entry, open the new search page");
		Salesforce.openSearchCase(o,ixnId);
	    }
	    else{
		//open search
		_log("searchCaseByFieldsList:  No entry, open the new search page");
		Salesforce.openSearchCase("", ixnId);     
	    }
	}
	else {
	    _log("searchCaseByFieldsList: result = " + o);
	    //open search
	    Salesforce.openSearchCase("", ixnId); 
	}
    });
 
}


function performCaseAction(obj){
    _log("in performCaseAction");
    // check for attached data sfdcCaseId and sfdcObjectId - if it is already there, then pop that
    var sfdcCase = (obj.userData.sfdcCaseId === undefined) ? "" : obj.userData.sfdcCaseId;
    if (sfdcCase != "") {
	if (Salesforce.inServiceCloudConsole()) {  
	    Salesforce.screenPop(sfdcCase);
	    Salesforce.screenPopUser(obj);
	    return;
	}
	else{
	    Workspace.sendFocusChange(sfdcCase, true); 
	}
    }
	
    if (Salesforce.screenPopUser(obj)) {
        return;
    }
    
    var caseSearchFieldsCount =  (obj.caseSearchFieldsCount === undefined) ? 0 : parseInt(obj.caseSearchFieldsCount);  
    _log("searchCaseByFieldsList for case screen pop caseSearchFieldsCount= " + caseSearchFieldsCount);
    var caseSearchAllFields = (obj.caseSearchAllFields === undefined) ? true : (obj.caseSearchAllFields.toLowerCase() == "true");    
    _log("searchCaseByFieldsList for case screen pop caseSearchAllFields= " + caseSearchAllFields);
    if (caseSearchFieldsCount > 0){    	
	var searchMap_ =  getSearchMap(obj, true);
	searchCaseByFieldsList(searchMap_, caseSearchAllFields, obj.Id);
    }
    else if(obj.caseSfdcField != undefined && obj.caseSfdcField != undefined){
    	var searchFieldName = obj.caseSfdcField;
    	var searchFieldValue = (obj.caseSfdcFieldValue === undefined) ? "" : obj.caseSfdcFieldValue;
    	searchCaseByField(searchFieldName, searchFieldValue, obj.Id);    	 
    }
    else
	Salesforce.openSearchCase("", obj.Id); 
	
}

////////////////////////////////////////////////////////////////////////////////////////
// Task handling
//
// Writes a simple task from provided disposition information
////////////////////////////////////////////////////////////////////////////////////////

function getDateB() {
    var date = new Date();
    var hrs = date.getHours();
    if(hrs < 10)
    	hrs = "0" + hrs;
    var min = date.getMinutes();
    if(min < 10)
    	min = "0" + min;
    var sec = date.getSeconds();
    if(sec < 10)
    	sec = "0" + sec;
    var day = date.getDate();
    if(day < 10)
    	day = "0" + day;
    var month = date.getMonth() + 1;
    if(month < 10)
    	month = "0" + month;
    return (date.getFullYear()) + '-' + month + '-' + day
        + " " + hrs + ':' + min + ':' + sec;
}

function getDisplayDate() {
    var date = new Date();
    var hrs = date.getHours();
    if(hrs < 10)
    	hrs = "0" + hrs;
    var min = date.getMinutes();
    if(min < 10)
    	min = "0" + min;
    var sec = date.getSeconds();
    if(sec < 10)
    	sec = "0" + sec;
    return (date.getMonth() + 1) + '/' + (date.getDate()) + '/' + date.getFullYear()
        //+ " " + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
        + " " + hrs + ':' + min + ':' + sec;
}

function createTask(createObj, objIdForActivity) {
    _log("in createTask");
    var createObjType = (createObj.type === undefined) ? getDisplayDate() : createObj.type;
    _log("createTask for " + createObjType);
    var displayDate = (createObj.startDate === undefined) ? getDisplayDate() : createObj.startDate;
    var lookupSource = "";
    var ixnType = "";
    var mediaType = "";
    var startDate = createObj.startDate;
    var endDate = createObj.endDate;    
    var transferredFrom = (createObj.transferredFrom===undefined) ? "" : createObj.transferredFrom;
    var _FIELDNAME = (createObj.fieldName === undefined) ? "" : createObj.fieldName;
    var _FIELDVALUE = (createObj.fieldValue === undefined) ? "" : createObj.fieldValue;
    var _SFDCCASEID = (createObj.userData.sfdcCaseId === undefined) ? "" : createObj.userData.sfdcCaseId;
    _log("in createTask: createObj.displayActivity = " + createObj.displayActivity);
    var displayActivity = (createObj.displayActivity === undefined) ? "false" : createObj.displayActivity;
    _log("in createTask: displayActivity = " + displayActivity);
    switch (createObjType) {
        case "Voice":
            // if outbound then use destination as source
            if (createObj.calltype == "Outbound") {
                lookupSource = createObj.destination;
                //ixnType = "Outbound";
                mediaType = (createObj.mediatype === undefined) ? "" : createObj.mediatype;
                if(createObj.mediatype === undefined || createObj.mediatype === ""){
                	ixnType = "Voice-Outbound Dial"; 
                }
                else ixnType = "Voice-Outbound";
            }
            else {
                if (createObj.role == 'RoleOrigination') {
                    lookupSource = createObj.destination;
                    ixnType = "Voice-Outbound Dial";
                }
                else {
                    lookupSource = createObj.source;
                    ixnType = "Voice-Inbound";
                }
            }
            break;
        case "Email":        	
        	if(createObj.calltype == "Inbound" && createObj.source != undefined && createObj.source != ''){
        		lookupSource = createObj.source;
        		ixnType = "Email-Inbound";
        	}
        	else if(createObj.calltype == "Outbound" && createObj.destination != undefined && createObj.destination != ''){
        			lookupSource = createObj.destination;
        			ixnType = "Email-Outbound";
				 }
            break;
        case "Chat":
            lookupSource = createObj.source;
            ixnType = createObj.type;
            break;
        case "InteractionWorkItem":
            lookupSource = createObj.source;
            ixnType = createObj.type;
            mediaType = createObj.mediaType;
            break;
        case "Sms":
            lookupSource = createObj.source;
            ixnType = createObj.type;
            break;
        case "WebCallback":
            lookupSource = createObj.source;
            ixnType = createObj.type;
            displayDate = (createObj.userData.startDate === undefined) ? getDisplayDate() : createObj.userData.startDate;
            break;            
        case "OpenMedia":
            lookupSource = createObj.source;
            ixnType = createObj.mediaType;
            break;
        case "Social":
            lookupSource = createObj.source;
            ixnType = createObj.type;
            break;
        default:
            _log("activity not created for " + createObj.type);
            return;
    }

    if (objIdForActivity != "") {
        _log("createTask: " + ixnType + " using objIdForActivity " + objIdForActivity);
    }
    else {
        _log("createTask: " + ixnType + " using field " + _FIELDNAME + " to search for a value of " + _FIELDVALUE);
    }

    var _CALL_DURATION = (createObj.duration === undefined) ? "" : createObj.duration;
    var _IXNTYPE = ixnType;
    var _COMMENTS = (createObj.notes === undefined) ? "" : createObj.notes;
    //var _DISP = (createObj.userData.DispositionCode === undefined) ? "" :
    //    createObj.userData.DispositionCode;
    var _DISP = (createObj.dispositionCode === undefined) ? "" : createObj.dispositionCode;
    var _DNIS = (createObj.destination === undefined) ? "" : createObj.destination;
    var _GENESYSID = (createObj.id === undefined) ? "" : createObj.id;
    var _ANI = (createObj.source === undefined) ? "" : createObj.source;
    var _SFDC_OBJECT_ID = objIdForActivity;
    
    //email specific
    var _Attachment_Flag = (createObj.Attachment_Flag === undefined) ? "" : createObj.Attachment_Flag;
    var _EMAIL_DESC = (createObj.emailDescription === undefined) ? "" : createObj.emailDescription;
    if(_EMAIL_DESC != ""){
    	_EMAIL_DESC = "\n" + "***EMAIL***" + _EMAIL_DESC;
    }
    
    var _CHAT_TRANSCRIPT = (createObj.transcript === undefined) ? "" : createObj.transcript;
    if(_CHAT_TRANSCRIPT != ""){
    	_CHAT_TRANSCRIPT = "\n" + "***CHAT***" + "\n" + _CHAT_TRANSCRIPT;
    }
    
    var _SMS_TRANSCRIPT = (createObj.smstranscript === undefined) ? "" : createObj.smstranscript;
    if(_SMS_TRANSCRIPT != ""){
    	_SMS_TRANSCRIPT = "\n" + "***SMS***" + "\n" + _SMS_TRANSCRIPT;
    }    
    
    if(_COMMENTS != ""){
    	_COMMENTS = "*** NOTES ***" + "\n" + _COMMENTS;
    }
    if(_EMAIL_DESC != ""){
    		_COMMENTS = "\n" +_COMMENTS + _EMAIL_DESC;
    }
    if(_CHAT_TRANSCRIPT != ""){
    		_COMMENTS = "\n" +_COMMENTS + _CHAT_TRANSCRIPT;
    }
    if(_SMS_TRANSCRIPT != ""){
		_COMMENTS = "\n" +_COMMENTS + _SMS_TRANSCRIPT;
}    

    
    var _SFDC1value = (createObj.SFDC1value === undefined) ? "" : createObj.SFDC1value;
    var _SFDC2value = (createObj.SFDC2value === undefined) ? "" : createObj.SFDC2value;
    var _SFDC3value = (createObj.SFDC3value === undefined) ? "" : createObj.SFDC3value;
    var _SFDC4value = (createObj.SFDC4value === undefined) ? "" : createObj.SFDC4value;
    var _SFDC5value = (createObj.SFDC5value === undefined) ? "" : createObj.SFDC5value;
    var _SFDC1field = (createObj.SFDC1field === undefined) ? "" : createObj.SFDC1field;
    var _SFDC2field = (createObj.SFDC2field === undefined) ? "" : createObj.SFDC2field;
    var _SFDC3field = (createObj.SFDC3field === undefined) ? "" : createObj.SFDC3field;
    var _SFDC4field = (createObj.SFDC4field === undefined) ? "" : createObj.SFDC4field;
    var _SFDC5field = (createObj.SFDC5field === undefined) ? "" : createObj.SFDC5field;

    _log("creating task map");
    var mapActivity = {
    	"Call Duration": _CALL_DURATION,
        "IXN Type": _IXNTYPE,
        "Comments": _COMMENTS,
        "Disposition": _DISP, "DNIS": _DNIS,
        "GenesysId": _GENESYSID, "ANI": _ANI,
        "sfdc Object Id": _SFDC_OBJECT_ID,
        "SFDC1value": _SFDC1value, "SFDC2value": _SFDC2value, "SFDC3value": _SFDC3value,
        "SFDC4value": _SFDC4value, "SFDC5value": _SFDC5value,
        "SFDC1field": _SFDC1field, "SFDC2field": _SFDC2field, "SFDC3field": _SFDC3field,
        "SFDC4field": _SFDC4field, "SFDC5field": _SFDC5field,
        "Media Type": mediaType,
        "DATE": displayDate, 
        "fieldName" : _FIELDNAME, "fieldValue" : _FIELDVALUE,
        "StartDate": startDate, "EndDate": endDate,
        "TransferredFrom": transferredFrom,
        "sfdcCaseId" : _SFDCCASEID
    };
    
    var searchObjectType = (createObj.searchObjectType === undefined) ? "default" : createObj.searchObjectType;        
    _log("createTask  searchObjectType= " + searchObjectType);
    

    g_WorkspaceConnectorController.findActivity(createObj.id, function(taskID) {
	if(taskID != null){
		_log("Activity Found - updateActivity " + taskID);
		g_WorkspaceConnectorController.updateActivity(taskID,mapActivity, function(result, event) {
		_log("   updateActivity RESULT = " + result);
		if (result == "success"){
		    Salesforce.screenPopRefresh(taskID);
	        if(_Attachment_Flag == 'True'){
	            	_log("Get attachment info on update activity");
		        	//Attachment info is in the form of :
		        	//	"attachments": [
		            //		{"id":"1", "name":"a.zip", "desc":"file a", "mimeType":"gzip"},
		            //		{"id":"2", "name":"b.zip", "desc":"file b", "mimeType":"gzip"}
		        	//	]
		
		            var attachmentInfo = createObj.attachments;
		            _log("Get attachment info on update activity displayActivity=" + displayActivity);
		            getAttachment(attachmentInfo,createObj.id,0,taskID, displayActivity);
	            }
			}
		});
		return;
	}
	else{
	    _log("Activity Not Found - create Activity");
	    g_WorkspaceConnectorController.createActivity(mapActivity, searchObjectType, function(result, event) {
	        _log("createActivity RESULT = " + result);

	        if (result != null && result != "not found") {
	            _log("new activity is created - " + result + " displayActivity = " + displayActivity);
	            
	            //MSavoj 02/07/2017 - The option is added to manage the display/hide of activity when an interaction is accepted/answered
	            if (displayActivity.toLowerCase() == 'true'){
	        	_log("Pop the new activity");
	        	Salesforce.screenPopRefresh(result);	
	            }
	            else{
	        	//Refresh the search result that this activity is associated with to make sure the new activity is displayed
	        	if(_SFDC_OBJECT_ID != undefined && _SFDC_OBJECT_ID != ""){
	        	    Salesforce.screenPopRefresh(_SFDC_OBJECT_ID);
	        	}
	            }
	        	
	            
	            if(_Attachment_Flag == 'True'){
	            	_log("Get attachment info on create activity");
		        	//Attachment info is in the form of :
		        	//	"attachments": [
		            //		{"id":"1", "name":"a.zip", "desc":"file a", "mimeType":"gzip"},
		            //		{"id":"2", "name":"b.zip", "desc":"file b", "mimeType":"gzip"}
		        	//	]
		
	            	var attachmentInfo = createObj.attachments;
	            	_log("Get attachment info on create activity displayActivity=" + displayActivity);
	            	getAttachment(attachmentInfo,createObj.id,0,result, displayActivity);
	            }
	        }
	        else {
	            _log("Could not create task for");
	        }
	    	if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
	    	{
	    		window.sessionStorage.setItem("Genesys_activeInteraction", "");
	    		_log("resetting Genesys_activeInteraction ");
	    	}
	    });  
	}
	
    }); 
    
}

function getAttachment(arrAttachId,interactionId,idx,myTaskID, redirectToTaskID){
	_log("in getAttachment");
    
    if(arrAttachId.length > idx ){
    	var wsParams = Workspace.getParameters();	
    	var msgJ;
    	if(arrAttachId.length == (idx+1))
    		//final request
    		msgJ = '{"action":"RequestAttachment",' + wsParams.CI_connectionData + ',"actionData":{"id":"' + interactionId + '","attachmentID":"' + arrAttachId[idx].id + '","attachmentName":"' + arrAttachId[idx].name + '","finalRequest":"true"}}';
    	else
    		msgJ = '{"action":"RequestAttachment",' + wsParams.CI_connectionData + ',"actionData":{"id":"' + interactionId + '","attachmentID":"' + arrAttachId[idx].id + '","attachmentName":"' + arrAttachId[idx].name + '"}}';
    	
        //this.requestUrl = wsParams.pollUrl + ":" + wsParams.pollPort + "/request=" + msgJ;
    	//_log("getAttachment url = " + this.requestUrl);
        this.requestUrl = wsParams.pollUrl + ":" + wsParams.pollPort;
        _log("getAttachment data = " + msgJ);
	    $.ajax({
	        url: requestUrl,
	        data: "/request=" + msgJ,
	        timeout: 20000,
	        async: true,
	        crossDomain: true,
	        cache: false,
	        //dataType: 'text',
	        dataType: 'jsonp',
	        success: function (data) {
	            // call the callback on retrieval

            	//setup first time call info
    			var attachmentInfo = arrAttachId[idx];
    			attachmentInfo.positionIndex = 0;
    			var attachmentId = null;
    			uploadAttachment(attachmentId,data,attachmentInfo,myTaskID, redirectToTaskID);
    			getAttachment(arrAttachId,interactionId,idx+1,myTaskID, redirectToTaskID);
        	},
	        error: function (xhr, ajaxOptions, thrownError) {
	            if (thrownError == 'timeout')
	                _log("Failed to connect for attachment request");
	            else
	                _log('Request error ' + xhr.status + ' ' + thrownError);
	        }
	    });
    }
}

/*
* Process the attachment data response
*/


var maxStringSize = 6000000;    //Maximum String size is 6,000,000 characters
var maxFileSize =   4350000;    
var chunkSize =      950000;    //Maximum Javascript Remoting message size is 1,000,000 characters


function uploadAttachment(attachmentId,attachmentData,attachmentInfo,myTaskID, redirectToTaskID) {
    var attachmentBody = "";
    //var descriptionText = "";
    //var nameText = "";
    //var mimeType = "";
    var doneUploading = false;
    var positionIndex = attachmentInfo.positionIndex;
    var attachment = (attachmentData.attachment === undefined) ? "" : attachmentData.attachment;
    var descriptionText = (attachmentInfo.desc === undefined) ? "" : attachmentInfo.desc;
    var nameText = (attachmentInfo.name === undefined) ? "" : attachmentInfo.name;
    var mimeType = (attachmentInfo.mimeType === undefined) ? "" : attachmentInfo.mimeType;
    var fileSize = attachment.length;
    _log("uploadAttachment " + nameText + ", fileSize = " + fileSize);
    //temporary check to prevent this APEX error
    // String length exceeds maximum: 6000000
    if(fileSize > maxStringSize){
    	_log("error adding attachment - String length exceeds maximum: 6000000");
    	return;
    }
    
    _log("mimeType = " + mimeType);
    if(fileSize <= positionIndex + chunkSize) {
      attachmentBody = attachment.substring(positionIndex);
      doneUploading = true;
    } else {
      attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
    }
    

    _log("Uploading " + attachmentBody.length + " chars of " + fileSize);
    _log("myTaskID: " + myTaskID + " descriptionText: " + descriptionText + " nameText: " + nameText + " mimeType: " + mimeType + "attachmentId: "  + attachmentId);
    g_WorkspaceConnectorController.addAttachment(myTaskID,descriptionText,nameText,mimeType,attachmentBody,attachmentId, function(result){
    	_log("addAttachment result = " + result);
    	if(result != null && result != "error") {
        	//OOP = Attachment
          if(result.substring(0,3) == '00P') { 
            if(doneUploading == true) {
              _log("doneUploading");
              _log("redirectToTaskID is based on the flag for displaying the activity redirectToTaskID=" + redirectToTaskID);
              if (redirectToTaskID === undefined || redirectToTaskID.toLowerCase() == 'true' ){
        	  _log("screenpop the task = " + myTaskID);
        	  Salesforce.screenPopRefresh(myTaskID);
              }
            } else {
              _log("continueUploading");             
              attachmentInfo.positionIndex += chunkSize; 
              _log("total uploaded so far = " + attachmentInfo.positionIndex);              
               uploadAttachment(result,attachmentData,attachmentInfo,myTaskID, redirectToTaskID);
            }
          }
        } else {
          _log("error adding attachment");
        }
      }
    );
  }

var tabId = function tabId(result){
		_log("tabId result = "+result.id);
		sforce.console.refreshPrimaryTabById(result.id,true,function(refreshResult){
			_log("refreshPrimaryTabById result = "+refreshResult.success);
		});
}



})(window, jQuery, undefined);
