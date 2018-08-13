vlocity.cardframework.registerModule.controller('intelligenceRecourceArticles', ['$scope','interactionTracking', function($scope,interactionTracking) {
       
        $scope.activeObj = [];
         $scope.prefixNamespace = localStorage.getItem('nsPrefixDotNotation').replace('_','-');
            
            $scope.sessionData = $scope.$parent.$parent.$parent.session.defaultUserIcon;
             $scope.getImageUrl = function(obj) {
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
     $scope.openStory = function(obj) {
            var toBeLaunchedUrl = obj.navigateLink || ('/' + obj.Id)
            $scope.performAction({
                isCustomAction: true,
                url: toBeLaunchedUrl
            });
        };
        $scope.dismissOffer = function(obj, card, $event) {
            var interactionData = interactionTracking.getDefaultTrackingData($scope);
            var eventData = {
                'TrackingService': 'Acuity',
                'TrackingEvent' : 'Reject',
                'ContextId' : obj.contextId,
                'ResourceId' : obj.resourceId,
                'ScaledRawScore' : obj.scaledRawScore,
                'CurrentMachine' : obj.currentMachine,
                'TargetObjectType' : obj.targetObjectType,
                'TargetObjectKey' : obj.targetObjectKey
            };
            interactionData = angular.extend(interactionData, eventData);
            interactionTracking.addInteraction(interactionData);
            $event.stopPropagation();
            $scope.$emit($scope.data.layoutName+'.events', {
                event: 'removeCard',
                message: $scope
            });
        };
        $scope.viewOffer = function(obj, card, $event) {
            var interactionData = interactionTracking.getDefaultTrackingData($scope);
            var eventData = {
                'TrackingService': 'Acuity',
                'TrackingEvent' : 'View',
                'ContextId' : obj.contextId,
                'ResourceId' : obj.resourceId,
                'ScaledRawScore' : obj.scaledRawScore,
                'CurrentMachine' : obj.currentMachine,
                'TargetObjectType' : obj.targetObjectType,
                'TargetObjectKey' : obj.targetObjectKey
            };
            interactionData = angular.extend(interactionData, eventData);
            interactionTracking.addInteraction(interactionData);
           
            $scope.$emit($scope.data.layoutName+'.events', {
             
                message: $scope
            });
        };
        $scope.clickOffer = function(obj, card, $event) {
            var interactionData = interactionTracking.getDefaultTrackingData($scope);
            var eventData = {
                'TrackingService': 'Acuity',
                'TrackingEvent' : 'Accept',
                'ContextId' : obj.contextId,
                'ResourceId' : obj.resourceId,
                'ScaledRawScore' : obj.scaledRawScore,
                'CurrentMachine' : obj.currentMachine,
                'TargetObjectType' : obj.targetObjectType,
                'TargetObjectKey' : obj.targetObjectKey
            };
            interactionData = angular.extend(interactionData, eventData);
            interactionTracking.addInteraction(interactionData);
       
            $scope.$emit($scope.data.layoutName+'.events', {
             
                message: $scope
            });
        };
        
        
       
          }]);