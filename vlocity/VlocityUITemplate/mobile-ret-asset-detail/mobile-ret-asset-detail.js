vlocity.cardframework.registerModule
    .controller('CpqAssetDetailController',
                 ['$scope', '$timeout', '$rootScope', 'MobileService', function($scope, $timeout, $rootScope, MobileService) {
        this.getImageFullUrl = function(objId, imgPath) {
            return MobileService.getImageFullUrl(objId, imgPath);
        };
}]);