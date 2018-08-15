({
    doInit: function(component, event, helper) {
        // Create the action
        var id = component.get("v.WorkTeamID");
        var action = component.get("c.getWorkTeamNameByID");
        action.setParams({
            "IdName": id
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.WorkTeamName", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    doInitName: function(component, event, helper) {
        // Create the action
        var id = component.get("v.WorkTeamID");
        var action = component.get("c.getAllRolesAndSubordinateRoles");
        action.setParams({
            "WorkTeamId": id
        });
       // alert("IDWOrk" + id );
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.WorkTeamAPIName", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    onChangeUserType : function(component, event, helper) {
        var userType = component.find('userType').get('v.value');
        var licence = '';
        if (userType == 'user') licence = 'Salesforce';
        if (userType == 'partner') licence = 'Partner Community';
        if (userType == 'portal') licence = 'Customer Community';
		component.set("v.Manager.Profile.UserLicense.Name", licence);
        //alert("here___" + WorkTeam.Name );
	},
    saveChangedAll : function(component, event, helper) {
        var roleAPIname = component.find('roleAPIname').get('v.value');
        var userManagerName = component.get("v.Manager.Name");
        var workTeamName = component.get("v.WorkTeamName");
        
        //alert("Alert save data_"+ roleAPIname + "_"+ "" + "_"+ userManagerName + "_"+ workTeamName);
        
        if(userManagerName == ''){
            component.set("v.messageHelp", "Debe seleccionar un usuario");
            document.getElementById("message__helper").style.display = "block";
        }else if(roleAPIname == '' || roleAPIname == 'NoSelected') {
            component.set("v.messageHelp", "Debe seleccionar un rol");
            document.getElementById("message__helper").style.display = "block";
        }else{
            //Here logic save WorkTeam Members
            var action = component.get("c.saveWorkTeamMembers");
        	action.setParams({
                "UserManagerName": userManagerName,
                "workTeamName": workTeamName,
                "roleAPIname":roleAPIname
        	});
          // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue() == true ){
                        component.set("v.showWorkTeamList","false");
                        component.set("v.showWorkTeamCreate","false");
                        component.set("v.showWorkTeamDetail","true");
                        component.set("v.showWorkTeamMembers","false");
                    }
                }
                else {
                    console.log("Failed with state: " + state);
                  }
               });
            // Send action off to be executed
          $A.enqueueAction(action);
       }    
	},    
    searchUser : function(component, event, helper) {
       helper.searchUser(component, event);
    },
    searchWorkTeam: function(component, event, helper) {
       helper.searchWorkTeam(component, event);
    },
    hiddenUsersModal : function(component, event, helper) {
        helper.hiddenUsersModal();
    },
    hiddenUsersModalWorkTeam: function(component, event, helper) {
        helper.hiddenUsersModalWorkTeam();
    },
    selectThisWorkTeam: function(component, event, helper) {
        helper.selectThisWorkTeam(component, event);
    },
    selectThisManager : function(component, event, helper) {
        helper.selectThisManager(component, event);
    },
    hiddenMessageModal : function() {
        document.getElementById("message__helper").style.display = "none";
    },
    cancelChanged: function(component, event) {
       component.set("v.showWorkTeamList","false");
       component.set("v.showWorkTeamCreate","false");
       component.set("v.showWorkTeamDetail","true");
       component.set("v.showWorkTeamMembers","false");
    }
})