({
    getBaseURL : function(cmp) {
        var baseurl = cmp.get('c.getCommunityBaseURL');
        var namespace = cmp.get('c.getNameSpacePrefix');
        var recordType = cmp.get('c.getObjectType');
        var url = window.location.host;
        if (url.includes('livepreview')) {
            cmp.set('v.isPreview', true);
        }
        //Check if record type is permisible
        recordType.setParams({
             id : cmp.get('v.recordId')});
        recordType.setCallback(this, function(response) {
            var result = response.getReturnValue();
            cmp.set('v.recordType', result);
            var applicableTypes = cmp.get('v.applicableTypes');
            if (applicableTypes.indexOf(result) < 0) {
                cmp.set('v.isValid', false);
            }
        });
        $A.enqueueAction(recordType);
        //If valid record type, get baseurl and nsPrefix for frame
        if (cmp.get('v.isValid')) {
            baseurl.setCallback(this, function(b) {
                var returnObjects = b.getReturnValue();
                var host, temp;
                if (cmp.get('v.isPreview')) {
                    temp = returnObjects.split('.com/');
                    host = temp[0] + '.com/';
                }else {
                    temp = returnObjects.split('/s/');
                    host = temp[0];
                }
                cmp.set('v.hostURL', host);
                cmp.set('v.baseURL', '&baseURL=' + returnObjects);
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
        }
    }
})