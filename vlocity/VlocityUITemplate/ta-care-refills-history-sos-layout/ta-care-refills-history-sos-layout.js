vlocity.cardframework.registerModule
    .controller('refillHistoryController',
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
    $scope.minDateValueFrom.add(-6, 'months');
    
    $scope.isOpenRangoDesde = false;
    $scope.isOpenRangoHasta = false;

    
    $scope.filterOptionRangoDesde = moment().add(-1, 'month');
    $scope.filterOptionRangoHasta = moment();

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
             
           /* $scope.updateDatasource({
            'startDateFilter' : $scope.filterOptionRangoDesde, 
            'endDateFilter' : $scope.filterOptionRangoHasta,
                }, $scope.appendFlag, false, false);
              //  $scope.reloadLayout2();
        
            if($scope.appendFlag === true)
                $scope.appendFlag = false;
            */
            
        }
    }
    
    $scope.setMinMaxDate = function(){
        $scope.minDateValueTo = $scope.filterOptionRangoDesde;
        
        var today = moment();
        var limitDay = moment($scope.filterOptionRangoDesde);
        limitDay = limitDay.add(90, 'days');
        
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
        $scope.sortingOrder = 'obj'+newSortingOrder.name;
        //$scope.closeAll();
    };
    
    $scope.closeAll = function(){
        elements = document.getElementsByClassName('chevronOpen');
        for (var i = 0; i < elements.length; i++) {
           elements[i].remove = 'chevronClosed';
           elements[i].add = 'chevronOpen'; 
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
        //console.log(e);
        clicked = e.currentTarget;
        window.clicked = e.currentTarget;
        window.chevron = window.clicked.getElementsByClassName('chevronToogle');
        window.closedChevron = window.clicked.getElementsByClassName('chevronClosed');
        closedChevron = e.currentTarget.getElementsByClassName('chevronClosed');
        openChevron = 
        next = e.currentTarget.nextElementSibling;
        
        
        if ( next.getAttribute('data-status') == "closed" ) {
            e.currentTarget.getElementsByClassName('chevronOpen')[0].setAttribute('class','ng-show chevronOpen');
            e.currentTarget.getElementsByClassName('chevronClosed')[0].setAttribute('class','ng-hide chevronClosed');
            next.setAttribute('class','ng-scope ng-show');
            next.setAttribute('data-status','open');
            e.stopPropagation();
        } else {
            e.currentTarget.getElementsByClassName('chevronOpen')[0].setAttribute('class','ng-hide chevronOpen');
            e.currentTarget.getElementsByClassName('chevronClosed')[0].setAttribute('class','ng-show chevronClosed');
            next.setAttribute('class','ng-scope ng-hide');
            next.setAttribute('data-status','closed');
            e.stopPropagation();
        }
        
    }
    
    $scope.init = function(){
        if($scope.params.LineNumber !== undefined && $scope.params.LineNumber !== '{1}')
        {
            $scope.filterOptionRangoDesde = moment().add(-1, 'month');
            $scope.filterOptionRangoHasta = moment();
            $scope.appendFlag = true;
            $scope.filtersAccepted();
            //$scope.reloadLayout();
        }
    }
}]);