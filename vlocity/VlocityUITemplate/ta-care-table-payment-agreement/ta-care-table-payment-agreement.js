vlocity.cardframework.registerModule.controller('tableCtrlAgreement',
['$rootScope', '$scope', '$filter',function($rootScope, $scope, $filter) {
    
    
    $scope.montoFinanciar = 1000;
    this.cuotasList = [];
    this.labels=[{label:'Cuota'},{label:'Vencimiento'},{label:'Estado'},{label:'Importe'}];
    
    $scope.cuotas=[];
    
    console.log('-->>> al inicio ');
    console.info('-->>>al inicio $scope.control',$scope.control);
    
   
    
    
    this.init = function(){
        //console.info('en el init');
        jQuery('#Step-PaymentAgreement_nextBtn').hide();
        
    }
    
    //al final no se usa
    function LastDayOfMonth(Year, Month) {
        return new Date( (new Date(Year, Month,1))-1 );
    }
    
    function addDays(date, days) {
      var result = new Date(date);
      result.setDate(result.getDate() + days);
      return result;
    }

    function addBusinessDays  (startingDate, daysToAdjust) {
        var newDate = new Date(startingDate.valueOf()),
        businessDaysLeft,
        isWeekend,
        direction;

        //trabajamos con el dia completo solamente
        if (daysToAdjust !== parseInt(daysToAdjust, 10)) {
            throw new TypeError('addBusinessDays can only adjust by whole days');
        }
    
        if (daysToAdjust === 0) {
            return startingDate;
        }
        direction = daysToAdjust > 0 ? 1 : -1;
    
        //agregamos el dia siempre y cuando no se sabado o domingo
        businessDaysLeft = Math.abs(daysToAdjust);
        while (businessDaysLeft) {
            newDate.setDate(newDate.getDate() + direction);
            isWeekend = newDate.getDay() in {0: 'Sunday', 6: 'Saturday'};
            if (!isWeekend) {
                businessDaysLeft--;
            }
        }
        return newDate;
    }

    this.preview = function(){
        this.cuotasList = [];
        this.cuotasListForBpTree = [];
        
        $scope.montoFinanciar=parseFloat(jQuery('#idMontoVencido').html());
        
        //console.info('------>>>>>>>>>>>>>>> ',jQuery('#idMontoVencido').html());
        //console.info('-->>>>contor0', $scope.control);
        //console.info('-->>>>contor1', $scope.control.SelectableItems2);
        //console.info('-->>>$scope.control.propSetMap',$scope.control.propSetMap);
        //console.info('-->>>$scope.control',$scope.control);
    
        
        /*POR ALGUNA RAZON EL SCOPE NO VE LAS VARIABLES--->>> REVISAR!!!*/
        var anticipo=jQuery('#Anticipo').val();
        var cuotas=jQuery("#Cuotas" ).val();
        var tipoCuota=jQuery('#Periodo').val();
       
        
        //montoFinanciar es la variable que tiene el valor a financiar
        //primero obtengo el mes actual y el anio actual
        var m=(new Date()).getMonth()+1;
        var y=(new Date()).getFullYear();
        var dd=(new Date()).getDate();
        var montoDeuda=0;
        
        if($scope.montoFinanciar>0 && $scope.montoFinanciar>anticipo && tipoCuota!='' && cuotas!=''){
            montoDeuda=$scope.montoFinanciar-anticipo;
            //calculo el monto de cada cuota
            var cuota=(montoDeuda/cuotas).toFixed(2);
            
            
            
            
            /*1ra cuota, 5 dias habiles luego del dia actual*/
            var dayOne= addBusinessDays(new Date(),5);
            var dayOneDay=dayOne.getDate()<10?'0'+dayOne.getDate():dayOne.getDate();
            var dayOneMonth=(dayOne.getMonth()+1)<10?'0'+(dayOne.getMonth()+1):(dayOne.getMonth()+1);
            
            
            //03-01-2018, nuevo ajuste, la primera cuota es el anticipo
            this.cuotasList.push({numeroCuota:1, estado:'Pendiente', importe:anticipo, vencimiento:dayOneDay+'/'+dayOneMonth+'/'+dayOne.getFullYear()});
            cuotas++;
            
            
            
            this.cuotasListForBpTree.push({montoCuotaConvenioCta:anticipo+'00', fechaVtoCuotaConvenioCta:dayOne.getFullYear()+'-'+dayOneMonth+'-'+dayOneDay+' 00:00:00', codMoneda:'ARS', comentario:''});
            
            
            console.info('-->> numero de cuotas',cuotas);
            
            if(tipoCuota=='MONTHLY'){
                //se suman 30 dias, ya que existe el caso de que siendo 30 de un mes, el mes siguiente no tenga ese dia (ejemplo: febrero)
                for(var i=1;i<cuotas;i++){
                    dayOne=addDays(dayOne,30);
                    dayOneDay=dayOne.getDate()<10?'0'+dayOne.getDate():dayOne.getDate();
                    dayOneMonth=(dayOne.getMonth()+1)<10?'0'+(dayOne.getMonth()+1):(dayOne.getMonth()+1);
                    
                    this.cuotasList.push({numeroCuota:i+1, estado:'Pendiente', importe:cuota, vencimiento:dayOneDay+'/'+dayOneMonth+'/'+dayOne.getFullYear()});
                    
                    this.cuotasListForBpTree.push({montoCuotaConvenioCta:cuota+'00', fechaVtoCuotaConvenioCta:dayOne.getFullYear()+'-'+dayOneMonth+'-'+dayOneDay+' 00:00:00', codMoneda:'ARS', comentario:''});
                }
            }
            else if(tipoCuota=='BIWEEKLY'){
                for(var j=1;j<cuotas;j++){
                    dayOne=addDays(dayOne,15);
                    dayOneDay=dayOne.getDate()<10?'0'+dayOne.getDate():dayOne.getDate();
                    dayOneMonth=(dayOne.getMonth()+1)<10?'0'+(dayOne.getMonth()+1):(dayOne.getMonth()+1);
                    
                    this.cuotasList.push({numeroCuota:j+1, estado:'Pendiente', importe:cuota, vencimiento:dayOneDay+'/'+dayOneMonth+'/'+dayOne.getFullYear()});
                    
                    this.cuotasListForBpTree.push({montoCuotaConvenioCta:cuota+'00', fechaVtoCuotaConvenioCta:dayOne.getFullYear()+'-'+dayOneMonth+'-'+dayOneDay+' 00:00:00', codMoneda:'ARS', comentario:''});
                }
            }
            
            jQuery('#Step-PaymentAgreement_nextBtn').show();
        }
        else{
            alert('No se puede realizar el calculo');
            jQuery('#Step-PaymentAgreement_nextBtn').hide();
        }
        
        
        //console.info('1an final tengo-->>>',$scope);
        //console.info('1an final $rootScope-->>>',$rootScope);
        //console.log('2an final tengo-->>>',$rootScope);
        //console.info('3al final', $scope.control);
        
        
        $scope.cuotas=this.cuotasList;
        
        
        console.info('-->> this.cuotasListForBpTree',this.cuotasListForBpTree);
        //$scope.control.bpTree.response={};
        if ($scope.bpTree) {
            $scope.bpTree.response.listaDetallePA=this.cuotasListForBpTree;    
        }
        
        //$scope.control.bpTree.agreements.push( this.cuotasList);
       
        
        
        
        
        
        //PRUEBA DE CONCEPTO DE DATATABLE.JS
        /*jQuery('#example').DataTable( {
            responsive: true
        });*/
        
    }
    
    
}]);