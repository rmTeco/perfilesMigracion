vlocity
    .cardframework
    .registerModule
    .controller('ICCIDRevalidationController', ICCIDRevalidationController);
    
    ICCIDRevalidationController.$inject = ['$scope', '$rootScope'];
    
    function ICCIDRevalidationController($scope, $rootScope) {
       var iccidrc = this;
       
       $scope.$watch('loopform.$valid', function (newVal, oldVal) {
          
          $scope.bpTree.response.SerialsValidated = newVal;
       });
    }