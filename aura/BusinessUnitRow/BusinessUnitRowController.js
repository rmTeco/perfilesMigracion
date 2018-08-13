({
	doInit : function(component, event, helper) {
		var record = component.get("v.record");
        if($A.util.isUndefined(record.et4ae5__Enabled__c)) 
            component.find("enabledcheckbox").set("v.disabled", true);
        else
            component.set("v.enabled", record.et4ae5__Enabled__c);           
    },

	selectAllChange : function(component, event, helper) {
		var selected = event.getParam("selected");
		var record = component.get("v.record");
		//If value is undefined, we do not want to change it because the user doesnt have permission
        if($A.util.isUndefined(record.et4ae5__Enabled__c))
            return;
        
		component.set("v.enabled", selected);
		helper.sendUpdateRecordEvent(component, helper);
	},

	enabledChange : function(component, event, helper) {
		helper.sendUpdateRecordEvent(component, helper);
	}
})