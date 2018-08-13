(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var documentClauseApp = angular.module('documentClauseApp', ['vlocity', 'mgcrea.ngStrap',
    'ngSanitize', 'viaDirectives', 'ngAnimate', 'ngTagsInput', 'angularUtils.directives.dirPagination', 'sldsangular'
]).config(['remoteActionsProvider', function(remoteActionsProvider) {
    'use strict';
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}]);

// Services
require('./modules/documentClauseApp/services/BrowserDetection.js');

// Controllers
require('./modules/documentClauseApp/controller/DocumentClauseController.js');

// Directives
require('./modules/documentClauseApp/directive/HighlightTokens.js');
require('./modules/documentClauseApp/directive/VlcLoader.js');

// Templates
require('./modules/documentClauseApp/templates/templates.js');

},{"./modules/documentClauseApp/controller/DocumentClauseController.js":2,"./modules/documentClauseApp/directive/HighlightTokens.js":3,"./modules/documentClauseApp/directive/VlcLoader.js":4,"./modules/documentClauseApp/services/BrowserDetection.js":5,"./modules/documentClauseApp/templates/templates.js":6}],2:[function(require,module,exports){
//Controller for Data Raptor Mapping
angular.module('documentClauseApp').controller('documentClauseCtrl', function($scope, remoteActions, browserDetection, $filter, $q, $sldsModal, $timeout) {
    'use strict';
    $scope.clauses = [];
    $scope.update = true;
    $scope.productsForClause = [];
    $scope.conditionalClauseProducts = [];
    $scope.nameSpacePrefix = window.nameSpacePrefix;
    $scope.initialCategoryOption = 'Select a Category';
    $scope.clauseCategories = [$scope.initialCategoryOption];
    $scope.productList = [];
    $scope.selectedProducts = [];
    $scope.selectedContractTypes = [];
    $scope.contractList = [];
    $scope.clauseData = {
        'clauseTokens': ''
    };
    $scope.typeOnClick = '';
    $scope.tempClauseData = {};
    $scope.clauseOnClick = {};
    $scope.finalClauseData = [];
    $scope.validationErrors = {};
    $scope.validationMessage = '';
    $scope.clauseScopeKeywords = {
        'editNew': 'New',
        'saveUpdate': 'Save'
    };
    $scope.productUrl = [];
    $scope.browser = browserDetection.detectBrowser();
    $scope.isSafari = ($scope.browser === 'safari') ? true : false;
    $scope.isInternetExplorer = ($scope.browser === 'msielte10' || $scope.browser === 'msiegt10') ? true : false;
    $scope.browserVersion = browserDetection.getBrowserVersion();
    console.log('Browser: ', $scope.browser);
    console.log('Browser Version: ', $scope.browserVersion);
    $scope.defaultContractType = '';
    $scope.filter = {
        'showArchived': false
    };
    if (window.modalLabels !== undefined) {
        $scope.modalLabels = window.modalLabels;
    }
    $scope.labels = {};

    $scope.getClauses = function() {
        remoteActions.getClauses().then(function(result) {
            console.log('Clauses:', result);
            $scope.labels = result.labels;
            $scope.active = result.clauses;
            $scope.archived = result.archived;
            if ($scope.filter.showArchived) {
                $scope.clauses = $scope.active;
                $scope.clauses = $scope.clauses.concat($scope.archived);
            } else {
                $scope.clauses = $scope.active;
            }
            $timeout(function() {
                angular.element(document).find('.vlocity').removeClass('preload');
            }, 500);
        });
    };
    $scope.getClauses();

    $scope.getDefaultContractType = function() {
        remoteActions.getDefaultContractType().then(function(result) {
            $scope.defaultContractType = result;
        });
    };
    $scope.getDefaultContractType();

    $scope.getContractTypeList = function() {
        remoteActions.getContractTypeList().then(function(result) {
            for (var i = 0; i < result.length; i++) {
                if (result[i].Name !== $scope.defaultContractType) {
                    var type = {'text': result[i].Name, 'id': result[i].Id};
                    $scope.contractList.push(type);
                }
            }
        });
    };
    $scope.getContractTypeList();

    $scope.switchToDefault = function() {
        $scope.clauseData.isDefault = true;
        $scope.clauseData.clauseContractTypes = $scope.defaultContractType;
        $scope.selectedContractTypes = [];
    };

    $scope.switchToCustom = function() {
        $scope.clauseData.isDefault = false;
        $scope.clauseData.clauseContractTypes = '';
        $scope.selectedContractTypes = [];
    };

    $scope.getCategories = function() {
        var i;
        remoteActions.getCategories().then(function(result) {
            for (i = 0; i < result.length; i++) {
                $scope.clauseCategories.push(result[i].Label);
            }
            // console.log("Categories: ");
            // console.log($scope.clauseCategories);
        });
    };
    $scope.getCategories();

    $scope.saveClause = function(update, checkArchive, archive) {
        var validationMessage, i;
        $scope.clauseData.clauseName = $scope.clauseData.clauseName.replace(/\s\s+/g, ' ');
        $scope.validateClause(update);
        if ($scope.validationErrors.clauseValid) {
            $scope.getTokens($scope.clauseData.clauseContent);
            if ($scope.selectedContractTypes.length > 0) {
                $scope.getSelectedContractTypes();
            }
            if (!$scope.clauseData.clauseRestricted) {
                $scope.clauseData.clauseRestricted = false;
            }
            $scope.finalClauseData.push($scope.clauseData);
            if (checkArchive) {
                $sldsModal({
                    templateUrl: 'check-archive-clause.tpl.html',
                    title: 'Warning',
                    container: 'div.vlocity',
                    placement: 'center',
                    html: true,
                    scope: $scope
                });
            } else if (update) {
                validationMessage = $scope.modalLabels.CLMClauseSavedSuccess;
                if (archive) {
                    validationMessage = $scope.modalLabels.CLMClauseSavedSuccess;
                    $scope.finalClauseData[0].clauseArchived = true;
                }
                $scope.vlcLoading = true;
                remoteActions.updateClause(JSON.stringify($scope.finalClauseData)).then(function() {
                    $scope.validationMessage = validationMessage;
                    console.log('Saving ', $scope.finalClauseData);
                    if (archive) {
                        //$scope.getClauses();
                        for (i = 0; i < $scope.clauses.length; i++) {
                            if ($scope.finalClauseData[0].clauseId === $scope.clauses[i].Id) {
                                $scope.clauses[i][$scope.nameSpacePrefix + ['IsArchived__c']] = true;
                            }
                        }
                    }
                    $scope.getClauses();
                    $scope.vlcLoading = false;
                    $scope.finalClauseData = [];
                });
            } else {
                $scope.vlcLoading = true;
                remoteActions.saveClause(JSON.stringify($scope.finalClauseData)).then(function(result) {
                    $scope.validationMessage = $scope.modalLabels.CLMClauseSavedSuccess;
                    $scope.clauseScopeKeywords.editNew = 'Editing';
                    $scope.clauseScopeKeywords.saveUpdate = 'Update';
                    $scope.getClauses();
                    $scope.tempClauseData = $scope.clauseData;
                    $scope.tempClauseData.clauseId = result;
                    $scope.clauseData.clauseId = result;
                    $scope.vlcLoading = false;
                    $scope.finalClauseData = [];
                });
            }
        }
    };

    $scope.searchContractTypeList = function(query) {
        var contractTypeList = $scope.contractTypeListWrapper(query);
        return contractTypeList;
    };

    $scope.contractTypeListWrapper = function(query) {
        var deferred = $q.defer();
        var callbackfunction = function(result) {
            $scope.$apply(function() {
                var sresult = [];
                if (result) {
                    sresult = angular.fromJson(result);
                }
                deferred.resolve(sresult);
            });
        };
        $scope.searchContractListCallback(query,callbackfunction);
        return deferred.promise;
    };

    $scope.searchContractListCallback = function(query, callback) {
        var data;
        var filter = {};
        var contractList = $scope.contractList;
        query = query.trim();
        if (query !== '') {
            filter.text = query;
            data = $filter('filter')(contractList, filter);
            callback(data);
        }else {
            callback(contractList);
        }
    };

    $scope.addContractType = function($tag) {
        var i;
        var inArray = false;
        for (i = 0; i < $scope.selectedContractTypes.length; i++) {
            if ($scope.selectedContractTypes[i].id === $tag.id) {
                inArray = true;
            }
        }
        if (!inArray) {
            $scope.selectedContractTypes.push($tag);
        }
    };

    $scope.removeContractType = function($tag) {
        var i;
        for (i = 0; i < $scope.selectedContractTypes.length; i++) {
            if ($scope.selectedContractTypes[i].id === $tag.id) {
                $scope.selectedContractTypes.splice(i,1);
            }
        }
    };

    $scope.createNewClause = function(type) {
        // if content has changed:
        $scope.hasChanged(undefined, type);
    };

    $scope.createNewClauseHelper = function(type) {
        $scope.validationErrors.clauseValid = true;
        $scope.validationErrors.clauseName = '';
        $scope.validationErrors.clauseCategory = '';
        $scope.validationErrors.clauseContent = '';
        $scope.validationMessage = '';

        // Reset Clause Data & finalClauseData objects
        $scope.clauseData = {
            'clauseTokens': ''
        };
        $scope.selectedProducts = [];
        $scope.finalClauseData = [];

        $scope.clauseScopeKeywords.editNew = 'New';
        $scope.clauseScopeKeywords.saveUpdate = 'Save';
        $scope.clauseData.clauseCategory = $scope.clauseCategories[0];
        $scope.clauseData.clauseType = type;
        $scope.clauseData.clauseContractTypes = $scope.defaultContractType;
        $scope.clauseData.isDefault = true;
        $scope.selectedContractTypes = [];
    };

    $scope.getTokens = function(clauseContent) {
        var tokens, i, token;
        if (clauseContent) {
            tokens = clauseContent.match(/%%(.*?)%%/g);
            if (tokens !== null) {
                for (i = 0; i < tokens.length; i++) {
                    token = tokens[i];
                    $scope.clauseData.clauseTokens = $scope.clauseData.clauseTokens + ', ' + token;
                }
            }
            if ($scope.clauseData.clauseTokens) {
                $scope.clauseData.clauseTokens = $scope.clauseData.clauseTokens.substr(2);
            }
        }
    };

    $scope.getSelectedContractTypes = function() {
        var str = '';
        for (var i = 0; i < $scope.selectedContractTypes.length; i++) {
            str += $scope.selectedContractTypes[i].text + ';';
        }
        str = str.substring(0, str.length - 1);
        $scope.clauseData.clauseContractTypes = str;
    };
    $scope.throwWarningModal = function() {
        console.log('Is update ' + $scope.update);
        $sldsModal({
            templateUrl: 'check-save-clause.tpl.html',
            title: 'Warning',
            container: 'div.vlocity',
            placement: 'center',
            scope: $scope
        });
        return true;
    };

    $scope.hasChanged = function(clause, type) {
        //Assume no warning
        var throwWarning = false;
        $scope.clauseOnClick = clause;
        $scope.typeOnClick = type;
        //New content in empty clause template
        if ($scope.clauseData.clauseId === undefined && $scope.clauseData.clauseCategory !== undefined && $scope.tempClauseData.clauseName === undefined && $scope.tempClauseData.Name === undefined) {
            //Set update to false for modal
            $scope.update = false;
            if ($scope.clauseData.clauseCategory !== 'Select a Category' || $scope.clauseData.clauseName !== undefined ||
                $scope.clauseData.clauseRestricted !== undefined || $scope.clauseData.clauseContent !== undefined) {
                throwWarning = $scope.throwWarningModal();
                $scope.populateClauseDataHelper($scope.clauseData);
            }
            if ($scope.clauseData.clauseType === 'Conditional' && !throwWarning && $scope.selectedProducts.length > 0) {
                throwWarning = $scope.throwWarningModal();
                $scope.populateClauseDataHelper($scope.clauseData);
            }
        }

        //Changed content in existing clause
        if ($scope.tempClauseData.Id === $scope.clauseData.clauseId && $scope.clauseData.clauseId !== undefined) {
            //Set update to true for modal
            $scope.update = true;
            if ($scope.tempClauseData[$scope.nameSpacePrefix + 'Category__c'] !==  $scope.clauseData.clauseCategory ||
            $scope.tempClauseData[$scope.nameSpacePrefix + 'ClauseContent__c'] !==  $scope.clauseData.clauseContent ||
            $scope.tempClauseData[$scope.nameSpacePrefix + 'IsRestricted__c'] !== $scope.clauseData.clauseRestricted ||
            $scope.tempClauseData.Name !== $scope.clauseData.clauseName)  {
                throwWarning = $scope.throwWarningModal();
                $scope.populateClauseDataHelper($scope.clauseData);
            }

        }

        //No warning has been thrown, load clause
        if (!throwWarning) {
            $scope.loadClauseOnClick(clause, type);
        }
    };

    //Populate Clause Data or Create A New Clause
    $scope.loadClauseOnClick = function(clause, type) {
        if (clause !== undefined) {
            $scope.populateClauseDataHelper(clause);
        } else {
            $scope.createNewClauseHelper(type);
            $scope.tempClauseData = {};
        }
    };

    // When clicking on an existing clause to edit:
    $scope.populateClauseData = function(clause) {
        //If change:
        $scope.hasChanged(clause, null);
        //Assign to temporary clause for click away warning
        $scope.tempClauseData = clause;
        // $scope.getClauses();
    };

    $scope.checkDeleteClause = function() {
        $sldsModal({
            templateUrl: 'check-delete-clause.tpl.html',
            title: 'Delete Clause',
            container: 'div.vlocity',
            placement: 'center',
            html: true,
            scope: $scope
        });
    };

    $scope.deleteClause = function() {
        $scope.vlcLoading = true;
        remoteActions.deleteClause($scope.clauseData.clauseId).then(function(result) {
            if (result) {
                $scope.getClauses();
                $scope.createNewClause('Generic');
                $scope.validationMessage = $scope.modalLabels.CLMClause + ' ' + $scope.modalLabels.CLMTemplateHasBeenDeleted;
            } else {
                $sldsModal({
                    templateUrl: 'warning-active-clause.tpl.html',
                    title: 'Active Clause',
                    container: 'div.vlocity',
                    placement: 'center',
                    html: true,
                    scope: $scope
                });
            }
            $scope.vlcLoading = false;
        });
    };

    $scope.closeSuccessBanner = function() {
        $scope.validationMessage = '';
    };

    $scope.populateClauseDataHelper = function(clause) {
        if (clause.Id) {
            // Reset Validation errors on click of an existing clause:
            $scope.validationErrors.clauseValid = true;
            $scope.validationErrors.clauseName = '';
            $scope.validationErrors.clauseCategory = '';
            $scope.validationErrors.clauseContent = '';
            $scope.validationMessage = '';

            // If clause is conditional, need to get list of products attached to it:
            if (clause[$scope.nameSpacePrefix + 'Type__c'] === 'Conditional') {
                $scope.getProductsForClause(JSON.stringify(clause.Id)); // Assigned to $scope.productsForClause
            }
            if (clause[$scope.nameSpacePrefix + 'IsArchived__c']) {
                $scope.clauseScopeKeywords.editNew = 'Archived';
            } else {
                $scope.clauseScopeKeywords.editNew = 'Editing';
            }
            $scope.clauseScopeKeywords.saveUpdate = 'Update';
            $scope.clauseData.clauseId = clause.Id;
            $scope.clauseData.clauseName = clause.Name;
            $scope.currentlyEditingName = $scope.clauseData.clauseName; // Need to store this for validation purposes
            $scope.clauseData.clauseType = clause[$scope.nameSpacePrefix + 'Type__c'];
            $scope.clauseData.clauseRestricted = clause[$scope.nameSpacePrefix + 'IsRestricted__c'];
            $scope.clauseData.clauseArchived = clause[$scope.nameSpacePrefix + 'IsArchived__c'];
            $scope.clauseData.clauseCategory = clause[$scope.nameSpacePrefix + 'Category__c'];
            $scope.clauseData.clauseContent = clause[$scope.nameSpacePrefix + 'ClauseContent__c'];
            $scope.clauseData.clauseContractTypes = clause[$scope.nameSpacePrefix + 'ContractTypes__c'];
            if ($scope.clauseData.clauseContractTypes === undefined || $scope.clauseData.clauseContractTypes === $scope.defaultContractType) {
                $scope.clauseData.isDefault = true;
                $scope.clauseData.clauseContractTypes = $scope.defaultContractType;
            } else {
                $scope.clauseData.isDefault = false;
                $scope.selectedContractTypes = [];
                var selectedClauseTypes = $scope.clauseData.clauseContractTypes.split(';');
                for (var j = 0; j < $scope.contractList.length; j++) {
                    if (selectedClauseTypes.indexOf($scope.contractList[j].text) > -1) {
                        $scope.addContractType($scope.contractList[j]);
                    }
                }
            }
            console.log($scope.clauseData);
        }
    };

    $scope.validateClause = function(update) {
        var i, j;
        $scope.validationErrors.clauseValid = true;
        $scope.validationErrors.clauseName = '';
        $scope.validationErrors.clauseCategory = '';
        $scope.validationErrors.clauseContent = '';
        // Make sure name is unique
        if (update) {
            // Check Clause Name is unique except for currently saved name of this clause:
            if ($scope.currentlyEditingName) {
                for (i = 0; i < $scope.clauses.length; i++) {
                    if ($scope.clauses[i].Name === $scope.clauseData.clauseName && $scope.clauses[i].Name !== $scope.currentlyEditingName) {
                        $scope.validationErrors.clauseName = $scope.modalLabels.CLMClauseNameExists;
                        $scope.validationErrors.clauseValid = false;
                    }
                }
            }
        } else {
            // Check Clause Name is not empty, 80 chars or less, and unique:
            if ($scope.clauseData.clauseName) {
                for (j = 0; j < $scope.clauses.length; j++) {
                    if ($scope.clauses[j].Name === $scope.clauseData.clauseName) {
                        $scope.validationErrors.clauseName = $scope.modalLabels.CLMClauseNameExists;
                        $scope.validationErrors.clauseValid = false;
                    }
                }
            }
        }
        // Check Name
        if ($scope.clauseData.clauseName) {
            if ($scope.clauseData.clauseName.length > 80) {
                $scope.validationErrors.clauseName = $scope.modalLabels.CLMClauseCharMin +
                $scope.clauseData.clauseName.length + $scope.modalLabels.CLMClausePlsShorten;
                $scope.validationErrors.clauseValid = false;
            }
        }else {
            $scope.validationErrors.clauseName = $scope.modalLabels.CLMClauseNameEmptyMsg;
            $scope.validationErrors.clauseValid = false;
        }
        // Check Clause Category is selected:
        if ($scope.clauseData.clauseCategory === $scope.initialCategoryOption) {
            $scope.validationErrors.clauseCategory = $scope.modalLabels.CLMClauseSelectClauseCategory;
            $scope.validationErrors.clauseValid = false;
        }
        // Check Clause Content is not empty:
        if ($scope.clauseData.clauseContent) {
            if ($scope.clauseData.clauseContent.length > 32768) {
                $scope.validationErrors.clauseContent = $scope.modalLabels.CLMClauseContentCharMax +
                    $scope.clauseData.clauseContent.length + $scope.modalLabels.CLMClausePlsShorten;
                $scope.validationErrors.clauseValid = false;
            }
        } else {
            $scope.validationErrors.clauseContent = $scope.modalLabels.CLMClauseContentEmpty;
            $scope.validationErrors.clauseValid = false;
        }
    };

    $scope.showArchived = function() {
        if ($scope.filter.showArchived) {
            $scope.clauses = $scope.clauses.concat($scope.archived);
            console.log($scope.clauses);
        } else {
            $scope.clauses = $scope.active;
        }
    };

});

},{}],3:[function(require,module,exports){
angular.module('documentClauseApp').directive('highlightTokens', function() {
    'use strict';
    return {
        restrict: 'A',
        link: function(scope, element) {
            scope.$watch('clauseData.clauseContent', function() {
                $(element).data('highlighter').highlight();
            });
            $(element).highlightTextarea({
                words: ['%%(.+?)%%'],
                id: 'vlocToken',
                color: '#b3eafd'
            });
        }
    };
});

},{}],4:[function(require,module,exports){
angular.module('documentClauseApp').directive('vlcLoader', function() {
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
(function() {
    'use strict';
    window.angular.module('documentClauseApp').service('browserDetection', ['$window', function($window) {
        this.userAgent = $window.navigator.userAgent;
        this.browsers = {
            chrome: /chrome/i,
            safari: /safari/i,
            firefox: /firefox/i,
            msielte10: /msie/i,
            msiegt10: /rv:/i,
            edge: /edge/i
        };

        this.detectBrowser = function() {
            var key;
            var userAgent = this.userAgent;
            var browsers = this.browsers;
            for (key in browsers) {
                if (browsers[key].test(userAgent)) {
                    return key;
                }
            }
            return 'unknown';
        };

        this.getBrowserVersion = function() {
            var version, i;
            var browser = this.detectBrowser();
            var userAgent = this.userAgent;
            var versionSearch = [{
                browser: 'chrome',
                before: ' ',
                after: 'Chrome/'
            }, {
                browser: 'safari',
                before: ' ',
                after: 'Version/'
            }, {
                browser: 'firefox',
                before: '',
                after: 'Firefox/'
            }, {
                browser: 'msielte10',
                before: ';',
                after: 'MSIE '
            }, {
                browser: 'msiegt10',
                before: ')',
                after: 'rv:'
            }, {
                browser: 'edge',
                before: '',
                after: 'Edge/'
            }];

            for (i = 0; i < versionSearch.length; i++) {
                if (browser === versionSearch[i].browser) {
                    version = userAgent.split(versionSearch[i].after)[1];
                    if (versionSearch[i].before) {
                        version = parseFloat(version.substr(0, version.indexOf(versionSearch[i].before)));
                    }
                }
            }

            return version;
        };
    }]);
}());

},{}],6:[function(require,module,exports){
angular.module("documentClauseApp").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("check-archive-clause.tpl.html",'<div role="dialog" tabindex="-1" aria-labelledby="header43" class="slds-modal slds-fade-in-open">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-modal__close slds-button--icon-inverse" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">\n                <slds-button-svg-icon id="close-modal" sprite="\'utility\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">{{modalLabels.CLMClauseClose}}</span>\n            </button>\n            <h2 id="header43" class="slds-text-heading--medium">{{modalLabels.CLMClauseArchiveClause}}</h2>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <p>{{modalLabels.CLMClauseArchiveClauseMsg}}</p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">{{modalLabels.CLMClauseCancel}}</button>\n            <button type="button" class="slds-button slds-button--brand" ng-click="saveClause(true, false, true); $hide()">{{modalLabels.CLMClauseArchiveClause}}</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop--open"></div>\n'),$templateCache.put("check-delete-clause.tpl.html",'<div role="dialog" tabindex="-1" aria-labelledby="header43" class="slds-modal slds-fade-in-open">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-modal__close slds-button--icon-inverse" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">\n                <slds-button-svg-icon id="close-modal" sprite="\'utility\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">{{modalLabels.CLMClauseClose}}</span>\n            </button>\n            <h2 id="header43" class="slds-text-heading--medium">{{modalLabels.CLMClauseDeleteClause}}</h2>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <p>{{modalLabels.CLMClauseAreYouSureDelete}} {{clauseData.clauseName}}? {{modalLabels.CLMClauseActionNotUndone}}</p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">{{modalLabels.CLMClauseCancel}}</button>\n            <button type="button" class="slds-button slds-button--destructive" ng-click="deleteClause(); $hide()">{{modalLabels.CLMClauseDeleteClause}}</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop--open"></div>\n'),$templateCache.put("check-save-clause.tpl.html",'<div role="dialog" tabindex="-1" aria-labelledby="header43" class="slds-modal slds-fade-in-open">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-modal__close slds-button--icon-inverse">\n                <slds-button-svg-icon id="close-modal" sprite="\'utility\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">{{modalLabels.CLMClauseClose}}</span>\n            </button>\n            <h2 id="header43" class="slds-text-heading--medium">{{modalLabels.CLMClauseSave}}</h2>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <p>{{modalLabels.CLMClauseSaveChangesMsg}}</p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button ng-if="!update"type="button" class="slds-button slds-button--neutral" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">{{modalLabels.CLMClauseCancel}}</button>\n            <button ng-if="update" type="button" class="slds-button slds-button--neutral" ng-click="$hide();saveClause(true);loadClauseOnClick(clauseOnClick, typeOnClick);">{{modalLabels.CLMClauseUpdate}}</button>\n            <button ng-if="update" type="button" class="slds-button slds-button--destructive" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">{{modalLabels.CLMClauseCancel}}</button>\n            <button ng-if="!update" type="button" class="slds-button slds-button--neutral" ng-click="$hide();saveClause(false);">{{modalLabels.CLMClauseSave}}</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop--open"></div>\n'),$templateCache.put("dir-pagination-controls.tpl.html",'<ul class="pagination" ng-if="1 < pages.length">\n    <li ng-if="boundaryLinks" ng-class="{ disabled : pagination.current == 1 }">\n        <a href="" ng-click="setCurrent(1)">&laquo;</a>\n    </li>\n    <li ng-if="directionLinks" ng-class="{ disabled : pagination.current == 1 }">\n        <a href="" ng-click="setCurrent(pagination.current - 1)">&lsaquo;</a>\n    </li>\n    <li ng-repeat="pageNumber in pages track by $index" ng-class="{ active : pagination.current == pageNumber, disabled : pageNumber == \'...\' }">\n        <a href="" ng-click="setCurrent(pageNumber)">{{ pageNumber }}</a>\n    </li>\n\n    <li ng-if="directionLinks" ng-class="{ disabled : pagination.current == pagination.last }">\n        <a href="" ng-click="setCurrent(pagination.current + 1)">&rsaquo;</a>\n    </li>\n    <li ng-if="boundaryLinks"  ng-class="{ disabled : pagination.current == pagination.last }">\n        <a href="" ng-click="setCurrent(pagination.last)">&raquo;</a>\n    </li>\n</ul>'),$templateCache.put("warning-active-clause.tpl.html",'<div role="dialog" tabindex="-1" aria-labelledby="header43" class="slds-modal slds-fade-in-open">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-modal__close slds-button--icon-inverse" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">\n                <slds-button-svg-icon id="close-modal" sprite="\'utility\'" icon="\'close\'" size="\'large\'"></slds-button-svg-icon>\n                <span class="slds-assistive-text">{{modalLabels.CLMClauseClose}}</span>\n            </button>\n            <h2 id="header43" class="slds-text-heading--medium">{{modalLabels.CLMClauseDeleteActiveClause}}</h2>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium slds-notify slds-notify--alert slds-theme--warning  slds-theme--alert-texture">\n             <label class="slds-form-element__label"><slds-svg-icon id="clause-page-header_icon" sprite="\'utility\'" icon="\'warning\'" size="\'small\'" extra-classes="\'slds-button__icon--left\'"></slds-svg-icon>{{modalLabels.CLMClauseDeleteActiveClause}}</label>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral" ng-click="loadClauseOnClick(clauseOnClick, typeOnClick); $hide()">{{modalLabels.CLMClauseCancel}}</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop--open"></div>\n')}]);
},{}]},{},[1]);

})();