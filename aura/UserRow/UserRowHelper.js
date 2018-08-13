({
	// This method executes when the data in the row is updated. It
	// sends out an event to inform the Data Table what to do with the record.
	sendUpdateRecordEvent : function(component, helper) {
		var record = component.get("v.record");
		var adminenabled = component.get("v.adminenabled");
		var userenabled = component.get("v.userenabled");
		var action;
		if(record.et4ae5__ExactTargetForAppExchangeUser__c == userenabled && record.et4ae5__ExactTargetForAppExchangeAdmin__c == adminenabled){
			action = "remove";
		}else{
			action = "add";
			record.et4ae5__ExactTargetForAppExchangeUser__c = userenabled;
			record.et4ae5__ExactTargetForAppExchangeAdmin__c = adminenabled;
		}
		var updateEvent = component.getEvent("UpdateRecord");
		updateEvent.setParams({
			"action": action,
			"record": record
        }).fire();
	}
})