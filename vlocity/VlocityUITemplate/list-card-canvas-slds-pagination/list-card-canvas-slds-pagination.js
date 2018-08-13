vlocity.cardframework.registerModule.controller('nplistCardCanvasINSSlds', ['$rootScope', '$scope', '$filter', function($rootScope, $scope, $filter) {
    $scope.sessionData = $scope.$parent.$parent.$parent.session.search;
     var sortingOrder = 'name';
    $scope.$watch('cards.length', function(length) {
     $scope.items = $scope.cards;
     $scope.search();
    });
    $scope.sortingOrder = sortingOrder;
    $scope.reverse = false;
    $scope.filteredItems = [];
    $scope.groupedItems = [];
    $scope.itemsPerPage = 5;
    $scope.pagedItems = [];
    $scope.currentPage = 0;
    //$scope.items = $scope.dataObject;
    
    var searchMatch = function (haystack, needle) {
        if (!needle) {
            return true;
        }
        return haystack.toLowerCase().indexOf(needle.toLowerCase()) !== -1;
    };

    // init the filtered items
    $scope.search = function () {
        $scope.filteredItems = $filter('filter')(
            $scope.items,
            function(card) {
                return $filter('filter')([card.obj], $scope.query).length == 1;
            }  );
        console.info('$scope.filteredItems',$scope.filteredItems);
        // take care of the sorting order
        if ($scope.sortingOrder !== '') {
            $scope.filteredItems = $filter('orderBy')($scope.filteredItems, $scope.sortingOrder, $scope.reverse);
        }
        $scope.currentPage = 0;
        // now group by pages
       $scope.groupToPages();
    };
    
    $scope.compareForNestedFiltering = function (actual, expected) {
    function contains (actualVal, expectedVal) {
        return actualVal.toString().toLowerCase().indexOf(expectedVal.toString().trim().toLowerCase()) !== -1;
    }
    if(typeof expected !== 'object') return contains(actual, expected);
    var result = Object.keys(expected).every(function (key) {
        return contains(eval('actual.'+key), eval('expected.'+key));
    });
    return result;
};
    
    // calculate page in place
    
    $scope.groupToPages = function () {
        $scope.pagedItems = [];
        
        for (var i = 0; i < $scope.filteredItems.length; i++) {
            if (i % $scope.itemsPerPage === 0) {
                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)] = [ $scope.filteredItems[i] ];
            } else {
                $scope.pagedItems[Math.floor(i / $scope.itemsPerPage)].push($scope.filteredItems[i]);
            }
        }
    };
    
    $scope.range = function (start, end) {
        var ret = [];
        if (!end) {
            end = start;
            start = 0;
        }
        for (var i = start; i < end; i++) {
            ret.push(i);
        }
        return ret;
    };
    
    $scope.prevPage = function () {
        if ($scope.currentPage > 0) {
            $scope.currentPage--;
        }
    };
    
    $scope.nextPage = function () {
        if ($scope.currentPage < $scope.pagedItems.length - 1) {
            $scope.currentPage++;
        }
    };
    
    $scope.setPage = function () {
        $scope.currentPage = this.n;
    };
    
    $scope.setItemsPerPage = function(pageSize) {
        $scope.itemsPerPage = pageSize;
        $scope.search();
    }

    // functions have been describe process the data for display
    

    // change sorting order
    $scope.sort_by = function(newSortingOrder) {
        if ($scope.sortingOrder == newSortingOrder)
            $scope.reverse = !$scope.reverse;

        $scope.sortingOrder = newSortingOrder;

        // icon setup
        $('th i').each(function(){
            // icon reset
            $(this).removeClass().addClass('icon-sort');
        });
        if ($scope.reverse)
            $('th.'+new_sorting_order+' i').removeClass().addClass('icon-chevron-up');
        else
            $('th.'+new_sorting_order+' i').removeClass().addClass('icon-chevron-down');
    };

}]);