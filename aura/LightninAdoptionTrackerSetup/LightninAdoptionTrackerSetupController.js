({
    doInit: function(cmp, evt, helper) {
        //Used Init due to this thread:
        //http://salesforce.stackexchange.com/questions/151409/error-when-calling-apex-controller-methods-from-lightning-component-helper-can/151410?noredirect=1#comment221553_151410
        helper.isActivated(cmp);
//        console.log("isActivated is done");
    },//doInit
    
    toggleAppActivation: function(cmp, evt, helper){
        if(cmp.get("v.isAppActive") === true){
            helper.activateApp(cmp, evt);
        }else{
//   	        console.log("going into helper for deactivateApp");
            helper.deactivateApp(cmp, evt);
//   	        console.log("done with helper for deactivateApp");
        }
    },
    onRunNow: function(cmp, evt, helper){
    	var action = cmp.get("c.updateCheckboxNow");
        action.setCallback(this, function(response) {
			var state = response.getState();
    		if (state === "SUCCESS") {
                //This only evaluates to true if in one.app, not in VF lightning out. 
                var toastEvent = $A.get("e.force:showToast");
                if(toastEvent){  
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": response.getReturnValue(),
                        "type": "success",
                        "duration": 1500
                    });
                    toastEvent.fire();
                }//if
			}//if
		});
		$A.enqueueAction(action);
	}
})