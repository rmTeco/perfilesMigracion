({
	render : function(component, helper) {
        var ret = this.superRender();        
		var settings = component.get("v.json");
		if(component.find("advanced_link")){
			component.find("advanced_link").set("v.label", settings.show_advanced_settings_label);
		}
        return ret;
	},

    rerender : function(component, helper){
        this.superRerender();
        
		var showAdvanced = $A.util.getBooleanValue(component.get("v.showAdvanced"));
        if(showAdvanced){
			helper.showAdvanced(component);
        }else{
			helper.hideAdvanced(component);
		}                	        		                        
    }
})