vlocity.cardframework.registerModule.controller('addLineItemsToOrdersController', ['$scope', function($scope) {
    var tc = this;
    tc.init = init;
    tc.orders = [];

    function init() {
        tc.forcetkClient = new forcetk.Client();
        tc.forcetkClient.setSessionToken(window.sessionId);

        tc.orders = $scope.bpTree.response.Orders;

        for (var i = 0; i < tc.orders.length; i++) {
            var order = tc.orders[i];

            addLineItemToOrder(order, i);
        }
    }

    function addLineItemToOrder(order, i) {
        var restPath = '/%vlocity_namespace%/v2/cpq/carts/' + order.OrderId + '/items';
        var restMethod = 'POST';
        var payload = {
            "methodName": "postCartsItems",
            "cartId": order.OrderId,
            "items": [
                {
                    "itemId": order.OrderItems[0].PriceBookEntryId
                }
            ]
        };
        
        //alert(JSON.stringify(payload));
        console.log('payload', payload);
        console.log('llamadacost', i);

        tc.forcetkClient.apexrest(
            restPath,
            function(result) {
                console.info('result', result);
                console.info('OrderId', result.records[0].actions.addtocart.rest.params.cartId);
                console.info('UnitPrice', result.records[0].UnitPrice.value);
                console.info('OneTimeCharge', result.records[0].%vlocity_namespace%__OneTimeCharge__c.value);
                console.info('OrderItemId', result.records[0].Id.value);

                var orderIdCallBack = result.records[0].actions.addtocart.rest.params.cartId;
                var unitPrice = result.records[0].UnitPrice.value;
                var oneTimeCharge = result.records[0].%vlocity_namespace%__OneTimeCharge__c.value;
                var orderItemId = result.records[0].Id.value;

                console.log('orders', $scope.bpTree.response.Orders);

                var orderInstance = $scope.bpTree.response.Orders.find(function(order) {
                    return order.OrderId == orderIdCallBack;
                });

                console.info('orderInstance', orderInstance.OrderId);

                orderInstance.OrderItems[0].OrderItemId = orderItemId;
                orderInstance.UnitPrice = unitPrice;
                orderInstance.OneTimeCharge = oneTimeCharge;

                $scope.$apply();
            },
            function(error) {
                console.info('error', error);
            },
            restMethod,
            angular.toJson(payload)
        );
    }
}]);