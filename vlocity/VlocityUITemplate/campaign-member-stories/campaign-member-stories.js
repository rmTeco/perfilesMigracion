vlocity.cardframework.registerModule
    .controller('viaStoryCardCanvasController',
                ['$scope', '$timeout', '$interval', '$filter', '$rootScope',
                    function($scope, $timeout, $interval, $filter, $rootScope) {
        var self = this;
        this.isOpen = false;
        this.search = null;
        this.filters = {
            'All': null
        };
        this.searchComplete = false;
        var shouldDefer = false;
        this.filteredCards = [];

        this.isSelected = function(card) {
            if (!card) {
                return !this.search;
            }
            return this.search && this.search.title == card.title;
        };

        this.changeFilter = function(card) {
            this.search = card;
            this.title = !card ? 'Customer Story' : card.title;
            this.isOpen = false;
            $scope.filteredCards = $filter('orderBy')($filter('filter')($scope.cards, self.filterStories), '-obj.LastActivityDate');
        };

        this.filterStories = function(value, index, array) {
            if (!self.search) {
                return true;
            }
            return !!(value.obj && checkFilter(value.obj, self.search.filter));
        };

        function checkFilter(sObject, filterObject) {
            var success = true;
            if (sObject) {
                if (Object.keys(sObject).length == 0) {
                    success = false;
                    return success;
                }
                for (var field in filterObject) {
                    if (typeof sObject[field] === 'object') {
                        success = checkFilter(sObject[field], filterObject[field]);
                    } else {
                        var objField = _.get(sObject, field);
                        success = filterObject[field] == objField; //TODO: add other logical operators
                    }
                    if (!success) {
                        return success;
                    }
                }
            } else {
                success = false;
                return success;
            }
            return success;
        };

        $scope.$watch(function() {
            return $scope.records ? $scope.records.length : 0;
        }, function() {
            if ($scope.records) {
                self.searchComplete = false;
                loadingSpinner.show();
                $scope.cards.forEach(function(card) {
                    self.filters[card.title] = card;
                });
                if (!hasUpdatedDataSource) {
                    shouldDefer = true;
                }
            }
        });

        $scope.$watch(function() {
            return $scope.cards ? $scope.cards.length : 0;
        }, function(newLength) {
            $scope.filteredCards = $filter('orderBy')($filter('filter')($scope.cards, self.filterStories), '-obj.LastActivityDate');
        });

        $scope.$on('reloadLayout', function(event, layoutName) {
            if (layoutName && layoutName === $scope.layoutName) {
                hasUpdatedDataSource = false;
            }
        });

        $rootScope.$on('vlocity.layout.campaign-member-stories.events', function() {
            loadingSpinner.show();
        });

        var loadingSpinner = $('.loading-row[data-name="' + $scope.layoutName +'"]');
        var intervalHolder = $interval(function() {
            if (!$scope.records) {
                return;
            }
            if (loadingSpinner.length == 0) {
                loadingSpinner = $('.loading-row[data-name="' + $scope.layoutName +'"]');
            }
            if (loadingSpinner.length > 0 && loadingSpinner.get(0).style.display != 'none') {
                var boundingClientRect = loadingSpinner[0].getBoundingClientRect();
                var elemTop = boundingClientRect.top;

                var isVisible = (elemTop >= 0) && (elemTop <= window.innerHeight);
                if (isVisible) {
                    getRemainingItems($scope.records[$scope.records.length - 1]);
                }
            }
        }, 500);
        $scope.layoutName[$scope.layoutName] = intervalHolder;

        $scope.$on("$destroy", function() {
            $interval.cancel(intervalHolder);
        });

        this.changeFilter(null);

        var hasUpdatedDataSource = false,
            currentRequestLastObj = null;
        function getRemainingItems(lastObj) {
            if (lastObj) {
                if (currentRequestLastObj == lastObj.Id) {
                    loadingSpinner.hide();
                    return;
                }
                var originalEndpoint = $scope.data.dataSource.value.endpoint;
                if (/lastObjId=[^&]+/.test($scope.data.dataSource.value.endpoint)) {
                    $scope.data.dataSource.value.endpoint = $scope.data.dataSource.value.endpoint.replace(/lastObjId=[^&]+/, 'lastObjId={{lastObjId}}');
                } else {
                    $scope.data.dataSource.value.endpoint = $scope.data.dataSource.value.endpoint +
                                                                (/\?/.test($scope.data.dataSource.value.endpoint) ? '&' : '?') +
                                                                        'lastObjId={{lastObjId}}&lastActivityDate={{lastActivityDate}}';
                }
                $scope.updateDatasource(
                    {
                        lastObjId: lastObj.Id,
                        lastActivityDate: lastObj.longLastActivityDate
                    },
                    true,
                    false,
                    true
                ).then(function(records) {
                    if (!records[records.length -1] || records[records.length -1].Id === currentRequestLastObj) {
                        // hide spinner since we didn't load anything new
                        loadingSpinner.hide();
                        self.searchComplete = true;
                    }
                });
                $scope.data.dataSource.value.endpoint = originalEndpoint;
                currentRequestLastObj = lastObj.Id;
                hasUpdatedDataSource = true;
            } else {
                loadingSpinner.hide();
                self.searchComplete = true;
            }
        };

    }]);