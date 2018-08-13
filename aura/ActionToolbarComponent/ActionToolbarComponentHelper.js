({
    initHelper : function(cmp) {
        var action = cmp.get('c.getAllActions');
        var baseurl = cmp.get('c.getCommunityBaseURL');
        var namespace = cmp.get('c.getNameSpacePrefix');
        //var linkTypes = cmp.get("c.getLinkTypes");
        //Get Actions
        action.setParams({
            objType : cmp.get('v.objType'),
            sFilterContextId : cmp.get('v.recordId'),
            sDisplayOn : cmp.get('v.displayOn'),
            sLinkType : cmp.get('v.linkType')
        });
        action.setCallback(this, function(a) {
            var returnObjects = JSON.parse(a.getReturnValue());
            cmp.set('v.vlocActions', returnObjects);
            //Set Orientation:
            var orientation = cmp.get('v.style');
            if (orientation === 'vertical') {
                cmp.set('v.styleHtml', 'action-container action-vertical community');
            }else {
                cmp.set('v.styleHtml', 'action-container action-horizontal');
            }

        });
        //Get Base URL
        $A.enqueueAction(action);
        baseurl.setCallback(this, function(b) {
            var returnObjects = b.getReturnValue();
            cmp.set('v.baseURL', returnObjects);
        });
        $A.enqueueAction(baseurl);
        //Get nsPrefix
        namespace.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === 'SUCCESS') {
                var nsPrefix = response.getReturnValue();
                cmp.set('v.nsPrefix', nsPrefix);
            }

        });
        $A.enqueueAction(namespace);
        //Dynamically create link type picklist:
        //linkTypes.setCallback(this, function(response){
        //      var state = response.getState();
        //      var linkTypes = response.getReturnValue();
        //      if (cmp.isValid() && state === "SUCCESS") {
        //           cmp.set("v.linkTypes", linkTypes);
        //      }
        //  });
        //  $A.enqueueAction(linkTypes);
    }
})