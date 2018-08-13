vlocity
    .cardframework
    .registerModule
    .controller('initApiSettingsController', initApiSettingsController);
    
    initApiSettingsController.$inject = ['$scope', '$rootScope'];
    
    function initApiSettingsController($scope, $rootScope) {
        
        console.info('Scope initApiSettingsController: ', $scope);

        // $rootScope.vlocCPQ = vlocCPQ;
        // $rootScope.rootCatalogId = vlocCPQ.rootCatalogId;
        // $rootScope.$watch('rootCatalogId', function(newVal, oldVal){
        //     console.info('newVal: ', newVal);
        //     console.info('oldVal: ', oldVal);
        //     console.info('$rootScope.rootCatalogId: ', $rootScope.rootCatalogId);    
        // });
        
        // $rootScope.defaultCatalogId = vlocCPQ.defaultCatalogId;
        $rootScope.updatedObjArr = [];
        $rootScope.isCartItemError = {};
        $rootScope.OLISequenceMap = {};
        $rootScope.ProductSequenceMap = {};

        $rootScope.apiSettings = {
    
    		// the following settings fpr API used in Cart and the Config Panel
    		'addToCartAPIRequiresPricing': true,
    		'addToCartAPIRequiresValidation': true,
    		'cloneAPIRequiresPricing': true,
    		'cloneAPIRequiresValidation': true,
    		'updateAPIRequiresPricing': true,
    		'updateAPIRequiresValidation': true,
    		'modifyAttributesAPIRequiresPricing': true,
    		'modifyAttributesAPIRequiresValidation': true,
    		'deleteAPIRequiresPricing': true,
    		'deleteAPIRequiresValidation': true,
    
    		// the following settings for API used in Product List
    		'addToCartAPIInProductListRequiresPricing': true,
    		'addToCartAPIInProductListRequiresValidation': true,
    
    		// the following settings for API used in Applied Promotions tab in Cart
    		'deleteAppliedPromotionAPIRequiresPricing': true,
    		'deleteAppliedPromotionAPIRequiresValidation': true
    
    	};
    
    	$rootScope.vlocityCPQ.features = {
            enablePromotions : true,
            enablePricing: true,
            // this determines if context rule engine is used to return list of products / promotions eligible for the cart
            // setting this to be true will return both "Qualified" and "Unqualified" types of products / promotions
            // this switch is independent of pricing / promotions switches
            enableRuleBasedQualifications: true
	    }
    }