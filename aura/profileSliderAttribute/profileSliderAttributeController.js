({

	sliderValueChanged : function(component, event) {
        var changeEvent = component.getEvent("change");
        changeEvent.setParams({
            "attributeName" : component.get("v.attributeName"),
            "appliedAttributeCode" : component.get("v.appliedAttributeCode"),
            "changedValue" : event.target.value});
        changeEvent.fire();
	},

    cancelOnclick : function(component, event) {
        event.preventDefault();
        event.stopPropagation();
    },

    // this is a workaround for html5 range input inside a Lightning container does not move
    sliderClicked : function(component, event) {
        if (event.screenX <= 50) {
            event.target.value = 1;
        } else if (event.screenX > 50 && event.screenX <= 120) {
            event.target.value = 2;
        } else if (event.screenX > 120 && event.screenX <= 200) {
            event.target.value = 3;
        } else if (event.screenX > 200 && event.screenX <= 270) {
            event.target.value = 4;
        } else {
            event.target.value = 5;
        }
        var changeEvent = component.getEvent("change");
        changeEvent.setParams({
            "attributeName" : component.get("v.attributeName"),
            "appliedAttributeCode" : component.get("v.appliedAttributeCode"),
            "changedValue" : event.target.value});
        changeEvent.fire();
    }

})