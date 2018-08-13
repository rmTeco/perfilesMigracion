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
var app = angular.module('thorIntegration', ['vlocity']);

/*TODO migrate external dependencies from main.js */
// require("./xom.scss");
// require("angular-lightning/app/scripts/fields/field-datepicker"); // TODO: get rid of this dependency
// require('ng-infinite-scroll');
// require('ng-jsoneditor');
// require('jsoneditor/dist/jsoneditor.css');
// require('./modules/planView/PlanView');
require('./modules/thorintegration/factory/thorIntegrationService.js');
/* TODO: migrate Services, Directives, Constants  */
    // Services
    // app.factory('metadataService', metadataService) // +
    // .factory('activeRecordService', activeRecordService)
    // .factory('authenticationService', authenticationService)
    // .factory('notificationService', notificationService)
    // .factory('errorHandlingService', errorHandlingService)
    // .factory('sfdcCanvasService', sfdcCanvasService) // not required
    // // Navigation directives
    // .directive('navigationHeader', navigationHeaderDirective)
    // .directive('breadcrumbs', breadcrumbsDirective)
    // .directive("breadcrumb", breadcrumbDirective)
    // .directive('objectBreadcrumbs', objectBreadcrumbsDirective)
    // .directive('objectTypeBreadcrumbs', objectTypeBreadcrumbsDirective)
    // .directive('globalSearch', globalSearchDirecrive)
    // // Facets
    // .directive('facet', facetDirective)
    // .directive('facet4412964684870411902', parametersFacetDirective)
    // .directive('parametersEditFacet', parametersEditFacetDirective)
    // .directive('facet4412964684870431356', referenceFacetDirective)
    // .directive('referenceFacetRow', referenceFacetRowDirective)
    // .directive('facet4412964684870431361', childrenFacetDirective)
    // .directive('childrenFacetRow', childrenFacetRowDirective)
    // .directive('attributeEditFacet', attributeEditFacetDirective)
    // .directive('objectTypeEditFacet', objectTypeEditFacetDirective)
    // .directive('facet4412964684871406204', orchestrationPlanViewFacetDirective)
    // .directive('facet4412964684871512704', backreferenceFacetDirective)
    // // Buttons
    // .directive('actionButton', buttonDirective)
    // .directive('button4412964684871522945', completeOrchItemButtonDirective)
    // .directive('button976718169185976322', clearSecurityCacheButtonDirective)
    // .directive('button4412964684871837317', systemUpAndUnholdOrchItemsButtonDirective)
    // // Attributes
    // .directive("attributeValue", attributeValueDirective)
    // .directive("attributeField", attributeFieldDirective)
    // .directive("textValue", textValueDirective)
    // .directive("textField", textFieldDirective)
    // .directive("datetimeValue", datetimeValueDirective)
    // .directive("datetimeField", datetimeFieldDirective)
    // .directive('objectTypeValue', objectTypeValueDirective)
    // .directive('objectTypeField', objectTypeFieldDirective)
    // .directive('referenceValue', referenceValueDirective)
    // .directive('referenceField', referenceFieldDirective)
    // .directive('referenceSingleValue', referenceSingleValueDirective)
    // .directive('referenceSingleField', referenceSingleFieldDirective)
    // .directive('referenceToAttributeValue', referenceToAttributeValueDirective)
    // .directive('referenceToAttributeField', referenceToAttributeFieldDirective)
    // .directive('referenceToPicklistValue', referenceToPicklistValueDirective)
    // .directive('referenceToPicklistField', referenceToPicklistFieldDirective)
    // .directive('picklistValue', picklistValueDirective)
    // .directive('picklistField', picklistFieldDirective)
    // .directive('booleanValue', booleanValueDirective)
    // .directive('booleanField', booleanFieldDirective)
    // .directive('jsonValue', jsonValueDirective)
    // .directive('jsonField', jsonFieldDirective)
    // .constant('DateConfig', {
    //     numWeeksShown: 5,
    //     dateFormat: 'D MMM YYYY',
    //     dateModel: 'x',
    //     dateTimeFormat: 'D MMM YYYY HH:mm:ss',
    //     datetimeModel: 'x'
    // });


},{"./modules/thorintegration/factory/thorIntegrationService.js":2}],2:[function(require,module,exports){
// service stores config data e.g. thor Url and authenticates external requests to thor platform
angular.module('thorIntegration').factory('thorIntegrationService', function($q, $timeout){
    let thorIntegrationService = {
        uiMode: undefined,
        uiServiceUrl: undefined,
        isOffAuthenticationInProgress: false,
        loginWindow: undefined,
        /* getOffplatformUrl and isOffplatformMode is a caching proxy to corresponding remoteActions functions */
        getOffplatformUrl: function getOffplatformUrl(remoteActionOperations){
            let uiServiceUrl = this.uiServiceUrl;
            if(uiServiceUrl != undefined){ // provide cached UI Service Url
                return $q(function(resolve, reject){
                    resolve(uiServiceUrl)
                });
            } else {
                // fetch uiServiceUrl from server
                return remoteActionOperations['getOffplatformUrl']()
                    .then(function(uiServiceUrl) {
                                return $q(function(resolve, reject){
                                    thorIntegrationService.uiServiceUrl = uiServiceUrl; 
                                    resolve(uiServiceUrl);
                                });
                            });
            }
        },
        isOffplatformMode: function isOffplatformMode(remoteActionOperations){
            let uiMode = this.uiMode;
            if(uiMode != undefined){ // provide cached UI Mode
                return $q(function(resolve, reject){
                    resolve(uiMode)
                });
            } else { // fetch uiMode from server
                return remoteActionOperations['isOffplatformMode']()
                            .then(function(uiMode) {
                                return $q(function(resolve, reject){
                                    thorIntegrationService.uiMode = uiMode; 
                                    resolve(uiMode);
                                });
                            });
            }
        },
        retryOperationInCaseAuthenticationError: function(operationToRetry, uiServicesUrl, retryAttemptsNumber){
            var attemptsCount = 0;
            if(retryAttemptsNumber){
                // do nothing
            } else {
                retryAttemptsNumber = 3;
            }
            return $q(function(resolve, reject){
                var tryRequest = function(){
                    // console.log('retrying operation. attempt ' + attemptsCount);
                    operationToRetry()
                        .then(function(promiseResult)
                        {
                            resolve(promiseResult);
                        }
                        )
                        .catch(function(response){
                            console.log('Catching response ', response);

                            if (response.status == 401
                                || (response.data != undefined && response.data.exception == 'org.apache.shiro.authc.AuthenticationException'))
                            {
                                    console.error('thorIntegrationService.provideRetryableAuthorizationCatcher: error ', response.data);
                                    // redirect to authentication service in a separate window
                                    if(this.loginWindow == undefined)
                                    {
                                        this.isOffAuthenticationInProgress = true;
                                        this.loginWindow = window.open(uiServicesUrl + '/security/v1/auth/openid/authorize');
                                    }
                                    var checkIfClosed = function()
                                    {
                                        if(this.loginWindow.closed){
                                            this.isOffAuthenticationInProgress = false;
                                            window.location.reload(); // XOM-2370 reloading page to refresh session id for VF page (workaround)
                                            console.log("thorIntegrationService.Authentication window is now closed. Retrying original operation...");
                                            if(attemptsCount < retryAttemptsNumber)
                                                tryRequest();
                                            attemptsCount++;
                                            this.loginWindow = undefined;
                                        }else{
                                            // console.log('Authentication window is in progress...');
                                            $timeout(checkIfClosed, 1000)
                                        }                                            
                                    }
                                    $timeout(checkIfClosed, 1000);
                            } else {
                                // passing the error through the catch chain
                                throw response;
                            }
                        })  
                }
                // call origina operation for the first time
                tryRequest();
            })               

        }
    };
    console.log('thorIntegrationService is initialised');
    return thorIntegrationService;
});
},{}]},{},[1]);

})();