/*
 * 
 */ 
+function() {
    vlocity
        .cardframework
        .registerModule
        .controller('leftProductItemController', leftProductItemController);

    leftProductItemController.$inject = ['$scope', '$rootScope', '$filter'];
    function leftProductItemController($scope, $rootScope, $filter) {
        // Public Fields
        var lpic = this;
        lpic.showStock = true;
        lpic.showErrorTimeout = false;
        
        // Public Methods
        lpic.init = init;
        lpic.checkCredit = checkCredit;
        lpic.closeModal = closeModal;
        lpic.titleModal = "";
        lpic.bodyModal = "";
        
        // Method Definitions
        function init() {
            
            console.info('leftProductItemController');
            console.info('obj: ', $scope.obj);

        }
        
        function checkCredit(obj){
            
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
            
        }
        
        function closeModal(){
            lpic.showErrorTimeout = false; 
        }

    }
}();