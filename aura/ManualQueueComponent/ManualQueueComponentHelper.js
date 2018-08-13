({
    initialize : function(component) {
        var recordId = component.get("v.recordId");
        var userId = component.get("v.userId");
        var displayedFields = component.get("v.displayedFields");
        
        var action = component.get("c.getManualQueueItems");
        action.setParams ({
            "manualQueueId" : recordId,
            "userId" : userId,
            "displayedFields" : displayedFields
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var mqTableData = response.getReturnValue();
            
            if(state == "SUCCESS") {
                component.set("v.mqTableData", mqTableData);
            }
        });
        $A.enqueueAction(action);
    },
    
    retryOperation : function(component, recordId) {
        var action = component.get("c.performRetryAction");
        action.setParams ({
            "orchestrationItemId" : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var orchestrationItem = response.getReturnValue();
            
            if(state == "SUCCESS") {
                var urlEvent = $A.get("e.force:navigateToSObject");
                urlEvent.setParams({
                    "recordId": orchestrationItem.Id
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    pickUpOperation : function(component, recordId) {
        
        var action = component.get("c.performPickUpAction");
        action.setParams ({
            "orchestrationItemId" : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var orchestrationItem = response.getReturnValue();
            
            if(state == "SUCCESS") {
                var urlEvent = $A.get("e.force:navigateToSObject");
                urlEvent.setParams({
                    "recordId": orchestrationItem.Id
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    completeOperation : function(component, recordId) {

        var action = component.get("c.performCompleteAction");
        action.setParams ({
            "orchestrationItemId" : recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var orchestrationItemId = response.getReturnValue();
            
            if(state == "SUCCESS") {
                var urlEvent = $A.get("e.force:navigateToSObject");
                urlEvent.setParams({
                    "recordId": recordId
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})