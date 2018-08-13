({
	toggleOff : function(component) {
        component.set("v.state", "-1");
        $A.util.addClass(component.getElement(), 'toggle-off');
        $A.util.removeClass(component.getElement(), 'toggle-neutral');
        $A.util.removeClass(component.getElement(), 'toggle-on');

        var changeEvent = component.getEvent("change");
        changeEvent.setParams({
            "newState" : component.get("v.state")});
        changeEvent.fire();
	},

	toggleNeutral : function(component) {
        component.set("v.state", "0");
        $A.util.removeClass(component.getElement(), 'toggle-off');
        $A.util.addClass(component.getElement(), 'toggle-neutral');
        $A.util.removeClass(component.getElement(), 'toggle-on');

        var changeEvent = component.getEvent("change");
        changeEvent.setParams({
            "newState" : component.get("v.state")});
        changeEvent.fire();
	},

	toggleOn : function(component) {
        component.set("v.state", "1");
        $A.util.removeClass(component.getElement(), 'toggle-off');
        $A.util.removeClass(component.getElement(), 'toggle-neutral');
        $A.util.addClass(component.getElement(), 'toggle-on');

        var changeEvent = component.getEvent("change");
        changeEvent.setParams({
            "newState" : component.get("v.state")});
        changeEvent.fire();
	},

    cancelOnclick : function(component, event) {
        event.preventDefault();
        event.stopPropagation();
    }

})