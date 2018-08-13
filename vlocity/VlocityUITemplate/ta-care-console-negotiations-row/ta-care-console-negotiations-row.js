vlocity.cardframework.registerModule
    .controller('NegotiationsRow',
                ['$scope', '$timeout', '$interval', '$filter','$rootScope',
                    function($scope, $timeout, $interval, $filter, $rootScope){ 
                        
        $scope.open_negotiation = function(id, num) {
            
            //console.log('clicked' + id)
        
        function testOpenSubtab() {
            //First find the ID of the primary tab to put the new subtab in
            sforce.console.getEnclosingPrimaryTabId(openSubtab);
        }
        
        var openSubtab = function openSubtab(result) {
            //Now that we have the primary tab ID, we can open a new subtab in it
            var primaryTabId = result.id;
            sforce.console.openSubtab(primaryTabId , '/'+id, true, 
                'Gestión '+ num , null, openSuccess, null);
        };
        
        var openSuccess = function openSuccess(result) {
            //Report whether we succeeded in opening the subtab
            if (result.success == true) {
                console.log('subtab successfully opened');
            } else {
                console.log('subtab cannot be opened');
            }
        };
        
        testOpenSubtab();
        
    }