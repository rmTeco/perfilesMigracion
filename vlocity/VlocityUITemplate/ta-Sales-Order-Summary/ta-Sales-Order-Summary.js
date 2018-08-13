vlocity.cardframework.registerModule.controller('taSalesOrderSummaryController', ['$scope',function($scope) {
    var tsom = this;
    console.info("LOAD taSalesOrderSummaryController");
    
    tsom.init = init;
    
    function init(){
        
        console.info("INIT ");
        console.info($scope.bpTree);
        console.info($scope.records);
        
    };
    
}]);