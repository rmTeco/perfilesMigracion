({
	sliderValueChanged : function(component, event) {
        component.set("v.attributeValue", event.target.id);
        var changeEvent = component.getEvent("change");
        changeEvent.setParams({
            "attributeName" : component.get("v.attributeName"),
            "appliedAttributeCode" : component.get("v.appliedAttributeCode"),
            "changedValue" : event.target.id});
        changeEvent.fire();
	},

    cancelOnclick : function(component, event) {
        event.preventDefault();
        event.stopPropagation();
    }

})