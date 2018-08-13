vlocity
    .cardframework
    .registerModule
    .controller('OrderListItemController', OrderListItemController);

    OrderListItemController.$inject = ['$scope', '$rootScope'];
    function OrderListItemController($scope, $rootScope) {
        var olic = this;

        olic.openCustomTab = openCustomTab;
        function openCustomTab(item) {
            
            if (item.Name == 'taCheckoutSetup' || item.Name == 'taHandoverSetup' ) {
                var newUrl = item.%vlocity_namespace%__URL__c.replace(/\{0\}/g, $scope.obj.orderId);
                sforce.console.openPrimaryTab(null, newUrl, true, item.%vlocity_namespace%__DisplayLabel__c);    
            } else {
                /* PFTA-10745 */
                if (item.Name == 'ta-Sales-reTakeSale' && sforce.console.isInConsole()) {
                    var newUrl1 = item.%vlocity_namespace%__URL__c + '?accountId=' + $scope.obj.Account.Id + '&contactId=' + $scope.obj.Account.%vlocity_namespace%__PrimaryContactId__c + '&operationCode=' + $scope.obj.Operation_Code__c + '&orderId=' + $scope.obj.Id ;
                    sforce.console.openPrimaryTab(null, newUrl1, true, item.%vlocity_namespace%__DisplayLabel__c);
                } /* PFTA-10745 END*/ else {
                    $scope.performAction(item);
                }
            }
        }
    }