vlocity
	.cardframework
	.registerModule
	.controller('MyAssetDetailCtrl', MyAssetDetailCtrl);
	
function MyAssetDetailCtrl() {
    var mac = this;
    mac.init = init;
    mac.mobile = false;
    
    function init() {
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            mac.mobile = true;
        }
    }
}