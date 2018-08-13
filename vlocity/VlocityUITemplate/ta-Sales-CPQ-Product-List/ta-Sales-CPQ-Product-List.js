/* Please use vlocity.cardframework.registerModule to register your Angular Controller */

vlocity
.cardframework
.registerModule
.controller('TACPQProductListController', TACPQProductListController);

TACPQProductListController.$inject = ['$rootScope','$scope','CPQService','$sldsTypeahead','$sldsPrompt','$sldsToast','$filter','$timeout', '$q','$http', 'PromiseQueueFactory','$log', 'dataSourceService'];
function TACPQProductListController($rootScope, $scope, CPQService, $sldsTypeahead, $sldsPrompt, $sldsToast, $filter, $timeout, $q, $http, PromiseQueueFactory, $log, dataSourceService) {
	$scope.comps = {};
	$scope.groups = {};
	$scope.categoryProductMap = {};
	
	$scope.isCallPending = false;
	$scope.isLayoutLoaded = false;
	
	$scope.isIE11 = !!navigator.userAgent.match(/Trident\/7\./);
	
	$scope.init = function() {
	    
	}
	
	$scope.$watch('records', function(newVal, oldVal) {
	    if (newVal && $rootScope.defaultCategory == 'Bundles' && $rootScope.selectedCategory == 'Bundles') {
	        $scope.recordsFiltered = $filter('orderBy')($scope.records, 'PricingElement.value');
	    } else if (newVal) {
	        $scope.recordsFiltered = newVal;    
	    }   
	});
	
	console.info('### Product List ###');
	$scope.$on('category', function (event, data) {
	    console.info('category on: ', event, ' - ', data);
		if ($scope.categoryProductMap[data.catalogId]){
			$scope.records = $scope.categoryProductMap[data.catalogId];
			$scope.importedScope.$parent.records = $scope.categoryProductMap[data.catalogId];
			console.info('Records: ', $scope.records);
			$scope.importedScope.$parent.reloadLayout2($scope.records);
		} else if (!data.catalogId && $scope.categoryProductMap['All']){
			$scope.records = $scope.categoryProductMap['All'];
			$scope.importedScope.$parent.records = $scope.categoryProductMap['All'];
			$scope.$parent.$parent.$parent.reloadLayout2($scope.records);
		} else {
			$scope.message = data;
			
			var params = {};
			params.category = data.catalogId;
			
			$scope.params = params;
			
			if ($scope.isLayoutLoaded) {
				$scope.$parent.$parent.updateDatasource(params);
			} else {
				$scope.isCallPending = true;
			}
		}
	});
	
	$scope.$watch('$parent.$parent.isLoaded', function(newVal, oldVal) {
	   $scope.isLayoutLoaded = newVal;
	   if ($scope.isCallPending) {
		  $scope.updateProductList(); 
		  $scope.isCallPending = false;
	   }
	});
	
	$scope.updateProductList = function() {
		$scope.$parent.$parent.updateDatasource($scope.params);
	}
	
	
	// // Custom Get Product Service
	
	// function addParamToBaseUrl(baseEndpoint, numOfParams, paramName, paramValue) {
	//     if (paramValue) {
	//         baseEndpoint += (numOfParams == 1) ? '?' : '&';
	//         baseEndpoint += paramName + '=' + paramValue;
	//     }
	//     return baseEndpoint;
	// }
	
	// $scope.getProductCustom = function(cartId, query, start, next, scope) {
	//     $log.debug('getting getCartAvailableProducts');
	//     var deferred = $q.defer();
	//     //var nsPrefix = fileNsPrefix().replace('__', '');
	//     var datasource = {};
	//     datasource.type = 'Dual';
	//     datasource.value = {};
	//     //datasource.value.remoteNSPrefix = nsPrefix;
	//     datasource.value.remoteClass = 'taCpqAppHandler';
	//     datasource.value.remoteMethod = 'getCartsProducts';
	//     datasource.value.inputMap = {'cartId': cartId,
	//                                 'query': query,
	//                                 'start': start,
	//                                 'next': next};
	//     datasource.value.apexRemoteResultVar = 'result.records';
	//     datasource.value.methodType = 'GET';
	//     datasource.value.apexRestResultVar = 'result.records';
	//     // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
	//     // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
	//     dataSourceService.getData(datasource, scope, null).then(
	//         function(data) {
	//             $log.debug(data);
	//             deferred.resolve(data);
	//             $scope.autoAddObj = data.records[0];
	//             $scope.addToCartFixed($scope.autoAddObj);
	//         }, function(error) {
	//             $log.error(error);
	//             deferred.reject(error);
	//         });

	//     return deferred.promise;
	// }
	
	// // Auto Add Connectivity
	// $scope.$on('autoAddOffer', function(event, data) {
	//     $scope.autoAddOffer(data);
	// });
	
	// $scope.autoAddOffer = function(obj) {
	//     var cartId = $scope.importedScope.params.id;
	//     var query = obj.Name? obj.Name : obj;
	//     $scope.getProducts(cartId, query, null, null, null, null, null, $scope).then(function(data){
	//         $scope.prepareOfferForAddToCart(data.records[data.records.length - 1], obj);
	//     });
	// }
	
	// $scope.$on('addConnectivity', function(event, data) {
	//     $scope.getAutoAdd();
	// });
			
	// $scope.getAutoAdd = function() {
	//     var cartId = $scope.importedScope.params.id;
	//     var query = 'TELUS Connectivity';
	//     $scope.getProductCustom(cartId, query, null, null, $scope);
	// }
	
	// Catalog Lazy Load
	
//     $scope.getProducts = function(remoteClass, remoteMethod, cartId, query, catalogId, lastRecordId, fields, start, next, scope) {
//         $log.debug('getting getCartAvailableProducts');
//         var deferred = $q.defer();
//         var datasource = {};
//         datasource.type = 'Dual';
//         datasource.value = {};
//         datasource.value.remoteClass = remoteClass;
//         datasource.value.remoteMethod = remoteMethod;
//         datasource.value.inputMap = {'cartId': cartId,
//                                     'query': query,
//                                     'category': catalogId,
//                                     'lastRecordId': lastRecordId,
//                                     'fields': fields,
//                                     'hierarchy': 0,
//                                     'pagesize': 1900, 
//                                     'start': start,
//                                     'next': next};
//         datasource.value.apexRemoteResultVar = 'result.records';
//         var baseEndpoint = '/v2/cpq/carts/' + cartId + '/products';
//         var numOfParams = 0;
//         baseEndpoint = !query ? baseEndpoint : addParamToBaseUrl(baseEndpoint, ++numOfParams, 'query', query);
//         baseEndpoint = !start ? baseEndpoint : addParamToBaseUrl(baseEndpoint, ++numOfParams, 'start', start);
//         baseEndpoint = !next ?  baseEndpoint : addParamToBaseUrl(baseEndpoint, ++numOfParams, 'next', next);
//         //datasource.value.endpoint = nsPrefix ? '/' + nsPrefix + baseEndpoint : baseEndpoint;
//         datasource.value.methodType = 'GET';
//         datasource.value.apexRestResultVar = 'result.records';
//         // no need to pass forceTk client below because on desktop, dual datasource will use ApexRemote
//         // and on Mobile Hybrid Ionic, dual datasource will use ApexRest via forceng
//         dataSourceService.getData(datasource, scope, null).then(
//             function(data) {
//                 $log.debug(data);
//                 deferred.resolve(data);
//             }, function(error) {
//                 $log.error(error);
//                 deferred.reject(error);
//             });

//         return deferred.promise;
//     }
	
//     $scope.getAllProducts = function() {
//         var remoteClass = 'CpqAppHandler';
//         var remoteMethod = 'getCartsProducts';
//         var cartId = $scope.importedScope.params.id;
//         var query = null;
//         var fields = $scope.importedScope.$parent.data.dataSource.value.inputMap.fields;
//         var catalogId = null;
//         var lastRecordId = $scope.lastRecordId? $scope.lastRecordId : null; 
//         var start = null;
//         var next = null;

//         $scope.getProducts(remoteClass, remoteMethod, cartId, query, catalogId, lastRecordId, fields, start, next, $scope).then(function(records){
//             $scope.allProducts = records;
//             // Create Category Product Map
//             $scope.createCategoryProductMap(records.records);
//             // Store last record PBE Id
//             $scope.lastRecordId = records.records[records.records.length - 1].Id.value;
//         }, function(error) {
//             $log.error(error);
//         });
//     }
	
// 	$scope.createCategoryProductMap = function(records) {
//         for (var i = 0; i < records.length; i++) {
//             $scope.categoryProductMap['All'] = {
//                 'records': records
//             };
//             if (records[i].Product2.%vlocity_namespace%__CategoryData__c) {
//                 var catData = JSON.parse(records[i].Product2.%vlocity_namespace%__CategoryData__c);
//                 if (catData[0]) {
//                     for (var j = 0; j < catData.length; j++) {
                        
//                         //  Child Categories
//                         if (catData[j].childCategories[0]) {
//                             var categoryId = catData[j].childCategories[0].id;
//                             if (!$scope.categoryProductMap[categoryId]) {
//                                 $scope.categoryProductMap[categoryId] = {
//                                     'records': []
//                                 };    
//                             }
//                             $scope.categoryProductMap[categoryId].records.push(records[i]);
//                         } 
                        
//                         // Root Category
//                         if (catData[j].id) {
//                             var rootCategoryId = catData[j].id;
//                             if (!$scope.categoryProductMap[rootCategoryId]) {
//                                 $scope.categoryProductMap[rootCategoryId] = {
//                                     'records': []
//                                 };    
//                             }
//                             $scope.categoryProductMap[rootCategoryId].records.push(records[i]);
//                         }
//                     }
//                 } 
//             }
//         }
//         console.log('categoryProductMap', $scope.categoryProductMap);
//     }
	
// 	$scope.getAllProducts();
	
	// $scope.prepareOfferForAddToCart = function(obj, feasibleObj) {
	//     if (feasibleObj && feasibleObj.Id) {
	//         var item = {};
	//         item.itemId = feasibleObj.Id;
	//         item.quantity = 1;
	//         var items = [item];
			
	//         obj.actions.addtocart.remote.params.items = items;
	//         obj.actions.addtocart.rest.params.items = items;
	//         obj.Name.value = feasibleObj.Name;
	//     }

	//     $scope.addToCartFixed(obj);
	// }
	
	// $rootScope.isCatalogLoaded = true;
	// $rootScope.$broadcast('isCatalogLoaded', true);
	
	// // Override 
	
	// $scope.addToCartFixed = function(obj) {
	//     var procesingMessageToast = $sldsToast({
	//         message: $filter('customLabel')('CPQAddingItem') + ' ' + obj.Name.value + ' ...',
	//         severity: 'info',
	//         icon: 'info',
	//         templateUrl: 'SldsToast.tpl.html',
	//         show: CPQService.toastEnabled('info')
	//     });
	//     wrapFunctionCall(addToCartPromise, [obj, procesingMessageToast]);
	// };

	// function wrapFunctionCall(call, args) {
	//     //wrap the function and add it to the queue and execute
	//     // var wrapped = PromiseQueueFactory.wrapFunction(call, [args]);
	//     // PromiseQueueFactory.addTask({task: wrapped});
	//     args = Array.isArray(args) ? args : [args];
	//     PromiseQueueFactory.addTask(call, args);
	//     PromiseQueueFactory.executeTasks();
	// }

	// /**
	//  * addToCart: Emits an event when ever user selects the product
	// */
	// var addToCartPromise = function(obj, procesingMessageToast) {
	//     var deferred = $q.defer();
	//     var addItemActionObj = obj.actions.addtocart ? obj.actions.addtocart : null;
		
	//     addItemActionObj.remote.params.hierarchy = 20;
	//     addItemActionObj.rest.params.hierarchy = 20;
		
	//     if (addItemActionObj) {
	//         CPQService.invokeAction(addItemActionObj).then(
	//             function(data) {
	//                 $log.debug(data);
	//                 procesingMessageToast.hide();

	//                 $sldsToast({
	//                     message: $filter('customLabel')('CPQAddedItem') + ' ' + obj.Name.value,
	//                     severity: 'success',
	//                     icon: 'success',
	//                     templateUrl: 'SldsToast.tpl.html',
	//                     autohide: true,
	//                     show: CPQService.toastEnabled('success')
	//                 });

	//                 if (data.actions) {
	//                     //gathering the messages
	//                     var itemMessages = [];
	//                     if (data.actions.addcart) {
	//                         itemMessages = itemMessages.concat(data.actions.addcart.client.params.items);
	//                     }
	//                     if (data.actions.deletecart) {
	//                         itemMessages = itemMessages.concat(data.actions.deletecart.client.params.items);
	//                     }

	//                     angular.forEach(itemMessages, function(item) {
	//                         $sldsToast({
	//                             backdrop: 'false',
	//                             message: item.message,
	//                             severity: 'success',
	//                             icon: 'success',
	//                             templateUrl: 'SldsToast.tpl.html',
	//                             autohide: true,
	//                             show: CPQService.toastEnabled('success')
	//                         });
	//                     });
	//                 }

	//                 $rootScope.$broadcast('vlocity.cpq.cart.addrecords', data.records);
	//                 deferred.resolve($filter('customLabel')('CPQAddedItem') + ' ' + obj.Name.value);

	//                 //Cross actions
	//                 //CPQCartItemCrossActionService.processActions(data.actions, data.records);
	//             }, function(error) {
	//                 $log.error(error);
	//                 procesingMessageToast.hide();

	//                 $sldsToast({
	//                     title: $filter('customLabel')('CPQAddItemFailed') + ' ' + obj.Name.value,
	//                     content: error.message,
	//                     severity: 'error',
	//                     icon: 'warning',
	//                     autohide: true,
	//                     show: CPQService.toastEnabled('error')
	//                 });
	//                 deferred.reject($filter('customLabel')('CPQAddItemFailed') + ' ' + obj.Name.value);
	//             });
	//     } else {
	//         $log.debug('Addtocart action not found');
	//         deferred.reject($filter('customLabel')('CPQAddItemFailed') + ' ' + obj.Name.value);
	//     }

	//     return deferred.promise;
	// };
}