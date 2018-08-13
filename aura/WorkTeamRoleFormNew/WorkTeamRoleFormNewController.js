({
    doInit: function(component, event, helper) {
        var wtId = component.get("v.WorkTeamID");
        var action = component.get("c.getWorkTeamNameByID");
        action.setParams({
            "IdName": wtId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.WorkTeamName", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    doInitName: function(component, event, helper) {
        var wtId = component.get("v.WorkTeamID");
        var action = component.get("c.getAllUserRoles");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.WorkTeamAPIName", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    saveChangedAll : function(component, event, helper) {
        var workTeamId = component.get("v.WorkTeamID");
        var roleAPIname = component.find('roleAPIname').get('v.value');
        var userManagerName = component.get("v.Manager.Name");
        var workTeamName = component.get("v.WorkTeamName");
        var workTeamRoleName = component.get("v.WorkTeamRoleName");

        if(roleAPIname == '' || roleAPIname == 'NoSelected') {
            component.set("v.messageHelp", "Debe seleccionar un rol");
            document.getElementById("message__helper").style.display = "block";
        }else{
            var action = component.get("c.saveWorkTeamRole");
        	action.setParams({
                "workTeamId": workTeamId,
                "roleAPIname": roleAPIname
        	});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue() !== '' ){
                        component.set("v.messageHelp", response.getReturnValue());
                        document.getElementById("message__helper").style.display = "block";
                    }else{
                        component.set("v.showWorkTeamList","false");
                        component.set("v.showWorkTeamCreate","false");
                        component.set("v.showWorkTeamDetail","true");
                        component.set("v.showWorkTeamMembers","false");
                        component.set("v.showWorkTeamRoles","false");                        
                    }
                }
                else {
                    console.log("Failed with state: " + state);
                  }
               });
          $A.enqueueAction(action);
       }    
	},    
    searchWorkTeam: function(component, event, helper) {
       helper.searchWorkTeam(component, event);
    },
    hiddenUsersModalWorkTeam: function(component, event, helper) {
        helper.hiddenUsersModalWorkTeam();
    },
    selectThisWorkTeam: function(component, event, helper) {
        helper.selectThisWorkTeam(component, event);
    },
    hiddenMessageModal : function() {
        document.getElementById("message__helper").style.display = "none";       
    },
    cancelChanged: function(component, event) {
       component.set("v.showWorkTeamList","false");
       component.set("v.showWorkTeamCreate","false");
       component.set("v.showWorkTeamDetail","true");
       component.set("v.showWorkTeamMembers","false");
       component.set("v.showWorkTeamRoles","false");
    }
})