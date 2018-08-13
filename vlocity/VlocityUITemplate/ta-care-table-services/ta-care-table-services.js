vlocity.cardframework.registerModule.controller('tableCtrl',
    ['$rootScope', 
     '$scope', 
     '$filter', function($rootScope, $scope, $filter) {

    $scope.sortingOrder = '';
    $scope.reverse = false;

    var amc = this;
    amc.init = init;
    amc.profile = false;

    function init() {

        if ($rootScope.vlocity.userProfileName == 'Test community'){
            amc.profile = true;
        }
    }
    
    $scope.sortBy = function(newSortingOrder) {
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrder = newSortingOrder.name;
        
        if ($scope.sortingOrder !== '') {
            $scope.records = $filter('orderBy')($scope.records, $scope.sortingOrder, $scope.reverse);
        }
    };
}]);