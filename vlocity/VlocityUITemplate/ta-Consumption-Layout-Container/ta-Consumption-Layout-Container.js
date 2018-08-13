vlocity
    .cardframework
    .registerModule
    .controller('consumptionDetailsContainerController', consumptionDetailsContainerController);
    
    consumptionDetailsContainerController.$inject = ['$scope', '$timeout', '$interval', '$filter'];
    
    function consumptionDetailsContainerController ($scope, $timeout, $interval, $filter) {
        
        $scope.hideSideBar = function(category) {
            if (sforce.console !== undefined && sforce.console.isInConsole()) {
                sforce.console.setSidebarVisible(false, null, sforce.console.Region.RIGHT);
            }
        }
        
        $scope.showSideBar = function(category) {
            if (sforce.console !== undefined && sforce.console.isInConsole()) {
                sforce.console.setSidebarVisible(true, null, sforce.console.Region.RIGHT);
            }
        }
    }