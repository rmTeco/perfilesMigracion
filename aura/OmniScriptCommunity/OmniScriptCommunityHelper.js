({
    getBaseURL : function(cmp, contextId, type, subtype, language) {
        var hostRoot, types, queryStringObj, queryString, getNameSpacePrefix, extraParams;
        if (/livepreview/.test(window.location.host)) {
            hostRoot = window.location.protocol + '//' + window.location.host + '/sfsites/c';
        } else {
            hostRoot = window.location.protocol + '//' + window.location.host + window.location.pathname.split("/s/")[0]; 
        }
        types = {
            "/native/bridge.app": "hybrid",
            "/one/one.app": "web"
        };
        queryStringObj = {
            id: contextId,
            ContextId: contextId,
            OmniScriptType: type, 
            OmniScriptSubType: subtype,
            OmniScriptLang: language,
            scriptMode: 'vertical',
            layout: 'lightning',
            omniIframeEmbedded: true,
            omniCancelAction: 'back',
            tour: "",
            isdtp: "p1",
            sfdcIFrameOrigin: this.getOrigin(),
            sfdcIFrameHost: "sfNativeBridge"in window ? "hybrid" : types[window.location.pathname.toLowerCase()] || "web"
        };
        if (!contextId) {
            delete queryStringObj.id;
        }
        queryString = Object.keys(queryStringObj).reduce(function(queryString, key) {
            return queryString + (queryString.length > 1 ? '&' : '') + encodeURIComponent(key) + '=' + encodeURIComponent(queryStringObj[key]);
        }, '');

        extraParams = cmp.get('v.extraParams');
        if (extraParams && Object.keys(extraParams).length > 0) {
            queryString += (queryString.length > 1 ? '&' : '') + Object.keys(extraParams).reduce(function(paramsString, key) {
                return paramsString + (paramsString.length > 1 ? '&' : '') + encodeURIComponent(key) + '=' + encodeURIComponent(extraParams[key]);
            }, '');
        }
        
        getNameSpacePrefix = cmp.get('c.getNameSpacePrefix');
        getNameSpacePrefix.setCallback(this, function(result) {
            var ns = result.getReturnValue() || '';
            var vfPage = cmp.get('v.customVFPage') || ns + 'OmniScriptUniversalPage';
            cmp.set('v.url', hostRoot + '/apex/' + vfPage + '?' + queryString);
        });
        $A.enqueueAction(getNameSpacePrefix);
    },
    getOrigin: function() {
        return "origin" in window.location ? window.location.origin : [window.location.protocol, "//", window.location.hostname, window.location.port ? ":" + window.location.port : ""].join("")
    }
})