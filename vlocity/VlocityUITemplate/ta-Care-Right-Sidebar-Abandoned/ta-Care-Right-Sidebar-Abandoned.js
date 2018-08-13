+function() {
    vlocity
        .cardframework
        .registerModule
        .controller('AbandonedSessionsController', AbandonedSessionsController);
        
    AbandonedSessionsController.$inject = ['$scope', '$rootScope'];
    function AbandonedSessionsController($scope, $rootScope) {
        // Public Fields
        var asc = this;
        
        // Public Methods
        asc.init = init;
        asc.parseDate = parseDate;
    
        // Method Definitions
        function init() {
           
        }
        
        function parseDate(date) {
            return new Date(date);
        }
    }
}();