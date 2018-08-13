vlocity.cardframework.registerModule.controller('containerTableCanvarController', ['$rootScope', '$scope', '$filter', function($rootScope, $scope, $filter) {
    
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
    $scope.numberOfPageLinks = 3;
    
    //INIT rows
    $scope.$watch('cards.length', function(length) {
        $scope.items = $scope.cards;
        $scope.search();
    });
    
    //init the filtered items / if no search query is mentioned then
    $scope.search = function () {
        $scope.filteredItems = $filter('filter')($scope.items, filterTable);
        $scope.groupToPages();
    };
    
    //Filter function 
    var filterTable = function(row){
        var rawData = row.obj;
        var isFound = true;
         if($scope.searchTerm) {
            var getterFilter = $filter('getter');
            _.some(row.states[0].fields, function(field){
                var fieldValue = getterFilter(rawData, field).toUpperCase();
                isFound = _.includes(fieldValue, $scope.searchTerm.toUpperCase());
                return isFound;
            });
        }
        return isFound;
    }

    //To divide cards object in different pages.
    $scope.groupToPages = function () {
        $scope.pagedItems = [];
       
       //Maintain sort order
        if ($scope.sortingOrder !== '') {
            $scope.filteredItems = $filter('orderBy')($scope.filteredItems, $scope.sortingOrder, $scope.reverse);
        }
        
        for (var i = 0; i < $scope.filteredItems.length; i++) {
            if (i % $scope.itemsPerPage === 0) {
                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [ $scope.filteredItems[i] ];
            } else {
                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
            }
        }
        
        
        $scope.currentPage = 0;
        $scope.previousPage = 0;
        $scope.nextPage = $scope.currentPage+1;
    };
    
    //To create pagination links
    $scope.range = function (size, start, numberOfPages) {
        var ret = []; 
        var end = start + numberOfPages;

        if (size < end) {
            end = size;
            start = size-$scope.numberOfPageLinks;
            if(start < 0){
                start = 0;
            }
        }
        for (var i = start; i < end; i++) {
            ret.push(i);
        }        

        return ret;
    };
    
    //To visit a particular page
    $scope.goToPage = function(pageNumber){
        $scope.currentPage = pageNumber;
        $scope.previousPage = pageNumber - 1;
        $scope.nextPage = pageNumber + 1;
    }

    // change sorting order
    $scope.sortBy = function(newSortingOrder) {
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrder = 'obj'+newSortingOrder.name;
        
        $scope.filteredItems = $filter('orderBy')($scope.filteredItems, $scope.sortingOrder, $scope.reverse);
        $scope.groupToPages();
    };
    
    //watch for change in number of items inside a page
    $scope.$watch('itemsPerPage', function(length) {
        $scope.search();
    });
    
    $scope.getCardList = function(){
        return $scope.pagedItems[$scope.currentPage];
    }

}]);