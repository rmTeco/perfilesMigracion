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

        $scope.openStory = function(obj) {
            var toBeLaunchedUrl = '/' + obj.Id;
            if (typeof sforce !== 'undefined') {
                if (sforce.console.isInConsole()) {
                    openSubtab = function openSubtab(result) {
                        sforce.console.openSubtab(result.id, toBeLaunchedUrl, false, obj.title, null, openSuccess, obj.title);
                    };
                    openSuccess = function openSuccess(result) {
                        sforce.console.focusSubtabById(result.id);
                    };
                    sforce.console.getEnclosingPrimaryTabId(openSubtab);
                } else {
                    if(typeof sforce.one === 'object') {
                        sforce.one.navigateToURL(toBeLaunchedUrl, false);
                    } else {
                        location.assign(toBeLaunchedUrl);
                    }

                }
            }else {
                location.assign(toBeLaunchedUrl);
            }
        };

    }]);