/*
Initialization sequence
Every other object will register its initialization function on load to be called later from Connector object (late binding).
Caveat: we may face circular dependencies here.

jquery.subscribe plugin will be used for subscriber/publisher model.

Listens to events:
"workpace/connectionAccepted"
"workspace/connected"
"workspace/disconnected"

Needs bindings:
checkPrimaryTab
checkSubTab

*/

(function(window, jQuery, undefined) {

var _log = Log ? Log.log : console.log;

var initFunctions = []; // [function, ...]

var version = getVersion();

var debugInfoVisible = false;
var logVisible = true;
var attachedDataVisible = false;
var statusConnected = false;
var initCompleted = false;

//CI Connection Information
var connectionDate = new Date().getTime();
connectionDate = connectionDate + "a";
var CI_connectionData = '"CI":"' + connectionDate + '"';
var connectionTimeout;

var clickToDialNum = "";

function registerInitFn(initFn) {
	// todo
}

function init() {
    _log("Version = " + version);
    sforce.interaction.isInConsole(function (isCon) {
        if (isCon.result) {
        	Salesforce.setInServiceCloudConsole(true);
            _log('In Console');
        }
        else {
        	Salesforce.setInServiceCloudConsole(false);
            _log('Not in console');
        }
        var autoLoggingEnabled = getURLParam("autologgingenabled", "false");
        _log("autoLoggingEnabled from url = " + autoLoggingEnabled);
        if(autoLoggingEnabled.toLowerCase() == "true"){
        	Log.setStoreLog(true);
        	jQuery('#saveLog').attr('checked', true);
        	_log("Version = " + version);
        	_log("autoLoggingEnabled from url = " + autoLoggingEnabled);
        }

        var serviceCloudConsoleOnly = getURLParam("servicecloudconsoleonly", "notPresent");
        _log("serviceCloudConsoleOnly from url = " + serviceCloudConsoleOnly);
        if (serviceCloudConsoleOnly == "notPresent") {
            serviceCloudConsoleOnly = readCookie("wsc_serviceCloudConsoleOnly");
            _log("serviceCloudConsoleOnly from cookie = " + serviceCloudConsoleOnly);
            //Returns 0 if no cookie found
            //A fix due to not working properly for classic mode when no information is found in cookies 
            //if (serviceCloudConsoleOnly == 0) {
            	//default value is true
             //   serviceCloudConsoleOnly = "true";
            //}
            
            if (serviceCloudConsoleOnly == 0) {
            	if (isCon.result)
            	    serviceCloudConsoleOnly = "true";
            	else
            	    serviceCloudConsoleOnly = "false";
            }
        }
        else {
            createCookie("wsc_serviceCloudConsoleOnly", serviceCloudConsoleOnly, 1);
        }
        _log('serviceCloudConsoleOnly = ' + serviceCloudConsoleOnly);
        try {
            if ((serviceCloudConsoleOnly == "false") || (serviceCloudConsoleOnly && Salesforce.inServiceCloudConsole())) {
                initLogo();
                initCallCenter();
                jQuery.subscribe("workspace/connectionAccepted", connectionInitialized, []); 
				jQuery.subscribe("workspace/connected", showConnectedStatus, [true]);
			    jQuery.subscribe("workspace/disconnected", showConnectedStatus, [false]);
            }
            else {
                sforce.interaction.cti.setSoftphoneHeight(0);
            }
            sforce.console.setCustomConsoleComponentButtonText('Workspace Plug-in');
            sforce.console.setCustomConsoleComponentButtonStyle('.font {color:black;}');
            //sforce.console.setCustomConsoleComponentButtonStyle('background:#ff3b3b;'); //initially red
            sforce.console.setCustomConsoleComponentButtonStyle('background:#F27878;'); //initially red  
        }
        catch (e) {
        	_log("Could not initialize Connector: " + e);
        }
    });
}

function initLogo() {
    jQuery('#logoTd').html('<img src="' + g_resources["logo"] + '">');
    
    sforce.interaction.isInConsole(function (isCon) {
        if (isCon.result) {
		sforce.interaction.cti.setSoftphoneHeight(28);
		sforce.interaction.cti.setSoftphoneWidth(200);
        }
        else {
		sforce.interaction.cti.setSoftphoneHeight(28);
        }
    });    
}

function getOption(callCenterDefinition, optionName, defValue) {
	var value = callCenterDefinition['/WorkspaceOptions/' + optionName];
    if (value) {
        _log("getOption: " + optionName + ": " + value);
        return value;
    } else {
    	_log("getOption: " + optionName + " (default): " + defValue);
    	return defValue;
    }
}

function initCallCenter() {
    // set defaults
    var useLocalHost = true;
    var pollURL = "http://localhost";
    var url127 = "http://127.0.0.1";
    var pollURLHTTPS = "https://localhost";
    var url127HTTPS = "https://127.0.0.1";
    var useHTTPS = 'false';
    var pollPort = "0";
    var pollQueueTimeout = 100;
    var pollQueueTimeoutError = 500;
    //var requestPort = 5051;
    var requestTimeout = 5000;

    pollPort = getURLParam("port", pollPort);
    //requestPort = getURLParam("requestport", requestPort);
    _log('pollPort from URL - ' + pollPort);
    //_log('requestPort from URL - ' + requestPort);

    //if no port from url, get them from the cookie
    if (pollPort == "0") {
        pollPort = readCookie("wsc_pollPort");
        //requestPort = readCookie("wsc_requestPort");
        _log('pollPort from cookie - ' + pollPort);
        //_log('requestPort from cookie - ' + requestPort);
    }

    sforce.interaction.cti.getCallCenterSettings(function(response) {
        _log('getCallCenterSettings - ' + response.result);
        var callCenterDefinition = jQuery.parseJSON(response.result);

		useLocalHost = getOption(callCenterDefinition, "UseLocalHost", useLocalHost);
		if (pollPort == "0") {
			pollPort = getOption(callCenterDefinition, "PollPort", "5050");
		}
		pollQueueTimeout = getOption(callCenterDefinition, "PollQueueTimeout", pollQueueTimeout);
		pollQueueTimeoutError = getOption(callCenterDefinition, "PollQueueTimeoutError", pollQueueTimeoutError);
		//requestPort = getOption(callCenterDefinition, "RequestPort", "5051");
		requestTimeout = getOption(callCenterDefinition, "RequestTimeout", requestTimeout);
		useHTTPS = getOption(callCenterDefinition, "SecureConnection", useHTTPS);

		if (useLocalHost === 'false') {
			if(useHTTPS === 'false')
				pollURL = url127;
			else
				pollURL = url127HTTPS;
        }
		else {
			if(useHTTPS === 'false')
				pollURL = pollURL;
			else
				pollURL = pollURLHTTPS;
		}
        _log('getCallCenterSettings: pollURL - ' + pollURL);


        // if the port value is valid store the port information into a cookie
        if (pollPort != 0) {
            createCookie("wsc_pollPort", pollPort, 1);
            //createCookie("wsc_requestPort", requestPort, 1);
        }

	//To track CI_connectionData for classic mode
	if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
	{
		var sessionInfo = window.sessionStorage.getItem("Genesys_sfdc_CI");
		if(sessionInfo!=null)
		{
			CI_connectionData = sessionInfo;				
			connectionDate = CI_connectionData.substring(CI_connectionData.lastIndexOf(':"')+2, CI_connectionData.lastIndexOf('"'));
		}
		else
			window.sessionStorage.setItem("Genesys_sfdc_CI", CI_connectionData);
	}

        Workspace.setParameters({
			"pollUrl": pollURL,
			"pollPort": pollPort,
			//"requestPort": requestPort,
			"requestTimeout": requestTimeout,
			"pollQueueTimeout": pollQueueTimeout,
			"pollQueueTimeoutError": pollQueueTimeoutError,
			"CI_connectionData": CI_connectionData
		});
        // start out in disconnect state 
        showConnectedStatus(false);

        // Initialize logging UI
        showLog(true);
        
        //Do not retry a connection with this window if we've been rejected already
        var canConnect = true;
        if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
        {
        	canConnect = window.sessionStorage.getItem("Genesys_sfdc_Banned");
        }
        if(canConnect==null || canConnect==true)
        {
	        //don't continue until a Connection Accepted message is received
	        Workspace.requestConnection();
        }
        else
        {
        	_log('This browser session was already denied.');
        }        
    });
}

//handle response from workspace
function connectionInitialized(){
    _log("connectionInitialized");
    _log('Start polling');
    Workspace.poll(100); 
    _log('Polling started');
    if (!initCompleted) {
    	canCommunicate();
    	initCompleted = true;
    } 
}

//if we are tracking the selected object
function trackFocusedObject()
{
    _log('trackFocusedObject started');
    sforce.interaction.getPageInfo(function(o) {
	if(o!=null && o.result!=null)
	{ 
	    _log('trackFocusedObject o.result=' + o.result);
	    var jsonResult = jQuery.parseJSON(o.result);
	    if(jsonResult!=null && jsonResult.objectId!=null)
	    {
		_log('trackFocusedObject jsonResult=' + jsonResult);
		var objectId = jsonResult.objectId;
		_log("trackFocusedObject Object selected= " + objectId);
		if (objectId != '') {
		    Workspace.sendFocusChange(objectId,false);
		}
	    }
	}
    });

}

// connection is made, enable features
function canCommunicate() {
    var dialListener = function (response) {
        if (response.result == null) {
            return;
        }

        var result = JSON.parse(response.result);
        var numberToCall = result.number;
        var objectId = result.objectId;

        // Keep formatting - workspace will take care of removing chars based on
        // expression.phone-number.supported-characters 
        //numberToCall = numberToCall.replace(/\D/g, '');

        var msg = {
            action: 'Dial',
            CI : connectionDate,
            actionData: { number: numberToCall, sfdcObjectId: objectId  }
        };
        clickToDialNum = numberToCall;
        _log("clickToDialNum = " + clickToDialNum);
        Workspace.send(JSON.stringify(msg));
    };
    sforce.interaction.cti.onClickToDial(dialListener);


    sforce.interaction.cti.enableClickToDial(function (response) {
        _log("ClickToDial = " + response.result);
    });

    var subEventHandler = function (result) {
        _log("Focus changed to a different subtab. ID is:"
            + result.id + "and object Id is:" + result.objectId);
        // determine if we are going to send to Workspace
        checkSubTab(result.objectId, "opened");
        /* 
        var genesysId = window.sessionStorage.getItem("Genesys_activeInteraction");
		var newData = '{"sfdcObjectId":"' + result.objectId + '","id":"' + genesysId + '"}';
		Workspace.sendAttachData(newData);
       */
    };
    var primaryEventHandler = function (result) {
        _log("Focus changed to a different primary tab. ID is:"
            + result.id + "and the object Id is:" + result.objectId);
        // determine if we are going to send to Workspace
        checkPrimaryTab(result.objectId, "opened");
        /* 
        var genesysId = window.sessionStorage.getItem("Genesys_activeInteraction");
		var newData = '{"sfdcObjectId":"' + result.objectId + '","id":"' + genesysId + '"}';
		Workspace.sendAttachData(newData);
       */
    };

    if (Salesforce.inServiceCloudConsole()) {
        //Add a listener for the 'CTIEvent' event type
        sforce.console.addEventListener('CTIEvent', receiveSFMessage);
        sforce.console.addEventListener('g_pluginRequest', receivedClientReqMessage);
        sforce.console.onFocusedPrimaryTab(primaryEventHandler);
        sforce.console.onFocusedSubtab(subEventHandler);
    }

    //window.addEventListener('message', receiveWindowMessage, false);
    
    if (!Salesforce.inServiceCloudConsole()) {
        //If not in service cloud console, the search function must store the
        //agent selection becasue when the agent
        //selects an entry from the search, it causes a refresh and the Connector
        //is re-initialized. The Connector needs to check if there is anything
        //saaved to send it to workspace
        if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null){
        	var genesysId = window.sessionStorage.getItem("Genesys_sfdc_interactionId");
        	var sfdcId = window.sessionStorage.getItem("Genesys_sfdc_objectId");
        	_log("Session data genesysId = " + genesysId + " , sfdcId = " + sfdcId);
        	if(genesysId != null && genesysId != "" && sfdcId != null && sfdcId != "")
        	{
        		var newData = '{"sfdcObjectId":"' + sfdcId + '","id":"' + genesysId + '"}';
        		Workspace.sendAttachData(newData);
            	window.sessionStorage.setItem("Genesys_sfdc_interactionId","");
            	window.sessionStorage.setItem("Genesys_sfdc_objectId","");	
        	}
        }
      //@Msavoj : 04/11/2017 - Find a new way to map the interaction id to tab id    
        ////???????? check Genesys_sfdc_interactionId vs Genesys_activeInteraction 
        //showInteractionByTabId(objID);
        ////
        trackFocusedObject();//if we are tracking the currently selected object, this is for classic mode
    }
}

////////////////////////////////////////////////////////////////////////////////////////
// *** Request received from other VF pages **** //
////////////////////////////////////////////////////////////////////////////////////////

// todo change to event subscription
function receiveSFMessage(result) {
    //receive message from Salesforce fireEvent
    //var myObj = eval('(' + result.message + ')');
    var myObj = JSON.parse(result.message);
    _log("receiveSFMessage CTIEvent = " + myObj.action);
    if (myObj.action == "ObjectSelected") {
        processObjectSelected(result.message);
    }
    if (myObj.action == "AttachData") {
    	myObj.CI = connectionDate;
        _log("Calling processAttachData with " + JSON.stringify(myObj));
        //Workspace.processAttachData(result.message);
        Workspace.processAttachData(JSON.stringify(myObj));
    }
    if (myObj.action == "MarkDone") {
    	myObj.CI = connectionDate;
        _log("Calling processMarkDone with " + JSON.stringify(myObj));
        //Workspace.processAttachData(result.message);
        Workspace.processMarkDone(JSON.stringify(myObj));
    }
}

function receivedClientReqMessage(result){
	_log("in receivedClientReqMessage");
	//Client.processClientReqMessage(result);
	jQuery.publish("client/req_message", [result]);
}

// todo change to event subscription
function receiveWindowMessage(event) {
    //receive message from window listener
    //_log("receiveWindowMessage = " + event.data);
    var s = event.data;
    var n = s.indexOf("AttachData");
    if (n > -1) {
    	_log("receiveWindowMessage = " + s);
    	var msg = jQuery.parseJSON(s);
        msg.CI = connectionDate;
        _log("Calling processAttachData with " + JSON.stringify(msg));
        Workspace.processAttachData(JSON.stringify(msg));
        return;
    }
    n = s.indexOf("MarkDone");
    if (n > -1) {
    	_log("receiveWindowMessage = " + s);
    	var msg = jQuery.parseJSON(s);
        msg.CI = connectionDate;
        _log("Calling processMarkDone with " + JSON.stringify(msg));
        Workspace.processMarkDone(JSON.stringify(msg));
        return;
    } 
    n = s.indexOf("GetInteractions");
    if(n> -1){
    	_log("GOT MESSAGE");
    }
    //_log("receiveWindowMessage no processing");
}

function showInteractionByTabId(tabId) {
    if (tabId == null) {
        _log('showInteractionByTabId: tabId is null');
        return;
    }
    _log("showInteractionByTabId: tabId is not null");
    var ixnId = Salesforce.getIxnId(tabId);
    if (!ixnId) {
        _log('showInteractionByTabId: could not find match');
        return;
    }
    _log('showInteractionByTabId: found match, sending to IWS');
    //Workspace.send('{"action":"ShowInteraction","actionData":{"interactionId":"' + ixnId + '"}}');
    var msg = {
         	action : 'ShowInteraction',
         	CI : connectionDate,
         	actionData : { "interactionId":ixnId }
    };
    Workspace.send(JSON.stringify(msg));
}

// todo change to event subscription
//inform workspace of navigation to Account primary tab
function checkPrimaryTab(objID, actionPerformed) {
    _log('checkPrimaryTab: find associated ixn Id for sfObject - '
        + objID + 'action - ' + actionPerformed);
    //TODO 
    //showInteractionByTabId(objID);
}

// todo change to event subscription
//inform workspace of navigation to Contact sub tab
function checkSubTab(objID) {
    _log('checkSubTab: find associated ixn Id for sfObject - ' + objID);
    //TODO
    //@Msavoj : 04/11/2017 - Find a new way to map the interaction id to tab id 
    
    //Option 1:  
    /*
    var ixnId = Salesforce.getIxnId(objID);
    if (!ixnId) {
        _log('checkSubTab: could not find match, use current active interaction id');
        var genesysId = window.sessionStorage.getItem("Genesys_activeInteraction");
        Salesforce.addIxnWindow(genesysId, objID);
    }
    else
	_log('checkSubTab: genesys interaction Id = ' + ixnId);
	*/
    //Option 2:
    //showInteractionByTabId(objID);
    //Added for changing focus 
    trackFocusedObject();
}

// todo change to event subscription
function processObjectSelected(result) {
    // Search page returns the following:
    var objSelected = JSON.parse(result);
    _log("processObjectSelected for " + objSelected.id);
    if (objSelected.id != '') {
        //inform workspace of SFobject id for subsequent use in activity creation and transfer
        //check for Case
    	if(objSelected.id.substring(0, 3) == '500'){
    		g_WorkspaceConnectorController.findContactFromcase(objSelected.id, function(o) {
    			if (o != null) {
    				//screen pop the contact
    				//sforce.console.openPrimaryTab(null, "/"+o,true);
    				Salesforce.screenPop(o);
    				var newData = '{"sfdcObjectId":"' + o + '","id":"' + objSelected.interactionId + '"}';
    				Workspace.sendAttachData(newData);
    		        var newData = '{"sfdcCaseId":"' + objSelected.id + '","id":"' + objSelected.interactionId + '"}';
    		        Workspace.sendAttachData(newData);
    			}
    			else {
    		        var newData = '{"sfdcObjectId":"' + objSelected.id + '","id":"' + objSelected.interactionId + '"}';
    		        Workspace.sendAttachData(newData);
    			}
    		});
    	}
    	else{
	        var newData = '{"sfdcObjectId":"' + objSelected.id + '","id":"' + objSelected.interactionId + '"}';
	        Workspace.sendAttachData(newData);
    	}
        //Salesforce.addIxnWindow(objSelected.interactionId, objSelected.id);
    }
}


////////////////////////////////////////////////////////////////////////////////////////
// *** MISC Functions **** //
////////////////////////////////////////////////////////////////////////////////////////

function getIconName(connected, debugInfoVisible) {
	return (debugInfoVisible ? "minus" : "plus") + "_" + (connected ? "green" : "red");
}

function updateLogElement() {
    Log.setLogElementId((debugInfoVisible && logVisible) ? "log" : null); // Stop Log writing to page element
}

function updateSize() {
	var w = debugInfoVisible ? 300 : 200;
	var h = jQuery("#title").outerHeight();

	if (attachedDataVisible) {
		var adh = jQuery("#attDataHeader").outerHeight() * 3;
		h += Math.min(adh, jQuery("#attDataContent").outerHeight());
		w = 300;
	}
	
	if (debugInfoVisible) {
		h += jQuery("#portStatus").outerHeight();
		h += jQuery("#logHeader").outerHeight();
		if (logVisible) {
			h += 235; // Log text div
		}
	}

    sforce.interaction.isInConsole(function (isCon) {
        if (isCon.result) {
			sforce.interaction.cti.setSoftphoneHeight(h);
			sforce.interaction.cti.setSoftphoneWidth(w);
        }
        else {
			sforce.interaction.cti.setSoftphoneHeight(h);
        }
    });    
}

function showConnectedStatus(connected) {
    //_log("showConnectedStatus statusConnected = " + statusConnected);
    //_log("showConnectedStatus debugInfoVisible = " + debugInfoVisible);
    //_log("showConnectedStatus connected = " + connected);

    statusConnected = connected;

//    var iconName = getIconName(connected, debugInfoVisible);
//    var imgUrl = jQuery(iconName).html();
    var iconName = getIconName(connected, debugInfoVisible);
    jQuery('#statusTd').html('<img id="debugInfoButton" style="cursor:pointer;" src="' + g_resources[iconName] + '">');
    jQuery('#debugInfoButton').click(switchDebugInfo);

    // todo move to CSS
    //var buttonStyle = statusConnected ? 'background:#53e675;' : 'background:#ff3b3b;'; // green : red
    var buttonStyle = statusConnected ? 'background:#AFF2AF;' : 'background:#F27878;'; // green : red
	sforce.console.setCustomConsoleComponentButtonStyle(buttonStyle);
}

function switchDebugInfo() {
	showDebugInfo(!debugInfoVisible);
}

function showDebugInfo(newDebugInfoVisible) {
    //_log("showDebugInfo statusConnected = " + statusConnected);
    //_log("showDebugInfo debugInfoVisible = " + debugInfoVisible);
    //_log("showDebugInfo newDebugInfoVisible = " + newDebugInfoVisible);

    var iconName = getIconName(statusConnected, newDebugInfoVisible);
//    var imgUrl = jQuery(iconName).html();
    jQuery('#statusTd').html('<img id="debugInfoButton" src="' + g_resources[iconName] + '">');
    jQuery('#debugInfoButton').click(switchDebugInfo);

    if (newDebugInfoVisible) {
        wsParams = Workspace.getParameters();
        jQuery('#portStatus').html("<span style='fontSize=8pt;'><b>Version: </b>" + version 
    		+ "<br>Port: " + wsParams.pollPort + "</style>");

        jQuery('#debug').show();
    }
    else {
        jQuery('#debug').hide();
    }

    debugInfoVisible = newDebugInfoVisible;

    updateLogElement();
    updateSize();
}

function switchLog() {
	showLog(!logVisible);
}

function showLog(newLogVisible) {
	var iconName;
	if (newLogVisible) {
		iconName = "minus_blue";
		jQuery("#logContainer").show();
	}
	else {
		iconName = "plus_blue";
		jQuery("#logContainer").hide();
	}

	jQuery("#logSwitchIcon").html('<img src="' + g_resources[iconName] + '">');

	logVisible = newLogVisible;

    updateLogElement();
    updateSize();
}

function showAttachedData(data) {
	var el = jQuery("#attDataContent");
	el.empty();

	if(data.length == 0){
		hideAttachedData();
		return;
	}
	var ud = new DataPanel(el, "en", true);
	ud.setData(data);

	jQuery("#attDataPanel").show();
	attachedDataVisible = true;
    updateSize();
}

function hideAttachedData() {
	jQuery("#attDataPanel").hide();
	jQuery("#attDataContent").empty();
	attachedDataVisible = false;
    updateSize();
}

// Publish API
var Connector = {
	"init": init,
	"registerInitFn": registerInitFn,
	"switchLog": switchLog,
	"showAttachedData": showAttachedData,
	"hideAttachedData": hideAttachedData
};

window["Connector"] = Connector;

jQuery(document).ready(function() { Connector.init(); });

})(window, jQuery, undefined);
