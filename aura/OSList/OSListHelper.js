({
    "getElements" : function(cmp, evt, Id, cmpToRender) {
        var action = cmp.get("c.OSElement");
        action.setParams({ omniscriptId : Id });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if ($A.util.isEmpty(response.getReturnValue()) == false) {
                    var elements = response.getReturnValue();
                    cmp.set("v." + cmpToRender, elements);
                    if (cmpToRender == "OSElementsTarget")
                        this.compareArrays(cmp, evt);
                } else {
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
        });
        $A.enqueueAction(action);
    },
    "compareArrays" : function(cmp, evt) {
        var origin = cmp.get("v.OSElementsOrigin");
        var target = cmp.get("v.OSElementsTarget");
        
        for (var i = 0 ; i < origin.length ; i++) {
            origin[i].doNotExist = "border:solid 2px #99ff33;";
            for (var j = 0 ; j < target.length ; j++) {
                if (origin[i].Name == target[j].Name) {
                    origin[i].doNotExist = "";
                    if (origin[i].vlocity_cmt__PropertySet__c != target[j].vlocity_cmt__PropertySet__c) {
                        origin[i].vlocity_cmt__TargetPropertySet__c = target[j].vlocity_cmt__PropertySet__c;
                        origin[i].showButton = true;
                        origin[i].different = "border:solid 2px #ffff00;";
                        target[j].different = "border:solid 2px #ffff00;";
                        break;
                    } else {
                        origin[i].showButton = false;
                    } //#99ff33 green #ff0000 red
                }
            }
        }
        
        for (var i = 0 ; i < target.length ; i++) {
            target[i].deleted = "border:solid 2px #ff0000;";
            for (var j = 0 ; j < origin.length ; j++) {
                if (target[i].Name == origin[j].Name) {
                    target[i].deleted = "";
                }
            }
        }
        
        cmp.set("v.OSElementsOrigin", origin);
    },
})