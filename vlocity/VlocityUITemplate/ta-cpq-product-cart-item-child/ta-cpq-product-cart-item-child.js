/*
 * 
 */ 
+function() {
    vlocity
        .cardframework
        .registerModule
        .controller('cpqCartItemChildProducts', cpqCartItemChildProducts);

    cpqCartItemChildProducts.$inject = ['$scope', '$rootScope', '$filter'];
    function cpqCartItemChildProducts($scope, $rootScope, $filter) {
        // Public Fields
        var ccicp = this;

        // Public Methods
        ccicp.init = init;

        // Method Definitions
        function init() {
            //console.info('scope: ', $scope);
            console.info('Operation Code: ', $scope.params.operationCode);
            console.info('ImportedScope: ', $scope.importedScope.viewModelRecords);
        }
        

    }
}();