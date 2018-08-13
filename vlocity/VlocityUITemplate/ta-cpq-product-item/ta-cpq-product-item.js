/*
 * 
 */ 
+function() {
    vlocity
        .cardframework
        .registerModule
        .controller('leftProductItemController', leftProductItemController);

    leftProductItemController.$inject = ['$scope', '$rootScope', 'dataService','$filter'];
    function leftProductItemController($scope, $rootScope, dataService,$filter) {
        // Public Fields
        var lpic = this;
        lpic.showStock = true;
        lpic.showErrorTimeout = false;
        
        // Public Methods
        lpic.init = init;
        lpic.validateAdd = validateAdd;
        lpic.closeModal = closeModal;
        lpic.titleModal = "";
        lpic.bodyModal = "";
        
        // Method Definitions
        function init() {

        }
        
        function validateAdd(obj){
            
            var className = 'taSalesCartContainerController';
             var methodName = 'AddToCartValidations';
             console.info("validateAdd");
             console.info(obj.Product2Id);
             console.info(obj.Product2.%vlocity_namespace%__Type__c);
             var optionsMap = {
                 IdOrder: $scope.params.id,
                 ItemToAddProductId: obj.Product2Id,
                 ItemToAddProductType: obj.Product2.%vlocity_namespace%__Type__c
             };
             return dataService.doGenericInvoke(className, methodName, null, angular.toJson(optionsMap)).then(function(result) {
                 if(result.ErrorMessage){
                     lpic.titleModal = result.ErrorMessageTitle;
                    lpic.bodyModal = result.ErrorMessage;
                    lpic.showErrorTimeout = true;
                     return;
                 }
                 
                 if($rootScope.dunning_c == true && parseFloat(obj.%vlocity_namespace%__RecurringPrice__c.value) > 0){
                
                lpic.titleModal = "Cliente posee mora";
                lpic.bodyModal = "No se puede puede agregar este item al carrito, el cliente posee mora.";
                lpic.showErrorTimeout = true;
                
            } else if (parseFloat(obj.%vlocity_namespace%__RecurringPrice__c.value) > parseFloat($rootScope.limiteDeCredito)){
                
                lpic.titleModal = "Límite de crédito excedido";
                lpic.bodyModal = "No se puede puede agregar más items al carrito, se excedió el límite de crédito.";
                lpic.showErrorTimeout = true;
                
            } else {
                
                lpic.showErrorTimeout = false;
                
                if(angular.isNumber(obj.%vlocity_namespace%__RecurringPrice__c.value)){
                    $rootScope.limiteDeCredito = parseFloat($rootScope.limiteDeCredito)-parseFloat(obj.%vlocity_namespace%__RecurringPrice__c.value);
                } else {
                    console.info("THE ITEM HAS A INVALID RECURRING PRICE");
                }
                    
                $scope.importedScope.addToCart(obj);
            }
            
             });
        }
        
        function closeModal(){
            lpic.showErrorTimeout = false; 
        }

    }
}();