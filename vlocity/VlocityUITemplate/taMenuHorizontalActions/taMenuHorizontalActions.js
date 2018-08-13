vlocity
    .cardframework
    .registerModule
    .controller('MenuHorizontalActionsController', MenuHorizontalActionsController);
    
    MenuHorizontalActionsController.$inject = ['$scope'];
    
    function MenuHorizontalActionsController ($scope) {
        var mhac = this;
        
        mhac.openGestionDeClientesInPrimaryTab = openGestionDeClientesInPrimaryTab;
        
        function openGestionDeClientesInPrimaryTab() {
            sforce.console.openPrimaryTab(null, '/apex/taClientSearch', true, 'Gestión de clientes');
            // sforce.console.openPrimaryTab(id:String, url:URL, active:Boolean,(optional)tabLabel:String, (optional)callback:Function, (optional)name)
        }
        
    }