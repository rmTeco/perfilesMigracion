({
    getBaseURL : function(cmp) {
        console.log('getBaseURL');
        var customVFPage = cmp.get('v.customVFPage');
        var search = '';
        console.log('search1: ' + window.location.search);
        if (typeof window.location.search != 'undefined' && window.location.search != '') {
            search = decodeURIComponent(window.location.search);
            console.log('search2: ' + search);
        }
        if (customVFPage) {
            var getBaseUrl = cmp.get('c.getBaseUrl');
            getBaseUrl.setCallback(this, function(result) {
                var a = document.createElement('a');
                a.href = result.getReturnValue() + '/apex/' + cmp.get('v.customVFPage');
                var iframeEmbed = '&isdtp=p1&sfdcIFrameOrigin=' + window.location.protocol + '//' + window.location.host + '&sfdcIFrameHost=web';
                cmp.set('v.url',  a.href + '?layout=' + encodeURIComponent(cmp.get('v.layout')) + '&id=' + encodeURIComponent(cmp.get('v.recordId')) + '&useCache=' + (!cmp.get('v.disableCache')) + iframeEmbed);
            });
            getBaseUrl.setStorable(true);
            $A.enqueueAction(getBaseUrl);
        } else {
            var baseurl = cmp.get("c.getCardUrl");
            baseurl.setCallback(this, function(b) {
                var returnObjects = b.getReturnValue();
                var a = document.createElement('a');
                a.href = returnObjects;
                var iframeEmbed = '&isdtp=p1&sfdcIFrameOrigin=' + window.location.protocol + '//' + window.location.host + '&sfdcIFrameHost=web';
                cmp.set("v.url", a.href + '?layout=' + encodeURIComponent(cmp.get('v.layout')) + '&id=' + encodeURIComponent(cmp.get('v.recordId')) + '&useCache=' + (!cmp.get('v.disableCache')) + decodeURIComponent(this.getUrlParam(search)) + iframeEmbed);
            }); 
            baseurl.setStorable(true);
            $A.enqueueAction(baseurl);  
        }
    },
    getUrlParam: function(url) {
        console.log("getUrlParam: " + url);
        if (url) {
            var urlParams = url.substr(((url.substr(1, url.length).indexOf("?") + 2)), url.length);
            console.log('urlParams1: ' + urlParams.substr(0, urlParams.length-1));
            return '&' + urlParams;
        }
        return '';
    }
})