vlocity.cardframework.registerModule.controller('AssetGroupCtrl', ['$scope', function($scope) {
        //var selectedAssets =  $scope.selectedAssets;
        $scope.init = function(){
            $scope.bpTree.response.selectedAssets = [];
        }
        
        $scope.saveSelectedAsset = function(asset){
            if (asset.isSelected) {
               $scope.bpTree.response.selectedAssets.push(asset);
            }
            else {
                $scope.bpTree.response.selectedAssets.pop(asset);
            }
        }
        
      }]);