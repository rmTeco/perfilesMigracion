vlocity
    .cardframework
    .registerModule
    .controller('CPQIframeController', CPQIframeController);
        
    CPQIframeController.$inject = ['$scope', '$rootScope', '$sce', '$window'];
    
    function CPQIframeController($scope, $rootScope, $sce, $window) {
        var cpqic = this;
        
        cpqic.init = init;
        
        function init() {
            var urlIframe='https://cs63.salesforce.com/apex/taSalesCPQ?id=';
            urlIframe += $scope.bpTree.response.IdOrder;
            
            cpqic.iframeSRC = $sce.trustAsResourceUrl(urlIframe);
            
        }
        
        
    }