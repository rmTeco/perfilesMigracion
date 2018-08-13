({
    workspaceAPI : null,
    isConsoleNavigation : false,
    isDesignTime : false,
    setIframe : function(cmp) {
        var me = this;
        // OMNI-3767 - check we have a frame and if not use setTimeout to defer the iframe creation.
        var frame = cmp.find('iframe');
        if (!frame) {
            setTimeout(function() {
                me.setIframe(cmp);
            }, 500);
            return;
        }

        var actionHandler = $A.getCallback(function(data) {
            me.handleIFrameMessage(cmp, data.message, cmp.get('v.openInActionsIn'));
        });
        var config = {
            log: false,
            checkOrigin: false,
            scrolling: false,
            heightCalculationMethod: 'lowestElementNoMargin',
            messageCallback : actionHandler
        };
        if (cmp.get('v.maxHeight')) {
            config.maxHeight = Number('' + cmp.get('v.maxHeight').replace('px', ''));
            config.scrolling = true;
        }

        var element = frame.getElement();
        if (element && !element.iFrameResizer) {
            iFrameResize(config, element);
            cmp.set('v.iFrameResizer', frame.getElement().iFrameResizer);
        } else if (!element) {
            setTimeout($A.getCallback(function() {
                me.setIframe(cmp);
            }), 50);
        }

        if (!this.workspaceAPI) {
            this.workspaceAPI = cmp.find("workspace");
            this.workspaceAPI.isConsoleNavigation().then(function(response) {
                me.isConsoleNavigation = response;
            });
        }

        this.isDesignTime = window.location.pathname === '/flexipageEditor/surface.app' || window.location.pathname === '/visualEditor/appBuilder.app';
    },
    /*
     * returns true if it was handled, or false if not.
     */
    handleIFrameMessage: function(cmp, message, openActionIn) {
        //To ignore actions while in design mode
        if(this.isDesignTime) {
            return;
        }
        this.workspaceAPI = cmp.find('workspace');
        switch (message.message) {
            case 'actionLauncher:windowopen':   this.handleActionLauncherEvent(cmp, message, openActionIn);
                                                break;
            case 'omni:doneCancelAux':          this.handleOmniNavigation(cmp, message.type, message.destination, message.additionalConfig);
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
        if (action && action.isCustomAction) {
            action.linkType = 'Custom';
        }
        switch (action.linkType || action.LinkType__c) {
            case 'Custom': this.handleUrl(cmp, openActionIn, action.url, action, message.actionConfig);
                                break;
            case 'OmniScript':  this.handleRegularAction(cmp, openActionIn, action, message.contextId, message.sObjType, message.actionConfig);
                                break;
            case 'LEXConsoleCards': this.handleConsoleCards(cmp, openActionIn, action, message.actionConfig);
                                break;
            default:            this.handleRegularAction(cmp, openActionIn, action, message.contextId, message.sObjType, message.actionConfig);
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

    handleUrl: function(cmp, openActionIn, url, action, actionConfig, closeTab) {
        var isAbsoluteUrl = new RegExp('^(?:[a-z]+:)?//', 'i');
        var protocolRegex = new RegExp('://');
        var workspaceAPI = this.workspaceAPI;
        var actionType = (action.LinkType__c || action.type) ? (action.LinkType__c || action.type).toLowerCase() : null;
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
                return this.openInConsoleSubTab('#/sObject' + url + '/view', null, closeTab, false);
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
            url = url ? url : action.url || action.Url__c;
            urlHelper = document.createElement('a');
            if (!actionConfig) {
                actionConfig = {}
            }
            if (!actionConfig.extraParams) {
                actionConfig.extraParams = {};
            }
            actionConfig.extraParams.omniCancelAction = 'back';
            actionConfig.extraParams.omniIframeEmbedded = true;
            actionConfig.extraParams.isdtp = 'p1';
            actionConfig.extraParams.sfdcIFrameOrigin = this.getOrigin();
            var types = {
                '/native/bridge.app': 'hybrid',
                '/one/one.app': 'web'
            };
            actionConfig.extraParams.sfdcIFrameHost = 'sfNativeBridge' in window ? 'hybrid' : types[window.location.pathname.toLowerCase()] || 'web';
            urlEvent = $A.get('e.force:navigateToURL');
            urlHelper.href = ((!protocolRegex.test(url) && url.charAt(0) !== '/') ? '/' : '') + url;
            urlHelper.search += (urlHelper.search.length === 0 ? '?' : '&') + this.buildQueryString(actionConfig);
            urlEvent.setParams({
                'url': this.ie11pathnameFix(urlHelper) + urlHelper.search + urlHelper.hash
            });

            attributes = {
                'url':  this.ie11pathnameFix(urlHelper) + urlHelper.search + urlHelper.hash,
            };

            lightningRedirect = {
                'componentDef' : 'vlocity_cmt:vlocityIframeComponent',
                'attributes': attributes
            };
            navigateToComponentObj = {
                'componentDef' : 'vlocity_cmt:vlocityIframeComponent',
                componentAttributes: attributes
            };
            lightningInstanceUrl = '/one/one.app#' + window.btoa(JSON.stringify(lightningRedirect));

            if (workspaceAPI && this.isConsoleNavigation && params === '_blank') {
                return this.openInConsoleSubTab(lightningInstanceUrl, action.displayName, closeTab, true);
            } else if (params === '_blank' && !openActionIn) {
                var navigateToComponent = $A.get('e.force:navigateToComponent');
                navigateToComponent.setParams(navigateToComponentObj);
                navigateToComponent.fire();
            } else if (openActionIn) {
                urlHelper.href = openActionIn + '?actionUrl=' + encodeURIComponent(this.ie11pathnameFix(urlHelper) + urlHelper.search + urlHelper.hash);
                urlEvent = $A.get('e.force:navigateToURL');
                urlEvent.setParams({
                    'url': this.ie11pathnameFix(urlHelper) + urlHelper.search + urlHelper.hash
                });
                urlEvent.fire();
            } else {
                window.open(lightningInstanceUrl, params);
            }
        }
        return null;
    },

    openInConsoleSubTab: function(lightningInstanceUrl, displayName, closeTab, fixIcon) {
        var workspaceAPI = this.workspaceAPI;
        return workspaceAPI.getEnclosingTabId()
            .then(function(outerResponse) {
                return workspaceAPI.getTabInfo({
                    tabId: outerResponse
                }).then(function(response) {
                    var parentTabId = response.parentTabId != null ? response.parentTabId : response.tabId;
                    if (closeTab && parentTabId !== outerResponse) {
                        workspaceAPI.closeTab({
                            tabId: outerResponse
                        });
                    }
                    return workspaceAPI.openSubtab({
                        parentTabId: parentTabId,
                        url: lightningInstanceUrl,
                        focus: true
                    });
                });
            }).then(function(response) {
                if (displayName) {
                    workspaceAPI.setTabLabel({
                        tabId: response,
                        label: displayName
                    });
                }
                if (fixIcon) {
                    //TODO: fix blank icons after salesforce solves big icon bug
                    workspaceAPI.setTabIcon({
                        tabId: response,
                        icon: '',
                        iconAlt: displayName
                    });
                }
                });
    },

    handleOmniNavigation: function(cmp, type, destination, additionalConfig) {
        this.doOmniNav(cmp, type, destination, additionalConfig);
    },

    doOmniNav: function(cmp, type, destination, additionalConfig) {
        var defaultActionConfig = additionalConfig.action || {};
        if (!defaultActionConfig.displayName) {
            defaultActionConfig.displayName = additionalConfig.consoleTabLabel;
        }
        switch (type) {
            case 'SObject': if (destination[0] !== '/') {
                                destination = '/' + destination;
                            }
                            // fall through to handle url
            default:        return this.handleUrl(cmp, additionalConfig.openActionIn, destination, defaultActionConfig, additionalConfig.actionConfig, true);
        }
    },

    isSObjectUrl: function(url) {
        return /^\/[a-zA-Z0-9]+(\?.*)*$/.test(url) || /^\/([a-zA-Z0-9]+)\/e(\?.*)*$/.test(url);
    },

    handleRegularAction: function(cmp, openActionIn, action, contextId, sObjectType, actionConfig) {
        this.getActionFromServer(cmp, openActionIn, action, contextId, sObjectType, actionConfig);
    },

    buildQueryString: function(actionConfig) {
        var queryString = '';
        if (actionConfig && actionConfig.extraParams) {
            queryString = Object.keys(actionConfig.extraParams).reduce(function(str, key) {
                return str + '&' + encodeURIComponent(key) + '=' + encodeURIComponent(actionConfig.extraParams[key]);
            }, queryString) + '&';
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
        if (cmp.get('v.iFrameResizer')) {
            cmp.get('v.iFrameResizer').sendMessage(message);
        }
    },

    getUrlParam: function(url, paramName) {
        var paramMatch = new RegExp(paramName + '=([^&#=]*)', 'i').exec(url);
        if (paramMatch && paramMatch.length > 1) {
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

    getOrigin: function() {
        return 'origin' in window.location ? window.location.origin : 
            [window.location.protocol, '//', window.location.hostname, window.location.port ? ':' + window.location.port : ''].join('');
    },

    /* https://news.ycombinator.com/item?id=3939454 */
    ie11pathnameFix: function(urlHelper) {
        return urlHelper.pathname.replace(/(^\/?)/,"/");
    }
})