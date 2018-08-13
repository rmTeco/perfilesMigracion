vlocity.cardframework.registerModule.controller('ServicesCtrl', ['$scope', function($scope) {
        
        $scope.groupServices = function(){
            $scope.internet = false;
            $scope.movil = false;
            $scope.fijo = false;
            $scope.otro = false;
            
            angular.forEach($scope.obj.Assets, function(value, key){
                console.log('value: ' + value);
                console.log('key: ' + value);
                if(value.Family == 'Internet')
                    $scope.internet = true;
                else if(value.Family == 'Movil')
                    $scope.movil = true;
                else if(value.Family == 'Fixed')
                    $scope.fijo = true;
                else
                    $scope.otro = true;
            });
            
        }
        
      }]);