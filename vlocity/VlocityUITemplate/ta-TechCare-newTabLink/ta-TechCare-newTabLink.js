vlocity
	.cardframework
	.registerModule
	.controller('MCModuleCtrl', MCModuleCtrl);

MCModuleCtrl.$inject = ['$scope'];

function MCModuleCtrl($scope) {
    var mcm = this;
    var caseId;

    mcm.openTab = openTab;
    mcm.init = init;
	mcm.caseNumber;

    function init() {
		mcm.caseNumber = $scope.bpTree.response.Case.CaseNumber;
        caseId = $scope.bpTree.response.Case.Id;
    }

    function openTab() {
        sforce.console.getEnclosingPrimaryTabId(openSubTab);
    }

    function openSubTab(result) {
        var primaryTabId = result.id;
        sforce.console.openSubtab(primaryTabId, caseId, true);
    }
}