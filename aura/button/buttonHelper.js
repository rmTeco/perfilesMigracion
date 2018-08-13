({
	// Method called from the Renderer class when the Button
	// component renders or rerenders 
	displayButton : function(component) {
		if (component.get("v.disabled")) {
			var disabled = $A.util.getBooleanValue(component.get("v.disabled")); 
			var button = component.find("button");
			if (button) {
				var element = button.getElement();
				if (element) {
					if (disabled) {
						element.setAttribute('disabled', 'disabled');
					} else {
						element.removeAttribute('disabled');
					}
				}
			}
		}
	}
})