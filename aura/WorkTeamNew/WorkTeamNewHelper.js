({
	searchUser : function(component, event, methodName) {
		component.set("v.Managers",[]);
        var manager = component.get("v.Manager");
        var action = component.get("c.getUsersByLicenceAndKeyName");
        action.setParams({
            "licenseName": manager.Profile.UserLicense.Name,
            "keyName": manager.Name
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.Managers", response.getReturnValue());
                console.log(JSON.stringify(component.get("v.Managers")));
                this.showUsersModal();
            }else{
                console.log('error: '+response.getState());
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
	},
    selectThisManager : function(component, event) {
        var manager = event.getSource().get("v.title");
        component.set("v.Manager.Name",manager.Name);
        component.set("v.Manager.Id",manager.Id);
        this.hiddenUsersModal();
    },
    showUsersModal : function() {
        document.getElementById("usersModal__c").style.display = "block";
    },
    hiddenUsersModal : function() {
        document.getElementById("usersModal__c").style.display = "none";
    },
    searchWorkTeams : function(component,event) {
        component.set("v.WorkTeamParents",[]);
        var workTeam = component.get("v.WorkTeamParent");
        var action = component.get("c.getWorkTeamsByKeyNameOrderByName");
        action.setParams({
            "keyName": workTeam.Name
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.WorkTeamParents", response.getReturnValue());
                this.showWorkTeamsModal();
            }else{
                console.log('error: '+response.getState());
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    selectThisWorkTeam : function(component, event) {
        var WorkTeamParent = event.getSource().get("v.title");
        component.set("v.WorkTeamParent",WorkTeamParent);
        this.hiddenWorkTeamsModal();
    },
    showWorkTeamsModal : function() {
        document.getElementById("workTeamsModal__c").style.display = "block";
    },
    hiddenWorkTeamsModal : function() {
        document.getElementById("workTeamsModal__c").style.display = "none";
    },
    saveWorkTeam : function(component, event) {
        if (!this.validateWorkTeam(component, event)) {
            this.showMessageModal();
            return;
        }
        
        var workTeam = component.get("v.WorkTeam");
        var manager = component.get("v.Manager.Id");
        var parent = component.get("v.WorkTeamParent.Id");
        var location = component.get("v.WorkTeamLocation.Id");
        var action = component.get("c.createWorkTeam");
        workTeam.Team_Name__c = workTeam.Name;
        action.setParams({
            "workTeam": workTeam,
            "manager": manager,
            "parent": parent,
            "location": location
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.messageHelp",'Equipo creado satisfactoriamente');
                this.showMessageModal(true);
                component.set("v.closeWindows", true);
                var id = event.getSource().get("v.name");
                var WorkTeamDetailEvent = component.getEvent("WorkTeamDetailEventFired");
                WorkTeamDetailEvent.setParams({ "WorkTeamID" : response.getReturnValue().Id });
                WorkTeamDetailEvent.fire();
            }else{
                component.set("v.messageHelp",'Error creando en el equipo de trabajo. Intente nuevamente.');
                this.showMessageModal();
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    cancelWorkTeam : function(component, event) {
        component.set("v.showWorkTeamList","true");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamDetail","false");
        component.set("v.WorkTeamID","");
    },
    validateWorkTeam : function(component, event) {
        var workTeam = component.get("v.WorkTeam");
        var manager = component.get("v.Manager");
        var parent = component.get("v.WorkTeamParent");
        
        var result = false;
        
        if (workTeam && workTeam.Name != undefined && workTeam.Name != '') {
            if ((manager && manager.Name != undefined && manager.Name != '' && manager.Id != undefined && manager.Id != '') || (manager && (manager.Name == undefined || manager.Name == ''))) {
                if ((parent && parent.Name != undefined && parent.Name != '' && parent.Id != undefined && parent.Id != '') || (parent && (parent.Name == undefined || parent.Name == ''))) {
                    result = true;
                } else {
                    component.set("v.messageHelp",'Verifique el padre del equipo de trabajo.');
                }
            } else {
                component.set("v.messageHelp",'Verifique el manager del equipo de trabajo.');
            }
        } else {
            component.set("v.messageHelp",'Verifique el nombre del equipo de trabajo.');
        }
        
        return result;
    },
    showMessageModal : function() {
        document.getElementById("message__helper").style.display = "block";
    },
    hiddenMessageModal : function(component, event) {
        document.getElementById("message__helper").style.display = "none";
        if (component.get("v.closeWindows")) {
            if ($A.get('e.force:refreshView')) {
                $A.get('e.force:refreshView').fire();
            } else {
                location.reload();
            }   
        }
    },
    searchStoreLocations : function(component,event) {
        component.set("v.SitesLocation",[]);
        var siteLocation = component.get("v.WorkTeamLocation");
        var action = component.get("c.getStoreLocationByWorkTeamName");
        action.setParams({
            "keyName": siteLocation.Name
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.WorkTeamLocations", response.getReturnValue());
                this.showStoreLocationsModal();
            }else{
                console.log('error: '+response.getState());
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    selectThisStoreLocation : function(component, event) {
        var WorkTeamLocation = event.getSource().get("v.title");
        component.set("v.WorkTeamLocation",WorkTeamLocation);
        this.hiddenStoreLocationsModal();
    },
    hiddenStoreLocationsModal : function() {
        document.getElementById("storeLocationModal__c").style.display = "none";
    },
    showStoreLocationsModal : function() {
        document.getElementById("storeLocationModal__c").style.display = "block";
    }
})