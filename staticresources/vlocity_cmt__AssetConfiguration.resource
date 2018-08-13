(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/** AngularJS **/
angular.module('assetConfiguration', ['ui.bootstrap', 'mgcrea.ngStrap', 'ui-rangeSlider']);

require('./modules/assetConfiguration/controller/AssetConfigurationController.js');
require('./modules/assetConfiguration/factory/AssetConfigurationService.js');

},{"./modules/assetConfiguration/controller/AssetConfigurationController.js":2,"./modules/assetConfiguration/factory/AssetConfigurationService.js":3}],2:[function(require,module,exports){
angular.module('assetConfiguration').controller('assetConfigurationController', function ($scope, $modal,$interval, assetConfigService) {
	$scope.ctx = {
		itemId: currentPageParameters.id,
		returnUrl: currentPageParameters.returnUrl,
		fieldSetName: currentPageParameters.fieldSetName,
		listType: currentPageParameters.listType

	};
	$scope.nsPrefix = nsPrefix;
	$scope.assetItems = [];
	$scope.allChk = {};
	$scope.prod = {};
	$scope.selectedAssets = [];
	$scope.cols = [];
	$scope.colsNameIdx = -1;
	$scope.colWidth = '';
	$scope.colNameWidth = '';
	$scope.tableHeight = '';
	/* to enable and disable buttons */
	$scope.isToDisable=true;
 

 //--------------CONSOLE HANDLING FIX FOR OM-810 OM-714 CMT-291-----------------------
     var PENDING = 0,  SUCCESS =1;
    var TO_RETRIES = 12 , TIMER_UNIT = 400;
    var responseReceived = PENDING;
    var consoleTimer,retryCount ;
        // CMT-300
	function getSOName(id){
          if ( id ){
            var pref = id.substring(0,3);
            var retval = "";
            //Quote : '0Q0' , Oppty : '006', Order : '801',Asset : '02i'
            switch(pref){
              case   '0Q0' : retval = 'New Quote';break;
              case   '006' : retval = 'New Opportunity';break;
              case   '801' : retval = 'New Order';break;
              case   '02i' : retval = 'New Asset';break;
            } 
            return retval;
              //--------------CONSOLE HANDLING FIX FOR OM-714 OM-291-----------------------
          }
          return '';
        } 
   $scope.consoleNavigateToDetail = function(arg,assetConfResult) {
        //First find the ID of the primary tab to put the new subtab in 
            //Now that we have the primary tab ID, we can open a new subtab in it
            var primaryTabId = assetConfResult.id; 
            var tname = getSOName(arg.substring(0,15));
            if (primaryTabId == "null")
             	sforce.console.openPrimaryTab(null,arg.substring(0,15), true, tname,null, tname); 
        	else
             	sforce.console.openSubtab(assetConfResult.id,'/' + arg.substring(0,15), true, tname,null, tname);
            $scope.isToDisable = true; 
    };



    $scope.SwitchToDetail = function(assetCallresult ) {
    	 	$scope.assetCallResult = assetCallresult;
            sforce.console.getEnclosingPrimaryTabId(function(consoleCheckResult) {
                responseReceived = true;
                $scope.consoleNavigateToDetail($scope.assetCallResult.location.substr(1),consoleCheckResult);
            });
            retryCount = 0;
            consoleTimer = $interval(  function(  ) {
                 retryCount++;
                if (responseReceived == SUCCESS  ) { // console succeeded
                    if ( angular.isDefined(consoleTimer) )
                    {
                        $interval.cancel(consoleTimer);
                    }
                    return;
                }
                else if ( retryCount == TO_RETRIES ) {

                    // still pending & used all retries. navigate to Aloha
                    if ($scope.assetCallResult.location !== '') {
                        window.top.location.href =  $scope.assetCallResult.location;
                    }  else {
                        $scope.isToDisable = true;
         				assetConfigService.openAlertWindow('Asset Change Error', $scope.assetCallResult.Status);
                    }
                }
            }, TIMER_UNIT);
    };

    //--------------CONSOLE HANDLING FIX FOR OM-810 OM-714 CMT-291-----------------------
	/* get the asset items */
	$scope.changeToQuoteFromAsset = function(items) {
		$scope.selectedAssets = [];
		angular.forEach(items, function(value, key){
			if(value.selected === true)
				$scope.selectedAssets.push(value.Id);
			if(value.children)
				$scope.parentSelectCheck(value);
		});
		assetConfigService.changeToQuoteFromAsset($scope.ctx.itemId, $scope.selectedAssets, $scope.ctx.listType).then(function(result) {
 				$scope.SwitchToDetail(result); //--------------CONSOLE HANDLING FIX FOR OM-810 OM-714
		}, function(errorMessage) {
			console.error(errorMessage);
		});
	};

	$scope.changeToOrderFromAsset = function(items) {    
		$scope.selectedAssets = [];
		angular.forEach(items, function(value, key){
			if(value.selected === true)
				$scope.selectedAssets.push(value.Id);
			if(value.children)
				$scope.parentSelectCheck(value);
		});
		assetConfigService.changeToOrderFromAsset($scope.ctx.itemId, $scope.selectedAssets, $scope.ctx.listType).then(function(result) {
 			$scope.SwitchToDetail(result);//--------------CONSOLE HANDLING FIX FOR OM-810 OM-714
		}, function(errorMessage) {
			console.error(errorMessage);
		});
	};

	$scope.getContextId = function(items){
		$scope.contextId = $scope.ctx.itemId;
		if(items !== undefined && items.length > 0) {
			for(var i=0; items.length; i++){
				if(items[i].selected === true && items[i].level === 1){
					$scope.contextId = items[i].Id;
					break;
				}
			}
		}
		return $scope.contextId;
	};

	$scope.getUrl = function(items) {
		//CMT-600 Initiate Move from Console
		var PENDING = 0,  SUCCESS =1;
	    var TO_RETRIES = 1 , TIMER_UNIT = 400;
	    var responseReceived = PENDING;
	    var consoleTimer,retryCount ;
	    
	    sforce.console.getEnclosingPrimaryTabId(function(consoleCallResult) {
                responseReceived = SUCCESS; // console check happened
                if ( angular.isDefined(consoleTimer) )
                {
                    $interval.cancel(consoleTimer);
                }
                var moveInAccountURL = '/apex/'+$scope.nsPrefix+'MoveInAccount?id='+$scope.getContextId();
				sforce.console.openPrimaryTab(null, moveInAccountURL, true, 'Move Asset',null, 'Move Asset');
            });
            retryCount = 0;

           consoleTimer = $interval(  function(  ) {
                retryCount++;
                if (responseReceived == SUCCESS  ) { // console succeeded
                    if ( angular.isDefined(consoleTimer) )
                    {
                        $interval.cancel(consoleTimer);
                    }
                    return;
                }
                else if ( retryCount == TO_RETRIES ) {
                    window.parent.location.href='/apex/'+$scope.nsPrefix+'MoveInAccount?id='+$scope.getContextId(items);
                }
            }, TIMER_UNIT);
	};

	$scope.getContextIds = function(items){
		$scope.contextIds = '';
		if(items !== undefined && items.length > 0) {
			for(var i=0; i < items.length; i++){
				if(items[i].selected === true && items[i].level === 1){
					$scope.contextIds += items[i].Id + '+';
				}
			}
		}
		$scope.contextIds = $scope.contextIds.substring(0, $scope.contextIds.length - 1);
		return $scope.contextIds;
	};

	$scope.getFDOUrl = function(items) {
		//CMT-600 Initiate Move from Console
		var PENDING = 0,  SUCCESS =1;
	    var TO_RETRIES = 1 , TIMER_UNIT = 400;
	    var responseReceived = PENDING;
	    var consoleTimer,retryCount ;
	    
	    sforce.console.getEnclosingPrimaryTabId(function(consoleCallResult) {
                responseReceived = SUCCESS; // console check happened
                if ( angular.isDefined(consoleTimer) )
                {
                    $interval.cancel(consoleTimer);
                }
                var fdoURL = '/apex/'+$scope.nsPrefix+'MACDFdo?id='+$scope.getContextIds(items)+'#/OmniScriptType/MACD/OmniScriptSubType/FDO/OmniScriptLang/English/ContextId/'+$scope.getContextIds(items)+'/PrefillDataRaptorBundle//true';
				sforce.console.openPrimaryTab(null, fdoURL, true, 'Future Dated Order',null, 'Future Dated Order');
            });
            retryCount = 0;

           consoleTimer = $interval(  function(  ) {
                retryCount++;
                if (responseReceived == SUCCESS  ) { // console succeeded
                    if ( angular.isDefined(consoleTimer) )
                    {
                        $interval.cancel(consoleTimer);
                    }
                    return;
                }
                else if ( retryCount == TO_RETRIES ) {
                    window.parent.location.href='/apex/'+$scope.nsPrefix+'MACDFdo?id='+$scope.getContextIds(items)+'#/OmniScriptType/MACD/OmniScriptSubType/FDO/OmniScriptLang/English/ContextId/'+$scope.getContextIds(items)+'/PrefillDataRaptorBundle//true';
                }
            }, TIMER_UNIT);
	};

	$scope.getChangeToQuoteUrl = function(items) {
		//CMT-600 Initiate Move from Console
		var PENDING = 0,  SUCCESS =1;
	    var TO_RETRIES = 1 , TIMER_UNIT = 400;
	    var responseReceived = PENDING;
	    var consoleTimer,retryCount ;
	    
	    sforce.console.getEnclosingPrimaryTabId(function(consoleCallResult) {
                responseReceived = SUCCESS; // console check happened
                if ( angular.isDefined(consoleTimer) )
                {
                    $interval.cancel(consoleTimer);
                }
                var changeURL = '/apex/'+$scope.nsPrefix+'OmniScriptUniversalPage?id='+$scope.getContextIds(items)+'#/OmniScriptType/MACD/OmniScriptSubType/ChangeToQuote/OmniScriptLang/English/ContextId/'+$scope.ctx.itemId+":"+$scope.ctx.listType+":"+$scope.getContextIds(items)+'/PrefillDataRaptorBundle//true';
				sforce.console.openPrimaryTab(null, changeURL, true, 'Change To Quote',null, 'Change To Quote');
            });
            retryCount = 0;

           consoleTimer = $interval(  function(  ) {
                retryCount++;
                if (responseReceived == SUCCESS  ) { // console succeeded
                    if ( angular.isDefined(consoleTimer) )
                    {
                        $interval.cancel(consoleTimer);
                    }
                    return;
                }
                else if ( retryCount == TO_RETRIES ) {
                    window.parent.location.href='/apex/'+$scope.nsPrefix+'OmniScriptUniversalPage?id='+$scope.getContextIds(items)+'#/OmniScriptType/MACD/OmniScriptSubType/ChangeToQuote/OmniScriptLang/English/ContextId/'+$scope.ctx.itemId+":"+$scope.ctx.listType+":"+$scope.getContextIds(items)+'/PrefillDataRaptorBundle//true';
                }
            }, TIMER_UNIT);
	};

	$scope.disableMove = function(items) {
		var disableButton = true;
		var count = 0;
		if($scope.ctx.listType === 'Service'){
			var selectedAsset = [];
			angular.forEach(items, function(value, key){
				if(value.selected === true)
					selectedAsset.push(value);
			});
			for(var i=0; i<selectedAsset.length; i++){
				if(selectedAsset[i].level === 1) {
					count++;
					disableButton = false;
				}
				if(count > 1) {
					disableButton = true;
					break;
				}

			}
			return disableButton;
		}
	};

	$scope.disableAllCheck = function(items) {

		if(!items || items.length === 0) {
			return true;
		}
		for(var i=0; i<items.length; i++) {
			if(items[i]['Provisioning Status'] == 'Active') {
				return false;
			}
		}
		return true;
	};

	$scope.parentSelectCheck = function(item) {
		angular.forEach(item.children, function(value, key) {
	      if(value.selected === true)
				$scope.selectedAssets.push(value.Id);
	      if (value.children) {
	    	  $scope.parentSelectCheck(value);
	      }
	    });
	  };

	$scope.getAssetList = function(accountId, fieldSetName, listType) {
		assetConfigService.getAssetList(accountId, fieldSetName, listType).then(function(result) {

			var cols = result[0];
			result.splice(0,1);

			// set up the columns to display
			angular.forEach(cols, function(value, idx) {
				if (!(value === 'Id' || value === 'LineNumber')) {
					$scope.cols.push(value);
				}
				if (value === 'Asset Name')
					$scope.colsNameIdx = idx;
			});

			// resize the Assets table
			$scope.resizeAssetsTable();

			// render the assets
			$scope.renderAssetItems(result, 'expandNone', accountId);
		}, function(errorMessage) {
			console.error(errorMessage);
		});
	};

	$scope.resizeAssetsTable = function() {
		// calculate the column widths
		if ($scope.colsNameIdx === -1) {
			if ($scope.cols.length > 0)
				$scope.colWidth = Math.floor((j$(window).width() - 40 - (9 * $scope.cols.length)) / $scope.cols.length)+'px';
		}
		else {
			if ($scope.cols.length > 1)
				$scope.colWidth = Math.floor((j$(window).width() - 320 - (9 * $scope.cols.length)) / ($scope.cols.length-1))+'px';
			$scope.colNameWidth = '280px';
		}

		// calculate the max height of the assets table
		var fixedHeight = 	j$('.vlocity .panel-assets .asset-hd').height() + 5 +
							j$('.vlocity .panel-assets .panel-footer').height() + 21;
		$scope.tableHeight = Math.floor(j$(window).height() - fixedHeight)+'px';
	};

	$scope.changeAssetSelection = function(item, items) {
	    // We're handling the ALL checkbox here
		if(item.length > 1){
			angular.forEach(item, function(value, key){
				$scope.allCheckChange(value);
			});
		}else{
			$scope.prod.selected = item.selected;
			var lineNum = [];
			var selItem = {};
			if(item.LineNumber){
				lineNum = item.LineNumber.split('.');
				angular.forEach(items, function(value, key){
					if(value.LineNumber !== undefined && value.LineNumber === lineNum[0]){
						value.selected = $scope.prod.selected;
						if (value.children) {
							$scope.parentCheckChange(value);
						}
				    // We're handling the toggling of all of the children here
						else {
							if(value.selected === undefined)
								value.selected = $scope.allChk.selected;
				    	}
					}
				});
			}
			
			
		
		}
		var isAllSelected = true;
		var isAllNotSelected = true;
		for(var i=0;i<items.length;i++){
			if(items[i].selected){
				isAllNotSelected=false;
			} else{
				isAllSelected = false;
			}
			if(!isAllNotSelected && !isAllSelected){
				//required work has done so breaking it.
				break;
			}
		}
		if(isAllSelected){
			$scope.allChk.selected = true;
			$scope.isToDisable = false;
		}else if(isAllNotSelected){
			$scope.allChk.selected = false;
			$scope.isToDisable = true;
		}else{
			$scope.isToDisable = false;
			$scope.allChk.selected = false;
		}
	};
	
	$scope.changeAllAssetSelection = function(item, items){
	    // We're handling the ALL checkbox here
	    if(items.length>0){
	    	$scope.isToDisable=!$scope.allChk.selected;
	    }
		if(item.length > 0 ){
			angular.forEach(item, function(value, key){
				$scope.allCheckChange(value);
			});
		}
	};

	$scope.allCheckChange = function(item) {
		if(item['Provisioning Status'] !== 'Retired'){
			item.selected = $scope.allChk.selected;
			if(item.children){
		    for (var i in item.children) {
			      item.children[i].selected = $scope.allChk.selected;
			      if (item.children[i].children) {
			    	  $scope.parentAllCheckChange(item.children[i]);
			      }
			    }
			}
		}
	  };

	 $scope.parentAllCheckChange = function(item) {
		    for (var i in item.children) {
		      item.children[i].selected = $scope.allChk.selected;
		      if (item.children[i].children) {
		    	  $scope.parentAllCheckChange(item.children[i]);
		      }
		    }
	 };
	  
	$scope.parentCheckChange = function(item) {
	    for (var i in item.children) {
	      item.children[i].selected = $scope.prod.selected;
	      if (item.children[i].children) {
	    	  $scope.parentCheckChange(item.children[i]);
	      }
	    }
	  };

	/* render the cart items */
	$scope.renderAssetItems = function(items, expandType, accId) {
		$scope.assetItems = [];
		var prevIdx = 0;
		var indent;
		angular.forEach(items, function(prod, idx) {
			if(prod.LineNumber !== undefined){
				indent = prod.LineNumber.split('.');
				if (indent.length === 1 && idx > 0) {
					var tempProdList = items.slice(prevIdx, idx);
					var tempProdHierarchy = $scope.createProductHierarchy(tempProdList, expandType);
					$scope.assetItems.push(tempProdHierarchy[0]);
					prevIdx = idx;
				}
			}else{
				$scope.assetItems.push(prod);
			}

			if (indent.length === 1) {
				expandType = 'expandNone';
			}

		});
		if (prevIdx < items.length) {
			var tempProdList = items.slice(prevIdx, items.length);
			var tempProdHierarchy = $scope.createProductHierarchy(tempProdList, expandType);
			$scope.assetItems.push(tempProdHierarchy[0]);
		}
	};

	/* initialize the app */
	$scope.init = function() {
		//fetch the Assets
		$scope.getAssetList($scope.ctx.itemId, $scope.ctx.fieldSetName, $scope.ctx.listType);

	};

	$scope.init();

	/* convert the product list into a tree hierarchy */
	$scope.createProductHierarchy = function(productList, expandNode) {
		var productHierarchy = [];

		var rootProduct = productList[0];
		rootProduct.isRoot = true;
		rootProduct.level = 1;
		if (expandNode !== undefined)
			rootProduct.isExpanded = (expandNode === 'expandAll' || expandNode === 'expandRoot');

		for (var idx = 1; idx < productList.length; idx++) {
			var prod = productList[idx];
			var levels;
			if(prod.LineNumber !== undefined){
				levels = prod.LineNumber.split('.');
				prod.level = levels.length;
			}
			if (expandNode !== undefined)
				prod.isExpanded = (expandNode === 'expandAll');
			prod.rootProductId = rootProduct.productId;
			if(levels !== undefined)
				$scope.setProductChildren(rootProduct, levels.slice(1), prod);
		}
		$scope.filterProductHierarchy(rootProduct);
		productHierarchy.push(rootProduct);

		return productHierarchy;
	};

	/* set the product children as part of building the tree hierarchy */
	$scope.setProductChildren = function(product, levels, p) {
		if (levels.length === 1) {
			if (product.children === undefined)
				product.children = [];

			product.children[levels[0]-1] = p;
		} else {
			$scope.setProductChildren(product.children[levels[0]-1], levels.slice(1), p);
		}
	};

	/* filter the tree hierarchy to remove undefined array elements */
	$scope.filterProductHierarchy = function(product) {
		if (product.children) {
			product.children = product.children.filter(function(n) { return n !== undefined; });
			angular.forEach(product.children, function(prod) {
				$scope.filterProductHierarchy(prod);
			});
		}
	};

	j$(window).on('resize.doResize', function() {
        $scope.$apply(function() {
        	// resize the Assets table
			$scope.resizeAssetsTable();
        });
    });

    $scope.$on('$destroy', function () {
         j$(window).off('resize.doResize'); // remove the handler added above
    });

    $scope.gotoAsset = function(assetId) {
		//top.window.location.href = location.protocol + '//' + location.hostname + '/' + assetId + '/e?retURL=%2F' + $scope.ctx.itemId;
		//Fix CMT-383
		top.window.location.href = location.protocol + '//' + location.hostname + '/' + assetId;
    };
});

angular.module('assetConfiguration').controller('ModalInstanceCtrl', function ($scope, $modalInstance, message) {
	$scope.message = message;
	$scope.ok = function () {
		$modalInstance.close();
	};

});

},{}],3:[function(require,module,exports){
function getAssetList(accId, fieldSetName, listType, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getAssetList, accId, fieldSetName, listType, callback, {escape: false});
}

function changeToOrderFromAsset(accId, svcAssets, listType, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.changeToOrderFromAsset, accId, svcAssets, listType, callback, {escape: false});
}

function changeToQuoteFromAsset(accId, svcAssets, listType, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.changeToQuoteFromAsset, accId, svcAssets, listType, callback, {escape: false});
}

angular.module('assetConfiguration').factory('assetConfigService', function($q, $rootScope, $modal) {
	var factory = {};

	factory.getAssetList = function(accId, fieldSetName, listType) {
		var deferred = $q.defer();
		getAssetList(accId, fieldSetName, listType, function(result, event) {
			$rootScope.$apply(function() {
				var sresult = [];
				if (event.status) {
					sresult = angular.fromJson(result);
					deferred.resolve(sresult);
				} else {
					deferred.reject(event.message);
				}
			});
		});
		return deferred.promise;
	};

	factory.changeToOrderFromAsset = function(accId, svcAssets, listType) {
		var deferred = $q.defer();
		changeToOrderFromAsset(accId, svcAssets, listType, function(result, event) {
			$rootScope.$apply(function() {
				var sresult = [];
				if (event.status) {
					sresult = angular.fromJson(result);
					deferred.resolve(sresult);
				} else {
					deferred.reject(event.message);
				}
			});
		});
		return deferred.promise;
	};
	
	factory.changeToQuoteFromAsset = function(accId, svcAssets, listType) {
		var deferred = $q.defer();
		changeToQuoteFromAsset(accId, svcAssets, listType, function(result, event) {
			$rootScope.$apply(function() {
				var sresult = [];
				if (event.status) {
					sresult = angular.fromJson(result);
					deferred.resolve(sresult);
				} else {
					deferred.reject(event.message);
				}
			});
		});
		return deferred.promise;
	};

	factory.openAlertWindow = function (title, message) {
		var modalInstance = $modal({
			templateUrl: 'myModalContent.html',
			controller: 'ModalInstanceCtrl',
			content: message,
			show:true,
			title: title
		});
	};

	return factory;
});

},{}]},{},[1]);

})();