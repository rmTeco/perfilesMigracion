vlocity
    .cardframework
    .registerModule
    .controller('CheckoutOrderItemGridController', CheckoutOrderItemGridController);
    
    CheckoutOrderItemGridController.$inject = ['$scope', '$rootScope'];
    
    function CheckoutOrderItemGridController($scope, $rootScope) {
       var coigCtrl = this;
       
       $scope.$watch('loopform.$valid', function (newVal, oldVal) {
          
          $scope.bpTree.response.ItemsChecked = newVal;
       });
    }