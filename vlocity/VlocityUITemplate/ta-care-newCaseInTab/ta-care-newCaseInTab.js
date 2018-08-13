vlocity
	.cardframework
	.registerModule
	.controller('NewCaseTabCtrl', NewCaseTabCtrl);

NewCaseTabCtrl.$inject = ['$scope'];

function NewCaseTabCtrl($scope) {
    var ctrl = this;
    
    ctrl.init = init;
    ctrl.caseNumber;
    ctrl.caseId;
    ctrl.openTab = openTab;

    function init() {
		
		ctrl.caseNumber = $scope.bpTree.response.CaseNumberFound.CaseNumber;
        ctrl.caseId = $scope.bpTree.response.CaseNumberFound.Id;
        console.info("ctrl.caseNumber = ",ctrl.caseNumber);
        console.info("ctrl.caseId = ",ctrl.caseId);
    }
    
    function openTab() {
        sforce.console.getEnclosingPrimaryTabId(openSubTab);
    }
    
    function openSubTab(result) {
        console.log("openSubTab");
        var primaryTabId = result.id;
        sforce.console.openSubtab(primaryTabId, ctrl.caseId, true);
    }
}