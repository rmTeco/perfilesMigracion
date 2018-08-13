vlocity.cardframework.registerModule
    .controller('profileTagsController',
                ['$scope', '$timeout', '$interval', '$filter',
                    function($scope, $timeout, $interval, $filter) {
        var self = this;
        this.isOpen = false;
        this.filterOption = 'Todos';
       
        this.changeFilter = function(category) {
            this.categoryModel = category == 'Todos' ? '' : category;
            this.filterOption = category;
            this.isOpen = false;
        }
    }]);