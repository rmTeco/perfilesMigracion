vlocity.cardframework.registerModule
    .controller('NegotiationsController',
                ['$scope', '$timeout', '$interval', '$filter','$rootScope',
                    function($scope, $timeout, $interval, $filter, $rootScope){   
    
    $scope.appendFlag = false;
    //Decides the sorting order
    $scope.sortingOrder = '';
    $scope.sortOrder='';
    //Determines sorting should be ascending or descending
    $scope.reverse = false;
    //List holds the filtered items
    $scope.filteredItems = [];
    //Items after dividing for different pages
    $scope.pagedItems = [];
    //Determines item per page
    $scope.itemsPerPage = 10;
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
    $scope.minDateValueFrom = moment().add(-6, 'months');
    
    $scope.isOpenRangoDesde = false;
    $scope.isOpenRangoHasta = false;
    
    $scope.filterOptionRangoDesde = moment().add(-1, 'month');
    $scope.filterOptionRangoHasta = moment();
    
    $scope.isOpenCanal = false;
    
    $scope.exploded = [];


    $scope.showMessageError = function(msg){
        $scope.errorMessage = msg;
        $scope.errorFound = true;
    };
    
    $scope.hideMessageError = function(){
        $scope.errorMessage = null;
        $scope.errorFound = false;
    };
    
    $scope.showGrid = true;
    
    //Setea la diferencia de dias minimo.
    $scope.setMinMaxDate = function(){
        $scope.minDateValueTo = $scope.filterOptionRangoDesde;
        
        var today = moment();//.format('DD/MM/YYYY');
        var limitDay = moment($scope.filterOptionRangoDesde).add(90, 'days');//.format('DD/MM/YYYY');
        
        if( moment(today).isBefore(limitDay) ) {
            $scope.maxDateValueTo = today;
        } else {
            //$scope.maxDateValueTo = moment($scope.filterOptionRangoDesde).add(90, 'days').format('DD/MM/YYYY');
            console.log($scope.filterOptionRangoDesde);
            desde =  moment($scope.filterOptionRangoDesde);
            console.log(desde)
            limite = desde.add(90, 'days');
            console.log(limite)
            hasta = limite.format('DD/MM/YYYY')
            console.log(hasta)
            $scope.maxDateValueTo = limite;
            //$scope.$digest();
        }
            
        //$scope.maxDateValueTo = today;
        $scope.minDateValueTo =  $scope.filterOptionRangoDesde;
        
        $scope.filterOptionRangoHasta = '';
    }
    
    $scope.validarFecha = function(startDate, endDate) {
   
      startDate = new Date(startDate);
      endDate = new Date(endDate);
      currentDate = new Date();
    
      $scope.hideMessageError();
    
      if(isNaN(startDate) && isNaN(endDate)) {
          $scope.showMessageError("Ingresá una rango de fechas.");
          return false;
      }
      
      if(isNaN(startDate)) {
          $scope.showMessageError("Ingresá una fecha de inicio.");
          return false;
      }
      
      if(isNaN(endDate)) {
          $scope.showMessageError("Ingresá una fecha de fin.");
          return false;
      }
      
      if(startDate > endDate)
      {
          $scope.showMessageError("La fecha de inicio debe ser anterior a la de fin. Modificá la fecha de inicio.");
          return false;
      }
      
      if(endDate > currentDate)
      {
          $scope.showMessageError("Sólo podés ver consumos pasados. Modificá la fecha de fin.");
          return false;
      }
      
      if(!$scope.diffOfMonth(startDate, endDate)) {
          $scope.showMessageError("La fecha de inicio del reporte no puede superar los 6 meses. Modificá la fecha de inicio.");
          return false;
      }
      
      if(!$scope.diffOfDays(startDate, endDate)) {
          $scope.showMessageError("El rango máximo del reporte es de 90 días. Modificá alguna de las dos fechas.");
          return false;
      }

      return true;
      
    }

    $scope.diffOfMonth = function (startDate, endDate) {
        var compStartDate = moment(startDate);
        var compEndDate = moment(endDate);
       
        if(Math.abs(compEndDate.diff(compStartDate, 'months')) > 13) {
            return false;
        }
        return true;
    }
    
    $scope.diffOfDays = function (startDate, endDate) {
        var compStartDate = moment(startDate);
        var compEndDate = moment(endDate);
     
        if(Math.abs(compEndDate.diff(compStartDate, 'days')) > 91) {
            return false;
        }
        return true;
    }
    
    

    $scope.processResults = function() {
        $scope.exploded = [];
        $scope.showGrid = false;
        // console.info('processingResults')
        // console.info($scope.records)
        
          for (i = 0; i < $scope.records.length; ++i) {
                    
                    // for each balance type of items ($)
                    if (typeof $scope.records[i].listaAjusteBalanceInfo != "undefined") {
                        if ($scope.records[i].listaAjusteBalanceInfo.length > 0) {
                             for (a = 0; a < $scope.records[i].listaAjusteBalanceInfo.length; ++a) {
                                subitem = {};
                                subitem.motivoAjuste = $scope.records[i].motivoAjuste;
                                subitem.fechaAjuste = moment($scope.records[i].fechaAjuste).format("DD/MM/YYYY - HH:mm:ss");
                                
                                subitem.expire = moment($scope.records[i].listaAjusteBalanceInfo[a].fechaExpiracionBalance).format("DD/MM/YYYY - HH:mm:ss");
                                subitem.codUnidadDeMedida = '';
                                
                                
                                if ($scope.records[i].listaAjusteBalanceInfo[a].montoAjuste > 0) {
                                    subitem.amount = $scope.records[i].listaAjusteBalanceInfo[a].montoAjuste;
                                } else {
                                    subitem.amount = Math.abs($scope.records[i].listaAjusteBalanceInfo[a].montoAjuste);
                                }
                                
                                if ($scope.records[i].listaAjusteBalanceInfo[a].tipoAjuste == "DEBITO") {
                                    subitem.polarity = "negativeAdjustment";
                                    subitem.tipobalance = '-$';
                                } else {
                                    subitem.polarity = "positiveAdjustment";
                                    subitem.tipobalance = '$';
                                }
                                
                                $scope.exploded.push(subitem);
                             }
                        }
                    }
                    
                    // for each unit subitem (SMS, MB, minutes)
                    if (typeof $scope.records[i].listaInfoAjusteUnidadesLibres != "undefined") {
                        if ($scope.records[i].listaInfoAjusteUnidadesLibres.length > 0) {
                             for (b = 0; b < $scope.records[i].listaInfoAjusteUnidadesLibres.length; ++b) {
                                subitem = {};
                                subitem.motivoAjuste = $scope.records[i].motivoAjuste;
                                subitem.fechaAjuste = moment($scope.records[i].fechaAjuste).format("DD/MM/YYYY - HH:mm:ss");
                                subitem.amount = $scope.records[i].listaInfoAjusteUnidadesLibres[b].montoAjuste;
                                subitem.expire = moment($scope.records[i].listaInfoAjusteUnidadesLibres[b].fechaAjusteVigenciaHasta).format("DD/MM/YYYY - HH:mm:ss");
                                subitem.codUnidadDeMedida = $scope.records[i].listaInfoAjusteUnidadesLibres[b].codUnidadDeMedida;
                                
                                if ($scope.records[i].listaInfoAjusteUnidadesLibres[b].tipoAjuste == "DEBITO") {
                                    subitem.polarity = "negativeAdjustment";
                                    subitem.tipobalance = '- ';
                                } else {
                                    subitem.polarity = "positiveAdjustment";
                                    subitem.tipobalance = '';
                                }
                                
                                $scope.exploded.push(subitem);
                             }
                             
                        }
                    }
                    
                }
    
        
        console.info('processed Results');
        console.info($scope.exploded);
        $scope.showGrid = true;
    }
    
    $scope.waitResults = function() {
        console.log('waiting')
        if (typeof $scope.records === "object") {
            $scope.processResults();
            $scope.reloadLayout2();
            clearInterval($scope.interval)
        }
    }

    $scope.filtersAccepted = function() {
       if( $scope.validarFecha($scope.filterOptionRangoDesde, $scope.filterOptionRangoHasta) ) {
            $scope.originalRecords = $scope.cards;
            $scope.filteredAdjustments = [];
            $scope.hideMessageError();
            $scope.exploded = [];
            $scope.showGrid = true;
            var startDate = $('#text-input-id-1').val();
			var endDate = $('#text-input-id-2').val();
			if (startDate && endDate) {
				var startDate2 = formatDate(startDate);
				var endDate2 = formatDate(endDate);
				var objDate;
				for (var i = 0, len = $scope.originalRecords.length; i < len; i++) {
					objDate = $scope.originalRecords[i].obj.fechaAjuste;
					objDate = $scope.makeDate(objDate);
					if ((+startDate2 <= +objDate) && (+endDate2 >= +objDate)) {
						$scope.filteredAdjustments.push($scope.originalRecords[i]); 
					}
				}
				console.log($scope.filteredAdjustments);
				
			}
			else {
			    for (var j=0; j<$scope.originalRecords.length;j++){
			        $scope.filteredAdjustments.push($scope.originalRecords[i]);
			    }
			}
			$scope.groupToPages($scope.filteredAdjustments);
			$scope.range();
			/*
            var eventPayload = {};
            eventPayload.event = 'updateDatasource';
            $scope.updateDatasource({
                "body": {
                  "cuenta": {
                    "codigoAcceso": {
                      "codSuscripcion": $scope.params.LineNumber //'20140527145411'//$scope.params.LineNumber
                    }
                  },
                  "infoDetalle": {},
                  "cantidadItemsConsulta": 99999,
                  "referenciaItemPaginado": 0,
                  "cantidadMaxConsulta": 99999,
                  "fechaDesde": $scope.filterOptionRangoDesde,
                  "fechaHasta": $scope.filterOptionRangoHasta
                }
            }, true, true, true)

                
                $scope.interval = window.setInterval(  $scope.waitResults() )
                
                if($scope.appendFlag === true) $scope.appendFlag = false;
             */  
                
            
        }
    } 
	
	function formatDate(date) {
		date = date.split('/');
		var year = date[2];
		var month = date[1];
		var day = date[0];
		var retDate = new Date(year,month-1,day);
		return retDate;
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
    /* 
    @@@ Since dates are stored in string format and cannot order by date,
    @@@ this method creates a date from string
    @@@ PFTA- 5975
    */
    $scope.makeDate=function (str) {
    	var day   = parseInt(str.substring(0,2));
		var month  = parseInt(str.substring(3,5));
		var year   = parseInt(str.substring(6,10));
		var hh   = parseInt(str.substring(13,15));
		var mm  = parseInt(str.substring(16,18));
		var ss   = parseInt(str.substring(19,21));
		var date1 = new Date(year, month-1, day, hh, mm, ss);
		return date1;
    }
    /* 
    @@@ Method created to give format to the fields
    @@@ PFTA- 5975
    */
    $scope.processData=function(sortOrder,records){
		if(sortOrder === 'obj.expire2'){
		    for(var i = 0; i<records.length; i++){
        		    records[i].obj.expire2=$scope.makeDate(records[i].obj.expire);
        	}
        }
        if(sortOrder === 'obj.fechaAjuste2'){
            for (var j=0; j<records.length;j++){
                records[j].obj.fechaAjuste2=$scope.makeDate(records[j].obj.fechaAjuste);
            }
        }
		if(sortOrder === 'obj.amount2'){
			for (var x=0; x<records.length;x++){
				if(records[x].obj.polarity === 'negativeAdjustment'){
					records[x].obj.amount2= records[x].obj.amount - (records[x].obj.amount *2);
				}
				else{
					records[x].obj.amount2= records[x].obj.amount;
				}
			}
		}
	}
	
    // change sorting order
    $scope.sortBy = function(newSortingOrder) {
        newSortingOrder.name = newSortingOrder.name.replace(/[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi, '');
        /* 
        @@@ Switch created to order by the new field created in $scope.processData
        */
        switch (newSortingOrder.name) {
			case 'expire':
				$scope.sortOrder='obj.expire2';
				break;
			case 'fechaAjuste':
				$scope.sortOrder='obj.fechaAjuste2';
				break;
			case 'amount':
				$scope.sortOrder='obj.amount2';
				break;
			default:
				$scope.sortOrder='obj.'+newSortingOrder.name;
				break;
        }
        $scope.reverse =  !$scope.reverse;
        $scope.sortingOrder = newSortingOrder.name;
        $scope.processData($scope.sortOrder,$scope.pagedItems[0]);
        $scope.pagedItems[0] = $filter('orderBy')($scope.pagedItems[0], $scope.sortOrder, $scope.reverse);

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
        
        // window.sforce = sforce;
        // window.scope = $scope;
            
        $scope.appendFlag = true;
        //$scope.filtersAccepted();
        $scope.processResults();
        //$scope.sortBy('Fecha');
           
            
    }
}]);