vlocity.cardframework.registerModule
    .controller('careFacturaTraficoController',
                ['$scope', '$timeout', '$interval', '$filter','$rootScope',
                    function($scope, $timeout, $interval, $filter, $rootScope){ 
                        
    $scope.init = function(){
        
        if($scope.obj.fechaAplicacionPago !== ""){
            var fecha = $scope.obj.fechaAplicacionPago;
            $scope.obj.fechaAplicacionPago = new Date(fecha); 
        }
        if($scope.params.AccountIntegrationId == "params.AccountIntegrationId"){
            $scope.params.AccountIntegrationId = ""; 
        }
        if($scope.params.direccionFactura == "params.direccionFactura"){
            $scope.params.direccionFactura = ""; 
        }
        
        
        if($scope.obj.codMedioPago === 'TAR'){
            $scope.codEntidad = $scope.obj.infoBanco.codEntidadTC;
        }else if($scope.obj.infoBanco !== undefined){
            $scope.codEntidad = $scope.obj.infoBanco.codEntidadFinanciera;
            $scope.codTar = null;
        }
        
        
       
    }
    

}]);