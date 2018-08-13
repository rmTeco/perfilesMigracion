vlocity.cardframework.registerModule.controller('cardCanvasListInfiniteController', ['$scope','$window', function($scope,$window) {
        
    $scope.isMoreItems = false;
    //INIT rows
    $scope.$watch('cards.length', function(length) {
        //Number of items to load comes from session varaible of layout
        $scope.numberOfItems = parseInt($scope.session.numberOfItems);
        $scope.items = $scope.cards;
        $scope.renderedItems = [];
        $scope.showMoreItems();
    });

    
    //To decide next round of items to load
    $scope.showMoreItems = function () {
        var renderedItemsLength = $scope.renderedItems.length;
        
        for (var i = renderedItemsLength; (i < renderedItemsLength + $scope.numberOfItems) && ($scope.renderedItems.length <  $scope.items.length); i++) {
            $scope.renderedItems.push($scope.items[i]);
        }
        
        if($scope.renderedItems.length === $scope.items.length){
            $scope.isMoreItems = true;
        } else {
            $scope.isMoreItems = false;
        }
        
    };
    
    angular.element($window).on('scroll', function() {
        var windowHeight = window.innerHeight;
        var body = document.body, html = document.documentElement;
        var docHeight = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight,  html.scrollHeight, html.offsetHeight);
        windowBottom = windowHeight + window.pageYOffset;
        
        if (windowBottom >= docHeight) {
            $scope.showMoreItems();
            $scope.$apply();
        }
    });
    
}]);