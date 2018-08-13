vlocity
    .cardframework
    .registerModule
    .controller('DoneActionCustomController', DoneActionCustomController);
    
    DoneActionCustomController.$inject = ['$scope'];
    
    function DoneActionCustomController($scope) {
        var dacc = this;
        
        dacc.openGestionDeClientesInPrimaryTab = openGestionDeClientesInPrimaryTab;
        
        function openGestionDeClientesInPrimaryTab(accountId) {
            console.info('accountId: ', accountId);
            var url = '/' + accountId;
            sforce.console.openPrimaryTab(null, url, true,'');
        }
    }