({
    handleProfileUpdatedEvent: function(component, event, helper) {
        var appEvent = $A.get("e.vlocity_cmt:vlocityCardEvent");
        appEvent.setParams({
            "layoutName": component.get('v.layout'),
            "message" : {
                event: 'reload'
            } });
        appEvent.fire();
    }
})