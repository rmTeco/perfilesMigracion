vlocity
	.cardframework
	.registerModule
	.controller('TASelectableListController', TASelectableListCtrl);

	TASelectableListCtrl.$inject = ['$scope'];

function TASelectableListCtrl($scope) {

	var SLCtrl = this;	
	Console.log('executed');
	SLCtrl.list = 
		angular.isArray($scope.control.vlcSI[$scope.control.itemsKey][0][$scope.control.propSetMap.selectableItemConfig.inputList]) ?
		$scope.control.vlcSI[$scope.control.itemsKey][0][$scope.control.propSetMap.selectableItemConfig.inputList] :
		[$scope.control.vlcSI[$scope.control.itemsKey][0][$scope.control.propSetMap.selectableItemConfig.inputList]];
}