vlocity
	.cardframework
	.registerModule
	.controller('Web360CardCtrl', Web360CardCtrl);

function Web360CardCtrl() {
    var wcc = this;
    wcc.init = init;
    wcc.mobile = false;
    
    function init() {
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            wcc.mobile = true;
        }
    }
}