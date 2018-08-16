/*
Screen pop functions that open SF tabs, subtabs or browser tabs for certain types of SF objects.
Search functions that search for specified object types by specified criteria. 
	Search functions will return results to a callback function that decides how to act 
	(screen pop, display list, other action).
Receive click-to-dial, click-to-email events and route them via Events object.
Functions to enable/disable SF features (e.g. stop routing click-to events).
Functions to create new SF objects (allow hooks on before/after creation).

*/

(function(window, undefined) {

var _log = Log ? Log.log : console.log;

var _inServiceCloudConsole;
var ixnWindows = []; // interaction ID -> SF Tab object ID

////////////////////////////////////////////////////////////////////////////////////////
// *** Search Handling **** //
////////////////////////////////////////////////////////////////////////////////////////


function openSearch(searchField, ixnId) {
    _log("openSearch for " + searchField);
    var Jsearch = "";
    if(searchField != null && searchField != ""){	
	Jsearch = JSON.stringify(searchField);
	Jsearch = Jsearch.replace(/&amp;/g, 'MyAmpersand');
	Jsearch = Jsearch.replace(/&#39;/g, 'SingleQuote');
	Jsearch = Jsearch.replace(/&plus;/g, 'MyPlus');
    }
    
    var url = "apex/g_CustomLookup?lksrch=" + Jsearch + "&ixnId=" + ixnId 
    	+ "&inServiceCloudConsole=" + inServiceCloudConsole();
    _log("openSearch url = " + url);

    screenPop(url, "Search");
}


function openSearchByFields(searchFieldName, searchFieldValue, ixnId){
    _log("openSearchByFields for " + searchFieldName + " and " + searchFieldValue);
    var JsearchFieldName = "";
    if(searchFieldName != null && searchFieldName != ""){	
	JsearchFieldName = JSON.stringify(searchFieldName);
	JsearchFieldName = JsearchFieldName.replace(/&amp;/g, 'MyAmpersand');
	JsearchFieldName = JsearchFieldName.replace(/&#39;/g, 'SingleQuote');
	JsearchFieldName = JsearchFieldName.replace(/&plus;/g, 'MyPlus');
    }
    
    var JsearchFieldValue = "";
    if(searchFieldValue != null && searchFieldValue != ""){	
	JsearchFieldValue = JSON.stringify(searchFieldValue);
	JsearchFieldValue = JsearchFieldValue.replace(/&amp;/g, 'MyAmpersand');
	JsearchFieldValue = JsearchFieldValue.replace(/&#39;/g, 'SingleQuote');
	JsearchFieldValue = JsearchFieldValue.replace(/&plus;/g, 'MyPlus');
    }    
    
    
    var Jsearch = "";
    _log("openSearch for searchFieldName: " + JsearchFieldName + "  and searchFieldValue:" + JsearchFieldValue);
    var url = "apex/g_CustomLookup?lksrch=&searchFieldName=" + JsearchFieldName + "&searchFieldValue=" + JsearchFieldValue + "&ixnId=" + ixnId 
    	+ "&inServiceCloudConsole=" + inServiceCloudConsole();
    _log("openSearchByFields url = " + url);

    screenPop(url, "Search");
    
}

function openSearchByFieldsMap(searchMap, ixnId){
    _log("openSearchByFieldsMap");
    var JsearchFieldsMap = "";
    if(searchMap != null ){	
	JsearchFieldsMap = JSON.stringify(searchMap);
	JsearchFieldsMap = JsearchFieldsMap.replace(/&amp;/g, 'MyAmpersand');
	JsearchFieldsMap = JsearchFieldsMap.replace(/&#39;/g, 'SingleQuote');
	JsearchFieldsMap = JsearchFieldsMap.replace(/&plus;/g, 'MyPlus');
    }

    _log("openSearch for openSearchByFieldsMap: " + JsearchFieldsMap);
    var url = "apex/g_CustomLookup?lksrch=&searchFieldsMap=" + JsearchFieldsMap  + "&ixnId=" + ixnId 
    	+ "&inServiceCloudConsole=" + inServiceCloudConsole();
    _log("openSearchByFieldsMap url = " + url);

    screenPop(url, "Search");
    
}

function openSearchAccount(searchField, ixnId, searchObjectType,lookupNumber) {
    _log("openSearchAccount");
    var Jsearch = "";
    if(searchField != null && searchField != ""){	
	Jsearch = JSON.stringify(searchField);
	Jsearch = Jsearch.replace(/&amp;/g, 'MyAmpersand');
	Jsearch = Jsearch.replace(/&#39;/g, 'SingleQuote');
	Jsearch = Jsearch.replace(/&plus;/g, 'MyPlus');
    }
    
    var url = "apex/g_CustomAccountLookup?lksrch=" + Jsearch + "&ixnId=" + ixnId	
    	+ "&inServiceCloudConsole=" + inServiceCloudConsole()
    	+ "&searchObjectType=" + searchObjectType+ "&lookupNumber=" + lookupNumber;

    _log("openSearchAccount url = " + url); 
    screenPop(url, "Account Search");   
}
    

function openSearchCase(searchField, ixnId) {
    _log("openSearchCase for " + searchField);
    var Jsearch = "";
    if(searchField != null && searchField != ""){	
	Jsearch = JSON.stringify(searchField);
	Jsearch = Jsearch.replace(/&amp;/g, 'MyAmpersand');
	Jsearch = Jsearch.replace(/&#39;/g, 'SingleQuote');
	Jsearch = Jsearch.replace(/&plus;/g, 'MyPlus');
    }    

    var url = "apex/g_CustomCaseLookup?lksrch=" + Jsearch + "&ixnId=" + ixnId + "&inServiceCloudConsole=" + inServiceCloudConsole();
    _log("openSearchCase url = " + url);

    screenPop(url, "Search");
}

// url should not include leading slash, "/".
// url may consist of SF Object ID only.
function screenPop(url, caseNumber) {
	url = "/" + url;
    if (inServiceCloudConsole()) {
        sforce.console.openPrimaryTab(null, url, true, caseNumber);
    }
    else {
        sforce.interaction.screenPop(url, function(response) {});
    }
}

function refreshPrimaryTab(result) {
    if (result.id != null) {
        _log("refreshPrimaryTab result.id = " + result.id);
        sforce.console.refreshPrimaryTabById(result.id, false);
    }
}

function screenPopRefresh(url, caseNumber) {
	url = "/" + url;
    if (inServiceCloudConsole()) {
        sforce.console.openPrimaryTab(null, url, true, caseNumber);
        _log("getTabID for refresh");
        sforce.console.getFocusedPrimaryTabId(refreshPrimaryTab);
    }
    else {
        sforce.interaction.screenPop(url, function(response) {});
    }
}

function consolePop(url, caseNumber) {
    if (inServiceCloudConsole()) {
        sforce.console.openPrimaryTab(null, "/" + url, true, caseNumber);
    }
}

// returns true if screen pop performed
function screenPopUser(obj) {
    // check for attached data sfdcObjectId - if it is already there, then pop that
    var id = obj.userData.sfdcObjectId;
    if (id !== undefined) {
        _log("sfdcObjectId = " + id);
        screenPop(id);
        return true;
    }
    return false;
}

function inServiceCloudConsole() {
	return _inServiceCloudConsole;
}

function setInServiceCloudConsole(inConsole) {
	_inServiceCloudConsole = inConsole;
}

////////////////////////////////////////////////////////////////////////////////////////
// Interaction Windows (tabs) tracking
////////////////////////////////////////////////////////////////////////////////////////

function addIxnWindow(ixnId, tabId) {
	/* TODO
	_log("addIxnWindow - " + ixnId + ", " + tabId);
	ixnWindows[ixnId] = tabId;
	*/
}

function removeIxnWindow(ixnId) {
	/* TODO
	_log("removeIxnWindow - " + ixnId);
	delete ixnWindows[ixnId];
	*/
}

function getIxnTabId(ixnId) {
	_log("getIxnTabId from ixnWindow - " + ixnId);
	return ixnWindows[ixnId];
}

function getIxnId(tabId) {
	_log("getIxnId from ixnWindow - " + tabId);
	var index = jQuery.inArray(tabId, ixnWindows);
	for (var id in ixnWindows) {
		  if (ixnWindows.hasOwnProperty(id)) { 
		    _log("id: " + id + " value: " + ixnWindows[id])
		    if(ixnWindows[id].indexOf(tabId) > -1){
		    	return id;
		    }
		  }
	}

	$.each(ixnWindows, function( k, v ) {
		_log( "Key: " + k + ", Value: " + v );
		});
	//return null;
	//@msavoj 04-011-2017
	//Associate tabId with the latest interaction Id
	if (index < 0)
	{
	    var genesysId = window.sessionStorage.getItem("Genesys_activeInteraction");
	    if(genesysId != undefined && genesysId != null){	    
		ixnWindows[genesysId] = tabId;
		index = genesysId;
	    }
	}
	//index is the Genesys Interaction Id
	return (index < 0) ? null : index;
}

// bring a primary tab to front
function focusIxnTab(ixnId) {
    _log("focusIxnTab for " + ixnId);
    var tabId = Salesforce.getIxnTabId(ixnId);
    if (tabId) {
    	Salesforce.consolePop(tabId);
    }
}

////////////////////////////////////////////////////////////////////////////////////////
//Using Salesforce search and search page
////////////////////////////////////////////////////////////////////////////////////////

function SF_SearchAndPop_inboundV(obj) {
	_log("SF_SearchAndPop_inboundV");
	var ANI = '';
	var OtherDN = '';
	if(obj.source != undefined && obj.source != '')
		ANI = obj.source;
	
	if(obj.OtherDN != undefined && obj.OtherDN != '')
		OtherDN = '';
	
	if(ANI == '' && OtherDN == '' ){
		//nothing to search
		SF_default_search(ANI);
		return;
	}	
	
	var multiFind = false;
	
	if(ANI != ''){
		sforce.interaction.searchAndScreenPop(ANI,'','inbound',function(response1) {
			if(response1.result && (response1.result.indexOf("Name")>-1) && ((response1.result.match(/Name/g).length > 1))){
				multiFind = true;
				_log('ANI search result = ' + response1.result);
			}
			if(!response1.error && response1.result != "{}" && !multiFind){
				_log("SF_search_and_pop success ANI");
			}  else {
			    _log("SF_search_and_pop fail");
			    multiFind = false;
			    if(OtherDN != ''){
			    	sforce.interaction.searchAndScreenPop(OtherDN,'','inbound',function(response2) {
			    		if(response2.result && (response2.result.indexOf("Name")>-1 )&& ((response2.result.match(/Name/g).length > 1))){
							multiFind = true;	
							_log('OtherDN search result = ' + response2.result);
						}
			    		if(!response2.error && response2.result != "{}" && !multiFind){
							_log("SF_search_and_pop success OtherDN");
						} 
			    		else
			    			SF_default_search(OtherDN);
			    	});
			    }
			    else
			    	//Screen pop failed for ANI and no OtherDN so pop default search
			    	SF_default_search(ANI);
			}
		});
	}
	else //ANI is blank, use OtherDN
	{
		sforce.interaction.searchAndScreenPop(OtherDN,'','inbound',function(response2) {
    		if(response2.result && (response2.result.indexOf("Name")>-1 )&& ((response2.result.match(/Name/g).length > 1))){
				multiFind = true;	
				_log('OtherDN search result (no ANI) = ' + response2.result);
			}
    		if(!response2.error && response2.result != "{}" && !multiFind){
				_log("SF_search_and_pop success OtherDN");
			} 
    		else
    			SF_default_search(OtherDN);
    	});
	}
	
}


function SF_SearchAndPop_outboundV(obj) {
	_log("SF_SearchAndPop_inboundV");
	var phoneField = '';
	if(obj.destination != undefined && obj.destination != '')
		phoneField = obj.destination;
	if(phoneField != ''){
		sforce.interaction.searchAndScreenPop(phoneField,'','inbound',function(response1) {
			if(response1.result && (response1.result.indexOf("Name")>-1) && ((response1.result.match(/Name/g).length > 1))){
				multiFind = true;
				_log('phoneField search result = ' + response1.result);
			}
    		if(!response1.error && response1.result != "{}" && !multiFind){
				_log("SF_search_and_pop success phoneField");
			} 
    		else
    			SF_default_search(phoneField);
		});
	}
	else
		SF_default_search(phoneField);
}

function SF_SearchAndPop_email(emailAddr){
	_log("SF_SearchAndPop_email");
	if(emailAddr != '') {
		sforce.interaction.searchAndGetScreenPopUrl(emailAddr, '','inbound', function(response) {
			//result for match = "{"003i0000019vXt5":{"Name":"Pat Thompson","object":"Contact","Title":""},"screenPopUrl":"/003i0000019vXt5"}"
			if(response.result){
				_log("URL = " + response.result);
				var jParse = JSON.parse(response.result);
				if(jParse.screenPopUrl!=null) {
					var numEntries=Object.keys(jParse).length;
					_log("numEntries = "+ numEntries);
					if(numEntries == 2){
						sforce.interaction.screenPop(jParse.screenPopUrl, function(response) {});
						return;
					}
				}
			}
			SF_default_search(emailAddr);
		});
	}
	else
		SF_default_search(emailAddr);
}


function SF_default_search(searchField){
	_log("SF_default_search");
	var url = '/_ui/search/ui/UnifiedSearchResults?isdtp=nv&searchType=2&sen=003&sen=00Q&searchType=2&str=' + searchField;
	sforce.interaction.screenPop(url, function(response) {});
}


var Salesforce = {
	"openSearch": openSearch,
	"openSearchByFields": openSearchByFields,
	"openSearchByFieldsMap": openSearchByFieldsMap,
	"openSearchAccount": openSearchAccount,
	"openSearchCase": openSearchCase,
	"screenPop": screenPop,
	"screenPopRefresh": screenPopRefresh,
	"consolePop": consolePop,
	"screenPopUser": screenPopUser,
	"inServiceCloudConsole": inServiceCloudConsole,
	"setInServiceCloudConsole": setInServiceCloudConsole,
	"addIxnWindow": addIxnWindow,
	"removeIxnWindow": removeIxnWindow,
	"getIxnTabId": getIxnTabId,
	"getIxnId": getIxnId,
	"focusIxnTab": focusIxnTab,
	"SF_SearchAndPop_inboundV": SF_SearchAndPop_inboundV,
	"SF_SearchAndPop_outboundV": SF_SearchAndPop_outboundV,
	"SF_SearchAndPop_email": SF_SearchAndPop_email
};

window["Salesforce"] = Salesforce;

})(window, undefined);
