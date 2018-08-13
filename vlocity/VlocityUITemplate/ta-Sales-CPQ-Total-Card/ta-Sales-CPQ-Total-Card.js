vlocity
.cardframework
.registerModule
.controller('SalesCPQTotalCardController', SalesCPQTotalCardController);

SalesCPQTotalCardController.$inject = ['$rootScope','$scope', 'dataService', '$window'];
function SalesCPQTotalCardController($rootScope, $scope, dataService) {
    var ctrl = this;
	ctrl.onClickSalesConfiguration = onClickSalesConfiguration;
	
	function onClickSalesConfiguration(action, checkoutActionConfig) {
         ctrl.errorMessage = null;
        /*
         var className = 'LinesManager';
         var methodName = 'ValidateLinesQtty';
         var optionsMap = {
             IdOrder: $scope.params.id
         };
         return dataService.doGenericInvoke(className, methodName, null, angular.toJson(optionsMap)).then(function(result) {
             if(result.LinesError){
                 ctrl.errorMessage = result.LinesError;
                 return;
             }
            setFlowURLAndPerformAction(action, checkoutActionConfig, $scope.params.operationCode);
         });
         */
         setFlowURLAndPerformAction(action, checkoutActionConfig, $scope.params.operationCode);
    }
	
	
	//function onClickSalesConfiguration(action, checkoutActionConfig) {
    //    setFlowURLAndPerformAction(action, checkoutActionConfig, $scope.params.operationCode);
   // }
	
	
	// Setting the URL for an specific Flow based on the operationCode
	function setFlowURLAndPerformAction(action, checkoutActionConfig, operationCode) {
		var url = '/apex/taSalesGlobalFlow?IdOrder=' + $scope.params.id + '&';
		
		//Set URL depending on operationCode
		switch (operationCode) {
			case 'VTLNCL':
				// New Line, New Client
				url += 'osType=Sales&osSubType=NewLineNewAccountSale';
				break;
			case 'VTLNCE':
				// New Line, Existing Client
				url += 'osType=Sales&osSubType=ExistingAccountNewLineSale';
				break;
			case 'VTLNCB':
				// New Line, Existing Client, New Billing Account
				url += 'osType=Sales&osSubType=NewLineNewBillingAccountSale';
				break;
			case 'VTPACK':
				// New Pack, Existing Asset
				url += 'osType=Sales&osSubType=NewPackExistingLine';
				break;
			case 'CAMBIOPLAN':
				// Plan Change Identity Validation
				url = '/apex/%vlocity_namespace%__OmniScriptUniversalPage?id=' + $scope.params.id + '&layout=lightning#/OmniScriptType/Sales/OmniScriptSubType/MACDValidationIdentitySubmit/OmniScriptLang/English/ContextId/' + $scope.params.id + '/PrefillDataRaptorBundle//true';
				break;
			case 'MACDServices':
    			//MACD Services
    			url = '/apex/%vlocity_namespace%__OmniScriptUniversalPage?id=' + $scope.params.id + '&layout=lightning#/OmniScriptType/Sales/OmniScriptSubType/MACDSubmit/OmniScriptLang/English/ContextId/' + $scope.params.id  +'/PrefillDataRaptorBundle//true';
    			break;
    		case 'CEG':
    			// Cambio en garantia
				url += 'osType=Sales&osSubType=ChangeTerminalInWarranty';
    			break;
		}

		if (operationCode != 'CAMBIOPLAN' && operationCode != 'MACDServices') {
			// Adding parameters to the new URL
			url += '&contactId=' + $scope.params.contactId + '&accountId=' + $scope.params.accountId;
			
			// Adding Billing Account ID
			if ($scope.params.billingAccountId) {
				url += '&billingAccountId=' + $scope.params.billingAccountId;
			}

			if ($scope.params.assetId) {
				url += '&assetId=' + $scope.params.assetId;
			}
		}
        
        // Changing action's url
        action.%vlocity_namespace%__URL__c = url;
		
		// Executing VlocityAction function with the new URL
		$scope.performAction(action, checkoutActionConfig);
		
	}
}