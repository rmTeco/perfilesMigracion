({
	isActivated: function(cmp) {
        //This function sets the component attribute to TRUE if the app is activated
        //Activated is defined as the scheduled apex method exists with the expected schedule time.
//        console.log("Helper method entered");
        var action = cmp.get("c.isSchedulerActivated");//THIS IS CAUSING A **** ERROR
//        console.log("Helper method get successful");
        action.setCallback(this, function(response) {
			var state = response.getState();
//			console.log("result of isSchedulerActivated is:  "+ response.getReturnValue());
            if (state === "SUCCESS") {
		        cmp.set("v.isAppActive", response.getReturnValue());
//                console.log("Scheduler value returned from apex controller method: "+ response.getReturnValue());
			}//if
		});
		$A.enqueueAction(action);
	},//isActivated
  
    activateApp: function(cmp,evt) {
//		console.log("Entering activateApp");

        var action = cmp.get("c.startScheduler");
        action.setCallback(this, function(response) {
			var state = response.getState();
//			console.log("result of startScheduler is:  "+ response.getReturnValue());
            if (state === "SUCCESS") {
                cmp.set("v.isAppActive", true);
                //This only evaluates to true if in one.app, not in VF lightning out. 
    			var toastEvent = $A.get("e.force:showToast");
                if(toastEvent){  
                    toastEvent.setParams({
                        "message": response.getReturnValue(),
                        "type": "success",
                        "duration": 1500
                    });
                    toastEvent.fire();
                }//if
			}//if
		});
		$A.enqueueAction(action);
    },//activateApp

    deactivateApp: function(cmp,evt) {
    	var action = cmp.get("c.stopScheduler");
        action.setCallback(this, function(response) {
			var state = response.getState();
    		if (state === "SUCCESS") {
                cmp.set("v.isAppActive", false);
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
    }//deactivateApp
    
})