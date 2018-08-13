vlocity.cardframework.registerModule
    .controller('decomposeValidateController',
                 ["$scope","$rootScope","$window","$location", function( $scope,$rootScope,$window,$location){
            $scope.errMeg="";
            var x = document.getElementsByClassName("panel-group");
            x[0].style.display = 'none';
            this.showValidateErrorMeg = function(erMessage,OrderId) {
            alert(erMessage);  
            //var url = "https://" + $window.location.host + "/apex/HybridCPQ?id="+OrderId;
            $window.open('','_self').close();
        };
        
}]);