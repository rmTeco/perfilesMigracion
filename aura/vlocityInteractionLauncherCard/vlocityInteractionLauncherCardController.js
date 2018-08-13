({
	doInit : function(component, event, helper) {
        var prefix  = "";
		var workspaceAPI = component.find("workspace");
        var recordId = component.get("v.recordId");
        var sObjectName = component.get("v.sObjectName");
        var action = component.get('c.getNameSpacePrefix');
        action.setCallback(this, function(a) {
            prefix = a.getReturnValue();
            var objType = sObjectName.replace(prefix,'');
            if(objType.toLowerCase() === "customerinteraction__c") {
                var getCustomerInteraction = component.get('c.getCustomerInteraction');
                getCustomerInteraction.setParams({ 'recordId' : recordId });
                getCustomerInteraction.setCallback(this, function(a) { 
                	var result = JSON.parse(a.getReturnValue());
                    var layout = result[prefix + "ConsoleCardLayout__c"];
                    if(layout) {
                        component.set("v.layout",layout);
                    	helper.getBaseURL(component);
                    } else {
                        component.set("v.islayout", false);
                    }
                    
                });
                $A.enqueueAction(getCustomerInteraction);
            }
        });
        $A.enqueueAction(action);
    },
    handleCardEvent: function(cmp, event, helper) {
        var layoutName = event.getParam("layoutName");
        var message = event.getParam("message");

        helper.sendIframeMessage(cmp, {
            type: "cardevent",
            layoutName: layoutName,
            message: message
        });
    }
    
})