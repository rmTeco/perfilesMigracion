({
    doInit : function(component, event, helper) {
        var record = component.get("v.record");
        if($A.util.isUndefined(record.et4ae5__ExactTargetForAppExchangeUser__c)) 
            component.find("usercheckbox").set("v.disabled", true);
        else
            component.set("v.userenabled", record.et4ae5__ExactTargetForAppExchangeUser__c);   
        
        if($A.util.isUndefined(record.et4ae5__ExactTargetForAppExchangeAdmin__c)) 
            component.find("admincheckbox").set("v.disabled", true);
        else
            component.set("v.adminenabled", record.et4ae5__ExactTargetForAppExchangeAdmin__c);
    },

	userEnabledChange : function(component, event, helper) {
		helper.sendUpdateRecordEvent(component, helper);
	},

	adminEnabledChange : function(component, event, helper) {
		helper.sendUpdateRecordEvent(component, helper);
	}
})