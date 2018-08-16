////////////////////////////////////////////////////////////////////////////////////////
//Handles Client Requests that come via fireEvent from g_service_client_api
////////////////////////////////////////////////////////////////////////////////////////

(function(window, jQuery, undefined) {

var _log = Log ? Log.log : console.log;

jQuery.subscribe("client/req_message", processClientReqMessage);

var myCI_obj;
var mygenesysId;

function processClientReqMessage(clientMessage){
	//Format of the JSON request:
	//{"action":"action to perform","actionData":{"key1":"value1","key2":"value2"}}
	var myObj = JSON.parse(clientMessage.message);
    _log("in processClientReqMessage  " + myObj.action);
    
    var wsParams = Workspace.getParameters();
    //CI_connectionData = '"CI":"' + connectionDate + '"';
    var myCI = wsParams.CI_connectionData;
    myCI = "{" + myCI + "}";
    myCI_obj = JSON.parse(myCI);
    
    if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null){
    	mygenesysId = window.sessionStorage.getItem("Genesys_activeInteraction");
    }
    
    switch(myObj.action){
    case "AttachDataToSpecificInteraction" :
        _log("Calling AttachDataToSpecificInteraction with " + JSON.stringify(myObj));
        AttachDataToSpecificInteraction(myObj);
    break;
    case "AttachDataToInteraction" :
        _log("Calling AttachDataToInteraction with " + JSON.stringify(myObj));
        AttachDataToInteraction(myObj);
    break;
    case "GetSFDCObjectId" :
        _log("Calling GetSFDCObjectId with " + JSON.stringify(myObj));
        var result = GetSFDCObjectId(myObj);
        returnClientResponse(result);
    break;
    case "GetInteractionId" :
        _log("Calling GetInteractionId with " + JSON.stringify(myObj));
        var result = GetInteractionId(myObj);
        returnClientResponse(result);
    break;
    case "MarkDone":
        _log("Calling processMarkDone with " + JSON.stringify(myObj));
    break;
    default:
    	 _log("   No processClientReqMessage processing");
    }
    	
}

function returnClientResponse(message){
	_log("in returnClientResponse message = " + message);
	sforce.console.fireEvent('g_pluginResponse', message, function (result) {
		//Store request ID and  in case a response is processed
		_log("returnClientResponse fired result: " + result.success);
    });
	
}

function AttachDataToSpecificInteraction(myObj){
	_log("in AttachDataToSpecificInteraction");
	// Incoming JSON {"action":"AttachDataToInteraction","actionData":{"kvp1":"value1","id":"0371F32NQFQRT00E"}}
    // Outgoing JSON {"action":"AttachData","CI":"1438638247609a","actionData":{"kvp1":"value1","id":"0371F32NQFQRT00E"}}
	myObj.action = "AttachData";
	myObj.CI = myCI_obj.CI;
    var actionData_obj = myObj.actionData;
    actionData_obj.id = mygenesysId;
    Workspace.processAttachData(JSON.stringify(myObj));
}


function AttachDataToInteraction(myObj){
	_log("in AttachDataToInteraction");
	// Incoming JSON {"action":"AttachDataToInteraction","actionData":{"kvp1":"value1"}}
    // Outgoing JSON {"action":"AttachData","CI":"1438638247609a","actionData":{"kvp1":"value1","id":"0371F32NQFQRT00E"}}
	myObj.action = "AttachData";
	myObj.CI = myCI_obj.CI;
    var actionData_obj = myObj.actionData;
    actionData_obj.id = mygenesysId;
    Workspace.processAttachData(JSON.stringify(myObj));
}


function GetInteractionId(myObj){
	_log("in GetInteractionId");
	result = '{"action":"GetInteractionId","actionData":"' + mygenesysId + '"}';
	return result;    
}


function GetSFDCObjectId(myObj){
	_log("in GetSFDCObjectId");
    if(typeof(Storage) !== "undefined" && window!=null && window.sessionStorage!=null){
    	var sfdcId = window.sessionStorage.getItem("Genesys_sfdc_objectId");
    }
	 var result = '{"action":"GetSFDCObjectId","actionData":"' + sfdcId + '"}';
	return result;
}
    

var Client = {
		"processClientReqMessage": processClientReqMessage
	};

	window["Client"] = Client;

})(window, jQuery, undefined);