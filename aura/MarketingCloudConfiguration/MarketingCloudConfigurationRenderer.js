({
	rerender : function(component, helper){
        this.superRerender();
        if($A.util.getBooleanValue(component.get("v.runWizard"))) {
        	helper.runWizzard(component);
        }
    	else if($A.util.getBooleanValue(component.get("v.skipWizard"))) {
    		helper.skipWizzard(component);
    	}
    	else if($A.util.getBooleanValue(component.get("v.showSetup"))) {
            helper.showSetup(component);
		}
    }
})