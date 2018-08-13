({
	getWorkTeam : function(component, event, helper) {
        if (component.get("v.WorkTeamID") != undefined && component.get("v.WorkTeamID") != ''){
            var id = component.get("v.WorkTeamID");
            var action = component.get("c.getWorkTeamById");
            action.setParams({
                "id": id
            });
            
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    component.set("v.WorkTeam.Id", response.getReturnValue().Id);
                    component.set("v.WorkTeam.Name", response.getReturnValue().Name);
                    component.set("v.WorkTeam.Is_Active__c", response.getReturnValue().Is_Active__c);
                    component.set("v.WorkTeam.LabelWorkTeamIsActive", response.getReturnValue().LabelWorkTeamIsActive);
                    if (response.getReturnValue().Team_Queue__c) component.set("v.WorkTeam.Team_Queue__c", response.getReturnValue().Team_Queue__c);
                    if (response.getReturnValue().Parent_Team__r) {
                        component.set("v.WorkTeamParent.Id", response.getReturnValue().Parent_Team__r.Id);
                    	component.set("v.WorkTeamParent.Name", response.getReturnValue().Parent_Team__r.Name);
                    }
                    if (response.getReturnValue().Manager__r) {
                        component.set("v.Manager.Id", response.getReturnValue().Manager__r.Id);
                        component.set("v.Manager.Name", response.getReturnValue().Manager__r.Name);
                        component.set("v.Manager.Profile.UserLicense.Name", response.getReturnValue().Manager__r.Profile.UserLicense.Name);
                        if (component.get("v.Manager.Profile.UserLicense.Name") == 'Salesforce') component.find('userType').set('v.value','user');
                        if (component.get("v.Manager.Profile.UserLicense.Name") == 'Partner Commuinty') component.find('userType').set('v.value','partner');
                        if (component.get("v.Manager.Profile.UserLicense.Name") == 'ustomer Community') component.find('userType').set('v.value','portal');
                        
                    }
                }
            });
            // Send action off to be executed
            $A.enqueueAction(action);
        }
	},
    onChangeUserType : function(component, event, helper) {
        var userType = component.find('userType').get('v.value');
        var licence = '';
        if (userType == 'user') licence = 'Salesforce';
        if (userType == 'partner') licence = 'Partner Community';
        if (userType == 'portal') licence = 'Customer Community';
		component.set("v.Manager.Profile.UserLicense.Name", licence);
	},
    searchUser : function(component, event, helper) {
        helper.searchUser(component, event);
    },
    selectThisManager : function(component, event, helper) {
        helper.selectThisManager(component, event);
    },
    showUsersModal : function(component, event, helper) {
        helper.showUsersModal();
    },
    hiddenUsersModal : function(component, event, helper) {
        helper.hiddenUsersModal();
    },
    searchWorkTeams : function(component, event, helper) {
        helper.searchWorkTeams(component, event);
    },
    hiddenWorkTeamsModal : function(component, event, helper) {
        helper.hiddenWorkTeamsModal();
    },
    showWorkTeamsModal : function(component, event, helper) {
        helper.showWorkTeamsModal();
    },
    selectThisWorkTeam : function(component, event, helper) {
        helper.selectThisWorkTeam(component, event);
    },
    saveWorkTeam : function(component, event, helper) {
        helper.saveWorkTeam(component, event);
    },
    cancelWorkTeam : function(component, event, helper) {
        helper.cancelWorkTeam(component, event);
    },
    hiddenMessageModal : function(component, event, helper) {
        helper.hiddenMessageModal(component, event);
    },
    showMessageModal : function(component, event, helper) {
        helper.showMessageModal();
    },
    searchStoreLocations : function(component, event, helper) {
        helper.searchStoreLocations(component, event);
    },
    selectThisStoreLocation : function(component, event, helper) {
        helper.selectThisStoreLocation(component, event);
    },
    hiddenStoreLocationsModal : function(component, event, helper) {
        helper.hiddenStoreLocationsModal();
    }
})