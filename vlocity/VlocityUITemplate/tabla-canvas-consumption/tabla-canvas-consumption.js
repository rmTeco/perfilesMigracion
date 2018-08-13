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
 
    $rootScope.$on('filtersAccepted', function(event, filterOptions){
        console.log('received filter options ',filterOptions);
        $scope.showGrid = true;
        $scope.restoreCombo();
        $rootScope.family = filterOptions.serviceFamily;
        $rootScope.startDateFamily = filterOptions.filterOptionRangoDesde;
        $rootScope.endDateFamily = filterOptions.filterOptionRangoHasta;
        $rootScope.InvoiceNumFamily = filterOptions.filterOptionFactura;
        console.log('family is ',$rootScope.family);
        
        //$scope.findState();
        
        $scope.$parent.updateDatasource({
            'familyFilter' : $rootScope.family, 
            'startDateFilter' : $rootScope.startDateFamily,
            'endDateFilter' : $rootScope.endDateFamily,
            'facturaFilter' : $rootScope.InvoiceNumFamily
        }, false, false, false);
        $scope.$parent.reloadLayout2();
    });
    
    $scope.restoreCombo = function(){
        $scope.filterAditonalOption = 'Todos los consumos';
        $scope.filterTypeFilterOption = 'Con y sin cargo';
    }
    
    //INIT rows
    $scope.$watch('records.length', function(length) {
        //$scope.items = $scope.cards;
        console.log('cards changed', length);
        $scope.search();
    });
    
    //init the filtered items / if no search query is mentioned then
    $scope.search = function () {
        if($scope.searchTerm || $scope.searchAditionalFilter ||  $scope.searchAditionalFilterOption) {
            $scope.filteredItems = $filter('filter')($scope.cards, filterTable);
            $scope.groupToPages($scope.filteredItems);
        } 
        else 
        {
            $scope.groupToPages($scope.cards);
        }
        
        $scope.range();
    };
    
    //Filter function 
    var filterTable = function(row){
        var rawData = row.obj;
        var isFound = true;
        if($scope.searchTerm) {
            _.some(row.states[$scope.findState($rootScope.family, row.states)].fields,
             function(field){
                 if(field.name == "['DestinationNumber']")
                 {
                    var fieldValue = $filter('getter')(rawData, field).toUpperCase();
                    isFound = _.includes(fieldValue, $scope.searchTerm.toUpperCase());
                 }
                 else
                    isFound = false;
                    
                return isFound;
            });
        }
        
        if(isFound && $scope.searchAditionalFilter && $scope.searchAditionalFilter != 'Todos los consumos') {
            if($scope.searchAditionalFilter)
                isFound = rawData.ConsumptionType.toUpperCase() == $scope.searchAditionalFilter.toUpperCase();
        }
        
        if(isFound && $scope.searchAditionalFilterOption && $scope.searchAditionalFilterOption != 'Con y sin cargo') {
            if($scope.searchAditionalFilterOption == 'Sin cargo')
                isFound = parseFloat(rawData.Cost) <= 0;
                
            if($scope.searchAditionalFilterOption == 'Con cargo')
                isFound = parseFloat(rawData.Cost) > 0; 
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
        
        //Maintain sort order
        if ($scope.sortingOrder !== '') {
            items = $filter('orderBy')(items, $scope.sortingOrder, $scope.reverse);
        }

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
        console.log('getting current page ',$scope.pagedItems[$scope.currentPage]);
        return $scope.pagedItems[$scope.currentPage];
    }
    
    $scope.filterAditonalOption = 'Todos los consumos';
    
    $scope.changeAditionalFilter = function(category){
    $scope.searchAditionalFilter = category;
    $scope.filterAditonalOption = category;
    $scope.search();
    }
    
    $scope.filterTypeFilterOption = 'Con y sin cargo';
    
    $scope.changeAditionalFilterOption = function(category) {
    $scope.searchAditionalFilterOption = category;
    $scope.filterTypeFilterOption = category
    $scope.search();

    }
    
    $scope.findState = function(myFamily){
        //$scope.family = myFamily;
        var stateIndex = 0;
        angular.forEach($scope.cards[0].states, function(state, index){
            if($rootScope.family === state.name) {
                stateIndex = index;
                $rootScope.selectedState = state;
            }
        });
        return stateIndex
        
    }

    
          //toggle hidden row
      $scope.toggleHiddenRow = function(){
          $scope.activeRow = "algo";
      };

    
    /*
    var isCtrl = false;
    document.onkeyup=function(e)
    {
        if(e.which == 17)
            isCtrl=false;
        }
        
        document.onkeydown=function(e)
        {
        if(e.which == 17)
           isCtrl=true;
           
        if((e.which == 85) || (e.which == 67) && isCtrl === true)
        {
            return false;
        }
    }
    
    document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
    */
    
}]);