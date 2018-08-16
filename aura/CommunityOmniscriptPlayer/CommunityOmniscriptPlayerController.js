({
    doInit : function(cmp, event, helper) {
        var url = window.location.host;
        var isPreview = false;
        if (/livepreview/.test(url)) {
            cmp.set('v.isPreview', true);
            isPreview = true;
        }
        
        if (!isPreview) {
            var match = /[?&]{1}actionUrl=([^&#]*)/i.exec(window.location.search);
            if (match && match.length>1) {
                var protocolRegex = new RegExp('://');
                var actionUrl = decodeURIComponent(match[1]).replace(/\+/g, ' ');
                // parse URL to ensure it's relative
                var hrefHelper = document.createElement('a');
                hrefHelper.href = ((!protocolRegex.test(actionUrl) && actionUrl.charAt(0) !== '/') ? '/' : '') + actionUrl;
                helper.setupExtraParams(cmp, hrefHelper.search);
                helper.handleURL(cmp, helper.ie11pathnameFix(hrefHelper) + hrefHelper.search + hrefHelper.hash);
            } else if (/actionid=([^&#=]*)/i.test(window.location.search)) {
                helper.setupExtraParams(cmp, window.location.search);
                var actionId = helper.getUrlParam(window.location.search, 'actionid');
                if (actionId) {
                    var contextId = helper.getUrlParam(window.location.search, 'contextId');
                    var objType = helper.getUrlParam(window.location.search, 'objType');
                    helper.getUrlForAction(cmp, actionId, contextId, objType, extraParams);
                } else {
                    cmp.set('v.isOmniScriptValid', false);
                }
            } else {
                cmp.set('v.isOmniScriptValid', false);
            }
        }
    }
})