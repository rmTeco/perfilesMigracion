({
    doInit: function (component, event, helper) {
        var sPageURL = window.location.href; //You get the whole decoded URL of the page.
        var aElement = document.createElement('a');
        aElement.href = sPageURL;
        var communityName = aElement.pathname.replace(/(^\/?)/,"/").split('/')[1];
        if (communityName) {
            component.set('v.communityName', '/' + communityName);
        }
    }
})