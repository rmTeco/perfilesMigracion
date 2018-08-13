vlocity.cardframework.registerModule.controller('listCardCanvasINSSlds', ['$rootScope', '$scope', '$filter', function($rootScope, $scope, $filter) {
    
    var self = this;
    
    $rootScope.$on('PartySelected', function(event, obj) {
        // append additional query
        $scope.params.ownerId = obj.dev%vlocity_namespace%__PartyId__c;
        $scope.updateDatasource(
            {
            },
            false,
            false,
            false
        ); 
    });
    
    $rootScope.$on('PartyDeselected', function(event, obj) {
        // remove additional query
        delete $scope.params.ownerId;
            $scope.updateDatasource(
                {
                },
                false,
                false,
                false
            );
    });
    
    $rootScope.$on('PolicySelected', function(event, obj) {
        // append additional query
        $scope.params.policyId = obj.Id;
        $scope.updateDatasource(
            {
            },
            false,
            false,
            false
        ); 
    });
    
    $rootScope.$on('PolicyDeselected', function(event, obj) {
        // remove additional query
        delete $scope.params.policyId;
            $scope.updateDatasource(
                {
                },
                false,
                false,
                false
            );
    });
    
    var getter = $filter('getter');
    var picker = $filter('picker');
    
    function getQueryTextForCard(fields, obj) {
        var text = '';
        fields.forEach(function(field) {
            text += '|' + picker(getter(obj, field), field.type) + '';
        });
        return text;
    }
    
    function escapeRegExp(str) {
      return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
    }
    
    $scope.$watch('listCardCanvasINSSlds.search.queryableText', function(queryText) {
        if (queryText) {
            var regex = new RegExp(escapeRegExp(queryText), 'i');
            if (!self.cached) {
                self.cached = angular.copy($scope.cards);
            }
            var filtered = [];
            var fullSet = angular.copy(self.cached);
            fullSet.forEach(function(card) {
                var text = getQueryTextForCard(card.fields, card.obj);
                if (regex.test(text)) {
                    filtered.push(card);
                }
            });
            $scope.cards = filtered;
        } else if (self.cached) {
            $scope.cards = self.cached;
            self.cached = null;
        }
    });
    
}]);