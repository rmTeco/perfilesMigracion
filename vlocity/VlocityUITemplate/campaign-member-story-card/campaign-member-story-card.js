vlocity.cardframework.registerModule
    .controller('viaTaskController',
                ['$scope','force', function($scope, force) {

        $scope.updateTask = function(id, value, obj) {
            obj.loading = true;
            force.update('task', {Id: id, Status: value})
                .then(
                function(response) {
                    delete obj.loading;
                },
                function(error) {
                    alert('Task could not be updated due to server error');
                    delete obj.loading;
                }
            );
        };

    }]);