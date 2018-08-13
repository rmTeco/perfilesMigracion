vlocity.cardframework.registerModule.controller('CartRootProdController', ['$scope', '$rootScope', function($scope, $rootScope) {
         $scope.number = Number;
         $scope.increment = function(scp) {
          alert('check',scp);
         
         }
         $scope.decrement = function(scp) {
          alert('check',scp);
         
         }
         
         $scope.removeItem = function(param, obj, mark){
             
            if(angular.isNumber(obj.%vlocity_namespace%__RecurringPrice__c))
                $rootScope.limiteDeCredito = parseFloat($rootScope.limiteDeCredito)+parseFloat(obj.%vlocity_namespace%__RecurringPrice__c);
                
            $scope.importedScope.delete(param, obj, mark);
         }
         
         
        
      }]);