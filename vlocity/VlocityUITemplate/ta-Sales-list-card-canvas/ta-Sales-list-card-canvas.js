vlocity
    .cardframework
    .registerModule
    .controller('NotificationController', NotificationController);
    
    NotificationController.$inject = ['$scope', '$rootScope']
    function NotificationController($scope, $rootScope) {
        var nc = this;
		
		nc.reloadControlPanel = reloadControlPanel;
		
		function reloadControlPanel() {
		    $scope.$parent.reloadLayout2();
		    $rootScope.notificationQty = 0;
		}
    }