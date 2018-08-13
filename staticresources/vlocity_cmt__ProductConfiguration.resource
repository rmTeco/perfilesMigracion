(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
/** AngularJS **/
angular.module('productConfiguration', ['formatFilters', 'ui.bootstrap', 'ui-rangeSlider', 'mgcrea.ngStrap.modal', 'mgcrea.ngStrap.datepicker', 'mgcrea.ngStrap.timepicker', 'mgcrea.ngStrap.tooltip', 'ui.mask']);

require('./modules/productConfiguration/controller/ProductConfigurationController.js');
require('./modules/productConfiguration/directive/vlcLoader.js');
require('./modules/productConfiguration/directive/QueryableAttribute.js');
require('./modules/productConfiguration/factory/ProductConfigurationService.js');
require('./modules/productConfiguration/filter/FormatFilters.js');

},{"./modules/productConfiguration/controller/ProductConfigurationController.js":2,"./modules/productConfiguration/directive/QueryableAttribute.js":3,"./modules/productConfiguration/directive/vlcLoader.js":4,"./modules/productConfiguration/factory/ProductConfigurationService.js":5,"./modules/productConfiguration/filter/FormatFilters.js":6}],2:[function(require,module,exports){
angular.module('productConfiguration').controller('productConfigurationController', function ($scope, $sce, $filter, $modal, prodConfigService, $timeout, $interval) {
    $scope.isProductsLoading = true;
    $scope.isCartLoading = true;
    $scope.expandedCart = false;
    $scope.saveMode = 'explicit';
    $scope.prodConfMode = null;
    $scope.idx = {
        attrval: {},
        attrname: {},
        attrtype: {},
        attrslider: {},
        attrdate: {},
        attrpicklist: {}
    };
    $scope.searchfilter = {};
    $scope.productIdToAttrbMap = {};
    $scope.productIdToProdKey = {};
    $scope.filterValueText = {};
    $scope.filterValueSlider = {};
    $scope.filterValueDate = {};
    $scope.filterValuePicklist = {};
    $scope.productsFilter = {
        hasResults: true,
        hasTextResults: true,
        hasSliderResults: true,
        hasDateResults: true
    };
    $scope.searchText = '';
    $scope.sortoptions = [
    {label: sortLabel.Name, name: 'Name'},
    {label: sortLabel.NonRecurringCost, name: 'NonRecurringCost'},
    {label: sortLabel.RecurringCost, name: 'RecurringCost'},
    {label: sortLabel.Featured, name: 'Featured'},
    ];
    $scope.sortby = $scope.sortoptions[0];
    $scope.bSelectPricebook = true;
    $scope.showPricebookError = false;
    $scope.pricebook = null;
    $scope.pricebooks = [];
    $scope.ctx = {
        itemId: currentPageParameters.id,
        returnUrl: currentPageParameters.returnUrl
    };
    $scope.nsPrefix = nsPrefix;
    $scope.currencySymbol = currencySymbol;
    $scope.thousandSep = thousandSep;
    $scope.decimalSep = decimalSep;
    $scope.orderActive = false;
    $scope.buttonStatus = {};
    $scope.buttonStatus.isCreateButtonEnabled = true;
    $scope.products = {list:[], searchresults:[]};
    $scope.cfgProducts = [];
    $scope.cfgLineItemId = null;
    $scope.productBundle = [];
    $scope.cartItems = [];
    $scope.parentObj = {
        showProdConfig: false,
        showAttrConfig: false
    };
    $scope.implicitClean = true;
    $scope.cartErrors = [];
    $scope.productErrors = [];
    $scope.prodAttribMode = 'true';
    $scope.disableAddToCartButton = false;
    $scope.isRequiredField = false;
    $scope.isSignatureRequired = false;
    $scope.attributesList = {};
    $scope.hasNext = false;
    $scope.hasPrevious = false;
    $scope.currentIndex;
    $scope.srchText = '';
    $scope.cacheEnabled = 'false';
    $scope.paginationMode = 'false';
    $scope.loadPage = true;
    $scope.selectedProds = '';
    $scope.prodIdToReqAttrMap = {};
    $scope.configurableProdIds = [];
    $scope.rootIdToChildMap = {};
    // CMT-723
    $scope.cpqSettings = {} ; //CMT-723
    $scope.cpqPerfMode = {} ; //CMT-723
    $scope.ptstamps = {};    
    $scope.perfstart  = function(funcname){
        var curr = new Date().getTime() ; 
        $scope.ptstamps[funcname+"START"] = curr;
    }
    $scope.perfstop  = function(funcname){
        var curr = new Date().getTime() ; 
        $scope.ptstamps[funcname+"STOP"] = curr;
        var tsecs = ($scope.ptstamps[funcname+"STOP"] - $scope.ptstamps[funcname+"START"]) / 1000;
        console.log(funcname +" took " + tsecs+"s");    
    }    
    $scope.perfprint =  function(funcname)
    {
        var tsecs = ($scope.ptstamps[funcname+"STOP"] - $scope.ptstamps[funcname+"START"]) / 1000;
        console.log(funcname +" took " + tsecs+"s");
        return tsecs;
    }
    //<<< CMT-723
    $scope.$watch('productErrors', function(newVal) {
        $scope.resizePanels();
    });

    $scope.$watch('cartErrors', function(newVal) {
        $timeout(function() {
            $scope.resizePanels();
        }, 1000);
    });

    $scope.$watch('cartItemsError', function(newVal) {
        $timeout(function() {
            $scope.resizePanels();
        }, 1000);
    });

    this.searchFunc = function(item) {
        if($scope.paginationMode === 'true')
            return true;
        var strToMatch = item.Name + ' ' + item.Description;
        strToMatch = strToMatch.toLowerCase();
        var matchArr = strToMatch.match($scope.searchText.toLowerCase());
        if (matchArr && matchArr.length > 0) {
            $scope.genIndexFromProd(item, false);
            return true;
        }
        return false;
    };
    
    this.orderFunc = function(sortby) {
		return function(item){
			if(item[sortby] == undefined){
				return 0;
			}
			return item[sortby];
		}
		
	 };
   // CMT-723
   var REFRESH_VALS = {FULL_REFRESH :0, MIN_REFRESH : 5,    VALIDATE_REFRESH : 8 , PRICE_REFRESH :10  };

    //get all attribute cache
   $scope.getAttributes = function() {
       $scope.isProductsLoading = true;
       prodConfigService.getAttributes($scope.ctx.itemId).then(function(result) {
        //check if cache enabled then get index from cache
        if($scope.cacheEnabled === 'true') {
           if(result !== undefined) {
             if(result.message !== undefined) {
                  var message = result.message;
                  var title = 'Batch Job';
                  prodConfigService.openAlertWindow(title,message);
             }
             if(result.pbeIdToJSONMap !== undefined) {
                 if(result.pbeIdToJSONMap.indexAttrMap !== undefined){
                      $scope.idx.attrval = result.pbeIdToJSONMap.indexAttrMap.attrval;
                      $scope.idx.attrname = result.pbeIdToJSONMap.indexAttrMap.attrname;
                      $scope.idx.attrtype = result.pbeIdToJSONMap.indexAttrMap.attrtype;
                      $scope.idx.attrslider = result.pbeIdToJSONMap.indexAttrMap.attrslider;
                      $scope.idx.attrdate = result.pbeIdToJSONMap.indexAttrMap.attrdate;
                      $scope.idx.attrpicklist = result.pbeIdToJSONMap.indexAttrMap.attrpicklist;
                      $scope.setSliderValues();
                 }

                 if(result.pbeIdToJSONMap.prodIdToAttrMap !== undefined){
                      $scope.productIdToAttrbMap = result.pbeIdToJSONMap.prodIdToAttrMap;
                 }

                 if(result.pbeIdToJSONMap.prodIdToReqAttrMap !== undefined){
                      $scope.prodIdToReqAttrMap = result.pbeIdToJSONMap.prodIdToReqAttrMap;
                 }

                 if(result.pbeIdToJSONMap.searchFilter !== undefined){
                      for(key in result.pbeIdToJSONMap.searchFilter) {
                        $scope.searchfilter[key] = result.pbeIdToJSONMap.searchFilter[key];
                      }
                 }
             }
           }
       }else{
                $scope.attributesList = result.pbeIdToJSONMap;
                $scope.genIndexFromAttr($scope.attributesList, true);
       }
       }, function(errorMessage) {
               $scope.productListErrors = errorMessage;
               console.error(errorMessage);
               $scope.isProductsLoading = false;
           });

   };

   $scope.setSliderValues = function() {
       var key;

       // set up min/max values for slider
       for (key in $scope.idx.attrslider) {
           $scope.filterValueSlider[key] = {
               min: $scope.idx.attrslider[key].min,
               max: $scope.idx.attrslider[key].max
           };
       }

       // set up min/max values for date
       for (key in $scope.idx.attrdate) {
           if ($scope.idx.attrdate[key].type === 'Datetime') {
               $scope.idx.attrdate[key].min = $scope.idx.attrdate[key].min.split(' ')[0];
           }

           $scope.filterValueDate[key] = {
               from: $scope.idx.attrdate[key].from,
               to: $scope.idx.attrdate[key].to
           };
       }
   }

   $scope.genIndexFromAttr = function(attr, bInit) {
       // get attribute json from Product
       for(var key in attr){
           if (attr[key]) {
               var alist = [];
                   if (typeof attr[key] === 'string' || attr[key] instanceof String)
                       attr[key] = JSON.parse(attr[key]);

            for (var cat in attr[key]) {
                   var attrs = attr[key][cat];
                   // parse the attributes
                   $scope.parseAttributes(attrs);
                   alist = alist.concat(attrs);
               }

               angular.forEach(alist, function(i) {
                   if (i.SegmentValue && i.Filterable) { // if an attribute has value & if an attribute is filterable
                       var arr = i.SegmentValue.split(','); // split the attribute list

                       var type = 'default';
                       if (i.attributeRunTimeInfo.dataType === 'Text')
                           type = 'text';

                       if (i.attributeRunTimeInfo.dataType === 'Number' || i.attributeRunTimeInfo.dataType === 'Currency' || i.attributeRunTimeInfo.dataType === 'Percent')
                           type = 'slider';
                       if (i.attributeRunTimeInfo.dataType === 'Date' || i.attributeRunTimeInfo.dataType === 'Datetime')
                           type = 'date';
                       if (i.attributeRunTimeInfo.dataType === 'Picklist')
                           type = 'picklist';
                       $scope.idx.attrtype[i.Name+'|'+i.Code] = type;

                       // set up values for picklist
                       if (type === 'picklist') {
                           if ($scope.idx.attrpicklist[i.Name+'|'+i.Code] === undefined) {
                               $scope.idx.attrpicklist[i.Name+'|'+i.Code] = [];
                               $scope.filterValuePicklist[i.Name+'|'+i.Code] = '';
                           }
                       }

                       // set up min/max values for slider
                       var minVal = 0;
                       var maxVal = 100;
                       if (type === 'slider') {
                           if ($scope.idx.attrslider[i.Name+'|'+i.Code] === undefined) {
                               if (i.attributeRunTimeInfo.dataType === 'Percent') {
                                   $scope.idx.attrslider[i.Name+'|'+i.Code] = {min: 0, max: 100, type: i.attributeRunTimeInfo.dataType, active: false};
                               } else if (i.attributeRunTimeInfo.dataType === 'Number' || i.attributeRunTimeInfo.dataType === 'Currency') {
                                   $scope.idx.attrslider[i.Name+'|'+i.Code] = {min: null, max: null, type: i.attributeRunTimeInfo.dataType, active: false};
                              }
                           }
                       }

                       // set up min/max values for date
                       if (type === 'date') {
                           if ($scope.idx.attrdate[i.Name+'|'+i.Code] === undefined) {
                               $scope.idx.attrdate[i.Name+'|'+i.Code] = {min: null, max: null, from: null, to: null, type: i.attributeRunTimeInfo.dataType, active: false};
                           }
                       }

                       angular.forEach(arr, function(a) {
                           // for each attribute Name:Value combination, add the Product to the array
                           if (!$scope.idx.attrval[i.Code+'|'+a])
                               $scope.idx.attrval[i.Code+'|'+a] = [];

                           angular.forEach($scope.products.list, function(l) {
                               if(l.priceBookEntryId === key)
                                   $scope.idx.attrval[i.Code+'|'+a].push(l);
                           });
                           //$scope.idx.attrval[i.Code+'|'+a].push(p); // attrCode:val -> Product hash array

                           if (bInit) {
                               // if bInit, then the UI state of this attribute is defaulted to show:true,Select:false
                               $scope.searchfilter[i.Code+'|'+a] = {show: true, state: false};
                               //$scope.productIdToProdKey[p.priceBookEntryId] = p;
                               //Here key is pricebookentryid
                               if($scope.productIdToAttrbMap[key] == undefined){
                                    $scope.productIdToAttrbMap[key] = [];
                                    $scope.productIdToAttrbMap[key].push(i.Code + '|' + a);
                                }
                                else {
                                    $scope.productIdToAttrbMap[key].push(i.Code + '|' + a);
                                }
                           }

                           // attrName:Code -> Product hash array to differentiate attributes of same Name
                           if (!$scope.idx.attrname[i.Name+'|'+i.Code])
                               $scope.idx.attrname[i.Name+'|'+i.Code] = [];

                           var keyfound = false;
                           angular.forEach($scope.idx.attrname[i.Name+'|'+i.Code], function(v) {
                               if (v === (i.Code+'|'+a))
                                   keyfound = true;
                           });
                           if (!keyfound) {
                               $scope.idx.attrname[i.Name+'|'+i.Code].push(i.Code+'|'+a);
                           }

                           // set up values for picklist
                           if (type === 'picklist') {
                               if (j$.inArray(a, $scope.idx.attrpicklist[i.Name+'|'+i.Code]) < 0)
                                   $scope.idx.attrpicklist[i.Name+'|'+i.Code].push(a);
                           }

                           // set up min/max values for slider
                           if (type === 'slider') {
                               if (i.attributeRunTimeInfo.dataType === 'Number' || i.attributeRunTimeInfo.dataType === 'Currency') {
                                   var num = parseInt(a, 10);

                                   if ($scope.idx.attrslider[i.Name+'|'+i.Code].min === null) {
                                       $scope.idx.attrslider[i.Name+'|'+i.Code].min = num;
                                   } else if (num < $scope.idx.attrslider[i.Name+'|'+i.Code].min) {
                                       $scope.idx.attrslider[i.Name+'|'+i.Code].min = num;
                                   }

                                   if ($scope.idx.attrslider[i.Name+'|'+i.Code].max === null) {
                                       $scope.idx.attrslider[i.Name+'|'+i.Code].max = num;
                                   } else if (num > $scope.idx.attrslider[i.Name+'|'+i.Code].max) {
                                       $scope.idx.attrslider[i.Name+'|'+i.Code].max = num;
                                   }
                               }
                           }

                           // set up min/max values for date
                           if (type === 'date') {
                               var aDate = new Date(a);

                               if ($scope.idx.attrdate[i.Name+'|'+i.Code].min === null) {
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].from = aDate;
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].min = a;
                               } else if (aDate < (new Date($scope.idx.attrdate[i.Name+'|'+i.Code].min))) {
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].from = aDate;
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].min = a;
                               }

                               if ($scope.idx.attrdate[i.Name+'|'+i.Code].max === null) {
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].to = aDate;
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].max = a;
                               } else if (aDate > (new Date($scope.idx.attrdate[i.Name+'|'+i.Code].max))) {
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].to = aDate;
                                   $scope.idx.attrdate[i.Name+'|'+i.Code].max = a;
                               }
                           }
                       });
                   }
               });

               if (bInit) {
                   var key;

                   // set up min/max values for slider
                   for (key in $scope.idx.attrslider) {
                       $scope.filterValueSlider[key] = {
                           min: $scope.idx.attrslider[key].min,
                           max: $scope.idx.attrslider[key].max
                       };
                   }

                   // set up min/max values for date
                   for (key in $scope.idx.attrdate) {
                       if ($scope.idx.attrdate[key].type === 'Datetime') {
                           $scope.idx.attrdate[key].min = $scope.idx.attrdate[key].min.split(' ')[0];
                       }

                       $scope.filterValueDate[key] = {
                           from: $scope.idx.attrdate[key].from,
                           to: $scope.idx.attrdate[key].to
                       };
                   }
               }
           }
       }
   };

    // helper to index product by attribute to search/filter
    $scope.genIndexFromProd = function(p, bInit) {
        // get attribute json from Product
      if($scope.cacheEnabled === 'false') {
        if (p.JSONAttribute) {
            var alist = [];
            if (!p.isAttrParsed) {
                p.JSONAttribute = JSON.parse(p.JSONAttribute);
                p.isAttrParsed = true;
            }

            for (var cat in p.JSONAttribute) {
                var attrs = p.JSONAttribute[cat];
                // parse the attributes
                $scope.parseAttributes(attrs, p);
                alist = alist.concat(attrs);
            }

            angular.forEach(alist, function(i) {
                //preparing attributeCheckMode with prodId
                var attributeCheckMap = {};
                if(i.attributeChecked === true){
                    if($scope.prodIdToReqAttrMap[p.productId] === undefined) {
                      attributeCheckMap.attributeChecked = i.attributeChecked;
                      $scope.prodIdToReqAttrMap[p.productId] = attributeCheckMap;
                    }else{
                      attributeCheckMap = $scope.prodIdToReqAttrMap[p.productId];
                      attributeCheckMap.attributeChecked = i.attributeChecked;
                      $scope.prodIdToReqAttrMap[p.productId] = attributeCheckMap;
                    }
                }
                if (i.SegmentValue && i.Filterable) { // if an attribute has value & if an attribute is filterable
                    var arr = i.SegmentValue.split(','); // split the attribute list

                    var type = 'default';
                    if (i.attributeRunTimeInfo.dataType === 'Text') {
                        type = 'text';
                    }
                    if (i.attributeRunTimeInfo.dataType === 'Number' || i.attributeRunTimeInfo.dataType === 'Currency' || i.attributeRunTimeInfo.dataType === 'Percent') {
                        type = 'slider';
                    }
                    if (i.attributeRunTimeInfo.dataType === 'Date' || i.attributeRunTimeInfo.dataType === 'Datetime') {
                        type = 'date';
                    }
                    if (i.attributeRunTimeInfo.dataType === 'Picklist') {
                        type = 'picklist';
                    }
                    $scope.idx.attrtype[i.Name + '|' + i.Code] = type;

                    // set up values for picklist
                    if (type === 'picklist') {
                        if ($scope.idx.attrpicklist[i.Name + '|' + i.Code] === undefined) {
                            $scope.idx.attrpicklist[i.Name + '|' + i.Code] = [];
                            $scope.filterValuePicklist[i.Name + '|' + i.Code] = '';
                        }
                    }

                    // set up min/max values for slider
                    var minVal = 0;
                    var maxVal = 100;
                    if (type === 'slider') {
                        if ($scope.idx.attrslider[i.Name + '|' + i.Code] === undefined) {
                            if (i.attributeRunTimeInfo.dataType === 'Percent') {
                                $scope.idx.attrslider[i.Name + '|' + i.Code] = {min: 0, max: 100, type: i.attributeRunTimeInfo.dataType, active: false};
                            } else if (i.attributeRunTimeInfo.dataType === 'Number' || i.attributeRunTimeInfo.dataType === 'Currency') {
                                $scope.idx.attrslider[i.Name + '|' + i.Code] = {min: null, max: null, type: i.attributeRunTimeInfo.dataType, active: false};
                            }
                        }
                    }

                    // set up min/max values for date
                    if (type === 'date') {
                        if ($scope.idx.attrdate[i.Name + '|' + i.Code] === undefined) {
                            $scope.idx.attrdate[i.Name + '|' + i.Code] = {min: null, max: null, from: null, to: null, type: i.attributeRunTimeInfo.dataType, active: false};
                        }
                    }

                    angular.forEach(arr, function(a) {
                        // for each attribute Name:Value combination, add the Product to the array
                        if (!$scope.idx.attrval[i.Code + '|' + a]) {
                            $scope.idx.attrval[i.Code + '|' + a] = [];
                        }

                        $scope.idx.attrval[i.Code + '|' + a].push(p); // attrCode:val -> Product hash array

                        if (bInit) {
                            // if bInit, then the UI state of this attribute is defaulted to show:true,Select:false
                            $scope.searchfilter[i.Code + '|' + a] = {show: true, state: false};

                            //CMT-125 to have 'AND' across attributes in attribute filter
                            //productIdToAttrbMap--> [priceBookEntryId] = {'attribute-003|Gold','attribute-001|16GB'}
                            $scope.productIdToProdKey[p.priceBookEntryId] = p;
	                        if($scope.productIdToAttrbMap[p.priceBookEntryId] == undefined){
	                        	$scope.productIdToAttrbMap[p.priceBookEntryId] = [];
	                        	$scope.productIdToAttrbMap[p.priceBookEntryId].push(i.Code + '|' + a);
	                        }
	                        else {
	                        	$scope.productIdToAttrbMap[p.priceBookEntryId].push(i.Code + '|' + a);
	                        }
                        }

                        // attrName:Code -> Product hash array to differentiate attributes of same Name
                        if (!$scope.idx.attrname[i.Name + '|' + i.Code]) {
                            $scope.idx.attrname[i.Name + '|' + i.Code] = [];
                        }

                        var keyfound = false;
                        angular.forEach($scope.idx.attrname[i.Name + '|' + i.Code], function(v) {
                            if (v === (i.Code + '|' + a)) {
                                keyfound = true;
                            }
                        });
                        if (!keyfound) {
                            $scope.idx.attrname[i.Name + '|' + i.Code].push(i.Code + '|' + a);
                        }

                        // set up values for picklist
                        if (type === 'picklist') {
                            if (j$.inArray(a, $scope.idx.attrpicklist[i.Name + '|' + i.Code]) < 0) {
                                $scope.idx.attrpicklist[i.Name + '|' + i.Code].push(a);
                            }
                        }

                        // set up min/max values for slider
                        if (type === 'slider') {
                            if (i.attributeRunTimeInfo.dataType === 'Number' || i.attributeRunTimeInfo.dataType === 'Currency') {
                                var num = parseInt(a, 10);

                                if ($scope.idx.attrslider[i.Name + '|' + i.Code].min === null) {
                                    $scope.idx.attrslider[i.Name + '|' + i.Code].min = num;
                                } else if (num < $scope.idx.attrslider[i.Name + '|' + i.Code].min) {
                                    $scope.idx.attrslider[i.Name + '|' + i.Code].min = num;
                                }

                                if ($scope.idx.attrslider[i.Name + '|' + i.Code].max === null) {
                                    $scope.idx.attrslider[i.Name + '|' + i.Code].max = num;
                                } else if (num > $scope.idx.attrslider[i.Name + '|' + i.Code].max) {
                                    $scope.idx.attrslider[i.Name + '|' + i.Code].max = num;
                                }
                            }
                        }

                        // set up min/max values for date
                        if (type === 'date') {
                            var aDate = new Date(a);

                            if ($scope.idx.attrdate[i.Name + '|' + i.Code].min === null) {
                                $scope.idx.attrdate[i.Name + '|' + i.Code].from = aDate;
                                $scope.idx.attrdate[i.Name + '|' + i.Code].min = a;
                            } else if (aDate < (new Date($scope.idx.attrdate[i.Name + '|' + i.Code].min))) {
                                $scope.idx.attrdate[i.Name + '|' + i.Code].from = aDate;
                                $scope.idx.attrdate[i.Name + '|' + i.Code].min = a;
                            }

                            if ($scope.idx.attrdate[i.Name + '|' + i.Code].max === null) {
                                $scope.idx.attrdate[i.Name + '|' + i.Code].to = aDate;
                                $scope.idx.attrdate[i.Name + '|' + i.Code].max = a;
                            } else if (aDate > (new Date($scope.idx.attrdate[i.Name + '|' + i.Code].max))) {
                                $scope.idx.attrdate[i.Name + '|' + i.Code].to = aDate;
                                $scope.idx.attrdate[i.Name + '|' + i.Code].max = a;
                            }
                        }
                    });
                }
            });

            if (bInit) {
                var key;

                // set up min/max values for slider
                for (key in $scope.idx.attrslider) {
                    $scope.filterValueSlider[key] = {
                        min: $scope.idx.attrslider[key].min,
                        max: $scope.idx.attrslider[key].max
                    };
                }

                // set up min/max values for date
                for (key in $scope.idx.attrdate) {
                    if ($scope.idx.attrdate[key].type === 'Datetime') {
                        $scope.idx.attrdate[key].min = $scope.idx.attrdate[key].min.split(' ')[0];
                    }

                    $scope.filterValueDate[key] = {
                        from: $scope.idx.attrdate[key].from,
                        to: $scope.idx.attrdate[key].to
                    };
                }
            }
        }
      }
    };

    $scope.$watch('searchfilter', function(filterarr) {
        var temp = {}, parr;
        var dofilter = false;
        $scope.selectedProds = '';
        angular.forEach(filterarr, function(fv, k) {
            dofilter = dofilter || fv.state;
        });

        $scope.products.searchresults = [];
        if (!dofilter && $scope.productsFilter.hasResults) {
            if(!$scope.loadPage && $scope.paginationMode === 'true')
                $scope.searchProducts($scope.srchText);
            angular.forEach($scope.products.list, function(i) {
                $scope.products.searchresults.push(i);
            });
            return;
        }
        /*angular.forEach(filterarr, function(fv, k) {
            // for each flag true, get all product s& add to searchresults
            if (fv.state) {
                parr = $scope.idx.attrval[k];
                angular.forEach(parr, function(p) {
                    if (!temp[p.productId]) {
                        $scope.products.searchresults.push(p);
                        temp[p.productId] = true;
                    }
                });
            }
        });*/
        var attrStateTrue = [];
        angular.forEach(filterarr, function(fv, k) {
        	//attributes which has state as true
        	if(fv.state){
        		attrStateTrue.push(k);

        	}
        });

        if($scope.cacheEnabled === 'true') {
            $scope.selectedProds = JSON.stringify(attrStateTrue);
        }else{
          angular.forEach($scope.productIdToAttrbMap, function(attrs,product){
          	var show = true;

          	//get all the attributes for each product
          	var attrMap = {};
          	var attrStateMap = {};
          	var show = false;

          	//get all the attributes of product with the value of each attribute
          	//eg 'Color' = [Gold], 'Memory-Size' = [16GB]
          	for(var i = 0 ; i < attrs.length ; i++){
          		if(attrMap[attrs[i].split('|')[0]] == undefined){
          			attrMap[attrs[i].split('|')[0]] = [];
          			attrMap[attrs[i].split('|')[0]].push(attrs[i].split('|')[1]);
          		}
          		else{
          			attrMap[attrs[i].split('|')[0]].push(attrs[i].split('|')[1]);
          		}
          	}

          	//get all the attributes that have are filtered and should be displayed
          	//eg 'Color' = [Gold,Green1] , 'Memory-Size' = [16GB,32GB] , 'Version' = ['V3']
          	for(var i = 0 ; i < attrStateTrue.length ; i++){
          		if(attrStateMap[attrStateTrue[i].split('|')[0]] == undefined){
          			attrStateMap[attrStateTrue[i].split('|')[0]] = [];
          			attrStateMap[attrStateTrue[i].split('|')[0]].push(attrStateTrue[i].split('|')[1]);
          		}
          		else{
          			attrStateMap[attrStateTrue[i].split('|')[0]].push(attrStateTrue[i].split('|')[1]);
          		}
          	}

          	var attrStateKeys = Object.keys(attrStateMap);
          	var attrKeys = Object.keys(attrMap);

          	var isFound = true;
          	//if all the attributes to be filtered are in the current products attributes
          	for(var i = 0 ; i < attrStateKeys.length ; i++){
          		if(attrKeys.indexOf(attrStateKeys[i]) == -1){
          			isFound = false;
          			break;
          		}
          	}

          	if(isFound){
          		show = true;
          		for(var i = 0 ; i < attrStateKeys.length ; i++){
          			//'And' across attributes in the attribute filter
          			show = show && ((attrStateMap[attrStateKeys[i]] != undefined) &&
          						   (attrStateMap[attrStateKeys[i]].some(function (e) { return attrMap[attrStateKeys[i]].indexOf(e) >= 0})));
          		}
          	}

          	//if all the attribute value matches
          	if(show){
                  if($scope.paginationMode === 'false'){
          		  $scope.products.searchresults.push($scope.productIdToProdKey[product]);
                  }
                  else{
                      $scope.selectedProds = $scope.selectedProds + '\'' + product + '\',';
                  }

          	}
          });
        }

        if($scope.paginationMode === 'true') {
             $scope.searchProducts($scope.srchText);
        }

        //setting state back to false
        /*angular.forEach(filterarr, function(fv, k) {
            fv.state = false;
        });*/
    }, true);

    $scope.$watch('searchText', function(newSearchVal) {
        if($scope.paginationMode === 'false') {
            $scope.idx.attrval = {};
            $scope.idx.attrname = {};
            $scope.idx.attrtype = {};
            $scope.idx.attrslider = {};
            $scope.idx.attrdate = {};
        }
        $scope.srchText = newSearchVal;
        if(!$scope.loadPage && $scope.paginationMode === 'true' && newSearchVal == ''){
            $scope.srchText = '';
            $scope.getProductList();
        }
    }, true);

    $scope.$watch('pricebook', function(newval) {
        if (newval !== null) {
            prodConfigService.setPricebook($scope.ctx.itemId, newval).then(function(result) {
                $scope.init();
                $scope.bSelectPricebook = false;
            }, function(errorMessage) {
                console.error(errorMessage);
            });
        }
    }, true);

    $scope.filterByAttrText = function(key, items) {

        var value = $scope.filterValueText[key].toLowerCase();
        var resultCount = 0;
        angular.forEach(items, function(item) {
            var itemVal = item.split('|')[1];
            var match = (itemVal.toLowerCase().indexOf(value) !== -1);
            if (match) {
                resultCount++;
            }
            $scope.searchfilter[item].state = (value === '' ? false : match);
        });
        $scope.productsFilter.hasTextResults = (value === '' ? true : (resultCount > 0));
    };

    $scope.$watch('productsFilter.hasTextResults', function(newValue) {
        $scope.productsFilter.hasResults = newValue && $scope.productsFilter.hasSliderResults && $scope.productsFilter.hasDateResults;
    });

    $scope.filterByAttrSlider = function(key, items, updateValues) {
        if ($scope.idx.attrslider[key].active) {
            var minVal = $scope.filterValueSlider[key].min;
            var maxVal = $scope.filterValueSlider[key].max;
            var resultCount = 0;
            angular.forEach(items, function(item) {
                var itemVal = parseInt(item.split('|')[1], 10);
                var match = (minVal <= itemVal && itemVal <= maxVal);
                if (match) {
                    resultCount++;
                }
                $scope.searchfilter[item].state = match;
            });
            $scope.productsFilter.hasSliderResults = (resultCount > 0);

            if (updateValues) {
                $scope.$apply();
            }
        } else {
            angular.forEach(items, function(item) {
                $scope.searchfilter[item].state = false;
            });
            $scope.productsFilter.hasSliderResults = true;
        }
    };

    $scope.$watch('productsFilter.hasSliderResults', function(newValue) {
        $scope.productsFilter.hasResults = $scope.productsFilter.hasTextResults && newValue && $scope.productsFilter.hasDateResults;
    });

    $scope.filterByAttrDate = function(key, items) {
        if ($scope.idx.attrdate[key].active) {
            var minDate = new Date($scope.idx.attrdate[key].min);
            var maxDate = new Date($scope.idx.attrdate[key].max);

            if ($scope.filterValueDate[key].from === undefined) {
                $scope.filterValueDate[key].from = $scope.idx.attrdate[key].from;
            }
            var fromDate = $scope.filterValueDate[key].from;

            if ($scope.filterValueDate[key].to === undefined) {
                $scope.filterValueDate[key].to = $scope.idx.attrdate[key].to;
            }
            var toDate = $scope.filterValueDate[key].to;

            if($scope.cacheEnabled === 'true'){
              if(fromDate !== undefined && fromDate !== null)
                fromDate = new Date(fromDate);
              if(toDate !== undefined && toDate !== null)
                toDate = new Date(toDate);
            }

            var resultCount = 0;
            angular.forEach(items, function(item) {
                var itemVal = item.split('|')[1];
                var itemDate = new Date(itemVal);
                var match = (fromDate <= itemDate && itemDate <= toDate);
                if (match) {
                    resultCount++;
                }
                $scope.searchfilter[item].state = match;
            });
            $scope.productsFilter.hasDateResults = (resultCount > 0);
        } else {
            angular.forEach(items, function(item) {
                $scope.searchfilter[item].state = false;
            });
            $scope.productsFilter.hasDateResults = true;
        }
    };

    $scope.$watch('productsFilter.hasDateResults', function(newValue) {
        $scope.productsFilter.hasResults = $scope.productsFilter.hasTextResults && $scope.productsFilter.hasSliderResults && newValue;
    });

    $scope.filterByAttrPicklist = function(key, items) {
        angular.forEach(items, function(item) {
            var itemVal = item.split('|')[1];
            $scope.searchfilter[item].state = ($scope.filterValuePicklist[key] === itemVal);
        });
    };

    /* parse the attributes */
    $scope.parseAttributes = function(attrs, product) {
        angular.forEach(attrs, function(attr) {
            attr.Name = attr.attributedisplayname__c;
            attr.Code = attr.attributeuniquecode__c;
            attr.Filterable = attr.attributefilterable__c;
            var isRequired = attr.isrequired__c;
            attr.SegmentValue = '';

            if (attr.attributeRunTimeInfo && attr.attributeRunTimeInfo.dataType) {
                var isBoundAttribute = $scope.attributeCodeToField && $scope.attributeCodeToField[attr.attributeuniquecode__c] ? true : false;
                if (attr.attributeRunTimeInfo.dataType === 'Text') {
                    // TEXT
                    if(isRequired === true && (attr.attributeRunTimeInfo.default === null || attr.attributeRunTimeInfo.default === undefined))
                          attr.attributeChecked = true;
                    if(isBoundAttribute && product){
                        if(product.attributeValues && product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]]){
                            attr.attributeRunTimeInfo.value = product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]];
                        } else if(product.contextId){
                            attr.attributeRunTimeInfo.value = '';
                        }

                    } else {
                        if (attr.attributeRunTimeInfo.value === undefined) {
                            attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                        }

                    }

                    attr.SegmentValue = attr.attributeRunTimeInfo.value;
                }
                if (attr.attributeRunTimeInfo.dataType === 'Number' || attr.attributeRunTimeInfo.dataType === 'Currency' || attr.attributeRunTimeInfo.dataType === 'Percent') {
                    // NUMBER, CURRENCY, PERCENT
                    if ((typeof attr.attributeRunTimeInfo.default) === 'string') {
                        // convert default to number, if string
                        attr.attributeRunTimeInfo.default = parseFloat(attr.attributeRunTimeInfo.default);
                    }

                    if(isRequired === true && (attr.attributeRunTimeInfo.default === null || attr.attributeRunTimeInfo.default === undefined))
                          attr.attributeChecked = true;

                    if(isBoundAttribute && product) {
                        if(product.attributeValues && product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]]){
                            attr.attributeRunTimeInfo.value = product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]];
                        } else if(product.contextId){
                            attr.attributeRunTimeInfo.value = '';
                        }
                    } else {
                        if (attr.attributeRunTimeInfo.value === undefined) {
                            attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                        } else {
                            if ((typeof attr.attributeRunTimeInfo.value) === 'string') {
                                // convert value to number, if string
                                attr.attributeRunTimeInfo.value = parseFloat(attr.attributeRunTimeInfo.value);
                            }
                        }
                    }

                    if(attr.attributeRunTimeInfo.value)
                        attr.SegmentValue = attr.attributeRunTimeInfo.value + '';
                    else
                        attr.SegmentValue = attr.attributeRunTimeInfo.value;
                }
                if (attr.attributeRunTimeInfo.dataType === 'Date' || attr.attributeRunTimeInfo.dataType === 'Datetime') {
                    // DATE, DATETIME

                    if(isRequired === true && (attr.attributeRunTimeInfo.default === null || attr.attributeRunTimeInfo.default === undefined))
                          attr.attributeChecked = true;

                    if(isBoundAttribute && product) {
                        if(product.attributeValues && product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]]){
                            attr.attributeRunTimeInfo.value = product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]];
                        } else if(product.contextId){
                            attr.attributeRunTimeInfo.value = '';
                        }
                    } else {
                       if (attr.attributeRunTimeInfo.value === undefined) {
                            attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                        }
                    }

                    var dateFormat = (attr.attributeRunTimeInfo.dataType === 'Date' ? 'shortDate' : 'short');
                    attr.SegmentValue = $filter('date')(attr.attributeRunTimeInfo.value, dateFormat);
                }
                if (attr.attributeRunTimeInfo.dataType === 'Checkbox') {
                    // CHECKBOX

                    if(isRequired === true && (attr.attributeRunTimeInfo.default === null || attr.attributeRunTimeInfo.default === undefined))
                          attr.attributeChecked = true;

                    if(isBoundAttribute && product) {
                        if(product.attributeValues && product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]]){
                            attr.attributeRunTimeInfo.value = product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]] == 'true' ? true : false;
                        } else if(product.contextId){
                            attr.attributeRunTimeInfo.value = false;
                        }
                    } else {
                        if (attr.attributeRunTimeInfo.value === undefined) {
                            attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                        }
                    }
                    attr.SegmentValue = (attr.attributeRunTimeInfo.value ? 'Yes' : 'No');
                }
                if (attr.attributeRunTimeInfo.dataType === 'Picklist') {
                    // PICKLIST - RADIO BUTTON & DROPDOWN
                    var tempSegmentList = [];
                    if(isRequired === true && (attr.attributeRunTimeInfo.default === null || attr.attributeRunTimeInfo.default === undefined || attr.attributeRunTimeInfo.default.length === 0))
                          attr.attributeChecked = true;

                    if(isBoundAttribute && product) {
                        if(product.attributeValues && product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]]){
                            selectedValue = product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]];
                            angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                                if (!value.ishidden__c && value.displayText === selectedValue) {
                                    attr.attributeRunTimeInfo.selectedItem = value;
                                }
                                if(!value.ishidden__c)
                                    tempSegmentList.push(value.displayText);
                            });
                        } else if(product.contextId){
                            attr.attributeRunTimeInfo.selectedItem  = {};
                        }
                    } else {
                        var selectedId;
                        if (attr.attributeRunTimeInfo.selectedItem === undefined) {
                            if (attr.attributeRunTimeInfo.default !== undefined && attr.attributeRunTimeInfo.default.length > 0) {
                                selectedId = attr.attributeRunTimeInfo.default[0].id;
                            }
                        } else {
                            selectedId = attr.attributeRunTimeInfo.selectedItem.id;
                        }
                        angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                            if (!value.ishidden__c && value.id === selectedId) {
                                attr.attributeRunTimeInfo.selectedItem = value;
                            }
                            if(!value.ishidden__c)
                                tempSegmentList.push(value.displayText);
                        });
                    }

                    attr.SegmentValue = tempSegmentList.join(',');
                }
                if (attr.attributeRunTimeInfo.dataType === 'Multi Picklist') {
                    // MULTI PICKLIST
                    var tempSegmentList = [];
                    if (attr.attributeRunTimeInfo.uiDisplayType === 'Checkbox') {
                        // CHECKBOX
                        if(isRequired === true && (attr.attributeRunTimeInfo.default === null || attr.attributeRunTimeInfo.default === undefined || attr.attributeRunTimeInfo.default.length === 0))
                           attr.attributeChecked = true;
                        if(isBoundAttribute && product) {
                            if(product.attributeValues && product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]]){
                                selectedValuesString = product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]];
                                selectedValues = selectedValuesString.split(';');
                                angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                                    var found = selectedValues.some(function (selectedValue) {
                                        return (!value.ishidden__c && selectedValue === value.displayText);
                                    });
                                    value.checked = found;

                                });
                            } else if(product.contextId){
                                angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                                    value.checked = false;
                                });
                            }
                        } else {
                            angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                                if (value.checked === undefined) {
                                    var found = attr.attributeRunTimeInfo.default.some(function (el) {
                                        return (!value.ishidden__c && el.id === value.id);
                                    });
                                    value.checked = found;
                                }
                                if (!value.ishidden__c) {
                                    tempSegmentList.push(value.displayText);
                                }
                            });
                        }

                    }
                    if (attr.attributeRunTimeInfo.uiDisplayType === 'Dropdown') {
                        // DROPDOWN
                        if(isRequired === true && (attr.attributeRunTimeInfo.default === null || attr.attributeRunTimeInfo.default === undefined || attr.attributeRunTimeInfo.default.length === 0))
                            attr.attributeChecked = true;
                        if(isBoundAttribute && product) {
                            if(product.attributeValues && product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]]){
                                attr.attributeRunTimeInfo.selectedItems = [];
                                selectedValuesString = product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]];
                                selectedValues = selectedValuesString.split(';');
                                angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                                    for (var i = 0; i < selectedValues.length; i++) {
                                        if (!value.ishidden__c && value.displayText === selectedValues[i]) {
                                            attr.attributeRunTimeInfo.selectedItems.push(value);
                                            break;
                                        }
                                    }
                                });
                            } else if(product.contextId){
                                attr.attributeRunTimeInfo.selectedItems = [];
                            }
                        } else {
                            if (attr.attributeRunTimeInfo.selectedItems === undefined) {
                                attr.attributeRunTimeInfo.selectedItems = [];
                                angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                                    for (var i = 0; i < attr.attributeRunTimeInfo.default.length; i++) {
                                        if (!value.ishidden__c && value.id === attr.attributeRunTimeInfo.default[i].id) {
                                            attr.attributeRunTimeInfo.selectedItems.push(value);
                                            break;
                                        }
                                    }
                                });
                            }
                        }
                        angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                            tempSegmentList.push(value.displayText);
                        });
                    }
                    attr.SegmentValue = tempSegmentList.join(',');
                }
            }

            delete attr.$$AttributeDefinitionEnd$$;
            attr.$$AttributeDefinitionEnd$$ = null;
        });
    };

    //parse the attributes in prod conf
    $scope.parseAttributesInDef = function(attrs) {
      angular.forEach(attrs, function(attr) {
        attr.Name = attr.attributedisplayname__c;
        attr.Code = attr.attributeuniquecode__c;
        attr.Filterable = attr.attributefilterable__c;
        attr.SegmentValue = '';

        if (attr.attributeRunTimeInfo && attr.attributeRunTimeInfo.dataType) {
            if (attr.attributeRunTimeInfo.dataType === 'Text') {
                // TEXT
                if (attr.attributeRunTimeInfo.value === undefined) {
                    attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                }
                attr.SegmentValue = attr.attributeRunTimeInfo.value;
            }
            if (attr.attributeRunTimeInfo.dataType === 'Number' || attr.attributeRunTimeInfo.dataType === 'Currency' || attr.attributeRunTimeInfo.dataType === 'Percent') {
                // NUMBER, CURRENCY, PERCENT
                if ((typeof attr.attributeRunTimeInfo.default) === 'string') {
                    // convert default to number, if string
                    attr.attributeRunTimeInfo.default = parseFloat(attr.attributeRunTimeInfo.default);
                }

                if (attr.attributeRunTimeInfo.value === undefined) {
                    attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                } else {
                    if ((typeof attr.attributeRunTimeInfo.value) === 'string') {
                        // convert value to number, if string
                        attr.attributeRunTimeInfo.value = parseFloat(attr.attributeRunTimeInfo.value);
                    }
                }

                attr.SegmentValue = attr.attributeRunTimeInfo.value + '';
            }
            if (attr.attributeRunTimeInfo.dataType === 'Date' || attr.attributeRunTimeInfo.dataType === 'Datetime') {
                // DATE, DATETIME
                if (attr.attributeRunTimeInfo.value === undefined) {
                    attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                }
                var dateFormat = (attr.attributeRunTimeInfo.dataType === 'Date' ? 'shortDate' : 'short');
                attr.SegmentValue = $filter('date')(attr.attributeRunTimeInfo.value, dateFormat);
            }
            if (attr.attributeRunTimeInfo.dataType === 'Checkbox') {
                // CHECKBOX
                if (attr.attributeRunTimeInfo.value === undefined) {
                    attr.attributeRunTimeInfo.value = attr.attributeRunTimeInfo.default;
                }
                attr.SegmentValue = (attr.attributeRunTimeInfo.value ? 'Yes' : 'No');
            }
            if (attr.attributeRunTimeInfo.dataType === 'Picklist') {
                // PICKLIST - RADIO BUTTON & DROPDOWN
                var selectedId;
                if (attr.attributeRunTimeInfo.selectedItem === undefined) {
                    if (attr.attributeRunTimeInfo.default !== undefined && attr.attributeRunTimeInfo.default.length > 0) {
                        selectedId = attr.attributeRunTimeInfo.default[0].id;
                    }
                } else {
                    selectedId = attr.attributeRunTimeInfo.selectedItem.id;
                }
                angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                    if (!value.ishidden__c && value.id === selectedId) {
                        attr.attributeRunTimeInfo.selectedItem = value;
                        attr.SegmentValue = value.displayText;
                    }
                });
            }
            if (attr.attributeRunTimeInfo.dataType === 'Multi Picklist') {
                // MULTI PICKLIST
                var tempSegmentList = [];
                if (attr.attributeRunTimeInfo.uiDisplayType === 'Checkbox') {
                    // CHECKBOX
                    angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                        if (value.checked === undefined) {
                            var found = attr.attributeRunTimeInfo.default.some(function (el) {
                                return (!value.ishidden__c && el.id === value.id);
                            });
                            value.checked = found;
                        }
                        if (value.checked) {
                            tempSegmentList.push(value.displayText);
                        }
                    });
                }
                if (attr.attributeRunTimeInfo.uiDisplayType === 'Dropdown') {
                    // DROPDOWN
                    if (attr.attributeRunTimeInfo.selectedItems === undefined) {
                        attr.attributeRunTimeInfo.selectedItems = [];
                        angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                            for (var i = 0; i < attr.attributeRunTimeInfo.default.length; i++) {
                                if (!value.ishidden__c && value.id === attr.attributeRunTimeInfo.default[i].id) {
                                    attr.attributeRunTimeInfo.selectedItems.push(value);
                                    break;
                                }
                            }
                        });
                    }
                    angular.forEach(attr.attributeRunTimeInfo.selectedItems, function(value) {
                        tempSegmentList.push(value.displayText);
                    });
                }
                attr.SegmentValue = tempSegmentList.join(',');
            }

            delete attr.$$AttributeDefinitionEnd$$;
            attr.$$AttributeDefinitionEnd$$ = null;
        }
        });
    };

/* get the cart items CMT-723*/
    $scope.getCartItems = function(productId) {
        $scope.isCartLoading = true;
            $scope.perfstart("getCartItems");
            $scope.perfstart("deleteImplSavedLineItems");
             if ( !$scope.cpqPerfMode.flag)
             {
                      prodConfigService.deleteImplSavedLineItems($scope.ctx.itemId).then(function(result){
                                  $scope.perfstop("deleteImplSavedLineItems");          

                      prodConfigService.getCartItems($scope.ctx.itemId).then(function(result) {
                        $scope.perfstop("getCartItems");          
                        
                        $scope.validateItems(result);
                        // render the cart items
                        $scope.renderCartItems(result, 'expandNone', productId);
                      }, function(errorMessage) {
                            $scope.cartItemsError = errorMessage;
                            console.error(errorMessage);
                            $scope.isCartLoading = false;
                    });
                  });
                }
                else
                {

                      prodConfigService.getCartItems($scope.ctx.itemId).then(function(result) {
                        $scope.perfstop("getCartItems");          

                        $scope.validateItems(result);
                        // render the cart items
                        $scope.renderCartItems(result, 'expandNone', productId);
                      }, function(errorMessage) {
                            $scope.cartItemsError = errorMessage;
                            console.error(errorMessage);
                            $scope.isCartLoading = false;
                    });
                }
    };
 
        /* get the cart items CMT-723 */
    $scope.getCartDetails = function(refreshMode) {
           $scope.refreshSpinner = true;

          $scope.perfstart("getCartDetails");
          prodConfigService.getCartDetails($scope.ctx.itemId, refreshMode).then(function(result) { 
              // render the cart items

              $scope.perfstop("getCartDetails");   
              $scope.validateItems(result);                     
              $scope.renderCartItems(result, 'expandNone', null);
               $scope.refreshSpinner = false;
          }, function(errorMessage) {
              $scope.cartItemsError = errorMessage;
              console.error(errorMessage);
               $scope.refreshSpinner = false;
          }); 
    };
    $scope.getCpqSettings = function(key) { 
          prodConfigService.getCpqSettings(key).then(function(result) { 
              // render the cart items 
              $scope.cpqSettings[key] = result.toString().toLowerCase(); //CMT-723
              $scope.cpqPerfMode.flag = ($scope.cpqSettings[key] == null || $scope.cpqSettings[key] == "false") ? false: true;
              console.log("cpq Settings : "+ key + " : "+ result)
;          }, function(errorMessage) {
              $scope.cartItemsError = errorMessage;  
          }); 
    };

    $scope.validateItems = function(items) {
        $scope.cartErrors = [];
        var rootId;
        var allItems = items;
        angular.forEach(items, function(prod) {
            if (prod.itemSObject[$scope.nsPrefix + 'JSONAttribute__c'] !== undefined) {
                var JSONAttr = prod.itemSObject[$scope.nsPrefix + 'JSONAttribute__c'];
                var attrId = $scope.checkRequiredAttr(JSONAttr);
                if (attrId.length > 0) {
                    for (var i = 0; i < attrId.length; i++) {
                        var xlId = prod.itemSObject.Id;
                        var error = {};
                        if (prod.isRoot) {
                            rootId = prod.itemSObject.Id;
                        } else {
                            var levels = prod.lineNumber.split('.');
                            rootId = $scope.getIdFromLineNumber(levels[0], allItems);
                        }
                        var prodName = prod.itemSObject.PricebookEntry.Product2.Name;
                        error.key = rootId;
                        error.xlId = xlId;
                        error.attrId = attrId[i];
                        error.message = 'Required fields are missing for ' + prodName;
                        $scope.cartErrors.push(error);
                    }
                }
            }
        });
    };

    $scope.validateProducts = function(prodList) {
        var rootId;
        var allItems = prodList;
        if (prodList !== undefined) {
            for (var i = 0; i < prodList.length; i++) {
                var attrId = null;
                var prod = prodList[i];
                if (prod.isRoot) {
                    $scope.productErrors = [];
                }
                if (prod.quantity > 0 && prod.JSONAttribute) {
                    var JSONAttr = prod.JSONAttribute;
                    attrId = $scope.checkRequiredAttr(JSONAttr);
                }
                if (attrId !== undefined &&  attrId !== null) {
                    for (var j = 0; j < attrId.length; j++) {
                        var xlId = prod.contextId;
                        var error = {};
                        if (prod.isRoot) {
                            rootId = prod.contextId;
                        } else {
                            var levels = prod.lineNumber.split('.');
                            rootId = $scope.getContextIdFromLineNumber(levels[0], allItems);
                        }
                        var prodName = prod.Name;
                        error.key = rootId;
                        error.xlId = xlId;
                        error.attrId = attrId[j];
                        error.message = 'Required fields are missing for ' + prodName;
                        $scope.productErrors.push(error);
                    }
                }
                if (prod.children !== undefined && prod.quantity > 0) {
                    $scope.validateProducts(prod.children);
                }
            }
        }
        if ($scope.productErrors.length > 0 && ($scope.prodAttribMode === 'true')) {
            $scope.disableAddToCartButton = true;
        } else {
            $scope.disableAddToCartButton = false;
        }
    };

    $scope.getIdFromLineNumber = function(lineNum, items) {
        for (var i = 0; i < items.length; i++) {
            var prod = items[i];
            if (prod.lineNumber === lineNum) {
                return prod.itemSObject.Id;
            }
        }
    };

    $scope.getContextIdFromLineNumber = function(lineNum, items) {
        for (var i = 0; i < items.length; i++) {
            var prod = items[i];
            if (prod.lineNumber === lineNum) {
                return prod.contextId;
            }
        }
    };

    $scope.checkRequiredAttr = function(JSONAttr) {
        var attrId = [];
        if (typeof JSONAttr === 'string' || JSONAttr instanceof String) {
            productAttributesObject = JSON.parse(JSONAttr);
        } else {
            productAttributesObject = JSONAttr;
        }

        angular.forEach(productAttributesObject, function(categoryContext, categoryName) {
                attributeObject = productAttributesObject[categoryName];
                $scope.parseAttributesInDef(attributeObject);
                angular.forEach(attributeObject, function(attrib) {
                    if (attrib.isrequired__c) {
                        if (attrib.attributeRunTimeInfo.dataType === 'Multi Picklist') {
                            if (attrib.attributeRunTimeInfo.uiDisplayType === 'Checkbox') {
                                var found = false;
                                angular.forEach(attrib.attributeRunTimeInfo.values, function(value) {
                                    if (value.checked) {
                                        found = true;
                                    }
                                });
                                if (!found) {
                                    attrId.push(attrib.id);
                                }
                            }
                            if (attrib.attributeRunTimeInfo.uiDisplayType === 'Dropdown') {
                                if (attrib.attributeRunTimeInfo.selectedItems === undefined || attrib.attributeRunTimeInfo.selectedItems.length === 0) {
                                    attrId.push(attrib.id);
                                }
                            }
                        } else if (attrib.attributeRunTimeInfo.dataType === 'Picklist') {
                            if (attrib.attributeRunTimeInfo.selectedItem === undefined || attrib.attributeRunTimeInfo.selectedItem.length === 0) {
                                attrId.push(attrib.id);
                            }
                        } else {
                            if (attrib.attributeRunTimeInfo.value === undefined || attrib.attributeRunTimeInfo.value === '') {
                                attrId.push(attrib.id);
                            }
                        }
                    }
               });
        });
        return attrId;
    };

    /* render the cart items */
    $scope.renderCartItems = function(items, expandType, productId) {
        $scope.isCartLoading = true;
        $scope.cartItems = [];
        var numErrors = 0;
        var prevIdx = 0;
        angular.forEach(items, function(prod, idx) {
            if (prod.indent === 0 && idx > 0) {
                var tempProdList = items.slice(prevIdx, idx);
                var tempProdHierarchy = $scope.createProductHierarchy(tempProdList, expandType);
                $scope.cartItems.push(tempProdHierarchy[0]);
                prevIdx = idx;
            }

            if (prod.indent === 0) {
                expandType = (prod.productId === productId ? 'expandAll' : 'expandNone');
            }

            if (prod.errors.length > 0 && prod.errors[0].indexOf('recommends') === -1) {
                numErrors++;
            }
        });
        if (prevIdx < items.length) {
            var tempProdList = items.slice(prevIdx, items.length);
            var tempProdHierarchy = $scope.createProductHierarchy(tempProdList, expandType);
            $scope.cartItems.push(tempProdHierarchy[0]);
        }
        $scope.buttonStatus.isCreateButtonEnabled = (numErrors === 0);

        //trigger the update summary
		j$(window).trigger('updateSummary');

        $scope.isCartLoading = false;
    };

    /* get contextual data */
    $scope.getContextualData = function() {
        paramsMap = {};
        paramsMap.objectId = $scope.ctx.itemId;
        prodConfigService.getContextualData(JSON.stringify(paramsMap)).then(function(result){
            if(result){
                $scope.attributeCodeToField = result.attributeCodeToField;

            }

        })

    };

    /* initialize the app */
    $scope.init = function() {
        console.log('init order manager..');
        // fetch the pricebooks
        prodConfigService.getPricebooks($scope.ctx.itemId).then(function(result) {
            if (!result) {
                $scope.bSelectPricebook = false;

                // get the custom setting for pagination mode
                prodConfigService.checkPaginationMode($scope.ctx.itemId).then(function(result) {
                    if(result !== undefined && result !== null)
                        $scope.paginationMode = result.toString().toLowerCase();
                });

                // get the custom setting for cache mode
                prodConfigService.checkCacheEnabled().then(function(result) {
                    if(result !== undefined && result !== null)
                        $scope.cacheEnabled = result.toString().toLowerCase();
                    if($scope.cacheEnabled === 'true')
                        $scope.paginationMode = 'true';
                });

                    //get the complete Attributes list
                    $scope.getAttributes();

                    // get the product list
                    $scope.getProductList();

            } else if (result.length === 0) {
                $scope.showPricebookError = true;
                $scope.isProductsLoading = false;
                $scope.bSelectPricebook = false;
            } else if (result.length > 0) {
                $scope.bSelectPricebook = true;
                angular.forEach(result, function(item) {
                    $scope.pricebooks.push(item);
                });

                $scope.isProductsLoading = false;

            }
        }, function(errorMessage) {
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });

        //get Contextual datat
        $scope.getContextualData();

  // refresh the cart // use getCartDetails with refreshmode = 
          prodConfigService.getCpqSettings("CpqPerfMode").then(function(result) { 
              // render the cart items 
                  if (result !== null)
                     $scope.cpqSettings["CpqPerfMode"] = result.toString().toLowerCase(); //CMT-723 This mode is to SHOW/HIDE price/validation buttons
                  else 
                     $scope.cpqSettings["CpqPerfMode"] = "false"; 

                   $scope.cpqPerfMode.flag = ($scope.cpqSettings["CpqPerfMode"]   == "false") ? false: true;
                   console.log("cpq Settings : CpqPerfMode : "+ result);
                   $scope.getCartItems(); 
               }, function(errorMessage) {
              $scope.cartItemsError = errorMessage;  
          }); 
        
        // get the custom setting for save mode
        prodConfigService.getProdConfigSaveMode().then(function(result) {
            if(result !== undefined && result !== null)
              $scope.saveMode = result.toString().toLowerCase();
        });


        // get the setting for contract signature
        prodConfigService.isSignatureRequired($scope.ctx.itemId).then(function(result) {
            $scope.isSignatureRequired = result;
        });

        //get disable Add To cart mode
        prodConfigService.getProdAttribCheckMode().then(function(result) {
            if (result !== null && result !== undefined) {
                $scope.prodAttribMode = result.toString().toLowerCase();
            }
        });

        // get the custom setting for Product configuration (Expand/Collapsed)
        prodConfigService.getProdConfMode().then(function(result) {
          if(result !== undefined && result !== null)
            $scope.prodConfMode = result.toString().toLowerCase();
        });
    };

    $scope.init();

    $scope.resizePanels = function() {
        var windowHeight = j$(window).height();
        var orderPanelHeight = j$('#summaryConfig').outerHeight(true);
        var prodErrorsHeight = j$('#prodCfgErrors').outerHeight(true);
        var cartErrorsHeight = j$('#cartCfgErrors').outerHeight(true);
        $scope.filterItemsHeight = Math.floor(windowHeight - orderPanelHeight - 80) + 'px';
        $scope.productListHeight = Math.floor(windowHeight - orderPanelHeight - 50) + 'px';
        $scope.cartHeight = Math.floor(windowHeight - orderPanelHeight - cartErrorsHeight - 120) + 'px';
        $scope.cfgProdHeight = Math.floor(windowHeight - orderPanelHeight - prodErrorsHeight - 75) + 'px';
    };

    /* get the full product list */
    $scope.getProductList = function(errorsArray, pricebookEntryId) {
        $scope.isProductsLoading = true;
        $scope.products = {list:[], searchresults:[]};
        $scope.configurableProdIds = [];
        prodConfigService.getProducts($scope.ctx.itemId).then(function(results) {
            $scope.hasNext = results.hasNext;
            $scope.hasPrevious = results.hasPrevious;
            $scope.currentIndex = results.currentIndex;
            angular.forEach(results.Products, function(item, idx) {
                if($scope.productIdToAttrbMap !== undefined && $scope.productIdToAttrbMap !== null) {
                    if($scope.productIdToAttrbMap[item.priceBookEntryId] !== undefined && $scope.productIdToAttrbMap[item.priceBookEntryId] !== null){
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }
                if($scope.attributesList !== undefined && $scope.attributesList !== null) {
                    if($scope.attributesList[item.priceBookEntryId] !== undefined && $scope.attributesList[item.priceBookEntryId] !== null){
                        item.JSONAttribute = $scope.attributesList[item.priceBookEntryId];
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }
                if (item.orderActive) {
                    $scope.orderActive = true;
                }
                if ($scope.prodAttribMode === 'true') {
                    $scope.configurableProdIds.push(item.priceBookEntryId);
                }
                if(errorsArray && item.priceBookEntryId == pricebookEntryId){
                  item.errors = errorsArray;
                }
                $scope.products.list.push(item);
                $scope.products.searchresults.push(item);

                if (idx === (results.Products.length - 1)) {
                    $scope.resizePanels();
                }

                if(item.JSONAttribute)
                  $scope.genIndexFromProd(item, true);

            });
            if(results.Products && results.Products.length === 0){
                $scope.resizePanels();
                $scope.isProductsLoading = false;
            }
            if($scope.searchfilter !== undefined){
              for(key in $scope.searchfilter) {
                $scope.searchfilter[key] = {show: true, state: false};
              }
            }

            if($scope.configurableProdIds !== undefined && $scope.configurableProdIds.length > 0) {
                var confProdIds = JSON.stringify($scope.configurableProdIds);
                prodConfigService.getProductForAttribCheckMode(confProdIds).then(function(result) {
                if(result !== undefined)
                      $scope.rootIdToChildMap = result;
                if($scope.products.searchresults !== undefined && $scope.products.searchresults.length > 0) {
                      angular.forEach($scope.products.searchresults, function(item, idx) {
                          if(item.traversed === undefined || !item.traversed) {
                              item.addToCart = false;
                              if($scope.prodIdToReqAttrMap[item.productId]) {
                                  item.addToCart = true;
                              } else {
                                var childItems = $scope.rootIdToChildMap[item.productId];
                                if(childItems !== undefined){
                                    for(var key in childItems) {
                                        if(childItems[key] > 0) {
                                            if($scope.prodIdToReqAttrMap[key]) {
                                                item.addToCart = true;
                                                break;
                                            }
                                        }
                                    }
                                }
                              }
                              item.traversed = true;
                          }
                      });
                  }
                  $scope.isProductsLoading = false;
              });
            }

            $scope.loadPage = false;
            if ($scope.prodAttribMode === undefined || $scope.prodAttribMode === 'false')
                $scope.isProductsLoading = false;
        }, function(errorMessage) {
            $scope.productListErrors = errorMessage;
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });
    };

    /* get the search products list */
    $scope.searchProducts = function(searchText) {
        $scope.isProductsLoading = true;
        $scope.products = {list:[], searchresults:[]};
        prodConfigService.searchProducts($scope.ctx.itemId, searchText, $scope.selectedProds, $scope.sortby.name).then(function(results) {
            $scope.srchText = searchText;
            $scope.hasNext = results.hasNext;
            $scope.hasPrevious = results.hasPrevious;
            $scope.currentIndex = results.currentIndex;
            angular.forEach(results.Products, function(item, idx) {
                if($scope.productIdToAttrbMap !== undefined && $scope.productIdToAttrbMap !== null) {
                    if($scope.productIdToAttrbMap[item.priceBookEntryId] !== undefined && $scope.productIdToAttrbMap[item.priceBookEntryId] !== null){
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }
                if($scope.attributesList !== undefined && $scope.attributesList !== null) {
                    if($scope.attributesList[item.priceBookEntryId] !== undefined && $scope.attributesList[item.priceBookEntryId] !== null){
                        item.JSONAttribute = $scope.attributesList[item.priceBookEntryId];
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }

                $scope.products.list.push(item);
                $scope.products.searchresults.push(item);

                if (idx === (results.Products.length - 1)) {
                    $scope.resizePanels();
                }

                if(item.JSONAttribute)
                    $scope.genIndexFromProd(item, false);

                if (item.orderActive) {
                    $scope.orderActive = true;
                }

                if ($scope.prodAttribMode === 'true') {
                    $scope.configurableProdIds.push(item.priceBookEntryId);
                }
            });

            if(results.Products && results.Products.length === 0){
                $scope.resizePanels();
                $scope.isProductsLoading = false;
            }

            if($scope.configurableProdIds !== undefined && $scope.configurableProdIds.length > 0) {
                var confProdIds = JSON.stringify($scope.configurableProdIds);
                prodConfigService.getProductForAttribCheckMode(confProdIds).then(function(result) {
                    if(result !== undefined)
                          $scope.rootIdToChildMap = result;
                    if($scope.products.searchresults !== undefined && $scope.products.searchresults.length > 0) {
                          angular.forEach($scope.products.searchresults, function(item, idx) {
                              if(item.traversed === undefined || !item.traversed) {
                                  item.addToCart = false;
                                  if($scope.prodIdToReqAttrMap[item.productId]) {
                                      item.addToCart = true;
                                  } else {
                                    var childItems = $scope.rootIdToChildMap[item.productId];
                                    if(childItems !== undefined){
                                        for(var key in childItems) {
                                            if(childItems[key] > 0) {
                                                if($scope.prodIdToReqAttrMap[key]) {
                                                    item.addToCart = true;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                  }
                                  item.traversed = true;
                              }
                          });
                      }
                      $scope.isProductsLoading = false;
                });
            }
            $scope.loadPage = false;
            if ($scope.prodAttribMode === undefined || $scope.prodAttribMode === 'false')
               $scope.isProductsLoading = false;
        }, function(errorMessage) {
            $scope.productListErrors = errorMessage;
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });
    };

    $scope.nextProducts = function() {
       $scope.isProductsLoading = true;
       $scope.products = {list:[], searchresults:[]};
       prodConfigService.nextProducts($scope.ctx.itemId, $scope.currentIndex, $scope.srchText, $scope.selectedProds, $scope.sortby.name).then(function(results) {
           $scope.hasNext = results.hasNext;
           $scope.hasPrevious = results.hasPrevious;
           $scope.currentIndex = results.currentIndex;
           angular.forEach(results.Products, function(item, idx) {
                if($scope.productIdToAttrbMap !== undefined && $scope.productIdToAttrbMap !== null) {
                    if($scope.productIdToAttrbMap[item.priceBookEntryId] !== undefined && $scope.productIdToAttrbMap[item.priceBookEntryId] !== null){
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }
                if($scope.attributesList !== undefined && $scope.attributesList !== null) {
                    if($scope.attributesList[item.priceBookEntryId] !== undefined && $scope.attributesList[item.priceBookEntryId] !== null){
                        item.JSONAttribute = $scope.attributesList[item.priceBookEntryId];
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }

                $scope.products.list.push(item);
                $scope.products.searchresults.push(item);

                if (idx === (results.Products.length - 1)) {
                    $scope.resizePanels();
                }

                if(item.JSONAttribute)
                    $scope.genIndexFromProd(item, true);

                if (item.orderActive) {
                    $scope.orderActive = true;
                }

                if ($scope.prodAttribMode === 'true') {
                    $scope.configurableProdIds.push(item.priceBookEntryId);
                }
            });

            if(results.Products && results.Products.length === 0){
                $scope.resizePanels();
                $scope.isProductsLoading = false;
            }

            if($scope.configurableProdIds !== undefined && $scope.configurableProdIds.length > 0) {
                var confProdIds = JSON.stringify($scope.configurableProdIds);
                prodConfigService.getProductForAttribCheckMode(confProdIds).then(function(result) {
                    if(result !== undefined)
                          $scope.rootIdToChildMap = result;
                    if($scope.products.searchresults !== undefined && $scope.products.searchresults.length > 0) {
                          angular.forEach($scope.products.searchresults, function(item, idx) {
                              if(item.traversed === undefined || !item.traversed) {
                                  item.addToCart = false;
                                  if($scope.prodIdToReqAttrMap[item.productId]) {
                                      item.addToCart = true;
                                  } else {
                                    var childItems = $scope.rootIdToChildMap[item.productId];
                                    if(childItems !== undefined){
                                        for(var key in childItems) {
                                            if(childItems[key] > 0) {
                                                if($scope.prodIdToReqAttrMap[key]) {
                                                    item.addToCart = true;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                  }
                                  item.traversed = true;
                              }
                          });
                      }
                      $scope.isProductsLoading = false;
                });
            }
            $scope.loadPage = false;
            if ($scope.prodAttribMode === undefined || $scope.prodAttribMode === 'false')
                $scope.isProductsLoading = false;
        }, function(errorMessage) {
            $scope.productListErrors = errorMessage;
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });
    };

    $scope.previousProducts = function() {
       $scope.isProductsLoading = true;
       $scope.products = {list:[], searchresults:[]};
       prodConfigService.previousProducts($scope.ctx.itemId, $scope.currentIndex, $scope.srchText, $scope.selectedProds, $scope.sortby.name).then(function(results) {
           $scope.hasNext = results.hasNext;
           $scope.hasPrevious = results.hasPrevious;
           $scope.currentIndex = results.currentIndex;
           angular.forEach(results.Products, function(item, idx) {
                if($scope.productIdToAttrbMap !== undefined && $scope.productIdToAttrbMap !== null) {
                    if($scope.productIdToAttrbMap[item.priceBookEntryId] !== undefined && $scope.productIdToAttrbMap[item.priceBookEntryId] !== null){
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }
                if($scope.attributesList !== undefined && $scope.attributesList !== null) {
                    if($scope.attributesList[item.priceBookEntryId] !== undefined && $scope.attributesList[item.priceBookEntryId] !== null){
                        item.JSONAttribute = $scope.attributesList[item.priceBookEntryId];
                        item.isAttrParsed = true;
                        item.isConfigurable = true;
                    }
                }
                $scope.products.list.push(item);
                $scope.products.searchresults.push(item);

                if (idx === (results.Products.length - 1)) {
                    $scope.resizePanels();
                }

                if (item.orderActive) {
                    $scope.orderActive = true;
                }

                if(item.JSONAttribute)
                    $scope.genIndexFromProd(item, true);

                if ($scope.prodAttribMode === 'true') {
                    $scope.configurableProdIds.push(item.priceBookEntryId);
                }
            });

            if(results.Products && results.Products.length === 0){
                $scope.resizePanels();
                $scope.isProductsLoading = false;
            }

            if($scope.configurableProdIds !== undefined && $scope.configurableProdIds.length > 0) {
                var confProdIds = JSON.stringify($scope.configurableProdIds);
                prodConfigService.getProductForAttribCheckMode(confProdIds).then(function(result) {
                    if(result !== undefined)
                          $scope.rootIdToChildMap = result;
                    if($scope.products.searchresults !== undefined && $scope.products.searchresults.length > 0) {
                          angular.forEach($scope.products.searchresults, function(item, idx) {
                              if(item.traversed === undefined || !item.traversed) {
                                  item.addToCart = false;
                                  if($scope.prodIdToReqAttrMap[item.productId]) {
                                      item.addToCart = true;
                                  } else {
                                    var childItems = $scope.rootIdToChildMap[item.productId];
                                    if(childItems !== undefined){
                                        for(var key in childItems) {
                                            if(childItems[key] > 0) {
                                                if($scope.prodIdToReqAttrMap[key]) {
                                                    item.addToCart = true;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                  }
                                  item.traversed = true;
                              }
                          });
                      }
                      $scope.isProductsLoading = false;
                });
            }
            $scope.loadPage = false;
            if ($scope.prodAttribMode === undefined || $scope.prodAttribMode === 'false')
                $scope.isProductsLoading = false;
        }, function(errorMessage) {
            $scope.productListErrors = errorMessage;
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });
    };

    //--------------CONSOLE HANDLING FIX FOR OM-714 CMT-235 -----------------------

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
   $scope.consoleNavigateToDetail = function(urlStr,consoleResult) {
             //Now that we have the primary tab ID, we can open a new subtab in it
            var primaryTabId = consoleResult.id;
            var tname = getSOName(urlStr.substring(0,15));
            if (primaryTabId == "null")
                sforce.console.openPrimaryTab(null, urlStr.substring(0,15), true, tname,null, tname);
            else
                sforce.console.openSubtab(consoleResult.id,'/' + urlStr.substring(0,15), true, tname,null, tname);
            $scope.buttonStatus.isCreateButtonEnabled = true;
    };



    $scope.cpqCreate = function(id) {
        prodConfigService.cpqCreate(id).then(function(cpqCallResult) {
            $scope.cpqCallResult = cpqCallResult;
            sforce.console.getEnclosingPrimaryTabId(function(consoleCallResult) {
                responseReceived = SUCCESS; // console check happened
                if ( angular.isDefined(consoleTimer) )
                {
                    $interval.cancel(consoleTimer);
                }
                $scope.consoleNavigateToDetail($scope.cpqCallResult.NewObjectId.substr(1), consoleCallResult);
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
                    if ($scope.cpqCallResult.NewObjectId !== '') {
                        window.top.location.href = $scope.cpqCallResult.NewObjectId;
                    }  else {
                        $scope.buttonStatus.isCreateButtonEnabled = true;
                        prodConfigService.openAlertWindow('Error', $scope.cpqCallResult.Status);
                    }
                }
            }, TIMER_UNIT);
        });
    };

    //--------------CONSOLE HANDLING FIX FOR OM-714 CMT-235 -----------------------
    /* configure the given product */
    $scope.configureProduct = function(product, itemInCart, lineItemId, attrId, xlId, callback) {
        $scope.isProductsLoading = true;
        $scope.cfgProducts = [];
        $scope.productErrors = [];
        $scope.cfg = {
            expanded: {},
            showAttrs: {}
        };

        var mode = 'expandRoot';
        if ($scope.prodConfMode !== null) {
            if ($scope.prodConfMode === 'expand') {
                mode = 'expandAll';
            }
            if ($scope.prodConfMode === 'collapse') {
                mode = 'expandNone';
            }
        }

        if (itemInCart) {
            // configure a product that is already in the cart
            $scope.prodConfigMode = 'update';

            prodConfigService.configureProductFromCart($scope.ctx.itemId, lineItemId).then(function(result) {
                if (result.length === 0) {
                    //TODO: something went wrong
                } else {
                    $scope.applyAttributeActions(result.Items, result.productConfigList, result.productIdToOriginalConfig);
                    $scope.cfgProducts = $scope.createProductHierarchy(result.Items, mode);
                    $scope.cfgLineItemId = result.Items[0].contextId;
                    $scope.cfgProductId = result.Items[0].productId;
                    $scope.cfgPriceBookEntryId = result.Items[0].priceBookEntryId;
                    $scope.parentObj.showProdConfig = true;
                    $scope.checkDisableAddToCart($scope.cfgProducts);
                    $scope.validateProducts($scope.cfgProducts);
                }
                $scope.isProductsLoading = false;
                if (callback) {
                    $timeout(function() {
                        callback(attrId, xlId);
                    });
                }
            }, function(errorMessage) {
                console.error(errorMessage);
                $scope.isProductsLoading = false;
            });
        } else {
            // configure a product before adding it to the cart
            $scope.prodConfigMode = 'add';
            var pId = product.Product2Id;

            prodConfigService.getProduct(product.productId, product.priceBookEntryId, 0, null, $scope.ctx.itemId).then(function(result) {
                if (result.length === 0) {
                    //TODO: something went wrong
                } else {
                    $scope.applyAttributeActions(result.prodHier, result.productConfigList, result.productIdToOriginalConfig);
                    $scope.cfgProducts = $scope.createProductHierarchy(result.prodHier, mode);
                    $scope.parentObj.showProdConfig = true;
                    $scope.checkDisableAddToCart($scope.cfgProducts);
                }

                if ($scope.saveMode === 'implicit') {
                    /** Implicit Mode **/
                    var productList = $scope.createProductList($scope.cfgProducts);
                    for(var i = 0 ; i < productList.length ; i++){
                    	productList[i].provisioningStatus = 'PendingInsert';
                    }
                    var productJSON = JSON.stringify(productList);
                    var priceBookEntryId = result.prodHier[0].priceBookEntryId;

                    // add the product to the cart 'temporarily'
                    prodConfigService.addProductToCart($scope.ctx.itemId, priceBookEntryId, productJSON).then(function(result) {
                        $scope.cfgCartItems = result.Items;
                        var lineItemId = result.lineItemId;
                        if (result.Items && result.Items.length > 0) {
                            for (var i = 0; i < result.Items.length; i++) {
                                var item = result.Items[i];
                                if (lineItemId === item.itemSObject.Id) {
                                    $scope.cfgLineItemId = item.itemSObject.Id;
                                    $scope.cfgProductId = pId;
                                    $scope.cfgPriceBookEntryId = item.itemSObject.PricebookEntryId;
                                    break;
                                }
                            }
                        }

                        prodConfigService.configureProductFromCart($scope.ctx.itemId, $scope.cfgLineItemId).then(function(res) {
                            if (res.length === 0) {
                                //TODO: something went wrong
                            } else {
                                $scope.applyAttributeActions(res.Items, res.productConfigList, res.productIdToOriginalConfig);
                                $scope.cfgProducts = $scope.createProductHierarchy(res.Items, mode);
                                $scope.cfgLineItemId = res.Items[0].contextId;
                                $scope.cfgProductId = res.Items[0].productId;
                                $scope.cfgPriceBookEntryId = res.Items[0].priceBookEntryId;
                                $scope.parentObj.showProdConfig = true;
                                $scope.checkDisableAddToCart($scope.cfgProducts);
                                $scope.validateProducts($scope.cfgProducts);
                            }
                            $scope.isProductsLoading = false;
                        }, function(errorMessage) {
                            console.error(errorMessage);
                            $scope.isProductsLoading = false;
                        });
                    }, function(errorMessage) {
                        $scope.parentObj.showProdConfig = false;
                        prodConfigService.openAlertWindow('Add Product Error', errorMessage);
                        console.error(errorMessage);
                        $scope.isProductsLoading = false;
                    });
                } else {
                    /** Explicit Mode **/
                    $scope.isProductsLoading = false;
                }
            }, function(errorMessage) {
                console.error(errorMessage);
                $scope.isProductsLoading = false;
            });
        }

    };

    $scope.$watch('cfgProducts', function(prods) {
        if ($scope.prodAttribMode === 'true') {

            $scope.checkDisableAddToCart(prods);
        }
        $scope.validateProducts(prods);
    }, true);

    $scope.checkDisableAddToCart = function(prodList) {

        if ($scope.prodAttribMode === 'true') {

            $scope.disableAddToCartButton = false;
            if (prodList !== undefined) {
                for (var i = 0; i < prodList.length; i++) {
                    var prod = prodList[i];
                    if (prod.quantity > 0 && prod.JSONAttribute !== null && prod.JSONAttribute !== undefined) {
                        $scope.disableAddToCartButton = $scope.disableAddToCart(prod);
                        if ($scope.disableAddToCartButton) {
                            break;
                        }
                    }
                    if (prod.children !== undefined && prod.quantity > 0) {
                        $scope.checkDisableAddToCart(prod.children);
                        if ($scope.disableAddToCartButton) {
                            return;
                        }
                    }
                }
            }
        }
    };

    /* convert the product list into a tree hierarchy */
    $scope.createProductHierarchy = function(productList, expandNode) {
        var productHierarchy = [];

        var rootProduct = productList[0];
        rootProduct.isRoot = true;
        rootProduct.level = 1;
        if (expandNode !== undefined) {
            rootProduct.isExpanded = (expandNode === 'expandAll' || expandNode === 'expandRoot');
        }
        rootProduct.hasConfigurableAttributes = $scope.hasConfigurableAttributes(rootProduct);
        if (rootProduct.hasConfigurableAttributes === true && expandNode === 'expandAll') {
            rootProduct.showAttrConfig = true;
        }
        for (var idx = 1; idx < productList.length; idx++) {
            var prod = productList[idx];
            var levels = prod.lineNumber.split('.');
            prod.level = levels.length;
            if (expandNode !== undefined) {
                prod.isExpanded = (expandNode === 'expandAll');
            }
            prod.hasConfigurableAttributes = $scope.hasConfigurableAttributes(prod);
            if (prod.hasConfigurableAttributes === true && expandNode === 'expandAll') {
                prod.showAttrConfig = true;
            }
            prod.rootProductId = rootProduct.productId;
            if (prod.minQuantity !== undefined && prod.maxQuantity !== undefined && prod.minQuantity === prod.maxQuantity) {
                prod.quantity = prod.minQuantity;
            }
            if (prod.quantity === undefined) {
                prod.quantity = prod.defaultQuantity;
            }
            if (prod.minQuantity === undefined) {
                prod.minQuantity = 0;
            }

            $scope.setProductChildren(rootProduct, levels.slice(1), prod);
        }
        $scope.filterProductHierarchy(rootProduct);
        productHierarchy.push(rootProduct);

        return productHierarchy;
    };

    /* set the product children as part of building the tree hierarchy */
    $scope.setProductChildren = function(product, levels, p) {
        if (levels.length === 1) {
            if (product.children === undefined) {
                product.children = [];
            }
            product.children[levels[0] - 1] = p;
        } else {
            $scope.setProductChildren(product.children[levels[0] - 1], levels.slice(1), p);
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

    $scope.hasConfigurableAttributes = function(product) {
        var hasConfAttrs = false;
        if (!product.isAttrParsed && product.JSONAttribute) {
            product.JSONAttribute = JSON.parse(product.JSONAttribute);
            product.isAttrParsed = true;
        }
        if (!product.categoryMap) {
            product.categoryMap = {};
            for (var cat in product.JSONAttribute) {
                var attrs = product.JSONAttribute[cat];
                var attrCount = 0;
                for (var i = 0; i < attrs.length; i++) {
                    $scope.parseAttributes(attrs, product);

                    if (attrs[i].attributeconfigurable__c && attrs[i].isactive__c) {
                        attrCount++;
                        hasConfAttrs = true;
                    }
                }
                if (attrs.length > 0) {
                    product.categoryMap[cat] = {name: attrs[0].categoryname__c, showCategory: (attrCount > 0)};
                }
            }
        }

        return hasConfAttrs;
    };

    /* convert the product tree hierarchy into a list */
    $scope.createProductList = function(productHierarchy) {
        var productStructure = j$.extend(true, {}, productHierarchy);
        var productList = [];
        angular.forEach(productStructure, function(rootProduct) {
            if (typeof(rootProduct) === 'object') {
                var children = rootProduct.children;
                delete rootProduct.children;
                delete rootProduct.isRoot;
                delete rootProduct.level;
                delete rootProduct.isExpanded;
                delete rootProduct.hasConfigurableAttributes;
                delete rootProduct.$$hashKey;
                delete rootProduct.showAttrConfig;
                delete rootProduct.isAttrParsed;
                delete rootProduct.categoryMap;
                rootProduct.JSONAttribute = JSON.stringify(rootProduct.JSONAttribute);
                productList.push(rootProduct);
                if (children) {
                    $scope.flattenChildren(productList, children);
                }
            }
        });
        return productList;
    };

    $scope.flattenChildren = function(productList, products) {
        angular.forEach(products, function(product) {
            var children = product.children;
            delete product.children;
            delete product.isRoot;
            delete product.level;
            delete product.isExpanded;
            delete product.hasConfigurableAttributes;
            delete product.$$hashKey;
            delete product.showAttrConfig;
            delete product.isAttrParsed;
            delete product.categoryMap;
            product.JSONAttribute = JSON.stringify(product.JSONAttribute);
            productList.push(product);
            if (children) {
                $scope.flattenChildren(productList, children);
            }
        });
    };

    $scope.configureAttributes = function(product) {
        product.showAttrConfig = !product.showAttrConfig;
        $scope.cfg.showAttrs[product.productId] = product.showAttrConfig;
    };

    /* add the given product to the cart */
    $scope.addProductToCart = function(priceBookEntryId, productHierarchy) {
        $scope.isProductsLoading = true;
        var productList = null;
        var productJSON = null;
        if (productHierarchy !== null) {
            productList = $scope.createProductList(productHierarchy);
            productJSON = JSON.stringify(productList);
        }

        prodConfigService.addProductToCart($scope.ctx.itemId, priceBookEntryId, productJSON).then(function(result) {
            if (result.length === 0) {
                //TODO: handle error
            }
            else if (result.Code === 'Validation successful') {
                // the product was added successfully
                $scope.parentObj.showProdConfig = false;
                // render the cart items
                var pId = (productHierarchy === null ? null : productHierarchy[0].productId);
                $scope.validateItems(result.Items);
                $scope.renderCartItems(result.Items, 'expandNone', pId);
            } else {
                $scope.cfgProducts = $scope.createProductHierarchy(result.Items, 'expandAll');
                //TODO: handle error
            }
            $scope.getProductList(result.Errors, priceBookEntryId);

        }, function(errorMessage) {
            $scope.parentObj.showProdConfig = false;
            prodConfigService.openAlertWindow('Add Product Error', errorMessage);
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });
    };

    $scope.getProdConfigSaveMode = function() {
        prodConfigService.getProdConfigSaveMode().then(function(result) {
            $scope.saveMode = result;
        });
    };

    $scope.getProdConfMode = function() {
        prodConfigService.getProdConfMode().then(function(result) {
            $scope.prodConfMode = result;
        });
    };

    $scope.cancelProductConfig = function() {
        /** AUTO-SAVE **/
        $scope.isProductsLoading = true;
        // delete the 'temporary' product from the cart
        prodConfigService.deleteProductFromCart($scope.ctx.itemId, $scope.cfgLineItemId).then(function(result) {
            $scope.parentObj.showProdConfig = !$scope.parentObj.showProdConfig;
            $scope.getProductList();
        });
    };

    $scope.closeProductConfig = function(cfgMode) {
        prodConfigService.updateProvisioningStatusForImplSave($scope.ctx.itemId, $scope.cfgLineItemId).then(function(result) {
	        $scope.parentObj.showProdConfig = !$scope.parentObj.showProdConfig;
	        // refresh the cart items
	        $scope.getCartItems($scope.cfgProductId);
	    });
    };

    /* delete the given product from the cart */
    $scope.deleteProductFromCart = function(rootProductId, lineItemId) {
        $scope.isCartLoading = true;
        $scope.disabledeletecart = true;
        prodConfigService.deleteProductFromCart($scope.ctx.itemId, lineItemId).then(function(result) {
            // refresh the cart
            //$scope.renderCartItems(result.Items, 'expandAll', rootProductId);
            //the delete errors are included in the results
            var deleteResults = result;
            prodConfigService.getCartItems($scope.ctx.itemId).then(function(result) {
                $scope.validateItems(result);
                //deleteErrors are lost as the getCartItems is called and the cart is rendered, hence merging all the errors
                result = $scope.includeDeleteErrors(result,deleteResults);
                $scope.renderCartItems(result, 'expandAll', rootProductId);
                $scope.getProductList();
                $scope.parentObj.showProdConfig = false;
                $scope.disabledeletecart = false;
            });

        }, function(errorMessage) {
            prodConfigService.openAlertWindow('Delete Product Error', errorMessage);
            console.error(errorMessage);
            $scope.isCartLoading = false;
            $scope.disabledeletecart = false;
        });
    };

    $scope.includeDeleteErrors = function(items, deleteItems) {
        if (deleteItems && deleteItems.Items) {
            deleteItems = deleteItems.Items;
            for (i = 0 ; i < deleteItems.length ; i++) {
                if (deleteItems[i] && deleteItems[i].errors && deleteItems[i].errors.length > 0) {
                  for(j = 0 ; j < deleteItems[i].errors.length ; j++){
                    //if the error message is already present do not include it
                    if(items[i].errors.indexOf(deleteItems[i].errors[j]) === -1){
                      items[i].errors.push(deleteItems[i].errors[j]);
                    }
                  }
                }
            }
        }
        return items;
    };

    /* update the quantity of the given product in the cart */
    $scope.updateProductQuantity = function(rootProductId, lineItemId, quantity) {
        if (quantity === undefined || quantity === null || quantity === '') {
            quantity = -1;
        }

        $scope.isCartLoading = true;
        if (quantity === 0) {
            // delete the product from the cart if quantity is set to zero
            $scope.deleteProductFromCart(rootProductId, lineItemId);
        } else {
            prodConfigService.updateProductQuantity($scope.ctx.itemId, lineItemId, quantity).then(function(result) {
                // render the cart items
                //$scope.getCartItems();
                $scope.renderCartItems(result.Items, 'expandAll', rootProductId);
                $scope.parentObj.showProdConfig = false;
            }, function(errorMessage) {
                console.error(errorMessage);
                $scope.isCartLoading = false;
            });
        }
    };

    /* validate quantity of product */
    $scope.validateQuantity = function(quantity, isRoot){
      if(isRoot){
        //Accept only positive quantity(exclude zero also).
        return /^[1-9]\d*$/.test(quantity);
      } else{
        //Accept only positive quantity(including zero also).
        return /^\d+$/.test(quantity);
      }
    }
    /* auto-save the given product */
    $scope.autoSaveProduct = function() {
        $scope.isProductsLoading = true;
        var productList = $scope.createProductList($scope.cfgProducts);
        var productJSON = JSON.stringify(productList);

        prodConfigService.autoSaveProduct($scope.ctx.itemId, $scope.cfgPriceBookEntryId, productJSON, $scope.cfgLineItemId).then(function(result) {
            if (result.length === 0) {
                //TODO: handle error
            }
            else if (result.Code === 'Validation successful') {
                //$scope.cfgProducts = result.Items;
                var temp = [];
                angular.forEach(result.Items, function(item) {
                    item.isExpanded = $scope.cfg.expanded[item.productId];
                    if ($scope.cfg.showAttrs[item.productId]) {
                        item.showAttrConfig = undefined;
                        temp.push(item);
                    } else {
                        item.showAttrConfig = false;
                    }
                });
                $scope.cfgProducts = $scope.createProductHierarchy(result.Items);
                angular.forEach(temp, function(prod) {
                    $scope.configureAttributes(prod);
                });
            } else {
                // there was an error saving the product
                console.error('autoSaveProduct: failure');
				var temp = [];
				angular.forEach(result.Items, function(item) {
					item.isExpanded = $scope.cfg.expanded[item.productId];
					if ($scope.cfg.showAttrs[item.productId]) {
						item.showAttrConfig = undefined;
						temp.push(item);
					} else {
						item.showAttrConfig = false;
					}
				});
				$scope.cfgProducts = $scope.createProductHierarchy(result.Items);
				angular.forEach(temp, function(prod) {
					$scope.configureAttributes(prod);
				});

            }
            $scope.implicitClean = false;
            $scope.getProductList();
        }, function(errorMessage) {
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });
    };

    /* save the given product in the cart */
    $scope.saveProductInCart = function(priceBookEntryId, productHierarchy) {
        $scope.isProductsLoading = true;
        var productList = $scope.createProductList(productHierarchy);
        var productJSON = JSON.stringify(productList);

        prodConfigService.saveProductInCart($scope.ctx.itemId, priceBookEntryId, productJSON).then(function(result) {
            if (result.length === 0) {
                //TODO: handle error
            }
            else if (result.Code === 'Validation successful') {
                // the product was added successfully
                $scope.parentObj.showProdConfig = false;
                // refresh the cart
                var pId = productHierarchy[0].productId;
                $scope.validateItems(result.Items);
                $scope.renderCartItems(result.Items, 'expandNone', pId);
            } else {
                // there was an error adding the product to the cart
                $scope.cfgProducts = $scope.createProductHierarchy(result.Items, 'expandAll');
                $scope.parentObj.showProdConfig = true;
            }
            $scope.getProductList();
        }, function(errorMessage) {
            console.error(errorMessage);
            $scope.isProductsLoading = false;
        });
    };

    $scope.toggleProductChildren = function(prod) {
        prod.isExpanded = !prod.isExpanded;
        $scope.cfg.expanded[prod.productId] = prod.isExpanded;
    };

    $scope.isSelectedPicklist = function(value, selectedItems) {
        var found = false;
        for (var i = 0; i < selectedItems.length; i++) {
            if (selectedItems[i].id === value.id) {
                found = true;
                break;
            }
        }
        return found;
    };

    $scope.setAttrPicklist = function(selectedIdx, attr) {
        var selected_items = [];
        var selectedItemsText = [];
        angular.forEach(selectedIdx, function(idx) {
            var index = parseInt(idx);
            if (-1 < index && index < attr.attributeRunTimeInfo.values.length) {
                selected_items.push(attr.attributeRunTimeInfo.values[index]);
                selectedItemsText.push(attr.attributeRunTimeInfo.values[index].displayText);
            }
        });
        attr.attributeRunTimeInfo.selectedItems = selected_items;
        attr.attributeRunTimeInfo.selectedItemsText = selectedItemsText.join(';');

    };

    $scope.executeQueryableMethod = function(attr) {
        var queryItems = attr.querycode__c.split('|');
        if (queryItems.length < 2) {
        //ERROR
        } else {
            var className = queryItems[0];
            var methodName = queryItems[1];
            var input = queryItems[2];
            if (input === undefined) {
                input = null;
            }
            if (attr.attributeRunTimeInfo.value !== '' && attr.attributeRunTimeInfo.value !== undefined) {
                var inputJSON = (input === null ? {} : JSON.parse(input));
                inputJSON.userInput = attr.attributeRunTimeInfo.value;
                input = JSON.stringify(inputJSON);
            }
            var options = queryItems[3];
            if (options === undefined) {
                options = null;
            }

            prodConfigService.executeQueryableMethod(className, methodName, input, options).then(function(result) {
                attr.attributeRunTimeInfo.queryresults = [];
                if (result.length > 0) {
                    attr.attributeRunTimeInfo.queryresults = result;
                }

                attr.attributeRunTimeInfo.showQueryResults = true;
            }, function(errorMessage) {
                console.error(errorMessage);
            });
        }
    };

    $scope.executeQueryableMethodCallback = function() {
        if ($scope.saveMode === 'implicit') {
            $scope.autoSaveProduct();
        }
    };

    $scope.isEmptyObject = function(obj) {
        return j$.isEmptyObject(obj);
    };

    $scope.valueByKey = function(o, s) {
        s = s.replace(/\[(\w+)\]/g, '.$1'); // convert indexes to properties
        s = s.replace(/^\./, '');           // strip a leading dot
        var a = s.split('.');
        for (var i = 0, n = a.length; i < n; ++i) {
            var k = a[i];
            if (k in o) {
                o = o[k];
            } else {
                return;
            }
        }
        return o;
    };

    $scope.applyAttributeActions = function(items, productConfigList, productIdToOriginalConfig) {
        if (productConfigList === undefined) {
            return;
        }
        angular.forEach(items, function(item) {
            if (item.JSONAttribute !== null && item.JSONAttribute) {
                originalProduct = productIdToOriginalConfig[item.productId];
                var originalProductAttributes = null;
                if (originalProduct !== undefined && originalProduct[$scope.nsPrefix + 'JSONAttribute__c'] !== undefined) {
                    originalProductAttributes = JSON.parse(originalProduct[$scope.nsPrefix + 'JSONAttribute__c']);
                }
                attributeCodeToAttributeObject = {};
                productAttributesObject = JSON.parse(item.JSONAttribute);
                //parse existing values to reference the map instead of looping
                angular.forEach(productAttributesObject, function(categoryContext, categoryName) {
                    angular.forEach(categoryContext, function(attributeContext, attributeKey) {
                        attributeObject = productAttributesObject[categoryName][attributeKey];
                        attributeCodeToAttributeObject[attributeObject.attributeuniquecode__c] = attributeObject;
                    });
                });
                angular.forEach(productConfigList, function(prod) {
                    if (prod[$scope.nsPrefix + 'ActionParameters__c'] !== undefined) {
                        $scope.doAttributeActions(JSON.parse(prod[$scope.nsPrefix + 'ActionParameters__c']), attributeCodeToAttributeObject, originalProductAttributes, item);
                    }
                });
                item.JSONAttribute = JSON.stringify(productAttributesObject);
            }
        });
    };

    $scope.updateProductAttributes = function(product, selectedAttributeCode, idx) {
        $scope.isProductsLoading = true;
        prodConfigService.updateProductAttributes(product.productId, JSON.stringify(product.JSONAttribute)).then(function(result) {
            filterIdToObjectIds = result.filterIdToObjectIds;
            entityFilterIdToActionParams = result.entityFilterIdToActionParams;
            productIdToOriginalConfig = result.productIdToOriginalConfig;
            templateApplied = false;
            attributeCodeToAttributeObject = {};
            originalProduct = productIdToOriginalConfig[product.productId];
            var originalProductAttributes = null;
            if (originalProduct !== undefined && originalProduct[$scope.nsPrefix + 'JSONAttribute__c'] !== undefined) {
                originalProductAttributes = JSON.parse(originalProduct[$scope.nsPrefix + 'JSONAttribute__c']);
            }

            //parse existing values to reference the map instead of looping
            angular.forEach(product.JSONAttribute, function(categoryContext, categoryName) {
                angular.forEach(categoryContext, function(attributeContext, attributeKey) {
                    attributeObject = product.JSONAttribute[categoryName][attributeKey];
                    attributeCodeToAttributeObject[attributeObject.attributeuniquecode__c] = attributeObject;
                });
            });

            angular.forEach(filterIdToObjectIds, function(filterContext, filterId) {
                if (filterContext.length > 0) {
                    templateApplied = true;
                    actions = JSON.parse(entityFilterIdToActionParams[filterId]);
                    $scope.doAttributeActions(actions, attributeCodeToAttributeObject, originalProductAttributes, product);
                }
            });

            //populate the attribute values for the bound fields
            if (attributeCodeToAttributeObject[selectedAttributeCode] && $scope.attributeCodeToField[selectedAttributeCode]) {
                attr = attributeCodeToAttributeObject[selectedAttributeCode];
                if (attr.attributeRunTimeInfo.dataType === 'Multi Picklist') {
                    if (attr.attributeRunTimeInfo.uiDisplayType === 'Checkbox') {
                        selectedString = [];
                        angular.forEach(attr.attributeRunTimeInfo.values, function(value) {
                            if (value.checked === true) {
                                selectedString.push(value.displayText);
                            }
                        });
                        product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]] = selectedString.join(';');
                    } else if (attr.attributeRunTimeInfo.uiDisplayType === 'Dropdown') {
                        product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]] = attr.attributeRunTimeInfo.selectedItemsText;
                    }

                } else if (attr.attributeRunTimeInfo.dataType === 'Picklist') {
                    if (attr.attributeRunTimeInfo.uiDisplayType === 'Radiobutton') {
                        product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]] = attr.attributeRunTimeInfo.selectedItem.displayText;
                    } else if (attr.attributeRunTimeInfo.uiDisplayType === 'Dropdown') {
                        product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]] = attr.attributeRunTimeInfo.values[idx].displayText;

                    }
                } else {
                    product.attributeValues[$scope.attributeCodeToField[attr.attributeuniquecode__c]] = attr.attributeRunTimeInfo.value;
                }
            }

            if (product.provisioningStatus !== undefined && product.provisioningStatus === 'Active') {
                product.provisioningStatus = 'Changed';
            }
            if ($scope.saveMode === 'implicit') {
                $scope.autoSaveProduct();
            } else {
                $scope.isProductsLoading = false;
            }
        });
    };

    $scope.doAttributeActions = function(actions, attributeCodeToAttributeObject, originalProductAttributes, product) {
        //parse existing values to reference the map instead of looping for the original object
        originalAttributeCodeToAttributeObject = {};
        angular.forEach(originalProductAttributes, function(categoryContext, categoryName) {
            angular.forEach(categoryContext, function(attributeContext, attributeKey) {
                originalAttributeObject = originalProductAttributes[categoryName][attributeKey];
                originalAttributeCodeToAttributeObject[attributeObject.attributeuniquecode__c] = originalAttributeObject;
            });
        });
        for (var attributeCode in actions) {
            if (attributeCodeToAttributeObject[attributeCode] === undefined) {
                break;
            }
            var isBoundAttribute = $scope.attributeCodeToField && $scope.attributeCodeToField[attributeCode] ? true : false;
            attributeObject = attributeCodeToAttributeObject[attributeCode];
            actionList = actions[attributeCode].actionsList;
            for (index = 0; index < actionList.length; index ++) {
                if (actionList[index].action === 'CONSTRAIN') {
                    if (actionList[index].actionType === 'include') {
                        if (attributeObject.attributeRunTimeInfo.dataType === 'Picklist' || attributeObject.attributeRunTimeInfo.dataType === 'Multi Picklist') {
                            //get existing values in order not to duplicate upon adding
                            existingValues = [];
                            for (valuesIndex = 0; valuesIndex < attributeObject.attributeRunTimeInfo.values.length; valuesIndex ++) {
                                existingValues.push(attributeObject.attributeRunTimeInfo.values[valuesIndex].displayText);
                            }

                            if (Array.isArray(actionList[index].value)) {
                                initialId = attributeObject.attributeRunTimeInfo.values.length;
                                for (inclIndex = 0; inclIndex < actionList[index].value.length; inclIndex ++) {
                                    if (existingValues.indexOf(actionList[index].value[inclIndex]) !== -1) {
                                        continue;
                                    }
                                    value = {};
                                    value.value = '';
                                    value.displayText = actionList[index].value[inclIndex];

                                    //reference orignial attributes to resolve the index id
                                    if (originalAttributeCodeToAttributeObject[attributeCode] !== undefined) {
                                        orignialAttributeObject = originalAttributeCodeToAttributeObject[attributeCode];
                                        originalValues = orignialAttributeObject.attributeRunTimeInfo.values;
                                        for (valuesIndex = 0; valuesIndex < originalValues.length; valuesIndex ++) {
                                            originalValue = originalValues[valuesIndex];
                                            if (actionList[index].value[inclIndex] === originalValue.displayText) {
                                                value.id = originalValue.id;
                                                break;
                                            }
                                        }
                                    } else {
                                        value.id = initialId;
                                        initialId++;
                                    }

                                    attributeObject.attributeRunTimeInfo.values.push(value);
                                }
                            } else if (typeof actionList[index].value === 'string') {
                                value = {};
                                value.value = '';
                                value.displayText = actionList[index].value;
                                value.id = attributeObject.attributeRunTimeInfo.values.length;
                                attributeObject.attributeRunTimeInfo.values.push(value);
                            }
                            attributeObject.attributeRunTimeInfo.values.sort($scope.sortByid);
                        }
                    } else if (actionList[index].actionType === 'exclude') {
                        if (attributeObject.attributeRunTimeInfo.dataType === 'Picklist' || attributeObject.attributeRunTimeInfo.dataType === 'Multi Picklist') {
                            values = attributeObject.attributeRunTimeInfo.values;
                            indicesToRemove = [];
                            for (valueIndex = 0; valueIndex < values.length; valueIndex ++) {
                                if (Array.isArray(actionList[index].value)) {
                                    initialId = attributeObject.attributeRunTimeInfo.values.length;
                                    for (excIndex = 0; excIndex < actionList[index].value.length; excIndex ++) {
                                        if (values[valueIndex].displayText === actionList[index].value[excIndex]) {
                                            indicesToRemove.push(valueIndex);
                                            break;
                                        }
                                    }
                                } else if (typeof actionList[index].value === 'string') {
                                    if (values[valueIndex].displayText === actionList[index].value) {
                                        indicesToRemove.push(valueIndex);
                                        break;
                                    }
                                }
                            }
                            if (indicesToRemove.length > 0) {
                                for (excIndex = indicesToRemove.length - 1 ; excIndex >= 0; excIndex --) {
                                    values.splice(indicesToRemove[excIndex], 1);
                                }
                            }
                        }
                    }
                } else if (actionList[index].action === 'ASSIGN') {
                    if (attributeObject.attributeRunTimeInfo.dataType === 'Picklist') {
                        if (Array.isArray(actionList[index].value)) {
                            valuesArray = actionList[index].value;
                            for (valuesIndex = 0; valuesIndex < attributeObject.attributeRunTimeInfo.values.length; valuesIndex ++) {
                                if (valuesArray.indexOf(attributeObject.attributeRunTimeInfo.values[valuesIndex].displayText) !== -1) {
                                    attributeObject.attributeRunTimeInfo.selectedItem = attributeObject.attributeRunTimeInfo.values[valuesIndex];

                                }
                            }
                        } else if (typeof actionList[index].value === 'string') {
                            valueString = actionList[index].value;
                            for (valuesIndex = 0; valuesIndex < attributeObject.attributeRunTimeInfo.values.length; valuesIndex ++) {
                                if (actionList[index].value === attributeObject.attributeRunTimeInfo.values[valuesIndex].displayText) {
                                    attributeObject.attributeRunTimeInfo.selectedItem = attributeObject.attributeRunTimeInfo.values[valuesIndex];
                                    break;
                                }
                            }
                        }
                        if(attributeObject.attributeRunTimeInfo.selectedItem && isBoundAttribute){
                            if(!product.attributeValues){
                                product.attributesValues = {};
                            }
                            product.attributeValues[$scope.attributeCodeToField[attributeCode]] = attributeObject.attributeRunTimeInfo.selectedItem.displayText;
                        }
                    } else if (attributeObject.attributeRunTimeInfo.dataType === 'Multi Picklist') {
                        attributeObject.attributeRunTimeInfo.selectedItems = [];
                        selectedItems = [];
                        if (Array.isArray(actionList[index].value)) {
                            valuesArray = actionList[index].value;
                            for (valuesIndex = 0; valuesIndex < attributeObject.attributeRunTimeInfo.values.length; valuesIndex ++) {
                                if (valuesArray.indexOf(attributeObject.attributeRunTimeInfo.values[valuesIndex].displayText) !== -1) {
                                    attributeObject.attributeRunTimeInfo.selectedItems.push(attributeObject.attributeRunTimeInfo.values[valuesIndex]);
                                    selectedItems.push(attributeObject.attributeRunTimeInfo.values[valuesIndex].displayText);
                                }
                            }
                        } else if (typeof actionList[index].value === 'string') {
                            attributeObject.attributeRunTimeInfo.selectedItems = [];
                            for (valuesIndex = 0; valuesIndex < attributeObject.attributeRunTimeInfo.values.length; valuesIndex ++) {
                                if (actionList[index].value === attributeObject.attributeRunTimeInfo.values[valuesIndex].displayText) {
                                    attributeObject.attributeRunTimeInfo.selectedItems.push(attributeObject.attributeRunTimeInfo.values[valuesIndex]);
                                    selectedItems.push(attributeObject.attributeRunTimeInfo.values[valuesIndex].displayText);
                                    break;
                                }
                            }
                        }
                        if(selectedItems && isBoundAttribute){
                            if(!product.attributeValues){
                                product.attributesValues = {};
                            }
                            product.attributeValues[$scope.attributeCodeToField[attributeCode]] = selectedItems.join(';');
                        }
                    } else {
                        attributeObject.attributeRunTimeInfo.value = actionList[index].value;
                        if(actionList[index].value && isBoundAttribute){
                            if(!product.attributeValues){
                                product.attributesValues = {};
                            }
                            product.attributeValues[$scope.attributeCodeToField[attributeCode]] = actionList[index].value;
                        }
                    }
                } else if (actionList[index].action === 'DISABLE') {
                    attributeObject.isreadonly__c = actionList[index].value;
                } else if (actionList[index].action === 'REQUIRE') {
                    attributeObject.isrequired__c = actionList[index].value;
                } else if (actionList[index].action === 'HIDE') {
                    attributeObject.ishidden__c = actionList[index].value;
                }
            }
        }
    };

    $scope.sortByid = function compare(a, b) {
        if (a.id < b.id) {
            return -1;
        } else if (a.id > b.id) {
            return 1;
        } else {
            return 0;
        }
    };

    $scope.disableAddToCart = function(product) {
        var invalidAttrIds = $scope.checkRequiredAttr(product.JSONAttribute);
        return (invalidAttrIds.length > 0);
    };

    $scope.takeMeThere = function(prodId, attrId, xlId) {
        $scope.configureProduct(null, true, prodId, attrId, xlId, function(attrId, xlId) {
            var hashId = 'attr-' + attrId;
            var e = document.getElementById(hashId);
            if (!!e && e.scrollIntoView) {
                e.scrollIntoView();
                document.getElementById(hashId).focus();
            }
        });
    };

    $scope.takeToProduct = function(prodId, attrId, xlId) {
        var hashId = 'attr-' + attrId;
        var e = document.getElementById(hashId);
        if (!!e && e.scrollIntoView) {
            e.scrollIntoView();
            document.getElementById(hashId).focus();
        }
    };
});

angular.module('productConfiguration').directive('onErrorSrc', function() {
    return {
        link: function(scope, element, attrs) {
          element.bind('error', function() {
            if (attrs.src != attrs.onErrorSrc) {
              attrs.$set('src', attrs.onErrorSrc);
            }
          });
        }
    }
});

angular.module('productConfiguration').controller('ModalInstanceCtrl', function($scope, $modalInstance, message) {
    $scope.message = message;
    $scope.ok = function() {
        $modalInstance.close();
    };
});

},{}],3:[function(require,module,exports){
angular.module('productConfiguration').directive('attributeQuery', function() {
    return {
        scope: {
        	attr: '=attribute',
        	query: '&',
        	callback: '='
        },
        replace: true,
        restrict: 'E',
        templateUrl: 'attributeQuery.html',
        controller: function($scope) {
        	$scope.executeQuery = function() {
        		$scope.query()($scope.attr);
        	};
        	$scope.setQueryResultToAttributeValue = function(attr, value) {
				
                if(attr.attributeRunTimeInfo.dataType ==='Picklist'){
                    attr.attributeRunTimeInfo.showQueryResults = false;
                    for(var i=0;i<attr.attributeRunTimeInfo.values.length;i++){
                        if(attr.attributeRunTimeInfo.values[i].displayText === value){
                            attr.attributeRunTimeInfo.selectedItem = attr.attributeRunTimeInfo.values[i];
                            break;
                        }
                    }
                } else if(attr.attributeRunTimeInfo.dataType ==='Multi Picklist'){
                    attr.attributeRunTimeInfo.showQueryResults = true;
                    for(var i=0;i<attr.attributeRunTimeInfo.values.length;i++){
                        if(attr.attributeRunTimeInfo.values[i].displayText===value){
                            if(attr.attributeRunTimeInfo.uiDisplayType === 'Checkbox'){
                                attr.attributeRunTimeInfo.values[i].checked = true;
                            } else if(attr.attributeRunTimeInfo.uiDisplayType === 'Dropdown'){
                                var toPush=true;
                                for(var j=0;j<attr.attributeRunTimeInfo.selectedItems.length;j++){
                                    if(attr.attributeRunTimeInfo.selectedItems[j].displayText===value){
                                        toPush=false;
                                        break;
                                    }
                                }
                                if(toPush){
                                    attr.attributeRunTimeInfo.selectedItems.push(attr.attributeRunTimeInfo.values[i]);
                                }
                            break;
                            }
                        }
                    }
                } else{
                    attr.attributeRunTimeInfo.value = value;
                    attr.attributeRunTimeInfo.showQueryResults = false;
                }
                
                // invoke the callback function in the parent scope
                if ($scope.callback)
                    $scope.callback();
			};
        }
    };
});
},{}],4:[function(require,module,exports){
angular.module('productConfiguration').directive('vlcLoader', function() {
    return {
        restrict: 'E',
        templateNamespace: 'svg',
        replace: true,
        template:
        '<svg x="0px" y="0px" width="28" height="28" viewBox="0 0 48 48">'+
            '<g width="48" height="48">'+
                '<animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 24 24" to="360 24 24" dur="0.75s" repeatCount="indefinite"/>'+
                '<path fill="#dedede" d="M24,45C12.4,45,3,35.6,3,24S12.4,3,24,3V0l0,0C10.7,0,0,10.7,0,24c0,13.3,10.7,24,24,24V45z"/>'+
                '<path fill="#05a6df" d="M24,3c11.6,0,21,9.4,21,21s-9.4,21-21,21v3l0,0c13.3,0,24-10.7,24-24C48,10.7,37.3,0,24,0V3z"/>'+
            '</g>'+
        '</svg>',
        scope: {
            stroke: '@'
        }
    };
});
},{}],5:[function(require,module,exports){
Visualforce.remoting.timeout = 120000;

function getPricebooks(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getPricebooks, objectId, callback, {escape: false});
}

function setPricebook(objectId, pricebookId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.setPricebook, objectId, pricebookId, callback, {escape: false});
}

function getProducts(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getProductsList, objectId, callback, {escape: false});
}

function searchProducts(objectId, searchText, prodIds, sortBy, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.searchProducts, objectId, searchText, prodIds, sortBy, callback, {escape: false});
}

function getProduct(productId, priceBookEntryId, level, lineNumber, parentObjectId, callback) {
	//Visualforce.remoting.Manager.invokeAction(remoteAction.getProductHierarchy, productId, priceBookEntryId, level, lineNumber, callback, {escape: false});
	Visualforce.remoting.Manager.invokeAction(remoteAction.getContextProductHierarchy, productId, priceBookEntryId, level, lineNumber, parentObjectId, callback, {escape: false});
}

function getProductForAttribCheckMode(prodIds, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getProductForAttribCheckMode, prodIds, callback, {escape: false});
}

function nextProducts(objectId, currentindex, searchText, prodIds, sortBy, callback ) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.nextProducts, objectId, currentindex, searchText, prodIds, sortBy, callback, {escape: false});
}

function previousProducts(objectId, currentindex, searchText, prodIds, sortBy, callback ) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.previousProducts, objectId, currentindex, searchText, prodIds, sortBy, callback, {escape: false});
}

function getAttributes(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getAttributes, objectId, callback, {escape: false});
}

function getCartItems(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getCartItems, objectId, callback, {escape: false});
}

function getOrderSummaryConfig(objectId, feature, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getOrderSummaryConfig, objectId, feature, callback, {escape: false});
}

function getOrderSummaryDetails(columnMap, oId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getOrderSummaryDetails, columnMap, oId, callback, {escape: false});
}

function addProductToCart(objectId, priceBookEntryId, productJSON, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.addProductToCart, objectId, priceBookEntryId, productJSON, callback, {escape: false});
}

function updateProvisioningStatusForImplSave(objectId, lineItemId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.updateProvisioningStatusForImplSave, objectId, lineItemId, callback, {escape: false});
}

function deleteImplSavedLineItems(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.deleteImplSavedLineItems, objectId, callback, {escape: false});
}

function getProdConfigSaveMode(callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getProdConfigSaveMode, callback, {escape: false});
}

function checkPaginationMode(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.checkPaginationMode, objectId, callback, {escape: false});
}

function checkCacheEnabled(callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.checkCacheEnabled, callback, {escape: false});
}

function getProdConfMode(callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getProdConfMode, callback, {escape: false});
}

function getProdAttribCheckMode(callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getProdAttribCheckMode, callback, {escape: false});
}

function deleteProductFromCart(objectId, lineItemId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.deleteProductFromCart, objectId, lineItemId, callback, {escape: false});
}

function updateProductQuantity(objectId, lineItemId, quantity, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.updateProductQuantity, objectId, lineItemId, quantity, callback, {escape: false});
}

function configureProductFromCart(objectId, lineItemId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.configureProductFromCart, objectId, lineItemId, callback, {escape: false});
}

function saveProductInCart(objectId, priceBookEntryId, productJSON, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.saveProductInCart, objectId, priceBookEntryId, productJSON, callback, {escape: false});
}

function autoSaveProduct(objectId, priceBookEntryId, productJSON, lineItemId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.autoSaveProduct, objectId, priceBookEntryId, productJSON, lineItemId, callback, {escape: false});
}

function cpqCreate(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.cpqCreate, objectId, callback, {escape: false});
}

function executeQueryableMethod(className, methodName, input, options, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.executeQueryableMethod, className, methodName, input, options, callback, {escape: false});
}

function updateProductAttributes(objectId, jsonAttributes, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.updateProductAttributes, objectId, jsonAttributes, callback, {escape: false});
}

function isSignatureRequired(objectId, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.isSignatureRequired, objectId, callback, {escape: false});
}

function getContextualData(requestParamsString, callback) {
	Visualforce.remoting.Manager.invokeAction(remoteAction.getContextualData, requestParamsString, callback, {escape: false});
}

//CMT-723
function getCartDetails(objectId, refreshMode, callback) {
  Visualforce.remoting.Manager.invokeAction(remoteAction.getCartDetails, objectId,refreshMode, callback, {escape: false});
}
function getCpqSettings( key, callback) {
  Visualforce.remoting.Manager.invokeAction(remoteAction.getCpqSettings, key , callback, {escape: false});
}
//CMT-723

angular.module('productConfiguration').factory('prodConfigService', function($q, $rootScope, $modal) {
	var factory = {};

	factory.getPricebooks = function(objectId) {
		var deferred = $q.defer();
		getPricebooks(objectId, function(result, event) {
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

	factory.setPricebook = function(objectId, pricebookId) {
		var deferred = $q.defer();
		setPricebook(objectId, pricebookId, function(result, event) {
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

	factory.getProducts = function(objectId) {
		var deferred = $q.defer();
		getProducts(objectId, function(result, event) {
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

	factory.getProductForAttribCheckMode = function(prodIds) {
		var deferred = $q.defer();
		getProductForAttribCheckMode(prodIds, function(result, event) {
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

	factory.searchProducts = function(objectId, searchText, prodIds, sortBy) {
		var deferred = $q.defer();
		searchProducts(objectId, searchText, prodIds, sortBy, function(result, event) {
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

	factory.nextProducts = function(objectId, currentIndex, searchText, prodIds, sortBy) {
		var deferred = $q.defer();
		nextProducts(objectId, currentIndex, searchText, prodIds, sortBy, function(result, event) {
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

	factory.previousProducts = function(objectId, currentIndex, searchText, prodIds, sortBy) {
		var deferred = $q.defer();
		previousProducts(objectId, currentIndex, searchText, prodIds, sortBy, function(result, event) {
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
// CMT-723
  factory.getCartDetails = function(objectId,refreshMode) {
    var deferred = $q.defer();
    getCartDetails(objectId, refreshMode,function(result, event) {
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

  factory.getCpqSettings = function(key) {
    var deferred = $q.defer();
    getCpqSettings(key,function(result, event) {
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
	factory.getAttributes = function(objectId) {
		var deferred = $q.defer();
		getAttributes(objectId, function(result, event) {
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

	factory.getProduct = function(productId, priceBookEntryId, level, lineNumber, parentObjectId) {
		var deferred = $q.defer();
		getProduct(productId, priceBookEntryId, level, lineNumber, parentObjectId, function(result, event) {
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

	factory.getCartItems = function(objectId) {
		var deferred = $q.defer();
		getCartItems(objectId, function(result, event) {
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

	factory.addProductToCart = function(objectId, priceBookEntryId, productJSON) {
		var deferred = $q.defer();
		addProductToCart(objectId, priceBookEntryId, productJSON, function(result, event) {
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

	factory.getProdConfigSaveMode = function() {
		var deferred = $q.defer();
		getProdConfigSaveMode(function(result, event) {
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

	factory.getProdAttribCheckMode = function() {
		var deferred = $q.defer();
		getProdAttribCheckMode(function(result, event) {
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

	factory.checkCacheEnabled = function() {
		var deferred = $q.defer();
		checkCacheEnabled(function(result, event) {
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

	factory.checkPaginationMode = function(objectId) {
		var deferred = $q.defer();
		checkPaginationMode(objectId, function(result, event) {
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
	
	factory.getProdConfMode = function() {
		var deferred = $q.defer();
		getProdConfMode(function(result, event) {
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

	factory.getOrderSummaryConfig = function(objectId, feature) {
		var deferred = $q.defer();
		getOrderSummaryConfig(objectId, feature, function(result, event) {
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

	factory.getOrderSummaryDetails = function(columnMap, oId) {
		var deferred = $q.defer();
		getOrderSummaryDetails(columnMap, oId, function(result, event) {
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

	factory.deleteProductFromCart = function(objectId, lineItemId) {
		var deferred = $q.defer();
		deleteProductFromCart(objectId, lineItemId, function(result, event) {
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

	factory.updateProvisioningStatusForImplSave = function(objectId, lineItemId) {
		var deferred = $q.defer();
		updateProvisioningStatusForImplSave(objectId, lineItemId, function(result, event) {
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
	
	factory.deleteImplSavedLineItems = function(objectId) {
		var deferred = $q.defer();
		deleteImplSavedLineItems(objectId, function(result, event) {
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

	factory.updateProductQuantity = function(objectId, lineItemId, quantity) {
		var deferred = $q.defer();
		updateProductQuantity(objectId, lineItemId, quantity, function(result, event) {
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

	factory.configureProductFromCart = function(objectId, lineItemId) {
		var deferred = $q.defer();
		configureProductFromCart(objectId, lineItemId, function(result, event) {
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

	factory.autoSaveProduct = function(objectId, priceBookEntryId, productJSON, lineItemId) {
		var deferred = $q.defer();
		autoSaveProduct(objectId, priceBookEntryId, productJSON, lineItemId, function(result, event) {
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

	factory.saveProductInCart = function(objectId, priceBookEntryId, productJSON) {
		var deferred = $q.defer();
		saveProductInCart(objectId, priceBookEntryId, productJSON, function(result, event) {
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

	factory.cpqCreate = function(objectId) {
		var deferred = $q.defer();
		cpqCreate(objectId, function(result, event) {
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

	factory.executeQueryableMethod = function(className, methodName, input, options) {
		var deferred = $q.defer();
		executeQueryableMethod(className, methodName, input, options, function(result, event) {
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
			template: 'myModalContent.html',
			controller: 'ModalInstanceCtrl',
			content: message,
			show:true,
			title: title
		});
	};

	factory.updateProductAttributes = function (objectId, jsonAttributes) {
		var deferred = $q.defer();
		updateProductAttributes(objectId, jsonAttributes, function(result, event) {
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

	factory.isSignatureRequired = function(objectId) {
		var deferred = $q.defer();
		isSignatureRequired(objectId, function(result, event) {
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

	factory.getContextualData = function(requestParamsString) {
		var deferred = $q.defer();
		getContextualData(requestParamsString, function(result, event) {
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
	
	return factory;
});

},{}],6:[function(require,module,exports){
angular.module('formatFilters', []).filter('numFormatFilter', function() {
    return function(input) {
    	var formatted = '';
        for (var i = 0; i < input.length; i++) {
        	if (input[i] === ',') {
        		formatted += thousandSep;
        	} else if (input[i] === '.') {
        		formatted += decimalSep;
        	} else {
        		formatted += input[i];
        	}
        }
        return formatted;
    };
});
},{}]},{},[1]);

})();