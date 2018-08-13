vlocity
	.cardframework
	.registerModule
	.controller('tableListController', tableListCtrl);

	tableListCtrl.$inject = ['$scope'];

function tableListCtrl($scope) {

	var TLCtrl = this;

	if($scope.bpTree.response) {
		$scope.$watch('bpTree.response[control.propSetMap.selectableItemConfig.inputList]', function(newValue, oldValue, scope) {			
			TLCtrl.inputList = angular.isArray(newValue) ? newValue : [newValue];	
		});
	}

	$scope.openConsoleSubTab = function(id) {
        var toBeLaunchedUrl = '/' + id;

        if (typeof sforce !== 'undefined') {
            if (sforce.console.isInConsole()) {
                openSubtab = function openSubtab(result) {
                    sforce.console.openSubtab(result.id, toBeLaunchedUrl, true, '', null, openSuccess, id);
                };
                openSuccess = function openSuccess(result) {
                    //sforce.console.focusSubtabById(result.id);
                    console.log(JSON.stringify(result));
                };
                sforce.console.getEnclosingPrimaryTabId(openSubtab);
            } else {
                if(typeof sforce.one === 'object') {
                    sforce.one.navigateToURL(toBeLaunchedUrl, false);
                } else {
                    location.assign(toBeLaunchedUrl);
                }

            }
        } else {
            location.assign(toBeLaunchedUrl);
        }
    };
}