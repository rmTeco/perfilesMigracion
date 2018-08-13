({
	getBaseURL : function(cmp) {
        var customVFPage = cmp.get('v.customVFPage');
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
                cmp.set("v.url", a.href + '?layout=' + encodeURIComponent(cmp.get('v.layout')) + '&id=' + encodeURIComponent(cmp.get('v.recordId')) + '&useCache=' + (!cmp.get('v.disableCache')) + iframeEmbed);
            }); 
            baseurl.setStorable(true);
            $A.enqueueAction(baseurl);  
        }
	}
})