({
    setupIframeResizer: function(cmp, event, helper) {
        var url = cmp.get("v.url");
        if (url !== undefined && typeof iFrameResize !== 'undefined') {
            helper.setIframe(cmp);
        }
    },

    handleDestroy: function(cmp, event, helper) {
        var iframeresizer = cmp.get('v.iFrameResizer');
        if (iframeresizer) {
            try {
                iframeresizer.close();
            } catch(ex) {
                // exception on console needs to be handled 
            }
        }
    },

    frameLoaded : function(cmp, event, helper) {
        var url = cmp.get("v.url");
        if(url !== undefined) {
            cmp.set("v.hideSpinner",true);
            event.target.width = "100%";
            event.target.height = "";
        }

        var frame = cmp.find('iframe');
        if (!frame) {
            return;
        }

        if (frame.getElement().iFrameResizer == null && typeof url !== 'undefined') {
            try {
                helper.setIframe(cmp);
            } catch(ex) {
                // exception on community builder needs to be handled 
            }
        }
    },

    locationChange : function(cmp, event, helper) {
        var message = window.location;
        helper.sendIframeMessage(cmp, {
            type: "locationchangeevent",
            message: message
        });
    }
})