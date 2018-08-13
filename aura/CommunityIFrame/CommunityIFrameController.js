({
    setupIframeResizer: function(cmp, event, helper) {
        //console.log('setupIframeResizer...');
        console.dir(event);
        var actionHandler = $A.getCallback(function(data) {
            helper.handleIFrameMessage(cmp, data.message, cmp.get('v.openInActionsIn'));
        });
        var config = {
            log: false,
            checkOrigin: false,
            scrolling: false,
            heightCalculationMethod: 'lowestElement',
            messageCallback : actionHandler
        };
        if (cmp.get('v.maxHeight')) {
            config.maxHeight = Number('' + cmp.get('v.maxHeight').replace('px', ''));
        }
        iFrameResize(config, cmp.find('iframe').getElement());
        cmp.set('v.iFrameResizer', cmp.find('iframe').getElement().iFrameResizer);


        helper.workspaceAPI = cmp.find("workspace");
        helper.workspaceAPI.isConsoleNavigation().then(function(response) {
            helper.isConsoleNavigation = response;
        });
             
    },

    handleDestroy: function(cmp, event, helper) {
        //console.log('handleDestroy...');
        var iframeresizer = cmp.get('v.iFrameResizer');
        //console.dir(iframeresizer);
        iframeresizer.close();
    },

    frameLoaded : function(cmp, event, helper) {
        //console.log('frameLoaded...');
        var url = cmp.get("v.url");
        //console.dir(url);
        if(url !== undefined) {
            cmp.set("v.hideSpinner",true);
        }
    },
})