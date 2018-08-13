/*
 * 
 */ 
+function() {
    vlocity
        .cardframework
        .registerModule
        .controller('leftProductItemController', leftProductItemController);

    leftProductItemController.$inject = ['$scope', '$rootScope', '$filter'];
    function leftProductItemController($scope, $rootScope, $filter) {
        // Public Fields
        var lpic = this;
        lpic.showStock = true;
        
        // Public Methods
        lpic.init = init;
        
        // Method Definitions
        function init() {
            console.info('scope: ', $scope);
        }

    }
}();