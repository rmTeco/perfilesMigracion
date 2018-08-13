({
	setJSON : function() {
        return {
		    "title"        : $A.get("et4ae5.mcAPIUsr"),
			"button_label" : $A.get("$Label.et4ae5.connect"),
			"advanced_settings_flag" : true,
			"is_api_user" : false,
			"show_advanced_settings_label" : $A.get("$Label.et4ae5.show") + ' ' + $A.get("$Label.et4ae5.advancedSettings"),
			"hide_advanced_settings_label" : $A.get("$Label.et4ae5.hide") + ' ' + $A.get("$Label.et4ae5.advancedSettings"),
			"environment_label"       : $A.get("$Label.et4ae5.envirnmnt"),
			"environments" : $A.get("$Label.et4ae5.environments"),
            "qaenvironments" : $A.get("$Label.et4ae5.qaenvironments"),
			"retrieve_oauth_url" : "c.getOAuthURL",
            "qa_mode" : "c.qamode",            
			"error" : "e.et4ae5:ThrowErrorMessage"
        };
    },
	// Called from renderer class
    showAdvanced : function(component) {
        var advanced_div = component.find("advanced_div");
        //This check will help resolve "undefined" errors- seen in Winter 17
        if(advanced_div)
        {
        	$A.util.removeClass(advanced_div.getElement(), 'hide');
			var settings = component.get("v.json");
			component.find("advanced_link").set("v.label", settings.hide_advanced_settings_label);
        }
    },
	// Called from renderer class
    hideAdvanced : function(component) {
		var advanced_div = component.find("advanced_div");
        //This check will help resolve "undefined" errors- seen in Winter 17
        if(advanced_div)
        {
			$A.util.addClass(advanced_div.getElement(), 'hide');
			var settings = component.get("v.json");
			component.find("advanced_link").set("v.label", settings.show_advanced_settings_label);
        }
    }    
})