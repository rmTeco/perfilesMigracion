vlocity
	.cardframework
	.registerModule
	.controller('MobileHistoryCtrl', MobileHistoryCtrl);

MobileHistoryCtrl.$inject = ['$scope'];

function MobileHistoryCtrl($scope) {
    var mhc = this;
    mhc.mobileFilter = mobileFilter;
    
    function mobileFilter(card) {
        if(card.title == $scope.params.cardTitle) {
            return true;
        }
        return false;
    }
}