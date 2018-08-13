vlocity
    .cardframework
    .registerModule
    .controller('OpenPrimaryTabController', OpenPrimaryTabController);
    
    OpenPrimaryTabController.$inject = ['$scope', '$window'];
    
    function OpenPrimaryTabController ($scope, $window) {
        var optc = this;
        
            optc.init = init;
        
        function init() {
            openPrimaryTab();
        }
        
        function openPrimaryTab() {
            $.getScript('/support/console/41.0/integration.js', function(){
                sforce.console.openPrimaryTab(null, '/' + $scope.bpTree.response.BusinessAccount.Id, true);
                // sforce.console.getFocusedPrimaryTabObjectId(function(response){
                //     sforce.console.closeTab(response.id);    
                // });
                
            });
        }
        
    }