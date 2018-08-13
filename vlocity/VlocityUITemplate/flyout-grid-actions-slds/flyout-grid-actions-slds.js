vlocity.cardframework.registerModule
    .controller('viaFlyoutGridActions',
                ['$scope', function($scope, $filter) {

        this.parentHasActions = function() {
            return !/-noActions-/.test($scope.templateUrl);
        };

        this.getActions = function() {
            var limitTo = 0;
            if (this.parentHasActions()) {
                limitTo = $scope.$parent.limitActionLinksTo || 5;
            }
            return $scope.data.actions.slice(limitTo);
        }

    }]);