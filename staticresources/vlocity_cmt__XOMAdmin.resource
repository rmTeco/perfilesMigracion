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
var module = angular.module('xomadmin', ['vlocity', 'ngRoute', 'thorIntegration'])
    .config(['remoteActionsProvider','$compileProvider', '$routeProvider', function(remoteActionsProvider, $compileProvider, $routeProvider) {
        remoteActionsProvider.setRemoteActions(window.remoteActions || {});
        $compileProvider.debugInfoEnabled(true); // Remove debug info (angularJS >= 1.3)

        console.log('Configuring routes');

        $routeProvider
                .when('/', {
                    templateUrl: 'XOMAdmin.tpl.html',
                    controller: 'XOMAdminController'
                })
                .when('/configureLayouts', {
                    templateUrl: 'XOMConfigureLayouts.tpl.html',
                    controller: 'XOMConfigureLayoutsController'
                })
                .otherwise({
                    redirectTo: '/'
                });

    }])
    .run(['$route', function() {}]);

require('./modules/xomadmin/controller/XOMAdminController.js');
require('./modules/xomadmin/controller/XOMAdminHomeController.js');
require('./modules/xomadmin/controller/XOMConfigureLayoutsController.js');
require('./modules/xomadmin/templates/templates.js');


},{"./modules/xomadmin/controller/XOMAdminController.js":2,"./modules/xomadmin/controller/XOMAdminHomeController.js":3,"./modules/xomadmin/controller/XOMConfigureLayoutsController.js":4,"./modules/xomadmin/templates/templates.js":5}],2:[function(require,module,exports){
angular.module('xomadmin').controller('XOMAdminController',
    [
        '$scope', '$window', '$location', '$timeout', 'remoteActions', 'config', '$http',
        'thorIntegrationService', 'labelsSyncService',
        function($scope, $window, $location, $timeout, remoteActions, config, $http,
                 thorIntegrationService, labelsSyncService)
        {

            var BATCH_SIZE = 1000;

            $scope.isThorEnabled = config.isThorEnabled == 'true';
            $scope.isDeltaTrackingEnabled = config.isDeltaTrackingEnabled == 'true';
            $scope.isDevEnabled = /devMode=true/.exec(window.location.search);

            console.log('Config:', config);
            console.log('Scope: ', $scope);

            $scope.forcePopulateSyncDelta = function()
            {

                console.log('Force populate Sync Delta');

                $scope.showSpinner = true;

                var sliceBatch = function(scope, start)
                {

                    console.log('Scope length', scope.length);

                    console.log('Preparing batch starting with', start);

                    var pos = 0;

                    var request = [];

                    for (var i = 0; i < scope.length; i++)
                    {
                        var item = scope[i];

                        //console.log('Pos', pos, 'item', item);

                        var itemReq = '';

                        for (var j = 0; j<item.ids.length; j++)
                        {

                            //console.log('Pos', pos, 'objId', item.ids[j]);

                            if (pos>=start)
                            {
                                // console.log('Starting');
                                if (!itemReq)
                                {
                                    // console.log('New sObjType');
                                    itemReq = {
                                        sObjTypeName: item.sObjTypeName,
                                        ids: []
                                    }

                                    request.push(itemReq);
                                }

                                if (pos >= start + BATCH_SIZE)
                                {
                                    return request;
                                }

                                itemReq.ids.push(item.ids[j]);
                            }

                            pos++;
                        }
                    }

                    return request;
                }

                var populateSyncDelta = function(scope, start)
                {

                    var request = sliceBatch(scope, start);

                    console.log('Creating deltas for ', request);

                    if (request.length > 0)
                    {

                        remoteActions.populateSyncDelta(JSON.stringify(request)).then(function()
                        {
                            populateSyncDelta(scope, start+BATCH_SIZE);
                        });
                    }
                    else
                    {
                        // Finished
                        $scope.showSpinner = false;
                    }

                };

                var cleanup = function (cont) {
                    console.log('Cleaning up');
                    remoteActions.cleanupSyncDelta().then(function (result) {
                        if (result) {
                            cont();
                        }
                        else {
                            // Not finished yet, retrying
                            cleanup(cont);
                        }

                    });
                }

                cleanup(function() {
                    // Don't forget to populate sync deltas
                    console.log('Starting to popuate sync deltas');
                    remoteActions.calcScopeForSyncDelta().then(function(scope)
                    {
                        populateSyncDelta(scope, 0);
                    });
                });

            }

            $scope.cleanupSyncDelta = function()
            {

                console.log('Cleanup Sync Delta');

                $scope.showSpinner = true;

                remoteActions.cleanupSyncDelta().then(function(result)
                {
                    if (result)
                    {
                        $scope.showSpinner = false;
                    }
                    else
                    {
                        // Not finished yet, retrying
                        $scope.cleanupSyncDelta();
                    }

                });

            }

            $scope.ensureGlobalKeys = function()
            {

                console.log('Ensure Global Keys');

                $scope.showSpinner = true;

                function _ensureGlobalKeys(idx) {

                    remoteActions.ensureGlobalKeysBatch(idx).then(function (idx) {
                        if (idx < 0 ) {
                            $scope.showSpinner = false;
                        }
                        else {
                            // Have not finished yet
                            _ensureGlobalKeys(idx);
                        }
                    });

                }

                _ensureGlobalKeys(0);


            }


            $scope.createDataRaptorBundlesForBackSync = function()
            {
                $scope.showSpinner = true;

                remoteActions.createDataRaptorBundlesForBackSync().then(function()
                {
                    $scope.showSpinner = false;
                });
            }

            $scope.syncCatalog = function()
            {
                $window.location.href = config.syncCatalogPage;
            }

            $scope.configureLayouts = function()
            {
                $location.path('/configureLayouts');
            }

            $scope.downloadSyncDeltas = function()
            {
                $scope.showSpinner = true;
                console.log('Download deltas');

                remoteActions.getBatch(200).then(function(json)
                {
                    $scope.showSpinner = false;
                    console.log('JSON: ', json);
                    var blob = new Blob([JSON.stringify(json)], {type: "application/json;charset=utf-8"});
                    var fileName = new Date().toLocaleString();
                    saveAs(blob, fileName + ".json");
                    console.log('Saving ' + fileName);
                });
            }

            $scope.syncLabels = function()
            {
                var labelsUrl = config.labelsUrl;

                $scope.showSpinner = true;

                function sync(labelsResponse) {

                    console.log(labelsResponse);

                    var labels = labelsResponse.data;

                    console.log(labels);

                    var xmlDoc = document.implementation.createDocument("http://soap.sforce.com/2006/04/metadata", "CustomLabels");

                    function addNode(parentNode, nodeName, value) {
                        var node = xmlDoc.createElement(nodeName);
                        node.appendChild(xmlDoc.createTextNode(value));
                        parentNode.appendChild(node);
                    }

                    for (var i = 0; i < labels.length; i++) {
                        var label = labels[i];
                        var name = label.name, title = label.title;

                        var labelsNode = xmlDoc.createElementNS("http://soap.sforce.com/2006/04/metadata", "labels");
                        xmlDoc.documentElement.appendChild(labelsNode);

                        addNode(labelsNode, 'categories', 'Thor');
                        addNode(labelsNode, 'fullName', name);
                        addNode(labelsNode, 'language', 'en_US');
                        addNode(labelsNode, 'protected', false);
                        addNode(labelsNode, 'shortDescription', label.type + ': ' + title);
                        addNode(labelsNode, 'value', title);

                    }

                    var s = new XMLSerializer();
                    var xml = s.serializeToString(xmlDoc);

                    console.log(xml);

                    var zip = new JSZip();

                    zip.file('labels/CustomLabels.labels', xml);

                    zip.file('package.xml', '<?xml version="1.0" encoding="UTF-8"?>\n' +
                        '<Package xmlns="http://soap.sforce.com/2006/04/metadata">\n' +
                        '\t<types>\n' +
                        '\t\t<members>*</members>\n' +
                        '\t\t<name>CustomLabels</name>\n' +
                        '\t</types>\n' +
                        '\t<version>40.0</version>' +
                        '</Package>');

                    var base64Zip = zip.generate({type: 'base64'});

                    var conn = new jsforce.Connection({ accessToken: config.accessToken });

                    conn.metadata.pollInterval = 3000;
                    conn.metadata.pollTimeout = 120000;

                    conn.metadata.deploy(base64Zip, {singlePackage: true, allowMissingFiles: true})
                        .complete(function (err, result) {

                            console.log('Deployment completed', err, result);
                            if (err) {
                                console.error(err);
                            }

                            // $timeout(function()
                            // {
                            //     $scope.showSpinner = false;
                            // });

                            $scope.refreshLabelsCache();

                        });
                }

                thorIntegrationService.retryOperationInCaseAuthenticationError(
                    function() {
                        return labelsSyncService.getLabels().then(function(labels)
                        {
                            sync(labels);
                        });
                    }, labelsUrl
                );
            }

            $scope.refreshLabelsCache = function ()
            {
                var conn = new jsforce.Connection({ accessToken: config.accessToken });

                conn.metadata.pollInterval = 3000;
                conn.metadata.pollTimeout = 120000;

                $scope.showSpinner = true;

                conn.metadata.list({type: 'CustomLabel', folder: null}, 40)
                    .then(function (data, err)
                    {

                        $scope.showSpinner = true;
                        if(err)
                        {
                            console.error(err);
                        }

                        console.log(data);

                        var labels = [];

                        for(var i = 0; i<data.length; i++)
                        {
                            var label = data[i].fullName;
                            labels.push(label);
                        }

                        console.log('Refreshing cache', labels);

                        // Let's update the cache
                        remoteActions.refreshCustomLabelsCache(labels)
                            .then(function(data, err)
                                    {
                                        console.log('/Refreshing cache', data, err);
                                        $scope.showSpinner = false;
                                    });

                    });
            }

        }

    ]);

},{}],3:[function(require,module,exports){
angular.module('xomadmin').controller('XOMAdminHomeController', ['$scope', 'config', 'remoteActions', '$window',
        function($scope, config, remoteActions, $window)
        {

            console.log('XOMAdminHomeController', $scope);

            $scope.forcePopulateSyncDelta = function()
            {

                console.log('Force populate Sync Delta');

                $scope.showSpinner = true;

                remoteActions.forcePopulateSyncDelta().then(function()
                {
                    $scope.showSpinner = false;
                });
            };

            $scope.syncCatalog = function()
            {
                $window.location.href = config.syncCatalogPage;
            };

            $scope.configureLayouts = function()
            {
                $location.path('/configureLayouts');
            };

        }
    ]);

},{}],4:[function(require,module,exports){
angular.module('xomadmin').controller('XOMConfigureLayoutsController',
    [
        '$scope', '$q', '$location', '$timeout', 'config', 'remoteActions',
        function($scope, $q, $location, $timeout, config, remoteActions)
        {
            console.log('XOMCOnfigureLayoutsController');

            var namespacePrefix = config.namespacePrefix;

            var packageRecordTypesAvailability =
                {
                    'OrchestrationItemDefinition__c':
                    [
                        {
                            recordType: namespacePrefix+'OrchestrationItemDefinition__c.'+namespacePrefix+'Callout',
                            default: false,
                            visible: true
                        },
                        {
                            recordType: namespacePrefix+'OrchestrationItemDefinition__c.'+namespacePrefix+'AutoTask',
                            default: false,
                            visible: true
                        },
                        {
                            recordType: namespacePrefix+'OrchestrationItemDefinition__c.'+namespacePrefix+'Milestone',
                            default: true,
                            visible: true
                        },
                        {
                            recordType: namespacePrefix+'OrchestrationItemDefinition__c.'+namespacePrefix+'ManualTask',
                            default: false,
                            visible: true
                        },
                        {
                            recordType: namespacePrefix+'OrchestrationItemDefinition__c.'+namespacePrefix+'PushEvent',
                            default: false,
                            visible: true
                        },
                        {
                            recordType: namespacePrefix+'OrchestrationItemDefinition__c.'+namespacePrefix+'SubPlan',
                            default: false,
                            visible: true
                        }
                    ]
                };

            var packageLayoutAssignments = {
                'XOM Base': {
                    'Order':
                        [
                            {
                                layout: 'Order-' + namespacePrefix + (config.isInsurance?'Order %28Vlocity Insurance%29 Layout':'Order %28Vlocity XOM%29 Layout V4')
                            }
                        ],
                    'InventoryItem__c':
                        config.isInsurance?
                            [
                            ]:
                            [
                                {
                                    layout: namespacePrefix + 'InventoryItem__c-' + namespacePrefix +'Inventory Item %28Vlocity XOM%29 Layout'
                                }
                            ],
                    'ManualQueue__c':
                        [
                            {
                                layout: namespacePrefix + 'ManualQueue__c-' + namespacePrefix + 'Manual Queue %28Vlocity XOM%29 Layout'
                            }
                        ],
                    'OrchestrationPlanDefinition__c':
                        [
                            {
                                layout: namespacePrefix + 'OrchestrationPlanDefinition__c-' + namespacePrefix + 'Orchestration Plan Definition %28Vlocity XOM%29 Layout'
                            }
                        ]
                },
                'XOM Admin': {
                    'Order':
                        [
                            {
                                layout: 'Order-' + namespacePrefix + (config.isInsurance?'Order %28Vlocity Insurance%29 Layout':'Order %28Vlocity XOM%29 Layout V4')
                            }
                        ],
                    'FulfilmentRequest__c':
                    [
                        {
                            layout: namespacePrefix + 'FulfilmentRequest__c-' + namespacePrefix + 'Fulfilment Request %28Vlocity XOM%29 Layout'
                        },
                        {
                            layout: namespacePrefix + 'FulfilmentRequest__c-' + namespacePrefix + 'Fulfilment Request %28Vlocity XOM%29 Layout',
                            recordType: namespacePrefix + 'FulfilmentRequest__c.' + namespacePrefix + 'FulfilmentRequest'
                        },
                        {
                            layout: namespacePrefix + 'FulfilmentRequest__c-' + namespacePrefix + 'Fulfilment Request %28Vlocity XOM%29 Layout',
                            recordType: namespacePrefix + 'FulfilmentRequest__c.' + namespacePrefix + 'ServiceQualificationRequest'
                        }
                    ],
                    'InventoryItem__c':
                        config.isInsurance?
                            [
                            ]:
                            [
                                {
                                    layout: namespacePrefix + 'InventoryItem__c-' + namespacePrefix +'Inventory Item %28Vlocity XOM%29 Layout'
                                }
                            ],
                    'DecompositionRelationship__c':
                        [
                            {
                                layout: namespacePrefix + 'DecompositionRelationship__c-' + namespacePrefix +'Decomposition Relationship %28Vlocity XOM%29 Layout V3'
                            }
                        ],
                    'OrchestrationItemDefinition__c':
                        [
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix +'Orchestration Item Definition %28Vlocity XOM%29 Layout V5'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix +'Orchestration Item Definition %28Vlocity XOM%29 Layout V5',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'Milestone'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Auto Task %28Vlocity XOM%29 Layout V4',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'AutoTask'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Callout %28Vlocity XOM%29 Layout V5',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'Callout'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Manual Task %28Vlocity XOM%29 Layout V5',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'ManualTask'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Push Event %28Vlocity XOM%29 Layout V5',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'PushEvent'
                            }
                        ],
                    'Product2':
                        [
                            {
                                layout: 'Product2-' + namespacePrefix + (config.isInsurance?'Product %28Vlocity Insurance%29 Layout':'Product %28Vlocity XOM%29 Layout V4')
                            },
                            {
                                layout: 'Product2-' + namespacePrefix + (config.isInsurance?'Product %28Vlocity Insurance%29 Layout':'Product %28Vlocity XOM%29 Layout V4'),
                                recordType: 'Product2.' + namespacePrefix + 'Product'
                            },
                            {
                                layout: 'Product2-' + namespacePrefix + (config.isInsurance?'Product %28Vlocity Insurance%29 Layout':'Product %28Vlocity XOM%29 Layout V4'),
                                recordType: 'Product2.' + namespacePrefix + 'Class'
                            }
                        ],
                    'OrchestrationScenario__c':
                    [
                        {
                            layout: namespacePrefix + 'OrchestrationScenario__c-' + namespacePrefix + 'Orchestration Scenario %28Vlocity XOM%29 Layout'
                        }
                    ],
                    'System__c':
                    [
                        {
                            layout: namespacePrefix + 'System__c-' + namespacePrefix + 'System %28Vlocity XOM%29 Layout'
                        }
                    ],
                    'ManualQueue__c':
                        [
                            {
                                layout: namespacePrefix + 'ManualQueue__c-' + namespacePrefix + 'Manual Queue %28Vlocity XOM%29 Layout'
                            }
                        ],
                    'ItemImplementation__c':
                        [
                            {
                                layout: namespacePrefix + 'ItemImplementation__c-' + namespacePrefix + 'Item Implementation %28Vlocity XOM%29 Layout V3'
                            }
                        ],
                    'OrchestrationPlanDefinition__c':
                        [
                            {
                                layout: namespacePrefix + 'OrchestrationPlanDefinition__c-' + namespacePrefix + 'Orchestration Plan Definition %28Vlocity XOM%29 Layout'
                            }
                        ]
                },
                'Thor Admin': {
                    'Order':
                        [
                            {
                                layout: 'Order-'+namespacePrefix+'Order %28Vlocity Thor%29 Layout V2'
                            }
                        ],
                    'FulfilmentRequest__c':
                    [
                        {
                            layout: namespacePrefix + 'FulfilmentRequest__c-' + namespacePrefix + 'Fulfilment Request %28Vlocity XOM%29 Layout'
                        },
                        {
                            layout: namespacePrefix + 'FulfilmentRequest__c-' + namespacePrefix + 'Fulfilment Request %28Vlocity XOM%29 Layout',
                            recordType: namespacePrefix + 'FulfilmentRequest__c.' + namespacePrefix + 'FulfilmentRequest'
                        },
                        {
                            layout: namespacePrefix + 'FulfilmentRequest__c-' + namespacePrefix + 'Fulfilment Request %28Vlocity XOM%29 Layout',
                            recordType: namespacePrefix + 'FulfilmentRequest__c.' + namespacePrefix + 'ServiceQualificationRequest'
                        }
                    ],
                    'InventoryItem__c':
                        config.isInsurance?
                            [
                            ]:
                            [
                                {
                                    layout: namespacePrefix + 'InventoryItem__c-' + namespacePrefix +'Inventory Item %28Vlocity XOM%29 Layout'
                                }
                            ],
                    'DecompositionRelationship__c':
                        [
                            {
                                layout: namespacePrefix + 'DecompositionRelationship__c-' + namespacePrefix +'Decomposition Relationship %28Vlocity XOM%29 Layout V3'
                            }
                        ],
                    'OrchestrationItemDefinition__c':
                        [
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix +'Orchestration Item Definition %28Vlocity Thor%29 Layout'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix +'Orchestration Item Definition %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'Milestone'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Auto Task %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'AutoTask'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Callout %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'Callout'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Manual Task %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'ManualTask'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Push Event %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'PushEvent'
                            },
                            {
                                layout: namespacePrefix + 'OrchestrationItemDefinition__c-' + namespacePrefix + 'Sub-plan %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OrchestrationItemDefinition__c.' + namespacePrefix + 'SubPlan'
                            }
                        ],
                    'Product2':
                        [
                            {
                                layout: 'Product2-' + namespacePrefix + 'Product %28Vlocity Thor%29 Layout'
                            },
                            {
                                layout: 'Product2-' + namespacePrefix + 'Product %28Vlocity Thor%29 Layout',
                                recordType: 'Product2.' + namespacePrefix + 'Product'
                            },
                            {
                                layout: 'Product2-' + namespacePrefix + 'Product %28Vlocity Thor%29 Layout',
                                recordType: 'Product2.' + namespacePrefix + 'Class'
                            }
                        ],
                    'OrchestrationScenario__c':
                    [
                        {
                            layout: namespacePrefix + 'OrchestrationScenario__c-' + namespacePrefix + 'Orchestration Scenario %28Vlocity XOM%29 Layout'
                        }
                    ],
                    'ErrorCodeNamespace__c':
                        [
                            {
                                layout: namespacePrefix + 'ErrorCodeNamespace__c-' + namespacePrefix + 'Error Code Namespace %28Vlocity XOM%29 Layout'
                            }
                        ],
                    'IntegrationRetryPolicy__c':
                        [
                            {
                                layout: namespacePrefix + 'IntegrationRetryPolicy__c-' + namespacePrefix +'Monotonous Forever Retry Policy %28Vlocity XOM%29 Layout',
                                recordType: namespacePrefix + 'IntegrationRetryPolicy__c.' + namespacePrefix + 'MonotonousForeverRetryPolicy'
                            },
                            {
                                layout: namespacePrefix + 'IntegrationRetryPolicy__c-' + namespacePrefix +'Monotonous Retry Policy %28Vlocity XOM%29 Layout',
                                recordType: namespacePrefix + 'IntegrationRetryPolicy__c.' + namespacePrefix + 'MonotonousRetryPolicy'
                            },
                            {
                                layout: namespacePrefix + 'IntegrationRetryPolicy__c-' + namespacePrefix +'No Retry Policy %28Vlocity XOM%29 Layout',
                                recordType: namespacePrefix + 'IntegrationRetryPolicy__c.' + namespacePrefix + 'NoRetryPolicy'
                            }
                        ],
                    'System__c':
                    [
                        {
                            layout: namespacePrefix + 'System__c-' + namespacePrefix + 'System %28Vlocity XOM%29 Layout'
                        }
                    ],
                    'ManualQueue__c':
                        [
                            {
                                layout: namespacePrefix + 'ManualQueue__c-' + namespacePrefix + 'Manual Queue %28Vlocity Thor%29 Layout'
                            }
                        ],
                    'ItemImplementation__c':
                        [
                            {
                                layout: namespacePrefix + 'ItemImplementation__c-' + namespacePrefix + 'Item Implementation %28Vlocity Thor%29 Layout'
                            }
                        ],
                    'OrchestrationPlanDefinition__c':
                        [
                            {
                                layout: namespacePrefix + 'OrchestrationPlanDefinition__c-' + namespacePrefix + 'Orchestration Plan Definition %28Vlocity XOM%29 Layout'
                            }
                        ],
                    'OperatingHoursEntry__c':
                        [
                            {
                                layout: namespacePrefix + 'OperatingHoursEntry__c-' + namespacePrefix + 'Standard Operating Hours Entry %28Vlocity Thor%29 Layout'
                            },
                            {
                                layout: namespacePrefix + 'OperatingHoursEntry__c-' + namespacePrefix +'Standard Operating Hours Entry %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OperatingHoursEntry__c.' + namespacePrefix + 'Standard'
                            },
                            {
                                layout: namespacePrefix + 'OperatingHoursEntry__c-' + namespacePrefix +'Exception Operating Hours Entry %28Vlocity Thor%29 Layout',
                                recordType: namespacePrefix + 'OperatingHoursEntry__c.' + namespacePrefix + 'Exception'
                            }
                        ]
                },
                'Thor Base':  {
                    'Order':
                        [
                            {
                                layout: 'Order-'+namespacePrefix+'Order %28Vlocity Thor%29 Layout V2'
                            }
                        ],
                    'InventoryItem__c':
                        [
                            {
                                layout: namespacePrefix + 'InventoryItem__c-' + namespacePrefix +'Inventory Item %28Vlocity XOM%29 Layout'
                            }
                        ],
                    'ManualQueue__c':
                        [
                            {
                                layout: namespacePrefix + 'ManualQueue__c-' + namespacePrefix + 'Manual Queue %28Vlocity Thor%29 Layout'
                            }
                        ],
                    'OrchestrationPlanDefinition__c':
                        [
                            {
                                layout: namespacePrefix + 'OrchestrationPlanDefinition__c-' + namespacePrefix + 'Orchestration Plan Definition %28Vlocity XOM%29 Layout'
                            }
                        ]
                }
            }

            $scope.profiles = [];

            $scope.profileOptions = [
                'None', 'XOM Base', 'XOM Admin'
            ];

            $scope.showSpinner = false;

            if (config.isThorEnabled == 'true')
            {
                $scope.profileOptions.push('Thor Base');
                $scope.profileOptions.push('Thor Admin');
            }

            var conn = new jsforce.Connection({ accessToken: config.accessToken });

            $scope.retrieveProfiles = function ()
            {
                var id2fullName = {};

                conn.metadata.list({type: 'Profile'}, '39.0')
                    .then(function(res)
                      {
                        console.log(res);

                        for (var i = 0; i < res.length; i++)
                        {
                            id2fullName[res[i].id] = res[i].fullName;
                        }

                        return conn.query('select Id, Name, UserLicense.name from Profile where UserLicense.name = \'Salesforce\'');

                      })
                    .then(function(res)
                    {
                        for (var i = 0; i < res.records.length; i++)
                        {
                            res.records[i].fullName = id2fullName[res.records[i].Id];
                        }

                        console.log(res);

                        $scope.$apply(function()
                        {

                            $scope.profiles.length = 0;

                            var current;

                            for (var i = 0; i < res.records.length; i++)
                            {

                                if (i % 3 == 0)
                                {
                                    current = [];
                                    $scope.profiles.push(current);
                                }

                                current.push({
                                    Name: res.records[i].Name,
                                    Id: res.records[i].Id,
                                    FullName: res.records[i].fullName,
                                    xom: 'None'
                                });
                            }

                        });
                    })
                    .catch(function(err)
                    {
                        console.log('Error', err);
                    });

            }

            function stripNamespace(name)
            {
                var parts = name.split('__');


                if (parts.length > 1)
                {
                    // I.e. aaa__c
                    if (parts[1] == 'c')
                    {
                        return name;
                    }
                    else
                    {
                        return parts[1];
                    }
                }
                else
                {
                    return name;
                }
            }

            function updateProfile(zip, profileSettings)
            {

                console.log('Profile settings ', profileSettings);

                var profileName = profileSettings.name;

                var profileType = profileSettings.type;

                var zipFile = zip.file('profiles/' + profileName + '.profile');

                if (!zipFile)
                {
                    console.log('Profile ' + profileName +' is not found');
                }

                var xml = zipFile.asText();

                var xmlDoc = new DOMParser().parseFromString(xml,"text/xml");

                var rootNode = xmlDoc.getElementsByTagName('Profile')[0];

                var recordTypeNodes = rootNode.getElementsByTagName('recordTypeVisibilities');

                var recordTypeNodesToRemove = [];

                for (var i = 0; i<recordTypeNodes.length; i++)
                {
                    var objectType = stripNamespace(recordTypeNodes[i].getElementsByTagName('recordType')[0].childNodes[0].nodeValue.split('.')[0]);

                    if (packageRecordTypesAvailability[objectType])
                    {
                        recordTypeNodesToRemove.push(recordTypeNodes[i]);
                    }

                }

                for (var i = 0; i < recordTypeNodesToRemove.length; i++)
                {
                    rootNode.removeChild(recordTypeNodesToRemove[i]);
                }

                for (var objectType in packageRecordTypesAvailability)
                {
                    var assignments = packageRecordTypesAvailability[objectType];

                    for (var i=0; i < assignments.length; i++)
                    {
                        var assignment = assignments[i];

                        var assignmentNode = xmlDoc.createElement('recordTypeVisibilities');
                        rootNode.insertBefore(assignmentNode, recordTypeNodes[0]);

                        var defaultNode = xmlDoc.createElement('default');
                        assignmentNode.appendChild(defaultNode);
                        defaultNode.appendChild(xmlDoc.createTextNode(assignment['default']));

                        var visibleNode = xmlDoc.createElement('visible');
                        assignmentNode.appendChild(visibleNode);
                        visibleNode.appendChild(xmlDoc.createTextNode('true'));

                        var recordTypeNode = xmlDoc.createElement('recordType');
                        assignmentNode.appendChild(recordTypeNode);
                        recordTypeNode.appendChild(xmlDoc.createTextNode(assignment['recordType']));
                    }
                }

                var layoutAssignmentsNodesToRemove = [];

                var layoutAssignmentsNodes = rootNode.getElementsByTagName('layoutAssignments');

                var standardLayoutAssignments = packageLayoutAssignments[profileType];

                for (var i = 0; i< layoutAssignmentsNodes.length; i++)
                {
                    var layoutAssignmentsNode = layoutAssignmentsNodes[i];

                    var objectType, recordType;

                    var layoutNode = layoutAssignmentsNode.getElementsByTagName('layout')[0];

                    objectType = stripNamespace(layoutNode.childNodes[0].nodeValue.split('-')[0]);

                    if (standardLayoutAssignments[objectType])
                    {
                        layoutAssignmentsNodesToRemove.push(layoutAssignmentsNode);
                    }


                }

                for (var i = 0; i < layoutAssignmentsNodesToRemove.length; i++)
                {
//                    console.log('Removing layout assignments ', layoutAssignmentsNodesToRemove[i]);
                    rootNode.removeChild(layoutAssignmentsNodesToRemove[i]);
                }

                // Now lets setup layoutAssignments
                for (var assignment in standardLayoutAssignments)
                {
                    if (standardLayoutAssignments.hasOwnProperty(assignment))
                    {

                        console.log ('>>>> Assigment ', assignment);

                        var pageAssignments = standardLayoutAssignments[assignment];

                        for (var i=0; i < pageAssignments.length; i++)
                        {

                            var pageAssignment = pageAssignments[i];

                            console.log ('>>>> PageAssigment ', pageAssignment);

                            var newAssignment = xmlDoc.createElement('layoutAssignments');
                            rootNode.insertBefore(newAssignment, layoutAssignmentsNodes[0]);

                            var newLayout = xmlDoc.createElement('layout');
                            newAssignment.appendChild(newLayout);

                            newLayout.appendChild(xmlDoc.createTextNode(pageAssignment['layout']));

                            var recordType = pageAssignment['recordType'];

                            if (recordType)
                            {
                                var newRecordType = xmlDoc.createElement('recordType');
                                newAssignment.appendChild(newRecordType);

                                newRecordType.appendChild(xmlDoc.createTextNode(recordType));
                            }

                        }

                    }
                }

                var s = new XMLSerializer();

                var xml = s.serializeToString(xmlDoc);

                console.log(xml);

                zip.file('profiles/' + profileName + '.profile', xml);
            }

            function updateZip(zipfile, profilesSettings)
            {
                var zip = new JSZip(zipfile, {base64: true});

                for (var i = 0; i < profilesSettings.length; i++)
                {
                    updateProfile(zip, profilesSettings[i]);
                }

                zip.remove('objects');
                zip.remove('layouts');

                console.log ('Zip', zip);

                return zip.generate();

            }

            function setupProfiles(profilesSettings, cont)
            {

                var profilesToUpdate = [];

                for (var i = 0; i < profilesSettings.length; i++)
                {
                    profilesToUpdate.push(profilesSettings[i].name);
                }

                console.log('Profiles to update', profilesToUpdate);

                conn.metadata.retrieve({ packageNames: [], singlePackage: true,
                                        unpackaged:
                                            {   version: '36.0',
                                                types:
                                                [
                                                    {members: profilesToUpdate, name: 'Profile'},
                                                    {members: ['*'], name: 'CustomObject'},
                                                    {members: ['*'], name: 'Layout'}
                                                ]}},
                function(err, data)
                {
                    // console.log('Err', err);
                    // console.log('Data', data);

                    function checkRetrievalStatus(id, cont)
                    {

                        conn.metadata.checkRetrieveStatus(id, function(err, status)
                        {
                            console.log('Status', status);
                            if (status.done == "false")
                            {
                                checkRetrievalStatus(id, cont);
                            }
                            else
                            {
                                cont(status);
                            }

                        })
                    }

                    checkRetrievalStatus(data.id, function(status)
                    {
                        console.log('End status: ', status);
                        var base64upload = updateZip(status.zipFile, profilesSettings);

                        function checkDeploy(id, cont)
                        {
                            conn.metadata.checkDeployStatus(id, function(err, res)
                            {
                                if (err)
                                {
                                    console.log('Error', err);
                                }
                                else
                                {
                                    console.log('Check Deploy Res', res);
                                    if (res.done == "true")
                                    {
                                        cont(res);
                                    }
                                    else
                                    {
                                        checkDeploy(id, cont);
                                    }
                                }
                            });

                        }

                        conn.metadata.pollInterval = 3000;
                        conn.metadata.pollTimeout = 30000;

                        conn.metadata.deploy(base64upload, {singlePackage: true, allowMissingFiles: true})
                           .complete(function(err, result) {
                                if (err) { console.error(err); }
                                cont();
                              });
                        });

                });

            }

            $scope.save = function ()
            {

                console.log('Save!');

                $scope.showSpinner = true;

                var profilesSettings = [];

                for(var i = 0; i < $scope.profiles.length; i++)
                {
                    for (var j = 0; j < $scope.profiles[i].length; j++)
                    {
                        if (packageLayoutAssignments[$scope.profiles[i][j].xom])
                        {
                            profilesSettings.push({name: $scope.profiles[i][j].FullName, type: $scope.profiles[i][j].xom});
                        }
                    }
                }

                setupProfiles(profilesSettings, function()
                {
                    $timeout(function()
                        {
                            $scope.showSpinner = false;
                        });
                });

            }

            $scope.cancel = function()
            {
                $location.path('/');
            }

            $scope.retrieveProfiles();

        }
    ]);


},{}],5:[function(require,module,exports){
angular.module("xomadmin").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("XOMAdmin.tpl.html",'<div>\n    <div class="slds-clearfix slds-p-around--small">\n    </div>\n    <div class="slds-theme--shade">\n        <div class="job-wrapper slds-p-around--medium">\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom">\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Apply Record Types and Page Layout Assignments</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Configures (or restores) Record Types visibility and Page Layouts for Vlocity XOM</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="configureLayouts" type="button" ng-click="configureLayouts()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="createEpcObjectClassesStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom" ng-if="isThorEnabled">\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Synchronize Catalog with Thor</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Synchronizes an associated Thor instance with Thor</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="syncCatalog" type="button" ng-click="syncCatalog()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="createEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom" ng-if="isDeltaTrackingEnabled" >\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Delete Sync Delta Objects</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Deletes all Sync Delta Objects</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="forcePopulateSyncDelta" type="button" ng-click="cleanupSyncDelta()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom" ng-if="isDeltaTrackingEnabled" >\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Generate Sync Delta Objects</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Regenerates Sync Delta Objects for the whole catalog</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="forcePopulateSyncDelta" type="button" ng-click="forcePopulateSyncDelta()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom" ng-if="isDeltaTrackingEnabled" >\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Generate Global Keys</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Ensures that all Catalog objects have Global Key set</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="forcePopulateSyncDelta" type="button" ng-click="ensureGlobalKeys()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom" ng-if="isThorEnabled" >\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Create Vlocity DataRaptor Bundles for Thor sync</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Creates or (fully re-creates) Vlocity DataRaptor Bundler for Thor sync</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="forcePopulateSyncDelta" type="button" ng-click="createDataRaptorBundlesForBackSync()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom" ng-if="isDevEnabled" >\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Download sync deltas</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Downloads last 200 sync deltas as a file</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="downloadSyncDetas" type="button" ng-click="downloadSyncDeltas()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom">\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Synchronize I18n labels</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Downloads all labels from Thor and sync them to SFDC</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="syncLabels" type="button" ng-click="syncLabels()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n            <div class="job-section slds-m-top--x-small slds-has-divider--bottom">\n                <div class="job-content slds-clearfix">\n                    <div class="job-detail slds-float--left">\n                        <div class="job-label">\n                            <a href="javascript:void(0)">Refresh I18n cache</a>\n                        </div>\n                        <div class="job-desc slds-m-top--x-small">Refreshes Custom Labels cache</div>\n                    </div>\n                    <div class="job-start slds-float--right">\n                        <button id="syncLabels" type="button" ng-click="refreshLabelsCache()" class="slds-button  slds-button--brand">Start</button>\n                    </div>\n                </div>\n                <div class="row">\n                    <div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n                        <div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>\n<div class="slds-spinner_container" ng-show="showSpinner">\n    <div class="slds-spinner--brand slds-spinner slds-spinner--large" aria-hidden="false" role="alert">\n        <div class="slds-spinner__dot-a"></div>\n        <div class="slds-spinner__dot-b"></div>\n    </div>\n</div>'),$templateCache.put("XOMConfigureLayouts.tpl.html",'<div class="_slds-align--absolute-center">\n    <div class="slds-panel">\n        <form class="slds-form--compound">\n            <div class="slds-panel__section slds-has-divider--bottom">\n                <div class="slds-form-element__row">\n                    <div class="slds-form-element slds-size--1-of-1 slds-clearfix">\n                        <button class="slds-button slds-button--brand slds-float--right"\n                                ng-disabled="readOnly" ng-click="cancel()">Cancel</button>\n                        <button class="slds-button slds-button--brand slds-float--right slds-m-right--medium"\n                                ng-disabled="readOnly" ng-click="save()">Update</button>\n                    </div>\n\n                </div>\n            </div>\n            <div class="slds-panel__section slds-has-divider--bottom">\n                <h3 class="slds-text-heading--small slds-m-bottom--medium">Profiles Assignments</h3>\n                <div class="slds-form-element__row" ng-repeat="profileChunk in profiles">\n                    <div class="slds-form-element slds-size--1-of-3" ng-repeat="profile in profileChunk track by profile.Id">\n                        <div class="slds-form-element slds-lookup slds-is-open">\n                            <label class="slds-form-element__label" ng-bind="profile.Name"></label>\n                            <div class="slds-form-element__control">\n                                <div class="slds-select_container">\n                                    <select class="slds-select"\n                                            ng-model="profile.xom"\n                                            ng-options="item for item in profileOptions">\n                                    </select>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n\n        </form>\n    </div>\n</div>\n<div class="slds-spinner_container" ng-show="showSpinner">\n    <div class="slds-spinner--brand slds-spinner slds-spinner--large" aria-hidden="false" role="alert">\n        <div class="slds-spinner__dot-a"></div>\n        <div class="slds-spinner__dot-b"></div>\n    </div>\n</div>')}]);
},{}]},{},[1]);

})();