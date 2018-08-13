({
	doInit : function(cmp, event, helper) {
		helper.getUrlForPage(cmp);
	},
    
    handleCardEvent: function(cmp, event, helper) {
        var layoutName = event.getParam("layoutName");
        var message = event.getParam("message");
        
        helper.sendIframeMessage(cmp, {
            type: "cardevent",
            layoutName: layoutName,
            message: message
        });
    }
})