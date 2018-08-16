/*
Maintain connection to IWS.
Receive and dispatch event from IWS (depends on Events).
Send requests to IWS.
Fire events on connection established/lost.

Events will be delivered via pub/sub model.
Events:
workspace/connected
	Indicates that connection to IWS is established. Fired on each poll of IWS.
workspace/disconnected
	Indicates that connection to IWS is not established. Fired on each poll of IWS.
workspace/message
	Notifies of message received from IWS.
*/

(function(window, jQuery, undefined) {

var _log = Log ? Log.log : console.log;

var pollUrl;
var pollPort;
//var requestPort;
var requestTimeout;
var pollQueueTimeout;
var pollQueueTimeoutError;
var connectionTimeout = '';
var CI_connectionData;
var businessAttributes = {};
var autoOpenDataDisplay = "true";
var monitorSFDCSession = false;

////////////////////////////////////////////////////////////////////////////////////////
// *** AJAX Functions **** //
////////////////////////////////////////////////////////////////////////////////////////

function setParameters(params) {
	pollUrl = params.pollUrl;
	pollPort = params.pollPort;
	//requestPort = params.requestPort;
	requestTimeout = params.requestTimeout;
	pollQueueTimeout = params.pollQueueTimeout;
	pollQueueTimeoutError = params.pollQueueTimeoutError;
	CI_connectionData = params.CI_connectionData;
}

function getParameters() {
	return {
		"pollUrl": pollUrl,
		"pollPort": pollPort,
		//"requestPort": requestPort,
		"requestTimeout": requestTimeout,
		"pollQueueTimeout": pollQueueTimeout,
		"pollQueueTimeoutError": pollQueueTimeoutError,
		"CI_connectionData": CI_connectionData
	};
}

function poll(timeout) {
    setTimeout(function () {
    	//If we are monitoring the Salesforce session
	if(monitorSFDCSession)
	{
	    g_WorkspaceConnectorController.testConnection(function(o) {
	        if (o == null) {
		    _log('Session expired, attempting to refresh connector');
		    document.location.reload();
		}
	    });
	}
        jQuery.ajax({
            url: pollUrl + ":" + pollPort + "/poll=" + "{" + CI_connectionData + "}" ,
            //url: pollUrl + ":" + pollPort + "/poll",
            timeout: requestTimeout,
            async: true,
            crossDomain: true,
            cache: false,
            dataType: 'jsonp',
            success: function(data) {
                if (data.action != 'NoWork') {
                    _log('JSON Received- ' + jQuery.param(data));
                    jQuery.publish("workspace/message", [data]);
                }

		//Track if the connection was denied so we don't keep retrying
		if (data.action != 'ConnectionDenied')
		{
                    poll(pollQueueTimeout);
                    jQuery.publish("workspace/connected", []);
		}
		else
		{
                    if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
                    {
                    	window.sessionStorage.setItem("Genesys_sfdc_Banned", "True");
                    }
                    jQuery.publish("workspace/disconnected", []);	            	
		}	   
            },
            error: function(xhr, ajaxOptions, thrownError) {
                _log('work request error (' + pollPort + ') ' + xhr.status + ' ' + thrownError);

                jQuery.publish("workspace/disconnected", []);

                if (thrownError == 'timeout') {
                    requestConnection();	//If we timeout, we should request a new connection in case Workspace has been restarted, not continue polling
                }
                else {
                    poll(pollQueueTimeout);
                }
            }
        });

    }, timeout);
}

function send(message) {
    _log("send Sending:" + message);
    jQuery.ajax({
        //url: pollUrl + ":" + requestPort + "/request=" + message,
    	//url: pollUrl + ":" + pollPort + "/request=" + message,
    	url: pollUrl + ":" + pollPort,
    	data:"/request=" + message,
    	type: 'GET',
    	processData: false,
        timeout: requestTimeout,
        async: false,
        crossDomain: true,
        cache: false,
        dataType: 'jsonp',
        success: function(data) {
            _log('Request sent - response = ' + data.action);
        },
        error: function(xhr, ajaxOptions, thrownError) {
            _log('Request sent error (' + pollPort + ') ' + ajaxOptions + ' - ' + xhr.status + ' ' + thrownError);
        }
    });
}

//request connection from workspace
function requestConnection() {
    var connectMsg = '{"action":"ConnectionRequest","actionData":{},"pollInterval":"' + pollQueueTimeout + '",' + CI_connectionData + '}';
    //var connectMsg = '{"action":"ConnectionRequest","actionData":{},"pollInterval":"' + pollQueueTimeoutError + '",' + CI_connectionData + '}';
    _log("Sending ConnectionRequest");
    jQuery.ajax({
    	//url: pollUrl + ":" + requestPort + "/request=" + connectMsg,
    	//url: pollUrl + ":" + pollPort + "/request=" + connectMsg,
    	url: pollUrl + ":" + pollPort,
    	data: "/request=" + connectMsg,
    	type: 'GET',
        timeout: requestTimeout,     
        async: true,
        crossDomain: true,
        cache: false,
        dataType: 'jsonp',
        success: function(data) {
    		_log('JSON Received requestConnection- ' + jQuery.param(data));
	    	if (data.action == 'ConnectionAccepted') {
	    		//Will we try to track the SalesForce session?
	    		if(data.monitorSFDCSession!=null && data.monitorSFDCSession=='true')
	    			monitorSFDCSession = true;
	    		else
	    			monitorSFDCSession = false;
	    		_log('Monitor Salesforce session: ' + monitorSFDCSession);
	    		
	    		stopTimer();
	            requestBusinessAttributes();
	        }
	        else if (data.action == 'ConnectionDenied'){ //Don't retry again if the session was denied
	            stopTimer();
	            _log('Connection denied, do not retry');
	            if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null)
	            {
	            	window.sessionStorage.setItem("Genesys_sfdc_Banned", "True");
	            }
	        }
	        else{ //ConnectionDenied
	            //start a timeout and try again
	            connectionTimeout = setTimeout('Workspace.requestConnection()', requestTimeout);
	        }
    	},
        error: function(xhr, ajaxOptions, thrownError) {
            _log('requestConnection error (' + pollPort + ') ' + xhr.status + ' ' + thrownError);
            connectionTimeout = setTimeout('Workspace.requestConnection()', requestTimeout);
        }
    });
} 

function stopTimer() {
	if (connectionTimeout != '') {
		clearTimeout(connectionTimeout);
	}
	connectionTimeout = '';
}

function notifyConnectionAccepted() {
	jQuery.publish("workspace/connectionAccepted", []);
}


//inform workspace so it can attach data
//input must be in JSON format
function processAttachData(objToProcess) {
    _log("processAttachData");
    //This request comes from Salesforce fireEvent or window listener
    send(objToProcess);
}

//inform workspace so it can attach data
//input must be in JSON format
function processMarkDone(objToProcess) {
	_log("processMarkDone");
	//This request comes from window listener
send(objToProcess);
}

function sendAttachData(newData) {
    _log("sendAttachData - " + newData);
    send('{"action":"AttachData",' + CI_connectionData + ',"actionData":' + newData + '}');
    var myObj = jQuery.parseJSON(newData);
    _log("   myObj.sfdcObjectId = " + myObj.sfdcObjectId);
    if(myObj.sfdcObjectId != undefined){
        if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null){
        	window.sessionStorage.setItem("Genesys_sfdc_objectId",myObj.sfdcObjectId);
        }
    }    	
}

function requestBusinessAttributes() {
    _log("Requesting Business Attributes");

    var message = '{"action":"GetData",' + CI_connectionData + ',"actionData":{"data":"data-display-attribute"}}';
    jQuery.ajax({
    	//url: pollUrl + ":" + pollPort + "/request=" + message,
    	url: pollUrl + ":" + pollPort,
    	data: "/request=" + message,
    	type: 'GET',
        timeout: requestTimeout,
        async: false,
        crossDomain: true,
        cache: false,
        dataType: 'jsonp',
        success: function(data) {
            _log('Request sent - response = ' + data.action);
            stopTimer();
            if (data.action == "DataRetrieved") {
	            setBusinessAttributes(data.actionData["data-display-attribute"]);
	            if(data.actionData.autoOpen != undefined && data.actionData.autoOpen != ""){
	            	autoOpenDataDisplay = data.actionData.autoOpen;	 
	            }
	        }
            notifyConnectionAccepted();
        },
        error: function(xhr, ajaxOptions, thrownError) {
            _log('requestBusinessAttributes error (' + pollPort + ') ' + ajaxOptions + ' - ' + xhr.status + ' ' + thrownError);
            //connectionTimeout = setTimeout('Workspace.requestBusinessAttributes()', requestTimeout);
            _log("continue with processing"); 
            notifyConnectionAccepted();
        }
    });
}

function setBusinessAttributes(actionData) {
	businessAttributes = {};
	if (!actionData || actionData.length == 0) {
		_log("Received empty Business Attributes array");
		return;
	}

    for (var i = 0; i < actionData.length; i++) {
    	var attr = actionData[i];
    	businessAttributes[attr.Name] = extendAttribute(attr);
    }
}

function extendAttribute(attr) {
	var template = {
		"order": 0,
		"label": attr.DisplayName,
		"type": "string",
		"key": "",
		"value": "",
		"style": "",
		"readonly": true
	};

	return jQuery.extend(template, attr);
}

function getBusinessAttributes() {
	return businessAttributes;
}

function getAutoOpenDataDisplay(){
	return autoOpenDataDisplay;
}

function sendFocusChange(objId, isScreenPop) {
    //_log("sendFocusChange - " + newData);
	_log("sendFocusChange - " + objId);
    var screenPop = '';
    if(isScreenPop==true)
    	screenPop = ',"screenPop":"true"'
    var newData = '{"sfdcObjectId":"' + objId + '"' + screenPop + '}';    
    message = '{"action":"FocusChanged",' + CI_connectionData + ',"actionData":' + newData + '}';
    
    _log("Sending:" + message);
    jQuery.ajax({
        //url: pollUrl + ":" + requestPort + "/request=" + message,
    	//url: pollUrl + ":" + pollPort + "/request=" + message,
    	url: pollUrl + ":" + pollPort,
    	data: "/request=" + message,
    	type: 'GET',
        timeout: requestTimeout,
        async: true,
        crossDomain: true,
        cache: false,
        dataType: 'jsonp',
        success: function(data) {
            _log('Request sent - response = ' + data.action);
            if(isScreenPop==true)
            	Salesforce.screenPop(objId);
        },
        error: function(xhr, ajaxOptions, thrownError) {
            _log('Request sent error (' + pollPort + ') ' + ajaxOptions + ' - ' + xhr.status + ' ' + thrownError);
        }
    });
}			        

var Workspace = {
	"setParameters": setParameters,
	"getParameters": getParameters,
	"poll": poll,
	"send": send,
	"processAttachData": processAttachData,
	"processMarkDone": processMarkDone,	
	"sendAttachData": sendAttachData,
	"requestConnection": requestConnection,
	"requestBusinessAttributes": requestBusinessAttributes,
	"getBusinessAttributes": getBusinessAttributes,
	"getAutoOpenDataDisplay": getAutoOpenDataDisplay,
	"sendFocusChange": sendFocusChange	
}

window["Workspace"] = Workspace;

})(window, jQuery, undefined);
