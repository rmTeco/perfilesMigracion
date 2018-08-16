({
    "doInit" : function(cmp) {
        var action = cmp.get("c.OSList");
        //action.setParams({ firstName : cmp.get("v.firstName") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if ($A.util.isEmpty(response.getReturnValue()) == false) {
                    var omniscriptList = response.getReturnValue()
                    cmp.set("v.OSNames", omniscriptList);
                    
                    const nameSet = new Set();
                    for(var n in omniscriptList) {
                        nameSet.add(omniscriptList[n].Name);
                    }
                    let arr = Array.from(nameSet);
                    cmp.set("v.OSNamesUnique", arr);
                } else {
                    console.log("Empty OS List");
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
    "selectedName" : function(cmp, evt, helper) {
        cmp.set("v.OriginVersions", null);
        cmp.set("v.TargetVersions", null);
        cmp.set("v.OSElementsOrigin", null);
        cmp.set("v.OSElementsTarget", null);
        var name = cmp.find("Name").get("v.value");
        if (name != "none") {
            var names = cmp.get("v.OSNames");
            var versions = names.filter(function(names) {return names.Name == name});

            cmp.set("v.OriginVersions", versions);
            cmp.set("v.TargetVersions", versions);
        }
    },
    "compare" : function(cmp, evt, helper) {
        var spinner = cmp.find("spinner");
        $A.util.removeClass(spinner, 'slds-hide');
        var IdElement = cmp.find("origin").get("v.value");
        if (name != "none") {
            var names = cmp.get("v.OSNames");
            var versions = names.filter(function(names) {return names.Id == IdElement});
            cmp.set("v.Origin", versions);
            helper.getElements(cmp, evt, versions[0].Id, "OSElementsOrigin");
        }
        var IdElement = cmp.find("selectTargetOS").get("v.value");
        if (name != "none") {
            var names = cmp.get("v.OSNames");
            var versions = names.filter(function(names) {return names.Id == IdElement});
            cmp.set("v.Target", versions);
            helper.getElements(cmp, evt, versions[0].Id, "OSElementsTarget");
        }
        $A.util.addClass(spinner, 'slds-hide');
    },
})