vlocity.cardframework.registerModule.controller('containerTableCanvarController',
['$rootScope', '$scope',  'interactionTracking',  '$filter', function($rootScope, $scope, interactionTracking, $filter, $window) {
    
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
    

    //sumatory
    //https://vlocity.atlassian.net/browse/PFTA-7019
    $scope.pageSumatory = 0;
    
    //https://vlocity.atlassian.net/browse/PFTA-7021
    $scope.showPageSumatoryUnits=false;
    $scope.pageSumatoryUnits = "-";
    $scope.pageSumatoryUnitsData="-";
    $scope.pageSumatoryUnitsVoice="-";
    $scope.pageSumatoryUnitsSms="-";
    
    $scope.pageSumatoryCostData=0;
    $scope.pageSumatoryCostVoice=0;
    $scope.pageSumatoryCostSms=0;
    
    
    //https://vlocity.atlassian.net/browse/PFTA-7384
    $scope.pageProductListOriginal = [];
    $scope.pageProductList = [];
    
    
    /*PFTA-6865*/
    //se debe enmascarar cualquier telefono segun amelia
    
    function phoneMask2(phoneNumber){
       var phone=phoneNumber.toString();
       //console.log(phone.length );
        if(phone.length >=4 ){
            var part1 = phone.substring(0,phone.length -3);
            var part2 = phone.substring(phone.length -3, phone.length );
            if(part1.length >= 4){
                var part1_1 = part1.substring(0,part1.length -3);
                return part1_1 +'XXX'+ part2;
            }
            else{
                return 'XXX'+part2;
            }
        } 
        else {
           return phone;    
       }
       //console.log('en phoneMask2 002');
       return phoneNumber;
    }
    

    $rootScope.validarRoot  = function(startDate, endDate) {
         
        //console.log (startDate, endDate);
        // startDate = new Date(startDate);
        // endDate = new Date(endDate);
        startDate = moment($rootScope.filterOptionRangoDesde).toDate();
        endDate = moment($rootScope.filterOptionRangoHasta).toDate();
        
        currentDate = new Date();
        
        $rootScope.validatedDates = true;
        

        if(isNaN(startDate) && isNaN(endDate))
        {
            this.showMessageError("Ingresá un rango de fechas.");
            $rootScope.validatedDates = false;
            return false;
        }
        
        if(isNaN(startDate))
        {
            this.showMessageError("Ingresá una fecha de inicio.");
            $rootScope.validatedDates = false;
            return false;
        }
        
        if(isNaN(endDate))
        {
            this.showMessageError("Ingresá una fecha de fin.");
            $rootScope.validatedDates = false;
            return false;
        }
        
        if(startDate > endDate)
        {
            this.showMessageError("La fecha de inicio debe ser anterior a la de fin. Modificá la fecha de inicio.");
            $rootScope.validatedDates = false;
            return false;
        }
        
        if(endDate > currentDate)
        {
            this.showMessageError("Sólo podés ver consumos pasados. Modificá la fecha de fin.");
            $rootScope.validatedDates = false;
            return false;
        }
        
        return true;
    }
    
    
    
    
    
    
    
    //$rootScope.$on('filtersAccepted', function(event, filterOptions){
    $scope.getDetails = function() {
        
        /*var name_list = $scope.records;
        filtered = name_list.filter(a => {
            this.my = this.my || Object.create(null);
            if (!this.my[a.Product]) {
                this.my[a.Product] = true;
                return true;
            }
        });
        $scope.pageProductListOriginal=filtered;
        $scope.pageProductList=filtered;
    
    
      
        $scope.showGrid = true;
        $scope.restoreCombo();*/
        
        //$scope.appendFlag = filterOptions.appendFlag;
        
        
       
        
         $scope.findState();
        $scope.search();
        
        
        /*$scope.$parent.updateDatasource({
            'familyFilter' : $rootScope.family, 
            'startDateFilter' : $rootScope.startDateFamily,
            'endDateFilter' : $rootScope.endDateFamily,
            'facturaFilter' : $rootScope.InvoiceNumFamily,
            'CustomerIntegrationId' : $rootScope.CustomerIntegrationId
        }, $scope.appendFlag, false, false);
        $scope.$parent.reloadLayout2();*/
        
        //console.log($scope.appendFlag);
        
        
        
        /*
        if($scope.appendFlag === true)
            $scope.appendFlag = false;
        else 
            $scope.$parent.reloadLayout2();
        */
    };
    $scope.showGrid = false;
    
    $scope.updateResults = function() {
        if (!!$scope.records && typeof $scope.records === "object") {
            $scope.showGrid = true;
            $scope.findState();
            $scope.restoreCombo();
             
            var name_list = $scope.records;
            filtered = name_list.filter(a => {
                this.my = this.my || Object.create(null);
                if (!this.my[a.nombreProducto]) {
                    this.my[a.nombreProducto] = true;
                    return true;
                }
            });
            $scope.pageProductListOriginal=filtered;
            $scope.pageProductList=filtered;
            $scope.range();
            $scope.search(); 
            clearInterval($scope.interval);
            $scope.showGrid = true;
            $scope.restoreCombo();
            
        }
    }
    
    $scope.$on('filtersAccepted', function(event, filterOptions){
        console.log('received: filtersAccepted' + filterOptions);
        $rootScope.filterOptions = filterOptions;
    });
    
    $scope.selectedAsset = '';
    $scope.interval = '';
    $scope.lastCall = 1;
    
    setInterval(function(){ 
        
        //console.info('interval:'+ $scope.records)
        /*if ( typeof $rootScope.newSelectedAsset === 'undefined' || $scope.selectedAsset ==  $rootScope.newSelectedAsset) {
            //console.log('sin cambios');*/
        if ( $rootScope.thisCall ===  $scope.lastCall && $rootScope.validatedDates === true ) {
           // console.log('sin cambios');
           $rootScope.thisCall =  $scope.lastCall;
        } else {

                $scope.showGrid = false;
                $scope.selectedAsset = $rootScope.newSelectedAsset;
                $rootScope.thisCall =  $scope.lastCall;
                
                $rootScope.validarRoot();
                
                console.log('updating records 1 '+ $rootScope.CustomerIntegrationId);
                
                console.log('updating records 2'+ $rootScope.InitialAssetLine + $rootScope.dataSourceFrom + $rootScope.dataSourceTo + $scope.selectedAsset);
                
                // $scope.updateDatasource({
                //     'familyFilter' : $rootScope.family, 
                //     'startDateFilter' : $rootScope.startDateFamily,
                //     'endDateFilter' : $rootScope.endDateFamily,
                //     'facturaFilter' : $rootScope.InvoiceNumFamily,
                //     'CustomerIntegrationId' : $rootScope.CustomerIntegrationId
                // }, true, true, true);
                
                
                /*$scope.updateDatasource({
                    'familyFilter' : 'Prepaid', 
                    'startDateFilter' : '20171201',
                    'endDateFilter' : '20171210',
                    'facturaFilter' : '',
                    'CustomerIntegrationId' : $rootScope.CustomerIntegrationId
                }, true, true, true);
                */
                
                $scope.updateDatasource({
                    'familyFilter' : 'Prepaid', 
                    'startDateFilter' : $rootScope.filterOptions.filterOptionRangoDesde,
                    'endDateFilter' : $rootScope.filterOptions.filterOptionRangoHasta,
                    'facturaFilter' : $rootScope.filterOptions.filterOptionFactura,
                    'filterOption' : $rootScope.filterOptions.filterOption,
                    'CustomerIntegrationId' : $rootScope.InitialAssetLine //$rootScope.CustomerIntegrationId
                }, true, true, true);
                
                
                
                // AUDIT LOG PFTA-4596
                var interactionData = interactionTracking.getDefaultTrackingData($scope);
            
                var query = 'Servicio: ' + ($rootScope.filterOptions.filterServiceOption || '')
                        + ' - Familia del Servicio: ' + ($rootScope.filterOptions.serviceFamily || '')
                        + ' - Línea: ' + ($rootScope.filterOptions.serviceLine || '')
                        + ($rootScope.filterOptions.filterOptionFactura !== "" ? (' - Factura de: ' + ($rootScope.filterOptions.filterOptionFactura || '')) : '')
                        + ' - Nombre del Servicio: ' + ($rootScope.filterOptions.serviceName || '')
                        + ' - Desde qué Momento: ' + $rootScope.filterOptions.filterOption
                        // + (this.filterOption.trim() == 'Un rango personalizado' ? (' - Rango desde: ' + ($rootScope.filterOptions.filterOptionRangoDesde || '') + ' - hasta: ' + ($rootScope.filterOptions.filterOptionRangoHasta || '')) : '');
                        
                var eventData = {
                    'TrackingService': 'Acuity',
                    'TrackingEvent' : 'DetalleConsumo',
                    'Criteria' : query
                };
                interactionData = angular.extend(interactionData, eventData);
                interactionTracking.addInteraction(interactionData);
                // END AUDIT LOG
            
                $scope.$parent.reloadLayout2();
                $scope.updateResults();
                $scope.interval = setInterval(function(){ 
                    $scope.updateResults();
                }, 100);
                
                console.log('nuevo asset');
                //$scope.getDetails();

        }
        
    }, 100);
    
    
    
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
        
    $scope.restoreCombo = function(){
        $scope.filterAditonalOption = 'Todos los consumos';
        $scope.filterTypeFilterOption = 'Con y sin cargo';
        $scope.filterAditonalOptionProduct= 'Todos los productos';
        
        //https://vlocity.atlassian.net/browse/PFTA-7021
        $scope.showPageSumatoryUnits=false;
    }
    
    //INIT rows
    $scope.$watch('cards.length', function(length) {
        //$scope.items = $scope.cards;
        //console.log('cards changed', length);
        $scope.search();
    });
    
    
    $scope.sansIncoming = [];
    $scope.removeIncoming = function() {
        for (var i = 0; i < $scope.cards.length; i++) {
            
            if ( $scope.cards[i].obj.descripcionTipoEvento == "Llamada de voz" && $scope.cards[i].obj.sentidoTrafico == "I") {
                 continue;
            } 
            
            // falta sms y mms
            if ( $scope.cards[i].obj.descripcionTipoEvento == "Llamada de voz" && $scope.cards[i].obj.sentidoTrafico == "I") {
                 continue;
            } 
            
            $scope.sansIncoming.push($scope.cards[i]);
            
        }
    }
    
    
    //init the filtered items / if no search query is mentioned then
    $scope.search = function () {
        
        if($scope.searchTerm || $scope.searchAditionalFilter ||  $scope.searchAditionalFilterOption || $scope.filterAditonalOptionProduct) {
            $scope.filteredItems = $filter('filter')($scope.cards, filterTable);
            $scope.groupToPages($scope.filteredItems);
        } 
        else 
        {   
            $scope.groupToPages($scope.cards);
        }
        
        $scope.range();
    };
    
    $scope.FiltersMsg = false;
    $scope.changedfilters = function() {
        var filtersActive = false;
        // console.log ($scope.searchTerm);
        // console.log ($scope.searchAditionalFilter);
        // console.log ($scope.filterTypeFilterOption);
        // console.log ($scope.filterAditonalOptionProduct);
        
        $debug = 0;
        
        if (typeof $scope.searchTerm == null || $scope.searchTerm == "") { } else {
            filtersActive = true;
            $debug = 1;
        }
        
        if ( $scope.searchAditionalFilter == undefined ) {
        } else {
            if(typeof $scope.searchAditionalFilter !== undefined && $scope.searchAditionalFilter != "Todos los consumos" ) {
                filtersActive = true; 
                $debug = 2;
            }
        }
        
        if ( $scope.filterTypeFilterOption != "Con y sin cargo") {
            filtersActive = true;
            $debug = 3;
        }
        
        if ( $scope.filterAditonalOptionProduct != "Todos los productos") {
            filtersActive = true;
            $debug = 4;
        }
        
        if (filtersActive == false) {
            $scope.FiltersMsg = false;
        } else {
            $scope.FiltersMsg = true;
        }
        
        console.log($scope.FiltersMsg)
        console.log($debug)
        
    }
    
    //Filter function 
    var filterTable = function(row){
        var rawData = row.obj;
        var isFound = true;
        if($scope.searchTerm) {
            _.some(row.states[$scope.findState($rootScope.family, row.states)].fields,
             function(field){
                 if(field.name == "['numeroOrigen']" || field.name == "['descripcionTipoEvento']"  || field.name == "['nombreProducto']")
                 {
                   var fieldValue = $filter('getter')(rawData, field).toUpperCase();
                   isFound = _.includes(fieldValue, $scope.searchTerm.toUpperCase());
                    
                 }
                 
                 else
                    isFound = false;
                    
                return isFound;
            });
        }
        
        if(isFound && $scope.filterAditonalOptionProduct && $scope.filterAditonalOptionProduct != 'Todos los productos') {
            
            $scope.showPageSumatoryUnits=true;
            
            if($scope.filterAditonalOptionProduct)
                isFound = rawData.Product.toUpperCase() == $scope.filterAditonalOptionProduct.toUpperCase();
        }
        else{
            $scope.showPageSumatoryUnits=false;
        }
        
        if(isFound && $scope.searchAditionalFilter && $scope.searchAditionalFilter != 'Todos los consumos') {
            if($scope.searchAditionalFilter)
                isFound = rawData.descripcionTipoEvento.toUpperCase() == $scope.searchAditionalFilter.toUpperCase();
        }
        
        if(isFound && $scope.searchAditionalFilterOption && $scope.searchAditionalFilterOption != 'Con y sin cargo') {
            console.log('parseFloat(rawData.Cost)',parseFloat(rawData.Cost));
            if($scope.searchAditionalFilterOption == 'Sin cargo')
                isFound = parseFloat(rawData.importeTasado.replace(',','.')) >= 0;
                
            if($scope.searchAditionalFilterOption == 'Con cargo')
                isFound = parseFloat(rawData.importeTasado.replace(',','.')) < 0; 
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
        $scope.sortingOrder =  newSortingOrder.name;
        //'obj'+newSortingOrder.name;
        $scope.collapseAll();
        console.log(newSortingOrder)
    };
    
    //watch for change in number of items inside a page
    $scope.$watch('itemsPerPage', function(length) {
        $scope.search();
    });
    

    $scope.getCardList = function(){
        
        //https://vlocity.atlassian.net/browse/PFTA-7021
        $scope.pageSumatoryUnitsData=0;
        $scope.pageSumatoryUnitsVoice='00:00:00';
        $scope.pageSumatoryUnitsSms=0;
        
        $scope.pageSumatoryCostData=0;
        $scope.pageSumatoryCostVoice=0;
        $scope.pageSumatoryCostSms=0;
             
       
        //https://vlocity.atlassian.net/browse/PFTA-7019
        $scope.pageSumatory=0;
        for (var j = 0; j < $scope.filteredItems.length; j++) {
             try{   
                
                 
                 
                
                //patch (se ajusta el formato de fecha)
                var tipo=($scope.filteredItems[j].obj).descripcionTipoEvento;
                
                
                if(($scope.filteredItems[j].obj).subTipoServicio=='VOZ_ONNET' || ($scope.filteredItems[j].obj).subTipoServicio=='SMS_ONNET')    
                    $scope.filteredItems[j].obj.operador='Personal';
                else{
                    $scope.filteredItems[j].obj.operador='Otro';
                }
                
                //console.log($scope.filteredItems[j].obj.operador);
           
                if(tipo=='Llamada de voz' || tipo=='Tarifa recurrente'){
                    
                    $scope.pageSumatoryUnitsVoice=addTimes($scope.pageSumatoryUnitsVoice, ($scope.filteredItems[j].obj).duracionTrafico);
                    var temCost=parseFloat(   (($scope.filteredItems[j].obj).importeTasado).replace(',','.')    );
                       
                    if(temCost<0){
                        $scope.pageSumatoryCostVoice=$scope.pageSumatoryCostVoice+Math.abs(temCost);
                    }
                    
                    $scope.filteredItems[j].obj.numeroOrigen=phoneMask2($scope.filteredItems[j].obj.numeroOrigen);
                    $scope.filteredItems[j].obj.unidades=$scope.filteredItems[j].obj.duracionTrafico+'';
                }
                else if(tipo=='Servicio de datos'){
                    if(parseFloat(($scope.filteredItems[j].obj).importeTasado.replace(',','.') )<0){
                        $scope.pageSumatoryCostData=$scope.pageSumatoryCostData+Math.abs(parseFloat(($scope.filteredItems[j].obj).importeTasado.replace(',','.')));
                    }
                     var units= ($scope.filteredItems[j].obj).detalleDeUnidadesLibresTasadasLista.elementoDetalleDeUnidadesLibresTasada.codUnidadDeMedida;
                     var cant=parseFloat(($scope.filteredItems[j].obj).saldoBalance);
                     
                     if(units.toLowerCase()=='mb'){
                         cant=cant*1024;
                     }
                     
                     if(cant>0){
                        $scope.pageSumatoryUnitsData=$scope.pageSumatoryUnitsData+cant;
                    }
                    
                    $scope.filteredItems[j].obj.numeroOrigen=phoneMask2($scope.filteredItems[j].obj.numeroOrigen);
                    $scope.filteredItems[j].obj['duracionTrafico'] = cant+' Kb';
                     
                }
                else if(tipo=='SMS' || tipo=='MMS'){
                    //var tSms=(($scope.filteredItems[j].obj).saldoBalance);
                    //if(parseFloat((($scope.filteredItems[j].obj).saldoBalance))>0){
                        //$scope.pageSumatoryUnitsSms=$scope.pageSumatoryUnitsSms+parseFloat((($scope.filteredItems[j].obj).saldoBalance));
                        $scope.pageSumatoryUnitsSms=$scope.pageSumatoryUnitsSms+1;
                    //}
                    
                    //  var temp003=parseFloat(($scope.filteredItems[j].obj).importeTasado);
                    if(parseFloat(($scope.filteredItems[j].obj).importeTasado.replace(',','.'))<0){
                        $scope.pageSumatoryCostSms=$scope.pageSumatoryCostSms+Math.abs(parseFloat(($scope.filteredItems[j].obj).importeTasado.replace(',','.')));
                    }
                
                    if(($scope.filteredItems[j].obj).subTipoServicio!='SMS_PREMIUM'  )    
                        $scope.filteredItems[j].obj.numeroOrigen=phoneMask2($scope.filteredItems[j].obj.numeroOrigen);
                    
                    $scope.filteredItems[j].obj.duracionTrafico=1+'';
                }
                else{/*otros*/
                    if(parseFloat(($scope.filteredItems[j].obj).importeTasado.replace(',','.'))<0){
                        $scope.pageSumatory=$scope.pageSumatory+Math.abs(parseFloat(($scope.filteredItems[j].obj).importeTasado.replace(',','.')));
                    }
                    
                    $scope.filteredItems[j].obj.numeroOrigen=phoneMask2($scope.filteredItems[j].obj.numeroOrigen);
                    $scope.filteredItems[j].obj.duracionTrafico=1+'';
                }
            }
            catch(e){}
        }
        
        if(parseFloat($scope.pageSumatory)==0) $scope.pageSumatory = "-";
        else{
            $scope.pageSumatory=parseFloat($scope.pageSumatory).toFixed(2);
        }
        
        if(parseFloat($scope.pageSumatoryCostSms)==0) $scope.pageSumatoryCostSms = "-";
        else{
            $scope.pageSumatoryCostSms=parseFloat($scope.pageSumatoryCostSms).toFixed(2);
        }
        
        if(parseFloat($scope.pageSumatoryCostData)==0) $scope.pageSumatoryCostData = "-";
        else{
            $scope.pageSumatoryCostData=parseFloat($scope.pageSumatoryCostData).toFixed(2);
        }
        
        if(parseFloat($scope.pageSumatoryCostVoice)==0) $scope.pageSumatoryCostVoice = "-";
        else{
            $scope.pageSumatoryCostVoice=parseFloat($scope.pageSumatoryCostVoice).toFixed(2);
        }
        
        
        if(parseFloat($scope.pageSumatoryUnitsData)>1023){
             $scope.pageSumatoryUnitsData=Math.floor($scope.pageSumatoryUnitsData / 1024);
        }
        else{
            $scope.pageSumatoryUnitsData=0;
        }
        
        
        return $scope.pagedItems[$scope.currentPage];
    }
    
    $scope.filterAditonalOption = 'Todos los consumos';
    
    $scope.changeAditionalFilter = function(category){
        
        $scope.searchAditionalFilter = category;
        $scope.filterAditonalOption = category;
        
        //https://vlocity.atlassian.net/browse/PFTA-7384
        if(category=='SMS' || category=='MMS'){
            $scope.pageProductList = $scope.pageProductListOriginal.filter(function(el) {
                return (el.nombreProducto !== "Internet x 1 dia" && el.nombreProducto !== "Pack Internet x 30 dias") ;
            });
        }
        else if(category=='Servicio de datos'){
            $scope.pageProductList = $scope.pageProductListOriginal.filter(function(el) {
                return (el.nombreProducto !== "Plan con Tarjeta" && el.nombreProducto !== "Numero Gratis" && el.nombreProducto !== "Promoción Personal") ;
            });
        }
        else if(category=='Llamada de voz'){
             $scope.pageProductList = $scope.pageProductListOriginal.filter(function(el) {
                 return (el.nombreProducto !== "Internet x 1 dia" && el.nombreProducto !== "Pack Internet x 30 dias") ;
            });
        }
        else {
            $scope.pageProductList=$scope.pageProductListOriginal;
        }
        
        
        $scope.search();
    }
    
    $scope.filterTypeFilterOption = 'Con y sin cargo';
    
    $scope.changeAditionalFilterOption = function(category) {
    $scope.searchAditionalFilterOption = category;
    $scope.filterTypeFilterOption = category;
    $scope.search();

    }
    
    $scope.filterAditonalOptionProduct = 'Todos los productos';
    $scope.showPageSumatoryUnits=false;
    
    $scope.changeAditionalFilterProduct = function(category){
    $scope.filterAditonalOptionProduct = category;
    //if(category!='Todos los productos')
    //    $scope.showPageSumatoryUnits=true;
    //else
    //    $scope.showPageSumatoryUnits=false;
    
    //console.log('$scope.showPageSumatoryUnits',$scope.showPageSumatoryUnits);    
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
    
    //window.scope = $scope;
    
    
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
    
        
    $scope.getIndexForPage = function(index){
        var newIndex = 0;
        newIndex = index - ($scope.itemsPerPage * ($scope.currentPage));
       return newIndex;
    }
    
    
    
    function addTimes(start, end) {
        try{
            var a = start.split(":");
            var seconds = (+a[0]) * 60 * 60 + (+a[1]) * 60 + (+a[2]); 
            var b = end.split(":");
            var seconds2 = (+b[0]) * 60 * 60 + (+b[1]) * 60 + (+b[2]); 
            
            var date = new Date(1970,0,1);
             date.setSeconds(seconds + seconds2);
            
            var c = date.toTimeString().replace(/.*(\d{2}:\d{2}:\d{2}).*/, "$1");
        return(c);
        }
        catch(e){
            return null;
        }
         

    }
    
    // PFTA-5261
    document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
    
    /*window.scope = $scope;
    window.root = $rootScope;
    window.paren = $scope.$parent
    */
    
}]);


vlocity.cardframework.registerModule.filter('importePolarity', function () {
  return function (item) {
      
      if (item.charAt(0) == "-") {
          return '- $' + item.substring(1);
      } else {
          return '$' + item;
      }
  };
});

 /* PFTA-6865 Actualizado */
 vlocity.cardframework.registerModule.filter('phoneMask', function () {
  return function (maskee) {
      var phoneNumber = maskee.toString()
      if(phoneNumber.length >=4 ){
        var part1 = phoneNumber.substring(0,phoneNumber.length -3);
        var part2 = phoneNumber.substring(phoneNumber.length -3, phoneNumber.length );
        if(part1.length >= 4){
            var part1_1 = part1.substring(0,part1.length -3);
            return part1_1 +'XXX'+ part2;
        }
        else{
            return 'XXX'+part2;
        }
     } else {
           return phoneNumber;    
       }
  };
});