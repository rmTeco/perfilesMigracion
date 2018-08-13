vlocity.cardframework.registerModule
    .controller('consumptionDetailsController',
                ['$scope', 'interactionTracking', '$timeout', '$interval', '$filter','$rootScope',
                    function($scope, interactionTracking, $timeout, $interval, $filter, $rootScope) {
                        
 
    // window.scope = $scope;
    // window.root = $rootScope;
    
    this.errorMessage = null;
    this.errorFound = false;
    
    this.isServiceOpen = false;
    this.isOpen = false;
    this.isOpenFactura = false;
    this.isOpenRangoDesde = false;
    this.isOpenRangoHasta = false;

    //this.filterOption = 'Los últimos 15 días';
    this.filterOptionFactura = 'Enero';
    this.filterOptionRangoDesde = '';
    this.filterOptionRangoHasta = '';
    
    this.filtroAdicionalFactura = true;
    this.filtroAdicionalRangoDesde = true;
    this.filtroAdicionalRangoHasta = true;

    //$scope.filterServiceOption = '';
    $scope.serviceFamily = "none";
    this.showGrid = true;
    $scope.$parent.$parent.$parent.$parent.showGrid  = this.showGrid;
   
    this.maxDateValueFrom = new Date();
    //this.maxDateValueTo = new Date();
    //this.minDateValue = -Infinity;
    
    
    $scope.hideSideBar = function(category){
        
        if(sforce.console !== undefined && sforce.console.isInConsole()){
            sforce.console.setSidebarVisible(false,null,sforce.console.Region.RIGHT);
        }
        
    }
    
    $scope.showSideBar = function(category){
        if(sforce.console !== undefined && sforce.console.isInConsole()){
            sforce.console.setSidebarVisible(true,null,sforce.console.Region.RIGHT);
        }
    }
    
    $scope.periodo = function(e) {
        console.log(e);
    }
    
    
    $scope.showInfoDetCon = false;
    
    $rootScope.hideAdvFilters = true;
    this.toogleAdvFilters = function() {
        if ($rootScope.hideAdvFilters == true) {
            $rootScope.hideAdvFilters = false;
        }
        
        if ($rootScope.hideAdvFilters == false) {
            $rootScope.hideAdvFilters = true;
        }
    }
    
    
    /*$scope.$watch('ptc.filterOptionRangoDesde', function(startDate){
        this.filterOptionRangoHasta = '';
        if(isNaN(startDate))
            $rootScope.maxDateValueTo = new Date();
        else
        {    
            var d = new Date(startDate)
            d.setSeconds(14*86400);
            toDay = new Date();
            if(d > toDay)
                $rootScope.maxDateValueTo = new Date();
            else
                $rootScope.maxDateValueTo = d;
            
            $rootScope.minDateValueTo = startDate;
        }
        
        this.filterOptionRangoHasta = '';
        document.getElementById('text-input-id-2').value = '';
    });
    */

    
    this.changeFilterService = function(Name, LineNumber, Family) {
        this.filterServiceOption = Name + ' - ' + LineNumber;
        this.serviceFamily = Family;
        this.isServiceOpen = false;
        $rootScope.InitialAssetLine = LineNumber;
        $rootScope.InitialAssetName = Name;
    }
    
    
    this.changeFilter = function(category) {
        
        this.filtroAdicionalFactura = true;
        this.filtroAdicionalRangoDesde = true;
        this.filtroAdicionalRangoHasta = true;
        
        if(category == 'Una factura')
        {
            this.filtroAdicionalFactura = false;
            //clear filters
            this.filterOptionRangoDesde = null;
            this.filterOptionRangoHasta = null;
        }
        else
        {
            if(category == 'Un rango personalizado')
            {
                this.filtroAdicionalRangoDesde = false;
                this.filtroAdicionalRangoHasta = false;
                //clear filters
                this.filterOptionFactura = null;
            }
            else
            {
                this.filtroAdicionalFactura = true;
                this.filtroAdicionalRango = true;
                this.filtroAdicionalRangoHasta = true;
                //clear filters
                this.filterOptionFactura = null;
                this.filterOptionRangoDesde = null;
                this.filterOptionRangoHasta = null;
                
            }
        }
        
        this.categoryModel = category;
        this.filterOption = category;
        this.isOpen = false;
    }
    
     this.changeFilterFactura = function(category) {
        this.categoryModel = category;
        this.filterOptionFactura = category;
        this.isOpenFactura = false;
    }
    
    $rootScope.validatedDates = true;
     this.validarFecha = function(startDate, endDate) {
         
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
        
        if(!diffOfMonth(startDate, endDate))
        {
            this.showMessageError("La fecha de inicio del reporte no puede superar los 13 meses. Modificá la fecha de inicio.");
            $rootScope.validatedDates = false;
            return false;
        }
        
        if(!diffOfDays(startDate, endDate))
        {
            this.showMessageError("El rango máximo del reporte es de 15 días. Modificá alguna de las dos fechas.");
            $rootScope.validatedDates = false;
            return false;
        }
        
        return true;
    }
    
    $rootScope.validarRoot = this.validarFecha;
    
    
    function diffOfMonth(startDate, endDate){
        var compStartDate = moment(startDate);
        var compEndDate = moment(endDate);
       
        if(Math.abs(compEndDate.diff(compStartDate, 'months')) > 13)
        {
            return false;
        }
        return true;
    }
    
    function diffOfDays(startDate, endDate)
    {
        var compStartDate = moment(startDate);
        var compEndDate = moment(endDate);
       
        if(Math.abs(compEndDate.diff(compStartDate, 'days')) > 15)
        {
                return false;
        }
        return true;
    }
    
    function convertDate(inputFormat) {
      function pad(s) { 
          return (s < 10) ? '0' + s : s;
      }
      var d = new Date(inputFormat);
      return [pad(d.getDate()), pad(d.getMonth()+1), d.getFullYear()].join('/');
    }
    
    this.hideMessageError = function(){
        this.errorMessage = null;
        this.errorFound = false;
    }
    
    this.showMessageError = function(msg){
        this.errorMessage = msg;
        this.errorFound = true;
    }
    
    function clearFilters()
    {
        this.filterOptionRangoDesde = '';
        this.filterOptionRangoHasta = '';
        this.filterOptionFactura = '';
    }
    
    $rootScope.thisCall = 1;
    this.filtersAccepted = function(){
        
        $rootScope.newSelectedAsset = $scope.ptc.filterServiceOption;
        this.hideMessageError();
        var filterOptions = {};
        var result = false;
        
        // CustomerIntegrationId should be one per asset and it's one per account. Amelia Bernal and Raul Morales were notified abotu this needed change
        $rootScope.CustomerIntegrationId = $scope.records.Account.CustomerIntegrationId;
        filterOptions.customerIntegrationId = $scope.records.Account.CustomerIntegrationId;
        
        if ( this.validarFecha($rootScope.filterOptionRangoDesde, $rootScope.filterOptionRangoHasta) == false ) {
            return false;
        }
        
        if(this.filterOption.trim() == 'Los últimos 15 días' ||
           this.filterOption.trim() == 'Los últimos 3 días')
        {
            filterOptions.filterOptionFactura = '';
            filterOptions.filterOptionRangoDesde = '';
            filterOptions.filterOptionRangoHasta = '';
            result = true;
        }
        else
        {
            if(this.filterOption.trim() == 'Una factura')
            {
                filterOptions.filterOptionFactura = this.filterOptionFactura;
                filterOptions.filterOptionRangoDesde = '';
                filterOptions.filterOptionRangoHasta = '';
                result = true;
            }
            else
            {
                if(this.filterOption.trim() == 'Un rango personalizado')
                {
                    filterOptions.filterOptionFactura = '';
                    if( this.validarFecha($rootScope.filterOptionRangoDesde, $rootScope.filterOptionRangoHasta) )
                    {
                        filterOptions.filterOptionRangoDesde = convertDate(this.filterOptionRangoDesde);
                        filterOptions.filterOptionRangoHasta = convertDate(this.filterOptionRangoHasta);
                        result = true;
                    }
                }
            }
        }
        $rootScope.thisCall++;

        if(result)
        {
            var rst = this.filterServiceOption.split("-");
            
            filterOptions.filterServiceOption = this.filterServiceOption;
            
            filterOptions.serviceName = rst[0].trim();
            filterOptions.serviceLine = rst[1].trim();
            filterOptions.serviceFamily = this.serviceFamily;
            filterOptions.customerIntegrationId = $scope.records.Account.CustomerIntegrationId;
            filterOptions.filterOption = this.filterOption.trim();
            filterOptions.showGrid = !this.showGrid;
            /*if($scope.params.AssetId !== undefined && $scope.params.AssetId !== '{1}')
                filterOptions.appendFlag = true;
            else
                filterOptions.appendFlag = false;*/
            /*var interactionData = interactionTracking.getDefaultTrackingData($scope);
            
            var query = 'Servicio: ' + (filterOptions.filterServiceOption || '')
                    + ' - Familia del Servicio: ' + (filterOptions.serviceFamily || '')
                    + ' - Línea: ' + (filterOptions.serviceLine || '')
                    + (filterOptions.filterOptionFactura !== "" ? (' - Factura de: ' + (filterOptions.filterOptionFactura || '')) : '')
                    + ' - Nombre del Servicio: ' + (filterOptions.serviceName || '')
                    + ' - Desde qué Momento: ' + filterOptions.filterOption
                    + (this.filterOption.trim() == 'Un rango personalizado' ? (' - Rango desde: ' + (filterOptions.filterOptionRangoDesde || '') + ' - hasta: ' + (filterOptions.filterOptionRangoHasta || '')) : '');
                    
            var eventData = {
                'TrackingService': 'Acuity',
                'TrackingEvent' : 'DetalleConsumo',
                'Criteria' : query
            };
            interactionData = angular.extend(interactionData, eventData);
            interactionTracking.addInteraction(interactionData);
            */
            
            $rootScope.filterOptions = filterOptions;
            $rootScope.$broadcast('filtersAccepted', filterOptions);
            
            
            //console.log('broadcasting filterAccepted ',filterOptions);
        }
        else {
            clearFilters();
        }
    }
    
    window.records = $scope.records;
    
    console.log('LENGTH');
    console.log(Object.keys($scope.records.Account.Asset).length);
    
    if (typeof $scope.records.Account.Asset[0] == 'undefined') { 
        $scope.assetsAmmount = 1
    } else {
        $scope.assetsAmmount = Object.keys($scope.records.Account.Asset).length;
    }
    
    
    console.log($scope.assetsAmmount);
    
    if (typeof $scope.records.Account.Asset == 'undefined') {
        $scope.noassets = true;
    } else {
    
    
        if($scope.params.AssetId !== undefined && $scope.params.AssetId !== '{1}')
        {
            var validAsset = false;
            this.filterOption = 'Los últimos 3 días';
            /*
            for(var i=0; i < $scope.records.Account.Asset.length; i++)
                {
                    assets = $scope.records.Account.Asset[i];
                    if(assets.Id === $scope.params.AssetId) 
                    {
                        this.filterServiceOption = assets.Name + ' - ' + assets.LineNumber;
                        this.serviceFamily = assets.Family;
                        validAsset = true;
                    }
                }
            
            if(validAsset)
                this.filtersAccepted();
                */
        }
        else
        {
            this.filterOption = 'Los últimos 15 días';
        
        }
        
        
        this.ultimos3 = function() {
            // inicio
            $rootScope.filterOptionRangoDesde = moment().subtract(3, 'days'); //.format('DD/MM/YYYY');
            $rootScope.minDateValueFrom = moment().subtract(13, 'months');
            $rootScope.maxDateValueFrom = moment();
        
            //fin
            $rootScope.filterOptionRangoHasta = moment();//.format('DD/MM/YYYY');
            $rootScope.minDateValueTo = moment().subtract(13, 'months');
            $rootScope.maxDateValueTo = moment();   
        }
        
        this.ultimos15 = function() {
            // inicio
            $rootScope.filterOptionRangoDesde = moment().subtract(15, 'days'); //.format('DD/MM/YYYY');
            $rootScope.minDateValueFrom = moment().subtract(13, 'months');
            $rootScope.maxDateValueFrom = moment();
        
            //fin
            $rootScope.filterOptionRangoHasta = moment();//.format('DD/MM/YYYY');
            $rootScope.minDateValueTo = moment().subtract(13, 'months');
            $rootScope.maxDateValueTo = moment();   
        }
        
        this.newFilterDate = function() {
            $rootScope.dataSourceFrom = moment($rootScope.filterOptionRangoDesde).format('YYYYMMDD');
            $rootScope.dataSourceTo = moment($rootScope.filterOptionRangoHasta).format('YYYYMMDD');
            $rootScope.dataSourceFromLog = moment($rootScope.filterOptionRangoDesde).format('YYYY/MM/DD');
            $rootScope.dataSourceToLog = moment($rootScope.filterOptionRangoHasta).format('YYYY/MM/DD');
        }
        
        
        this.newStart = function() {
            //console.info('new start');
            
            var min = moment($rootScope.filterOptionRangoDesde);
            var max = moment($rootScope.filterOptionRangoDesde).add(15, 'days')
            //console.log( moment( min).isBetween( min, max) );
            
            //fin
            $rootScope.filterOptionRangoHasta = '';
            $rootScope.minDateValueTo = moment($rootScope.filterOptionRangoDesde);
            
            var nuevomax = moment($rootScope.filterOptionRangoDesde).add(15, 'days');
            
            if ( moment(nuevomax).isAfter( moment() ) ) {
                $rootScope.maxDateValueTo = moment();
            } else {
                $rootScope.maxDateValueTo = nuevomax;
            }
              
            
        }
        
        // When entering from an asset, get the asset name and do initial search
        $rootScope.InitialAssetName = '';
        $rootScope.InitialAssetLine = '';
        if (typeof $scope.params.LineNumber === "undefined") { 
            $rootScope.InitialAssetName = 'none';
            $rootScope.InitialAssetLine = 'none';
        } else {
            for(var i=0; i < $scope.records.Account.Asset.length; i++) {
                if ($scope.params.LineNumber == $scope.records.Account.Asset[i].LineNumber ){
                    $rootScope.InitialAssetName = $scope.records.Account.Asset[i].Name;
                    $rootScope.InitialAssetLine = $scope.params.LineNumber;
                }
            }
        }
        console.log('InitialAssetLine')
        console.log($rootScope.InitialAssetName)
        console.log($rootScope.InitialAssetLine)
        if ($rootScope.InitialAssetLine != '' && $rootScope.InitialAssetLine != 'none') {
            this.filterServiceOption = $rootScope.InitialAssetName +" - "+ $rootScope.InitialAssetLine;  
            this.filtersAccepted();
            //$rootScope.thisCall++;
            
        }
        
        
        // default init according PFTA-5260 and PFTA-4608
        this.ultimos3();
        this.newFilterDate();
    
    //console.log(records.Account.Asset)
    }



     window.top = $scope;
     window.rootop = $rootScope;
     window.this = this;
     //window.fil = ptc.filterOption;
}]);