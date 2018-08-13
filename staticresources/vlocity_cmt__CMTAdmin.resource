(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';
var app = angular.module('CMTAdmin', ['vlocity', 'sldsangular','epcadmin', 'fieldLookupUI', 'ngSanitize', 'ngAnimate']);
app.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}]);

require('./modules/CMTAdmin/controller/CMTAdminController.js');
require('./modules/CMTAdmin/controller/DashboardController.js');
require('./modules/CMTAdmin/controller/AdminConsoleController.js');
require('./modules/CMTAdmin/controller/CustomSettingsController.js');
require('./modules/CMTAdmin/controller/EnableFeaturesController.js');
require('./modules/CMTAdmin/factory/BasicFactory.js');
require('./modules/CMTAdmin/factory/BasicService.js');
require('./modules/CMTAdmin/templates/templates.js');

},{"./modules/CMTAdmin/controller/AdminConsoleController.js":2,"./modules/CMTAdmin/controller/CMTAdminController.js":3,"./modules/CMTAdmin/controller/CustomSettingsController.js":4,"./modules/CMTAdmin/controller/DashboardController.js":5,"./modules/CMTAdmin/controller/EnableFeaturesController.js":6,"./modules/CMTAdmin/factory/BasicFactory.js":7,"./modules/CMTAdmin/factory/BasicService.js":8,"./modules/CMTAdmin/templates/templates.js":9}],2:[function(require,module,exports){
var app = angular.module('CMTAdmin');
app.controller('AdminConsoleController', ['$scope', '$window', '$timeout', '$sldsModal', 'BasicService', 'remoteActions', '$window', 'ActiveMenu',
	function (scope, window, timeout, modal, basicService, remoteActions, window, activeMenu) {
		scope.asyncApexJobFieldsLabels = window.asyncApexJobFieldsLabels;
		scope.labels = window.labels;
		scope.configData = window.configData;
		scope.module = {};
		scope.activeMenu = 0;
		scope.rootAccountJobsList = [];
		scope.XLIBatchJobValidationList = [];
		scope.refreshPriceBookJobList = [];
		scope.upgradeTab = {};
		scope.upgradeTab.attributesBindingObjects = null;

		scope.initApp = function(name, label) {
			scope.module.name = name;
			scope.module.label = label;
			scope.$parent.spinner.showSpinner();
			scope.refreshBatchJobLists();
			scope.$parent.spinner.hideSpinner();
		};
		scope.startRootAccountJob = function() {
			var parameters = {};
        	parameters.methodName =  "startRootAccountJob";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.rootAccountJobsList = result.resolveRootAccountsJobs;
			}, function(error) {

			});
		};

		scope.startAttributesBindingJob = function() {
			var parameters = {};
        	parameters.methodName =  "startAttributesBindingJob";
        	parameters.objectNames =  scope.upgradeTab.attributesBindingObjects;
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.attributesBindingJobsList = result.attributesBindingJobs;
			});
		};

		// validate the startAttributesBindingJob form
		scope.validateInput = function() {
			if(scope.upgradeTab.attributesBindingObjects != null){
				return false;
			}else{
				return true;
			}
		};

		scope.startRootProductChildItemJob = function() {
			var parameters = {};
        	parameters.methodName =  "startRootProductChildItemJob";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.rootProductChildItemJobsList = result.rootProductChildItemJobs;
			});
		};

		scope.startXLIBatchValidationJob = function() {
			var parameters = {};
        	parameters.methodName =  "startXLIBatchValidationJob";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.XLIBatchJobValidationList = result.xliBatchValidationJobs;
			});
		};

		scope.resetXLIBatchValidationData = function() {
			var parameters = {};
        	parameters.methodName =  "resetXLIBatchValidtionData";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('idResetXLIValidationDataButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('idResetXLIValidationDataButton');
				}
			});
		};

		scope.clearPlatformCache = function() {
			var parameters = {};
        	parameters.methodName =  "clearPlatformCache";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('idClearCacheStartButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('idClearCacheStartButton');
				}
			});
		};

		scope.refreshPriceBook = function() {
			var parameters = {};
			parameters.methodName =  "refreshPriceBook";
			var remoteOptions ={};
			remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
			remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.refreshPriceBookJobList = result.productAttributesBatchJobs;
			});
		};

		scope.importEpcObjectsLayouts = function() {
			var path = '/apex/'+scope.nsPrefix+'DataPacksHome?dataPackDataPublicId=DP_CPQ_EpcDefaultObjects&dataPackDataPublicSource=Vlocity%20Resource'
			window.open(path, '_blank');
		};

		scope.importPricingPlanData = function() {
			var path = '/apex/'+scope.nsPrefix+'DataPacksHome?dataPackDataPublicId=DP_CPQ_PricingPlanDefaultData&dataPackDataPublicSource=Vlocity%20Resource'
			window.open(path, '_blank');
		};

		scope.createEpcObjectClasses = function() {
			scope.displayWaitDialog('createEpcObjectClassesButton');
			var parameters = {};
        	parameters.methodName =  "createEpcObjectClasses";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('createEpcObjectClassesButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('createEpcObjectClassesButton');
				}
			});
		};

		scope.createEpcDefaultLayouts = function() {
			scope.displayWaitDialog('createEpcDefaultLayoutsButton');
			var parameters = {};
        	parameters.methodName =  "createEpcDefaultLayouts";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('createEpcDefaultLayoutsButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('createEpcDefaultLayoutsButton');
				}
			});
		};

		scope.deleteEpcDefaultLayouts = function() {
			scope.displayWaitDialog('deleteEpcDefaultLayoutsButton');
			var parameters = {};
        	parameters.methodName =  "deleteEpcDefaultLayouts";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('deleteEpcDefaultLayoutsButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('deleteEpcDefaultLayoutsButton');
				}
			});
		};

		scope.generateEPCGlobalKeys = function() {
			scope.displayWaitDialog('generateGlobalKeysButton');
			var parameters = {};
        	parameters.methodName = "generateEPCGlobalKeys";
            var remoteOptions ={};
            remoteOptions.apexType = scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters = JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('generateGlobalKeysButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('generateGlobalKeysButton');
				}
			});
		};

		scope.createDefaultPricingVariables = function() {
			scope.displayWaitDialog('createDefaultPricingVariablesButton');
			var parameters = {};
        	parameters.methodName =  "createDefaultPricingVariables";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('createDefaultPricingVariablesButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('createDefaultPricingVariablesButton');
				}
			});
		};

		scope.resetInterfaceImplementations = function() {
			scope.displayWaitDialog('idInImpStartButton');
			var parameters = {};
        	parameters.methodName =  "resetInterfaceImplementations";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('idInImpStartButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('idInImpStartButton');
				}
			});
		};

		scope.mergeInterfaceImplementations = function() {
			scope.displayWaitDialog('idMergeInImpStartButton');
			var parameters = {};
        	parameters.methodName =  "mergeInterfaceImplementations";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('idMergeInImpStartButton');
				//TODO check errors from result.hasErrors
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('idMergeInImpStartButton');
				}
			});
		};


		scope.resetFieldMaps = function() {
			scope.displayWaitDialog('idfldMapStartButton');
			var parameters = {};
        	parameters.methodName =  "resetFieldMaps";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('idfldMapStartButton');
				//TODO check errors from result.hasErrors;
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('idfldMapStartButton');

				}
			});
		};

		scope.resetObjectMaps = function() {
			scope.displayWaitDialog('idObjMapStartButton');
			var parameters = {};
        	parameters.methodName =  "resetObjectMaps";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.removeWaitDialog('idObjMapStartButton');
				//TODO check errors from result.hasErrors;
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
					scope.showSuccessStatus('idObjMapStartButton');

				}
			});
		};

		scope.refreshBatchJobLists = function() {
			var parameters = {};
        	parameters.methodName =  "refreshBatchJobLists";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.rootAccountJobsList = result.resolveRootAccountsJobs;
				scope.XLIBatchJobValidationList = result.xliBatchJobs;
				scope.attributesBindingJobsList = result.attributesBindingJobs;
				scope.rootProductChildItemJobsList = result.rootProductChildItemJobs;
				scope.productHierarchyJobsList = result.resolveProductHierarchyJobs;
				scope.refreshPriceBookJobList = result.productAttributesBatchJobs;
				//console.log(scope.XLIBatchJobValidationList);
				if(activeMenu.getActiveMenu() === 'MaintenanceJob.tpl.html' ||
					activeMenu.getActiveMenu() === 'UpgradeJob.tpl.html' ||
					activeMenu.getActiveMenu() === 'EPCJob.tpl.html') {
					timeout(scope.refreshBatchJobLists, 3000);
				}
			});
		};
		scope.refreshXLIBatchJobValidationLists = function() {
			var parameters = {};
        	parameters.methodName =  "refreshXLIBatchJobLists";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.XLIBatchJobValidationList = result.xliBatchJobValidationList;
				//debugger;
				//console.log(scope.XLIBatchJobValidationList);
				if(activeMenu.getActiveMenu() === 'MaintenanceJob.tpl.html' || activeMenu.getActiveMenu() === 'UpgradeJob.tpl.html') {
					timeout(scope.refreshXLIBatchJobValidationLists, 3000);
				}

			});
		};
		scope.startProductHierarchyJob = function() {
			var parameters = {};
        	parameters.methodName =  "startProductHierarchyJob";
            var remoteOptions ={};
            remoteOptions.apexType =  scope.configData.telcoAdminConsoleClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.telcoAdminConsloleInvokeMethod(remoteOptions).then(function(result) {
				scope.productHierarchyJobsList = result.resolveProductHierarchyJobs;
			}, function(error) {
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
				}
			});
		};

		scope.addOrderLineItemJob = function() {
			scope.$parent.spinner.showSpinner();
			remoteActions.AddXLITime().then(function(result) {
				scope.$parent.spinner.hideSpinner();
				scope.result = result;
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
				}
			}, function(error) {
				if(result.hasErrors) {
					scope.errorMessage = result.errorMessage;
					scope.hasErrors = true;
				} else {
					scope.hasErrors = false;
				}
			});
		};

		scope.testConfigurationsJob = function() {
			scope.$parent.spinner.showSpinner();
			remoteActions.testConfigurationsJob().then(function(result) {
				scope.$parent.spinner.hideSpinner();
				scope.result = result.result;
				if(result.hasError) {
					scope.errorMessage = result.errorMessage;
					scope.hasError = true;
				} else {
					scope.hasError = false;
				}
			}, function(error) {
				if(result.hasError) {
					scope.errorMessage = result.errorMessage;
					scope.hasError = true;
				} else {
					scope.hasError = false;
				}
			});
		};

		scope.displayWaitDialog = function(parentId) {
			var over = j$('<div id="overlay-'+parentId+'">' +
					            '<img id="loading" src="'+scope.configData.waitingImage+'">' +
					            '</div>');
			var div = j$('#'+parentId);
			over.css('top', div.position().top);
			over.css('left', div.position().left);
	        j$(over).appendTo(div);
		};

		scope.removeWaitDialog = function(parentId) {
			j$('#overlay-'+parentId).remove();

		};

		scope.showSuccessStatus = function(parentId) {
			var over = j$('<div id="overlay-'+parentId+'">' +
      							'<span style="font-size: 2em; color:green" aria-hidden="true" data-icon="&#xea10;" class="icon-checkmark" />' +
      						'</div>');
		    var div = j$('#'+parentId);
		    over.css('top', div.position().top);
		    over.css('left', div.position().left);

			j$(over).appendTo(div);
			j$(over).fadeOut(2000).promise().then(function() {
				j$(over).remove();

			});

		};
	}
]);

},{}],3:[function(require,module,exports){
var app = angular.module('CMTAdmin');
app.controller('CMTAdminController', ['$scope', '$sldsModal', 'BasicService', 'PageSpinner', 'ActiveMenu', 'remoteActions', '$window',
	function (scope, modal, basicService, spinner, activeMenu, remoteActions, window) {
		scope.SLDSICON = window.SLDSICON;
		scope.labels = window.labels;
		scope.nsPrefix = window.configData.nsPrefix;
		scope.configurations = [];
		scope.selectedConfigurationIndex = 0;
		scope.spinner = spinner;
		scope.sectionList = [];
		scope.activeMenu = activeMenu;
		scope.showClickedMenu = function(menu) {
			scope.activeMenu.setActiveMenu(menu);
		};
	}
]);

},{}],4:[function(require,module,exports){
var app = angular.module('CMTAdmin');
app.controller('CustomSettingsController', ['$scope', '$sldsModal', 'BasicService', 'remoteActions', '$window', 'fieldLookupService',
	function (scope, modal, basicService, remoteActions, window, fieldLookupService) {
		scope.SLDSICON = window.SLDSICON;
		scope.labels = window.labels;
		scope.subModuleList = [];
		scope.module = {};
		scope.activeTab = 0;
		scope.search = {'name': ''};
		scope.allObjectList = [];
		scope.booleanSelectionOptions = [{"value":true,"label":"Yes"},{"value":false,"label":"No"}];
		scope.nsPrefix = window.configData.nsPrefix;
		scope.isDuplicateSequence = false;
		scope.isSearchBar = false;
		scope.tab = {
			index: 0
		};

		scope.$watch('tab.index', function(newValue, oldValue) {
			//get records on tab changes
			scope.activeTab = newValue;
			scope.getCustomSettingsRecord();
		});
		scope.filterList = function(item) {
			if(scope.search.name === '') {
				scope.isSearchBar = false;
				return true;
			}
			var fields = [];
			scope.isSearchBar = true;
			fields.push(item[scope.nsPrefix + 'ObjectName__c']);
			fields.push(item[scope.nsPrefix + 'Object_Name__c']);
			fields.push(item[scope.nsPrefix + 'IsEditable__c']);
			fields.push(item[scope.nsPrefix + 'Popup_Page_Id__c']);
			fields.push(item[scope.nsPrefix + 'SetupValue__c']);
			fields.push(item[scope.nsPrefix + 'Value__c']);
			fields.push(item[scope.nsPrefix + 'Sequence__c']);
			fields.push(item[scope.nsPrefix + 'FieldName__c']);
			if(scope.subModuleList[scope.activeTab].name === 'configurations') {
				// add name field
				fields.push(item.Name);
			}

			return scope.find(fields);
		};
		scope.find = function(fields) {
			for(var i=0; i<fields.length; i++) {
				if(fields[i]) {
					var m = (fields[i] + '').toLowerCase().match(scope.search.name.toLowerCase());
					if(m && m.length > 0) {
						return true;
					}
				}
			}
			return false;
		};
		scope.verifyDuplicate = function(propertyName) {
	        var sorted, i;
	        var records = scope.subModuleList[scope.activeTab].records;
	        var isInvalid = false;
	        sorted = records.concat().sort(function (a, b) {
	            if (a[propertyName] > b[propertyName]) return 1;
	            if (a[propertyName] < b[propertyName]) return -1;
	            return 0;
	        });
	        for(i = 0; i < records.length; i++) {
	            sorted[i].isDuplicate = ((sorted[i-1] && sorted[i-1][propertyName] == sorted[i][propertyName]) || (sorted[i+1] && sorted[i+1][propertyName] == sorted[i][propertyName]));
	            if(sorted[i].isDuplicate && !isInvalid) {
	            	isInvalid = sorted[i].isDuplicate;
	            }
	        }
	        scope.isDuplicate = isInvalid;
	    };
		scope.getMetadata = function() {
			scope.spinner.showSpinner();
			remoteActions.getCustomSettingsMetadata(scope.module.name).then(function(results) {
		        if(results.hasError){
					basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, error);
				}else{
					var module = results.result[0];
					scope.module = module;
					scope.subModuleList = module.subModuleList;
					scope.getCustomSettingsRecord();
				}
				scope.$parent.spinner.hideSpinner();
			}, function(error) {
				scope.$parent.spinner.hideSpinner();
				basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, error);
			});
		};
		scope.getCustomSettingsRecord = function() {
			if(!scope.subModuleList[scope.activeTab]) {
				return ;
			}
			scope.$parent.spinner.showSpinner();
			var objectAPI = scope.subModuleList[scope.activeTab].objectAPI;
			var feature = scope.subModuleList[scope.activeTab].feature;
			remoteActions.getCustomSettingsRecord(objectAPI, feature).then(function(results) {
				if(results.hasError) {
					basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, results.errorMessage);
				} else {
					scope.subModuleList[scope.activeTab].records = results.result;
				}
				scope.$parent.spinner.hideSpinner();
			}, function(error) {
				scope.$parent.spinner.hideSpinner();
				basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, error);
			});
		};
		scope.initApp = function(name) {
			scope.module.name = name;
			scope.getMetadata();
			scope.getObjectList();
		};
		scope.getObjectList = function() {
			var parameters = {};
            parameters.methodName =  'getGlobalDescribe';
            var remoteOptions ={};
            remoteOptions.apexType =  window.configData.adminClassType;
            remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.getObjectList(remoteOptions).then(function(result) {
				scope.allObjectList = JSON.parse(result.objectsDescribeListJSON.toString().replace('\n', ''));
				scope.$parent.spinner.hideSpinner();
			}, function(err) {
				scope.$parent.spinner.hideSpinner();
				basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, error);
			});
		};
		scope.delete = function(record, index) {
			var objectAPI = scope.subModuleList[scope.activeTab].objectAPI;
			var customsettingsID = record.Id;
			//var modalInstance = modal();
			var modalScope = scope.$new();
            modalScope.confirmationTitle = scope.labels.DeleteCustomSettingsLabel;
            modalScope.confirmationMsg = scope.labels.DeleteCustomSettingsWarningMessage;
            modalScope.cancelActionLbl = scope.labels.CancelLabel;
            modalScope.confirmActionLbl = scope.labels.DeleteLabel;
            modalScope.SLDSICON = scope.SLDSICON;
            modalScope.confirmAction = function() {
            	deleteModal.hide();
            	var records = scope.subModuleList[scope.activeTab].records;
                if(customsettingsID) {
                    scope.$parent.spinner.showSpinner();
					remoteActions.deleteCustomSettings(customsettingsID, objectAPI).then(function(results){
						scope.$parent.spinner.hideSpinner();
						records = records.splice(index, 1);
	                }, function(error) {
	                	scope.$parent.spinner.hideSpinner();
	                    basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, error);
	                });
				} else {
					records = records.splice(index, 1);
				}
            };
			var deleteModal = modal({
                templateUrl: 'ConfirmationModal.tpl.html',
                backdrop: 'static',
                scope: modalScope,
                show: true
			});
		};
		scope.checkSaveMode = function() {
			var save = false;
			var records = scope.subModuleList[scope.activeTab].records;
			if(records) {
				for(var i=0; i<records.length; i++) {
					if(records[i].editMode) {
						save = true;
						break;
					}
				}
			}
			return !save;
		};
		scope.add = function(records) {
			if(!records){
				records = [];
			}
			records.push(scope.createEmptyRecord());
		};
		scope.createEmptyRecord = function() {
			var record = {};
			var metaDataList = scope.subModuleList[scope.activeTab].metaDataList;
			for(var i=0; i<metaDataList.length; i++) {
				record[metaDataList[i].name] = '';
			}
			record.editMode = true;
			return record;
		};
		scope.fixLookupRecordBeforeSave = function(records) {
			for(var i=0; i<records.length; i++) {
				delete records[i].isDuplicate;
				delete records[i].editMode;
			}
		};
		scope.fixConfigRecordBeforeSave = function(records) {
			for(var i=0; i<records.length; i++) {
				delete records[i].isDuplicate;
				delete records[i].editMode;
			}
		};
		scope.fixFieldRecordBeforeSave = function(records) {
			for(var i=0; i<records.length; i++) {
				var sequence = records[i][scope.nsPrefix + 'Sequence__c'] + '';
				var feature = scope.subModuleList[scope.activeTab].feature;
				records[i][scope.nsPrefix + 'Feature__c'] = feature;
				delete records[i].isDuplicate;
				delete records[i].editMode;
			}
		};
		scope.save = function() {
			scope.$parent.spinner.showSpinner();
			var objectAPI = scope.subModuleList[scope.activeTab].objectAPI;
			var records = [];
			//get only edited records
			for(var i=0; i<scope.subModuleList[scope.activeTab].records.length; i++) {
				var record = scope.subModuleList[scope.activeTab].records[i];
				if(record.editMode) {
					records.push(record);
				}
			}
			var name = scope.subModuleList[scope.activeTab].name;
			if(name === 'displayFields' || name === 'queryFields' || name === 'updateFields') {
				scope.fixFieldRecordBeforeSave(records);
			} else if(name === 'lookupFields') {
				scope.fixLookupRecordBeforeSave(records);
			} else if(name === 'configurations') {
				scope.fixConfigRecordBeforeSave(records);
			}
			remoteActions.saveCustomSettings(objectAPI, angular.toJson(records)).then(function(results) {
				if(results.hasError){
					scope.$parent.spinner.hideSpinner();
					basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, results.errorMessage);
				} else{
					//saved
					scope.getCustomSettingsRecord();
				}
			}, function(error) {
				scope.$parent.spinner.hideSpinner();
				basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, error);
			});
		};
		scope.convertFieldSelName = function(fieldName) {
			var cFields = [];
			var names = fieldName.split(".");
			if(names.length > 1) {
				for(var i=0; i<names.length; i++) {
					if(names[i].indexOf('__c') !== -1 && i < names.length - 1){
						cFields.push(names[i].replace('__c','__r'));
					} else if (i < names.length - 1){
						cFields.push(names[i].substring(0, names[i].length-2));
					} else{
						cFields.push(names[i]);
					}
				}
			} else {
				cFields.push(fieldName);
			}
			return cFields.join(".");
		};
		scope.openFieldSelection = function (record) {
			var modalScope = scope.$new();
            modalScope.confirmationTitle = scope.labels.FieldSelectionLabel;
            modalScope.cancelActionLbl = scope.labels.CancelLabel;
            modalScope.confirmActionLbl = scope.labels.SaveLabel;
            modalScope.objectName = record[scope.nsPrefix + 'ObjectName__c'] || record[scope.nsPrefix + 'Object_Name__c'];
            modalScope.fieldName = scope.convertFieldSelName(record[scope.nsPrefix + 'FieldName__c']);
            modalScope.selectedFields = [];
            modalScope.nsPrefix = scope.nsPrefix;
            modalScope.SLDSICON = scope.SLDSICON;
            modalScope.confirmAction = function() {
                //
                var fieldInfo = scope.parseFields(modalScope.selectedFields);
                record.fieldName = fieldInfo.label;
                record[scope.nsPrefix + 'FieldName__c'] = fieldInfo.apiName;
                fieldSelectionModal.hide();
            };
			var fieldSelectionModal = modal({
				templateUrl: 'FieldSelectionModal.tpl.html',
                backdrop: 'static',
                scope: modalScope,
                show: true
			});
		};
		scope.parseFields = function(selectedFields) {
			var fieldName = [];
			var fieldApiNames = [];
			var fieldType = null;
			var numberOfFields = selectedFields.length;
			var lastReferenceObject = null;
			for (i = 0; i < numberOfFields; i++) {
				var fieldInfo = selectedFields[i];
				if(fieldInfo.type === 'reference'){
					lastReferenceObject = fieldInfo.referenceTo[0];
				}
				// if it's a reference field and there is an element after it
				if(fieldInfo.type === 'reference' && i < numberOfFields - 1){
					if(fieldInfo.name.indexOf('__c') !== -1){
						fieldName.push(fieldInfo.name.replace('__c','__r'));

					}else{
						fieldName.push(fieldInfo.name.substring(0,fieldInfo.name.length-2));

					}
				} else {
					fieldName.push(fieldInfo.name);

				}
				fieldType = fieldInfo.type;
				fieldApiNames.push(fieldInfo.name);
			}
			var fullFieldName = '';
			for (i = 0; i < fieldName.length; i++) {
				fullFieldName += fieldName[i];
				if(i !==  fieldName.length-1){
					fullFieldName += '.';
				}

			}
			retVal = {};
			retVal.fullFieldName = fullFieldName;
			retVal.fieldType = fieldType;
			retVal.lastReferenceObject = lastReferenceObject;
			if(fieldApiNames.length > 0) {
				retVal.apiName = fieldApiNames.join(".");
			}
			return retVal;
		};
		scope.openPageSelection = function(record) {
			var modalScope = scope.$new();
            modalScope.confirmationTitle = scope.labels.PageSelectionLabel;
            modalScope.cancelActionLbl = scope.labels.CancelLabel;
            modalScope.confirmActionLbl = scope.labels.SaveLabel;
            modalScope.pageWrapper = {page:{}};
            modalScope.pageWrapper.page.Name = record[scope.nsPrefix + 'Popup_Page_Id__c'];
            modalScope.nsPrefix = scope.nsPrefix;
            modalScope.SLDSICON = scope.SLDSICON;
            scope.$parent.spinner.hideSpinner();
            modalScope.search = '';
            modalScope.confirmAction = function() {
                record[scope.nsPrefix + 'Popup_Page_Id__c'] = modalScope.pageWrapper.page.Name;
                pageSelectionModal.hide();
            };
            modalScope.init = function() {
            	modalScope.getPageList('');
            };
            modalScope.searchPage = function(search) {
            	modalScope.getPageList(search);
            };
            modalScope.getPageList = function(search) {
            	scope.$parent.spinner.showSpinner();
            	remoteActions.getPageList(search).then(function(results) {
					if(results.hasError){
						basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, results.errorMessage);
					} else{
						//saved
						modalScope.pageList = results.result;
					}
					scope.$parent.spinner.hideSpinner();
				}, function(error) {
					scope.$parent.spinner.hideSpinner();
					basicService.openAlertWindow(scope, scope.labels.CustomSettingsError, error);
				});
            };
			var pageSelectionModal = modal({
				templateUrl: 'PageSelectionModal.tpl.html',
                backdrop: 'static',
                scope: modalScope,
                show: true
			});
			modalScope.init();
		};
	}
]);

},{}],5:[function(require,module,exports){
var app = angular.module('CMTAdmin');
app.controller('DashboardController', ['$scope', '$sldsModal', 'BasicService', 'PageSpinner', 'ActiveMenu', 'remoteActions', '$window',
	function (scope, modal, basicService, spinner, activeMenu, remoteActions, window) {
		scope.SLDSICON = window.SLDSICON;
		scope.labels = window.labels;
		scope.nsPrefix = window.configData.nsPrefix;
		scope.configurations = [];
		scope.selectedConfigurationIndex = 0;
		scope.spinner = spinner;
		scope.sectionList = [];

		scope.initApp = function() {
			scope.spinner.showSpinner();
			remoteActions.getAdminOptions().then(function(results) {
		        if(results.hasError) {
					basicService.openAlertWindow(scope, scope.labels.CMTAdminError, error);
				}else{
					scope.sectionList = results.result;
				}
				scope.spinner.hideSpinner();
			}, function(error) {
				scope.spinner.hideSpinner();
				basicService.openAlertWindow(scope, scope.labels.CMTAdminError, error);
			});
		};

		scope.showClickedMenu = function(menu) {
			activeMenu.setActiveMenu(menu);
		};
	}
]);

},{}],6:[function(require,module,exports){
var app = angular.module('CMTAdmin');
app.controller('EnableFeaturesController', ['$scope', '$sldsModal', 'BasicService', 'PageSpinner', 'remoteActions', '$window',
    function (scope, modal, basicService, spinner, remoteActions, window) {
        scope.SLDSICON = window.SLDSICON;
        scope.labels = window.labels;
        scope.nsPrefix = window.configData.nsPrefix;
        scope.loyaltyPoints = {};
        scope.spinner = spinner;
        scope.featureList;
        scope.module = {};

        scope.initApp = function(name, label) {
            scope.module.name = name;
            scope.module.label = label;
            scope.getMetadata();
        };
        scope.getMetadata = function() {
            scope.spinner.showSpinner();
            remoteActions.getCustomSettingsMetadata(scope.module.name).then(function(results) {
                if(results.hasError){
                    basicService.openAlertWindow(scope, scope.labels.EnableFeaureError, error);
                }else{
                    var module = results.result[0];
                    scope.module = module;
                    scope.subModule = module.subModuleList[0];
                    scope.getCustomSettingsRecord();
                }
                scope.$parent.spinner.hideSpinner();
            }, function(error) {
                scope.$parent.spinner.hideSpinner();
                basicService.openAlertWindow(scope, scope.labels.EnableFeaureError, error);
            });
        };
        scope.getCustomSettingsRecord = function() {
            scope.$parent.spinner.showSpinner();
            var objectAPI = scope.subModule.objectAPI;
            var feature = scope.subModule.feature;
            remoteActions.getCustomSettingsRecord(objectAPI, feature).then(function(results) {
                if(results.hasError) {
                    basicService.openAlertWindow(scope, scope.labels.EnableFeaureError, results.errorMessage);
                } else {
                    scope.featureList = results.result;
                }
                scope.$parent.spinner.hideSpinner();
            }, function(error) {
                scope.$parent.spinner.hideSpinner();
                basicService.openAlertWindow(scope, scope.labels.EnableFeaureError, error);
            });
        };
        scope.enableDisableFeature = function(f) {
            var feature = angular.copy(f);
            var modalScope = scope.$new();
            if(feature.isEnabled) {
                modalScope.confirmActionLbl = scope.labels.Enable;
                modalScope.confirmationMsg = scope.labels.EnableSettingWarning;
                modalScope.confirmationTitle = scope.labels.Enable+ ' '+ feature.label;
            } else {
                modalScope.confirmActionLbl = scope.labels.Disable;
                modalScope.confirmationMsg = feature.warningMessage;
                modalScope.confirmationClass = 'slds-theme_warning';
                modalScope.confirmationTitle = scope.labels.Disable + ' ' + feature.label;
            }
            modalScope.cancelActionLbl = scope.labels.CancelLabel;
            modalScope.isCancelActionRequried = true;
            modalScope.SLDSICON = scope.SLDSICON;
            modalScope.cancelAction = function() {
                f.isEnabled = !f.isEnabled;
                confirmModal.hide();
            };
            modalScope.confirmAction = function() {
                feature[scope.nsPrefix + 'SetupValue__c'] = feature.isEnabled + '';
                delete feature['label'];
                delete feature['warningMessage'];
                delete feature['isEnabled'];
                var objectAPI = scope.subModule.objectAPI;
                confirmModal.hide();
                scope.$parent.spinner.showSpinner();
                remoteActions.saveCustomSettings(objectAPI, angular.toJson(feature)).then(function(results) {
                    if(results.hasError){
                        basicService.openAlertWindow(scope, scope.labels.EnableFeaureError, results.errorMessage);
                    } else {
                        if(f.isEnabled) {
                            basicService.openAlertWindow(scope, f.label, scope.labels.EnableFeatureSuccessMessage);
                        } else {
                            basicService.openAlertWindow(scope, f.label, scope.labels.DisableFeatureSuccessMessage);
                        }
                    }
                    scope.$parent.spinner.hideSpinner();
                }, function(error) {
                    scope.$parent.spinner.hideSpinner();
                    basicService.openAlertWindow(scope, scope.labels.EnableFeaureError, error);
                });
            };
            var confirmModal = modal({
                templateUrl: 'ConfirmationModal.tpl.html',
                backdrop: 'static',
                scope: modalScope,
                show: true
            });
        }
    }
]);

},{}],7:[function(require,module,exports){
angular.module('CMTAdmin')
.factory('PageSpinner', [
	function(){
		var spinner = false;
		return {
			getSpinner: function() {
				return spinner;
			},
			showSpinner: function() {
				spinner = true;
			},
			hideSpinner: function() {
				spinner = false;
			}
		};
	}
]);
angular.module('CMTAdmin')
.factory('ActiveMenu', [
	function(){
		var menuTemplate = 'Dashboard.tpl.html';
		return {
			getActiveMenu: function() {
				return menuTemplate;
			},
			setActiveMenu: function(menu) {
				menuTemplate = menu + '.tpl.html';
			}
		};
	}
]);
// This module is necessary to pass salesforce merged valued to directives in static resources.
//used for the field Lookup Directive
angular.module('parameters',[])
	.factory('ParametersFactory', ['$window', function(window){
		var factory = {};
		factory.getRemoteInvokeMethod = function(){
			return window.configData.adminInvokeMethod;
		
		};
		
		factory.getClassType = function(){
			return window.configData.adminClassType;
		
		};
		
		factory.getLoadingImg = function(){
			return window.configData.waitingImage;
		};
		
		factory.getNsPrefix = function(){
			return window.configData.nsPrefix;
		};
		
		return factory;
	
	}]);
},{}],8:[function(require,module,exports){
var app = angular.module('CMTAdmin');
app.service('BasicService',['$sldsModal', function BasicService(modal) {

    BasicService.prototype.openAlertWindow = function (scope, title, message) {
		var modalScope = scope.$new();
            modalScope.confirmationTitle = title;
            modalScope.errorMessage = message;
            modalScope.cancelActionLbl = scope.labels.OKLabel;
        var deleteModal = modal({
            templateUrl: 'ErrorModal.tpl.html',
            backdrop: 'static',
            scope: modalScope,
            show: true
		});
	};
}]);

},{}],9:[function(require,module,exports){
angular.module("CMTAdmin").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("AdminConsole.tpl.html",'<div ng-controller="AdminConsoleController" class="grid-wrapper slds-grid slds-theme_shade" ng-init="initApp()">\n\t<div class="module-menu slds-grid_vertical slds-size_3-of-12 slds-p-left-medium">\n\t\t<ul role="menu" class="slds-has-block-links_space slds-has-dividers_bottom">\n\t\t\t<li ng-repeat="menu in menuList track by $index" class="slds-item slds-clearfix" ng-class="activeMenu === $index ? \'slds-item-active\': \'\'" ng-click="makeActiveMenu($index)">\n\t\t\t\t<a role="menuitem" href="javascript:void(0);" >\n\t                <p class="slds-truncate" ng-click="menuToggle = module">\n\t                  <span class="slds-icon_container slds-m-right_medium slds-float_right">\n\t                    <svg aria-hidden="true" class="slds-icon slds-icon-text-default slds-icon_x-small">\n\t                      <use xlink:href="{{SLDSICON.RIGHT_ARROW}}"></use>\n\t                    </svg>\n\t                  </span>\n\t                  <span>{{menu.label}}</span>\n\t                </p>\n\t            </a>\n\t\t\t</li>\n\t\t</ul>\n\t</div>\n\t<div ng-if="menuList[activeMenu].name === \'maintenanceJob\' " class="job-wrapper slds-size_9-of-12 slds-p-around_medium">\n\t\t<div class="job-section slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isRootAccountJobsCollapsed = !isRootAccountJobsCollapsed">{{labels.AccountHierarchyMaintenance}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.JobRestoreAccountHierarchy}}</div>\n\t\t\t\t</div>\n\t\t\t\t<span class="job-start slds-float_right">\n\t\t\t\t\t<button id="idAcctHierStartButton" type="button" ng-click="isRootAccountJobsCollapsed = true; startRootAccountJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</span>\n\t\t\t</div>\n\t\t\t<div ng-if="rootAccountJobsList.length != 0" ng-show="isRootAccountJobsCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\tng-repeat="job in rootAccountJobsList track by $index">\n\t\t\t\t\t  \t<td class="slds-cell-wrap">\n\t\t\t\t\t\t  \t<p>{{labels.ResolveRootAccounts}}</p>\n\t\t\t\t\t  \t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t<!-- <a href="#" class="list-group-item">\n\t\t\t<div class="row">\n\t\t\t\t<div class="col-md-8 col-sm-12 col-xs-12">\n\t\t\t\t\t<h4 class="list-group-item-heading">Party Model Maintenance</h4>\n\t\t\t\t\t<p class="list-group-item-text">This job will create missing party records.</p>\n\t\t\t\t</div>\n\t\t\t\t<div class="col-md-4 col-sm-12 col-xs-12  text-right ">\n\t\t\t\t\t<button type="button" ng-click="addItem();" class="btn btn-primary btn-sm">Start</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</a> -->\n\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.InterfaceImplementationMaintenanceRestore}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.JobRestoreImplementations}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idInImpStartButton" type="button" ng-click="resetInterfaceImplementations();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="slds-media">\n\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.InterfaceImplementationMaintenanceMerge}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.MergeInterfaceImplementations}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idMergeInImpStartButton" type="button" ng-click="mergeInterfaceImplementations();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idInImpStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.FieldMapsMaintenance}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.JobRestoreFieldMaps}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idfldMapStartButton" type="button" ng-click="resetFieldMaps();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idfldMapStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">Object Map Maintenance</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">This job will restore default object maps.</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idObjMapStartButton" type="button" ng-click="resetObjectMaps();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idObjMapStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom" >\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isXLIRoot = !isXLIRoot">Batch Validation</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">Start Batch Validation Job</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="id1" type="button" ng-click="isXLIRoot = true; startXLIBatchValidationJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div  ng-show="isXLIRoot">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\tng-repeat="job in XLIBatchJobValidationList track by $index">\n\t\t\t\t\t  \t<td class="slds-cell-wrap">\n\t\t\t\t\t\t  \t<p>Batch Validation</p>\n\t\t\t\t\t  \t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">Reset XLI validation Data</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">Validated Orders will be reset</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idResetXLIValidationDataButton" type="button" ng-click="resetXLIBatchValidationData();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idResetXLIValidationDataStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isProductHierarchyJobsCollapsed = !isProductHierarchyJobsCollapsed">{{labels.ProductHierarchyMaintenanceTitle}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.ProductHierarchyMaintenanceDescription}}</div>\n\t\t\t\t</div>\n\t\t\t\t<span class="job-start slds-float_right">\n\t\t\t\t\t<button id="idProdHierStartButton" type="button" ng-click="isProductHierarchyJobsCollapsed = true; startProductHierarchyJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</span>\n\t\t\t</div>\n\t\t\t<div class="slds-media">\n\t\t\t\t<div ng-if="hasErrors" class="slds-notify slds-notify_alert slds-theme_error slds-theme_alert-texture" role="alert">{{errorMessage}}</div>\n\t\t\t</div>\n\t\t\t<div ng-if="productHierarchyJobsList.length != 0" ng-show="isProductHierarchyJobsCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\tng-repeat="job in productHierarchyJobsList track by $index">\n\t\t\t\t\t  \t<td class="slds-cell-wrap">\n\t\t\t\t\t\t  \t<p>{{labels.ProductHierarchyMaintenanceJobName}}</p>\n\t\t\t\t\t  \t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t<!-- <a href="#" class="list-group-item">\n\t\t\t<div class="row">\n\t\t\t\t<div class="col-md-8 col-sm-12 col-xs-12">\n\t\t\t\t\t<h4 class="list-group-item-heading">Interface Implementation Maintenance</h4>\n\t\t\t\t\t<p class="list-group-item-text">This job will restore default interface implementations.</p>\n\t\t\t\t</div>\n\t\t\t\t<div class="col-md-4 col-sm-12 col-xs-12  text-right ">\n\t\t\t\t\t<button type="button" ng-click="addItem();" class="btn btn-primary btn-sm">Start</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</a> -->\n\t</div>\n\n\t<div ng-if="menuList[activeMenu].name === \'upgradeJob\' " class="job-wrapper slds-size_9-of-12 slds-p-around_medium">\n\t\t<div class="job-section slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isAttributesBindingJobCollapsed = !isAttributesBindingJobCollapsed">Attributes Binding Upgrade</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">This job will populate the bound attribute fields from the JSON to the specified object fields based on the entity class definition</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-objectName slds-p-left_medium slds-float_left">\n\t\t\t\t    <input id="idAttributesBindingObjects" class="slds-input" type="text" placeholder="Object name" />\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idAttributesBindingButton"type="button" ng-click="isAttributesBindingJobCollapsed = true; startAttributesBindingJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div ng-if="attributesBindingJobsList.length != 0" ng-show="isAttributesBindingJobCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\tng-repeat="job in attributesBindingJobsList track by $index">\n\t\t\t\t\t  \t<td class="slds-cell-wrap">\n\t\t\t\t\t\t  \t<p>Attributes Binding Upgrade</p>\n\t\t\t\t\t  \t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isRootProductChildItemJobCollapsed = !isRootProductChildItemJobCollapsed">Root Product Child Item Upgrade</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">This job will create a product child item record for each product with the "Is Root Product Child Item" Flag Set.</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idRootProductChildItemButton" type="button" ng-click="isRootProductChildItemJobCollapsed = true; startRootProductChildItemJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div ng-if="rootProductChildItemJobsList.length != 0" ng-show="isRootProductChildItemJobCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap"></th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n'+"\t\t\t\t\t\t\t\t\t'slds-theme_default': job.Status == 'Holding',\n\t\t\t\t\t\t\t\t\t'slds-theme_default': job.Status == 'Preparing',\n\t\t\t\t\t\t\t\t\t'slds-theme_success': job.Status == 'Completed',\n\t\t\t\t\t\t\t\t\t'slds-theme_info': job.Status == 'Aborted',\n\t\t\t\t\t\t\t\t\t'slds-theme_warning': job.Status == 'Processing',\n\t\t\t\t\t\t\t\t\t'slds-theme_error': job.Status == 'Failed'}\"\n\t\t\t\t\t\tng-repeat=\"job in rootProductChildItemJobsList track by $index\">\n\t\t\t\t\t  \t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t  \t<p>Root Product Child Item Upgrade</p>\n\t\t\t\t\t  \t</td>\n\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : 'short' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : 'short' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t</div>\n</div>"),$templateCache.put("ConfirmationModal.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header" ng-class="confirmationClass">\n            <button class="slds-button slds-button_icon-inverse slds-modal__close" ng-click="isCancelActionRequried ? cancelAction() : $hide()">\n                <svg aria-hidden="true" class="slds-button__icon slds-button__icon_large">\n                    <use xlink:href="{{SLDSICON.CLOSE}}"></use>\n                </svg>\n                <span class="slds-assistive-text">{{labels.CloseLabel}}</span>\n            </button>\n            <h2 class="slds-text-heading_medium">{{confirmationTitle}}</h2>\n        </div>\n        <div class="slds-modal__content slds-p-around_medium">\n            <div>\n                <p ng-bind-html="confirmationMsg"></p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button_neutral" ng-click="isCancelActionRequried ? cancelAction() : $hide()">{{cancelActionLbl}}</button>\n            <button type="button" class="slds-button slds-button_neutral slds-button_brand" ng-click="confirmAction()">{{confirmActionLbl}}</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop_open"></div>\n'),$templateCache.put("CpqConfig.tpl.html",'<div ng-controller="CustomSettingsController" ng-init="initApp(\'genericcpq\')">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="slds-p-around_small" slds-active-pane="tab.index" slds-tabs-pane-class="slds-p-top_none" slds-tabs="true">\n\t\t<div ng-repeat="subModule in subModuleList" slds-pane="true" data-title="{{subModule.label}}" ng-include="\'Module.tpl.html\'"></div>\n\t</div>\n</div>'),$templateCache.put("CustomSettings.tpl.html",'<div ng-controller="CustomSettingsController" class="grid-wrapper slds-grid slds-theme_shade" ng-init="initApp()">\n\t<div class="module-menu slds-grid_vertical slds-size_3-of-12 slds-p-left-medium">\n\t\t<ul role="menu" class="slds-has-block-links_space slds-has-dividers_bottom">\n\t\t\t<li ng-repeat="module in metadata track by $index" class="slds-item slds-clearfix" ng-class="activeIndex.module === $index ? \'slds-item-active\': \'\'" ng-click="makeActiveModule($index)">\n\t\t\t\t<a role="menuitem" href="javascript:void(0);" >\n\t                <p class="slds-truncate" ng-click="menuToggle = module">\n\t                  <span class="slds-icon_container slds-m-right_medium slds-float_right">\n\t                    <svg aria-hidden="true" class="slds-icon slds-icon-text-default slds-icon_x-small">\n\t                      <use xlink:href="{{SLDSICON.RIGHT_ARROW}}"></use>\n\t                    </svg>\n\t                  </span>\n\t                  <span>{{module.label}}</span>\n\t                </p>\n\t            </a>\n\t\t\t</li>\n\t\t</ul>\n\t</div>\n\t<div class="tab-wrapper slds-grid_vertical slds-size_9-of-12 slds-p-left_medium slds-p-right_x-small">\n\t\t<div slds-active-pane="activeIndex.subModule" slds-tabs-pane-class="slds-p-top_none" slds-tabs="true">\n\t\t\t<div ng-repeat="subModule in metadata[activeIndex.module].subModuleList" slds-pane="true" data-title="{{subModule.label}}" ng-include="\'Module.tpl.html\'"></div>\n\t\t</div>\n\t</div>\n</div>'),$templateCache.put("Dashboard.tpl.html",'<div ng-controller="DashboardController" ng-init="initApp()">\n    <div class="slds-p-around_small">\n    </div>\n    <div class="slds-grid slds-grid_pull-padded-small">\n    \t<div class="slds-p-horizontal_small slds-size_1-of-3 slds-medium-size_2-of-6 slds-large-size_4-of-12" ng-repeat="section in sectionList track by $index" ng-class="{\'slds-p-right_small\': $index % 1 === 0}">\n            <div class="slds-card">\n                <div class="slds-card__header slds-grid grid_flex-spread slds-p-horizontal_x-small">\n                    <h2 class="slds-text-heading_medium slds-truncate" title="{{section.name}}">{{section.label}}</h2>\n                </div>\n                <div class="slds-card__body">\n                    <ul class="slds-list_vertical slds-has-dividers_top-space slds-has-list-interactions slds-theme_default fix-border-bottom-radius">\n                        <li class="slds-list__item slds-p-horizontal_x-small" ng-repeat="menu in section.menuList">\n                            <div class="slds-clearfix">\n                                <div class="slds-float_left">\n                                    <a href ng-click="showClickedMenu(menu.name)" title="{{menu.label}}">{{menu.label}}\n                                    </a>\n                                </div>\n                            </div>\n                        </li>\n                    </ul>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("EPCJob.tpl.html",'<div ng-controller="AdminConsoleController" ng-init="initApp(\'epcJobs\', labels.CMTOptionEPCJobsLabel)">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="job-wrapper">\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.InstallDefaultLayouts}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.InstallDefaultLayoutsDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="importEpcObjectsLayoutsButton" type="button" ng-click="importEpcObjectsLayouts();" class="slds-button  slds-button_brand">{{labels.InstallLabel}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="createEpcObjectClassesStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.InstallDefaultPPD}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.InstallDefaultPPDDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="importPricingPlanDataButton" type="button" ng-click="importPricingPlanData();" class="slds-button  slds-button_brand">{{labels.InstallLabel}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.DeleteDefaultObjectLayouts}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.DeleteLayoutsDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="deleteEpcDefaultLayoutsButton" type="button" ng-click="deleteEpcDefaultLayouts();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="deleteEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.CreateDefaultPVB}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.CreateDefaultPVBDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="createDefaultPricingVariablesButton" type="button" ng-click="createDefaultPricingVariables();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="createDefaultPricingVariablesStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.GenerateGlobalKey}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.GenerateGlobalKeyDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="generateGlobalKeysButton" type="button" ng-click="generateEPCGlobalKeys();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="generateGlobalKeysStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)"><span class="slds-text-color_error">[{{labels.DeprecatedLabel}}]</span> {{labels.CreateDefaultObjectClass}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.CreateDefaultObjectClassDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="createEpcObjectClassesButton" type="button" ng-click="createEpcObjectClasses();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="createEpcObjectClassesStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)"><span class="slds-text-color_error">[{{labels.DeprecatedLabel}}]</span> {{labels.CreateDefaultLayout}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.CreateDefaultLayoutDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="createEpcDefaultLayoutsButton" type="button" ng-click="createEpcDefaultLayouts();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="createEpcDefaultLayoutsStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t</div>\n</div>\n'),
$templateCache.put("EnableFeatures.tpl.html",'<div ng-controller="EnableFeaturesController" ng-init="initApp(\'EnableFeatures\', \'Enable Features\')">\n    <div ng-include="\'SubHeader.tpl.html\'"></div>\n    <div class="slds-theme_shade">\n        <div class="job-wrapper slds-p-around_medium" ng-repeat="feature in featureList">\n            <div class="slds-grid slds-theme_default slds-p-around_small">\n                <div class="slds-size_1-of-2">\n                    <span ng-bind="feature.label"></span>\n                </div>\n                <div class="slds-size_1-of-2">\n                    <div class="slds-float_right slds-form-element">\n                        <label class="slds-checkbox_toggle slds-grid">\n                            <input type="checkbox" name="checkbox" aria-describedby="toggle-desc" ng-model="feature.isEnabled"\n                            ng-change="enableDisableFeature(feature)" />\n                            <span id="toggle-desc" class="slds-checkbox_faux_container" aria-live="assertive">\n                                <span class="slds-checkbox_faux"></span>\n                                <span class="slds-checkbox_on">{{labels.EnabledLabel}}</span>\n                                <span class="slds-checkbox_off">{{labels.DisabledLabel}}</span>\n                            </span>\n                        </label>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("ErrorModal.tpl.html",'<div>\n    <div aria-hidden="false" aria-labelledby="prompt-heading-id" aria-describedby="prompt-message-wrapper" role="alertdialog" class="slds-modal slds-modal_prompt slds-fade-in-open">\n        <div class="slds-modal__container slds-modal_prompt" role="document" id="prompt-message-wrapper" tabindex="0">\n            <div class="slds-modal__header slds-theme_error slds-theme_alert-texture">\n                <h2 class="slds-text-heading_medium" id="prompt-heading-id">{{confirmationTitle}}</h2>\n            </div>\n            <div class="slds-modal__content slds-p-around_medium">\n                <div>\n                    <p>{{errorMessage}}</p>\n                </div>\n            </div>\n            <div class="slds-modal__footer slds-theme_default">\n                <button class="slds-button slds-button_neutral" ng-click="$hide()">{{cancelActionLbl}}</button>\n            </div>\n        </div>\n    </div>\n    <div class="slds-backdrop slds-backdrop_open"></div>\n</div>'),$templateCache.put("FieldSelectionModal.tpl.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-button_icon-inverse slds-modal__close" ng-click="$hide()">\n                <svg aria-hidden="true" class="slds-button__icon slds-button__icon_large">\n                    <use xlink:href="{{SLDSICON.CLOSE}}"></use>\n                </svg>\n                <span class="slds-assistive-text">{{labels.CloseLabel}}</span>\n            </button>\n            <h2 class="slds-text-heading_medium">{{confirmationTitle}}</h2>\n        </div>\n        <div class="slds-modal__content slds-p-around_medium">\n            <field-Lookup object-name="objectName" field-name="fieldName" selected-fields="selectedFields"> </field-Lookup>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button_neutral" ng-click="$hide()">{{cancelActionLbl}}</button>\n            <button type="button" class="slds-button slds-button_neutral slds-button_brand" ng-click="confirmAction()">{{confirmActionLbl}}</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop_open"></div>\n'),$templateCache.put("FunctionalJob.tpl.html",'<div ng-controller="AdminConsoleController" ng-init="initApp(\'FunctionalJobs\', labels.CMTOptionFunctionalJobsLabel)">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="job-wrapper">\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.BasicConfigLabel}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.BasicConfigDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="testConfigurationsJobButton" type="button" ng-click="showTestResults = true; testConfigurationsJob();" class="slds-button  slds-button_brand">{{labels.CheckLabel}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\n\t\t\t<div class="row">\n\t\t\t\t<div id="testConfigurationsJobStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasError" style="color : red" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\n\t\t\t<div ng-if="result.Cache != 0" ng-show="showTestResults">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr ng-class="slds-theme_shade" style="background-color : #cfeef8">\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Cache</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Current Status (Used Capacity)</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Expected Status</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\'slds-theme_error\': result.Cache.SessionCache !== \'Available\' || result.Cache.SessionCacheSize> 95}">\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>Session Cache</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{result.Cache.SessionCache}} ({{result.Cache.SessionCacheSize}}%)</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>Available</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\'slds-theme_error\': result.Cache.OrganizationCache !== \'Available\' || result.Cache.OrganizationCacheSize> 95}">\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>Organization Cache</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{result.Cache.OrganizationCache}} ({{result.Cache.OrganizationCacheSize}}%)</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>Available</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\n\t\t\t<div ng-if="result != 0" ng-show="showTestResults">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr ng-class="slds-theme_success" style="background-color : #cfeef8">\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Triggers</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Current Value</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Expected Value</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\n\t\t\t\t\t\t\t\t\t\'slds-theme_error\': result.AllTriggers != \'On\'\n\t\t\t\t\t\t\t\t\t}">\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>AllTriggers</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{result.AllTriggers}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>On</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\n\t\t\t<div ng-if="result != 0" ng-show="showTestResults">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr ng-class="slds-theme_success" style="background-color : #cfeef8">\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Custom Field Map</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Current Value</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Expected Value</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\'slds-theme_warning\': result.CustomFieldMapCount < 300}">\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>CustomFieldMapCount</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{result.CustomFieldMapCount}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>> 300</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\n\t\t\t<div ng-if="result != 0" ng-show="showTestResults">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr ng-class="slds-theme_success" style="background-color : #cfeef8">\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Interface Implementation</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Current Value</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Expected Value</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\'slds-theme_warning\': result.InterfaceImplementationCount < 50">\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>InterfaceImplementationCount</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{result.InterfaceImplementationCount}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>>=50</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\n\t\t\t<div ng-if="result != 0" ng-show="showTestResults">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr ng-class="slds-theme_success" style="background-color : #cfeef8">\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Custom Settings</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Current Value</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Recommended Value</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-repeat="(key, value) in result.CustomSettings" ng-class="{\'slds-theme_error\': ((value.Current | lowercase) !== (value.Recommended | lowercase) && value.Recommended !== undefined)}">\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{key}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{value.Current}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{value.Recommended}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t</div>\n</div>\n'),$templateCache.put("MaintenanceJob.tpl.html",'<div ng-controller="AdminConsoleController" ng-init="initApp(\'maintenanceJobs\', labels.CMTOptionMaintenanceJobsLabel)">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="job-wrapper">\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isRootAccountJobsCollapsed = !isRootAccountJobsCollapsed">{{labels.AccountHierarchyMaintenance}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.JobRestoreAccountHierarchy}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idAcctHierStartButton" type="button" ng-click="isRootAccountJobsCollapsed = true; startRootAccountJob();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div ng-if="rootAccountJobsList.length != 0" ng-show="isRootAccountJobsCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<thead>\n\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</thead>\n\t\t\t\t\t<tbody>\n\t\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\t\tng-repeat="job in rootAccountJobsList track by $index">\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{labels.ResolveRootAccounts}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</tbody>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.InterfaceImplementationMaintenanceRestore}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.JobRestoreImplementations}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idInImpStartButton" type="button" ng-click="resetInterfaceImplementations();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="slds-media">\n\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.InterfaceImplementationMaintenanceMerge}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.MergeInterfaceImplementations}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idMergeInImpStartButton" type="button" ng-click="mergeInterfaceImplementations();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idInImpStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.FieldMapsMaintenance}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.JobRestoreFieldMaps}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idfldMapStartButton" type="button" ng-click="resetFieldMaps();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idfldMapStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.ObjectMapMaintenance}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.ObjectMapMaintenanceDescription}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idObjMapStartButton" type="button" ng-click="resetObjectMaps();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idObjMapStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom" >\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isXLIRoot = !isXLIRoot">{{labels.BatchValidation}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.StartBatchJobValidation}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="id1" type="button" ng-click="isXLIRoot = true; startXLIBatchValidationJob();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div  ng-show="isXLIRoot">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<thead>\n\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</thead>\n\t\t\t\t\t<tbody>\n\t\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\t\tng-repeat="job in XLIBatchJobValidationList track by $index">\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{labels.BatchValidation}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</tbody>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.ResetXLIValiatonData}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.ValidateOrdersReset}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idResetXLIValidationDataButton" type="button" ng-click="resetXLIBatchValidationData();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idResetXLIValidationDataStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isProductHierarchyJobsCollapsed = !isProductHierarchyJobsCollapsed">{{labels.ProductHierarchyMaintenanceTitle}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.ProductHierarchyMaintenanceDescription}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idProdHierStartButton" type="button" ng-click="isProductHierarchyJobsCollapsed = true; startProductHierarchyJob();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div ng-if="productHierarchyJobsList.length != 0" ng-show="isProductHierarchyJobsCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<thead>\n\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</thead>\n\t\t\t\t\t<tbody>\n\t\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\t\tng-repeat="job in productHierarchyJobsList track by $index">\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{labels.ProductHierarchyMaintenanceJobName}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</tbody>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.ClearManagedPlatformCache}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_xx-small">{{labels.ClearManagedPlatformCacheDescription}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idClearCacheStartButton" type="button" ng-click="clearPlatformCache();" class="slds-button slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="row">\n\t\t\t\t<div id="idClearCacheDataStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t<div ng-if="hasErrors" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isrefreshPriceBookJobsCollapsed = !isrefreshPriceBookJobsCollapsed">{{labels.RefreshPricebook}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.RefreshPricebookDescription}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idRefreshPriceBookStartButton" type="button" ng-click="isrefreshPriceBookJobsCollapsed = true; refreshPriceBook();" class="slds-button  slds-button--brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div ng-if="refreshPriceBookJobList.length != 0" ng-show="isrefreshPriceBookJobsCollapsed">\n\t\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n'+"\t\t\t\t\t\t\t\t\t\t'slds-theme_default': job.Status == 'Holding',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_default': job.Status == 'Preparing',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_success': job.Status == 'Completed',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_info': job.Status == 'Aborted',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_warning': job.Status == 'Processing',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_error': job.Status == 'Failed'}\"\n\t\t\t\t\t\t\tng-repeat=\"job in refreshPriceBookJobList track by $index\">\n\t\t\t\t\t\t  \t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t  \t<p>{{labels.RefreshPricebook}}</p>\n\t\t\t\t\t\t  \t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : 'short' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : 'short' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</table>\n\t\t\t\t</div>\n\t\t</div>\n\t</div>\n</div>\n"),$templateCache.put("Module.tpl.html",'<div class="slds-p-around_small" ng-if="!showLoading">\n\t<ng-form name="moduleForm">\n\t\t<div class="slds-input-has-icon slds-input-has-icon_left">\n\t\t\t<svg aria-hidden="true" class="slds-input__icon slds-input__icon_left slds-icon-text-default">\n\t\t\t\t<use xlink:href="{{SLDSICON.SEARCH}}"></use>\n\t\t\t</svg>\n\t\t\t<input type="search" placeholder="{{labels.SearchLabel}}"\n\t\t\tng-model="search.name" class="slds-input">\n\t\t</div>\n\t\t<table class="slds-table slds-table_bordered slds-table_cell-buffer slds-m-top_medium">\n\t  \t\t<thead>\n\t    \t\t<tr class="slds-text-heading_label">\n\t\t\t\t\t<th scope="col" data-title="{{column.label}}" ng-repeat="column in subModuleList[activeTab].metaDataList">\n\t\t\t\t\t\t<div class="slds-truncate">{{column.label}}</div>\n\t\t\t\t\t</th>\n\t\t\t\t\t<th scope="col">\n\t\t\t\t\t\t<div class="slds-p-horizontal_x-small"></div>\n\t    \t\t\t</th>\n\t    \t\t</tr>\n\t  \t\t</thead>\n\t  \t\t<tbody>\n\t    \t\t<tr ng-repeat="record in subModuleList[activeTab].records| filter:filterList track by $index">\n\t\t\t\t\t<td ng-repeat="column in subModuleList[activeTab].metaDataList" data-label="{{record[column.name]}}" title="{{record[column.name]}}">\n\n\t\t\t\t\t\t<div ng-if="!record.editMode" data-title="{{record[column.name]}}">{{record[column.name]}}</div>\n\t\t\t\t\t\t<div ng-if="record.editMode">\n\t\t\t\t\t\t\t<div ng-if="column.name === \'Name\' && subModuleList[activeTab].name !== \'configurations\'" data-title="{{record[column.name]}}">\n\t\t\t\t\t\t\t\t{{record[column.name]}}\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === \'Name\' && subModuleList[activeTab].name === \'configurations\'">\n\t\t\t\t\t\t\t\t<input type="text" ng-required="true" ng-model="record[column.name]" ng-change="verifyDuplicate(column.name)" ng-class="{\'ng-invalid-required\':record.isDuplicate}" class="slds-input" data-title="{{record[column.name]}}">\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'IsEditable__c\'">\n\t\t\t\t\t\t\t\t<select ng-options="boolean.value as boolean.label for boolean in booleanSelectionOptions" ng-model="record[column.name]" ng-required="true" class="slds-select">\n\t\t\t\t\t\t\t\t\t<option value="" ng-disabled="true">{{labels.SelectLabel}}</option>\n\t\t\t\t\t\t\t\t</select>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'ObjectName__c\' || column.name === nsPrefix  + \'Object_Name__c\'" data-title="{{record[column.name]}}">\n\t\t\t\t\t\t\t\t<select ng-options="object.name as object.label for object in allObjectList" ng-model="record[column.name]" ng-required="true" class="slds-select" ng-change="record[nsPrefix  + \'FieldName__c\'] = \'\' ">\n\t\t\t\t\t\t\t\t\t<option value="" ng-disabled="true">{{labels.SelectLabel}}</option>\n\t\t\t\t\t\t\t\t</select>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'FieldName__c\' ">\n\t\t\t\t\t\t\t\t<div class="slds-input-has-icon slds-input-has-icon_right">\n\t\t\t\t\t\t\t\t\t<a href="javascript:void(0)" ng-class="{\'disableIcon\': !record[nsPrefix + \'ObjectName__c\'] && !record[nsPrefix + \'Object_Name__c\']}">\n\t\t\t\t\t\t\t\t\t\t<svg aria-hidden="true" class="slds-input__icon slds-icon-text-default" ng-click="openFieldSelection(record)">\n\t\t\t\t\t\t\t\t\t\t\t<use xlink:href="{{SLDSICON.EDIT}}"></use>\n\t\t\t\t\t\t\t\t\t\t</svg>\n\t\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t\t\t<input type="text" ng-required="true" ng-disabled="true" class="slds-input" ng-model="record[column.name]">\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'Sequence__c\'">\n\t\t\t\t\t\t\t\t<input type="text" ng-model="record[column.name]" ng-change="verifyDuplicate(column.name)" ng-class="{\'ng-invalid-required\':record.isDuplicate}" ng-required="true" class="slds-input" ng-pattern="/^\\d+$/"/>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'Feature__c\'" ng-init="record[column.name]=subModuleList[activeTab].feature">\n\t\t\t\t\t\t\t\t<input type="text" ng-model="record[column.name]" ng-readonly="true" ng-required="true" ng-disabled="true" class="slds-input" data-title="{{record[column.name]}}"/>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'Popup_Page_Id__c\'">\n\t\t\t\t\t\t\t\t<div class="slds-input-has-icon slds-input-has-icon_right">\n\t\t\t\t\t\t\t\t \t<a href="javascript:void(0);">\n\t\t\t\t\t\t\t\t\t\t<svg aria-hidden="true" class="slds-input__icon slds-icon-text-default" ng-click="openPageSelection(record)">\n\t\t\t\t\t\t\t\t\t\t\t<use xlink:href="{{SLDSICON.SEARCH}}"></use>\n\t\t\t\t\t\t\t\t\t\t</svg>\n\t\t\t\t\t\t\t\t\t</a>\n\t\t\t\t\t\t\t\t\t<input type="text" ng-required="true" ng-readonly="true" ng-disabled="true" class="slds-input" ng-model="record[column.name]" data-title="{{record[column.name]}}">\n\t\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'SetupValue__c\'">\n\t\t\t\t\t\t\t\t<input type="text" ng-required="true" ng-model="record[column.name]" class="slds-input" data-title="{{record[column.name]}}">\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t\t<div ng-if="column.name === nsPrefix + \'Value__c\'">\n\t\t\t\t\t\t\t\t<input type="text" ng-required="true" ng-model="record[column.name]" class="slds-input" data-title="{{record[column.name]}}">\n\t\t\t\t\t\t\t</div>\n\t\t\t\t\t\t</span>\n\t\t\t\t\t</td>\n\t\t\t\t\t<td data-label="Action" title="Action">\n\t\t\t\t\t\t<a href="javascript:void(0);" ng-class="{\'disableIcon\': record.editMode===true}">\n\t\t\t\t\t\t\t<svg aria-hidden="true" class="slds-icon slds-icon_xx-small slds-icon-text-default" ng-click="record.editMode = true">\n\t\t\t\t\t\t\t\t<use xlink:href="{{SLDSICON.EDIT}}"></use>\n\t\t\t\t\t\t\t</svg>\n\t\t\t\t\t\t</a>\n\t\t\t\t\t\t<a href="javascript:void(0);">\n\t\t\t\t\t\t  \t<svg aria-hidden="true" class="slds-icon slds-icon_xx-small slds-icon-text-default slds-m-left_x-small" ng-click="delete(record, $index)">\n\t\t\t\t\t\t    \t<use xlink:href="{{SLDSICON.DELETE}}"></use>\n\t\t\t\t\t\t  \t</svg>\n\t\t\t\t\t  \t</a>\n\t\t\t\t\t</td>\n\t    \t\t</tr>\n\t  \t\t</tbody>\n\t\t</table>\n\t\t<div class="slds-grid slds-grid_align-center slds-button-group slds-m-top_medium" role="group">\n\t\t\t<button class="slds-button slds-button_neutral" ng-click="add(subModuleList[activeTab].records)">{{labels.AddLabel}}</button>\n\t\t\t<button class="slds-button slds-button_neutral" ng-click="save()" ng-disabled="isDuplicate || moduleForm.$invalid || checkSaveMode() || isSearchBar">{{labels.SaveLabel}}</button>\n\t\t</div>\n\t</ng-form>\n</div>\n'),
$templateCache.put("PageSelectionModal.tpl.html",'<div class="page-selection slds-modal slds-fade-in-open" aria-hidden="false" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-button_icon-inverse slds-modal__close" ng-click="$hide()">\n                <svg aria-hidden="true" class="slds-button__icon slds-button__icon_large">\n                    <use xlink:href="{{SLDSICON.CLOSE}}"></use>\n                </svg>\n                <span class="slds-assistive-text">{{labels.Close}}</span>\n            </button>\n            <h2 class="slds-text-heading_medium">{{confirmationTitle}}</h2>\n        </div>\n        <div class="slds-modal__content slds-p-around_medium">\n            <div class="slds-spinner_container" ng-if="showLoading">\n                <div class="slds-spinner_brand slds-spinner slds-spinner_medium" aria-hidden="false" role="alert">\n                    <div class="slds-spinner__dot-a"></div>\n                    <div class="slds-spinner__dot-b"></div>\n                </div>\n            </div>\n            <div class="search-wrapper" ng-if="!showLoading">\n                <svg aria-hidden="true" class="slds-icon">\n                    <use xlink:href="{{SLDSICON.SEARCH}}"></use>\n                </svg>\n                <input type="search" placeholder="Search" ng-model="search"/>\n                <button class="slds-button" ng-click="searchPage(search)">{{labels.SearchLabel}}</button>\n            </div>\n            <table class="table-wrapper slds-table slds-table_bordered slds-table_cell-buffer slds-m-top_medium" ng-if="!showLoading && pageList && pageList.length !== 0">\n                <thead>\n                    <tr class="slds-text-heading_label">\n                        <th scope="col">\n                            <div class="slds-truncate">{{labels.SelectLabel}}</div>\n                        </th>\n                        <th scope="col">\n                            <div class="slds-truncate">{{labels.NameLabel}}</div>\n                        </th>\n                        <th scope="col">\n                            <div class="slds-truncate">{{labels.LabelLabel}}</div>\n                        </th>\n                        <th scope="col">\n                            <div class="slds-truncate">{{labels.ApiVersionLabel}}</div>\n                        </th>\n                    </tr>\n                </thead>\n                <tbody>\n                    <tr ng-repeat="p in pageList track by $index">\n                        <td style="width:10%;">\n                            <input type="radio" ng-model="pageWrapper.page" ng-value="p" name="vfpage">\n                        </td>\n                        <td style="width:30%;">\n                            <div class="slds-truncate">{{p.Name}}</div>\n                        </td>\n                        <td style="width:30%;">\n                            <div class="slds-truncate">{{p.MasterLabel}}</div>\n                        </td>\n                        <td style="width:30%;">\n                            <div class="slds-truncate">{{p.ApiVersion}}</div>\n                        </td>\n                    </tr>\n                </tbody>\n            </table>\n            <div class="error" ng-if="!showLoading && (!pageList || pageList.length === 0)">\n                <p>{{labels.NoPageFoundError}}</p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button_neutral" ng-click="$hide()">{{cancelActionLbl}}</button>\n            <button type="button" class="slds-button slds-button_neutral slds-button_brand" ng-click="confirmAction()" ng-disabled="!pageWrapper.page.Name || pageWrapper.page.Name === \'\' ">{{confirmActionLbl}}</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop_open"></div>\n'),$templateCache.put("PerformanceJob.tpl.html",'<div ng-controller="AdminConsoleController" ng-init="initApp(\'PerformanceJobs\', labels.CMTOptionPerformanceJobsLabel)">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="slds-theme_shade">\n\t\t<div class="job-wrapper slds-p-around_medium">\n\t\t\t<div class="job-section slds-m-top_x-small slds-has-divider_bottom">\n\t\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t\t<a href="javascript:void(0)">{{labels.XLIAPILabel}}</a>\n\t\t\t\t\t\t</div>\n\t\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.XLIAPIDesc}}</div>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t\t<button id="addOrderLineItemJobButton" type="button" ng-click="showTestResults = true; addOrderLineItemJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="row">\n\t\t\t\t\t<div id="addOrderLineItemJobStatus" class="col-md-12 col-sm-12 col-xs-12">\n\t\t\t\t\t\t<div ng-if="hasErrors" style="color : red" class="alert alert-danger" role="alert">{{errorMessage}}</div>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t\t<div ng-if="result != 0" ng-show="showTestResults">\n\t\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t\t<tr ng-class="slds-theme_success" style="background-color : #cfeef8">\n\t\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">API</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap" style="font-weight:900">Time</th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t\t<tr>\n\t\t\t\t\t  \t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t  \t\t<p>{{labels.AddXLILabel}}</p>\n\t\t\t\t\t  \t\t</td>\n\t\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t\t<p>{{result.AddOLITime}} <span ng-bind="{{result.AddOLITime}}"></span><i ng-hide="result.AddOLITime"  class="icon icon-refresh icon-spin" >...</i></p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</table>\n\t\t\t\t</div>\n\t\t\t</div>\n\n\t\t</div>\n\t</div>\n</div>\n'),$templateCache.put("PowerUpdate.tpl.html",'<div ng-controller="CustomSettingsController" ng-init="initApp(\'powerupdate\')">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="slds-p-around_small" slds-active-pane="tab.index" slds-tabs-pane-class="slds-p-top_none" slds-tabs="true">\n\t\t<div ng-repeat="subModule in subModuleList" slds-pane="true" data-title="{{subModule.label}}" ng-include="\'Module.tpl.html\'"></div>\n\t</div>\n</div>'),$templateCache.put("ProductManagementConfig.tpl.html",'<div ng-controller="CustomSettingsController" ng-init="initApp(\'prodMgmtCfg\')">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="slds-p-around_small" slds-active-pane="tab.index" slds-tabs-pane-class="slds-p-top_none" slds-tabs="true">\n\t\t<div ng-repeat="subModule in subModuleList" slds-pane="true" data-title="{{subModule.label}}" ng-include="\'Module.tpl.html\'"></div>\n\t</div>\n</div>'),$templateCache.put("ReviewCart.tpl.html",'<div ng-controller="CustomSettingsController" ng-init="initApp(\'reviewcart\')">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="slds-p-around_small" slds-active-pane="tab.index" slds-tabs-pane-class="slds-p-top_none" slds-tabs="true">\n\t\t<div ng-repeat="subModule in subModuleList" slds-pane="true" data-title="{{subModule.label}}" ng-include="\'Module.tpl.html\'"></div>\n\t</div>\n</div>'),$templateCache.put("SubHeader.tpl.html",'<div class="slds-clearfix slds-p-around_small">\n\t<span class="slds-text-heading_medium slds-float_left">{{module.label}}</span>\n\t<span class="slds-float_right">\n\t\t<button class="slds-button slds-button_neutral" ng-click="showClickedMenu(\'Dashboard\')">{{labels.BackToDashboardLabel}}</button>\n\t</span>\n</div>\n'),$templateCache.put("UpgradeJob.tpl.html",'<div ng-controller="AdminConsoleController" ng-init="initApp(\'upgradeJobs\',labels.CMTOptionUpgradeJobsLabel)">\n\t<div ng-include="\'SubHeader.tpl.html\'"></div>\n\t<div class="job-wrapper">\n\t\t<!--\n\t\t<div class="job-section slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isAttributesBindingJobCollapsed = !isAttributesBindingJobCollapsed">Attributes Binding Upgrade</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">This job will populate the bound attribute fields from the JSON to the specified object fields based on the entity class definition</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-objectName slds-p-left_medium slds-float_left">\n\t\t\t\t\t<input id="idAttributesBindingObjects" ng-required="true" ng-model="upgradeTab.attributesBindingObjects" class="slds-input" type="text" placeholder="Object name" />\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idAttributesBindingButton"type="button" ng-disabled="validateInput()" ng-click="isAttributesBindingJobCollapsed = true; startAttributesBindingJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div ng-if="attributesBindingJobsList.length != 0" ng-show="isAttributesBindingJobCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<tr>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.status}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t</tr>\n\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Holding\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_default\': job.Status == \'Preparing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_success\': job.Status == \'Completed\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_info\': job.Status == \'Aborted\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_warning\': job.Status == \'Processing\',\n\t\t\t\t\t\t\t\t\t\'slds-theme_error\': job.Status == \'Failed\'}"\n\t\t\t\t\t\tng-repeat="job in attributesBindingJobsList track by $index">\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>Attributes Binding Upgrade</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : \'short\' }}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t\t<td class="slds-cell-wrap">\n\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t</td>\n\t\t\t\t\t</tr>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t\t-->\n\t\t<div class="job-section slds-p-around_small slds-has-divider_bottom">\n\t\t\t<div class="job-content slds-clearfix">\n\t\t\t\t<div class="job-detail slds-float_left">\n\t\t\t\t\t<div class="job-label">\n\t\t\t\t\t\t<a href="javascript:void(0)" ng-click="isRootProductChildItemJobCollapsed = !isRootProductChildItemJobCollapsed">{{labels.RootPCIUpgrade}}</a>\n\t\t\t\t\t</div>\n\t\t\t\t\t<div class="job-desc slds-m-top_x-small">{{labels.RootPCIUpgradeDesc}}</div>\n\t\t\t\t</div>\n\t\t\t\t<div class="job-start slds-float_right">\n\t\t\t\t\t<button id="idRootProductChildItemButton" type="button" ng-click="isRootProductChildItemJobCollapsed = true; startRootProductChildItemJob();" class="slds-button  slds-button_brand">{{labels.StartDT}}</button>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div ng-if="rootProductChildItemJobsList.length != 0" ng-show="isRootProductChildItemJobCollapsed">\n\t\t\t\t<table class="slds-table slds-m-top_small slds-no-row-hover slds-table_fixed-layout">\n\t\t\t\t\t<thead>\n\t\t\t\t\t\t<tr>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{labels.JobName}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap"></th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.totalJobItems}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.jobItemsProcessed}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.createdDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.completedDate}}</th>\n\t\t\t\t\t\t\t<th class="slds-cell-wrap">{{asyncApexJobFieldsLabels.extendedStatus}}</th>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</thead>\n\t\t\t\t\t<tbody>\n\t\t\t\t\t\t<tr ng-class="{\t\'slds-theme_default\': job.Status == \'Queued\',\n'+"\t\t\t\t\t\t\t\t\t\t'slds-theme_default': job.Status == 'Holding',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_default': job.Status == 'Preparing',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_success': job.Status == 'Completed',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_info': job.Status == 'Aborted',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_warning': job.Status == 'Processing',\n\t\t\t\t\t\t\t\t\t\t'slds-theme_error': job.Status == 'Failed'}\"\n\t\t\t\t\t\t\tng-repeat=\"job in rootProductChildItemJobsList track by $index\">\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{labels.RootPCIUpgrade}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.Status}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.TotalJobItems}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.JobItemsProcessed}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{ job.CreatedDate | date : 'short' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{ job.CompletedDate | date : 'short' }}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t\t<td class=\"slds-cell-wrap\">\n\t\t\t\t\t\t\t\t<p>{{job.ExtendedStatus}}</p>\n\t\t\t\t\t\t\t</td>\n\t\t\t\t\t\t</tr>\n\t\t\t\t\t</tbody>\n\t\t\t\t</table>\n\t\t\t</div>\n\t\t</div>\n\t</div>\n</div>\n"),$templateCache.put("fieldLookup.html",'<div class="slds-grid slds-grid_pull-padded">\n\t\t<div class="fieldsContainer-{{$index}} slds-size_1-of-2"  ng-repeat="fieldSet in fieldSets track by $index" ng-init="outerIndex = $index">\n\t\t\t<select class="slds-select" size="10" ng-change="populateNextTable($index, selectedFields[$index])" data-ng-options="field as field.label+\'<\'+field.name+\'>\' for field in fieldSet | orderBy:\'label\'" data-ng-model="selectedFields[$index]">\n\t\t\t\t<option value="" ng-if="false"></option>\n\t\t\t</select>\t\t\t\t\t\t\t\n\t\t</div>\n</div>')}]);
},{}]},{},[1]);

})();