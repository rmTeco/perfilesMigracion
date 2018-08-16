({
    "showpopover" : function(cmp, event, helper) {
        
        var index = event.target.getAttribute("value");
        var jsonRight = undefined;
        var jsonLeft = undefined;

        jsonRight = cmp.get("v.OSElements")[index].vlocity_cmt__PropertySet__c;
        jsonLeft = cmp.get("v.OSElements")[index].vlocity_cmt__TargetPropertySet__c;

        if (jsonRight != undefined) {
            jsonRight = JSON.parse(jsonRight);
        }
        if(jsonRight != undefined && jsonLeft != undefined) {
            jsonLeft = JSON.parse(jsonLeft);

            $A.createComponent("c:Modal", 
            {
                "aura:id" : "Modal",
                "JSONLeft" : jsonLeft,
                "JSONRight" : jsonRight,
                "ModalBehavior" : cmp.getReference("c.destroypopover")
            }, function (cmpModal, status, errorMsg){
                if (status === "SUCCESS") {
                    var body = cmp.get("v.body");
                    body.push(cmpModal);
                    cmp.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMsg);
                }
            });
        } else {
            alert("JSON Property empty!");
        }
    },
    "destroypopover" : function(cmp, event, helper){
        cmp.find("Modal").destroy();
    },
})