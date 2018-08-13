vlocity.cardframework.registerModule.controller('AutomaticDebitSubscription', ['$scope', function($scope){ 

          var bac = this;
          bac.invalidAccount = invalidAccount;
          
          bac.isSelected = true;
          $scope.bpTree.response.lastInvalidAccounts = "";
          $scope.bpTree.response.InvalidAccounts = [];
          $scope.validar = false;
          $scope.bpTree.response.isInvalidFraud = false;
		  $scope.bpTree.response.isInvalidDunning = false;
		  $scope.bpTree.response.isInvalidDebtFinancing = false;
		  $scope.bpTree.response.isInvalidPurchaseFinancing = false;
          
          function invalidAccount(account) {
        
              
              if (searchObjList(account.Id) && account.isSelected === false) {
					deleteAccountSelect(account.Id);
					$scope.bpTree.response.isInvalidFraud = false;					   
					$scope.bpTree.response.isInvalidDunning = false;
					$scope.bpTree.response.isInvalidDebtFinancing = false;
					$scope.bpTree.response.isInvalidPurchaseFinancing = false;                       
			  }
			  else if(!searchObjList(account.Id) && account.isSelected === true){
				if (account.Fraud || account.Dunning || account.DebtFinancing || account.PurchaseFinancing) {
					$scope.bpTree.response.InvalidAccounts.push({Id:account.Id,Name:account.Name});		
					$scope.bpTree.response.lastInvalidAccounts = account.Name;					
				}
					if (account.Fraud === true) {						                       
                        $scope.bpTree.response.isInvalidFraud = true;
					} if (account.Dunning === true) {						
                        $scope.bpTree.response.isInvalidDunning = true;                       
					} if (account.DebtFinancing === true) {					
                        $scope.bpTree.response.isInvalidDebtFinancing = true;
					} if (account.PurchaseFinancing === true) {						
                        $scope.bpTree.response.isInvalidPurchaseFinancing = true;
					}
                }
          }
          
          function deleteAccountSelect(id_account) {

                    var index = -1;
                    //var ln = $scope.bpTree.response.InvalidAccounts.length;
                    for (var i = 0, len = $scope.bpTree.response.InvalidAccounts.length; i < len; i++) {
                        if ($scope.bpTree.response.InvalidAccounts[i].Id === id_account) {
                            index = i;
                            break;
                        }
                    }
                    $scope.bpTree.response.InvalidAccounts.splice(index, 1);
                    if($scope.bpTree.response.InvalidAccounts.length > 0){
                        //$scope.validar = (ln)-1;
                        $scope.bpTree.response.lastInvalidAccounts = $scope.bpTree.response.InvalidAccounts[($scope.bpTree.response.InvalidAccounts.length)-1].Name;  
                    }
                
          }
          
          function searchObjList(id_account) {
                    var validate = false;
                    if ($scope.bpTree.response.InvalidAccounts.length > 0) {
                        $scope.bpTree.response.InvalidAccounts.forEach(function (entry) {
                            if (entry.Id == id_account) {
                                validate = true;
                            }
                        });
                    }
                    return validate;
                }
            
      }]);