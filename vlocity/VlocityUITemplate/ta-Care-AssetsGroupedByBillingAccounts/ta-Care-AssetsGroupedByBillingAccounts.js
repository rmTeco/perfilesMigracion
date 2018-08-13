vlocity.cardframework.registerModule.controller('AssetGroupCtrl', ['$scope', function($scope) {
        
        $scope.saveSelectedAsset = function(asset){
            $scope.bpTree.response.SelectedAssetId = asset.Id;
            $scope.bpTree.response.SelectedAssetStatus = asset.Status;
        }
        
      }]);