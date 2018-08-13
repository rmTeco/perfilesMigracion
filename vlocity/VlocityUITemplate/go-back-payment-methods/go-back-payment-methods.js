vlocity.cardframework.registerModule.controller('GoBackController', ['$scope', '$filter', function ($scope, $filter) {

	var vm = this;
	var bpTree = $scope.bpTree;
	
// 	vm.click = click();
	
    activate();

	function activate() {
// 		var order = bpTree.response.BillingOrder;

// 		if (order.Items) {
// 			vm.items = angular.isArray(order.Items) ? order.Items : [order.Items];
// 		}
// 		if (bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta)
// 			vm.taxes = bpTree.response.S013_Response.IPResult.calculoImpuestosRespuesta.infoResCalculoImpuestos;
		
// 		vm.payments = bpTree.response.GetPaymentAdjustments_Response.data;
// 		for(var i = 0; i < vm.payments.length; i++){
// 		    if(vm.payments[i].Financial_Promotion__r.Percentage__c > 0){
// 		        vm.financiado.push(vm.payments[i]);
// 		    }
// 		}
		
// 		calculateTotals();
	}

	vm.prevClick = function (control){
	   // console.info('param', param);
	   //Visualforce.remoting.Manager.invokeAction(
    //         "taOrderController.CancelOrderForRetryPaymentMethods", $scope.bpTree.response,
    //                 function(result) {
    //                     console.info('installmentDPF: ', result.options);
    //                     mpmc.installmentDPF = result.options;
    //                 },
    //         {escape: false} // No escaping, please
    //     );
        // var className = 'taOrderController';
        // var methodName = 'RollbackOrderForRetryPaymentMethods';
        var optionsMap = {
            orderId: bpTree.response.IdOrder //'8016C0000008c26'
        };
        
        Visualforce.remoting.Manager.invokeAction(
                "taOrderController.RollbackForRetryPaymentMethods", optionsMap,
                        function(result) {
                            console.info('Response: ', result);
                            // $scope.reset($scope.bpTree.response);
                            // $scope.sidebarNav(($scope.bpTree.children | filter:{name: control.propSetMap.elementValueMap.target})[0]);
                            // if(mpmc.paymentMethodList[index].installmentSelected !== "" && mpmc.paymentMethodList[index].installmentSelected !== undefined){
                            //     console.info(mpmc.paymentMethodList[index].installmentSelected.value);
                            //     if( mpmc.paymentMethodList.length == 1 ){
                            //         validateLimitCredit(index);
                            //     } else if(mpmc.paymentMethodList.length > 1 && mpmc.paymentMethodList[index].amountSelected !== "" && mpmc.paymentMethodList[index].amountSelected > 0){
                            //         validateLimitCredit(index);
                            //     }
                            // } else {
                            //     resetTotalFromAmountCft(index);
                            // }

                            // mpmc.paymentMethodList[index].installmentByCardBank = result.options;
                            // $scope.$apply();
                        },
                {escape: false} // No escaping, please
            );
        // return dataService.doGenericInvoke(className, methodName, null, angular.toJson(optionsMap))
        //         .then(function(result) {
        //             console.log('RESPUESTA RollbackOrderForRetryPaymentMethods', result);
        //             // if(result.LinesError){
        //             //     ctrl.errorMessage = result.LinesError;
        //             //     return;
        //             // }
                    
        //             // $scope.performAction(action, checkoutActionConfig);
        // });
	}
	
}]);