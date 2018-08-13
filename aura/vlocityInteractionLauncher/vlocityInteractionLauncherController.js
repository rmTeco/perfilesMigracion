({
	doInit : function(component, event, helper) {
        helper.getNamespacePrefix(component);
        helper.getLookupRequest(component);
    },
    refresh : function(component, event, helper) {
        component.set('v.vlcLoading', true);
        component.set('v.activePane', 0);
        helper.getLookupRequest(component);
    },
    setActivePane : function(component, event, helper) {
        component.set('v.activePane', event.getSource().get('v.value'));
    },
    clearErrorMessage: function(component, event, helper) {
        helper.showAlert(component,'', '');
    },
    search: function(component, event, helper) {
        //component.set('v.vlcLoading', true);
       	helper.showAlert(component,'', '');
        //component.set('v.activePane', 1);
        var requests = component.get('v.lookupRequests');
        var searchSection = helper.checkSearchEntry(requests);
        
        if (searchSection === undefined || helper.isObjEmpty(searchSection)) {
            helper.showAlert(component,'default', $A.get('$Label.'+component.get('v.namespace')+'.InteractionLauncher_EnterSearchTerms'));
        } else {
            component.set('v.vlcLoading', true);
            helper.getSearchResult(component, requests, false);
        }
    },
    verifySearchResult: function(component, event, helper) {
        component.set('v.callerData',event.getSource().get('v.value'));
        helper.getVerificationActions(component, false);
        component.set('v.activePane', 3);
    },
    launchConsole : function(component, event, helper) {
        var uniqueRequestName = 'uniqueRequestName';
        var callerData = component.get('v.callerData');
        var searchResult = component.get('v.searchResult');
        var requests = component.get('v.lookupRequests');
        var launchAction = component.get('v.launchAction');
        var searchSection = helper.checkSearchEntry(requests);
        var policyData = {};
        if (!helper.isObjEmpty(callerData)) {
             policyData = callerData;
        } else if (searchResult.length && !helper.isObjEmpty(searchResult)) {
             policyData = searchResult[0];
        } else {
             policyData = searchSection;
             uniqueRequestName = 'requestUniqueName';
        }
        
        if(!helper.checkFieldVerificationAndProcess(component, policyData, launchAction ,true)) {
            return;
        }
        
        helper.invokeVOIMethod(component, policyData.recordId,
                    policyData[uniqueRequestName],
                    policyData.tabId,
                    launchAction,
                    policyData,
                    false);
        
    },
    verifyAndSearch : function(component, event, helper) { 
        var callerData = component.get('v.callerData');
        var policyData = {};
        if (!helper.isObjEmpty(callerData)) {
             policyData = callerData;
        }
        callerData.verificationResult.status = false;
		if(helper.checkFieldVerificationAndProcess(component, policyData, null ,null))
        {
            callerData.verificationResult.status = true;
            callerData.verificationResult.timestamp = new Date();
            helper.getLookupRequestsWithoutSearch(component);
        }

        component.set('v.callerData', callerData);
    },
    secondSearch : function(component, event, helper) { 
        helper.showAlert(component,'', '');
        
        var requests = component.get('v.moreRequests');
        var searchSection = helper.checkSearchEntry(requests);
        
        if (searchSection === undefined || helper.isObjEmpty(searchSection)) {
            helper.showAlert(component,'default', $A.get('$Label.'+component.get('v.namespace')+'.InteractionLauncher_EnterSearchTerms'));
        } else {
            component.set('v.vlcLoading', true);
            helper.getSearchResult(component, requests, true);
        }
    },
    invokeAction : function(component, event, helper) { 
        var action = event.currentTarget.dataset;
        var actionList = component.get('v.resultActions');
        if(!JSON.parse(action.isresultaction)) {
            actionList = component.get('v.verificationActions');
        }
        
        var selectedAction = actionList[action.value];
        
        var uniqueRequestName = 'uniqueRequestName';
        var callerData = component.get('v.callerData');
        var searchResult = component.get('v.searchResult');
        var requests = component.get('v.lookupRequests');
        var searchSection = helper.checkSearchEntry(requests);
        var policyData = {};
        if (!helper.isObjEmpty(callerData) && callerData != null) {
             policyData = callerData;
        } else if (searchResult.length && !helper.isObjEmpty(searchResult)) {
             policyData = searchResult[0];
        } else {
             policyData = searchSection;
             uniqueRequestName = 'requestUniqueName';
        }
        
        helper.invokeVOIMethod(component, policyData.recordId,
                    policyData[uniqueRequestName],
                    policyData.tabId,
                    selectedAction,
                    policyData,
                    false);
        
    },
    view : function(component, event, helper) { 
        var data = event.currentTarget.dataset;
        var selectedAction = component.get('v.launchAction');
        var searchResult = component.get('v.searchResult');
        var policyData = {};
        policyData = searchResult[data.index];
        
        helper.invokeVOIMethod(component, policyData.recordId,
                    policyData.uniqueRequestName,
                    policyData.tabId,
                    selectedAction,
                    policyData,
                    false);
        
    },
    viewVerifiedRequest : function(component, event, helper) { 
        var data = event.currentTarget.dataset;
        var selectedAction = component.get('v.launchAction');
        var searchResult = component.get('v.nextLookupRequests');
        var policyData = {};
        policyData = searchResult[data.index];
        
        helper.invokeVOIMethod(component, policyData.recordId,
                    policyData.uniqueRequestName,
                    policyData.tabId,
                    selectedAction,
                    policyData,
                    false);
        
    },
    handleSubmit : function(component, event, helper) {
        if (event.keyCode && event.keyCode == 13) {
            var activePane = component.get('v.activePane');
            var submitAction;
            activePane = parseInt(activePane);
            switch (activePane) {
                case 0:
                    submitAction = component.get('c.search');
                    $A.enqueueAction(submitAction);
                    break;
                case 3:
                    var callerData = component.get('v.callerData');
                    submitAction = callerData.request.continueSearch ? component.get('c.verifyAndSearch') : component.get('c.launchConsole');
                    $A.enqueueAction(submitAction);
                    break;
                case 5:
                    submitAction = component.get('c.secondSearch');
                    $A.enqueueAction(submitAction);
                default:
                    break;
            }

        }
    },
    handleILEvent: function(component, event, helper) { 
        helper.clearErrorMessage(component);
        var obj = event.getParams();
        var eventType = obj && obj.data.event;
        switch(eventType){
            case 'via-relaunch-verified-caller':
                  helper.relaunchVerifiedCaller(component,obj.data);
                  break;
            case 'via-launch-lookup-widget':
                  helper.launchIL(component);
                  break;
            case 'via-display-search-results':
                  helper.displayResult(component, obj.data);
                  break;
            case 'via-verify-caller-from-console':
                  helper.verifyCaller(component, obj.data);
                  break;
        }
    }
})