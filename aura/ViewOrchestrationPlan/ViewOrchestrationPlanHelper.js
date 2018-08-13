({
	initialize : function(component) {
		
        $A.get("e.force:closeQuickAction").fire();
        
        var orderId = component.get("v.recordId");
        var action = component.get("c.getOrchestrationPlanId");
        
        action.setParams ({
            "orderIdForOrch" : orderId
        });
        
        action.setCallback(this, function(response) {
            
            component.set("v.orchestrationId", response.getReturnValue());
            var state = response.getState();
            var OrchestrationId = component.get("v.orchestrationId");
            
            if(state == "SUCCESS") {
                if(OrchestrationId != null) {
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                        "recordId": OrchestrationId
                    });
                    urlEvent.fire();
                } else {
                    alert("Order is not associated with any Orchestration Plan!");
                    $A.get("e.force:closeQuickAction").fire();
                }
        	}
        });
        $A.enqueueAction(action);        
	}
})