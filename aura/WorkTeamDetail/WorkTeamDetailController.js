({
	getWorkTeam : function(component, event, helper) {
        var id = component.get("v.WorkTeamID");
        console.log('detail'+component.get("v.WorkTeamID"));
        var action = component.get("c.getWorkTeamById");
        action.setParams({
            "id": id
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.WorkTeam", response.getReturnValue());
                console.log(JSON.stringify(component.get("v.WorkTeam")));
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
	},
    handleSelect: function (component, event, helper) {
        var id = event.getSource().get("v.value");
        var actionName = event.detail.menuItem.get("v.label");
        
        var action = component.get("c.putWorkTeamMemberActive");
        action.setParams({
            "IdMember": id
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue().messageAlert) {
                    alert(response.getReturnValue().messageAlert);
                } else {
                    component.set("v.WorkTeam", response.getReturnValue());
                }
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    handleSelectRole: function (component, event, helper) {
        var id = event.getSource().get("v.value");        
        var action = component.get("c.inactivateWorkTeamPermissionRoleById");
        action.setParams({
            "id": id
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                if (response.getReturnValue().WorkTeamMembersWithRoleToInactivate) {
                    component.set("v.WorkTeamMembersWithRoleToInactivate",response.getReturnValue());
                    document.getElementById("usersModal__c").style.display = "block";
                } else {
                    component.set("v.WorkTeam", response.getReturnValue());
                }
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    handleSelectQueue: function (component, event, helper) {
        var id = event.getSource().get("v.value");     
        var action = component.get("c.inactivateWorkTeamPermissionQueueById");
        action.setParams({
            "id": id
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.WorkTeam", response.getReturnValue());
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    hiddenUsersModal : function() {
        document.getElementById("usersModal__c").style.display = "none";
    },
    getNewWorkTeamMembers: function(component, event, helper) {
		var id = event.getSource().get("v.name");
        component.set("v.WorkTeamID",id);
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamDetail","false");
        component.set("v.showWorkTeamMembers","true");
        component.set("v.showWorkTeamRoles","false");
        component.set("v.showWorkTeamQueues","false");
	},
    getNewWorkTeamRole: function(component, event, helper) {
		var id = event.getSource().get("v.name");
        component.set("v.WorkTeamID",id);
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamDetail","false");
        component.set("v.showWorkTeamMembers","false");
        component.set("v.showWorkTeamRoles","true");
        component.set("v.showWorkTeamQueues","false");
	},
    getNewWorkTeamQueue: function(component, event, helper) {
		var id = event.getSource().get("v.name");
        component.set("v.WorkTeamID",id);
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamDetail","false");
        component.set("v.showWorkTeamMembers","false");
        component.set("v.showWorkTeamRoles","false");
        component.set("v.showWorkTeamQueues","true");
	},      
    backToList : function(component, event) {
        component.set("v.showWorkTeamList","true");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamDetail","false");
        component.set("v.WorkTeamID","");
    }
})