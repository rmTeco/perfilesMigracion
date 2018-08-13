vlocity
    .cardframework
    .registerModule
    .controller('ProductItemMoreController', ProductItemMoreController);
    
    ProductItemMoreController.$inject = ['$scope', '$rootScope'];
    
    function ProductItemMoreController($scope, $rootScope) {
        var pimc = this;
        
        pimc.init = init;
        
        function init() {
            console.info($scope.records);
            $scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c = JSON.parse($scope.records[0].Product2.%vlocity_namespace%__JSONAttribute__c);
            
        }
        
    }