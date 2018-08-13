vlocity.cardframework.registerModule.controller('cardAssetPrepaidController',
['$rootScope', '$scope',  'interactionTracking',  '$filter', function($rootScope, $scope, interactionTracking, $filter, $window) {

    var obj = $scope.obj;
    $scope.suspNum = 0;
    
    init();

    function init() {
        
        console.info(obj);
        
       if(obj.Transaction_History !== undefined){
           if(obj.Transaction_History.length !== undefined){
               $scope.suspNum = obj.Transaction_History.length;
           }else{
               $scope.suspNum = obj.Transaction_History.Id !== undefined ? 1 : 0;
           }
        
             
        }

    }

}]);