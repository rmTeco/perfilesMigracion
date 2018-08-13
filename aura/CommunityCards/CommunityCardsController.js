({
    doInit : function(cmp, event, helper) {
        try {
            helper.getBaseURL(cmp);
        } catch(err) {
            console.log(err.message);
        }
    },
    
    handleCardEvent: function(cmp, event, helper) {
        console.log('doInit' + cmp.get("v.accountId"));
        console.log('handleCardEvent');
        try {
            var layoutName = event.getParam("layoutName");
            var message = event.getParam("message");
            
            helper.sendIframeMessage(cmp, {
                type: "cardevent",
                layoutName: layoutName,
                message: message
            });
        } catch(err) {
            console.log(err.message);
        }
    },
})