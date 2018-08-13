vlocity.cardframework.registerModule.controller('BillingAccountsToController', ['$scope', function($scope) {
          $scope.bpTree.response.InvalidToAccount = 'false';

            var bacTo = this;
            bacTo.checkValid = checkValid;

            function checkValid(ba) {

                if (ba.PurchaseFinancing || ba.DebtFinancing){
                    $scope.bpTree.response.InvalidToAccount = 'true';
                } else{
                    $scope.bpTree.response.InvalidToAccount = 'false';
                }
                 
            }  
            
      }]);