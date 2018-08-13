vlocity.cardframework.registerModule
    .controller('actionRedirectController',
                 ["$scope","$rootScope","$window","$location", function( $scope,$rootScope,$window,$location){
        this.performAction =  function (action, params,itemId,customTaskExecUrl) {
          if (params) {
            var nsPrefix = $rootScope.nsPrefix;
            var url;
            if(customTaskExecUrl) {
                url = customTaskExecUrl;
                console.log('customTaskExecUrl', customTaskExecUrl);
                url=url.toString().replace("{0}",itemId);
            } else {
                url = action[nsPrefix + 'Url__c'] || action[nsPrefix + 'URL__c'] || action.url;
                action[nsPrefix + 'UrlParameters__c'] = itemId;

                url=url.toString().replace("{0}",itemId);
                action[nsPrefix + 'URL__c']=url;
            }
            console.log('Card action', action);
            var isInConsole = (window.sforce && sforce.one)
            if(isInConsole){
              action[nsPrefix + 'OpenUrlMode__c']="Current window";
            }
            $scope.performAction({
            type: 'Custom',
            isCustomAction: true,
            url: url,
            openUrlIn: action[nsPrefix + 'OpenUrlMode__c']
            });
              
          }
    }
}]);