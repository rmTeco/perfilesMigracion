({
	doInit : function(cmp, event, helper) {
        var layout = cmp.get('v.layout');
        if(layout !== '') {
		    helper.getBaseURL(cmp);
        }
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