({
    onInit : function(component, event, helper) {
        //Call server and check for outstanding sends
        var action = component.get("c.initialize");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var initializeResponse = JSON.parse(response.getReturnValue());
                if(initializeResponse.errorCode === "UNAUTHORIZED"){
                    window.location.href = "/apex/etSwitchboard";
                }else{
                    //Set user credentials variables
                    component.find("oAuthConnectJSON").set("v.json", helper.getOAuthConnectJSON());
                }
            }else{
                helper.bc_throwEventMessage(component, $A.get("$Label.et4ae5.srySmtgWrng"), $A.get("$Label.et4ae5.msg0241"), "error");
            }
        });
        $A.enqueueAction(action);
    },

    handleErrorMessage : function(component, event, helper) {
        helper.bc_throwEventMessage(component, event.getParam("message"), event.getParam("title"), "error");
    },
})