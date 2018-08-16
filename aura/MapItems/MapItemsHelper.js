({
    "getElements" : function(cmp, evt, Id, cmpToRender) {
        cmp.set("v." + cmpToRender, null);
        cmp.set("v.showMsg", true);
        this.showHideSpinner(cmp, evt, true);
        var action = cmp.get("c.OSElement");
        action.setParams({ omniscriptId : Id });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if ($A.util.isEmpty(response.getReturnValue()) == false) {
                    cmp.set("v.showMsg", false);
                    var elements = response.getReturnValue();
                    cmp.set("v." + cmpToRender, elements);
                } else {
                    cmp.set("v.showMsg", true);
                    console.log("Empty Elements List");
                }
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            this.showHideSpinner(cmp, evt, false);
        });
        $A.enqueueAction(action);
    },
    "showHideSpinner" : function(cmp, evt, active) {
        var spinner = cmp.find("spinner");
        if (active)
            $A.util.removeClass(spinner, "slds-hide");
        else
            $A.util.addClass(spinner, "slds-hide");
    },
})