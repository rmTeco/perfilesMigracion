vlocity.cardframework.registerModule
    .controller('refillHistoryController',
                ['$scope', 'interactionTracking', '$timeout', '$interval', '$filter','$rootScope',
                    function($scope, interactionTracking, $timeout, $interval, $filter, $rootScope){   
    
    //Decides the sorting order
    $scope.sortingOrder = 'obj.fechaEmisionComprobante';
    //Determines sorting should be ascending or descending

    $scope.errorMessage = null;
    $scope.errorFound = false;
    
    $scope.isOpenRangoDesde = false;
    $scope.isOpenRangoHasta = false;

    $scope.filterOptionRangoDesde = moment().add(-1, 'month');
    $scope.filterOptionRangoHasta = moment();
    
    $scope.maxDateValueFrom = new Date();
    $scope.minDateValueFrom = moment();
    $scope.minDateValueFrom.add(-6, 'months');
    $scope.minDateValueFrom.add(-1, 'days');
    $scope.maxDateValueTo = new Date();
    $scope.minDateValueTo = moment();
    $scope.minDateValueTo = $scope.filterOptionRangoDesde;
    
    $scope.filterOptionCanal = 'Todos';
    $scope.filterOptionBenef = 'Todos';
    
    $scope.saldoPorTipoBalance = 0;
    
    $scope.showMessageError = function(msg){
        $scope.errorMessage = msg;
        $scope.errorFound = true;
    }
    
    $scope.hideMessageError = function(){
        $scope.errorMessage = null;
        $scope.errorFound = false;
    }
    
    $scope.showGrid = true;
    
    $scope.filtersAccepted = function(){
        
        if($scope.filterOptionRangoDesde === ''){
            $scope.showMessageError('Debe ingresar una Fecha de inicio');
        } else if($scope.filterOptionRangoHasta === ''){
            $scope.showMessageError('Debe ingresar una Fecha de fin');
        } else{
            $scope.hideMessageError();
            $scope.params.startDateFilter = moment($scope.filterOptionRangoDesde).format('YYYY-MM-DD HH:mm:ss');
            
            $scope.params.endDateFilter = moment($scope.filterOptionRangoHasta).format('YYYY-MM-DD HH:mm:ss');
            
            //$scope.$parent.updateDatasource({'x':''}, false, false, false);
            
            $scope.reloadLayout2();
            
            $scope.showGrid = true;
            //console.log($scope.params.startDateFilter);
            //console.log($scope.params.endDateFilter);
        }
    }
    
    $scope.setMinDate = function(setMin){
        
        $scope.filterOptionRangoDesde = setMin;
        
        $scope.minDateValueTo = $scope.filterOptionRangoDesde;
        
        /*var today = moment();
        var limitDay = moment($scope.filterOptionRangoDesde);
        limitDay = limitDay.add(90, 'days');
        
        if(limitDay > today)
            $scope.maxDateValueTo = today;
        else
            $scope.maxDateValueTo = limitDay;*/
        
     
    }
    
     $scope.setMaxDate = function(setMax){
        $scope.minDateValueTo = $scope.filterOptionRangoDesde.add(-1, 'days');
        $scope.filterOptionRangoHasta = setMax;
        
        //console.log("$scope.maxDateValueTo = ", $scope.maxDateValueTo);
    }
        
    
    

    
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
        $scope.sortingOrderHTML = newSortingOrder.name;
        var name1 = newSortingOrder.name;
        var name2 = name1.replace("['","");
        $scope.sortingOrder = 'obj.' + name2.replace("']","");
        $scope.collapseAll();
    };
    

    //watch for change in number of items inside a page
    $scope.$watch('itemsPerPage', function(length) {
        //$scope.search();
    });
    
    $scope.getCardList = function(){
        return $scope.pagedItems[$scope.currentPage];
        
    }    
        
    $scope.getIndexForPage = function(index){
        var newIndex = 0;
        newIndex = index - ($scope.itemsPerPage * ($scope.currentPage));
       return newIndex;
    }
    

    var ctrl = this;
    ctrl.mobile = false;
    
 
    
    $scope.init = function(){

        $scope.saldoPorTipoBalance = $scope.records.datosBalance.listaInfoBalance.infoBalance[0].saldoPorTipoBalance;
        
        if(new Date($scope.params.CreatedDateAcc) > $scope.minDateValueFrom){
            $scope.minDateValueFrom = new Date($scope.params.CreatedDateAcc);
        }
        
        //$scope.filterOptionRangoDesde = moment().add(-1, 'month');
        $scope.filterOptionRangoHasta = moment();
        $scope.appendFlag = true;
        
        /*var sixMonthsPast =  moment().add(-6, 'month');
        items = $filter('orderBy')(items, 'fechaEmisionComprobante');
        var momentEmision = moment(items[0].fechaEmisionComprobante);
        console.log('sixmonths '+sixMonthsPast+' momentemision '+momentEmision);
        if(items[0] !== undefined && momentEmision > sixMonthsPast){
            //$scope.minDateValueFrom = items[0].fechaEmisionComprobante;
            $scope.minDateValueFrom = momentEmision;
            $scope.filterOptionRangoDesde = momentEmision;
        } else {
            $scope.minDateValueFrom =  momentEmision;
            $scope.filterOptionRangoDesde = moment().add(-6, 'month');
        }*/
        
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            ctrl.mobile = true;
        }
        
        //console.log(" $scope.minDateValueFrom  2= ",$scope.minDateValueFrom);
        
    }
}]);