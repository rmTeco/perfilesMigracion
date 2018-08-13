vlocity.cardframework.registerModule
    .controller('NegotiationsController',
                ['$window','$scope', '$timeout', '$interval', '$filter','$rootScope',
                    function($window,$scope, $timeout, $interval, $filter, $rootScope){   

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
    
    $scope.filterOptions = ['Casos', 'Ordenes'];
    
    $scope.errorMessage = null;
    $scope.errorFound = false;
    
    $scope.maxDateValueFrom = new Date();
    $scope.maxDateValueTo = new Date();
    //$scope.minDateValueFrom = moment(); // => parametrizable
    //$scope.minDateValueFrom.add(-99, 'years'); //Antiguedad maxima => parametrizable
    
    $scope.isOpenRangoDesde = false;
    $scope.isOpenRangoHasta = false;
    
    $scope.filterOptionRangoDesde = moment().add(-1, 'month');
    $scope.filterOptionRangoHasta = moment().add(2, 'month');
    
    $scope.filterOptionPack = 'Todos';
    $scope.isOpenCanal = false;

    $scope.originaldata = $scope.records.Negotiations;
    $scope.filtered = [];
    
    $scope.showGrid = false;
    
    $scope.showAccordionDetail = false;
    
    // $scope.screenSize = screenSize;
    
    //var nc = this;
    //nc.init = init;
    //nc.mobile = false;
    
    $scope.changeFilterPack = function(category) {
        $scope.filterOptionPack = category;
        $scope.isOpenPack = false;
    }
    
    $scope.openOrder = function(id,num) {
        console.info('en openOrder'+id+' '+num);
        function testOpenSubtab() {
        
            sforce.console.getEnclosingPrimaryTabId(openSubtab);
        }
        
        var openSubtab = function openSubtab(result) {
            console.info('enopenSubtab'+result);
            var primaryTabId = result.id;
            sforce.console.openSubtab(primaryTabId , '/'+id, true, 
                'Orden '+ num , null, openSuccess, null);
        };
        
        var openSuccess = function openSuccess(result) {
            console.info('en openSuccess'+result);
            if (result.success == true) {
                console.log('subtab successfully opened');
            } else {
                console.log('subtab cannot be opened');
            }
        };
    
        testOpenSubtab();
    
    }
    
    $scope.showMessageError = function(msg){
        $scope.errorMessage = msg;
        $scope.errorFound = true;
    }
    
    $scope.hideMessageError = function(){
        $scope.errorMessage = null;
        $scope.errorFound = false;
    }
    
   
    
    $scope.filtersAccepted = function(){
        if($scope.filterOptionRangoDesde === ''){
            $scope.showMessageError('Debe ingresar una Fecha de inicio');
        } else if($scope.filterOptionRangoHasta === ''){
            $scope.showMessageError('Debe ingresar una Fecha de fin');
        } else{
            $scope.hideMessageError();           
            $scope.filtered.Negotiations = [];
            
            //conversion date del input para matchear los dates que llegan en los records
            var startDate = $('#text-input-id-1').val();
            var endDate = $('#text-input-id-2').val();
            var typeInput = $('#text-input-03').val();
            if (startDate && endDate) {
                
                console.log('entra0 ' + startDate + ' - ' + endDate);
                var startDate2 = formatDate(startDate);
                var endDate2 = formatDate(endDate);
                var objDate;
                var splitObjDate;
                var originalDate;
                for (var i = 0, len = $scope.originaldata.length; i < len; i++) {
                    
                    objDate = $scope.originaldata[i].negDate;
                    objDate = objDate.split('T');
                    splitObjDate = objDate[0].split('-');
                    year = splitObjDate[0];
                    month = splitObjDate[1];
                    day = splitObjDate[2];
                    console.log('entra1 ' + startDate2 + ' - ' + endDate2);
                    originalDate = new Date(year,month-1,day);
                    if ((+startDate2 <= +originalDate) && (+endDate2 >= +originalDate)) { 
                        if(((typeInput === 'Ordenes')&&($scope.originaldata[i].negType === 'Order'))||((typeInput === 'Casos')&&($scope.originaldata[i].negType === 'Case'))) {
                            console.log('entra2 ' + $scope.originaldata[i]);
                            $scope.filtered.Negotiations.push($scope.originaldata[i]);
                        }
                        else if (typeInput === 'Todos') {
                            console.log('entra3 ' + $scope.originaldata[i]);
                            $scope.filtered.Negotiations.push($scope.originaldata[i]);
                        }  
                    }
                }
                if (!$scope.showGrid) {
                    $scope.showGrid = true;
                }
                //$scope.updateDatasource();
            } 
            else {
                for (var j = 0, len2 = $scope.originaldata.length; j < len2; j++) {
                    $scope.filtered.Negotiations.push($scope.originaldata[j]);
                }
            }

            console.log('data ' + $scope.originaldata.length);
            console.log('filter ' + $scope.filtered.Negotiations);
            $scope.groupToPages($scope.filtered.Negotiations);
            $scope.range();
            
            
        }
    }
    
    function formatDate(date) {

        if (date.includes('/'))
        {
            date = date.split('/');
            var year = date[2];
            var month = date[1];
            var day = date[0];
            var retDate = new Date(year,month-1,day);
        } else if (date.includes('-'))  // Responsive format date
                {
                    date = date.split('-');
                    var year = date[0];
                    var month = date[1];
                    var day = date[2];
                    var retDate = new Date(year,month-1,day);
                }
        return retDate;
    }
    
    //Setea la diferencia de dias minimo.
    $scope.setMinMaxDate = function(){
        $scope.minDateValueTo = $scope.filterOptionRangoDesde;
        
        var today = moment();
        var limitDay = moment($scope.filterOptionRangoDesde);
        limitDay = limitDay.add(366, 'days');
        
        
        // if(limitDay > today)
        //     $scope.maxDateValueTo = today;
        // else
        //     $scope.maxDateValueTo = limitDay;
            
        $scope.maxDateValueTo = today;
        
        $scope.filterOptionRangoHasta = '';
    }
        
    $scope.search = function () {

        $scope.groupToPages($scope.cards);
        $scope.range();
    };
    
    //INIT rows
    $scope.$watch('cards', function() {
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
        console.log('Hola ' + $scope.pagedItems);
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
        
    $scope.getIndexForPage = function(index){
        var newIndex = 0;
        newIndex = index - ($scope.itemsPerPage * ($scope.currentPage));
       return newIndex;
    }
    
    $scope.toogleOpen = function(e, thiselement){
        
    }
    
    
    $scope.init = function(){
        
        window.sforce = sforce;
        window.scope = $scope;

        if($scope.params.AssetId !== undefined && $scope.params.AssetId !== '{1}')
        {
            $scope.filterOptionRangoDesde = moment().add(-1, 'month');
            $scope.filterOptionRangoHasta = moment();
            
            var dateString  = $scope.records.AssetMinDate;
            var year        = dateString.substring(0,4);
            var month       = dateString.substring(5,7);
            var day         = dateString.substring(8,10);
            
            var date        = new Date(year, month, day);
            var cvteddate   = new Date();
            
            
            var param = year +'-'+ month +'-'+ day
            $scope.filterOptionRangoDesde = moment(param);

            $scope.filtersAccepted();
            //$scope.reloadLayout();
            
            $scope.sortBy('Fecha');
        }
        
        // if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
        //     // Take the user to a different screen here.
        //     nc.mobile = true;
        // }

    }
    

}]);

vlocity.cardframework.registerModule
    .directive('windowSize', function ($window) {
      return function (scope, element) {
        var w = angular.element($window);
        scope.getWindowDimensions = function () {
            return {
                'h': w.height(),
                'w': w.width()
            };
        };
        scope.$watch(scope.getWindowDimensions, function (newValue, oldValue) {
          scope.windowHeight = newValue.h;
          scope.windowWidth = newValue.w;
          scope.style = function () {
              return {
                  'height': (newValue.h - 100) + 'px',
                  'width': (newValue.w - 100) + 'px'
              };
          };
        }, true);

        w.bind('resize', function () {
            scope.$apply();
        });
      }
    })