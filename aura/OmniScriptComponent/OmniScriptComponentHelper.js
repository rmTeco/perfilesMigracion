({
    getUrlForAction: function(cmp, actionId, contextId, objType, extraParams) {
        var me = this;
        var getUrlForAction = cmp.get('c.getUrlForAction');
        getUrlForAction.setParams({
            actionId: actionId,
            contextId: contextId,
            objType: objType
        });
        getUrlForAction.setCallback(this, function(result) {
            var url = result.getReturnValue();
            if (url) {
                var queryString = '';
                if (extraParams && Object.keys(extraParams).length > 0) {
                    queryString = Object.keys(extraParams).reduce(function(str, key) {
                        return str + '&' + encodeURIComponent(key) + '=' + encodeURIComponent(extraParams[key]);
                    }, '').substring(1) + '&';
                }
                if (url.indexOf('?') > -1) {
                    url = url.substring(0, url.indexOf('?') + 1) + queryString + url.substring(url.indexOf('?') + 1); 
                } else if (queryString !== '') {
                    url += '?' + queryString;
                }
                me.handleURL(cmp, url, true);
            } else {
                cmp.set('v.isOmniScriptValid', false);
            }
        });
        $A.enqueueAction(getUrlForAction);
    }, 

    handleURL: function(cmp, url, isredirect) {
        var hostRoot, urlEvent;
        if (/livepreview/.test(window.location.host)) {
            hostRoot = window.location.protocol + '//' + window.location.host + '/sfsites/c';
        } else {
            hostRoot = window.location.protocol + '//' + window.location.host + window.location.pathname.split('/s/')[0];
        }
        if (/^\/[a-zA-Z0-9]{15,18}(\?.*)*$/.test(url)) {
            // special case for view object
            urlEvent = $A.get('e.force:navigateToSObject');
            urlEvent.setParams({
                'recordId': url.substring(1),
                'isredirect': !!isredirect
            });
            urlEvent.fire();
        } else if (/^\/([a-zA-Z0-9]{15,18})\/e(\?.*)*$/.test(url)) {
            // special case for edit object
            var result = /^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.exec(url);
            urlEvent = $A.get('e.force:editRecord');
            urlEvent.setParams({
                'recordId': result[1],
                'isredirect': !!isredirect
            });
            urlEvent.fire();
        } else {
            var protocolRegex = new RegExp('://'),
                urlHelper = document.createElement('a'),
                queryString = 'omniCancelAction=back';
            urlHelper.href = ((!protocolRegex.test(url) && url.charAt(0) !== '/') ? '/' : '') + url;
            urlHelper.search += (urlHelper.search.length === 0 ? '?' : '&') + queryString;
            if (this.isApexPage(this.ie11pathnameFix(urlHelper))) {
                var types = {
                    '/native/bridge.app': 'hybrid',
                    '/one/one.app': 'web'
                };
                var queryStringObj = {
                    omniIframeEmbedded: true,
                    omniCancelAction: 'back',
                    tour: '',
                    isdtp: 'p1',
                    sfdcIFrameOrigin: this.getOrigin(),
                    sfdcIFrameHost: 'sfNativeBridge' in window ? 'hybrid' : types[window.location.pathname.toLowerCase()] || 'web'
                };
                var queryString = Object.keys(queryStringObj).reduce(function(queryString, key) {
                    return queryString + (queryString.length > 1 ? '&' : '') + encodeURIComponent(key) + '=' + encodeURIComponent(queryStringObj[key]);
                }, '');
                $A.createComponent('vlocity_cmt:vlocityIframeComponent', {
                    url: hostRoot + this.ie11pathnameFix(urlHelper) + urlHelper.search + urlHelper.hash
                }, function handleComponentCreation(component, status, errorMessage) {
                    if (status === 'SUCCESS') {
                        var body = cmp.get('v.body');
                        body.push(component);
                        cmp.set('v.body', body);
                    } else if (status === 'INCOMPLETE') {
                        console.log('No response from server or client is offline.');
                    } else if (status === 'ERROR') {
                        console.log('Error: ' + errorMessage);
                    }
                });
            } else {
                urlEvent = $A.get('e.force:navigateToURL');
                urlEvent.setParams({
                    'url': url,
                    'isredirect': !!isredirect
                });
                urlEvent.fire();
            }
        }
        cmp.set('v.isOmniScriptValid', true);
    },

    setupExtraParams: function(cmp, source) {
        var regex = new RegExp('"', 'g'),
            extraParams = {};
        if (source[0] === '?') {
            source = source.substring(1);
        }
        if (source[source.length - 1] === '&') {
            source = source.substring(0, source.length - 1);
        }
        var asString = '{"' + decodeURI(source).replace(regex, '\\"').replace(/&/g, '","').replace(/=/g,'":"') + '"}';
        try {
            extraParams = JSON.parse(asString);
        } catch (e) { /* log and swallow bad parsing.*/
            console.error('Could not generate extraParams from: ' + asString);
        }
        cmp.set('v.extraParams', extraParams);
    },

    getUrlParam: function(url, paramName) {
        var paramMatch = new RegExp(paramName + '=([^&#=]*)', 'i').exec(url);
        if (paramMatch && paramMatch.length > 1) {
            return decodeURIComponent(paramMatch[1]);
        }
        return null;
    },

    isApexPage: function(url) {
        return new RegExp('^/apex/').test(url);
    },

    /* https://news.ycombinator.com/item?id=3939454 */
    ie11pathnameFix: function(urlHelper) {
        return urlHelper.pathname.replace(/(^\/?)/,"/");
    },

    getOrigin: function() {
        return 'origin' in window.location ? window.location.origin : 
        [window.location.protocol, '//', window.location.hostname, window.location.port ? ':' + window.location.port : ''].join('');
    },

    getPageName: function(url) {
        if (this.isApexPage(url)) {
            var parts = url.split(/(\/|\?|#)/);
            return parts.filter(function(str) {
                return str.length > 0;
            })[3];
        }
        return null;
    }
})