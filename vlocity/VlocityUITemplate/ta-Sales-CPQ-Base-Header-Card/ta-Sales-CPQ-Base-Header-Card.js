vlocity
    .cardframework
    .registerModule
    .controller('HeaderCPQController', HeaderCPQController);
    
    HeaderCPQController.$inject = ['$scope', '$rootScope', '$sce', '$window']
    function HeaderCPQController($scope, $rootScope, $sce, $window) {
        var hcpqc = this;
		
		$rootScope.iframeSrc = '';
		
		hcpqc.init = init;
        $rootScope.iframeOSUrl = iframeOSUrl;

		function init() {
		    
		    $rootScope.deliveryMethod = $scope.$parent.$parent.$parent.$parent.records[0].Delivery_Method__c;
		    $rootScope.OriginatingChannel = $scope.$parent.$parent.$parent.$parent.records[0].%vlocity_namespace%__OriginatingChannel__c;
		    
			$rootScope.showModal = false;
			
			$window.addEventListener('message', function(event) {
                if (event.isTrusted === true) {
                    if (event.data && event.data['OmniScript-Messaging'] && event.data['OmniScript-Messaging'].reloadOS === true) {
                        console.info('reloadOS: ', event.data['OmniScript-Messaging'].reloadOS);
                        
                        $window.location.reload();
                    } 
                } 
                // console.info(event);
            });
		}
		
		// params type Obj
		function iframeOSUrl (url, params) {
			console.info('url: ', url);
			var paramsStr = '';
			for (var key in params) {
				if (params.hasOwnProperty(key)) {
					console.info(key + " -> " + params[key]);
					paramsStr += '&' + key + '=' + params[key];
				}
			}
			
			$rootScope.iframeSrc = $sce.trustAsResourceUrl(url + paramsStr);
		}
    }