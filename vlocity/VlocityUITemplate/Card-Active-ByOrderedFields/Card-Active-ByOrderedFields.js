vlocity.cardframework.registerModule.controller('ServicesCtrl', ['$scope', function($scope) {
        
        $scope.groupServices = function(){

//Campo agregado para solucionar PFTA-7334

            if ($scope.obj.Statement !== undefined && $scope.obj.Statement.DueDate !== undefined){
                $scope.obj.Statement.DueDate2 = moment($scope.obj.Statement.DueDate).format('D/M/YY');
            }

            $scope.internet = false;
            $scope.movil = false;
            $scope.fijo = false;
            $scope.otro = false;
            angular.forEach($scope.obj.Assets, function(value, key){
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