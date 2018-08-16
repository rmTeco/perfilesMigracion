/*
Log keeping
Log downloading
Persistent logging (use localStorage).

Possible enhancements:
	* Log compression
	* Truncate log more precisely, by lines

Local storage limit is 5MB
JS string length limit is 2^15 = 32768
	E.g. if a string of 60 characters is logged every 5 seconds, it would result in 2MB of data per day

Log is stored as a set of strings with keys "log0".."log255" containing concatenated log lines.
String lengths are limited to 16K.
Strings count is limited to 256.
Total stored log size shall not exseed 4MB.
These strings are organized in a circular buffer.
There is a stored value logIndex containing index [0..255] of the string currently being used.
*/

(function(window, undefined) {

var logFileNameBranding = "salesforce_workspace_connector";

var storeLog = false;
var logElementId = null;

function twoDigit(n) {
	return ((n < 10) ? "0" : "") + n;
}

function formatDateToSeconds() {
    var d = new Date();
    var Y = d.getFullYear();
    var M = twoDigit(d.getMonth() + 1);
    var D = twoDigit(d.getDate());
    var h = twoDigit(d.getHours());
    var m = twoDigit(d.getMinutes());
    var s = twoDigit(d.getSeconds());

    return M + "/" + D + "/" + Y + "_" + h + ":" + m + ":" + s;
}

function formatTime() {
    var d = new Date();
    var h = twoDigit(d.getHours());
    var m = twoDigit(d.getMinutes());
    var s = twoDigit(d.getSeconds());

    return h + ":" + m + ":" + s;
}

function getIndex() {
	var logIndex = localStorage.getItem("logIndex");
//	console.log("***** Log index get: " + logIndex);
	try {
		return logIndex ? parseInt(logIndex) : 0;
	}
	catch (e) {
		return 0;
	}
}

function setIndex(logIndex) {
//	console.log("***** Log index set: " + logIndex);
	localStorage.setItem("logIndex", logIndex);
}

function getLine(index) {
	var logLine = localStorage.getItem("log" + index);
	return logLine ? logLine : "";
}

function setLine(index, line) {
	localStorage.setItem("log" + index, line);
}

function logToConsole(message) {
	//if (console.log) {
	//	console.log(message);
	//}
    if (typeof console!="undefined") {
        if (typeof console.log != "undefined") {
            console.log(message);
        }
    }
	if (logElementId) {
		logToElement(message)
	}
	if (storeLog) {
		logToStore(message);
	}
}

function logToStore(message) {
	try {
		message = formatDateToSeconds() + " " + message + "\n";
    
		var logIndex = getIndex();
		var logStr = getLine(logIndex);
    
		if (logStr.length + message.length > 16384) {
			console.log("Log line overflow");
			// Next buffer cell
			logIndex++;
			if (logIndex > 255) {
				console.log("Log buffer overflow");
				// Wrap buffer
				logIndex = 0;
			}
			logStr = "";
		    setIndex(logIndex);
		}
    
        logStr = logStr + message;
        setLine(logIndex, logStr);
    }
    catch (e) {
    	console.log("Log error", e);
    }
}

function logToElement(message) {
	try {
		message = "<span style='color: blue;'>" + formatTime() + "</span>" + " " + decodeURIComponent(message);
	    
        var el = document.getElementById(logElementId);
        var ih = el.innerHTML;
        if (ih.length > 0) {
            el.innerHTML = ih + "<br>" + message;
        }
        else {
            el.innerHTML = message;
        }
    }
    catch (e) {
    	console.log("Log error", e);
    }
}

function setStoreLog(b) {
	storeLog = !!b;
}

function getStoreLog() {
	return storeLog;
}

function downloadLog() {
    var logStrings = [];
    var logIndex = getIndex();
    var i;
    for (i = logIndex + 1; i < 256; i++) {
    	logStrings.push(getLine(i));
    }
    for (i = 0; i <= logIndex; i++) {
    	logStrings.push(getLine(i));
    }

    var blob = new Blob(logStrings, {type: 'text/plain'});
    var fileName = logFileNameBranding + "_" + formatDateToSeconds() + ".log";

    if (window.navigator.msSaveOrOpenBlob) {
        window.navigator.msSaveOrOpenBlob(blob, fileName);
    }
    else {
        var e = document.createEvent('MouseEvents');
        var a = document.createElement('a');
        a.download = fileName;
        a.href = window.URL.createObjectURL(blob);
        a.dataset.downloadurl =  ['text/plain', a.download, a.href].join(':');
        e.initMouseEvent('click', true, false, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
        a.dispatchEvent(e);
    }
}

function clearStoredLog() {
	try {
		setIndex(0);
		for (var i = 0; i < 256; i++) {
			setLine(i, "");
		}
	}
	catch (e) {
		console.log("Could not clear stored log", e);
	}
}

function setLogElementId(id) {
	logElementId = id;
}

function getLogElementId() {
	return logElementId;
}

function clearLogElement() {
	if (logElementId) {
    	document.getElementById(logElementId).innerHTML = "";
	}
}

var Log = {
	"log": logToConsole,
	"logToConsole": logToConsole,
	"setStoreLog": setStoreLog,
	"getStoreLog": getStoreLog,
	"downloadLog": downloadLog,
	"clearStoredLog": clearStoredLog,
	"setLogElementId": setLogElementId,
	"getLogElementId": getLogElementId,
	"clearLogElement": clearLogElement
}

window["Log"] = Log;

}) (window, undefined);
