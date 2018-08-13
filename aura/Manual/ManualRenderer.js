({
	rerender : function(component, helper){
		this.superRerender();
		if($A.util.getBooleanValue(component.get("v.skipWiz"))) {
        	helper.skipWizardDOMChanges(component);
        }
	}
})