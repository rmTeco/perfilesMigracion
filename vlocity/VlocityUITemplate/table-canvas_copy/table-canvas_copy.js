vlocity.cardframework.registerModule.controller('containerTableCanvarController',
['$rootScope', '$scope', '$filter', function($rootScope, $scope, $filter) {
    
    //Decides the sorting order
    $scope.sortingOrder = '';
    //Determines sorting should be ascending or descending
    $scope.reverse = false;
    //List holds the filtered items
    $scope.filteredItems = [];
    //Items after dividing for different pages
    $scope.pagedItems = [];
    //Determines item per page
    $scope.itemsPerPage = 5;
    //Current selected page
    $scope.currentPage = 0;
    //List includes items per page options
    $scope.numberOfRowsOption = [5, 10, 20];
    //number of items per page
    $scope.numberOfPageLinks = 5;
    
    //INIT rows
    $scope.$watch('cards.length', function(length) {
        //$scope.items = $scope.cards;
        $scope.search();
    });
    
    //init the filtered items / if no search query is mentioned then
    $scope.search = function () {
        if($scope.searchTerm) {
            $scope.filteredItems = $filter('filter')($scope.cards, filterTable);
            $scope.groupToPages($scope.filteredItems);
        } else {
            $scope.groupToPages($scope.cards);
        }
        
        $scope.range();
        
    };
    
    //Filter function 
    var filterTable = function(row){
        var rawData = row.obj;
        var isFound = true;
         if($scope.searchTerm) {
            _.some(row.states[0].fields, function(field){
                var fieldValue = $filter('getter')(rawData, field).toUpperCase();
                isFound = _.includes(fieldValue, $scope.searchTerm.toUpperCase());
                return isFound;
            });
        }
        return isFound;
    }

    //To divide cards object in different pages.
    $scope.groupToPages = function (items) {
        $scope.pagedItems = [];
        var ret = [];
        
        for (var i = 0; i < items.length; i++) {
            if (i % $scope.itemsPerPage === 0) {
                ret[Math.floor(i / $scope.itemsPerPage)] = [items[i]];
            } else {
                ret[Math.floor(i / $scope.itemsPerPage)].push(items[i]);
            }
        }
        
        //filling last page empty rows
        /*var lastPageRowsLength = $scope.pagedItems[$scope.pagedItems.length-1].length;
        if(lastPageRowsLength < $scope.itemsPerPage){
            for (var j = lastPageRowsLength; j < $scope.itemsPerPage; j++) {
                $scope.pagedItems[$scope.pagedItems.length-1].push({});
            }
        }*/
        
        //Maintain sort order
        if ($scope.sortingOrder !== '') {
            items = $filter('orderBy')(items, $scope.sortingOrder, $scope.reverse);
        }
        
        // if ($scope.sortingOrder !== '') {
        //     items = $filter('orderBy')($scope.pagedItems[0], $scope.sortingOrder, $scope.reverse);
        // }
        
        $scope.currentPage = 0;
        $scope.previousPage = 0;
        $scope.nextPage = $scope.currentPage+1;
        
        $scope.pagedItems = ret;
    };
    
    //To create pagination links
    $scope.range = function () {
        var size = $scope.pagedItems.length;
        var start = $scope.currentPage;
        
        $scope.currentRange = []; 
        var end = $scope.currentPage + $scope.numberOfPageLinks;
        
        if (size < end) {
            end = size;
            start = size - $scope.numberOfPageLinks;
            if(start < 0){
                start = 0;
            }
        }
        for (var i = start; i < end; i++) {
            $scope.currentRange.push(i);
        }
    };
    
    //To visit a particular page
    $scope.goToPage = function(pageNumber){
        $scope.currentPage = pageNumber;
        $scope.previousPage = pageNumber - 1;
        $scope.nextPage = pageNumber + 1;
        $scope.range();
    }

    // change sorting order
    $scope.sortBy = function(newSortingOrder) {
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrder = 'obj'+newSortingOrder.name;
    };
    
    //watch for change in number of items inside a page
    $scope.$watch('itemsPerPage', function(length) {
        $scope.search();
    });
    
    $scope.getCardList = function(){
        return $scope.pagedItems[$scope.currentPage];
    }

}]);