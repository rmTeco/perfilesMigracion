(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';
var app = angular.module('ObjectMapper', ['vlocity', 'sldsangular','epcadmin', 'ngSanitize', 'ngAnimate']);
app.config(['remoteActionsProvider', function(remoteActionsProvider) {
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}]);

require('./modules/ObjectMapper/controller/ObjectMapperController.js');
require('./modules/ObjectMapper/factory/ObjectMapperService.js');
require('./modules/ObjectMapper/templates/templates.js');
},{"./modules/ObjectMapper/controller/ObjectMapperController.js":2,"./modules/ObjectMapper/factory/ObjectMapperService.js":3,"./modules/ObjectMapper/templates/templates.js":4}],2:[function(require,module,exports){
'use strict';
var app = angular.module('ObjectMapper');
app.controller('ObjectMapperController', ['$scope', '$sldsModal', 'ObjectMapperService', 'remoteActions', '$window',
	function (scope, modal, service, remoteActions, window) {
		scope.SLDSICON = window.SLDSICON;
		scope.labels = window.labels;
		scope.nsPrefix = window.configData.nsPrefix;
		scope.configurations = [];
		scope.selectedConfigurationIndex = 0;
		scope.showSpinner = false;
		scope.allObjectList = [];
		scope.objectMapper = {};
		scope.childObjectMapperList = [];

		scope.initApp = function() {
			scope.getObjectList();
			//add a empty box.
			scope.add();
		};
		scope.add = function() {
			var childObject = {};
			scope.childObjectMapperList.push(childObject);
		};
		scope.deleteChildObject = function(index) {
			var objectMapperId = scope.childObjectMapperList[index].Id;
			var modalScope = scope.$new();
            modalScope.confirmationTitle = 'Delete Object Mapper';
            modalScope.confirmationMsg = 'Are you sure want to delete this mapping?';
            modalScope.cancelActionLbl = 'Cancel';
            modalScope.confirmActionLbl = 'Delete';
            modalScope.SLDSICON = scope.SLDSICON;
            modalScope.confirmAction = function() {
            	deleteModal.hide();
                if(objectMapperId) {
                    scope.showSpinner = true;
					remoteActions.deleteObjectMapper(objectMapperId).then(function(results){
						scope.showSpinner = false;
						scope.childObjectMapperList.splice(index, 1);
	                }, function(error) {
	                	scope.showSpinner = false;
	                    service.openAlertWindow(scope, scope.labels.errorHeading, error);
	                });
				} else {
					scope.childObjectMapperList.splice(index, 1);
				}
            };
			var deleteModal = modal({
                templateUrl: 'ConfirmationModal.tpl.html',
                backdrop: 'static',
                scope: modalScope,
                show: true
			});
		};
		scope.save = function() {
			scope.showSpinner = true;
			var objectMapperList = scope.processBeforeSave();
			remoteActions.save(objectMapperList).then(function(results) {
				if(results.hasError) {
					service.openAlertWindow(scope, scope.labels.errorHeading, results.errorMessage);
				}
				scope.getObjectMapper(scope.objectMapper.sourceParentObject, scope.objectMapper.destinationParentObject);
				scope.showSpinner = false;
			}, function(error) {
				service.openAlertWindow(scope, scope.labels.errorHeading, error);
				scope.showSpinner = false;
			});
		};
		scope.processBeforeSave = function() {
			var objectMapperList = [];
			for(var i=0; i<scope.childObjectMapperList.length ;i++) {
				var objectMapper = {};
				var childObject = scope.childObjectMapperList[i];
				objectMapper[scope.nsPrefix + 'SourceParentObject__c'] = scope.objectMapper.sourceParentObject;
				objectMapper[scope.nsPrefix + 'DestinationParentObject__c'] = scope.objectMapper.destinationParentObject;
				objectMapper[scope.nsPrefix + 'SourceChildObject__c'] = childObject.sourceChildObject;
				objectMapper[scope.nsPrefix + 'DestinationChildObject__c'] = childObject.destinationChildObject;
				objectMapper[scope.nsPrefix + 'ParentSourceReferenceField__c'] = childObject.parentSourceReferenceField;
				objectMapper[scope.nsPrefix + 'ParentDestinationReferenceField__c'] = childObject.parentDestinationReferenceField;
				objectMapper.Name = scope.objectMapper.sourceParentObject + '>'+ scope.objectMapper.destinationParentObject + (i+1);
				objectMapper.Id = childObject.Id;
				objectMapperList.push(objectMapper);
			}
			return objectMapperList;
		};
		scope.processBeforeDisplay = function(objectMapperList) {
			var chlidMapperList = [];
			for(var i=0; i<objectMapperList.length ;i++) {
				var objectMapper = objectMapperList[i];
				var childObject = {};
				childObject.Id = objectMapper.Id;
				childObject.sourceChildObject = objectMapper[scope.nsPrefix + 'SourceChildObject__c'];
				childObject.destinationChildObject = objectMapper[scope.nsPrefix + 'DestinationChildObject__c'];
				childObject.parentSourceReferenceField = objectMapper[scope.nsPrefix + 'ParentSourceReferenceField__c'];
				childObject.parentDestinationReferenceField = objectMapper[scope.nsPrefix + 'ParentDestinationReferenceField__c'];
				chlidMapperList.push(childObject);
				//get fields details
				scope.getFieldsDetails(childObject.sourceChildObject, childObject, true);
				scope.getFieldsDetails(childObject.destinationChildObject, childObject, false);
			}
			if(chlidMapperList.length === 0) {
				var c = {};
				chlidMapperList.push(c);
			}
			scope.childObjectMapperList = chlidMapperList;
		};
		scope.changeDestinationParent = function(desParentObject) {
			scope.getRelatedObjects(desParentObject, false);
			var sourceParentObject = scope.objectMapper.sourceParentObject;
			if(scope.isParentObjectSeleted(sourceParentObject, desParentObject)) {
				scope.getObjectMapper(sourceParentObject, desParentObject);
			}
		};
		scope.changeSourceParent = function(sourceParentObject) {
			scope.getRelatedObjects(sourceParentObject, true);
			var desParentObject = scope.objectMapper.destinationParentObject;
			if(scope.isParentObjectSeleted(sourceParentObject, desParentObject)) {
				scope.getObjectMapper(sourceParentObject, desParentObject);
			}
		};
		scope.changeSourceChild = function(childObject, selectedObject) {
			scope.getFieldsDetails(selectedObject, childObject, true);
		};
		scope.changeDestinationChild = function(childObject, selectedObject) {
			scope.getFieldsDetails(selectedObject, childObject, false);
		};
		scope.isParentObjectSeleted = function(sourceParentObject, desParentObject) {
			if(sourceParentObject && sourceParentObject !== '' && desParentObject && desParentObject !== '') {
				return true;
			}
			return false;
		};
		scope.getObjectMapper = function(sourceParentObject, desParentObject) {
			scope.showSpinner = true;
			remoteActions.getObjectMapper(sourceParentObject, desParentObject).then(function(results) {
				if(results.hasError) {
					service.openAlertWindow(scope, scope.labels.errorHeading, results.errorMessage);
				} else {
					scope.processBeforeDisplay(results.result);
				}
				scope.showSpinner = false;
			}, function(error) {
				scope.showSpinner = false;
				service.openAlertWindow(scope, scope.labels.errorHeading, error);
			});
		};
		scope.getObjectList = function() {
			scope.showSpinner = true;
			var parameters = {};
            parameters.methodName =  "getGlobalDescribe";   
            var remoteOptions ={};
            remoteOptions.apexType =  window.configData.adminClassType;
            remoteOptions.parameters =  JSON.stringify(parameters);
			remoteActions.adminInvokeMethod(remoteOptions).then(function(result) {
				scope.allObjectList = JSON.parse(result.objectsDescribeListJSON.toString().replace('\n', ''));
				scope.showSpinner = false;
			}, function(err) {
				scope.showSpinner = false;
				service.openAlertWindow(scope, scope.labels.errorHeading, err);
			});
		};
		scope.getRelatedObjects = function(objectName, isSource) {
			scope.showSpinner = true;
			remoteActions.getRelatedObjects(objectName).then(function(results) {
				if(results.hasError) {
					service.openAlertWindow(scope, scope.labels.errorHeading, results.errorMessage);
				} else {
					if(isSource) {
						scope.objectMapper.sourceRelatedObjectList = JSON.parse(results.result[0].toString().replace('\n', ''));
					} else {
						scope.objectMapper.destinationRelatedObjectList = JSON.parse(results.result[0].toString().replace('\n', ''));
					}
				}
				scope.showSpinner = false;
			}, function(error) {
				service.openAlertWindow(scope, scope.labels.errorHeading, error);
				scope.showSpinner = false;
			});
		};
		scope.getFieldsDetails = function(objectName, childObject, isSource) {
			scope.showSpinner = true;
			var parameters = {};
        	parameters.methodName =  'getObjectFieldsDescribe';
        	parameters.objectNames = [objectName];
            var remoteOptions ={};
            remoteOptions.apexType =  window.configData.adminClassType;
        	remoteOptions.parameters =  JSON.stringify(parameters);
        	remoteActions.adminInvokeMethod(remoteOptions).then(function(result) {
        		if(isSource) {
        			childObject.sourceFieldList = result.objectNameToFieldDescribes[objectName];
        		} else {
        			childObject.destinationFieldList = result.objectNameToFieldDescribes[objectName];
        		}
				scope.showSpinner = false;
			}, function(err) {
				scope.showSpinner = false;
				service.openAlertWindow(scope, scope.labels.errorHeading, err);
			});
		};
	}
]);

},{}],3:[function(require,module,exports){
'use strict';
var app = angular.module('ObjectMapper');
app.service('ObjectMapperService',['$sldsModal', function ObjectMapperService(modal) {
	
    ObjectMapperService.prototype.openAlertWindow = function (scope, title, message) {
		var modalScope = scope.$new();
            modalScope.confirmationTitle = title;
            modalScope.errorMessage = message;
            modalScope.cancelActionLbl = 'OK';
        var deleteModal = modal({
            templateUrl: 'ErrorModal.tpl.html',
            backdrop: 'static',
            scope: modalScope,
            show: true
		});
	};
}]);
},{}],4:[function(require,module,exports){
angular.module("ObjectMapper").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("ChildObject.tpl.html",'<div class="slds-box slds-m-around--large slds-theme--default">\n\t<div class="slds-grid slds-p-around--large">\n\t\t<div class="slds-size--5-of-12 slds-col--padded-large">\n\t\t\t<div class="slds-form-element slds-m-bottom--medium">\n\t\t\t\t<label class="slds-form-element__label" for="select-03">Source Object</label>\n\t\t\t\t<div class="slds-form-element__control">\n\t\t\t\t\t<div class="slds-select_container">\n\t\t\t\t\t\t<select id="select-03" class="slds-select" ng-model="childObjectMapper.sourceChildObject" ng-options="object.name as object.label for object in objectMapper.sourceRelatedObjectList" ng-change="changeSourceChild(childObjectMapper, childObjectMapper.sourceChildObject)" ng-required="true">\n\t\t\t\t\t\t\t<option value="" ng-disabled="true">Select</option>\n\t\t\t\t\t\t</select>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="slds-form-element">\n\t\t\t\t<label class="slds-form-element__label" for="select-05">Parent source reference field</label>\n\t\t\t\t<div class="slds-form-element__control">\n\t\t\t\t\t<div class="slds-select_container">\n\t\t\t\t\t\t<select id="select-05" class="slds-select" ng-model="childObjectMapper.parentSourceReferenceField" ng-options="field.name as field.label+\'<\'+field.name+\'>\' for field in childObjectMapper.sourceFieldList | orderBy:\'label\' " ng-required="true">\n\t\t\t\t\t\t\t<option value="" ng-disabled="true">Select</option>\n\t\t\t\t\t\t</select>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="slds-size--5-of-12 slds-col--padded-large">\n\t\t\t<div class="slds-form-element slds-m-bottom--medium">\n\t\t\t\t<label class="slds-form-element__label" for="select-04">Destination Object</label>\n\t\t\t\t<div class="slds-form-element__control">\n\t\t\t\t\t<div class="slds-select_container">\n\t\t\t\t\t\t<select id="select-04" class="slds-select" ng-model="childObjectMapper.destinationChildObject" ng-options="object.name as object.label for object in objectMapper.destinationRelatedObjectList" ng-change="changeDestinationChild(childObjectMapper, childObjectMapper.destinationChildObject)" ng-required="true">\n\t\t\t\t\t\t\t<option value="" ng-disabled="true">Select</option>\n\t\t\t\t\t\t</select>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t\t<div class="slds-form-element">\n\t\t\t\t<label class="slds-form-element__label" for="select-06">Parent destination reference field</label>\n\t\t\t\t<div class="slds-form-element__control">\n\t\t\t\t\t<div class="slds-select_container">\n\t\t\t\t\t\t<select id="select-06" class="slds-select" ng-model="childObjectMapper.parentDestinationReferenceField" ng-options="field.name as field.label+\'<\'+field.name+\'>\' for field in childObjectMapper.destinationFieldList | orderBy:\'label\' " ng-required="true">\n\t\t\t\t\t\t\t<option value="" ng-disabled="true">Select</option>\n\t\t\t\t\t\t</select>\n\t\t\t\t\t</div>\n\t\t\t\t</div>\n\t\t\t</div>\n\t\t</div>\n\t\t<div class="slds-size--1-of-12 slds-col--padded-large">\n\t\t\t<svg aria-hidden="true" class="slds-icon  slds-icon--x-small slds-icon-text-default" ng-click="deleteChildObject($index)"> \n\t\t\t\t<use xlink:href="{{SLDSICON.DELETE}}"></use> \n\t\t\t</svg> \n\t\t</div>\n\t</div>\n</div>'),$templateCache.put("ErrorModal.tpl.html",'<div>\n    <div aria-hidden="false" aria-labelledby="prompt-heading-id" aria-describedby="prompt-message-wrapper" role="alertdialog" class="slds-modal slds-modal--prompt slds-fade-in-open">\n        <div class="slds-modal__container slds-modal--prompt" role="document" id="prompt-message-wrapper" tabindex="0">\n            <div class="slds-modal__header slds-theme--error slds-theme--alert-texture">\n                <h2 class="slds-text-heading--medium" id="prompt-heading-id">{{confirmationTitle}}</h2>\n            </div>\n            <div class="slds-modal__content slds-p-around--medium">\n                <div>\n                    <p>{{errorMessage}}</p>\n                </div>\n            </div>\n            <div class="slds-modal__footer slds-theme--default">\n                <button class="slds-button slds-button--neutral" ng-click="$hide()">{{cancelActionLbl}}</button>\n            </div>\n        </div>\n    </div>\n    <div class="slds-backdrop slds-backdrop--open"></div>\n</div>'),$templateCache.put("ConfirmationModal.tp.html",'<div class="slds-modal slds-fade-in-open" aria-hidden="false" role="dialog"> \n    <div class="slds-modal__container"> \n        <div class="slds-modal__header"> \n            <button class="slds-button slds-button--icon-inverse slds-modal__close" ng-click="$hide()"> \n                <svg aria-hidden="true" class="slds-button__icon slds-button__icon--large"> \n                    <use xlink:href="{{SLDSICON.CLOSE}}"></use> \n                </svg> \n                <span class="slds-assistive-text">Close</span> \n            </button> \n            <h2 class="slds-text-heading--medium">{{confirmationTitle}}</h2> \n        </div> \n        <div class="slds-modal__content slds-p-around--medium"> \n            <div> \n                <p ng-bind-html="confirmationMsg"></p> \n            </div> \n        </div> \n        <div class="slds-modal__footer"> \n            <button type="button" class="slds-button slds-button--neutral" ng-click="$hide()">{{cancelActionLbl}}</button> \n            <button type="button" class="slds-button slds-button--neutral slds-button--brand" ng-click="confirmAction()">{{confirmActionLbl}}</button> \n        </div> \n    </div> \n</div> \n<div class="slds-backdrop slds-backdrop--open"></div>')}]);
},{}]},{},[1]);

})();