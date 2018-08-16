({
	getWorkTeams : function(component, event, helper) {
        component.set("v.WorkTeams",[]);
        var keyName = component.get("v.KeyName");
        var action = component.get("c.getWorkTeamsByKeyName");
        action.setParams({
            "keyName": keyName
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.WorkTeams", response.getReturnValue());
                component.set("v.isLoading","false");
            }
        });
        // Send action off to be executed
        $A.enqueueAction(action);
        component.set("v.isLoading","true");
	},
    createRecord : function (component, event, helper) {
        alert("Acción en mantenimiento");
        /*var createRecordEvent = $A.get("e.force:createRecord");
        if(!createRecordEvent) sforce.one.createRecord("WorkTeam__c");
        createRecordEvent.setParams({
            "entityApiName": "WorkTeam__c"
        });
        createRecordEvent.fire();*/
    }
})