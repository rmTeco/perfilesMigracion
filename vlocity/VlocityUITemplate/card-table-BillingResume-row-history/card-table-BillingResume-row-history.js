vlocity.cardframework.registerModule.controller('tableCtrl',
    ['$rootScope', 
     '$scope', 
     '$filter', 'interactionTracking', function($rootScope, $scope, $filter, interactionTracking) {
         
    var interactionData = interactionTracking.getDefaultTrackingData($scope);

    $scope.sortingOrder = '';
    $scope.reverse = false;
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
    //$scope.groupToPages($scope.cards);
    
    
    /* $scope.sortBy = function(newSortingOrder) {
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrder = newSortingOrder.name;
        console.log("$scope.sortingOrder 1 = ",$scope.sortingOrder);
        
        if ($scope.sortingOrder !== '') {
        var listTest = $scope.getCardList();
        console.log("getCardList 2 = ",listTest);
            $scope.records = $filter('orderBy')($scope.records, $scope.sortingOrder, $scope.reverse);
        }
        
    };*/
    
    // change sorting order
    $scope.sortBy = function(newSortingOrder) {
        if(newSortingOrder.name === "['listaDetallesPagos']['detallePago'][0]['numeroComprobante']"){
            newSortingOrder.name = ['numeroComprobante'];
        }
        $scope.reverse = !$scope.reverse;
        $scope.sortingOrderHTML = newSortingOrder.name;
        $scope.sortingOrder =  newSortingOrder.name;
    };
    
    //To divide cards object in different pages.
    $scope.groupToPages = function (items2) {
        if(angular.isArray(items2)){
            $scope.pagedItems = [];
            var ret = [];
            for (var i = 0; i < items2.length; i++) {
                if (i % $scope.itemsPerPage === 0) {
                    ret[Math.floor(i / $scope.itemsPerPage)] = [items2[i]];
                } else {
                    ret[Math.floor(i / $scope.itemsPerPage)].push(items2[i]);
                }
            }
        }
        
        //Maintain sort order
        if ($scope.sortingOrder !== '') {
            items2 = $filter('orderBy')(items, $scope.sortingOrder, $scope.reverse);
        }

        $scope.currentPage = 0;
        $scope.previousPage = 0;
        $scope.nextPage = $scope.currentPage+1;
        $scope.pagedItems = ret;
        $scope.range();
    };
    
    var ctrl = this;
    ctrl.mobile = false;
    $scope.init = function (){
        
        
        /*console.log("DATAAAA = ", $scope.data);
        console.log("OBJJJ = ", $scope.obj);
        console.log("PARAMSs = ", $scope.params);
        console.log("CARDS = ",$scope.cards);*/

        //$scope.initAcum($scope.records);
        
        ctrl.fechaHasta = $scope.$parent.$parent.$parent.$parent.filterOptionRangoHasta;
        

        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini/i.test(navigator.userAgent)) {
            // Take the user to a different screen here.
            ctrl.mobile = true;
        }
        
         $(document).ready(function(){
            $('.accordion').click(function() {
                console.log('asda');
                var acc = $(this);
                
                console.log(acc.next());
                acc.next().addClass("active");
                if (acc.next().css( "display") === "block") {
                    acc.next().css( "display", "none" );
                } else {
                    acc.next().css( "display", "block" );
                }
               

            });
            });
            
            $scope.groupToPages($scope.records);
        
    }
    
    $scope.getCardList = function(){
        $scope.initAcum($scope.pagedItems[$scope.currentPage]);
        return $scope.pagedItems[$scope.currentPage];
        
    }
    
    //watch for change in number of items inside a page
    $scope.$watch('itemsPerPage', function(length) {
        $scope.groupToPages($scope.records);
    });
    
    //To visit a particular page
    $scope.goToPage = function(pageNumber){
        $scope.currentPage = pageNumber;
        $scope.previousPage = pageNumber - 1;
        $scope.nextPage = pageNumber + 1;
        $scope.range();
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
    
    $scope.selectEvent = function(action,record){
          if($scope.data.title == 'Comprobantes'){
            $scope.TrackingEvent('Consulta de Comprobante',record);
          }else if($scope.data.title == 'Pagos'){
              $scope.params.txId = record.txId;
          }
          
          $scope.performAction(action);
     }
    
    $scope.TrackingEvent = function(evento,dato){
        var interactionData = interactionTracking.getDefaultTrackingData($scope);
        var query = 'Vista: Consulta de Comprobante'
                    + ' - NumeroCuenta: ' + $scope.params.numeroServicio
                    + ' - TipoDeComprobante: ' + dato.codAccionNegocio
                    + ' - NumeroComprobante: ' + dato.numeroComprobanteLegal;

        var accion = evento;
        var eventData = {
                'TrackingService': 'Acuity',
                'TrackingEvent' : 'Consulta de Comprobante',
                'Criteria' : query,
                'TrackedAction' : accion,
                'TrackedCard' : 'Resumen de Cuenta'
            };
            interactionData = angular.extend(interactionData, eventData);
            interactionTracking.addInteraction(interactionData);
    }
    
    $scope.initAcum = function(items){
        var date1 = new Date();
        var date2 = new Date();
        var mount = Number('0');
        var comprobante = Number('0');
        
        if($scope.data.cardName === 'ta-care-Billing-Resume-Comprobante'){
            for(i=0;i<items.length;i++){
                if(items[i].fechaEmisionComprobante && items[i].fechaVencimientoComprobante && items[i].importeComprobante && items[i].numeroComprobanteLegal) {
                    date1 = new Date(items[i].fechaEmisionComprobante);
                    date2 = new Date(items[i].fechaVencimientoComprobante);
                    mount = Number(items[i].importeComprobante);
                    comprobante = items[i].numeroComprobanteLegal;
                    items[i].fechaEmisionComprobante = date1;
                    items[i].fechaVencimientoComprobante = date2;
                    items[i].importeComprobante = mount;
                    items[i].numeroComprobanteLegal = comprobante;
                }
            }
        }else if($scope.data.cardName === 'ta-care-Billing-Resume-Pago'){
            for(i=0;i<items.length;i++){
                if (items[i].fechaAplicacionPago && items[i].importePago) { 
                    date1 = new Date(items[i].fechaAplicacionPago);
                    mount = Number(items[i].importePago);
                    comprobante = items[i].txId;
                    /*if(items[i].listaDetallesPagos) {
                        comprobante = Number(items[i].listaDetallesPagos.detallePago[0].numeroComprobante);
                    }*/
                    items[i].fechaAplicacionPago = date1;
                    items[i].importePago = mount;
                    items[i].numeroComprobante = comprobante;
                }
            }
        }
        
    }

}]);