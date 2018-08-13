({
	handleWorkTeamDetailEventFired : function (component, event, helper) {
        component.set("v.WorkTeamID", event.getParam("WorkTeamID"));        
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamDetail","true");
    },
    handleWorkTeamNewEventFired : function (component, event, helper) {
        if (event.getParam("WorkTeamID")) component.set("v.WorkTeamID", event.getParam("WorkTeamID"));
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","true");
        component.set("v.showWorkTeamDetail","false");
        component.set("v.showWorkTeamRoles","false");
        component.set("v.showWorkTeamQueues","false");            
    },
    handleWorkTeamMemberEventFired : function (component, event, helper) {
        component.set("v.WorkTeamID", event.getParam("WorkTeamID"));   
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamMembers","true");
        component.set("v.showWorkTeamRoles","false");
        component.set("v.showWorkTeamQueues","false");        
    },
    handleWorkTeamRoleEventFired : function (component, event, helper) {
        component.set("v.WorkTeamID", event.getParam("WorkTeamID"));   
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamMembers","false");
        component.set("v.showWorkTeamRoles","true");
        component.set("v.showWorkTeamQueues","false");
    },
    handleWorkTeamQueueEventFired : function (component, event, helper) {
        component.set("v.WorkTeamID", event.getParam("WorkTeamID"));   
        component.set("v.showWorkTeamList","false");
        component.set("v.showWorkTeamCreate","false");
        component.set("v.showWorkTeamMembers","false");
        component.set("v.showWorkTeamRoles","false");
        component.set("v.showWorkTeamQueues","true");
    }
})