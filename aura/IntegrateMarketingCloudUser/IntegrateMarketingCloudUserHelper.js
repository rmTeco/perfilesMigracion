({
    getOAuthConnectJSON : function () {
        return {
		    "title"        : $A.get("$Label.et4ae5.mcUsr"),
			"button_label" : $A.get("$Label.et4ae5.connect"),
			"advanced_settings_flag" : false,
			"is_api_user" : false,
			"show_advanced_settings_label" : $A.get("$Label.et4ae5.show") + ' ' + $A.get("$Label.et4ae5.advancedSettings"),
			"hide_advanced_settings_label" : $A.get("$Label.et4ae5.hide") + ' ' + $A.get("$Label.et4ae5.advancedSettings"),
			"environment_label"       : $A.get("$Label.et4ae5.envirnmnt"),
			"environments" : $A.get("$Label.et4ae5.environments"),
			"retrieve_oauth_url" : "c.getOAuthURL",
			"error" : "e.et4ae5:ThrowErrorMessage"
        };
    }
})