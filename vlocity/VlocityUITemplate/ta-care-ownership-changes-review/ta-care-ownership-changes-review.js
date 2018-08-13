vlocity.cardframework.registerModule.controller('ownershipChangesReviewController', ['$scope', function($scope) {
  var oc = this;
  oc.init = init;
  oc.orders = [];
  oc.totalRESTCalls = 0;

  function init() {
      oc.forcetkClient = new forcetk.Client();
      oc.forcetkClient.setSessionToken(window.sessionId);

      oc.orders = $scope.bpTree.response.Orders;
      oc.originAccount = $scope.bpTree.response.ContextId;
      oc.destinationAccount = $scope.bpTree.response.DestinationAccountId;
      oc.selectedAssets = $scope.bpTree.response.AssetSelection.SelectAsset;

      for (var i = 0; i < oc.orders.length; i++) {
          var order = oc.orders[i];
          var asset = oc.selectedAssets.find(function(asset) {
            return asset.Id == order.AssetId;
          });

          addLineItemToOrder(order, asset, i);
      }
  }

  function addLineItemToOrder(order, asset, i) {
      var restPath = '/OwnershipChanges';
      var restMethod = 'PUT';
      var payload = {
          "ContextId": oc.originAccount,
          "OrderId": order.OrderId,
          "AccountId": oc.destinationAccount,
          "Asset": asset
      };
      
      console.log('llamada', i);
      console.log('payload', payload);

      oc.forcetkClient.apexrest(
          restPath,
          function(result) {
              console.info('result', result);
              console.info('orderItemId', result.orderItemId);
              console.info('orderId', result.orderId);
              console.info('msg', result.msg);
              
              var msg = result.msg;
              var orderIdCallBack = result.orderId;
              var orderItemId = result.orderItemId;

              var orderInstance = $scope.bpTree.response.Orders.find(function(order) {
                  return order.OrderId == orderIdCallBack;
              });

              /*orderInstance.OrderItems.push({
                  "OrderItemId": orderItemId
              });*/

              oc.totalRESTCalls++;

              $scope.bpTree.response.TotalRESTCalls = oc.totalRESTCalls;

              $scope.$apply();
          },
          function(error) {
              console.info('error', error);
              oc.totalRESTCalls++;

              $scope.bpTree.response.TotalRESTCalls = oc.totalRESTCalls;
          },
          restMethod,
          angular.toJson(payload)
      );
  }
}]);