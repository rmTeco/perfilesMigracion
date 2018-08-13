({
	getWorkTeams : function(component, event, helper) {
        helper.getWorkTeams(component, event);
        helper.onScroll(component);
	},
    detailWorkTeam : function (component, event, helper) {
        var id = event.getSource().get("v.name");
        var WorkTeamDetailEvent = component.getEvent("WorkTeamDetailEventFired");
        WorkTeamDetailEvent.setParams({ "WorkTeamID" : id });
        WorkTeamDetailEvent.fire();
    },
    newWorkTeam : function (component, event, helper) {
        component.set("v.WorkTeamID",'');
        var WorkTeamNewEvent = component.getEvent("WorkTeamNewEventFired");
        WorkTeamNewEvent.setParams({ "WorkTeamID" : '' });
        WorkTeamNewEvent.fire();
    },
    editWorkTeam : function (component, event, helper) {
        var id = event.getSource().get("v.name");
        var WorkTeamNewEvent = component.getEvent("WorkTeamNewEventFired");
        WorkTeamNewEvent.setParams({ "WorkTeamID" : id });
        WorkTeamNewEvent.fire();
    },
    keyCheck : function(component, event, helper) {
        if(event.getParams().keyCode == 13) {
            document.querySelector("#btn-aux").click();
            document.querySelector("#btn-search").click();
        }
    },
    deleteRecord : function(component, event, helper) {
        helper.deleteRecord(component, event);
    }
})