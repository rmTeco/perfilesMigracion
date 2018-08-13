/* Custom Template for input field
   Used in Vlocity Dynamic Form to override the default input template
*/

vlocity.cardframework.registerModule.controller('customActionsController', ['$scope',  '$parse', function($scope, $parse) {
    // $scope.$parent.$parent.records contain the reference to field object passed from VDF
    $scope.field = $scope.$parent.$parent.records;
    $scope.formName = $scope.$parent.$parent.attrs.formName;
    $scope.formAutoSave = $scope.$parent.$parent.attrs.formAutoSave;
    
    $scope.autoGenerate = function() {
        //Integrate the external service here if needed
        var digits = Math.floor(Math.random() * 9000000000) + 1000000000;
        $scope.field.userValues = digits;
        if ($scope.formAutoSave) {
            // trigger attribute value auto-save
            wrappedResult = angular.element(document.getElementsByName($scope.formName));
            formChangeFn = $parse(wrappedResult.attr('form-on-change'));
            formChangeFn($scope.$parent.$parent.$parent.$parent.$parent.$parent, {e:false});
        }
    };
    
    $scope.reset = function() {
        $scope.field.userValues = '';
        if ($scope.formAutoSave) {
            // trigger attribute value auto-save
            wrappedResult = angular.element(document.getElementsByName($scope.formName));
            formChangeFn = $parse(wrappedResult.attr('form-on-change'));
            formChangeFn($scope.$parent.$parent.$parent.$parent.$parent.$parent, {e:false});
        }
    };
}]);