vlocity.cardframework.registerModule
    .controller('viaOfferCardActive',
                ['$scope', '$timeout', function($scope, $timeout) {
        this.getImageUrl = function(obj) {
            if (!obj) {
                return null;
            }
            var imageId = null;
            Object.keys(obj.attachment).forEach(function(key) {
                if (!imageId) {
                    imageId = obj.attachment[key];
                }
                if (/@card/.test(key)) {
                    imageId = obj.attachment[key];
                    return false;
                }
            });
            return '/servlet/servlet.FileDownload?file=' +imageId;
        };

        function registerLightningEventHandler() {
            if (typeof $A === 'undefined') {
                setTimeout(registerLightningEventHandler, 1000);
                return;
            }
            var lightningNsPrefix = $scope.nsPrefix.replace('__', ':'),
                collectedChanges = [];
            $A.eventService.addHandler({
                "event": lightningNsPrefix + "profileAttributeValueUpdatedEvent",
                "handler": function(event) {
                    $scope.reloadCard();
                }
            });

            $A.eventService.addHandler({
                "event": lightningNsPrefix + "profileAttributeCategoryUpdatedEvent",
                "handler": function(event) {
                    collectedChanges.push(event);
                }
            });
            
            $A.eventService.addHandler({
                "event": lightningNsPrefix + "profileNavigationEvent",
                "handler": function(event) {
                    var navigateFrom = event.getParam('navigateFrom'),
                        navigateTo = event.getParam('navigateTo');
                    if (navigateFrom === 'slide-to-profiler-edit' && collectedChanges.length > 0) {
                        $scope.reloadCard();
                    } else {
                        collectedChanges = [];
                    }
                }
            });
        }

        registerLightningEventHandler();

    }]);