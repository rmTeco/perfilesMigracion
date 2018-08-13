vlocity.cardframework.registerModule.controller('StockController', ['$scope', function($scope) {
    var sc = this;
    
    sc.processData = processData;
    
    function processData(data) {
        sc.depositos = angular.isArray(data) ? data : [data];
    }
    
}]);