/*
Persistent storage.

Note: clear() alo clears global variable "globals"
*/

(function(window, jQuery, undefined) {

var _log = Log ? Log.log : console.log;

// Publish API
var defaultGlobals = {
	"load": load,
	"store": store,
	"clear": clear
};

function extend(g) {
	return jQuery.extend(g, defaultGlobals);
}

function load() {
	var g = {};
	try {
		var data = localStorage.getItem("Globals");
		
		if (data != null) {
			try {
				var gg = JSON.parse(data);
				
				// check the timing
				if (g.storeTime != null) {
					// todo explain magic number
					if ((new Date().getTime() - g.storeTime) < 30000) {
						g = gg;
					}
				}
			} 
			catch (e) {
				_log("Could not load Globals object, will create a new one", e);
				localStorage.removeItem("Globals");
			}
		}
	}
	catch (e) {
		_log("Could not load Globals object, will create a new one", e);
	}
	
	// Merge in necessary functions
	window["Globals"] = extend(g);
}

function store() {
	var g = window["Globals"];
	if (!g) {
		_log("Could not store Globals object: object does not exist");
		return;
	}
	// set the store time
	g.storeTime = new Date().getTime();
	try {
		// todo Remove transient data
/*		jQuery.each(g.ixns, function(k, v) {
			delete v.ixnView;
		});
*/
		localStorage.setItem("Globals", JSON.stringify(g));
	}
	catch(e) {
		_log("Could not store Globals object", e);
	}
}

function clear() {
	localStorage.removeItem("Globals");
	window["Globals"] = extend({});
}

// Expose default object
window["Globals"] = extend({});

})(window, jQuery, undefined);
