(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('cardhome', ['sldsangular', 'drvcomp', 'ngTable', 'vlocity', 'infinite-scroll'])
	.config(['$localizableProvider', function($localizableProvider) {
      'use strict';
      $localizableProvider.setLocalizedMap(window.i18n);
      $localizableProvider.setDebugMode(false);
  }]);

require('./modules/cardhome/controller/CardHome.js');
require('./modules/cardhome/config/Config.js');
require('./modules/cardhome/factory/Save.js');
require('./modules/cardhome/templates/templates.js');

},{"./modules/cardhome/config/Config.js":2,"./modules/cardhome/controller/CardHome.js":3,"./modules/cardhome/factory/Save.js":4,"./modules/cardhome/templates/templates.js":5}],2:[function(require,module,exports){
/*global fileNsPrefixDot*/
angular.module('cardhome')
    .config(['remoteActionsProvider', function(remoteActionsProvider) {
        'use strict';
        var actions = ['saveLayout', 'getLayout', 'isInsidePckg', 'setLayoutStatus'];
        var config = actions.reduce(function(config, action) {
            config[action] = {
                action: fileNsPrefixDot() + 'CardCanvasController.' + action,
                config: {escape: false}
            };
            return config;
        }, {});
        remoteActionsProvider.setRemoteActions(config);
    }]);
},{}],3:[function(require,module,exports){
angular.module('cardhome')
.controller('cardhome', ['$scope', '$rootScope', '$drvExport', '$sldsPrompt',
                            'remoteActions', '$filter',  '$drvImport', '$localizable', '$sldsModal', 'save', '$window', '$q',
    function($scope, $rootScope, $drvExport, $sldsPrompt, remoteActions, $filter, $drvImport, $localizable, $sldsModal, save, $window, $q) {

        'use strict';
        var DEFAULT_AUTHOR = 'vlocity';
        var DEFAULT_AUTHOR_SUFFIX = 'Dev';
        $rootScope.nsPrefix = fileNsPrefix();
        var DEFAULT_AUTHOR = 'vlocity';
        var DEFAULT_AUTHOR_SUFFIX = 'Dev';
        $scope.defaultColumns = [{
            field: 'Name',
             width: 300,
            additionalFields: [fileNsPrefix() + 'Version__c'],
            getValue: function($scope, row) {
                if (typeof sforce != "undefined" && sforce.one) {
                    return '<a onclick="sforce.one.navigateToURL(\'' + window.cardsNewUrl + '?id=' + row.Id + '\')">' +
                                        row.Name + ' (Version ' +
                                row[fileNsPrefix() + 'Version__c'] + ')</a>';
                } else {
                    return '<a href="' + window.cardsNewUrl + '?id=' + row.Id + '">' + row.Name + ' (Version ' +
                                row[fileNsPrefix() + 'Version__c'] + ')</a>';
                }
            },
            resizable: true
        }, {
            field: fileNsPrefix() + 'Type__c',
            resizable: true
        }, {
            field: fileNsPrefix() + 'Author__c',
            width: 140,
            resizable: true,
            getGroupValue: function($scope, $group) {
                return;
            },
            getValue: function($scope, row) {
                return row[fileNsPrefix() + 'Author__c'];
            }
        }, {
            resizable: true,
            field: 'LastModifiedDate',
            getGroupValue: function($scope, $group) {
                return $filter('date')($group.data[0].LastModifiedDate, 'short');
            },
            getValue: function($scope, row) {
                return $filter('date')(row.LastModifiedDate, 'short');
            }
        }, {
            resizable: true,
            field: 'LastModifiedById',
            getGroupValue: function($scope, $group) {
                return $group.data[0].LastModifiedBy ? $group.data[0].LastModifiedBy.Name : '';
            },
            getValue: function($scope, row) {
                return row.LastModifiedBy ? row.LastModifiedBy.Name : '';
            }
        }, {
            field: fileNsPrefix() + 'Active__c',
            shrink: true,
            dynamic: true,
            getGroupSortValue: function($scope, $group) {
                var hasAnActiveEntry = false;
                _.forEach($group.data, function(row) {
                    if (row[fileNsPrefix() + 'Active__c']) {
                        hasAnActiveEntry = true;
                        return false;
                    }
                });
                return hasAnActiveEntry
            },
            getValue: function($scope, row) {
                if (row[fileNsPrefix() + 'Active__c']) {
                    return '<span class="slds-icon_container" title="Is Active"><slds-svg-icon sprite="\'utility\'"' +
                            ' icon="\'success\'" size="\'x-small\'" extra-classes="\'slds-icon-text-default \'"></slds-svg-icon></span>';
                }
            },
            getGroupValue: function($scope, $group) {
                var hasAnActiveEntry = false;
                _.forEach($group.data, function(row) {
                    if (row[fileNsPrefix() + 'Active__c']) {
                        hasAnActiveEntry = true;
                        return false;
                    }
                });
                if (hasAnActiveEntry) {
                    return '<span class="slds-icon_container" title="Is Active"><slds-svg-icon sprite="\'utility\'"' +
                            ' icon="\'success\'" size="\'x-small\'" extra-classes="\'slds-icon-text-default \'"></slds-svg-icon></span>';
                }
            },
            resizable: true,
            width: 110
        }];
        //Row actions
        $rootScope.vlocity.getCustomLabels('DeleteLayout', 'Preview')
            .then(function(labels) {
                $scope.rowActions = [{
                    type: 'export',
                    drvType: 'VlocityUILayout'
                }, {
                    type: 'delete',
                    promptTitle: labels[0],
                    promptContent: function(row) {
                        return $localizable('DeleteLayoutConfirmation', 'Are you sure you want to delete this Layout?<br/> <br/>"{1} (Version {2})" ', row.Name, row[fileNsPrefix() + 'Version__c']);
                    },
                    hide: function(row, group) {
                        return row[fileNsPrefix() + 'Active__c'];
                    }
                }, {
                    text: labels[1],
                    icon: {
                        sprite: 'utility',
                        icon: 'preview'
                    },
                    click: function(row, group) {
                        window.open('/apex/' + fileNsPrefix() + 'ConsoleCards?isdtp=vw&layout=' + row.Name + '&layoutId=' +
                                            row.Id + '&previewMode=Universal','_blank');
                    }
                }, {
                    text: 'Clone',
                    icon: {
                        sprite: 'action',
                        icon: 'clone'
                    },
                    click: function(row, group) {
                        $scope.showCloneModal(row);
                    }
                }, {
                    text: 'Activate',
                    icon: {
                        sprite: 'utility',
                        icon: 'success'
                    },
                    click: function(row, group) {
                        $scope.setLayoutStatus([row.Id], true);
                    },
                    hide: function(row, group) {
                        return row[fileNsPrefix() + 'Active__c'];
                    }
                },{
                    text: 'Deactivate',
                    icon: {
                        sprite: 'utility',
                        icon: 'error'
                    },
                    click: function(row, group) {
                        $scope.setLayoutStatus([row.Id], false);
                    },
                    hide: function(row, group) {
                        return !row[fileNsPrefix() + 'Active__c'];
                    }
                }];
            });
        
        $scope.showCloneModal = function(parentLayout) {
            console.log('cloning layout parent',parentLayout);
           
            remoteActions.getLayout('Id',parentLayout.Id).then(
                function(layout) {
                    console.log('received parent layout ',layout[0]);
                    var modal, modalScope, title = 'Clone Layout';

                    modalScope = $scope.$new();
                    modalScope.parentLayout = layout[0];
                    modalScope.parentLayout[$rootScope.nsPrefix + 'Definition__c'] = JSON.parse(modalScope.parentLayout[$rootScope.nsPrefix + 'Definition__c']);
                    modalScope.clonedLayout = angular.copy(modalScope.parentLayout);
                    modalScope.clonedLayout[$rootScope.nsPrefix + 'Author__c'] = $window.orgName.toLowerCase() === DEFAULT_AUTHOR ? DEFAULT_AUTHOR + DEFAULT_AUTHOR_SUFFIX : $window.orgName;

                    modalScope.saveLayout = function(hideModal){
                        modalScope.clonedLayout[$rootScope.nsPrefix + 'Version__c'] = 1;
                        modalScope.clonedLayout[$rootScope.nsPrefix + 'ParentID__c'] = modalScope.parentLayout[$rootScope.nsPrefix + 'GlobalKey__c'];
                        delete modalScope.clonedLayout.Id;
                        delete modalScope.clonedLayout.createNewLayout;
                        delete modalScope.clonedLayout[$rootScope.nsPrefix + 'GlobalKey__c'];
                        console.log(modalScope.clonedLayout);
                        save(modalScope.clonedLayout, null, true).then(function(savedLayout) {
                            console.log('saved the new new layout',savedLayout);
                            if(savedLayout.errors){
                                console.log('look at these errors',savedLayout.errors);
                                modalScope.errors = savedLayout.errors;
                            } else {
                                hideModal();
                                window.open('/apex/' + fileNsPrefix() + 'CardDesignerNew?id=' + savedLayout.Id, '_current');
                            }
                            
                        }, function(err){
                            console.log('couldnt save ',err);
                        });
                    };

                    modal = $sldsModal({
                        templateUrl: 'CloneModal.tpl.html',
                        show: true,
                        backdrop: 'static',
                        scope: modalScope,
                    });
                },
                function(err) {
                    console.log(err);
            });
            

            
        };

        remoteActions.isInsidePckg()
        .then(function(insidePckg) {
            console.log('inside pckg? ',insidePckg);
            $rootScope.insidePckg = insidePckg;
            // $rootScope.lockedLayout = $rootScope.insidePckg && $rootScope.layout[$rootScope.nsPrefix + 'Author__c'].toUpperCase() === 'VLOCITY';
            console.log('is layout locked? ',$rootScope.lockedLayout);
        }, function(err){
            console.log('inside pckg error ',err);
            //set to true if error returns that user does not have access to package
            $rootScope.insidePckg = true;
        });

        remoteActions.getBaseDatapacks('DP_CARDS_').then(
            function(packs){
                $scope.additionalTableButtons = $scope.additionalTableButtons || [];
                angular.forEach(packs, function(pack, index) {
                    $localizable('InstallDataPack', 'Install {1}', pack.Name.replace('DP_CARDS_',''))
                        .then(function(label) {
                            var tableButton = {
                                text: label,
                                click: function() {
                                    $drvImport({
                                        scope: $scope,
                                        mode: 'staticresource',
                                        dataPackDataPublicId: pack.Name,
                                        dataPackDataPublicSource: 'Vlocity Resource',
                                        onImportComplete: function() {
                                            $rootScope.$broadcast('reload.table', 'cards-home');
                                        }
                                    });
                                }
                            };
                            $scope.additionalTableButtons.push(tableButton);
                        })
                });
            },
            function(error){
                console.log(error);
        });

        $scope.additionalHeaderButtons = $scope.additionalHeaderButtons || [];

        var activateButton = {
            id : 'activate',
            text : 'Activate',
            click : function(scope, event) {
                        var selectedRows = $scope.$$childHead.sldsGroupedTableParams.selected();
                        $scope.setLayoutStatus(selectedRows, true);
                    },
            hide: function(row, group) {
                        return $scope.$$childHead.sldsGroupedTableParams.selected().length === 0;
                    }
        };

        var deactivateButton = {
            id: 'deactivate', 
            text : 'Deactivate',
            click : function() {
                        var selectedRows = $scope.$$childHead.sldsGroupedTableParams.selected();
                        $scope.setLayoutStatus(selectedRows, false);
                    },
            hide: function(row, group) {
                        return $scope.$$childHead.sldsGroupedTableParams.selected().length === 0;
                    }
        };

        $scope.additionalHeaderButtons.push(activateButton);
        $scope.additionalHeaderButtons.push(deactivateButton);

        $scope.setLayoutStatus = function(rows, status){
            remoteActions.setLayoutStatus(rows, status).then(
                function(layouts){
                    if(layouts.length == 0){
                        $rootScope.$broadcast('reload.table', 'cards-home');
                        return;
                    }
                    var modalScope = $scope.$new();
                    var labelPrefix = status ? 'A' : 'Dea';
                    var labelTitlePromise = $localizable(labelPrefix + 'ctivationTitle', labelPrefix + 'ctivation Error');
                    var labelBodyPromise = $localizable(labelPrefix + 'ctivateLayoutsError', 'Please select only one layout of a particular name to ' + labelPrefix.toLowerCase() + 'ctivate. ' + labelPrefix + 'ctivation of layouts with the same name is not allowed: {1}.?',
                                _.map(layouts, 'Name').join(', '));

                    $q.all([
                        labelTitlePromise,
                        labelBodyPromise
                    ]).then(function(labels) {
                        $sldsModal({
                            title: labels[0],
                            templateUrl: 'ErrorModal.tpl.html',
                            content: labels[1],
                            scope: modalScope,
                            show: true
                        });
                    });
            });
        };
    }]);
},{}],4:[function(require,module,exports){
angular.module('cardhome')
.factory('save', function($q, remoteActions, $rootScope, $timeout, $window, $localizable) {
    'use strict';
    var DEFAULT_AUTHOR = 'vlocity';
    function adaptLayoutJsonForSave(json, isLayout, ignoreCards) {
        return Object.keys(json).reduce(function(outputObject, key) {
            if (/(^Id|^Name|__c)$/.test(key)) {
                outputObject[key] = json[key];
                if (/Definition__c/.test(key)) {
                    if (isLayout && !ignoreCards) {
                        // update Deck on definition with the latest names of cards
                        outputObject[key].Cards = json[key].Cards = $rootScope.layoutCards.filter(function(card) {
                            return card !== null;
                        }).map(function(card) {
                            return card.Name;
                        });
                    }
                    outputObject[key] = angular.toJson(outputObject[key]);
                }
            }
            return outputObject;
        }, {});
    }

    function shouldSave(item, json, isLayout, ignoreCards) {
        //parse definition if it comes in as string
        item[$rootScope.nsPrefix + 'Definition__c'] = typeof item[$rootScope.nsPrefix + 'Definition__c'] === 'string' ?
            JSON.parse(item[$rootScope.nsPrefix + 'Definition__c']) : item[$rootScope.nsPrefix + 'Definition__c'];
        if (item.saving) {
            return false;
        } else if (!item.Name || item.Name === '' || item.Name === '*') {
            $localizable('CardDesignerMustSetName', 'Please provide a name')
                .then(function(label) {
                    item.errors = [{
                        message: label
                    }];
                })
            return false;
        }

         // if it is layout, check for template as it is mandatoryf
        if (isLayout && !item[$rootScope.nsPrefix + 'Author__c']) {
            $localizable('CardDesignerLayoutMustSelectAuthor', 'Please provide a Layout author')
                .then(function(label) {
                    item.errors = [{
                        message: label
                    }];
                });
            return false;
        }

        // check for author name exists and not similar to default author 
        if ($rootScope.insidePckg && item[$rootScope.nsPrefix + 'Author__c'] && item[$rootScope.nsPrefix + 'Author__c'].toLowerCase() === DEFAULT_AUTHOR && !item.Id) {
            $localizable('DesignerMustSetAuthor', 'You cannot set Vlocity as your author')
                .then(function(label) {
                    item.errors = [{
                        message: label
                    }];
                });
            return false;
        }

        // if it is layout, check for template as it is mandatoryf
        if (isLayout && (!item[$rootScope.nsPrefix + 'Definition__c'].templates ||
               item[$rootScope.nsPrefix + 'Definition__c'].templates.length === 0)) {
            $localizable('CardDesignerLayoutMustSelectTemplate', 'Please provide a template for the layout')
                .then(function(label) {
                    item.errors = [{
                        message: label
                    }];
                });
            return false;
        }

        // check layout name doesn't exist already
        if (isLayout && item.createNewLayout && $rootScope.layouts.find(function(layout) {
            // a layout name is duplicated if it was created by the "New" button from the CardHome page (item.createNewLayout)
            // and its name is the same as an existing one in the DB
            return layout.Name === item.Name;
        })) {
            $localizable('CardDesignerNameAlreadyInUse', 'This name is already in use')
                .then(function(label) {
                        item.errors = [{
                            message: label
                        }];
                    });
            return false;
        }

        if (isLayout && !ignoreCards) {
            // don't save it if the change is a Card name and it's now invalid
            if ($rootScope.layoutCards.some(function(card) {
                return card.Name === '' || card.Name === '*' || (card.errors && card.errors.length > 0);
            })) {
                return false;
            }
        } else {
            // check card name doesn't exist already
            if (!ignoreCards && $rootScope.cards.find(function(card) {
                return card.Name === item.Name && card.Id !== item.Id;
            })) {
                if (item.originalJson) {
                    if (item.Name !== item.originalJson.Name) { //make sure the name changed to a used name
                        $localizable('CardDesignerNameAlreadyInUse', 'This name is already in use')
                            .then(function(label) {
                                item.errors = [{
                                        message: label
                                    }];
                                });
                    } else {
                        delete item.errors;
                    }
                } else {
                    $localizable('CardDesignerNameAlreadyInUse', 'This name is already in use')
                        .then(function(label) {
                            item.errors = [{
                                    message: label
                                }];
                            });
                }

                return false;
            }

            if (item[$rootScope.nsPrefix + 'Definition__c'] && item[$rootScope.nsPrefix + 'Definition__c'].states && item[$rootScope.nsPrefix + 'Definition__c'].states.length === 0) {
                $localizable('CardDesignerCardStateMustExist', 'Please provide a Card State')
                    .then(function(label) {
                        item.errors = [{
                                message: label
                            }];
                        });
                return false;
            }

            if (item[$rootScope.nsPrefix + 'Definition__c'] && item[$rootScope.nsPrefix + 'Definition__c'].states && item[$rootScope.nsPrefix + 'Definition__c'].states.length > 0) {
                angular.forEach(item[$rootScope.nsPrefix + 'Definition__c'].states,function(state) {
                    if (!state.name || !state.templateUrl) {
                        $localizable('CardDesignerCardStateMustHaveNameAndTemplate', 'Please provide a Card State name and template')
                            .then(function(label) {
                                item.errors = [{
                                        message: label
                                    }];
                                });
                        return false;
                    }
                });
            }

        }

            if (angular.equals(item.originalJson, json)) {
                return false;
            }    

        item.originalJson = json;
        item.saving = true;
        item.errors = null;
        return item;
    }

    function saveLayout(layout, ignoreCards) {
        var jsonToSave = adaptLayoutJsonForSave(layout, true, ignoreCards);
        if (shouldSave(layout, jsonToSave, true, ignoreCards)) {
            layout.saving = true;
            return remoteActions.saveLayout(jsonToSave).then(function(updatedLayout) {
                layout.saving = false;
                $rootScope.$broadcast('saved', layout);
                if (updatedLayout) {
                    layout.Id = updatedLayout.Id;
                    var existingId = $window.location.href.split(/[?&]/).find(function(item) {
              return /^id\=/.test(item);
          });
                    if (existingId) {
                        existingId = existingId.replace(/^id=/, '');
                    }
                    if (!existingId || existingId !== layout.Id) {
                        $timeout(function() {
                            if (existingId) {
                                var pathname = $window.location.href.replace(existingId, layout.Id);
                                $window.history.pushState('', '', pathname);
                            } else {
                                var newUrl = $window.location.pathname +
                                            ($window.location.search.length === 0 ? '?' :
                                             $window.location.search + '&') + 'id=' + layout.Id;
                                $window.history.pushState('','', newUrl);
                            }
                        });
                    }
                    if (updatedLayout.errors) {
                        layout.errors = updatedLayout.errors;
                    } else if (updatedLayout.type === 'exception') {
                        layout.errors = [{
                            message: updatedLayout.message
                        }];
                    }
                }
                return layout;
            }, function(error) {
                console.log('bad save layout promise ',error);
                layout = layout || {};
                layout.saving = false;
                layout.errors = [{
                    message: error.message,
                    data: error
                }];
                return layout;
            })
            .catch(function(error) {
                console.log('saving layout error ',error);
                layout = layout || {};
                layout.saving = false;
                layout.errors = [{
                    message: error.message,
                    data: error
                }];
            });
        } else {
            return $q.when(layout);
        }
    }
    function saveCard(card) {
        var jsonToSave = adaptLayoutJsonForSave(card);
        if (shouldSave(card, jsonToSave)) {
            card.saving = true;
            return remoteActions.saveCard(jsonToSave).then(function(updatedCard) {
                card.saving = false;
                $rootScope.$broadcast('saved', card);
                if (updatedCard) {
                    if (card.Id !== updatedCard.Id) {
                        card.Id = updatedCard.Id;
                        $rootScope.cards.push(card);
                    }
                    if (updatedCard.errors) {
                        card.errors = updatedCard.errors;
                    } else if (updatedCard.type === 'exception') {
                        card.errors = [{
                            message: updatedCard.message
                        }];
                    }
                }
            }).catch(function(error) {
                card.saving = false;
                card.errors = [{
                    message: error.message
                }];
            });
        } else {
            return $q.when(card);
        }
    }

    return function save(layout, cards, ignoreCards) {
        if (!layout || (!cards && !ignoreCards)) {
            //throw "Missing cards or layout when trying to save!";
            return $q.when(layout);
        }
        if (ignoreCards) {
            return saveLayout(layout, !!ignoreCards);
        }
        return $q.all(cards.filter(function(card) {
        return !(card.Name === '' && !card.originalJson);
    }).map(function(card) {
        return saveCard(card);
    })).then(function() {
        return saveLayout(layout);
    });
    };
});

},{}],5:[function(require,module,exports){
angular.module("cardhome").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("CloneModal.tpl.html",'<div class="slds-modal slds-fade-in-open">\n    <div>\n        <div class="slds-modal__container">\n            <div class="slds-modal__header">\n                <h2 class="slds-text-heading--medium">CLONE LAYOUT</h2>\n            </div>\n            <div ng-if="clonedLayout.errors">\n                <div class="slds-notify slds-notify--alert slds-theme--error slds-theme--alert-texture" role="alert" ng-repeat="error in clonedLayout.errors">\n                    <h2>\n                    <svg class="slds-icon slds-icon--small slds-m-right--x-small" aria-hidden="true">\n                        <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#ban"></use>\n                    </svg>{{error.message}}</h2>\n                </div>\n            </div>\n            <div class="slds-modal__content slds-p-around--x-large" style="min-height: 200px;">\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="layoutName">Layout Name</label>\n                    <div class="slds-form-element__control">\n                        <input type="text" id="layoutName" class="slds-input" ng-model="clonedLayout.Name" required=""/>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="select-01">Layout Type</label>\n                    <div class="slds-form-element__control">\n                        <div class="slds-select_container">\n                        <select id="select-01" class="slds-select" ng-model="clonedLayout[$root.nsPrefix+\'Type__c\']">\n                            <option>Layout</option>\n                            <option>Flyout</option>\n                        </select>\n                        </div>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="layoutName">Layout Author</label>\n                    <div class="slds-form-element__control">\n                        <input type="text" id="layoutName" class="slds-input" ng-model="clonedLayout[$root.nsPrefix+\'Author__c\']"/>\n                    </div>\n                </div>\n            </div>\n            <div class="slds-modal__footer">\n                <button type="button" class="slds-button slds-button--neutral"\n                        ng-click="$hide()">\n                        Close\n                </button>\n                <button type="button" class="slds-button slds-button--brand"\n                        ng-click="saveLayout($hide);" >\n                        Clone\n                </button>\n            </div>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("ConfirmationModal.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n  <div class="modal-dialog">\n    <div class="modal-content">\n      <div class="modal-header" ng-show="title">\n        <button type="button" class="close" aria-label="Close" ng-click="$hide()"><span aria-hidden="true">&times;</span></button>\n        <h4 class="modal-title" ng-bind="title"></h4>\n      </div>\n      <div class="modal-body" ng-bind="content"></div>\n      <div class="modal-footer">\n        <button type="button" class="btn btn-primary" ng-click="ok();$hide()">{{ ::\'LayoutConfirmOk\' | localize: \'Delete\' }}</button>\n        <button type="button" class="btn btn-default" ng-click="$hide()">{{ ::\'LayoutConfirmCancel\' | localize: \'Cancel\' }}</button>\n      </div>\n    </div>\n  </div>\n</div>'),$templateCache.put("ErrorModal.tpl.html",'<div class="slds-modal slds-fade-in-open">\n  <div class="slds-modal__container">\n    <div class="slds-modal__header slds-theme--error slds-theme--alert-texture">\n        <h2 class="slds-text-heading--medium"><slds-svg-icon sprite="\'utility\'" icon="\'warning\'" size="\'small\'" extra-classes="\'slds-m-right--small slds-col slds-no-flex\'"></slds-svg-icon>{{title}}</h2>\n    </div>\n    <div class="slds-modal__content slds-p-around--x-large slds-grid slds-grid--vertical">\n        <div class="" role="alert">\n           <slds-svg-icon sprite="\'utility\'" icon="\'warning\'" size="\'small\'" extra-classes="\'slds-icon-text-error\'"></slds-svg-icon>\n            {{content}}\n        </div>\n    </div>\n    <div class="slds-modal__footer">\n        <button type="button" class="slds-button slds-button--neutral"\n            ng-click="$hide()">\n            Close\n        </button>\n    </div>\n  </div>\n</div>')}]);
},{}]},{},[1]);

})();