vlocity.cardframework.registerModule
    .controller('CpqHomeActionController',
                 ['$scope', '$timeout', '$location', '$rootScope', 'MobileService', 'AdminConfigService', 'VLCMoment', function($scope, $timeout, $location, $rootScope, MobileService, AdminConfigService, VLCMoment) {
  
        
             this.createOrder = function(action, params) {
              if (params) {
                  var nsPrefix = $rootScope.nsPrefix;
                  var url = action[nsPrefix + 'Url__c'] || action[nsPrefix + 'URL__c'] || action.url;

                    if (url.indexOf('{cartId}') > -1) {
                        
                        if(_.isEmpty(_.get($rootScope.retailAppData, "orderId"))){
                            alert("OrderId doesn't exist, make sure turn on EnableRetailApp in mobile configuration.");
                        }
                        
                        url =  _.replace(url, new RegExp('{cartId}', 'gi'), $rootScope.retailAppData.orderId);
                        
                        
                        $timeout(function() {
                            $location.path(url);
                        });                        
                    }
          
              }
              
        };
}]);