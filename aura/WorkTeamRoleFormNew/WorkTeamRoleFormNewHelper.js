({
    searchUser : function(component, event, methodName) {
		component.set("v.Managers",[]);
        var manager = component.get("v.Manager");
        var action = component.get("c.getUsersByLicenceAndKeyNameOrUserName");
        action.setParams({
            "licenseName": manager.Profile.UserLicense.Name,
            "keyName": manager.Name
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.Managers", response.getReturnValue());
                this.showUsersModal();
            }else{
                console.log('error: '+response.getState());
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
	},
    searchWorkTeam: function(component, event, methodName) {
        component.set("v.WorkTeamNameAll",[]);
        var workTeamName = component.find('searchWorkTeam').get('v.value');
        var action = component.get("c.getWorkTeamsByKeyNameOrderByName");
        action.setParams({
            "keyName": workTeamName
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.WorkTeamNameAll", response.getReturnValue());
                this.showUsersModalWorkTeam();
            }else{
                console.log('error: '+response.getState());
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
	},
    
    showUsersModal : function() {
        document.getElementById("usersModal__c").style.display = "block";
    },
    showUsersModalWorkTeam : function() {
        document.getElementById("usersModalWorkTeam__c").style.display = "block";
    },
     hiddenUsersModal : function() {
        document.getElementById("usersModal__c").style.display = "none";
    },
    hiddenUsersModalWorkTeam : function() {
        document.getElementById("usersModalWorkTeam__c").style.display = "none";
    },
    selectThisWorkTeam: function(component, event) {
        var workTeam = event.getSource();
        var msgBtnWorkTeam = workTeam.get("v.label");
        component.set("v.WorkTeamName",msgBtnWorkTeam);
        this.hiddenUsersModalWorkTeam();
    },
    selectThisManager : function(component, event) {
        var manager = event.getSource().get("v.title");
        component.set("v.Manager.Name",manager.Name);
        component.set("v.Manager.Id",manager.Id);
        this.hiddenUsersModal();
    }
})