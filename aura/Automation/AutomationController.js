({    
    doInit: function(component, event, helper) {
		component.set("v.sidebysideJSON", helper.getSidebySideJSON());
        component.set("v.json_step", helper.getMessagingModalJSON());  
        component.set("v.okLabel", $A.get("$Label.et4ae5.okay") + "!");
	},

    finishSetup : function (component, event, helper) {
		component.set("v.showModal", true); 
        helper.setAutomations(component, helper); 
    },

    clickOK : function(cmp, evt) {
        location.reload();
    }    
})