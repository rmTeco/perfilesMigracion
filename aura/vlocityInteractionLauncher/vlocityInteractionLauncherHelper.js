({
	showAlert : function(cmp, type, message) {
		var validationErrorHandler = {};
        validationErrorHandler['type'] = type;
        validationErrorHandler['message'] = message;
        cmp.set('v.validationErrorHandler', validationErrorHandler);
    },
    clearErrorMessage : function(cmp) {
        this.showAlert(cmp,'', '');
    },
    getNamespacePrefix : function(cmp) {
        var action = cmp.get('c.getNameSpacePrefix');
        action.setCallback(this, function(a) {
            var prefix = a.getReturnValue();
            
            cmp.set('v.namespace', prefix.replace('__',''));
        });
        $A.enqueueAction(action);
    },
    getLookupRequest : function(cmp) {
        var action = cmp.get('c.getAuraLookupRequests');
        action.setParams({ 'additionalData' : null });
        action.setCallback(this, function(a) {
            cmp.set('v.lookupRequests', JSON.parse(a.getReturnValue()));
            cmp.set('v.vlcLoading', false);
        });
        $A.enqueueAction(action);
    },
    getSearchResult : function(component, requests, isSecondSearch) {
        
        var searchSection = this.checkSearchEntry(requests);
        var parentId = null;
        if(isSecondSearch) {
            var searchResultData = component.get('v.nextLookupRequests')[0];
            parentId = searchResultData.recordId;
        }
        var action = component.get('c.getAuragetSearchResult');
            action.setParams({ 'strRequest' : JSON.stringify(searchSection), 'contextIds' : null, 'parentId' : parentId });
            action.setCallback(this, function(a) {
                component.set('v.vlcLoading', false);
                if (a.getState() === 'SUCCESS') {
                	var result = JSON.parse(a.getReturnValue());
                    var searchResult = [];
                    if (result.parentContextSearchResult) {
                        searchResult = result.parentContextSearchResult
                    }
                    else {
                        searchResult = result.searchResult;
                    }
                    component.set('v.searchResult', searchResult);
                    for (var k = 0; k < searchResult.length; k++) {
                        searchResult[k]['parentId'] = parentId;
                    }
                    if(searchResult && searchResult.length <= 0) {
                        this.showAlert(component,'default', $A.get('$Label.'+component.get('v.namespace')+'.InteractionLauncher_NoSearchResults'));
                        return;
                    }
                    if(searchResult[0].request.referenceObjectName) {
                        this.getRoleBasedActions(component,searchResult[0]);
                    }
                    this.getResultActions(component, searchSection, isSecondSearch);
                    if(isSecondSearch) {
                        this.getVerificationActions(component,isSecondSearch); 
                    }
            	} else if (a.getState() === 'ERROR'){
                    var errors = action.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
            				this.showAlert(component,'error', 'No search result returned');
                        }
                    }
            	}
            });
            $A.enqueueAction(action);
    },
    getResultActions : function(cmp, searchSection, isSecondSearch) {
        var searchResult = cmp.get('v.searchResult');
        var stepName = isSecondSearch ? 'SecondResultPane' : 'ResultPane';
        var hasResult = false;
        if(searchResult != null && searchResult.length > 0) {
            hasResult = true;
        }
        if(searchSection)
        {
            var action = cmp.get('c.getAuraStepActions');
            action.setParams({ 
                'unqiueRequestName' : searchSection.requestUniqueName,
                'stepName' :stepName,
                'searchValueMap' :searchSection.searchValueMap,
                'resultValueMap':null,
                'additionalData' : null,
                'verificationResult':null,
                'hasResult' : hasResult
            });
            var isSearchTypeCaller = searchSection.searchType == 'Caller Identification' ? true : false;
            cmp.set('v.isSearchTypeCaller',isSearchTypeCaller);
            if(!isSearchTypeCaller) {
                this.getPartyTable(cmp, searchResult);
            }
            cmp.set('v.vlcLoading', true);
            action.setCallback(this, function(a) {
                cmp.set('v.vlcLoading', false);
                cmp.set('v.activePane', isSecondSearch ? 6 : isSearchTypeCaller ? 1 : 2);
                var resultActions = a.getReturnValue();
                cmp.set('v.resultActions', JSON.parse(resultActions));
            });
            $A.enqueueAction(action);
        }
    },
    getPartyTable : function(cmp, searchResult) {
        var tableColumnLimit = 2;
        var tableHeader = [];
        var tableBody = [];
        for(var fieldIndex in searchResult[0].resultFieldList) {
            var field = searchResult[0].resultFieldList[fieldIndex];
            if(tableHeader.length >= tableColumnLimit) {
                break;
            }
            tableHeader.push(searchResult[0].resultFieldsLabelTypeMap[field].label);
        }
        
        for(var resultIndex in searchResult) {
            var result = searchResult[resultIndex];
            var tr = [];
            for(var index = 0;index < result.resultFieldList.length ; index ++) {
                if(index >= tableColumnLimit) {
                	break;
            	}
                tr.push(result.resultValueMap[result.resultFieldList[index]]);
            }
            searchResult[resultIndex]['body'] = tr;
        }
        
        cmp.set('v.partyTable', {'header' : tableHeader, 'body' : tableBody });
        cmp.set('v.searchResult', searchResult);
    },
    getVerificationActions : function(cmp, isSecondSearch) {
        var callerData = cmp.get('v.callerData');
        var requests = cmp.get('v.lookupRequests');
        var searchResultData = cmp.get('v.searchResult');
        if(isSecondSearch) {
            searchResultData = cmp.get('v.nextLookupRequests')[0];
            requests = cmp.get('v.moreRequests');
        }

        var searchSection = this.checkSearchEntry(requests);

        if(searchSection)
        {
            var action = cmp.get('c.getAuraVerificationPaneActions');
            action.setParams({ 
                'unqiueRequestName' : isSecondSearch ? searchSection.requestUniqueName  : callerData.uniqueRequestName,
                'searchValueMap' :isSecondSearch ? null : searchSection.searchValueMap || null,
                'resultValueMap':isSecondSearch ? searchResultData.resultValueMap : callerData.resultValueMap,
                'additionalData' : null,
                'verificationResult':isSecondSearch ? searchResultData.verificationResult : callerData.verificationResult
            });
            cmp.set('v.vlcLoading', true);
            action.setCallback(this, function(a) {
                cmp.set('v.vlcLoading', false);
                var verificationActions = a.getReturnValue();
                var result = JSON.parse(verificationActions);
                cmp.set('v.verificationActions', result.VerificationPane);
                cmp.set('v.launchAction', result.Launch[0]);
            });
            $A.enqueueAction(action);
        }
    },
    checkFieldVerificationAndProcess: function(cmp, policyData, selectedAction, alreadyInvoked) {
        var callerData = cmp.get('v.callerData');
        var input = policyData || callerData;
        alreadyInvoked = alreadyInvoked || false;
        return this.checkFieldVerification(
            	cmp,
                policyData.recordId,
                policyData.uniqueRequestName,
                policyData.tabId,
                selectedAction,
                input,
                null,
                alreadyInvoked
            );
    },
    checkFieldVerification : function(cmp, newRecordId, newSearchType, tabId, selectedAction, input, callback, alreadyInvoked) {
        var callerData = cmp.get('v.callerData');
        var namespace = cmp.get('v.namespace');
        var errorMessage = $A.get('$Label.'+cmp.get('v.namespace')+'.InteractionLauncher_CallerFields');
        this.showAlert(cmp, '', '');
        if(callerData.verificationResult.fields) {
            for(var vfField in callerData.verificationFieldList) {
                var value = callerData.verificationFieldList[vfField];
                if(!callerData.verificationResult.fields[value]) {
                    this.showAlert(cmp, 'error', errorMessage);
                    return false;
                }
            }
            
            if(callerData.optionalVerificationFieldList) {
                
        		var totalVerifiedLength = 0;
                var length = callerData.optionalVerificationFieldList.length + callerData.verificationFieldList.length;
                if(callerData.numOfOptionalVerificationFields) {
                    var length = callerData.verificationFieldList.length + parseInt(callerData.numOfOptionalVerificationFields);
                }
                
                for(var resField in callerData.verificationResult.fields) {
                    if(callerData.verificationResult.fields[resField]) {
                        totalVerifiedLength += 1;
                    }
                }
                
                if(totalVerifiedLength < length) {
                    this.showAlert(cmp, 'error', errorMessage);
                    return false;
                }
                
            }
            
            return true;
            
        } else {
            this.showAlert(cmp, 'error', errorMessage);
        }
        
    },
    isObjEmpty : function(obj) {
        for(var prop in obj) {
            if(obj.hasOwnProperty(prop))
                return false;
        }
        return JSON.stringify(obj) === JSON.stringify({});
	},
    checkSearchEntry : function(requests) {
        for (var i = 0; i < requests.length; i++) {
            var searchValueMap = requests[i]['searchValueMap'];
            if(searchValueMap) {
                for (var key in searchValueMap) {
                    if(searchValueMap[key]) {
                     	return requests[i];
                    }
                }
    		}
        }
        return {};
    },
    getLookupRequestsWithoutSearch : function(cmp) {
        cmp.set('v.vlcLoading', true);
        var callerData = cmp.get('v.callerData');
        var newRecordId = callerData.recordId;
        var action = cmp.get('c.getAuraNextLookupRequestsWithoutSearch');
        action.setParams({ 'strResult' : JSON.stringify(callerData), 'searchUniqueName' : callerData.uniqueRequestName });
        action.setCallback(this, function(a) {
            cmp.set('v.vlcLoading', false);
            if (a.getState() === 'SUCCESS') {
                var nextLookupRequests = JSON.parse(a.getReturnValue());
                cmp.set('v.activePane', 5);
                
                if (callerData.verificationResult) {
                    nextLookupRequests[0].verificationResult = callerData.verificationResult;
                } else {
                    nextLookupRequests[0].verificationResult.status = true;
                    nextLookupRequests[0].verificationResult.timestamp = new Date();
                }
                nextLookupRequests[0].parentId = newRecordId;
                cmp.set('v.nextLookupRequests',nextLookupRequests );
                cmp.set('v.moreRequests',nextLookupRequests[0].moreRequests);
                
            }
        });
        $A.enqueueAction(action);
    },
    onNavigate : function(cmp, url, label, urlOpenMode, subTabUrl, input, interactionId, interactionName) {
        var workspace = cmp.find('workspace');
        var utilityAPI = cmp.find('utilitybar');
        var doneData;
        var isAbsoluteUrl = new RegExp('^(?:[a-z]+:)?//', 'i');
        var oldStyleOmniRegex = new RegExp("/OmniScriptType/([^/]*)/OmniScriptSubType/([^/]*)/OmniScriptLang/([^/]*)/ContextId/([^/]*)/");
        subTabUrl = '';
        if (isAbsoluteUrl.test(url)) {
            var params = (urlOpenMode === 'New Tab / Window') ? '_blank' : '_self';
            if (params === '_self') {
                window.open(url, params);
            }
        } else if (url.indexOf('apex') < 0) {
            url = '#/sObject/' + url;
            label = '';
        } else {
            var matches = oldStyleOmniRegex.exec(url);
            if(matches !== null && matches.length > 0) {
                var urlObj = {
                    componentDef : "vlocity_cmt:OmniScript",
                    attributes: {
                        type: matches[1],
                        subtype: matches[2],
                        language: matches[3],
                        recordId: (matches[4] || this.getUrlParam(url, 'ContextId') || this.getUrlParam(url, 'id'))
                    }
                };
                var lightningRedirect = JSON.stringify(urlObj);
                var lightningInstanceUrl = '/one/one.app#' + window.btoa(lightningRedirect);
                url = lightningInstanceUrl;
            } else {
                var urlObj = {
                    componentDef : "one:alohaPage",
                    attributes: {
                        values: {
                            address : url
                        },
                        history: []
                    }
                };
                var lightningRedirect = JSON.stringify(urlObj);
                var lightningInstanceUrl = '/one/one.app#' + window.btoa(lightningRedirect);
                url = lightningInstanceUrl;
            }
        }
        
        var actionData = {
                currentUrl: url,
                currentLabel: label
        };

        

	    var isInConsole = true;
		if(isInConsole) {
            if(url != null) {
                if (!input.tabId || input.focusedTabId) {  
                    workspace.openTab({
                        url: actionData.currentUrl, 
                        focus: true}).then(function(response) {
                        var tabId = response;
                            workspace.setTabLabel({
                                tabId: tabId,
                                label: actionData.currentLabel ? actionData.currentLabel : 
                                        (interactionName ? interactionName + ' - ' + interactionId : interactionId)
                            });
                            workspace.setTabIcon({
                                tabId: tabId,
                                iconAlt : 'Tab'
                            });
                
                            utilityAPI.minimizeUtility();
                           // workspace.focusTab({tabId : response});  
                            if(subTabUrl) {
                                workspace.openSubtab({
                                    parentTabId : tabId,
                                    url :  subTabUrl,
                                    focus: true
                                }).then(function(res) {
                                    workspace.setTabIcon({
                                        tabId: res,
                                        iconAlt : 'subTab'
                                    });
                                });
                            } 
                        })
                        .catch(function(error) {
                            console.log(error);
                        });
                }
            }
        }
    },
    getUrlParam: function(url, paramName) {
        var paramMatch = new RegExp(paramName + '=([^&#=]*)', 'i').exec(url);
        if (paramMatch && paramMatch.length > 1) {
            return decodeURIComponent(paramMatch[1]);
        }
        return null;
    },
    invokeVOIMethod : function(cmp, recordId, searchType, tabId, selectedAction, input, verifyAction) {
    		var callerData = cmp.get('v.callerData');
            // Case 5
            if (selectedAction && selectedAction.url && !selectedAction.className && !selectedAction.methodName) {
                // Need to add tabId in this case so url opens in a subtab:
               
                var subTabUrl = input.tabId ? selectedAction.url : null;
                this.onNavigate(cmp,
                    selectedAction.url,
                    selectedAction.displayName,
                    selectedAction.openUrlIn,
                    subTabUrl,
                    input,
                    false,
                    false
                );
                cmp.set('v.activePane', 4);
                return;
            // Cases 1-4
            } else if (selectedAction.className && selectedAction.methodName) {
                var option = {};
                var parentActionUrl, actionUrl, doneData;
                console.log('input in checkFieldVerificationAndProcess callback', input);
                console.log('passing input stringified: ', input);
    			var action = cmp.get('c.invokeAuraVOIMethod');
    			action.setParams({ 'className' : selectedAction.className ,
                                  'methodName' : selectedAction.methodName,
                                  inputJson : JSON.stringify(input),
                                  optionJson : JSON.stringify(option) });
                action.setCallback(this, function(result) {
                    var remoteResp = JSON.parse(JSON.parse(result.getReturnValue()));
                    console.log('invokeVOIMethod: ', result);
                    if (remoteResp && remoteResp.Error !== 'OK') {
                        this.showAlert(cmp,'error',remoteResp.Error);
                    } else {
                        if (remoteResp[input.interactionObjName + 'Id'] === undefined ||
                            remoteResp['parent' + input.interactionObjName + 'Id'] === undefined) {
                            this.showAlert(cmp,'error','There was an error creating the ' + input.interactionObjName);
                            return;
                        }
                        if (selectedAction.url) {
                            // URL & caseId
                            if (remoteResp[input.interactionObjName + 'Id']) {
                                actionUrl = selectedAction.url +
                                    '?launchSource=VlocityInteraction&' +
                                    input.interactionObjName +
                                    'Id=' + remoteResp[input.interactionObjName + 'Id'];
                                parentActionUrl = actionUrl;
                                if (remoteResp['parent' + input.interactionObjName + 'Id']) {
                                    actionUrl = actionUrl + '&parent' + input.interactionObjName + 'Id=' +
                                        remoteResp['parent' + input.interactionObjName + 'Id'];
                                    parentActionUrl = actionUrl;
                                }
                            // URL & no caseId
                            } else {
                                actionUrl = selectedAction.url + '?launchSource=VlocityInteraction';
                                parentActionUrl = actionUrl;
                            }
                        } else if (verifyAction) {
                            // This is a verifyAction and we just needed to invokeVOIMethod so custom code gets
                            // run.
                            console.log('verifyAction found, action invoked.');
                            return;
                        // No URL
                        } else {
                            // No URL & caseId exists
                            if (remoteResp[input.interactionObjName + 'Id']) {
                                actionUrl =  remoteResp[input.interactionObjName + 'Id'] +
                                    '?launchSource=VlocityInteraction';
                                parentActionUrl = remoteResp['parent' + input.interactionObjName + 'Id'] +
                                    '?launchSource=VlocityInteraction';
                            // No URL & no caseId
                            }
                        }
                        console.log('actionUrl:', actionUrl);
                        console.log('parentActionUrl:', parentActionUrl);
                            console.log('tab Id : ',input.tabId);
                            this.onNavigate( cmp,
                                parentActionUrl,
                                selectedAction.displayName,
                                selectedAction.openUrlIn,
                                actionUrl,
                                input,
                                remoteResp[input.interactionObjName + 'Id'],
                                remoteResp[input.interactionObjName + 'Name']
                            );
                            cmp.set('v.activePane', 4);
                    }
                });
                $A.enqueueAction(action);
            // Case 6
            } else {
                this.showAlert(cmp,'error','Action Button not configured correctly.');
                return;
            }
        },
    getRoleBasedActions : function(cmp, result) {
    	var action = cmp.get('c.getAuraRoleBasedActions');
    	action.setParams({ 'objectName' : result.request.referenceObjectName, 'recordId' : null });   
        action.setCallback(this, function(a) {
            var res = a.getReturnValue();
            cmp.set('v.roleBasedActions', JSON.parse(res));
        });
        $A.enqueueAction(action);
    },
    relaunchVerifiedCaller : function(cmp, data) {
        var utilityAPI = cmp.find('utilitybar');
        utilityAPI.openUtility();
        cmp.set('v.vlcLoading', true);
        var action = cmp.get('c.getAuraNextLookupRequests');
        action.setParams({'contextIds' : [data.recordId], 'searchUniqueName' : data.searchType, 'additionalData' : data});
        action.setCallback(this, function(a) {
            cmp.set('v.activePane', 5);
            cmp.set('v.vlcLoading', false);
            if (a.getState() === 'SUCCESS') {
                var nextLookupRequests = JSON.parse(a.getReturnValue());
                if(nextLookupRequests && nextLookupRequests.length) {
                    nextLookupRequests[0].verificationResult.status = true;
                    nextLookupRequests[0].verificationResult.timestamp = new Date();
                    nextLookupRequests[0].parentId = data.recordId;
                    cmp.set('v.nextLookupRequests',nextLookupRequests);
                    cmp.set('v.moreRequests',nextLookupRequests[0].moreRequests);
                    cmp.set('v.callerData',{request: nextLookupRequests[0].request});
                } else {
                    cmp.set('v.activePane', 0);
                    this.showAlert(cmp,'error', 'No result found or invalid configuration');
                }

            }  else if (a.getState() === 'ERROR'){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.activePane', 0);
                        this.showAlert(cmp,'error', 'Invalid Configuration or Configuration not active');
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    launchIL : function(cmp){
        var refresh = cmp.get('c.refresh');
        $A.enqueueAction(refresh);
        var utilityAPI = cmp.find('utilitybar');
        utilityAPI.openUtility();
    },
    displayResult : function(cmp, data) {
        var utilityAPI = cmp.find('utilitybar');
        var isSecondSearch = false;
        utilityAPI.openUtility();
        cmp.set('v.vlcLoading', true);
        var action = cmp.get('c.getAuraSearchResultByIds');
        action.setParams({'contextIds' : (data.recordId ? [data.recordId] : null), 'searchUniqueName' : data.searchType, 'additionalData' : data});
        action.setCallback(this, function(a) {
            cmp.set('v.vlcLoading', false);
            if (a.getState() === 'SUCCESS') {
                var result = JSON.parse(a.getReturnValue());
                var searchResult = result && result.parentContextSearchResult;
                if(searchResult && searchResult.length) {
                    cmp.set('v.searchResult',searchResult);
                    var searchSection = searchResult[searchResult.length - 1].request;
                    this.getResultActions(cmp, searchSection, isSecondSearch);
                } else {
                    cmp.set('v.activePane', 0);
                    this.showAlert(cmp,'error', 'No result found or invalid configuration');
                }
            } else if (a.getState() === 'ERROR'){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.activePane', 0);
                        this.showAlert(cmp,'error', 'Invalid Configuration or Configuration not active');
                    }
                }
            }

        });
        $A.enqueueAction(action);
    },
    verifyCaller : function(cmp, data) {
        var utilityAPI = cmp.find('utilitybar');
        var isSecondSearch = false;
        utilityAPI.openUtility();
        cmp.set('v.vlcLoading', true);
        var action = cmp.get('c.getAuraVerifyResultById');
        action.setParams({'contextId' : data.recordId , 'searchUniqueName' : data.searchType, 'additionalData' : data});
        action.setCallback(this, function(a) {
            cmp.set('v.vlcLoading', false);
            if (a.getState() === 'SUCCESS') {
                var result = JSON.parse(a.getReturnValue());
                if(result && result.length) {
                    var callerData = result[0];
                    callerData.recordId = data.recordId;
                    cmp.set('v.callerData', callerData);
                    this.getVerificationActions(cmp,isSecondSearch);
                    cmp.set('v.activePane', 3);
                } else {
                    cmp.set('v.activePane', 0);
                    this.showAlert(cmp,'error', 'No result found or invalid configuration');
                }
            } else if (a.getState() === 'ERROR'){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        cmp.set('v.activePane', 0);
                        this.showAlert(cmp,'error', 'Invalid Configuration or Configuration not active');
                    }
                }
            }

        });
        $A.enqueueAction(action);
    }
    
})