vlocity
	.cardframework
	.registerModule
	.controller('Web360ActionsCtrl', Web360ActionsCtrl);

function Web360ActionsCtrl() {
    var wac = this;
    wac.init = init;
    wac.mobile = false;
    
    function init() {
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            wac.mobile = true;
        }
    }
}