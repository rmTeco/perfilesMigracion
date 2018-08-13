(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('attributeCategoryEdit', ['vlocity', 'drvcomp', 'sldsangular', 'ngSanitize', 'ngMessages', 'ngAria', 'ngAnimate'])
  .config(['remoteActionsProvider', function(remoteActionsProvider) {
      'use strict';
      var actions = ['getAttributeAssignmentRules', 'saveAttributeCategory', 'saveAttribute', 'saveAttributeAssignmentRule', 'deleteAttributeAssignmentRule', 'deleteAttribute', 'validateUniqueField', 'validateAttributeCode'];
      var config = actions.reduce(function(config, action) {
            config[action] = {
                action: fileNsPrefixDot() + 'VlocityAttributeCategoryEditCtrl.' + action,
                config: {escape: false}
            };
            return config;
        }, {});
      remoteActionsProvider.setRemoteActions(config);
  }])
  .run(function(attributeCategory, $$attributes) {
    delete attributeCategory.attributes;
    attributeCategory.$$originalJSON = angular.toJson(attributeCategory);
    attributeCategory.$$attributes = $$attributes;
    attributeCategory.$$attributes.forEach(function(attribute) {
      delete attribute.attributes;
      attribute.$$originalJSON = angular.toJson(attribute);
    });
  })
.constant('_', window._);

require('./modules/attributeCategoryEdit/controller/vlocAttrCategory.js');

require('./modules/attributeCategoryEdit/directive/categoryValueSidebar.js');
require('./modules/attributeCategoryEdit/directive/categoryEditPane.js');

require('./modules/attributeCategoryEdit/service/attributeValidationService.js');

require('./modules/attributeCategoryEdit/templates/templates.js');

},{"./modules/attributeCategoryEdit/controller/vlocAttrCategory.js":2,"./modules/attributeCategoryEdit/directive/categoryEditPane.js":3,"./modules/attributeCategoryEdit/directive/categoryValueSidebar.js":4,"./modules/attributeCategoryEdit/service/attributeValidationService.js":5,"./modules/attributeCategoryEdit/templates/templates.js":6}],2:[function(require,module,exports){
angular.module('attributeCategoryEdit')
    .controller('vlocAttrCategory', function (attributeCategory, fieldMetadata, _, remoteActions, $scope, $window, fieldSetMetadata, $q) {
        var self = this;
        this.attributeCategory = attributeCategory;
        this.fields = fieldMetadata.AttributeCategory;
        this.visibleFields = fieldSetMetadata.AttributeCategory;

        this.selectedAttribute = this.attributeCategory.$$attributes[0];

        this.buttons = [
            {
                type: 'edit',
                handleSave: function(attributeCategory) {
                    var safeJson = angular.fromJson(angular.toJson(attributeCategory));
                    return remoteActions.saveAttributeCategory(safeJson)
                            .then(function(updatedAttributeCategory) {
                                if (!attributeCategory.Id) {
                                    var newUrl = $window.location.pathname +
                                                ($window.location.search.length === 0 ? '?' :
                                                $window.location.search + '&') + 'id=' + updatedAttributeCategory.Id;
                                    $window.history.replaceState('','', newUrl);
                                }
                                _.assign(attributeCategory, updatedAttributeCategory);
                            });
                }
            },{
                type: 'export'
            }
        ];

        this.onAttributeDeleted = function(attribute) {
            var i = self.attributeCategory.$$attributes.indexOf(attribute);
            if (i > -1) {
                self.attributeCategory.$$attributes.splice(i, 1);
                self.selectedAttribute = self.attributeCategory.$$attributes[i >= self.attributeCategory.$$attributes.length ? self.attributeCategory.$$attributes.length-1 : i];
            }
        };

        $scope.$watch('ctrl.attributeCategory.$$attributes.length', function(length) {
            if (length) {
                self.attributeCategory.$$attributes.forEach(function(attribute) {
                    attribute[fileNsPrefix() + 'AttributeCategoryId__c'] = self.attributeCategory.Id;
                });
            }
        });

    });

},{}],3:[function(require,module,exports){
angular.module('attributeCategoryEdit')
    .directive('categoryEditPane', function(remoteActions, $timeout, $sldsDeletePrompt, $sldsToast, $localizable, $q, fieldSetMetadata, attributeValidationService) {

        function getTemplate(type) {
            switch (type) {
                case 'BOOLEAN': return 'CheckboxTemplate.tpl.html';
                default:        return 'InputTemplate.tpl.html';
            }
        }

        return {
            restrict: 'ACE',
            bindToController: {
                attribute: '=',
                attributeCategory: '=',
                onDelete: '&'
            },
            scope: {},
            templateUrl: 'CategoryEditPane.tpl.html',
            controllerAs: 'ctrl',
            controller: function($scope, fieldMetadata, $element, $rootScope) {
                var self = this;
                this.ns = fileNsPrefix();
                this.rules = [];

                $scope.$watch('ctrl.attributeform', function(form) {
                    attributeValidationService.setCurrentForm(form);
                });

                self.form = fieldSetMetadata.Attribute
                    .map(function(key) {
                        var size = {class: 'slds-size--1-of-4'};
                        if ('Name' == key) {
                            return _.defaults(size, _.defaults({
                                isNillable: false
                            }, fieldMetadata.Attribute[key]));
                        } else if (self.ns + 'Code__c' == key) {
                            return _.defaults(size, _.defaults({
                                isNillable: false,
                                customValidator: function(modelValue, viewValue) {
                                    attributeValidationService.setCurrentAttributeValidating();
                                    return $q(function(resolve, reject) {
                                        remoteActions.validateAttributeCode(self.attribute.Id || '', modelValue)
                                            .then(function(response) {
                                                if (response) {
                                                    resolve(response);
                                                } else {
                                                    reject(response);
                                                }
                                                $timeout(function() {
                                                    attributeValidationService.setCurrentAttributeValid(response);
                                                });
                                            })
                                            .catch(function(err) {
                                                attributeValidationService.setCurrentAttributeValid(false);
                                                reject(err);
                                            });
                                    });
                                },
                                customValidatorMessage: 'This code already exists. Code\'s must be unique.'
                            }, fieldMetadata.Attribute[key]));
                        }
                        return _.defaults(size, fieldMetadata.Attribute[key]);
                    });

                var saveToken = null;
                $scope.$watch('ctrl.attribute', function(attribute, previousAttribute) {
                    if (attribute && previousAttribute && (attribute.Id !== previousAttribute.Id && previousAttribute.Id)) {
                        $timeout(function() {
                            $('#Name', $element).focus();
                        });
                    }
                    if (attribute && attribute.Name) {
                        saveAttribute(attribute);
                    }
                }, true);

                function saveAttribute(attribute) {
                    if (saveToken && saveToken.Id == attribute.Id) {
                        $timeout.cancel(saveToken.token);
                    }
                    var jsonString = angular.toJson(attribute);
                    if (attribute.$$originalJSON !== jsonString) {
                        attributeValidationService.setCurrentAttributeValidating();
                        var token = $timeout(function() {
                            self.attributeCategory.$$saving = true;
                            if (attribute.Name) {
                                var capturedSaveToken = saveToken;
                                remoteActions.saveAttribute(JSON.parse(jsonString))
                                    .then(function(updatedAttribute) {
                                        attributeValidationService.setCurrentAttributeValid(true);
                                        _.assign(attribute, updatedAttribute);
                                        self.attributeCategory.$$saving = false;
                                        attribute.$$originalJSON = angular.toJson(attribute);
                                    }).catch(function(error) {
                                        attributeValidationService.setCurrentAttributeValid(false);
                                        console.log(error);
                                        self.attributeCategory.$$saving = false;
                                        self.attributeCategory.$$error = error;
                                        $localizable("CouldNotSave", "{1} could not be saved.", attribute.Name)
                                            .then(function(label) {
                                                $sldsToast({
                                                    severity: 'error',
                                                    title: label,
                                                    icon: 'warning',
                                                    autohide: false,
                                                    content: error.message
                                                });
                                            });
                                        });
                            }
                        }, 1000);
                        saveToken = {
                            token: token,
                            Id: attribute.Id
                        };
                    }
                }

                this.selectedAttribute = function(attribute) {
                    $rootScope.$broadcast('attributeScrollIntoView', attribute);
                };

                this.deleteAttribute = function(attribute) {
                    $sldsDeletePrompt(attribute, function() {
                        var promise = $q.when(attribute);
                        if (attribute.Id) {
                            promise = remoteActions.deleteAttribute(JSON.parse(angular.toJson(attribute)))
                        }
                        promise.then(function() {
                            self.onDelete({attribute: attribute});
                            self.attribute = null;
                        });
                        return promise;
                    });   
                };

                self.rulesForm = fieldSetMetadata.AttributeAssignmentRule
                    .map(function(key) {
                        if (/Service__c/.test(key)) {
                            return _.defaults({
                                class: 'slds-size--1-of-1',
                            }, _.defaults({
                                type: 'TEXTAREA'
                            }, fieldMetadata.AttributeAssignmentRule[key]));    
                        } else if ('Name' == key) {
                            return _.defaults({
                                class: 'slds-size--1-of-4',
                            }, _.defaults({
                                isNillable: false
                            }, fieldMetadata.AttributeAssignmentRule[key]));    
                        }
                        return _.defaults({
                            class: 'slds-size--1-of-4',
                        }, fieldMetadata.AttributeAssignmentRule[key]);
                    });

                self.getLabel = function(field, rule) {
                    return rule[fileNsPrefix() + "Type__c"] === "Field" ? "Field" : "Formula";
                };

                $scope.$watch('ctrl.attribute.Id', function(newId, oldId) {
                    if (newId) {
                        remoteActions.getAttributeAssignmentRules(newId)
                            .then(function(rules) {
                                self.rules = rules;
                                self.rules.forEach(function(rule) {
                                    rule[fileNsPrefix() + 'SObjectTypes__c'] = rule[fileNsPrefix() + 'SObjectTypes__c'] ? rule[fileNsPrefix() + 'SObjectTypes__c'].split(';') : [];
                                    rule.$$originalJSON = angular.toJson(rule);
                                });
                            }).catch(function(error) {
                                console.log(error);
                                self.attribute.$$error = error;
                                $localizable("CouldNotLoadAttributes", "Could not load attributes for '{1}'", self.attribute.Name)
                                    .then(function(label) {
                                        $sldsToast({
                                            severity: 'error',
                                            title: label,
                                            icon: 'warning',
                                            autohide: false,
                                            content: error.message
                                        });
                                    });
                            });
                    } else {
                        self.rules = [];
                    }
                });

                this.addNewAssignmentRule = function() {
                    var rule = {
                        Name: ''
                    };
                    fieldSetMetadata.AttributeAssignmentRule.forEach(function(field) {
                        if (fieldMetadata.AttributeAssignmentRule[field].type && fieldMetadata.AttributeAssignmentRule[field].type.toUpperCase() == 'BOOLEAN') {
                            rule[field] = fieldMetadata.AttributeAssignmentRule[field].defaultValue || false;
                        } else if (fieldMetadata.AttributeAssignmentRule[field].defaultValue) {
                            rule[field] = fieldMetadata.AttributeAssignmentRule[field].defaultValue;
                        }
                    });
                    rule[self.ns + 'AttributeId__c'] = self.attribute.Id;
                    rule[self.ns + 'Type__c'] = 'Formula';
                    self.rules.push(rule);

                    $timeout(function() {
                        var newRule = $('.vlocity-attribute-assignment-rule', $element).last().get(0);
                        if (newRule && (!newRule.scrollIntoViewIfNeeded || newRule.scrollIntoViewIfNeeded())) {
                            newRule.scrollIntoView();
                        }
                        $('input', newRule).get(0).focus();
                    });
                };

                this.deleteRule = function(rule, $index) {
                    $sldsDeletePrompt(rule, function() {
                        var promise = $q.when(rule);
                        if (rule.Id) {
                            promise = remoteActions.deleteAttributeAssignmentRule(JSON.parse(angular.toJson(rule)));
                        }
                        promise.then(function() {
                            self.rules.splice($index, 1);
                        });
                        return promise;
                    });
                };

                $scope.$watch('ctrl.rules', function(rules) {
                    if (rules && rules.length > 0) {
                        if (saveToken) {
                            $timeout.cancel(saveToken);
                        }
                        var changedRules = rules.filter(function(rule) {
                            return (rule.$$originalJSON !== angular.toJson(rule));
                        });
                        saveToken = $timeout(function() {
                            self.attributeCategory.$$saving = true;
                            $q.all(changedRules.map(function(rule) {
                                var capturedSaveToken = saveToken;
                                return remoteActions.saveAttributeAssignmentRule(JSON.parse(angular.toJson(rule)))
                                    .then(function(newRule) {
                                        if (capturedSaveToken === saveToken) {
                                            _.assign(rule, newRule);
                                        }
                                        rule.$$originalJSON = angular.toJson(rule);
                                    }).catch(function(error) {
                                        console.log(error);
                                        rule.$$error = error;
                                        $localizable("CouldNotSave", "{1} could not be saved.", rule.Name)
                                            .then(function(label) {
                                                $sldsToast({
                                                    severity: 'error',
                                                    title: label,
                                                    icon: 'warning',
                                                    autohide: false,
                                                    content: error.message
                                                });
                                            });
                                    });
                            }))
                            .finally(function() {
                                self.attributeCategory.$$saving = false;
                            });
                        }, 1000);
                    }
                }, true);
            }
        };
    })

},{}],4:[function(require,module,exports){
'use strict';
angular.module('attributeCategoryEdit')
    .directive('categoryValueSidebar', function($timeout, fieldMetadata, fieldSetMetadata, attributeValidationService, $sldsToast) {
        return {
            restrict: 'ACE',
            scope: {},
            bindToController: {
                selectedAttribute: '=',
                attributes: '='
            },
            templateUrl: 'CategoryValueSidebar.tpl.html',
            controllerAs: 'ctrl',
            controller: function($scope) {
                var self = this;
                var dereg;

                function scrollAttributeIntoView() {
                    var target = document.getElementById('attribute-category-' + self.selectedAttribute.Id);
                    if (!target) {
                        setTimeout(scrollAttributeIntoView, 250);
                    } else if (target && (!target.scrollIntoViewIfNeeded || target.scrollIntoViewIfNeeded())) {
                        target.scrollIntoView();
                    }
                }

                this.ns = fileNsPrefix();
                this.searchText = '';
                this.fieldMetadata = fieldMetadata.Attribute;
                this.showAttribute = function(attribute) {
                    $timeout(function() {
                        attributeValidationService.isCurrentAttributeValid()
                            .then(function(valid) {
                                self.selectedAttribute = attribute;
                                $timeout(function() {
                                    scrollAttributeIntoView();
                                });
                            })
                            .catch(function(invalid) {
                                // if it's invalid show an error sldsToast
                                $sldsToast({
                                    severity: 'error',
                                    title: 'Please fix existing errors',
                                    icon: 'warning',
                                    autohide: false,
                                    content: 'Fix up errors before switching to a different attribute'
                                });
                            });
                        });
                };

                $scope.$on('attributeScrollIntoView', function() {
                    scrollAttributeIntoView();
                });

                dereg = $scope.$watch('ctrl.selectedAttribute', function(attr) {
                    if (attr) {
                        scrollAttributeIntoView();
                        dereg();
                    }
                });

                this.addNewAttribute = function() {
                    // need to use a $timeout to let the existing attribute validation kick in
                    // we can't add a new one if the currently editing one is invalid
                    $timeout(function() {
                        attributeValidationService.isCurrentAttributeValid()
                            .then(function(valid) {
                                var attribute = {
                                    Name: ''
                                };
                                fieldSetMetadata.Attribute.forEach(function(field) {
                                    if (self.fieldMetadata[field].type && fieldMetadata.Attribute[field].type.toUpperCase() === 'BOOLEAN') {
                                        attribute[field] = fieldMetadata.Attribute[field].defaultValue || false;
                                    } else if (fieldMetadata.Attribute[field].defaultValue) {
                                        attribute[field] = fieldMetadata.Attribute[field].defaultValue;
                                    }
                                });
                                attribute[self.ns + 'Code__c'] = '';
                                attribute[self.ns + 'DisplaySequence__c'] = self.attributes.length + 1;
                                self.attributes.push(attribute);
                                self.selectedAttribute = attribute;
                            })
                            .catch(function(invalid) {
                                // if it's invalid show an error sldsToast
                                $sldsToast({
                                    severity: 'error',
                                    title: 'Please fix existing errors',
                                    icon: 'warning',
                                    autohide: false,
                                    content: 'Fix up errors before creating a new attribute'
                                });
                            });
                    });
                };
            }
        };
    });

},{}],5:[function(require,module,exports){
(function() {
    'use strict';

    angular
        .module('attributeCategoryEdit')
        .service('attributeValidationService', AttributeValidationService);

    AttributeValidationService.$inject = ['$q', 'attributeCategory', '$timeout'];
    function AttributeValidationService($q, attributeCategory, $timeout) {
        var self = this;
        this.setCurrentForm = setCurrentForm;
        this.isCurrentAttributeValid = isCurrentAttributeValid;
        this.setCurrentAttributeValidating = setCurrentAttributeValidating;
        this.setCurrentAttributeValid = setCurrentAttributeValid;

        this.attributeValidating = false;
        ////////////////

        var promises = [];

        function isCurrentAttributeValid() {
            var deferred = $q.defer();
            if (attributeCategory.$$attributes.length > 0) {
                $timeout(function() {
                    if (self.form.$valid && !self.form.$pending) {
                        deferred.resolve(true);
                    } else if (self.form.$invalid) {
                        deferred.reject(false);
                    } else {
                        promises.push(deferred);
                    }
                });
            } else {
                $timeout(function() {
                    deferred.resolve(true);
                });
            }
            return deferred.promise;
        }

        function setCurrentAttributeValidating() {
            self.attributeValidating = true;
        }

        function setCurrentForm(form) {
            self.form = form;
        }

        function setCurrentAttributeValid(isValid) {
            self.attributeValidating = false;
            promises.forEach(function(promise) {
                if (isValid) {
                    promise.resolve(true);
                } else {
                    promise.reject(false);
                }
            });
            promises = [];
        }
    }
})();
},{}],6:[function(require,module,exports){
angular.module("attributeCategoryEdit").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("CategoryEditPane.tpl.html",'<style>\n    .slds-form--stacked .slds-grid .slds-size--1-of-4 .slds-checkbox {\n        margin-top: 1.75rem;\n    }\n</style>\n\n<div class="slds-panel slds-col slds-grid slds-grid--vertical slds-nowrap">\n    <div class="slds-col slds-form--stacked slds-grow slds-grid slds-grid--vertical slds-scrollable--y" ng-if="ctrl.attribute">\n        <div class="slds-panel__section slds-has-divider--bottom slds-grid">\n            <div class="slds-col slds-media slds-media--center slds-has-flexi-truncate">\n                <div class="slds-media__body slds-p-bottom--xx-small slds-truncate">\n                    <h2 title="{{ctrl.attribute.Name}}">\n                        <a href="javascript:void(0);" ng-click="ctrl.selectedAttribute(attribute)">\n                            <span class="slds-text-heading--small">{{ctrl.attribute.Name || \'&nbsp;\'}}</span>\n                        </a>\n                    </h2>\n                </div>\n            </div>\n            <div class="slds-no-flex" style="margin-top: -8px;">\n                <div class="slds-dropdown-trigger slds-dropdown-trigger--click slds-col--bump-left" ng-class="{\'slds-is-open\': ctrl.$$isOpen}" aria-expanded="true">\n                    <button class="slds-button slds-button--icon-border-filled slds-button--icon-small" aria-haspopup="true" ng-click="ctrl.$$isOpen = !ctrl.$$isOpen; $event.stopPropagation();">\n                            <slds-button-svg-icon size="\'small\'" sprite="\'utility\'" icon="\'down\'" extra-classes="\'slds-button__icon--hint\'" ></slds-button-svg-icon>\n                                <span class="slds-assistive-text">{{::$root.vlocity.getCustomLabel(\'ShowMore\', \'Show More\')}}</span>\n                        </button>\n                    <div class="slds-dropdown slds-dropdown--right slds-dropdown--actions">\n                        <ul class="dropdown__list" role="menu">\n                            <li class="slds-dropdown__item" ng-attr-title="{{::$root.vlocity.getCustomLabel(\'Delete\', \'Delete\')}}"> \n                                <a role="menuitem" href="javascript:void(0)" ng-click="ctrl.deleteAttribute(ctrl.attribute);ctrl.$$isOpen = false">\n                                    <p class="slds-truncate">{{::$root.vlocity.getCustomLabel(\'Delete\', \'Delete\')}}</p>\n                                </a>\n                            </li>\n                        </ul>\n                    </div>\n                </div>\n            </div>\n        </div>\n        <div class="slds-col slds-scrollable--y">\n            <div class="slds-panel__section" ng-form name="ctrl.attributeform" form>\n                <div class="slds-grid slds-wrap slds-grid--pull-padded">\n                    <div class="slds-p-horizontal--small slds-p-bottom--small {{field.class}}" ng-repeat="field in ctrl.form">\n                        <slds-form-element field="field" model="ctrl.attribute[field.name]" form-element-id="field.name" ng-disabled="ctrl.attribute.$$deleting" custom-validator="field.customValidator(modelValue, viewValue)" \n                        custom-validator-message="field.customValidatorMessage"></slds-form-element>\n                    </div>\n                </div>\n            </div>\n            <div class="slds-panel__section slds-p-bottom--none"> \n                <form class="vlocity-attribute-assignment-rule slds-grid slds-wrap slds-grid--pull-padded slds-border--bottom slds-p-top--large" ng-repeat="rule in ctrl.rules" ng-class="{\'slds-border--top\': $first}">\n                    <div class="slds-p-horizontal--small slds-m-bottom--small slds-size--1-of-1 slds-grid">\n                        <h3 class="slds-text-heading--small">Auto-Assignment Rule</h3>\n                        <div class="slds-dropdown-trigger slds-dropdown-trigger--click slds-col--bump-left"\n                            ng-class="{\'slds-is-open\': rule.$$isOpen}" aria-expanded="true">\n                            <button class="slds-button slds-button--icon-border-filled slds-button--icon-xx-small" aria-haspopup="true" ng-click="rule.$$isOpen = !rule.$$isOpen; $event.stopPropagation();">\n                                <slds-button-svg-icon size="\'x-small\'" sprite="\'utility\'" icon="\'down\'" extra-classes="\'slds-button__icon--hint\'"></slds-button-svg-icon>\n                                <span class="slds-assistive-text">{{::$root.vlocity.getCustomLabel(\'ShowMore\', \'Show More\')}}</span>\n                            </button>\n                            <div class="slds-dropdown slds-dropdown--right slds-dropdown--actions">\n                                <ul class="dropdown__list" role="menu">\n                                    <li class="slds-dropdown__item" ng-attr-title="{{::$root.vlocity.getCustomLabel(\'Delete\', \'Delete\')}}">\n                                        <a role="menuitem" href="javascript:void(0)" ng-click="ctrl.deleteRule(rule, $index);rule.$$isOpen = false">\n                                            <p class="slds-truncate">{{::$root.vlocity.getCustomLabel(\'Delete\', \'Delete\')}}</p>\n                                        </a>\n                                    </li>\n                                </ul>\n                            </div>\n                        </div>\n                    </div>\n                    <div class="slds-p-horizontal--small slds-p-bottom--small {{field.class}}" ng-repeat="field in ctrl.rulesForm">\n                        <slds-form-element field="field" model="rule[field.name]" ng-disabled="rule.$$deleting" label-override="field.name == (ctrl.ns + \'Service__c\') ? ctrl.getLabel(field, rule) : null"></slds-form-element>\n                    </div>\n                </form>\n                <button class="slds-button slds-m-top--x-small" ng-click="ctrl.addNewAssignmentRule()" ng-disabled="!ctrl.attribute.Id">\n            <slds-button-svg-icon sprite="\'utility\'" icon="\'new\'" size="\'medium\'" extra-classes="\'slds-button__icon--left\'"></slds-button-svg-icon>Add New Assignment Rule</button>\n            </div>\n        </div>\n    </div>\n    <div class="slds-col" ng-if="!ctrl.attribute">\n    </div>\n</div>\n'),$templateCache.put("CategoryValueSidebar.tpl.html",'<style>\n    .via-selected-item {\n        position: relative;\n    }\n    .via-selected-item:after, .via-selected-item:before {\n        right: 0;\n        top: 50%;\n        border: solid transparent;\n        content: " ";\n        height: 0;\n        width: 0;\n        position: absolute;\n        pointer-events: none;\n    }\n    .via-selected-item:after {\n        border-right-color: #FFF;\n        border-width: 16px;\n        margin-top: -16px;\n    }\n    .via-selected-item:before {\n        border-right-color: rgba(126, 126, 126, 0.2);\n        border-width: 18px;\n        margin-top: -18px;\n    }\n</style>\n<div class="slds-col slds-grid slds-grid--vertical slds-grid--vertical-stretch">\n    <div class="slds-form-element slds-p-around--small slds-col--rule-bottom" style="border-color: rgba(126, 126, 126, 0.2)">\n        <div class="slds-form-element__control slds-input-has-icon slds-input-has-icon--right">\n        <slds-input-svg-icon sprite="\'utility\'" icon="\'search\'" extra-classes="\'slds-icon-text-default\'"></slds-input-svg-icon>\n        <input ng-model="ctrl.searchText" class="slds-input" type="text" placeholder="" />\n        </div>\n    </div>\n    <ul class="slds-col slds-has-dividers--bottom slds-has-block-links--space" style="overflow-y: auto">\n        <li class="slds-item" ng-repeat="attribute in ctrl.attributes | orderBy:(ctrl.ns + \'DisplaySequence__c\') | filter:ctrl.searchText" ng-class="{\'via-selected-item\': attribute === ctrl.selectedAttribute}" id="attribute-category-{{attribute.Id}}">\n            <a href="javascript:void(0);" ng-click="ctrl.showAttribute(attribute)" class="slds-m-left--xx-small slds-m-right--xx-small">{{attribute.Name != \'\' ? attribute.Name : \'&nbsp;\'}}</a>\n        </li>\n    </ul>\n    <div class="slds-col--rule-top slds-text-align--left" style="border-color: rgba(126, 126, 126, 0.2)">\n        <button class="slds-button slds-m-around--xx-small slds-p-left--small" ng-click="ctrl.addNewAttribute()">\n            <slds-button-svg-icon sprite="\'utility\'" icon="\'new\'" size="\'medium\'" extra-classes="\'slds-button__icon--left\'"></slds-button-svg-icon>Add New Attribute</button>\n    </div>\n</div>')}]);
},{}]},{},[1]);

})();