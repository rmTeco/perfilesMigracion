vlocity
	.cardframework
	.registerModule
	.controller('containerTableSubscriptionsController', containerTableSubscriptionsCtrl);

	containerTableSubscriptionsCtrl.$inject = ['$rootScope', '$scope', '$filter'];

function containerTableSubscriptionsCtrl($rootScope, $scope, $filter) {

	var CTSCtrl = this;
    

	CTSCtrl.addSubscription = addSubscription;
	CTSCtrl.checkAll = false;
	CTSCtrl.toggleAll = toggleAll;
	CTSCtrl.historyBlackList = false ;
	


	if (typeof $rootScope.subscriptionsSelected == 'undefined')
		$rootScope.subscriptionsSelected = [];

	CTSCtrl.subscriptions = $rootScope.subscriptionsSelected;

	var indexOfCodServicio;

	$rootScope.$watch('subscriptionsSelected', function(newVal, oldVal) {
		CTSCtrl.subscriptions = newVal;
		$rootScope.vlocity.subscriptions = angular.toJson(newVal).replace (/"/g,"");
		console.info("$rootScope.vlocity.subscriptions: ", $rootScope.vlocity.subscriptions);
	}, true);

	$scope.toogleOpenSVA = function(event) {
		var $row = $(event.target).closest('tr');
		var $groupRow = $row.next();

		event.preventDefault();

		$row.toggleClass('activeRow');
		if ($row.hasClass('activeRow')) {
			$groupRow.addClass('activeGroup');
		} else {
			$groupRow.removeClass('activeGroup');
		}
		return;
	}

	//Decides the sorting order
	$scope.sortingOrder = '';
	//Determines sorting should be ascending or descending
	$scope.reverse = false;

	// change sorting order
	$scope.sortBy = function(newSortingOrder) {
		$scope.reverse = !$scope.reverse;
		$scope.sortingOrder = 'obj'+newSortingOrder.name;
	};
	
	$scope.viewHistoryBlackList = function(valor) {
	    
	    CTSCtrl.historyBlackList = valor;
	    buttonHIstory.buttonHIstory
	   
	};



 	function addSubscription(codServicio, checkValue, checkAll) {

		if(!checkAll) {
			if(angular.element(".addedValueServices input:checked").length === angular.element(".addedValueServices input").length) {				
				angular.element('#checkAll')[0].checked = true;
			} else {
				angular.element('#checkAll')[0].checked = false;
				CTSCtrl.checkAll = false;
			}			
		}

		if (checkValue) {
			$rootScope.subscriptionsSelected.push(codServicio);
			$rootScope.subscriptionsSelected = $rootScope.subscriptionsSelected.filter(function(value, index, self) {
				// console.info(value, index, 'Stays:', self.indexOf(value) === index);
				return self.indexOf(value) === index;
			});
		} else
			$rootScope.subscriptionsSelected = $rootScope.subscriptionsSelected.filter(function(value) {
				// console.info(value, 'Stays:', value !== codServicio);
				return value !== codServicio;
			});
		console.info("$rootScope.subscriptionsSelected: ", $rootScope.subscriptionsSelected);
	}

	function toggleAll(cards, checkValue) {
	    
  		for (var i=0; i < cards.length; i++) {
			if(cards[i].cardName != "SubscriptionsListActions") {
				if(checkValue) {
					cards[i].vlcSelected = true;
					addSubscription(cards[i].obj.DatosServicioSuscrip.codServicio, true, true);
					// console.info("cards: ", cards[i].vlcSelected, " - ", cards[i].obj.CanalAlta.codCanal);
				} else {
					cards[i].vlcSelected = false;
					addSubscription(cards[i].obj.DatosServicioSuscrip.codServicio, false, true);
				}
			}
		}
	}
	

}