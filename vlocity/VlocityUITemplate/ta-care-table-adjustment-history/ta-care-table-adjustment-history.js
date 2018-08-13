vlocity.cardframework.registerModule.controller('tableCtrl',
    ['$rootScope', 
     '$scope', 
     '$filter', function($rootScope, $scope, $filter) {

    $scope.sortingOrder = '';
    $scope.reverse = false;
    
     $scope.sortBy = function(newSortingOrder) {
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrder = newSortingOrder.name;
        
        if ($scope.sortingOrder !== '') {
            $scope.records = $filter('orderBy')($scope.records, $scope.sortingOrder, $scope.reverse);
        }
    };
}]);