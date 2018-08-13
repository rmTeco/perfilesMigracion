vlocity.cardframework.registerModule.controller('largeCardController', ['$scope', '$filter', function ($scope, $filter) {
    $scope.isString = function (value) {
        return value.type === "string";
    };
    $scope.getIconSet = function (object) {
        if ($scope.isJsonString(object)) {
            object = JSON.parse(object);
            $scope.sprite = object.sprite;
            $scope.icon = object.icon;
        }
    };

    $scope.isJsonString = function (str) {
        try {
            JSON.parse(str);
        } catch (e) {
            return false;
        }
        return true;
    };
}]);