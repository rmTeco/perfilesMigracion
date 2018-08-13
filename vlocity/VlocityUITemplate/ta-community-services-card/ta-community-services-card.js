vlocity
	.cardframework
	.registerModule
    .controller('MyModuleCtrl', MyModuleCtrl);

MyModuleCtrl.$inject = ['$scope'];

function MyModuleCtrl($scope) {
    var mmc = this;
    mmc.init = init;
    mmc.mobile = false;
    
    function init() {
        /*
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            mmc.mobile = true;
        }
        */
    }
    
    $scope.fieldsfilter = function (field) {
        if(field.label == 'ProductName' || field.label == 'LineNumber') {
            return true;
        }
        return false;
    }
}