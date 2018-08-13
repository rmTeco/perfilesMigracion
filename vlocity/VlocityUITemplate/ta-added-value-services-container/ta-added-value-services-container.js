vlocity
	.cardframework
	.registerModule
	.controller('containerTableSVAController', containerTableSVACtrl);

	containerTableSVACtrl.$inject = ['$rootScope', '$scope', '$filter'];

function containerTableSVACtrl($rootScope, $scope, $filter) {

	var SVACtrl = this;		

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
	
	// Search Function
	$scope.TAsearchFunc = function(cardObj, passedSearchToken) {
		// Wrapping in array since the 'filter' $filter expects an array
		return function(card) {
			var searchedObj = [card.obj];			
			var searchToken = passedSearchToken || $scope.searchTerm;
	
			if (searchToken) {
				var matches = $filter('filter')(searchedObj, {Name: searchToken});
					
				return matches.length > 0;
			} else {
				return true;
			}
		};
	};
}