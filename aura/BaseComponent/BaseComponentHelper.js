({
    bc_throwEventMessage : function(component, errorMessage, errorTitle, severity) {
        var cmpMessageEvent = component.getEvent("BCMessage");
        if(severity === "info") {
            cmpMessageEvent.setParams({
                "messageTitle" : errorTitle,
                "toastMessage" : errorMessage
            });            
        }
        else if (severity === "confirm")
        {
            cmpMessageEvent.setParams({
                "messageTitle" : errorTitle,
                "successMessage" : errorMessage
            });
        }
        else
            cmpMessageEvent.setParams({
            "messageTitle" : errorTitle,
            "errorMessage" : errorMessage
        });
        cmpMessageEvent.fire();        
    }
})