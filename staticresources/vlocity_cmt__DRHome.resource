(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('drhome', ['sldsangular', 'drvcomp', 'ngTable', 'vlocity', 'infinite-scroll'])
	.config(['$localizableProvider', function($localizableProvider) {
      'use strict';
      $localizableProvider.setLocalizedMap(window.i18n);
      $localizableProvider.setDebugMode(window.ns === '');
  	}]);

require('./modules/drhome/config/config.js');

require('./modules/drhome/controller/DRHome.js');

},{"./modules/drhome/config/config.js":2,"./modules/drhome/controller/DRHome.js":3}],2:[function(require,module,exports){
angular.module('drhome')
    .config(['remoteActionsProvider', 'fileNsPrefixDot', function(remoteActionsProvider, fileNsPrefixDot) {
        'use strict';
        var remoteActions = {
            getAllBundles: {
                action: fileNsPrefixDot() + 'DRHomeController.getAllBundles',
                config: {escape: false}
            },
            deleteBundle: {
                action: fileNsPrefixDot() + 'DRHomeController.deleteBundle'
            }
        };
        remoteActionsProvider.setRemoteActions(remoteActions);
    }]);

},{}],3:[function(require,module,exports){
angular.module('drhome')
    .controller('drhome', ['$drvExport', '$sldsPrompt', '$scope', 'remoteActions', '$filter', '$localizable',
                                function($drvExport, $sldsPrompt, $scope, remoteActions, $filter, $localizable) {
        'use strict';

        $scope.defaultColumns = [{
            field: 'Name',
            resizable: true
        }, {
            field: fileNsPrefix() + 'Type__c',
            resizable: true,
            width: 180,
            additionalFields: [fileNsPrefix() + 'InputType__c', fileNsPrefix() + 'OutputType__c'],
            sortable: fileNsPrefix() + 'Type__c, ' + fileNsPrefix() + 'InputType__c, ' + fileNsPrefix() + 'OutputType__c',
            getValue: function($scope, row) {
                var output = row[fileNsPrefix() + 'Type__c'];
                if (!/\(/.test(output)) {
                    if (row[fileNsPrefix() + 'InputType__c'] && row[fileNsPrefix() + 'OutputType__c']) {
                        output += ' (' + row[fileNsPrefix() + 'InputType__c'] + ' → ' + row[fileNsPrefix() + 'OutputType__c'] + ')';
                    } else if (row[fileNsPrefix() + 'OutputType__c']) {
                        output += ' (' + row[fileNsPrefix() + 'OutputType__c'] + ')';
                    }
                }
                return output;
            }
        }, {
            field: fileNsPrefix() + 'Description__c',
            getValue: function($scope, row) {
                if (!row[fileNsPrefix() + 'Description__c']) {
                    return '';
                }
                return '<span title="' + row[fileNsPrefix() + 'Description__c'] + '">' +
                                row[fileNsPrefix() + 'Description__c'] + '</span>';
            },
            resizable: true
        }, {
            resizable: true,
            width: 140,
            field: 'LastModifiedDate',
            getGroupValue: function($scope, $group) {
                return $filter('date')($group.data[0].LastModifiedDate, 'short');
            },
            getValue: function($scope, row) {
                return $filter('date')(row.LastModifiedDate, 'short');
            }
        }, {
            resizable: true,
            width: 140,
            field: 'LastModifiedById',
            getGroupValue: function($scope, $group) {
                return $group.data[0].LastModifiedBy ? $group.data[0].LastModifiedBy.Name : '';
            },
            getValue: function($scope, row) {
                return row.LastModifiedBy ? row.LastModifiedBy.Name : '';
            }
        }];

        $localizable('DeleteDataRaptor', 'Delete DataRaptor')
            .then(function(label) {
                $scope.rowActions = [{
                    type: 'export',
                    drvType: 'DataRaptor'
                }, {
                    type: 'delete',
                    promptTitle: label,
                    promptContent: function(row, group) {
                        return $localizable('DeleteDataraptorConfirmation2', 'Are you sure you want to delete this DataRaptor interface?<br/> <br/> {1}', row.Name);
                    },
                    deleteAction: function(row, group) {
                        return remoteActions.deleteBundle(row.Id);
                    }
                }];
            });

        $scope.extraFilters = [{
            name: {
                Name: fileNsPrefix() + 'Type__c'
            },
            operator: '!=',
            value: 'Migration'
        }, {
            name: {
                Name: fileNsPrefix() + 'Type__c'
            },
            operator: '!=',
            value: 'Export (Component)'
        }];

    }]);
},{}]},{},[1]);

})();