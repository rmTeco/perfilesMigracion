({
    workspaceAPI : null,
    isConsoleNavigation : false,
    /*
     * returns true if it was handled, or false if not.
     */
    handleIFrameMessage: function(cmp, message, openActionIn) {
        console.log('handleIFrameMessage...');
        console.dir(message);
        this.workspaceAPI = cmp.find('workspace');
        switch (message.message) {
            case 'actionLauncher:windowopen':   this.handleActionLauncherEvent(cmp, message, openActionIn);
                                                break;
            case 'omni:doneCancelAux':          this.handleOmniNavigation(cmp, message.type, message.destination);
                                                break;
            case 'omni:cancelGoBack':           this.handleCancelGoBack(cmp, message);
                                                break;
            case 'ltng:event':                  this.fireLightningEvent(cmp, message);
                                                break;
            case 'interactionLauncher:event':   this.fireInteractionLauncherEvent(cmp, message);
                                                break;
            case 'actionLauncher:closePrimaryTab': this.handleClosePrimaryTab();
                                                break;
            default: // no-op
        }
    },

    handleActionLauncherEvent: function(cmp, message, openActionIn) {
        var action = message.action;
        console.log('action: ');
        //action.contextId = cmp.get("v.accountId");
        console.dir(action);
        console.log('action.isC:' + action.isCustomAction);
        if (action && action.isCustomAction) {
            action.linkType = 'Custom';
        }
        console.log('linkType: ' + action.linkType);
        switch (action.linkType || action.LinkType__c) {
            case 'Custom': this.handleUrl(cmp, openActionIn, action.url, action, message.actionConfig);
                                break;
            case 'OmniScript':  this.handleRegularAction(cmp, openActionIn, action, message.contextId, message.sObjType, message.actionConfig);
                                break;
            case 'LEXConsoleCards': this.handleConsoleCards(cmp, openActionIn, action, message.actionConfig);
                                break;
             case 'CommunityUrl' : this.handleCommunityUrl(cmp, openActionIn, action, message.actionConfig);
                                break;
            default:            this.handleRegularAction(cmp, openActionIn, action, message.contextId, message.sObjType, message.actionConfig);
        }
    },
    handleCommunityUrl : function(cmp, openActionIn, action, actionConfig){
        var urlEvent;
        var openUrlMode = action.OpenUrlMode__c || action.OpenURLMode__c || action.openUrlIn;
        var params = (openUrlMode === 'New Tab / Window') ? '_blank' : '_self';
        var toBeLaunchedUrl = action.url || action.Url__c || action.URL__c;
        for(var key in actionConfig.extraParams) {
           toBeLaunchedUrl = this.replaceUrlParam(toBeLaunchedUrl, key, actionConfig.extraParams[key]);
        }
        var cName = this.getCommunityName();
        if (params === '_self') {
            urlEvent = $A.get('e.force:navigateToURL');
            urlEvent.setParams({
                'url': toBeLaunchedUrl
            });
            urlEvent.fire();
        } else {
            window.open(cName + toBeLaunchedUrl, params);
        }
    },

    handleConsoleCards : function(cmp, openActionIn, action, actionConfig){
      //  var lightningRedirect = '{"componentDef":"one:alohaPage","attributes":{"values":{"address":"'+action.url+'"},"history":[]},"t":'+Date.now()+'}';
        var workspaceAPI = this.workspaceAPI;
        var url = action.url || action.Url__c,
            layout = this.getUrlParam(url, 'layout'),
            id = this.getUrlParam(url, 'id');

        var openUrlMode = action.OpenUrlMode__c || action.OpenURLMode__c || action.openUrlIn;
        var params = (openUrlMode === 'New Tab / Window') ? '_blank' : '_self';

        if (!layout) {
            this.handleUrl(cmp, openActionIn, url, action, actionConfig);
            return;
        }

        var lightningRedirect = {
            'componentDef' : 'vlocity_cmt:vlocityCardComponent',
            'attributes': {
                'url':  url,
                'layout' : layout,
                'recordId' : id
            }
        };
        var lightningInstanceUrl = '/one/one.app#' + window.btoa(JSON.stringify(lightningRedirect));

        if (workspaceAPI && this.isConsoleNavigation && params === '_blank') {
            workspaceAPI.getEnclosingTabId()
            .then(function(response) {
                return workspaceAPI.getTabInfo({
                    tabId: response
                });
            }).then(function(response) {
                var parentTabId = response.parentTabId != null ? response.parentTabId : response.tabId;
                return workspaceAPI.openSubtab({
                    parentTabId: parentTabId,
                    url: lightningInstanceUrl,
                    focus: true
                });
            }).then(function(response) {
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: action.displayName
                });
                workspaceAPI.setTabIcon({
                    tabId: response,
                    iconAlt: action.displayName
                });
            });
        } else if (params === '_blank') {
            var navigateToComponent = $A.get('e.force:navigateToComponent');
            navigateToComponent.setParams({
                componentDef : 'vlocity_cmt:vlocityCardComponent',
                componentAttributes: {
                    url:  url,
                    layout : layout,
                    recordId : id
                }
            });
            navigateToComponent.fire();
        } else {
            window.open(lightningInstanceUrl, params);
        }
    },

    handleUrl: function(cmp, openActionIn, url, action, actionConfig) {
        console.log('handleUrl');
        console.dir(openActionIn);
        console.dir(url);
        console.dir(action);
        console.dir(actionConfig);
        var isAbsoluteUrl = new RegExp('^(?:[a-z]+:)?//', 'i');
        var protocolRegex = new RegExp('://');
        var workspaceAPI = this.workspaceAPI;
        
        console.log('workspaceAPI');
        console.dir(workspaceAPI);
        
        var actionType = (action.LinkType__c || action.type) ? (action.LinkType__c || action.type).toLowerCase() : null;
        console.log(actionType);
        var openUrlMode = action.OpenUrlMode__c || action.OpenURLMode__c || action.openUrlIn;
        var params = (openUrlMode === 'New Tab / Window') ? '_blank' : '_self';
        var type, subtype, language, recordId, urlEvent, urlHelper,
            queryString, lightningInstanceUrl, lightningRedirect, attributes, navigateToComponentObj;
        if (!url) {
            console.error('iframeComponent.handleUrl :: Vlocity action url not found for this action', action);
            return false;
        }
        if (/^\/[a-zA-Z0-9]{15,18}(\?.*)*$/.test(url)) {
            // For SObjects
            if (workspaceAPI && this.isConsoleNavigation) {
                workspaceAPI.getEnclosingTabId().then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(response) {
                        var parentTabId = response.parentTabId != null ? response.parentTabId : response.tabId;
                        workspaceAPI.openSubtab({
                            parentTabId: parentTabId,
                            url: '#/sObject' + url + '/view',
                            focus: true
                        });
                    });
                });
            } else {
                urlEvent = $A.get('e.force:navigateToSObject');
                urlEvent.setParams({
                    'recordId': url.substring(1)
                });
                urlEvent.fire();
            }
        } else if (/^\/([a-zA-Z0-9]{15,18})\/e(\?.*)*$/.test(url)) {
            //special case for edit object
            var result = /^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.exec(url);
            urlEvent = $A.get('e.force:editRecord');
            urlEvent.setParams({
                'recordId': result[1]
            });
            urlEvent.fire();
        } else if (isAbsoluteUrl.test(url)) {

            if (params === '_self') {
                window.open(url, params);
            } else {
                urlEvent = $A.get('e.force:navigateToURL');
                urlEvent.setParams({
                    'url': url
                });
                urlEvent.fire();
            }

        
        } else {
            url = url ? url : action.url || action.URL__c;
            urlHelper = document.createElement('a');
            queryString = 'omniCancelAction=back' + this.buildQueryString(actionConfig);
            urlHelper.href = ((!protocolRegex.test(url) && url.charAt(0) !== '/') ? '/' : '') + url;
            urlHelper.search += (urlHelper.search.length === 0 ? '?' : '&') + queryString;
            var oldStyleOmniRegex = new RegExp('/OmniScriptType/([^/]+)*/OmniScriptSubType/([^/]+)*/OmniScriptLang/([^/]+)*/');
            if (actionType === 'omniscript' || (oldStyleOmniRegex.test(urlHelper.hash) ||
                (/OmniScriptType=/.test(urlHelper.search) &&
                    /OmniScriptSubType=/.test(urlHelper.search) &&
                    /OmniScriptLang=/.test(urlHelper.search)))) {

                if (oldStyleOmniRegex.test(urlHelper.hash)) {
                    var matches = oldStyleOmniRegex.exec(urlHelper.hash);
                    type = matches[1];
                    subtype = matches[2];
                    language = matches[3];
                    recordId = (matches[4] || this.getUrlParam(urlHelper.search, 'ContextId') || this.getUrlParam(urlHelper.search, 'id'));
                } else if (/OmniScriptType=/.test(urlHelper.search) &&
                    /OmniScriptSubType=/.test(urlHelper.search) &&
                    /OmniScriptLang=/.test(urlHelper.search)) {
                    type = this.getUrlParam(urlHelper.search, 'OmniScriptType');
                    subtype = this.getUrlParam(urlHelper.search, 'SubType');
                    language = this.getUrlParam(urlHelper.search, 'OmniScriptLang');
                    recordId = this.getUrlParam(urlHelper.search, 'ContextId');
                }
                attributes = {
                    'type':  type,
                    'subtype': subtype,
                    'language': language,
                    'recordId': recordId,
                    'extraParams' : actionConfig.extraParams || {}
                };
                attributes.extraParams.omniCancelAction = 'back';

                lightningRedirect = {
                    'componentDef' : 'vlocity_cmt:OmniScript',
                    'attributes': attributes
                };
                navigateToComponentObj = {
                    componentDef : 'vlocity_cmt:OmniScript',
                    componentAttributes: attributes
                };
                //openActionIn = openActionIn && openActionIn != '' ?  openActionIn : urlHelper.pathname;
            } else {
                queryString = this.buildQueryString(actionConfig);
                urlEvent = $A.get('e.force:navigateToURL');                
                urlHelper.href = ((!protocolRegex.test(url) && url.charAt(0) !== '/') ? '/' : '') + url;
                urlHelper.search += (urlHelper.search.length == 0 ? '?' : '&') + queryString;

                urlEvent.setParams({
                    'url': urlHelper.pathname + urlHelper.search + urlHelper.hash
                });



                attributes = {
                    'address':  urlHelper.pathname + urlHelper.search + urlHelper.hash,
                };

                lightningRedirect = {
                    'componentDef' : 'one:alohaPage',
                    'attributes': attributes
                };

                navigateToComponentObj = {
                    'componentDef' : 'one:alohaPage',
                    componentAttributes: attributes
                };
            }
            
            lightningInstanceUrl = window.btoa(JSON.stringify(lightningRedirect));

            console.log(workspaceAPI + ' _ ' + this.isConsoleNavigation + ' _ ' + params + ' _ ' + openActionIn);
            if (workspaceAPI && this.isConsoleNavigation && params === '_blank') {
                workspaceAPI.getEnclosingTabId()
                    .then(function(response) {
                        return workspaceAPI.getTabInfo({
                            tabId: response
                        });
                    }).then(function(response) {
                        var parentTabId = response.parentTabId != null ? response.parentTabId : response.tabId;
                        return workspaceAPI.openSubtab({
                            parentTabId: parentTabId,
                            url: lightningInstanceUrl,
                            focus: true
                        });
                    }).then(function(response) {
                        workspaceAPI.setTabLabel({
                            tabId: response,
                            label: action.displayName
                        });
                        //TODO: fix blank icons after salesforce solves big icon bug
                        workspaceAPI.setTabIcon({
                            tabId: response,
                            icon: '',
                            iconAlt: action.displayName
                        });
                    });
            } else if (params === '_blank' && !openActionIn) {
                var navigateToComponent = $A.get('e.force:navigateToComponent');
                navigateToComponent.setParams(navigateToComponentObj);
                navigateToComponent.fire();
            } else if (openActionIn) {
                urlHelper.href = openActionIn + '?actionUrl=' + encodeURIComponent(urlHelper.pathname + urlHelper.search + urlHelper.hash);


                urlEvent = $A.get('e.force:navigateToURL');
                urlEvent.setParams({
                    "url": urlHelper.pathname + urlHelper.search + urlHelper.hash
                });
                urlEvent.fire();
            } else {
                window.open(lightningRedirect, params);
            }
        }
    },

    handleOmniNavigation: function(cmp, type, destination) {
        var workspaceAPI = this.workspaceAPI,
            self = this;
        var urlEvent = null;
        if (type === 'URL') {
            urlEvent = $A.get('e.force:navigateToURL');
            urlEvent.setParams({
                'url': destination
            });
            urlEvent.fire();
        } else if (type === 'SObject') {
            if (workspaceAPI && this.isConsoleNavigation) {
                workspaceAPI.getEnclosingTabId().then(function(response) {
                    workspaceAPI.getTabInfo({
                        tabId: response
                    }).then(function(response) {
                        var parentTabId = response.parentTabId != null ? response.parentTabId : response.tabId;
                        if (destination[0] !== '/') {
                            destination = '/' + destination;
                        } 
                        workspaceAPI.openSubtab({
                            parentTabId: parentTabId,
                            url: '#/sObject' + destination + '/view',
                            focus: true
                        });
                        self.handleCancelGoBack();
                    });
                });
            } else {
                urlEvent = $A.get("e.force:navigateToSObject");
                urlEvent.setParams({
                    'recordId': destination
                });
                urlEvent.fire();
            }
        }
    },

    handleRegularAction: function(cmp, openActionIn, action, contextId, sObjectType, actionConfig) {
        
        console.log('handleRegularAction: ');
        console.log('openActionIn: ');
        console.dir(openActionIn);
        console.log('action: ');
        console.dir(action);
        console.log('contextId: ');
        console.dir(contextId);
        console.log('sObjectType: ');
        console.dir(sObjectType);
        console.log('actionConfig: ');
        console.dir(actionConfig);

        this.getActionFromServer(cmp, openActionIn, action, contextId, sObjectType, actionConfig);
    },

    buildQueryString: function(actionConfig) {
        var queryString = '';        
        if (actionConfig && actionConfig.extraParams) {
            queryString = Object.keys(actionConfig.extraParams).reduce(function(str, key) {
                return str + '&' + encodeURIComponent(key) + '=' + encodeURIComponent(actionConfig.extraParams[key]);
            }, queryString);// + '&';
        }
        return queryString;
    },

    getActionFromServer: function(cmp, openActionIn, action, contextId, sObjectType, actionConfig) {
        var getUrlForAction = cmp.get('c.getUrlForAction'),
            me = this;
        getUrlForAction.setParams({
            actionId: action.Id,
            contextId: contextId,
            objType: sObjectType
        });
        getUrlForAction.setCallback(this, function(result) {
            if (result) {
                me.handleUrl(cmp, openActionIn, result.getReturnValue(), action, actionConfig);
            }
        });
        $A.enqueueAction(getUrlForAction);
    },

    fireLightningEvent: function(cmp, message) {
        var evt = $A.get(message.event);
        if (message.params) {
            evt.setParams(message.params);
        }
        evt.fire();
    },

    fireInteractionLauncherEvent : function(cmp, message) {
        var evt = $A.get('e.vlocity_cmt:vlocityInteractionLauncherEvent');
        if (message.params) {
            evt.setParams(message.params);
        }
        evt.fire();
    },

    sendIframeMessage: function(cmp, message) {
        cmp.get('v.iFrameResizer').sendMessage(message);
    },

    getUrlParam: function(url, paramName) {
        console.log("getUrlParam: " + url + " _ " + paramName);
        var paramMatch = new RegExp(paramName + '=([^&#=]*)', 'i').exec(url);
        if (paramMatch && paramMatch.length > 1) {
            console.log("Result: " + paramMatch[1]);
            return decodeURIComponent(paramMatch[1]);
        } 
        return null;
    },
    
    handleCancelGoBack : function(cmp){
        var workspaceAPI = this.workspaceAPI;
        if (workspaceAPI && this.isConsoleNavigation) {
            //have to handle same window case (in case of Omniscript)
            workspaceAPI.getEnclosingTabId().then(function(response) {
                        workspaceAPI.closeTab({
                            tabId: response
                        });
            });
        } else {
            window.history.back();
        }
    },

    handleClosePrimaryTab : function(){
        var workspaceAPI = this.workspaceAPI;
        workspaceAPI.getEnclosingTabId().then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(response) {
                var tabId = response.parentTabId != null ? response.parentTabId : response.tabId;
                workspaceAPI.closeTab({
                    tabId: tabId
                })
            })
        });
    },
    
     getCommunityName : function() {
        var sPageURL = window.location.href; //You get the whole decoded URL of the page.
        var aElement = document.createElement('a');
        aElement.href = sPageURL;
        var cName = aElement.pathname.replace(/(^\/?)/,"/").split('/')[1];
        return cName === 's' ? '/' + cName : '/' + cName + '/s' ;
    },
    replaceUrlParam: function(endpoint, paramName, paramValue) {
        var pattern = new RegExp('\\b('+paramName+'=).*?(&|$)');
        if(endpoint.search(pattern) >= 0){
            return endpoint.replace(pattern,'$1' + paramValue + '$2');
        }
        return endpoint + (endpoint.indexOf('?') > 0 ? '&' : '?') + paramName + '=' + paramValue ;
    }
})