vlocity.cardframework.registerModule
    .controller('PacksHistoryController',
                ['$scope', '$timeout', '$interval', '$filter','$rootScope',
                    function($scope, $timeout, $interval, $filter, $rootScope){   
    
    $scope.appendFlag = false;
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
    
    $scope.errorMessage = null;
    $scope.errorFound = false;
    
    $scope.maxDateValueFrom = new Date();
    $scope.maxDateValueTo = new Date();
    $scope.minDateValueFrom = moment();
    $scope.minDateValueFrom.add(-6, 'months'); //Antiguedad maxima.
    
    $scope.isOpenRangoDesde = false;
    $scope.isOpenRangoHasta = false;
    
    $scope.filterOptionRangoDesde = moment().add(-1, 'month');
    $scope.filterOptionRangoHasta = moment();
    
    $scope.filterOptionPack = 'Todos';
    $scope.isOpenCanal = false;
    
    $scope.changeFilterPack = function(category) {
        $scope.filterOptionPack = category;
        $scope.isOpenPack = false;
    }

    $scope.showMessageError = function(msg){
        $scope.errorMessage = msg;
        $scope.errorFound = true;
    }
    
    $scope.hideMessageError = function(){
        $scope.errorMessage = null;
        $scope.errorFound = false;
    }
    
    $scope.showGrid = false;
    
    $scope.filtersAccepted = function(){
        if($scope.filterOptionRangoDesde === ''){
            $scope.showMessageError('Debe ingresar una Fecha de inicio');
        } else if($scope.filterOptionRangoHasta === ''){
            $scope.showMessageError('Debe ingresar una Fecha de fin');
        } else{
            $scope.hideMessageError();
            
            var filterOptions = {};
            $scope.showGrid = true;
             
            $scope.updateDatasource({
            'startDateFilter' : $scope.filterOptionRangoDesde,
            'endDateFilter' : $scope.filterOptionRangoHasta,
            'namePack' : $scope.filterOptionPack,
                }, $scope.appendFlag, false, false);
              //  $scope.reloadLayout2();
            
            if($scope.appendFlag === true)
                $scope.appendFlag = false;
            
        }
    }
    
    //Setea la diferencia de dias minimo.
    $scope.setMinMaxDate = function(){
        $scope.minDateValueTo = $scope.filterOptionRangoDesde;
        
        var today = moment();
        var limitDay = moment($scope.filterOptionRangoDesde);
        limitDay = limitDay.add(30, 'days');
        
        if(limitDay > today)
            $scope.maxDateValueTo = today;
        else
            $scope.maxDateValueTo = limitDay;
        
        $scope.filterOptionRangoHasta = '';
    }
        
    $scope.search = function () {
        if($scope.searchTerm) 
        {
            $scope.filteredItems = $filter('filter')($scope.cards, filterTable);
            $scope.groupToPages($scope.filteredItems);
        } 
        else 
        {
            $scope.groupToPages($scope.cards);
        }
        
        $scope.range();
    };
    
    //INIT rows
    $scope.$watch('cards.length', function(length) {
        //$scope.items = $scope.cards;
        $scope.search();
    });
    
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
        $scope.sortingOrder = newSortingOrder.name;
        $scope.collapseAll();
    };
    
    $scope.collapseAll = function(){
        angular.forEach($scope.cards, function(k, v){
            k.status = "active"
        });
        
        var chevronOpen = document.getElementsByClassName('ng-show chevronOpen');
        for(var i = chevronOpen.length-1; i >= 0; i--)
        {
            chevronOpen[i].setAttribute('class','ng-hide chevronOpen');
        }
        
        var chevronClosed = document.getElementsByClassName('ng-hide chevronClosed');
        for(var x = chevronClosed.length-1; x >= 0; x--)
        {
            chevronClosed[x].setAttribute('class','ng-show chevronClosed');
        }
    }
    
    //watch for change in number of items inside a page
    $scope.$watch('itemsPerPage', function(length) {
        $scope.search();
    });
    
    $scope.getCardList = function(){
        return $scope.pagedItems[$scope.currentPage];
    }    
        
    $scope.getIndexForPage = function(index){
        var newIndex = 0;
        newIndex = index - ($scope.itemsPerPage * ($scope.currentPage));
       return newIndex;
    }
    
    $scope.toogleOpen = function(e, thiselement){
        clicked = e.currentTarget;
        closedChevron = e.currentTarget.getElementsByClassName('chevronClosed');
        next = e.currentTarget.nextElementSibling;
       
        
        if ( $scope.cards[ e.currentTarget.getAttribute('data-card') ].status != "expanded" ) {
            e.currentTarget.getElementsByClassName('chevronOpen')[0].setAttribute('class','ng-show chevronOpen');
            e.currentTarget.getElementsByClassName('chevronClosed')[0].setAttribute('class','ng-hide chevronClosed');
            $scope.cards[ e.currentTarget.getAttribute('data-card') ].status = "expanded"
            e.stopPropagation();
        } else {
            e.currentTarget.getElementsByClassName('chevronOpen')[0].setAttribute('class','ng-hide chevronOpen');
            e.currentTarget.getElementsByClassName('chevronClosed')[0].setAttribute('class','ng-show chevronClosed');
            $scope.cards[ e.currentTarget.getAttribute('data-card') ].status = "active"
            e.stopPropagation();
        }
        
    }
    
    $scope.init = function(){
        if($scope.params.AssetId !== undefined && $scope.params.AssetId !== '{1}')
        {
            $scope.filterOptionRangoDesde = moment().add(-1, 'month');
            $scope.filterOptionRangoHasta = moment();
            $scope.appendFlag = true;
            $scope.filtersAccepted();
            //$scope.reloadLayout();
        }
    }
}]);