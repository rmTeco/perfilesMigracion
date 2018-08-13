({
	doInit : function(cmp, event, helper) {
        helper.initHelper(cmp);
    },
    //Vlocity Action Handler
    handleAction : function(cmp, event) {
        var item = event.getParam('item');
        var baseURL = cmp.get('v.baseURL');
        var isLEX;
        if (baseURL.includes('one.app')) {
            isLEX = true;
        }else {
            isLEX = false;
        }
        var customCommunityPage = cmp.get('v.customCommunityPage');
        var path = baseURL + item.url;
        if (item.url.includes('/apex/')) {
            if (!isLEX) {
                path = baseURL + customCommunityPage + '?actionUrl=' + item.url;
            }else {
                path = item.url;
            }
        }
        // if (item.methodName !== null) HANDLE INVOKE METHOD
        window.location.href = path;
    }
})