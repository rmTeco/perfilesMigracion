vlocity.cardframework.registerModule
    .controller('CustomerHistoryCtrl',
                ['$scope', '$timeout', '$interval', '$rootScope',
                    function($scope, $timeout, $interval, $filter, $rootScope){   
    
    $scope.appendFlag = false;
    //Decides the sorting order
    $scope.sortingOrder = '';
    //Determines sorting should be ascending or descending
    $scope.reverse = false;
    //List holds the filtered items ProcessTransaction
    $scope.selectProcessTransaction = null;
    //List holds the filtered items TypeTransaction
    $scope.selectTypeTransaction = null;
        //List holds the filtered items MotiveTransaction
    $scope.selectMotiveTransaction = null;
    
    
    
    
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

    

    $scope.processResults = function() {
        $scope.exploded = [];
        $scope.showGrid = false;
         console.log('processingResults');
          console.log('processingResults:'+$scope.records.length);
        
          for (i = 0; i < $scope.records.length; ++i) {
                    
                     
                  
                    // for each balance type of items ($)
                    if ( $scope.records[i].serviceTransaction === 'Plan Prepago Nacional') {
                       console.log('processingResults_2:'+$scope.records[i].serviceTransaction);
                            
                                subitem = {};
                                subitem.serviceTransaction = $scope.records[i].serviceTransaction;
                                subitem.lineNumberClient = $scope.records[i].lineNumberClient;
                                subitem.typeTransaction = $scope.records[i].typeTransaction;
                                subitem.motiveTransaction = $scope.records[i].motiveTransaction;
                                subitem.assetId = $scope.records[i].assetId;
                                subitem.assetName = $scope.records[i].assetName;
                                subitem.processTransaction = $scope.records[i].processTransaction;
                                subitem.accountId = $scope.records[i].accountId;
                                subitem.dateTransaction = moment($scope.records[i].dateTransaction).format("DD/MM/YYYY - HH:mm:ss");
                                

                                $scope.exploded.push(subitem);
                          
                            
                       
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
            clearInterval($scope.interval);
        }
    }

    $scope.filtersAccepted = function() {
        
        console.log('filtersAccepted-Prueba');
        
        // console.log('$scope.selectTypeTransaction:'+ $scope.selectTypeTransaction.length);
      console.log('$scope.params.Id:'+$scope.params.Id);
        console.log('$scope.params.assetId:'+$scope.params.assetId);
      
            $scope.hideMessageError();
            $scope.exploded = [];
            $scope.showGrid = true;
            
            var eventPayload = {};
            var idAccount;
            var idAsset;
            var strTypeTransaction;
            var strMotiveTransaction;
            var strProcessTrasaction;
            console.log('motivo:'+$scope.selectMotiveTransaction);
            
            if ( $scope.params.Id === undefined){
                idAccount = 'S1NNUM3R0';
             }else{
                 idAccount =  $scope.params.Id;
             }
             
             if ($scope.params.assetId === undefined) {
                 idAsset = 'S1NNUM3R0';
             }else{
                 idAsset = $scope.params.assetId;
             }
            
             if ($scope.selectProcessTransaction === null || $scope.selectProcessTransaction === undefined || $scope.selectProcessTransaction === ''){
                strProcessTrasaction = 'Todos';
            }else{
                strProcessTrasaction = $scope.selectProcessTransaction;
                
            }
            
            
            if ($scope.selectTypeTransaction === null || $scope.selectTypeTransaction === undefined || $scope.selectTypeTransaction === ''){
                strTypeTransaction = 'Todos';
            }else{
                strTypeTransaction = $scope.selectTypeTransaction;
                
            }
            
            if ($scope.selectMotiveTransaction === null || $scope.selectMotiveTransaction === undefined || $scope.selectMotiveTransaction === ''){
                strMotiveTransaction = 'Todos';
            }else{
                strMotiveTransaction = $scope.selectMotiveTransaction;
                
            }
            console.log('motivo:'+strMotiveTransaction);
            
            eventPayload.event = 'updateDatasource';
           
            $scope.updateDatasource({
                "accountId":idAccount,
                "assetId":idAsset,
                "processTransaction": strProcessTrasaction,
                "typeTransaction": strTypeTransaction,
                "motiveTransaction":strMotiveTransaction

            }, true, true, true)
            
            
                
                $scope.interval = window.setInterval(  $scope.waitResults() )
                
                if($scope.appendFlag === true) $scope.appendFlag = false;
    } 



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
        
        $scope.appendFlag = true;
        $scope.filtersAccepted();

            
            
    }
}]);