({
	getParameter : function() {
		var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
        
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
            
            if (sParameterName[0] === 'id') { //lets say you are looking for param name - id
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
            }
        }
        return sParameterName[1];
	},
    
	blockButton : function() {
        history.pushState(null, null, location.href);
        window.onpopstate = function () {
            history.go(1);
        }
    },
    
    removeParam : function (key, sourceURL) {
        var rtn = sourceURL.split("?")[0],
            param,
            params_arr = [],
            queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
        if (queryString !== "") {
            params_arr = queryString.split("&");
            for (var i = params_arr.length - 1; i >= 0; i -= 1) {
                param = params_arr[i].split("=")[0];
                if (param === key) {
                    params_arr.splice(i, 1);
                }
            }
            rtn = rtn + "?" + params_arr.join("&");
        }
        return rtn;
    },
    
    changeURL : function(event) {
        var originalURL = location.href;
        var newURL = this.removeParam('id', originalURL);
        if(originalURL != newURL) {
            window.history.pushState(
                "",
                "",
                newURL
			);
        }
	}
})