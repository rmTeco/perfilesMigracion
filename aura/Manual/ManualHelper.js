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

    getUserCredentialJSON : function () {
        return {
            "title"        : $A.get("$Label.et4ae5.mcUsr"),
            "first_label"  : $A.get("$Label.et4ae5.username"),
            "first_placeholder"     : $A.get("$Label.et4ae5.mcAPIUsrAbbr"),
            "second_label" : $A.get("$Label.et4ae5.password"),
            "second_placeholder"    : "**********",
            "button_label" : $A.get("$Label.et4ae5.connect"),
            "authenticate" : "c.authenticate",
            "firstParamName" : "user",
            "secParamName" : "secret",
            "top"          : "https://et4ae5.na1.visual.force.com/apex/MarketingCloudSettings",
            "error"        : "e.et4ae5:ThrowErrorMessage",
            "advanced_settings_flag" : true,
            "third_label"  : $A.get("$Label.et4ae5.editApiUrl"),
            "thirdParamName" : "link",
            "third_placeholder"       : $A.get("$Label.et4ae5.apiUrl"),
            "third_value"  : "https://webservice.exacttarget.com/Authentication/Auth.svc",
            "advancedSettings" : $A.get("$Label.et4ae5.advancedSettings")
        };
    },

    getJson_help_left_automatic : function () {
        return {
            "title" : "",
            "description" : "",
            "entries" : [
                {
                    "url" : "https://help.exacttarget.com/v5_connecting_the_clouds",
                    "title" : $A.get("$Label.et4ae5.configChkLst"),
                    "description" : $A.get("$Label.et4ae5.msg0202")
                },
                {
                    "url" : "https://help.exacttarget.com/v5_first_time_configuration_crm_admin/#page_layouts",
                    "title" : $A.get("$Label.et4ae5.updtPgLyut"),
                    "description" : $A.get("$Label.et4ae5.msg0203")
                }
            ]
        };
    },

    getJson_help_left_manual : function () {
        return {
            "title" : "",
            "description" : "",
            "entries" : [
                {
                    "url" : "https://help.exacttarget.com/v5_connecting_the_clouds",
                    "title" : $A.get("$Label.et4ae5.configChkLst"),
                    "description" : $A.get("$Label.et4ae5.msg0202")
                }
            ]
        };
    },

    getJson_help_right_automatic : function () {
        return {
            "title" : "",
            "description" : "",
            "entries" : [
                {
                    "url" : "https://help.exacttarget.com/v5_first_time_configuration_mc_admin/#creating_mcc_users",
                    "title" : $A.get("$Label.et4ae5.crtMCSysUsr"),
                    "description" : $A.get("$Label.et4ae5.msg0204")
                },
                {
                    "url" : "https://help.exacttarget.com/v5_first_time_configuration_mc_admin/#creating_mc_api_user",
                    "title" : $A.get("$Label.et4ae5.crtMCAPIUsr"),
                    "description" : $A.get("$Label.et4ae5.msg0205")
                }
            ]
        };
    },

    skipWizardDOMChanges : function(component) {
        $A.util.addClass(component.find("rightLinks").getElement(), 'hide');
        $A.util.addClass(component.find("leftALinks").getElement(), 'hide');
        $A.util.removeClass(component.find("leftMLinks").getElement(), 'hide');
    }
})