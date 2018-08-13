({
    onInit : function(component, event, helper) {
		component.find("oAuthConnectJSON").set("v.json",helper.getOAuthConnectJSON());
	}
})