({

	handleStateChangedEvent : function(component, event) {
		var changedValue = event.getParam("newState");
        var changeEvent = component.getEvent("change");
        changeEvent.setParams({
            "attributeName" : component.get("v.attributeName"),
            "appliedAttributeCode" : component.get("v.appliedAttributeCode"),
            "changedValue" : changedValue});
        changeEvent.fire();
	}

})