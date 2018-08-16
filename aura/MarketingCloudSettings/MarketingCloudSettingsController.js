({
    onInit : function(component, event, helper) {
        var action = component.get("c.retrieveMarketingCloudSettings");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var settings = JSON.parse(response.getReturnValue());
                if(!settings.hasErrors) {
                    //delete attributes that make the sObjects invalid
                    delete settings.configuration.attributes;
                    delete settings.cmConfiguration.attributes;
                    component.set("v.config", settings.configuration);
                    component.set("v.cmConfig", settings.cmConfiguration);
                    helper.setAlternateReplyto(component, settings.configuration.et4ae5__MultiReplyTo__c);
                    helper.setUpAudiences(component, settings.configuration.et4ae5__Target_Audience__c, settings.configuration.et4ae5__Exclusion_Audience__c);
                    helper.setUpSendTypes(component, settings.sendTypes, settings.configuration.et4ae5__Send_Types__c);
                    helper.setUpDeepLinks(component,settings.configuration.et4ae5__Deep_Link_Availability__c);
                    helper.setUpTSRestrictions(component, settings.configuration.et4ae5__Restrict_Automation__c);
                    helper.setUpTrackingFrequencies(component,settings.configuration.et4ae5__Frequency__c);
                    helper.setUpTriggeredSendObjects(component, settings.objects, settings.configuration.et4ae5__automationObjects__c);
                    helper.setLastLogRequest(component, settings.configuration.et4ae5__Last_Log_Request__c);
                    helper.setUpRetryView(component, settings.configuration.et4ae5__Retry__c);
                    helper.setUpPersonalReportsView(component, settings.configuration.et4ae5__Allow_Personal_Reports__c);
                    helper.setUpCampaignMemberView(component, settings.cmConfiguration.et4ae5__CampaignMemberIntegrationEnabled__c);
                    helper.setUpTrackingEnablement(component, settings.configuration.et4ae5__Aggregate_Tracking__c, settings.configuration.et4ae5__Individual_Tracking__c, settings.configuration.et4ae5__Link_Detail_Tracking__c, settings.configuration.et4ae5__Sent_Events_Tracking__c);
                    component.set("v.retrievedMarketingCloudSettings",true);
                    if(helper.determineEditMode(component, settings.configuration)) {
                        helper.editMCSettings(component);
                        helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0222"), $A.get("$Label.et4ae5.setUpMCC"), "info");
                    }

                }
                else {
                    helper.bc_throwEventMessage(component, settings.message, settings.messageTitle, "error");
                }
            }
            else
                helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0223"), $A.get("$Label.et4ae5.srySmtgWrng"), "error");
        });
        $A.enqueueAction(action);
    },

    startLog : function (component, event, helper) {
    	var action = component.get("c.initiateLog");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                component.find("viewLogging").set("v.value", $A.get("$Label.et4ae5.loggingOn"));
                component.find("editLogging").set("v.value", $A.get("$Label.et4ae5.loggingOn"));
                component.set("v.logStarted",true);
                component.set("v.lastLogRequestDateTime", response.getReturnValue());
            }
            else if (state === "ERROR")
                helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0224"), $A.get("$Label.et4ae5.validYourPerm"), "error");
            else
                helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0223"), $A.get("$Label.et4ae5.srySmtgWrng"), "error");
        });
        $A.enqueueAction(action);
    },

    saveMCSettings : function(component, event, helper) {
        var updatedConfig = component.get("v.config");
        var updatedCmConfig = component.get("v.cmConfig");
        updatedConfig.et4ae5__Deep_Link_Availability__c = component.find("editDeepLinkAvailability").get("v.value");
        updatedConfig.et4ae5__Restrict_Automation__c = helper.calculateTSRestrictions(component.find("editRestriction").get("v.value"));
        updatedConfig.et4ae5__Frequency__c = component.find("editTrackingFrequency").get("v.value");
        updatedConfig.et4ae5__Send_Types__c = helper.buildSendTypesString(component);
        updatedConfig.et4ae5__Target_Audience__c = helper.buildAudiencesString(component);
        updatedConfig.et4ae5__Exclusion_Audience__c = helper.buildExclusionsString(component);
        updatedConfig.et4ae5__automationObjects__c = helper.buildTrigSendObjectsString(component.get("v.enabledObjectsSelected"), component);
        updatedConfig.et4ae5__Last_Log_Request__c=helper.buildLastLogRequest(component);
        updatedConfig.et4ae5__Support_Ticket_Recipient__c=helper.buildSupportTicketRecipient(component);
        updatedConfig.et4ae5__Days_Tracked__c = helper.determineNumberOfDaysTracked(component, updatedConfig.et4ae5__Days_Tracked__c);
        var hasErrors = component.find("editSendTypesEmail").get("v.errors") || component.find("editTargetAudienceReport").get("v.errors") || component.find("editSupportTicketRecipient").get("v.errors") || component.find("editNumberDaysTracked").get("v.errors");
        if(hasErrors)
            helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0225"), $A.get("$Label.et4ae5.srySmtgWrng"), "error");
        else {
            var action = component.get("c.saveSettings");
            action.setParams( {
                "modifiedConfig" : updatedConfig,
                "modifiedCmConfig" : updatedCmConfig
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state == "SUCCESS"){
                    var res = JSON.parse(response.getReturnValue());
                    if(!res.hasErrors) {
                        helper.bc_throwEventMessage(component,$A.get("$Label.et4ae5.msg0226"),$A.get("$Label.et4ae5.updtYrSettgs"),"confirm");
                        if(res.destination === "MarketingCloudSettings")
                            location.reload();
                        else
                            window.location.href = "/apex/businessUnitHold";
                    }
                    // Email regex validation was moved to the server-side to avoid inequivalent validation results    
                    else if (res.emailError) {
                        //Set the error for email
                        component.find("editSupportTicketRecipient").set("v.errors",[{message : $A.get("$Label.et4ae5.msg0236")}]);
                        //Throw the message
                        helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0225"), $A.get("$Label.et4ae5.srySmtgWrng"), "error");
                    }
                    else {
                        helper.bc_throwEventMessage(component, res.message, res.messageTitle, "error");
                    }
                }
                else
                    helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.msg0227"), $A.get("$Label.et4ae5.srySmtgWrng"), "error");
            });
            $A.enqueueAction(action);
        }
    },

    advancedSettingsClick : function (component, event, helper) {
		var showAdvancedSettings = component.get("v.showAdvancedSettings");
		if(showAdvancedSettings){
			component.set("v.showAdvancedSettings", false);
		}else{
			component.set("v.showAdvancedSettings", true);
		}
    },

    afterScriptsLoaded : function (component, event, helper) {

        component.find("MCMultiRightArrow").getElement().addEventListener("click", function() {
        	var selectedvalues = component.find("editEnabledObjectsLeft").get("v.value").split(';');
            var rightvalues = component.get("v.enabledObjectsSelected");
            var leftvalues = component.get("v.enabledObjectsAvailable");
            component.set("v.enabledObjectsSelected", helper.addValues(component, rightvalues, selectedvalues));
            component.set("v.enabledObjectsAvailable", helper.removeValues(component, leftvalues, selectedvalues));
        });

        component.find("MCMultiLeftArrow").getElement().addEventListener("click", function() {
        	var selectedvalues = component.find("editEnabledObjectsRight").get("v.value").split(';');
            var rightvalues = component.get("v.enabledObjectsSelected");
            var leftvalues = component.get("v.enabledObjectsAvailable");
            component.set("v.enabledObjectsSelected", helper.removeValues(component, rightvalues, selectedvalues));
            component.set("v.enabledObjectsAvailable", helper.addValues(component, leftvalues, selectedvalues));
        });

        component.find("MCMultiTopArrow").getElement().addEventListener("click", function() {
        	var selectedvalues = component.find("editEnabledObjectsRight").get("v.value").split(';');
            var rightvalues = component.get("v.enabledObjectsSelected");
            component.set("v.enabledObjectsSelected", helper.moveValueUp(component, rightvalues, selectedvalues[0]));
        });

        component.find("MCMultiBottomArrow").getElement().addEventListener("click", function() {
        	var selectedvalues = component.find("editEnabledObjectsRight").get("v.value").split(';');
            var rightvalues = component.get("v.enabledObjectsSelected");
            component.set("v.enabledObjectsSelected", helper.moveValueDown(component, rightvalues, selectedvalues[0]));
        });

        component.set("v.isScriptLoaded",true);

    },

    editSettings : function (component, event, helper) {
    	helper.editMCSettings(component);
    },

    cancelSaveSettings : function (component, helper) {
    	component.set("v.isCancelSet",true);
        component.set("v.isEdit",false);
    },

    aggregateClicked : function(component, event, helper) {
        var aggregateCheckBox = component.find("editAggregateTracking");
        if(!aggregateCheckBox.get("v.value")){
            var individualCheckBox = component.find("editIndividualTracking");
            individualCheckBox.set("v.value", false);
            var linkCheckBox = component.find("editLinkDetailsTracking");
            linkCheckBox.set("v.value", false);
            var sentCheckBox = component.find("editSentEventsTracking");
            sentCheckBox.set("v.value", false);
        }
    },

    individualClicked : function(component, event, helper) {
        var individualCheckBox = component.find("editIndividualTracking");
        if(individualCheckBox.get("v.value")){
            var aggregateCheckBox = component.find("editAggregateTracking");
            aggregateCheckBox.set("v.value", true);
        }else{
            var linkCheckBox = component.find("editLinkDetailsTracking");
            linkCheckBox.set("v.value", false);
            var sentCheckBox = component.find("editSentEventsTracking");
            sentCheckBox.set("v.value", false);
        }
    },

    linkClicked : function(component, event, helper) {
        var linkCheckBox = component.find("editLinkDetailsTracking");
        if(linkCheckBox.get("v.value")){
            var aggregateCheckBox = component.find("editAggregateTracking");
            aggregateCheckBox.set("v.value", true);
            var individualCheckBox = component.find("editIndividualTracking");
            individualCheckBox.set("v.value", true);
        }
    },

    sentClicked : function(component, event, helper) {
        var sentCheckBox = component.find("editSentEventsTracking");
        if(sentCheckBox.get("v.value")){
            var aggregateCheckBox = component.find("editAggregateTracking");
            aggregateCheckBox.set("v.value", true);
            var individualCheckBox = component.find("editIndividualTracking");
            individualCheckBox.set("v.value", true);
        }
    }
})