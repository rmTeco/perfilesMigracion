vlocity.cardframework.registerModule
    .controller('CardCanvasController',
                 ['$scope', '$timeout', '$location', '$rootScope', function($scope, $timeout, $location, $rootScope) {
  
        
             $scope.performAction =  function (action, params) {
              if (params) {
                  console.log('Card action', action);
          
              }
        };
}]);