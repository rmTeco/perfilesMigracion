/* Custom Template for input field
   Used in Vlocity Dynamic Form to override the default input template
*/

vlocity.cardframework.registerModule.controller('customActionsTpl2Controller', ['$scope', '$sldsModal', '$parse', function($scope, $sldsModal, $parse) {
    var customActionModal;

    // $scope.$parent.$parent.records contain the reference to field object passed from VDF
    $scope.field = $scope.$parent.$parent.records;
    $scope.formName = $scope.$parent.$parent.attrs.formName;
    $scope.formAutoSave = $scope.$parent.$parent.attrs.formAutoSave;

    $scope.autoGenerate = function() {
        var targetOrigin = window.location.origin;
        var messageType = 'ATTR_CONFIG_CUSTOM_ACTION';
        var attributeId = $scope.field.attributeId + '_' + $scope.formName;

        var modalScope = $scope.$new();
        modalScope.title = 'Lookup Phone Number';
        /* This is where you specify the third party page to load when the user clicks on a custom action link/button */
        modalScope.customActionIframeSrc = '/apex/CustomActionThirdPartyTest?targetOrigin=' + targetOrigin + '&messageType=' + messageType + '&attributeId=' + attributeId;

        customActionModal = $sldsModal({
            backdrop: 'static',
            scope: modalScope,
            templateUrl: 'CPQCartItemConfigCustomActionModal.tpl.html',
            show: true
        });
    };

    $scope.reset = function() {
        $scope.$parent.$parent.records.userValues = '';
    };

    $scope.$on('vlocity.cpq.config.custom.action', function(event, data) {
        var wrappedResult, formChangeFn;

        if (data.attributeId === ($scope.field.attributeId + '_' + $scope.formName)) {
            if ($scope.field.userValues !== data.attributeValue) {
                // update the value of the attribute
                $scope.$apply(function() {
                    $scope.field.userValues = data.attributeValue;
                });

                if ($scope.formAutoSave) {
                    // trigger attribute value auto-save
                    wrappedResult = angular.element(document.getElementsByName($scope.formName));
                    formChangeFn = $parse(wrappedResult.attr('form-on-change'));
                    formChangeFn($scope.$parent.$parent.$parent.$parent.$parent.$parent, {e:false});
                }
            }

            // close the custom action modal
            customActionModal.hide();
        }
    });
}]);