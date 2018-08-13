vlocity
    .cardframework
    .registerModule
    .controller('DataPackController', DataPackController);
    
    DataPackController.$inject = ['$scope'];
    
    function DataPackController($scope) {
        var dpc = this;
        
        
        // console.info('$scope: ', $scope.$parent.$parent.$parent.$parent.$parent.records.lineItems.records[$scope.data.cardIndex]);
        
        // console.info('$scope: ', $scope.$parent.$parent.$parent.$parent.$parent.$parent.records.lineItems.records[$scope.data.cardIndex]);
        
        // 
        
        
        $scope.$watch('$parent.$parent.$parent.$parent.$parent.$parent.records.lineItems', function (newVal, oldVal) {
            console.info('NewVal: ', newVal);
            console.info('OldVal: ', oldVal);
            
            dpc.productProcessed = newVal ? newVal.records.lineItems.records[$scope.data.cardIndex] : $scope.obj;
            
            
        });
    }