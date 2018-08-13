({
	// This method executes when the data in the row is updated. It
	// sends out an event to inform the Data Table what to do with the record.
	sendUpdateRecordEvent : function(component, helper) {
		var record = component.get("v.record");
		var enabled = component.get("v.enabled");
		var action;
		if(record.et4ae5__Enabled__c != enabled){
			action = "add";
			record.et4ae5__Enabled__c = enabled;
		}else{
			action = "remove";
		}
		var updateEvent = component.getEvent("UpdateRecord");
		updateEvent.setParams({
			"action": action,
			"record": record
        }).fire();
	}
})