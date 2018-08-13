vlocity.cardframework.registerModule.controller('taCareRadioButtonListCtrl', ['$scope', function($scope) {
    
    $scope.isArray = angular.isArray;
    
}]);

vlocity.cardframework.registerModule.filter("isArray", function() {
    return function(input) {
        return angular.isArray(input);
    };
});

vlocity.cardframework.registerModule.filter("format", function() {
    return function (input, items, option) {
		var args = items;
		return input.replace(/\{(\d+)\}/g, function (match, capture) {
			return option[args[parseInt(capture, 10)]];
		});
	};
});