({
    "doInit" : function(cmp) {
        var action = cmp.get("c.OSList");
        var isProcedure = cmp.get("v.isProcedure");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if ($A.util.isEmpty(response.getReturnValue()) == false) {
                    var omniscriptList = response.getReturnValue()
                    cmp.set("v.OSNames", omniscriptList);
                    const nameOSSet = new Set(), nameIPSet = new Set();
                    for(var n in omniscriptList) {
                        (omniscriptList[n].vlocity_cmt__IsProcedure__c) ?
                            nameIPSet.add(omniscriptList[n].Name) : nameOSSet.add(omniscriptList[n].Name);
                    }
                    let arrOS = Array.from(nameOSSet);
                    let arrIP = Array.from(nameIPSet);
                    cmp.set("v.OSNamesUnique", arrOS);
                    cmp.set("v.OSIPUnique", arrIP);
                } else {
                    console.log("Empty OS List");
                }
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
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
        cmp.set("v.OSElementsOrigin", null);
        
        cmp.set("v.showMsg", true);
        var isProcedure = cmp.get("v.isProcedure");
        var name = 'none';
        
        if (isProcedure) {
            name = cmp.find("IPName").get("v.value")
            cmp.set("v.IPSelectedName", name);
        } else {
            name = cmp.find("OSName").get("v.value")
            cmp.set("v.OSSelectedName", name);
        }
        
        if (name != "none" && name != undefined) {
            var names = cmp.get("v.OSNames");
            var versions = names.filter(function(names) {return names.Name == name});
            (isProcedure) ? cmp.set("v.IPVersions", versions) : cmp.set("v.OSVersions", versions);
        }
    },
    "selectedOrigin" : function(cmp, evt, helper) {
        var isProcedure = cmp.get("v.isProcedure");
        var IPVersion = cmp.find("originIP").get("v.value");
        var OSVersion = cmp.find("originOS").get("v.value");
        var idVersion =  "none";

        if (isProcedure) { idVersion = IPVersion; } else { idVersion = OSVersion; }
        if (idVersion != "none" && name != undefined) {
            var names = cmp.get("v.OSNames");
            var versions = names.filter(function(names) {return names.Id == idVersion});
            cmp.set("v.Origin", versions);
            var target;
            target = (isProcedure) ? "IPElement" : "OSElement";
            helper.getElements(cmp, evt, versions[0].Id, target);
        }
    },
    "showHideTab" : function(cmp, evt, helper) {
        cmp.set("v.OriginVersions", null);
        cmp.set("v.OSElementsOrigin", null);
        $A.util.removeClass(cmp.find("OS"), 'slds-is-active');
        $A.util.addClass(cmp.find("OS_Section"), 'slds-hide');

        $A.util.removeClass(cmp.find("IP"), 'slds-is-active');
        $A.util.addClass(cmp.find("IP_Section"), 'slds-hide');

        $A.util.removeClass(cmp.find("DR"), 'slds-is-active');
        $A.util.addClass(cmp.find("DR_Section"), 'slds-hide');

        $A.util.removeClass(cmp.find("Card"), 'slds-is-active');
        $A.util.addClass(cmp.find("Card_Section"), 'slds-hide');
        
        $A.util.removeClass(cmp.find("OSComparator"), 'slds-is-active');
        $A.util.addClass(cmp.find("OSComparator_Section"), 'slds-hide');

        var element = document.getElementById(evt.target.getAttribute("id")).parentElement;
        var cmpTarget = cmp.find(element.id);
        var cmpSectionTarget = cmp.find(element.id + '_Section');
        if (element.id == 'OS') {
            cmp.set("v.isProcedure", false);
            cmp.set("v.msg", "Here will be shown Omniscript Elements once you have chosen OS Name and Version");
        } else {
            cmp.set("v.isProcedure", true);
            cmp.set("v.msg", "Here will be shown Integration Prcedure Elements once you have chosen IP Name and Version");
        }
        
        $A.util.addClass(cmpTarget, 'slds-is-active');
        $A.util.removeClass(cmpSectionTarget, 'slds-hide');

    },
    "clear" : function(cmp, evt, helper) {
        cmp.find("IPName").set("v.value", "none");
        cmp.find("OSName").set("v.value", "none");
        cmp.find("originIP").set("v.value", "none");
        cmp.find("originOS").set("v.value", "none");
        cmp.set("v.IPElement", null);
        cmp.set("v.OSElement", null);
        var isProcedure = cmp.get("v.isProcedure");
        cmp.set("v.showMsg", true);
        if (isProcedure) {
            cmp.set("v.msg", "Here will be shown Integration Prcedure Elements once you have chosen IP Name and Version");
        } else {
            cmp.set("v.msg", "Here will be shown Omniscript Elements once you have chosen OS Name and Version");
        }
    }
})