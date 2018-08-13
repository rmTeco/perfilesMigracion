({
	skip : function(component, event, helper) {
		var skipWizzardEvent = $A.get("e.et4ae5:SkipWizzard");
        skipWizzardEvent.fire();
	},

    start : function(component, event, helper) {

        var action = component.get("c.isRemoteSiteSettingCreated");
        action.setCallback(this, function(response) {
            var data = JSON.parse(response.getReturnValue());
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                if(!data.isAPIAvailable) {
                    var errorEvent = $A.get("e.et4ae5:ThrowErrorMessage");
                    errorEvent.setParams({"title" : $A.get("$Label.et4ae5.rssMissing"), "message" : data.message});
                    errorEvent.fire();
                }
                else {
                    var startWizzardEvent = $A.get("e.et4ae5:StartWizzard");
                    startWizzardEvent.fire();
                }
            }
            else {
                location.reload();
            }
        });
        $A.enqueueAction(action);

	}
})