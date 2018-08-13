vlocity
    .cardframework
    .registerModule
    .controller('FAndFController', FAndFController);
  
    FAndFController.$inject = ['$scope'];
    function testt(){
        console.info("hola");
        console.dir(numerosAmigos);
    }
    function FAndFController($scope){
        var fafc = this;
        /* ng-disabled='control.ro' eze's code */
        fafc.disabled = false; 
        fafc.operation = $scope.bpTree.response.readOnlyMode;
        fafc.chargeData = false;
        fafc.validateTelecomNumber = validateTelecomNumber;
        fafc.showError = false;
        console.info("Operation-> : ", fafc.operation);
        
        if(fafc.operation === true){
            fafc.disabled = true;   
        }
        
        $scope.$watch('bpTree.response.numerosAmigosXPlan', function (newVal, oldVal) {
            
            if(newVal !== undefined){
                var keepGoing = true;
                $scope.bpTree.response.numerosAmigosModified = false;
                angular.forEach($scope.bpTree.response.numerosAmigosXPlan, function(value, key) {
                    if(keepGoing) {
                        for(var m=0; m < value.numerosAmigoSms.length; m++){
                            if(value.numerosAmigoSms[m].modified && value.numerosAmigoSms[m].validated){
                                $scope.bpTree.response.numerosAmigosModified = true;
                                keepGoing = false;
                                break; 
                            }
                        }
                    }
                    if(keepGoing) {
                        for(var l=0; l < value.numerosAmigoVoz.length; l++){
                            if(value.numerosAmigoVoz[l].modified && value.numerosAmigoVoz[l].validated){
                                $scope.bpTree.response.numerosAmigosModified = true;
                                keepGoing = false;
                                break; 
                            }
                        }
                    }
                    
                });
            }
        
        }, true);
        
        $scope.$watch('bpTree.response.numerosAmigosXPlanBK', function (newVal, oldVal) {
            console.info("chargeData: ", fafc.chargeData);
            if(newVal !== undefined && fafc.chargeData === false ){
                angular.forEach($scope.bpTree.response.numerosAmigosXPlanBK, function(value, key) {
                    for(var i=0; i < value.numerosAmigoSms.length; i++){
                        if(typeof $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoSms[i].originalLine === 'undefined'){
                            $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoSms[i].originalLine = value.numerosAmigoSms[i].lineNumber;
                            $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoSms[i].BKLine = value.numerosAmigoSms[i].lineNumber;
                            $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoSms[i].modified = false;
                        }
                    }
                    
                    for(var j=0; j < value.numerosAmigoVoz.length; j++){
                        if(typeof $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoVoz[j].originalLine === 'undefined'){
                            $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoVoz[j].originalLine = value.numerosAmigoVoz[j].lineNumber;
                            $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoVoz[j].BKLine = value.numerosAmigoVoz[j].lineNumber;
                            $scope.bpTree.response.numerosAmigosXPlan[key].numerosAmigoVoz[j].modified = false;
                        }
                    }
                });
                fafc.chargeData = true; 
            }
        
        }, true);
        
        function checkChangeLines(lineNumber, index, parent, operation){

            var checkBoolean = false;
            if($scope.bpTree.response.numerosAmigosXPlanBK){
                
                angular.forEach($scope.bpTree.response.numerosAmigosXPlanBK, function(value, key) {
    
                    if(key === parent){
                        
                        if(operation == 'SMS'){
                            for(var i=0; i < value.numerosAmigoSms.length; i++){
                                /*Agregar más validaciones aca  para lineas duplicadas*/
                                if(lineNumber === value.numerosAmigoSms[i].lineNumber && lineNumber !== "" ){
                                    checkBoolean = true;
                                }
                                
                                if(lineNumber === value.numerosAmigoSms[i].lineNumber  && lineNumber !== ""){
                                    $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].originalLine = value.numerosAmigoSms[i].lineNumber;
                                }
                                
                                if($scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].originalLine !== lineNumber){
                                    $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].modified = true; 
                                } else {
                                    $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].modified = false;  
                                }
                            }
                        }
                        
                        
                        if(operation == 'VOZ'){
                            for(var j=0; j < value.numerosAmigoVoz.length; j++){
                                /*Agregar más validaciones aca  para lineas duplicadas*/
                                if(lineNumber === value.numerosAmigoVoz[j].lineNumber && lineNumber !== "" ){
                                    checkBoolean = true;
                                }
    
                                if(lineNumber === value.numerosAmigoVoz[j].lineNumber && lineNumber !== ""){
                                    $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].originalLine = value.numerosAmigoVoz[j].lineNumber;
                                }
    
                                if($scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].originalLine !== lineNumber){
                                    $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].modified = true; 
                                } else {
                                    $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].modified = false;  
                                }
                            }
                        }
                    
                        angular.forEach($scope.bpTree.response.numerosAmigosXPlan, function(valueBK, keyBK) {
    
                            if(keyBK === parent){
                                for(var m=0; m < valueBK.numerosAmigoSms.length; m++){
                                    
                                    if(valueBK.numerosAmigoSms[index].originalLine && valueBK.numerosAmigoSms[m].lineNumber == valueBK.numerosAmigoSms[index].originalLine && m!==index && valueBK.numerosAmigoSms[m].lineNumber !== $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].lineNumber){
                                        $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].originalLine = $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].BKLine;
                                    }
                                    
                                    if(valueBK.numerosAmigoSms[index].originalLine && valueBK.numerosAmigoSms[m].originalLine && valueBK.numerosAmigoSms[m].originalLine == valueBK.numerosAmigoSms[index].originalLine && m!==index){
                                        $scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoSms[m].originalLine = $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoSms[index].BKLine;
                                    }
                                    
                                    if( $scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoSms[m].originalLine === $scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoSms[m].lineNumber && m!=index){
                                        $scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoSms[m].modified = false;
                                    }
                                    
                                }
                                
                                for(var l=0; l < valueBK.numerosAmigoVoz.length; l++){
                                    
                                    if(valueBK.numerosAmigoVoz[index].originalLine && valueBK.numerosAmigoVoz[l].lineNumber == valueBK.numerosAmigoVoz[index].originalLine && l!==index && valueBK.numerosAmigoVoz[l].lineNumber !== $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].lineNumber){
                                        $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].originalLine = $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].BKLine;
                                    }
                                    
                                    if(valueBK.numerosAmigoVoz[l].originalLine && valueBK.numerosAmigoVoz[index].originalLine && valueBK.numerosAmigoVoz[l].originalLine == valueBK.numerosAmigoVoz[index].originalLine && l!==index){
                                        $scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoVoz[l].originalLine = $scope.bpTree.response.numerosAmigosXPlan[parent].numerosAmigoVoz[index].BKLine;
                                    }
                                    
                                    if($scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoVoz[l].originalLine === $scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoVoz[l].lineNumber && l!==index){
                                        $scope.bpTree.response.numerosAmigosXPlan[keyBK].numerosAmigoVoz[l].modified = false; 
                                    }
                                }
                                
                            }
                            
                        });
                    }
                    
                });
                
            }
            
            return checkBoolean;
        }
        
        
        function validateTelecomNumber(lineNumber, spinnerName, showErrorMsg, numeroAmigoVozValidated, index, parent, operation) {
            fafc[spinnerName] = true;
            fafc[showErrorMsg] = false;
            
            /*if(TypeOf(lineNumber)=="string") {
                var lineNumberAsString = Integer.parseInt(lineNumber) ; 
                        }*/
            
            
            
            
            if(lineNumber && lineNumber !== "" && lineNumber.length >= 10){
                Visualforce.remoting.Manager.invokeAction('taOrderController.ValidateTelecomNumber',lineNumber, 
                    function(result, event) { 
                   // var result = true;
                   console.info("result: ", result);
                        fafc[spinnerName] = false;
                        checkChangeLines(lineNumber, index, parent, operation);
                        numeroAmigoVozValidated.validated = result;
                        fafc[showErrorMsg] = !result;
                        $scope.$apply();
                    }, 
                    {escape: false, buffer: false}
                );              
            } else if(lineNumber === ""){
                
                checkChangeLines(lineNumber, index, parent, operation);
                fafc[spinnerName] = false;
                
            }
        }
    }