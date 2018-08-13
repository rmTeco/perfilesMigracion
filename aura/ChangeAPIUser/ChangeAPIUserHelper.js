({
    getOAuthConnectJSON : function () {
        return {
            "title" : $A.get("$Label.et4ae5.mcAPIUsr"),
            "button_label" : $A.get("$Label.et4ae5.connect"),
            "advanced_settings_flag" : true,
            "is_api_user" : true,
            "show_advanced_settings_label" : $A.get("$Label.et4ae5.show") + ' ' + $A.get("$Label.et4ae5.advancedSettings"),
            "hide_advanced_settings_label" : $A.get("$Label.et4ae5.hide") + ' ' + $A.get("$Label.et4ae5.advancedSettings"),
            "environment_label" : $A.get("$Label.et4ae5.envirnmnt"),
            "environments" : $A.get("$Label.et4ae5.environments"),
            "retrieve_oauth_url" : "c.getOAuthURL",
            "error" : "e.et4ae5:ThrowErrorMessage"
        };
    },

    getUserCredsJSON : function (destination) {
        return {
            "title"        : $A.get("$Label.et4ae5.chngMCAPIUsr"),
            "first_label"  : $A.get("$Label.et4ae5.username"),
            "first_placeholder"     : $A.get("$Label.et4ae5.mcAPIUsrAbbr"),
            "second_label" : $A.get("$Label.et4ae5.password"),
            "second_placeholder"    : "**********",
            "button_label" : $A.get("$Label.et4ae5.updtAPIUsr"),
            "authenticate" : "c.authenticate",
            "firstParamName" : "user",
            "secParamName" : "secret",
            "top"          : "/apex/" + destination,
            "error"        : "e.et4ae5:ThrowErrorMessage",
            "advanced_settings_flag" : true,
            "third_label"  : $A.get("$Label.et4ae5.editApiUrl"),
            "thirdParamName" : "link",
            "third_placeholder"       : $A.get("$Label.et4ae5.apiUrl"),
            "third_value"  : "https://webservice.exacttarget.com/Authentication/Auth.svc",
            "instruction_label" : $A.get("$Label.et4ae5.msg0248"),
            "advancedSettings" : $A.get("$Label.et4ae5.advancedSettings")
        };
    },
})