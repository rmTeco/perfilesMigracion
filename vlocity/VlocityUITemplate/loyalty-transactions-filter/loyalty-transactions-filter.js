vlocity.cardframework.registerModule.controller('MyCtrl',
    ['$scope', 
     '$filter', function($scope, $filter) {
    
    $scope.currentPage = 0;
    $scope.pageSize = 10;
    $scope.q = '';
    
    $scope.numberOfPages=function(){
        
        return Math.ceil($scope.data.obj.transactions.length/$scope.pageSize);                
    };

    $scope.getData = function () {
        
      return $filter('filter')($scope.data.obj.transactions);
    };
    
    $scope.size = Math.ceil($scope.getData().length/$scope.pageSize);
        
    $scope.currentRange = []; 
    
    for (var i = 0; i < $scope.size; i++) {
        $scope.currentRange.push(i);
    }
    
    $scope.numberOfPages=function(){
        return $scope.size;
    };
   
    $scope.goToPage = function(pageNumber){
        $scope.currentPage = pageNumber;
        $scope.previousPage = pageNumber - 1;
        $scope.nextPage = pageNumber + 1;
        $scope.range();
    };
        
}]);

vlocity.cardframework.registerModule.filter('startFrom', function() {
    return function(input, start) {
        start = +start; //parse to int
        return input.slice(start);
    };
});

vlocity.cardframework.registerModule.filter('filterFrom', function() {
    return function(input, from) {
        if(from === undefined || from === null){
                from = '1900-01-01';
        }
        return input.filter(function(input){
            
            var d = new Date(from);
            var month = d.getMonth();
            var day = d.getDate();
            month = month + 1;
            if(month < 10){month = '0' + month;}
            if(day < 10){day = '0' + day;}
            var date = d.getFullYear() + '-' + month + '-' + day;
            //console.log('fecha:'+input.transactionDate+'desde:'+date);
            return input.transactionDate >= date;
        });
    };
});
vlocity.cardframework.registerModule.filter('filterTo', function() {
    return function(input, to) {
        if(to === undefined || to === null){
                to = '2999-12-31';
        }
        return input.filter(function(input){
            
            var d = new Date(to);
            var month = d.getMonth();
            var day = d.getDate();
            month = month + 1;
            if(month < 10){month = '0' + month;}
            if(day < 10){day = '0' + day;}
            var date = d.getFullYear() + '-' + month + '-' + day;
            //console.log('fecha:'+input.transactionDate+'hasta:'+date);
            return input.transactionDate <= date;
        });
    };
});