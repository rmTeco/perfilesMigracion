vlocity.cardframework.registerModule
    .controller('viaAcuitySidebarOfferCard',
                ['$scope', '$timeout', function($scope, $timeout) {

        var lightningNsPrefix = $scope.nsPrefix.replace('__', ':'),
            collectedChanges = [];

        this.getImageUrl = function(obj) {
            if (!obj) {
                return null;
            }
            var imageId = null;
            Object.keys(obj.attachment).forEach(function(key) {
                if (!imageId) {
                    imageId = obj.attachment[key];
                }
                if (/@sidebar/.test(key)) {
                    imageId = obj.attachment[key];
                    return false;
                }
            });
            return '/servlet/servlet.FileDownload?file=' +imageId;
        };

        this.getTags = function(obj) {
            if (!obj || !angular.isArray(obj.componentScores)) {
                return [];
            }
            return obj.componentScores.reduce(function(array, componentScore) {
                if (componentScore && angular.isArray(componentScore.scoreParameters)) {
                    return array.concat(componentScore.scoreParameters);
                }
                return array;
            }, []);
        };

        $scope.$on('$destroy', removeHandlers);

        function removeHandlers() {
            $A.eventService.removeHandler({
                "event": lightningNsPrefix + "profileAttributeValueUpdatedEvent",
                "handler": profileAttributeValueUpdatedEventHandler,
                "globalId": $scope.layoutName + "-profileAttributeValueUpdatedEvent"
            });
            $A.eventService.removeHandler({
                "event": lightningNsPrefix + "profileAttributeCategoryUpdatedEvent",
                "handler": profileAttributeCategoryUpdatedEventHandler,
                "globalId": $scope.layoutName + "-profileAttributeCategoryUpdatedEvent"
            });
            $A.eventService.removeHandler({
                "event": lightningNsPrefix + "profileNavigationEvent",
                "handler": profileNavigationEventHandler,
                "globalId": $scope.layoutName + "-profileNavigationEvent"
            });
        }

        function profileNavigationEventHandler(event) {
            var navigateFrom = event.getParam('navigateFrom'),
                navigateTo = event.getParam('navigateTo');
            if (navigateFrom === 'slide-to-profiler-edit' && collectedChanges.length > 0) {
                $scope.bypassTemplateRefresh = true;
                $scope.$emit($scope.data.layoutName+'.events', {
                    event: 'reload',
                    message: []
                });
            } else {
                collectedChanges = [];
            }
        }

        function profileAttributeCategoryUpdatedEventHandler(event) {
            collectedChanges.push(event);
        }

        function profileAttributeValueUpdatedEventHandler(event) {
            $scope.bypassTemplateRefresh = true;
            $scope.$emit($scope.data.layoutName+'.events', {
                event: 'reload',
                message: []
            });
        }

        function registerLightningEventHandler() {
            if (typeof $A === 'undefined') {
                setTimeout(registerLightningEventHandler, 1000);
                return;
            }
            // only register one set
            removeHandlers();
            $A.eventService.addHandler({
                "event": lightningNsPrefix + "profileAttributeValueUpdatedEvent",
                "handler": profileAttributeValueUpdatedEventHandler,
                "globalId": $scope.layoutName + "-profileAttributeValueUpdatedEvent"
            });

            $A.eventService.addHandler({
                "event": lightningNsPrefix + "profileAttributeCategoryUpdatedEvent",
                "handler": profileAttributeCategoryUpdatedEventHandler,
                "globalId": $scope.layoutName + "-profileAttributeCategoryUpdatedEvent"
            });
            
            $A.eventService.addHandler({
                "event": lightningNsPrefix + "profileNavigationEvent",
                "handler": profileNavigationEventHandler,
                "globalId": $scope.layoutName + "-profileNavigationEvent"
            });
        }

        registerLightningEventHandler();

    }]);