vlocity
	.cardframework
	.registerModule
	.controller('CustomerHistoryCtrl', CustomerHistoryCtrl);

function CustomerHistoryCtrl() {
    var mhc = this;
    mhc.init = init;
    mhc.mobileFilter = mobileFilter;
    mhc.mobile = false;
    
    function init() {
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            mhc.mobile = true;
        }
    }
    
    function mobileFilter(card) {
        if(card.title == "MobileHistory") {
            return true;
        }
        return false;
    }
}