(function(){  var fileNsPrefix = (function() {
    'use strict';
    var scripts = document.getElementsByTagName('script');
    var lastScript = scripts[scripts.length - 1];
    var scriptName = lastScript.src;
    var parts = scriptName.split('/');
    var thisScript = parts[parts.length - 1];
    if (thisScript === "") {
      thisScript = parts[parts.length - 2];
    }

    // Fix to handle cases where js files are inside zip files
    // https://dev-card.na31.visual.force.com/resource/1509484368000/dev_card__cardframework_core_assets/latest/cardframework.js
    if(scriptName.indexOf('__') != -1 && thisScript.indexOf('__') == -1) {
        thisScript = parts[5] && parts[5].indexOf('__') != -1 ? parts[5] : thisScript;
    }

    var lowerCasePrefix = thisScript.indexOf('__') == -1 ? '' : thisScript.substring(0, thisScript.indexOf('__') + 2);
    //check for the cached namespace first
    lowerCasePrefix = lowerCasePrefix === '' && localStorage.getItem('nsPrefix') ? localStorage.getItem('nsPrefix'): lowerCasePrefix;
    
    if(lowerCasePrefix !== ''){
        lowerCasePrefix = /__$/.test(lowerCasePrefix) ? lowerCasePrefix : lowerCasePrefix + '__';
    }
    if (lowerCasePrefix.length === 0) {
      return function() {
        //then check if the app has put a namespace and take that one as it is newer
        lowerCasePrefix = window.nsPrefix ? window.nsPrefix: lowerCasePrefix;
        //add the underscore if it doesn't have them    
        if(lowerCasePrefix !== ""){
            lowerCasePrefix = /__$/.test(lowerCasePrefix) ? lowerCasePrefix : lowerCasePrefix + '__';
        }  
        return lowerCasePrefix;
      };
    } else {
      var resolvedNs = null;
      return function() {
        if (resolvedNs) {
          return resolvedNs;
        }
        // hack to make scan SF objects for the correct case
        try {
          var tofind = lowerCasePrefix.replace('__', '');
          var name;
          var scanObjectForNs = function(object, alreadySeen) {
            if (object && object !== window && alreadySeen.indexOf(object) == -1) {
                alreadySeen.push(object);
                Object.keys(object).forEach(function(key) {
                  if (key === 'ns') {
                    // do ns test
                    if (typeof object[key] === 'string' && object[key].toLowerCase() === tofind) {
                      name = object[key] + '__';
                      return false;
                    }
                  }
                  if (Object.prototype.toString.call(object[key]) === '[object Array]') {
                    object[key].forEach(function(value) {
                      var result = scanObjectForNs(value, alreadySeen);
                      if (result) {
                          name = result;
                          return false;
                      }
                    });
                  } else if (typeof object[key] == 'object') {
                    var result = scanObjectForNs(object[key], alreadySeen);
                    if (result) {
                        name = result;
                        return false;
                    }
                  }
                  if (name) {
                    return false;
                  }
                });
                if (name) {
                  return name;
                }
            };
          }
          if(typeof Visualforce !== 'undefined') { //inside VF
            scanObjectForNs(Visualforce.remoting.Manager.providers, []);  
          } else {
            return lowerCasePrefix;
          }
          if (name) {
            return resolvedNs = name;
          } else {
            return resolvedNs = lowerCasePrefix;
          }
        } catch (e) {
          return lowerCasePrefix;
        }
      };
    }
  })();

  var fileNsPrefixDot = function() {
    var prefix = fileNsPrefix();
    if (prefix.length > 1) {
      return prefix.replace('__', '.');
    } else {
      return prefix;
    }
  };
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var module = angular.module('vloc.planView', 
    ['vlocity','CardFramework' , 'sldsangular', 'ngSanitize', 'forceng', 'tmh.dynamicLocale',
     'cfp.hotkeys', 'VlocityDynamicForm', 'thorIntegration'])
    .config(['remoteActionsProvider', function(remoteActionsProvider) {
        remoteActionsProvider.setRemoteActions(window.remoteActions || {});
    }]);

module.constant('actionToEndpoint', {
                'getOrchestrationPlan': '/ordermanagement/v1/orchestrationplans/',
                'getOrchestrationItem': '/ordermanagement/v1/orchestrationitems/'
            });

module.constant('config', {
                grid_width: 200,
                grid_height: 182,
                header_height: 30,
                item_margin_x: 10,
                item_margin_top_y: 40,
                item_margin_bottom_y: 20,
                item_padding_x: 10,
                item_padding_y: 10,
                grid_padding_left: 90,
                label_font_size: 12,
                max_label_len: 6,
                dep_margin_y: 5
            });

// reload RemoteActions - overide with off-platform calls
angular.module('vloc.planView')
.config(function($provide) {
    $provide.decorator('remoteActions', function($delegate, $http, thorIntegrationService, actionToEndpoint) 
    {
        var originalRemoteActions = $delegate;
        // override the remoteActions methods you know may be off platform
        var potentiallyOffPlatformCalls = ['getOrchestrationPlan', 'getOrchestrationItem'];
        potentiallyOffPlatformCalls.forEach(function(remoteActionName) {
            var remoteActionCallFn = originalRemoteActions[remoteActionName];
            // override getOrchestrationPlan by using $http service to fetch Offplatform data
            originalRemoteActions[remoteActionName] = function() {
                var args = [].slice.call(arguments);
                var recordId = args[0];
                var isExternalId = !isNaN(parseFloat(recordId)) 
                                    && isFinite(recordId);
                if (isExternalId) {
                    // Thor data surce mode - fetch data via $http
                    return thorIntegrationService.getOffplatformUrl(originalRemoteActions)
                        .then(function(uiServiceUrl) {
                            var resourceUri = actionToEndpoint[remoteActionName] + recordId;
                            return thorIntegrationService.retryOperationInCaseAuthenticationError(
                                    function() {
                                        return $http({method: 'GET', url: uiServiceUrl + resourceUri + '/view', withCredentials: true})
                                                 .then(function success(response){
                                                    return response.data;
                                                    });
                                    },
                                    uiServiceUrl
                                )
                        });
                } else { // On-platform mode - fetch data using VF Remote manager (use origina function)
                    return remoteActionCallFn.apply(this, args);
                };
            }
        });
        return $delegate;
    })
});
require('./modules/planview/templates/templates.js');
require('./modules/planview/controller/PlanViewController.js');
require('./modules/planview/factory/commetd.js');
require('./modules/planview/directive/svg.js');

},{"./modules/planview/controller/PlanViewController.js":2,"./modules/planview/directive/svg.js":3,"./modules/planview/factory/commetd.js":4,"./modules/planview/templates/templates.js":9}],2:[function(require,module,exports){
var Grid = require ('../layout/layout.js');

angular
.module('vloc.planView')
.controller('PlanViewController', function($scope, $rootScope,$http, config, id, cometd, 
    remoteActions, $interval, taskTypes, $sldsModal, layoutDataService, thorIntegrationService,$window) {

    'use strict';

    $scope.staticResourceURL =vlocXOM.staticResourceURL;
    $scope.orchestrationPlan = {
        items: [],
        deps: []
    };
    $scope.currentOrchestrationPlan = {
        items: [],
        deps: []
    };
    $scope.RTLArray={
        items: [],
        deps: []
    };
    $scope.zoomVar = 100;
    $scope.scaleVal = 1;
    $scope.service = layoutDataService;
    config.grid_height = ($scope.service.attributMaxSize * 20) + 156;

    function convertDate(dateToConvert){
        var convertedMoment = moment(dateToConvert);

        if(dateToConvert === undefined)
            return dateToConvert;

        if(!convertedMoment.isValid()){
            // console.error('invalid date to convert ' + dateToConvert + ' reason number ', convertedMoment.invalidAt());
            return dateToConvert;
        }
        return convertedMoment.format('DD/MM/YYYY HH:mm:ss');
    
    }
    $scope.languageRTL = document.getElementsByTagName("html")[0].getAttribute("dir"); 
    if($scope.languageRTL =="rtl"){
        $scope.isRTL=true;
    }else{
        $scope.isRTL=false;
    }

    // Processes plan from server
    function processPlan (orchestrationPlan) {
        console.log ('Orchestration plan from the server', orchestrationPlan, Date.now());

        var swimlanes = orchestrationPlan.swimlanes,
            items = orchestrationPlan.items;
        $scope.OriginalOrderId = orchestrationPlan.orderId;
        $scope.OrderName = orchestrationPlan.orderName;

        var grid = new Grid();

        var swimlanesIdx = {};

        var i;
        var paddedDigits;
        var q;
        for (i = 0; i < swimlanes.length; i++) {
            if(swimlanes[i].showOrderStr!=null)
            {
                paddedDigits = 18 - swimlanes[i].showOrderStr.length;//Apex Number field allows max number with eighteen 9's : 999999999999999999
                for(q=0 ; q<paddedDigits; q++)//XOM-747
                {
                    swimlanes[i].showOrderStr = '0'+ swimlanes[i].showOrderStr;
                }
            }
            grid.addSwimlane (swimlanes[i].planDefId,
                            swimlanes[i].planDefName,
                            swimlanes[i].orderId,
                            swimlanes[i].orderName,
                            swimlanes[i].showOrderStr); //XOM-747
        }
        $scope.startDate =false;
        $scope.dueDate = false;


        for (i = 0; i < items.length; i++) {
            if(items[i].startDate){
                $scope.startDate =true; 
            }
            if(items[i].dueDate){
                $scope.dueDate =true;
            }
            var item = grid.addItem(items[i].id, grid.getSwimlane (items[i].planDefId, items[i].orderId), items[i].name, items[i].type, items[i].state);
            item.additionalId = items[i].additionalId;
            item.additionalName = items[i].additionalName;
            item.startDate = convertDate(items[i].startDate);
            item.dueDate = convertDate(items[i].dueDate);
            item.customTaskExecutionUrl = items[i].customTaskExecutionUrl;
            if(items[i].translatedState){
                item.translatedState=items[i].translatedState;
            }else{
                item.translatedState=items[i].state;
            }
            
            var deps = items[i].deps;

            for (var j = 0; j < deps.length; j++) {
                grid.addDependency (items[i].id, deps[j]);
            }

        }

        grid.layout ();

        //code change relate to RTL
        if($scope.languageRTL == "rtl"){
            var itemLength = grid.max_x+1;
            var rtlItemOrder = (Array.from(Array(itemLength).keys())).reverse();
            var rtlArray=[];
            for (var rtl = 0; rtl < grid.items.length; rtl++) {
                var itemR = grid.items[rtl];
                var posR = itemR.x;
                itemR.x = rtlItemOrder[posR];
                rtlArray.push(itemR);
            }
            $scope.orchestrationPlan.items = rtlArray;
        }else{
            $scope.orchestrationPlan.items = grid.items;;
        }

        $scope.orchestrationPlan.swimlanes = grid.swimlanes;
        $scope.orchestrationPlan.deps = grid.dependencies;
    }
    $scope.getCardItemHeight= function(){
        return $scope.opv_item_height;
    }
    $scope.viewMore= function(item){
            var itemDetails ={};
            remoteActions.getOrchestrationItem(item.id).then(function(ServerItemDetails) {
                        if(itemDetails){
                            itemDetails=ServerItemDetails
                            console.log("Item Details :"+itemDetails.parameters);
                            var modalScope = $scope.$new();
                            var productDetailsModal;
                            modalScope.isDetailLayoutLoaded = false;
                            modalScope.saving = false;
                            //$rootScope.cardItem =item;
                            modalScope.obj = $scope.$parent.obj;
                            modalScope.obj["item"] = item;
                            modalScope.obj["parameters"] = itemDetails.parameters;

                            productDetailsModal = $sldsModal({
                                backdrop: 'static',
                                scope: modalScope,
                                templateUrl:"OPVAttributeModal.tpl.html" ,
                                show: true
                            });
                        }
                    });
        
    };
    $scope.viewOriginalOrder= function(){
        window.open(parent.location.origin+'/'+$scope.OriginalOrderId);
    };
    $scope.isIdentical = function(currentItemArray,updatedItemArray) {
        if(Object.keys(currentItemArray.items).length>0){
            var currentPlanItemCount=currentItemArray.items.length;
            var updatedPlanItemCount= updatedItemArray.items.length;
            if(currentPlanItemCount != updatedPlanItemCount){
                return false;
            } 
            var currentItems = currentItemArray.items;
            var updatedItems = updatedItemArray.items;
             for(var i = 0; i < currentItems.length; i++) {
                if(currentItems[i].deps.length !== updatedItems[i].deps.length){
                    return false;
                }
                for(var j = currentItems[i].deps.length; j--;) {
                    if(currentItems[i].deps[j] !== updatedItems[i].deps[j]){
                        return false;
                    }
                }
            }
            return true;
        }
    }    
    $scope.getOrchestrationPlan = function(id) {

        // Reset previous timeout timeer
        if ($scope.updatePromise) {
            $interval.cancel ($scope.updatePromise);
        }


        remoteActions.getOrchestrationPlan (id)
            .then(function(orchestrationPlan) {
                console.log ('Setting interval');
                $scope.updatePromise = $interval(function() {
                    console.log ('Interval is called');
                     if(!thorIntegrationService.isOffAuthenticationInProgress)
                        $scope.getOrchestrationPlan(id);
                }, 30000);

                //Checking any update on items/items dependencies add/modify/delete
                var isIdentical =$scope.isIdentical($scope.currentOrchestrationPlan,orchestrationPlan);
                if(isIdentical==false){
                    $window.location.reload();
                }
                $scope.currentOrchestrationPlan=orchestrationPlan;
                
                processPlan(orchestrationPlan);

                // Remove (potentially) previous subscription to prevent a memory leak
                if ($scope.subscription) {
                    cometd.unsubscribe($scope.subscription);
                }

                console.log ('Loaded orchestration plan', $scope.orchestrationPlan);

                console.log ('Subscribing to ', '/topic/' + orchestrationPlan.topicName);

                // Subscribe on updates
                if ($scope.subscription) {
                    $scope.subscription = cometd.subscribe('/topic/' + orchestrationPlan.topicName, null, function(message) {
                        // Reread plan from server
                        if(!thorIntegrationService.isOffAuthenticationInProgress)
                            remoteActions.getOrchestrationPlan (id)
                                .then(processPlan(orchestrationPlan));
                    });
                }
                // FIXME: An attempt to fix race condition
                processPlan(orchestrationPlan);
            });

    };

    $scope.getCanvasWidth = function (swimlanes) {
        if (!swimlanes || swimlanes.length === 0) {
            return 100;
        }

        return (swimlanes[0].grid.max_x + 1) * config.grid_width + 2*config.grid_padding_left;
    };

    $scope.getCanvasHeight = function (swimlanes) {
        var height = 0;

        if (!swimlanes) {
            return 100;
        }

        for (var i = 0; i < swimlanes.length; i++) {
            height += $scope.getSwimlaneHeight(swimlanes[i]);
        }

        return height;
    };
    
    $scope.getItemTooltip = function(item) {
        var xomIs = $rootScope.vlocity.getCustomLabel('XOMIs','is');
        var toolTipText = item.name +' ('+ $scope.getItemText(item) +') '+xomIs+ ' '+item.translatedState;
        $("#itemLabel-"+item.id).attr("title",toolTipText);
        //return item.name +' ('+ $scope.getItemText(item) +') '+xomIs+ ' '+item.translatedState;
    };

    $scope.label2class = function(label) {
        return 'item-' + label.toLowerCase().replace(/[ \t\n,.]/, '-');
    };

    $scope.getItemX = function(item) {
        return item.x * config.grid_width + config.item_margin_x + config.grid_padding_left;
    };

    $scope.getItemY = function(item) {
        return item.y * config.grid_height + config.item_margin_top_y;
    };

    $scope.getItemWidth = function(item) {
        return config.grid_width - 2 * config.item_margin_x;
    };

    $scope.getItemHeight = function(item) {
        if($scope.startDate==true){
            $scope.opv_item_height="70";
        }
        var paramHeight = -32;
        if($scope.startDate ==true)
            paramHeight = paramHeight + 18;
        if($scope.dueDate ==true)
            paramHeight = paramHeight + 18;
        return config.grid_height - config.item_margin_top_y - config.item_margin_bottom_y + paramHeight;
    };

    $scope.getHeaderHeight = function(item) {
        return config.header_height;
    }

    $scope.getItemLabelX = function(item) {
        if(item.state == "Running" || item.state == "Cancelled" || item.state == "Failed" || item.state == "Fatally Failed" || item.state == "Completed" || item.state == "Started" || item.state == "On Hold"){
            if($scope.languageRTL =="rtl"){
                return $scope.getItemX(item) + config.item_padding_x+24;
            }
            return $scope.getItemX(item) + config.item_padding_x+40;
        }
        else{
            if($scope.languageRTL =="rtl"){
                return $scope.getItemX(item) + config.item_padding_x+40;
            }
            return $scope.getItemX(item) + config.item_padding_x+20;
        }
    };

    $scope.getItemLabelY = function(item) {
        return $scope.getItemY(item);
    };

    $scope.getItemTextX = function(item) {
        return $scope.getItemX(item) + config.item_padding_x;
    };

    $scope.getItemTextY = function(item) {
        return $scope.getItemY(item) + config.item_padding_y + config.header_height;
    };

    $scope.getItemTextWidth = function(item) {

        var bodyWidth = 0;

        if (!!ICON_PARAMS[item.state]) {
            bodyWidth = ICON_PARAMS[item.state].bodyWidth;
        }

        return $scope.getItemWidth(item) - 2 * config.item_padding_x - bodyWidth;

    };

    $scope.getItemLabelWidth = function(item) {

        var headerWidth = 0;

        if (!!ICON_PARAMS[item.state]) {
            headerWidth = ICON_PARAMS[item.state].headerWidth;
        }
        //XOM 428
        //return $scope.getItemWidth(item) - 2 * config.item_padding_x - headerWidth;
        var returnValue = $scope.getItemWidth(item) - 2 * config.item_padding_x - headerWidth;
        if(isNaN(returnValue)){
            return 142;
        }
        else{
            return returnValue;
        }
    };

    $scope.getViewMoreText= function () {
        return $scope.viewMoreText;
    }
    $scope.getlayoutConfigParamLabel = function(stringLabel){
        var tranText= "XOMModal"+stringLabel.replace(/[\s]/g, '');
        if(stringLabel.indexOf("(")>-1){
            tranText = tranText.substring(0,tranText.indexOf("("));
        }
        return $rootScope.vlocity.getCustomLabel(tranText,stringLabel);
    }
    $scope.getItemText = function (item) {
        var customLabelText = taskTypes[item.type].replace(/\b[a-z]/g,function(f){return f.toUpperCase();});
        customLabelText = "XOM"+customLabelText.replace(/\s/g, '');
        var transType = $rootScope.vlocity.getCustomLabel(customLabelText, taskTypes[item.type]);
        item.transType =transType;
        item.viewMoreText=$rootScope.vlocity.getCustomLabel('XOMViewMore','View More');
        return transType;
    }

    // $scope.getItemLabelHeight = function(item) {
    //     return $scope.getItemHeight(item) - 2 * config.item_padding_y;
    // };

    // $scope.getItemLabelText = function(item) {
    //     //console.log("Label", item.name, item.name.length)
    //     if (item.name.length > config.max_label_len) {
    //         //console.log(item.name.substring(0, config.max_label_len));
    //         return item.name.substring(0, config.max_label_len) + '...';
    //     }

    //     return item.name;
    // };

    function headerIconX (item) {
        var label = document.getElementById("itemLabel-"+item.id);
        if(label !=null && label !='undefined')
            label.style.left =$scope.getItemLabelX(item)+"px";            
        return $scope.getItemX(item)+10;
    }

    function headerIconY (item) {
        return $scope.getItemY(item) + ICON_PARAMS[item.state].height / 2;
    }

    function bodyIconX (item) {
        return $scope.getItemX(item) + $scope.getItemWidth(item) - ICON_PARAMS[item.state].height - config.item_margin_x;
    }

    function bodyIconY (item) {
        return $scope.getItemY(item) + ($scope.getItemHeight(item)- ICON_PARAMS[item.state].height + config.header_height) / 2;
    }

     var ICON_PARAMS = {
        'Completed': {
            fill: "#FFFFFF",
            stroke: "#FFFFFF",
            iconX: headerIconX,
            iconY: headerIconY,
            headerWidth: 40, // Space occupied in the header
            bodyWidth: 0, // Space occupied in the body
            width: 18,
            height: 13,
            icon: 'check' 
        },
        'Running': {
            fill: "#FFFFFF",
            stroke: "#FFFFFF",
            iconX: headerIconX,
            iconY: headerIconY,
            headerWidth: 18, // Space occupied in the header
            bodyWidth: 0, // Space occupied in the body
            width: 18,
            height: 13,
            icon: 'feed' 
        },
        'On Hold': {
            fill: "#16325c",
            stroke: "#16325c",
            iconX: headerIconX,
            iconY: headerIconY,
            headerWidth: 18, // Space occupied in the header
            bodyWidth: 0, // Space occupied in the body
            width: 18,
            height: 13,
            icon: 'touch_action' 
        },
        'Started': {
            fill: "#FFFFFF",
            stroke: "#FFFFFF",
            iconX: headerIconX,
            iconY: headerIconY,
            headerWidth: 18, // Space occupied in the header
            bodyWidth: 0, // Space occupied in the body
            width: 18,
            height: 13,
            icon: 'feed' 
        },
        'Failed': {
            fill: "#FFFFFF",
            stroke: "#FFFFFF",
            iconX: headerIconX,
            iconY: headerIconY,
            headerWidth: 0, // Space occupied in the header
            bodyWidth: 0, // Space occupied in the body
            width: 18,
            height: 13,
            icon: 'refresh'
        },
        'Fatally Failed': {
            fill: "#FFFFFF",
            stroke: "#FFFFFF",
            iconX: headerIconX,
            iconY: headerIconY,
            headerWidth: 18, // Space occupied in the header
            bodyWidth: 0, // Space occupied in the body
            width: 18,
            height: 13,
            icon: 'warning'
        },
        'Cancelled': {
            fill: "#FFFFFF",
            stroke: "#FFFFFF",
            iconX: headerIconX,
            iconY: headerIconY,
            headerWidth: 0,
            width: 18,
            height: 13,
            bodyWidth: 0, // Space occupied in the body
            icon: 'close'
        }
    };

    $scope.getItemIconX = function(item) {
        if($scope.languageRTL == "rtl"){
            return ICON_PARAMS[item.state].iconX(item)+142;
        }else{
            return ICON_PARAMS[item.state].iconX(item);
        }
    };

    $scope.getItemIconY = function(item) {
        return ICON_PARAMS[item.state].iconY(item);
    };

    $scope.getItemIconWidth = function(item) {
        return ICON_PARAMS[item.state].width;
    };

    $scope.getItemIconHeight = function(item) {
        return ICON_PARAMS[item.state].height;
    };

    $scope.getIconColor = function (item) {
        return ICON_PARAMS[item.state].fill;
    }

    $scope.shouldShowIcon = function(item) {
        return !!ICON_PARAMS[item.state];
    }

    $scope.getIconURL = function(baseURL, item) {
        return $scope.staticResourceURL.slds+baseURL+'#'+ICON_PARAMS[item.state].icon;
    }

    $scope.getSwimlaneX = function(swimlane) {
        return 0;
    };
    $scope.getSwimlaneX1 = function(swimlane) {
        if($scope.languageRTL =="rtl"){
            return "right";
        }else{
            return "left";
        }

    };

    $scope.getSwimlaneX2 = function(item) {
        return $scope.getSwimlaneX(item) + $scope.getSwimlaneWidth(item);
    };

    $scope.getSwimlaneY = function(swimlane) {
        //console.log('GetSLY', swimlane);
        return swimlane.y * config.grid_height;
    };

    $scope.getSwimlaneY2 = function(item) {
        return $scope.getSwimlaneY(item) + $scope.getSwimlaneHeight(item);
    };

    $scope.getSwimlaneWidth = function(swimlane) {
        return (swimlane.grid.max_x + 1) * config.grid_width + config.grid_padding_left;
    };

    $scope.getSwimlaneHeight = function(swimlane) {
        return swimlane.height * config.grid_height;
    };

    $scope.getOrderLabelX = function (swimlane) {
        return 10;
    };

    $scope.getOrderLabelY = function (swimlane) {
        //console.log('OLY',swimlane);
        return swimlane.height * config.grid_height + 10;
    };

    $scope.getOrderLabelWidth = function (swimlane) {
        return config.grid_padding_left - 20;
    };

    $scope.getOrderLabelHeight = function (swimlane) {
        return 20;
    };

    $scope.buildPath = function(dep) {
        var item1 = dep.dependsOn,
            item2 = dep.item;
        if($scope.languageRTL == "rtl"){
            var x1 = $scope.getItemX(item1),
            x2 = $scope.getItemX(item2)+ $scope.getItemWidth(item1),
            dx = item1.x - item2.x,
            dy = item1.y - item2.y;
            var xM = (item2.x + 1) * config.grid_width + config.grid_padding_left;
        }
        else{
            x1 = $scope.getItemX(item1) + $scope.getItemWidth(item1),
            x2 = $scope.getItemX(item2),
            dx = item2.x - item1.x,
            dy = item2.y - item1.y;
            var xM = (item1.x + 1) * config.grid_width + config.grid_padding_left;
        }
        var y1 = $scope.getItemY(item1) + $scope.getItemHeight(item1) / 2,
            y2 = $scope.getItemY(item2) + $scope.getItemHeight(item2) / 2,
            path = 'M' + x1 + ',' + y1 + ' ';


        var y3, x4;

        // Let's do special cases first
        if (dy === 0) {
            // Straigh line
            path += 'L' + x2 + ',' + y2;
        } else if (dx == 1) {
            // Simple hook
            path += 'L' + xM + ',' + y1 + ' ';
            path += 'L' + xM + ',' + y2 + ' ';
            path += 'L' + x2 + ',' + y2;
        } else if (dy > 0) {
            // Multi-segment connector
            y3 = (item1.y + 1) * config.grid_height + config.dep_margin_y;
            x4 = item2.x * config.grid_width + config.grid_padding_left;
            path += 'L' + xM + ',' + y1 + ' ';
            path += 'L' + xM + ',' + y3 + ' ';
            path += 'L' + x4 + ',' + y3 + ' ';
            path += 'L' + x4 + ',' + y2 + ' ';
            path += 'L' + x2 + ',' + y2;
        } else {
            // Upper hook
            y3 = item1.y * config.grid_height + config.dep_margin_y;
            x4 = item2.x * config.grid_width + config.grid_padding_left;
            path += 'L' + xM + ',' + y1 + ' ';
            path += 'L' + xM + ',' + y3 + ' ';
            path += 'L' + x4 + ',' + y3 + ' ';
            path += 'L' + x4 + ',' + y2 + ' ';
            path += 'L' + x2 + ',' + y2;
        }

        return path;

    };

    $scope.highlightItemAndDependencies = function (item) {
        console.log('highlightItemAndDependencies', item, $scope.orchestrationPlan.items);
        var highlightedDeps = $scope.orchestrationPlan.highlightedDeps = [];
        var highlightedItems = $scope.orchestrationPlan.highlightedItems = [item];

        item.dependencies.forEach (function (dep) {
            highlightedItems.push(dep.dependsOn);
            highlightedDeps.push(dep);
        });

        item.dependents.forEach (function (dep) {
            highlightedItems.push(dep.item);
            highlightedDeps.push(dep);
        });

        //console.log('Deps', item.dependencies);
        //console.log('Deps\'ants', item.dependents);
    };

    $scope.unhighlightItemAndDependencies = function () {
        $scope.orchestrationPlan.highlightedDeps = null;
        $scope.orchestrationPlan.highlightedItems = null;
        console.log ('Exiting');
    };

    // Set id from context and fetch orchestration plan either from SFDC or Off-platform endpoint
    console.log('identifying plan id from contextId ', id);
    remoteActions.getOrchestrationPlanId (id)
            .then(function(orchestrationPlanId) {
                console.log('orchestrationPlanId: ' + orchestrationPlanId );
                $scope.getOrchestrationPlan(orchestrationPlanId);
                $scope.orchestrationPlanId=orchestrationPlanId;
                $scope.isExternalId = !isNaN(parseFloat(orchestrationPlanId)) 
                                     && isFinite(orchestrationPlanId);                
            });

    // Unsubscribe when user leaves the page
    $scope.$on('$locationChangeStart', function (event) {
        cometd.disconnect();
    });
    $scope.zoomPath = function(){
    	console.log('****in zoompath..');
        var paths = document.getElementsByClassName('dep');
        if($scope.zoomVar < 70)
        {
            for(var i=0; i<paths.length; i++){
                paths[i]['style']['stroke-width'] = '4px';
            }
        }
        if($scope.zoomVar >= 70 && $scope.zoomVar <= 140)
        {
            for(var i=0; i<paths.length; i++){
                paths[i]['style']['stroke-width'] = '2px';
            }
        }
        if($scope.zoomVar > 140)
        {
            for(var i=0; i<paths.length; i++){
                paths[i]['style']['stroke-width'] = '1px';
            }
        }
    };
    $scope.zoomIn = function()
    {
        $scope.zoomPath();
        console.log('$scope.zoomVar: '+$scope.zoomVar+'$scope.scaleVal: '+$scope.scaleVal);
        var myPage = document.getElementById('canvas');
        $scope.zoomVar = parseInt(myPage.style.zoom) + 10 ;
        $scope.zoomVar = parseInt($scope.zoomVar);
        //myPage.style.zoom = $scope.zoomVar+'%';
        var myPageStyle = myPage.style;
        myPageStyle['transform'] 				= 'scale('+$scope.scaleVal+')';
        myPageStyle['transform-origin'] 		=  '0 0';
        myPageStyle['-webkit-transform'] 		= 'scale('+$scope.scaleVal+')';
        myPageStyle['-webkit-transform-origin-x'] =  '0';
        myPageStyle['-webkit-transform-origin-y'] =  '0';
        myPageStyle['-ms-transform'] 			= 'scale('+$scope.scaleVal+')';
        myPageStyle['-ms-transform-origin'] 	=  '0 0';
        myPageStyle.MozTransform 				= 'scale('+$scope.scaleVal+')';
        myPageStyle.MozTransformOrigin			= '0 0';
        return false;
    }
     
    $scope.zoomOut =  function()
    {
        $scope.zoomPath();
        $scope.scaleVal=$scope.scaleVal-0.1;
        console.log('$scope.zoomVar: '+$scope.zoomVar+'$scope.scaleVal: '+$scope.scaleVal);
        var myPage = document.getElementById('canvas');
        $scope.zoomVar = parseInt(myPage.style.zoom) - 10 ;
        $scope.zoomVar = parseInt($scope.zoomVar);
        //myPage.style.zoom = $scope.zoomVar+'%';
        var myPageStyle = myPage.style;
        myPageStyle['transform'] 				= 'scale('+$scope.scaleVal+')';
        myPageStyle['transformOrigin'] 		=  '0 0';
        myPageStyle['-webkit-transform'] 		= 'scale('+$scope.scaleVal+')';
        myPageStyle['-webkit-transform-origin-x'] =  '0';
        myPageStyle['-webkit-transform-origin-y'] =  '0';
        myPageStyle['-ms-transform'] 			= 'scale('+$scope.scaleVal+')';
        myPageStyle['-ms-transform-origin'] 	=  '0 0';
        myPageStyle.MozTransform	= 'scale('+$scope.scaleVal+')';
        myPageStyle['-moz-transform-origin']	= '0 0';
        return false;
    }

    $scope.resolveNavigate = function(recordId)
    {
        var isExternalId = !isNaN(parseFloat(recordId)) && isFinite(recordId);
        if(!isExternalId)
        {
            window.open('/' + recordId);
        } else 
        {
            window.open('/apex/XOMObjectParams#!/object/' + recordId);
        }
    }
    $scope.customPerformAction = function(action, params,recordId)
    {
    var isExternalId = !isNaN(parseFloat(recordId)) && isFinite(recordId);
        if(!isExternalId)
        {
           var url='/' + recordId;
        } else 
        {
            var url='/apex/XOMObjectParams#!/object/' + recordId;
        }
        if (params) {
            var nsPrefix = $rootScope.nsPrefix;
            if(action[nsPrefix + 'OpenUrlMode__c'])
            {
                var urlMode  = action[nsPrefix + 'OpenUrlMode__c'];
            }
            if(action[nsPrefix + 'OpenURLMode__c'])
            {
                var urlMode  = action[nsPrefix + 'OpenURLMode__c'];
            }

            action[nsPrefix + 'UrlParameters__c'] = recordId;
            action[nsPrefix + 'URL__c']=url;
            var isInConsole = (window.sforce && sforce.one);
            if(isInConsole){
              urlMode = "Current window";
            }
            $scope.performAction({
            type: 'Custom',
            isCustomAction: true,
            url: url,
            openUrlIn: urlMode
            });
          }
    }
});

},{"../layout/layout.js":7}],3:[function(require,module,exports){
// Hack to work around anguler/WebKit bug
angular.module('vloc.planView')
    .directive('ngX', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngX, function(value) {
                element.attr('x', value);
            });
        };
    })
    .directive('ngY', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngY, function(value) {
                element.attr('y', value);
            });
        };
    })
    .directive('ngX1', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngX1, function(value) {
                element.attr('x1', value);
            });
        };
    })
    .directive('ngY1', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngY1, function(value) {
                element.attr('y1', value);
            });
        };
    })
    .directive('ngX2', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngX2, function(value) {
                element.attr('x2', value);
            });
        };
    })
    .directive('ngY2', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngY2, function(value) {
                element.attr('y2', value);
            });
        };
    })
    .directive('ngWidth', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngWidth, function(value) {
                element.attr('width', value);
            });
        };
    })
    .directive('ngHeight', function() {
        return function(scope, element, attrs) {
            scope.$watch(attrs.ngHeight, function(value) {
                element.attr('height', value);
            });
        };
    });

},{}],4:[function(require,module,exports){
// Factory implementation for cometd
// Depends on JQuery and JQuery.Cometd
// sessionId is a constant with current session
angular.module('vloc.planView').factory('cometd', function($rootScope, sessionId) {
    var cometd = $.cometd;

    // Configure cometd
    cometd.configure({
        url: window.location.protocol + '//' + window.location.hostname + '/cometd/24.0/',
        requestHeaders: {Authorization: 'OAuth ' + sessionId},
        logLevel: 'info'
    });

    // Add a listener for the handshake *TODO* what should be done if message fails ?
    cometd.addListener('/meta/handshake', function(message) { console.log(message); });

    // Handshake with the server
    cometd.handshake();

    return {
        addListener: function(channel, scope, callback) {
            cometd.addListener(channel, scope, function() {
                var args = arguments;
                $rootScope.$apply(function() {
                    callback.apply(cometd, args);
                });
            });
        },

        removeListener: function(subscription) {
            cometd.removeListener(subscription);
        },

        subscribe: function(channel, scope, callback, subscribeProps) {
            cometd.subscribe(channel, scope, function() {
                var args = arguments;
                console.log ('Cometd:receive', args);
                $rootScope.$apply(function() {
                    callback.apply(cometd, args);
                });
            }, subscribeProps);
        },

        unsubscribe: function(subscription, unsubscribeProps) {
            cometd.unsubscribe(subscription, unsubscribeProps);
        },

        publish: function(channel, content, publishProps, publishCallback) {
            cometd.publish(channel, content, publishProps, function() {
                var args = arguments;
                $rootScope.$apply(function() {
                    publishCallback.apply(cometd, args);
                });
            });
        },

        disconnect: function(sync, disconnectProps) {
            cometd.disconnect(sync, disconnectProps);
        },

        batch: function(scope, callback) {
            cometd.batch(scope, function() {
                var args = arguments;
                $rootScope.$apply(function() {
                    callback.apply(cometd, args);
                });
            });
        }
    };
});

},{}],5:[function(require,module,exports){
var BinaryHeap = function(comp) {

    'use strict';

    // default to max heap if comparator not provided
    comp = comp || function(a, b) {
        return a > b;
    };

    var arr = [];

    var swap = function(a, b) {
        var temp = arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    };

    var bubbleDown = function(pos) {
        var left = 2 * pos + 1;
        var right = left + 1;
        var largest = pos;

        if (left < arr.length && comp(arr[left], arr[largest])) {
            largest = left;
        }

        if (right < arr.length && comp(arr[right], arr[largest])) {
            largest = right;
        }

        if (largest != pos) {
            swap(largest, pos);
            bubbleDown(largest);
        }
    };

    var bubbleUp = function(pos) {
        if (pos <= 0) {
            return;
        }

        var parent = Math.floor((pos - 1) / 2);

        if (comp(arr[pos], arr[parent])) {
            swap(pos, parent);
            bubbleUp(parent);
        }
    };

    var that = {};

    this.isEmpty = function () {
        return arr.length === 0;
    };

    this.pop = function() {

        if (arr.length === 0) {
            throw new Error('pop() called on emtpy binary heap');
        }

        var value = arr[0];
        var last = arr.length - 1;

        arr[0] = arr[last];
        arr.length = last;

        if (last > 0) {
            bubbleDown(0);
        }

        return value;
    };

    this.push = function(value) {
        arr.push(value);
        bubbleUp(arr.length - 1);
    };

    this.size = function() {
        return arr.length;
    };

};

module.exports = BinaryHeap;

},{}],6:[function(require,module,exports){
// Simple greedy algorithm for swimlanes sorting
// To approach this task we use the following approach:
// 1. We build an unoriented fully connected weighted graph.
// 2. Nodes are swimlanes.
// 3. Edges correspond to links between swimlanes.
// 4. Weights on edges are number of links between the corresponding swimlines. The weight can be zero
// 5. We assume that 0th swimline corresponds to end-to-end and should stay in place
// 6. We want to find a maximum cost path starting from 0th node and passing all nodes, i.e. that's a classic TSP problem
// 7. To simplify the things we will use a greedy algorithm as the fastest one
// 8. We use a matrix to represent the graph

// Graph with n nodes
function Graph (n) {

    'use strict';

    this.n = n;
    this.matrix = new Array(n * n);

    // Put a negative number to the diagonal so we never go to themselves
    for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {

            if (i == j) {
                this.matrix[i * n + j] = -1;
            } else {
                this.matrix[i * n+ j] = 0;
            }
        }
    }

    this.get = function (i, j) {
        return this.matrix[i * n + j];
    };

    this.set = function (i, j, w) {
        // Matrix is symmetric
        this.matrix[i * n + j] = w;
        this.matrix[i + j * n] = w;
    };

    // Increments value a i, j
    // Should not be used for i==j
    this.incr = function (i, j) {

        if (i == j) {
            return;
        }

        // Matrix is symmetric
        this.matrix[i * n + j]++;
        this.matrix[i + j * n]++;
    };

    this.calculateMaxPath = function () {

        if (this.n == 1) {
            return [0];
        }

        var res = [];

        var visitedElements = {};

        var currentElement = 0;

        var cnt = 0;

        while (true) {

            cnt++;

            res.push(currentElement);
            visitedElements[currentElement] = 1;

            //console.log('Current element', currentElement, visitedElements);

            var maxIdx = -1;
            var max = -1;

            var offset = currentElement * n;

            // Find the max unvisited
            for (var i = 0; i < this.n; i++) {

                if (!visitedElements[i]) {
                    // Only consider unvisited elements

                    var w = this.matrix[offset + i];

                    if (w > max) {
                        max = w;
                        maxIdx = i;
                    }

                }

            }

            if (maxIdx == -1) {
                // Did not find any unvisited
                // Break the cycle
                break;
            }

            currentElement = maxIdx;

        }

        return res;

    };

}

module.exports = Graph;

},{}],7:[function(require,module,exports){
var Graph = require('./graph.js');
var SymmetricMatrix = require('./matrix.js');
var BinaryHeap = require('./bheap.js');

// Utility function not to require the whole lodash
function forEach(m, f) {

    'use strict';

    for (var k in m) {
        if (m.hasOwnProperty(k)) {
            f(k, m[k]);
        }
    }
}

function Item(id, swimlane, name, type, state) {

    'use strict';

    this.id = id;
    this.swimlane = swimlane;
    this.name = name;
    this.x = -1;
    this.y = -1;
    this.dependencies = [];
    this.dependents = [];

    // isProcessed is used in topo sort
    this.isProcessed = false;

    // isLayedOut is used in layouting
    this.isLayedOut = false;
    this.state = state;
    this.type = type;

    // Upper index: lower incoming/outging dependencies - upper incoming/outgoing dependencies
    // Items with lower index will be put upper in the swimline
    this.upperIndex = 0;

    // Index in swimlane items
    this.swimlaneIdx = swimlane.items.length;

    swimlane.items.push(this);
}

function Dependency(id, itemId, dependsOnId) {
    this.itemId = itemId;
    this.dependsOnId = dependsOnId;
    this.item = null;
    this.dependsOn = null;
    this.id = 'd' + id;
    //this.segments = [];
}

function Swimlane(grid, idx, planDefId, planDefName, orderId, orderName) {
    this.grid = grid;
    this.idx = idx;
    this.y = -1;
    this.max_x = -1;
    this.height = 0;
    this.planDefId = planDefId;
    this.planDefName = planDefName;
    this.orderId = orderId;
    this.orderName = orderName;
    this.items = [];
}

function Grid() {

    this.items = [];
    this.itemsIdx = {};
    this.dependencies = [];
    this.swimlanes = [];
    this.swimlanesIdx = {};
    this.max_x = 0;
    this.depsIdx = 0;

    function getSwimlaneId(planDefId, orderId) {
        return planDefId + ':' + orderId;
    }

    this.addSwimlane = function(planDefId, planDefName, orderId, orderName, showOrder) {
        var swimlaneId = getSwimlaneId(planDefId, orderId);
        var swimlane = this.swimlanesIdx[swimlaneId];

        if (!swimlane) {
            swimlane = new Swimlane(this, this.swimlanes.length, planDefId, planDefName, orderId, orderName);
            swimlane.showOrder = showOrder;
            this.swimlanesIdx[swimlaneId] = swimlane;
            this.swimlanes.push(swimlane);
        }

        return swimlane;
    };

    this.getSwimlane = function (planDefId, orderId) {
        var id = getSwimlaneId(planDefId, orderId);
        return this.swimlanesIdx[id];
    };

    this.addItem = function (id, swimlane, name, type, state) {
        var item = this.itemsIdx[id] = new Item(id, swimlane, name, type, state);
        this.items.push(item);
        return item;
    };

    this.getItem = function (id) {
        return this.itemsIdx[id];
    };

    this.addDependency = function (itemId, dependsOnId) {
        this.dependencies.push(new Dependency(this.depsIdx++, itemId, dependsOnId));
    };

    // Lays out items on the grid
    this.layout = function () {

        if (this.swimlanes.length === 0) {
            // Safeguard for empty response
            return;
        }
        
        //XOM-747: modified version of XOM-429
        // Sort swimlines by name
        this.swimlanes.sort(function(a, b) {
            var aName = a.orderName+'_'+a.planDefName;
            var bName = b.orderName+'_'+b.planDefName;
            if (a.showOrder == null) {
                a.showOrder = 9999999999999999999; //19 digits
            }
 
            if (b.showOrder == null) {
            	b.showOrder = 9999999999999999999; //19 digits
            }
            
            
            if (a.showOrder > b.showOrder) {
                return 1;
            } else if (a.showOrder < b.showOrder) {
                return -1;
            } else {
            	console.log('Sort by orderNum/FRNum followed by PlanDefnName since '+a.showOrder+'=='+b.showOrder);
                if(aName > bName){
                	return 1;
                }else if (aName < bName) {
                    return -1;
                } else {
                	return 0;
                }
            }
 
        });
        var itemsIdx = this.itemsIdx;
        var graph = new Graph (this.swimlanes.length);

        //// console.log ('Layout items ', itemsIdx);
        //
        // console.log ('Layout 0', Date.now());

        // Resolve dependencies
        this.dependencies.forEach (function(dep) {

            var item = itemsIdx[dep.itemId];
            var dependsOn = itemsIdx[dep.dependsOnId];

            if (!item) {
                throw 'Can\'t resolve an item ' + item;
            }

            if (!dependsOn) {
                throw 'Can\'t resolve an item ' + dependsOn;
            }

            item.dependencies.push(dep);
            dependsOn.dependents.push(dep);

            dep.item = item;
            dep.dependsOn = dependsOn;

        });

        // console.log ('Layout 1', Date.now());

        var workingSet = {};

        // Locate items without any dependencies, they will be an initial working set
        // And will be placed into column 0
        forEach (itemsIdx, function (id, item) {

            if (!item.dependencies.length) {
                workingSet[item.id] = item;
            } else {
                // Iterate through dependencies and calculate swimlanes adjacency matrix

                var deps = item.dependencies;
                var itemSwimlaneIdx = item.swimlane.idx;

                for (var i = 0; i < deps.length; i++) {

                    //// console.log ('Deps', deps[i]);

                    var depSwimlaneIdx = deps[i].dependsOn.swimlane.idx;

                    if (itemSwimlaneIdx != depSwimlaneIdx) {
                        graph.incr(itemSwimlaneIdx, depSwimlaneIdx);
                    }

                }

            }

        });

        // Now iterating till the no more items are in the working set

        var newWorkingSet = {};
        var round = 0;

        // Utility function checking of dependency is satisfied
        function isDepedencySatisfied(dep) {
            return dep.dependsOn.isProcessed;
        }

        // Process item and put all resolved dependencies into the new working set
        function processItem(id, item) {
            //// console.log ('processItem', id, item);
            if (item.isProcessed) {
                // Cycle is detected
                throw new Error('Cycle is detected for item with id=' + item.id);
            }

            item.x = round;

            item.isProcessed = true;

            item.dependents.forEach (function(itemDep) {

                var candidate = itemDep.item;

                if (candidate.dependencies.every(isDepedencySatisfied)) {
                    newWorkingSet[candidate.id] = candidate;
                }

            });

        }

        // Cycle invariant:
        // - All items in the working set is unprocessed (otherwise, there is a cycle)
        // - All items in the working set have all of the dependencies processed
        while (Object.keys(workingSet).length > 0) {

            forEach (workingSet, processItem);

            workingSet = newWorkingSet;
            newWorkingSet = {};
            round++;

        }

        // Now lets calculate swimlanes ordering
        //var swimlanesOrder = graph.calculateMaxPath();

        var y = 0;

        var upperSwimlanes = {};

        // And calculate Y based on swimlanes ordering
        for (var i = 0; i < this.swimlanes.length; i++) {

            var swimlane = this.swimlanes[i];

            swimlane.y = y;

            var swimlaneItems = swimlane.items;

            var runMatrix = new SymmetricMatrix(swimlaneItems.length);

            var orderedItems = new BinaryHeap (function(item1, item2) {

                return (item1.x < item2.x) ||
                        ((item1.x == item2.x) && (item1.upperIndex < item2.upperIndex));

            });

            for (var j = 0; j < swimlaneItems.length; j++) {

                var swimlaneItem = swimlaneItems[j];

                if (swimlaneItem.x > swimlane.max_x) {
                    swimlane.max_x = swimlaneItem.x;
                }

                if (swimlane.max_x > this.max_x) {
                    this.max_x = swimlane.max_x;
                }

                var k;

                // Calculate runs between items and incoing/outgoing links from the top
                for (k = 0; k < swimlaneItem.dependents.length; k++) {

                    if (swimlaneItem.swimlane.idx == swimlaneItem.dependents[k].item.swimlane.idx) {
                        // The same swimlane
                        runMatrix.set(j, swimlaneItem.dependents[k].item.swimlaneIdx, swimlaneItem.dependents[k].item.x - swimlaneItem.x);
                    } else if (upperSwimlanes[swimlaneItem.dependents[k].item.swimlane.idx]) {
                        swimlaneItem.upperIndex--;
                    } else {
                        swimlaneItem.upperIndex++;
                    }

                }

                // Calculate incoing/outgoing links from the top
                for (k = 0; k < swimlaneItem.dependencies.length; k++) {

                    if (upperSwimlanes[swimlaneItem.dependencies[k].dependsOn.swimlane.idx]) {
                        swimlaneItem.upperIndex--;
                    } else {
                        swimlaneItem.upperIndex++;
                    }

                }

                orderedItems.push(swimlaneItem);
            }

            var yBefore = y;

            // Now swimlines are sorted in x,upperIndex order
            while (!orderedItems.isEmpty()) {

                var item = orderedItems.pop();

                if (item.isLayedOut) {
                    continue;
                }

                item.y = y;
                item.isLayedOut = true;

                //// console.log ('Layout: Item', item);

                var currentItemIdx = item.swimlaneIdx;

                while (true) {

                    var max = -1;
                    var longestRunItemIdx = -1;

                    for (var jj = 0; jj < swimlaneItems.length; jj++) {

                        if (!swimlaneItems[jj].isLayedOut) {

                            var run = runMatrix.get(currentItemIdx, jj);

                            // There is a dependency
                            if (run > 0) {

                                if (run > max) {
                                    max = run;
                                    longestRunItemIdx = jj;
                                }

                            }

                        }

                    }

                    if (longestRunItemIdx < 0) {
                        // Did not find any runs, laying out the next line
                        break;
                    }

                    swimlaneItems[longestRunItemIdx].y = y;
                    swimlaneItems[longestRunItemIdx].isLayedOut = true;

                    currentItemIdx = longestRunItemIdx;

                }

                y++;

            }

            swimlane.height = y - yBefore;

            upperSwimlanes[i] = 1;

        }

    };

}

module.exports = Grid;

},{"./bheap.js":5,"./graph.js":6,"./matrix.js":8}],8:[function(require,module,exports){
function SymmetricMatrix (n) {

    'use strict';

    this.n = n;

    var n2 = n * n;

    var matrix = this.matrix = new Array(n2);

    for (var i = 0; i < n2; i++) {
        matrix[i] = 0;
    }

    this.set = function(i, j, w) {
        this.matrix[i * this.n + j] = w;
    };

    this.get = function(i, j) {
        return this.matrix[i * this.n + j];
    };

    this.findMax = function(i) {

        var offset = i * n;
        var maxJ = -1;
        var max = -1;

        for (var j = 0; j < this.n; j++) {

            if (this.matrix[offset + j] > max) {
                max = this.matrix[offset + j];
                maxJ = j;
            }

        }

        return maxJ;

    };

}

module.exports = SymmetricMatrix;

},{}],9:[function(require,module,exports){
angular.module("vloc.planView").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("OPVAttributeModal.tpl.html",'<div class="slds-modal slds-fade-in-open slds-modal--large">\n    <div id="opv-model-container" class="slds-modal__container" style="width:50%;min-width:25rem;">\n        <div class="slds-modal__header">\n        <h2 class="slds-text-heading--medium">{{::$root.vlocity.getCustomLabel(\'XOMOrchestrationModalTitle\', \'Orchestration Item Details\')}}</h2>\n    </div>\n    <div class="slds-modal__content slds-p-around--x-large" style="min-height: 200px;">\n        <div class="slds-is-relative" ng-if="!isDetailLayoutLoaded">\n            <div class="slds-spinner--brand slds-spinner slds-spinner--large slds-m-top--x-large slds-m-bottom--x-large" aria-hidden="false" role="alert">\n                <div class="slds-spinner__dot-a"></div>\n                <div class="slds-spinner__dot-b"></div>\n            </div>\n        </div>\n\n        <div class="vlc-framed slds-scrollable--y">\n            <vloc-layout layout-name="{{data.flyout.layout}}" parent="obj" is-loaded="isDetailLayoutLoaded" ctrl="PlanViewController" records="productObj">\n        </vloc-layout>\n        </div>\n    </div>\n        <div class="slds-modal__footer slds-is-relative">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="$hide()">{{::$root.vlocity.getCustomLabel(\'XOMClose\', \'Close\')}}</button>\n\n            <!--div class="slds-spinner--brand slds-spinner slds-spinner--small" aria-hidden="false" role="alert" ng-if="saving"-->\n                <div class="slds-spinner__dot-a"></div>\n                <div class="slds-spinner__dot-b"></div>\n            </div>\n        </div>\n    </div>\n</div>')}]);
},{}]},{},[1]);

})();