(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('templatehome', ['sldsangular', 'drvcomp', 'ngTable', 'vlocity', 'infinite-scroll']);

require('./modules/templatehome/controller/TemplateHome.js');
require('./modules/templatehome/factory/Save.js');
require('./modules/templatehome/templates/templates.js');
},{"./modules/templatehome/controller/TemplateHome.js":2,"./modules/templatehome/factory/Save.js":3,"./modules/templatehome/templates/templates.js":4}],2:[function(require,module,exports){
angular.module('templatehome')
.controller('templatehome', ['$drvExport', '$sldsPrompt', '$scope', 'remoteActions',
                             '$filter', '$rootScope', '$drvImport', '$localizable', '$sldsModal', 'save', '$q',
    function($drvExport, $sldsPrompt, $scope, remoteActions, $filter, $rootScope, $drvImport, $localizable, $sldsModal, save, $q) {

        'use strict';
        var BASE_TEMPLATE_AUTHOR = 'Vlocity';
        $rootScope.nsPrefix = fileNsPrefix();
        remoteActions.getTemplates().then(function (templates) {
            $rootScope.templates = templates;
            $rootScope.templateTypes = [];
            $rootScope.templates.forEach(function (template) {
                if ($rootScope.templateTypes.indexOf(template[fileNsPrefix() + 'Type__c']) === -1) {
                    $rootScope.templateTypes.push(template[fileNsPrefix() + 'Type__c']);
                }
            });
        });

        remoteActions.getBaseDatapacks('DP_TEMPLATES_').then(
            function(packs){
                console.log('packs ',packs);
                $scope.additionalTableButtons = $scope.additionalTableButtons || [];
                angular.forEach(packs, function(pack, index) {
                    $localizable('InstallDataPack', 'Install {1}', pack.Name.replace('DP_TEMPLATES_',''))
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
                                            $rootScope.$broadcast('reload.table', 'template-home');
                                        }
                                    });
                                }
                            };
                            $scope.additionalTableButtons.push(tableButton);
                        });
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
                        $scope.setTemplateStatus(selectedRows, true);
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
                        $scope.setTemplateStatus(selectedRows, false);
                    },
            hide: function(row, group) {
                        return $scope.$$childHead.sldsGroupedTableParams.selected().length === 0;
                    }
        };

        $scope.additionalHeaderButtons.push(activateButton);
        $scope.additionalHeaderButtons.push(deactivateButton);

        $scope.defaultColumns = [{
            field: 'Name',
            additionalFields: [fileNsPrefix() + 'Version__c'],
            getValue: function($scope, row) {
                if (typeof sforce != "undefined" && sforce.one) {
                    return '<a onclick="sforce.one.navigateToURL(\'' + window.templatesNewUrl + '?id=' + row.Id + '\')">' +
                                        row.Name + ' (Version ' +
                                row[fileNsPrefix() + 'Version__c'] + ')</a>';
                } else {
                    return '<a href="' + window.templatesNewUrl + '?id=' + row.Id + '">' + row.Name + ' (Version ' +
                                row[fileNsPrefix() + 'Version__c'] + ')</a>';
                }
            },
            resizable: true
        }, {
            field: fileNsPrefix() + 'Type__c',
            getValue: function() {
                return '';
            },
            resizable: true
        }, {
            field: fileNsPrefix() + 'Author__c',
            resizable: true,
            width: 140,
            getGroupValue: function($scope, $group) {
                return;
            },
            getValue: function($scope, row) {
                return row[fileNsPrefix() + 'Author__c'];
            }
        }, {
            id: 'last-modifed-date',
            resizable: true,
            field: 'LastModifiedDate',
            getGroupValue: function($scope, $group) {
                return $filter('date')($group.data[0].LastModifiedDate, 'short');
            },
            getValue: function($scope, row) {
                return $filter('date')(row.LastModifiedDate, 'short');
            }
        }, {
            id: 'last-modifed-by',
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
                    return '<span class="slds-icon_container" title="Is Active"><slds-svg-icon sprite="\'utility\'" icon="\'success\'" size="\'x-small\'"  extra-classes="\'slds-icon-text-default \'"></slds-svg-icon></span>';
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
                    return '<span class="slds-icon_container" title="Is Active"><slds-svg-icon sprite="\'utility\'" icon="\'success\'" size="\'x-small\'"  extra-classes="\'slds-icon-text-default \'"></slds-svg-icon></span>';
                }
            },
            resizable: false,
            width: 110
        }];

        $localizable('DeleteTemplate', 'Delete Template?')
            .then(function(label) {
                $scope.rowActions = [{
                    type: 'export',
                    drvType: 'VlocityUITemplate'
                },{
                    type: 'delete',
                    promptTitle: label,
                    promptContent: function(row) {
                        return $localizable('DeleteTemplateConfirmation', 'Are you sure you want to delete this Template?<br/> <br/>"{1} (Version {2})" ', row.Name, row[fileNsPrefix() + 'Version__c']);
                    },
                    hide: function(row, group) {
                        return row[fileNsPrefix() + 'Active__c'];
                    },
                },{
                    text: 'Preview',
                    icon: {
                        sprite: 'utility',
                        icon: 'preview'
                    },
                    click: function(row, group) {
                        window.open('/apex/' + fileNsPrefix() + 'TemplatePreview?templateId=' +
                                            row.Id,'_blank');
                    }
                },{
                    text: 'Clone',
                    icon: {
                        sprite: 'action',
                        icon: 'clone'
                    },
                    click: function(row, group) {
                        $scope.showCloneModal(row);
                    }
                },{
                    text: 'Activate',
                    icon: {
                        sprite: 'utility',
                        icon: 'success'
                    },
                    click: function(row, group) {
                        $scope.setTemplateStatus([row.Id], true);
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
                        $scope.setTemplateStatus([row.Id], false);
                    },
                    hide: function(row, group) {
                        return !row[fileNsPrefix() + 'Active__c'];
                    }
                }];
            });

        var isSaveTemplateFieldValid = function (field) {
            if (!field) {
                return false;
            } else {
                return true;
            }
        };

        var isSaveTemplateNameAuthorUnique = function (userInputName, userInputAuthor) {
            if ($rootScope.templates.find(function (template) {
                return template.Name.toLowerCase() === userInputName.toLowerCase() && template[$rootScope.nsPrefix + 'Author__c'].toLowerCase() === userInputAuthor.toLowerCase();
            })) {
                return false;
            }
            return true;
        };

        var isSaveTemplateFieldUsingSpecialCharacters = function (userInputName) {
            var specialCharacters = /[~`!#$%\^&*+=\[\]\\';,/{}|:<>\?]/;
            if (specialCharacters.test(userInputName)) {
                return true;
            } else {
                return false;
            }
        };

        var isSaveTemplateUsingBaseTemplateAuthorName = function (userInputAuthor) {
            if (userInputAuthor.toLowerCase() === BASE_TEMPLATE_AUTHOR.toLowerCase() && $rootScope.insidePckg) {
                return true;
            } else {
                return false;
            }
         };
        $scope.showCloneModal = function(parentTemplate) {
            console.log('cloning layout parent', parentTemplate);
            remoteActions.getTemplate(parentTemplate.Id).then(
                function (template) {
                    var modal, modalScope, title = 'Clone Template';
                    modalScope = $scope.$new();
                    modalScope.$root = $rootScope;
                    modalScope.template = template;
                    modalScope.clonedTemplate = {};
                    modalScope.clonedTemplate.name = template.Name;
                    modalScope.clonedTemplate.type = template[$rootScope.nsPrefix + 'Type__c'];
                    modalScope.clonedTemplate.author = template[$rootScope.nsPrefix + 'Author__c'];
                    modalScope.saveTemplate = function(hideModal){
                        modalScope.clonedTemplate.errors = [];
                        if (!isSaveTemplateFieldValid(modalScope.clonedTemplate.name)) {
                            $localizable('SaveTemplateDialogNameMissingError',
                                'You must specify template name!').then(function (label) {
                                    modalScope.clonedTemplate.errors.push({ 'message': label });
                                });  
                        } else if (isSaveTemplateFieldUsingSpecialCharacters(modalScope.clonedTemplate.name)) {

                            $scope.saveTemplateNameInvalid = true;
                            $localizable('SaveTemplateDialogNameHasSpecialCharactersError',
                                                    'Special characters cannot be used in template name!').then(function (label) {
                                    modalScope.clonedTemplate.errors.push({ 'message': label });
                                });  

                        } else if (!isSaveTemplateNameAuthorUnique(modalScope.clonedTemplate.name, modalScope.clonedTemplate.author)) {
                            $localizable('SaveTemplateDialogError',
                                                    'A template with same name and author already exists, try creating a new version.').then(function (label) {
                                    modalScope.clonedTemplate.errors.push({ 'message': label });
                                });  
                        }
                        
                        if (!isSaveTemplateFieldValid(modalScope.clonedTemplate.type)) {
                            $localizable('SaveTemplateDialogTypeMissingError',
                                'You must specify template type!').then(function (label) {
                                    modalScope.clonedTemplate.errors.push({ 'message': label });
                                });
                        }

                        if (!isSaveTemplateFieldValid(modalScope.clonedTemplate.author)) {
                            $localizable('SaveTemplateDialogAuthorMissingError',
                                                                  'You must specify template author!').then(function (label) {
                                    modalScope.clonedTemplate.errors.push({ 'message': label });
                                });

                        } else if (isSaveTemplateUsingBaseTemplateAuthorName(modalScope.clonedTemplate.author)) {
                            $localizable('SaveTemplateDialogUsingBaseTemplateAuthorNameError',
                                                    'You must not use Base Template author name as template author!').then(function (label) {
                                    modalScope.clonedTemplate.errors.push({ 'message': label });
                                });

                        }

                        var cloneTemplate = angular.copy(modalScope.template);
                        cloneTemplate['Name'] =  modalScope.clonedTemplate.name;
                        cloneTemplate[$rootScope.nsPrefix + 'Type__c'] = modalScope.clonedTemplate.type;
                        cloneTemplate[$rootScope.nsPrefix + 'Author__c'] = modalScope.clonedTemplate.author;
                        modalScope.disableCloneBtn = true;
                        delete cloneTemplate.Id;
                        delete cloneTemplate[$rootScope.nsPrefix + 'ExternalID__c'];
                        delete cloneTemplate.originalJson;
                        cloneTemplate[$rootScope.nsPrefix + 'Version__c'] = 1;
                        cloneTemplate[$rootScope.nsPrefix + 'ParentID__c'] = modalScope.template[$rootScope.nsPrefix + 'ExternalID__c'];
                        cloneTemplate[$rootScope.nsPrefix + 'Definition__c'] = modalScope.template[$rootScope.nsPrefix + 'Definition__c'];
                        cloneTemplate[$rootScope.nsPrefix + 'Active__c'] = false;
                        save(cloneTemplate).then(function(savedTemplate) {
                            console.log('saved the new template',savedTemplate);
                            if(savedTemplate.errors){
                                modalScope.disableCloneBtn = false;
                                console.log('look at these errors',savedTemplate.errors);
                                modalScope.errors = savedTemplate.errors;
                            } else {
                                hideModal();
                                if (typeof sforce != "undefined" && sforce.one) {
                                    sforce.one.navigateToURL('/apex/' + fileNsPrefix() + 'uitemplatedesigner?id=' + savedTemplate.Id);
                                } else {
                                    window.open('/apex/' + fileNsPrefix() + 'uitemplatedesigner?id=' + savedTemplate.Id, '_current');
                                }
                            }
                        });
                    };
                    modal = $sldsModal({
                        title: title,
                        templateUrl: 'cloneModal.tpl.html',
                        show: true,
                        backdrop: 'static',
                        scope: modalScope,
                    });

                }, function (error) {
                    console.log('template retrieval error: ' + error);
             });
        };

        $scope.setTemplateStatus = function(rows, status){
            remoteActions.setTemplateStatus(rows, status).then(
                function(templates){
                    if(templates.length == 0){
                        $rootScope.$broadcast('reload.table', 'template-home');
                        return;
                    }
                    var modalScope = $scope.$new();
                    var labelPrefix = status ? 'A' : 'Dea';
                    var labelTitlePromise = $localizable(labelPrefix + 'ctivationTitle', labelPrefix + 'ctivation Error');
                    var labelBodyPromise = $localizable(labelPrefix + 'ctivateTemplatesError', 'Please select only one template of a particular name to ' + labelPrefix.toLowerCase() + 'ctivate. ' + labelPrefix + 'ctivation of templates with the same name is not allowed: {1}.?',
                                _.map(templates, 'Name').join(', '));

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
},{}],3:[function(require,module,exports){
angular.module('templatehome')
  .factory('save', function($q, $window, remoteActions, $rootScope, $timeout,
                            $localizable, fileNsPrefix) {
      'use strict';

      var sass = new Sass();
      /*remoteActions.getSassMixins().then(function(mixins) {
        $rootScope.mixins = [];
        if (mixins) {
            $rootScope.mixins = mixins;
            $rootScope.mixins.forEach(function(mixin) {
                var ngSass =
                    mixin[fileNsPrefix() + 'Sass__c'] ? htmlUnescapeFilter(mixin[fileNsPrefix() + 'Sass__c']) : '';
                sass.writeFile(mixin.Name, ngSass);
            });
        }
    });*/

      function adaptTemplateJsonForSave(json) {
        console.log('adapting json ',json);
        var pendingCompilePromise = $q(function(resolve) {
            var sawSass = false;
            var outputObject = Object.keys(json).reduce(function(outputObject, key) {
                if (/(Id|Name|__c)$/.test(key)) {
                    outputObject[key] = json[key];
                    if (/Sass__c/.test(key)) {
                        sawSass = true;
                        sass.compile(outputObject[key] || '', function(result) {
                            if (result.status === 1) {
                                json.errors = [{
                                    message: result,
                                    property: key
                                }];
                            } else if (!result.status || !json[key] || json[key] !== '') {
                                //Sass field is empty
                                outputObject[fileNsPrefix() + 'CSS__c'] = result.text ? result.text : '';
                            }
                            resolve(outputObject);
                        });
                    }
                }
                if(outputObject[fileNsPrefix() + 'Definition__c'] && typeof outputObject[fileNsPrefix() + 'Definition__c'] === 'object') {
                    outputObject[fileNsPrefix() + 'Definition__c'] = JSON.stringify(outputObject[fileNsPrefix() + 'Definition__c']);
                }
                
                return outputObject;
            }, {});
            if (!sawSass) {
                resolve(outputObject);
            }
        });
        return pendingCompilePromise;
    }

      function hasUniqueNameAndVersion(item) {
        // check template name doesn't exist already
        if ($rootScope.templates.find(function(template) {
            return template.Name.toLowerCase() === item.Name.toLowerCase() &&
                    (!item[fileNsPrefix() + 'Version__c'] ||
                      item[fileNsPrefix() + 'Version__c'] === template[fileNsPrefix() + 'Version__c']) && item[fileNsPrefix() + 'Author__c'] === template[fileNsPrefix() + 'Author__c'] &&
                    template.Id !== item.Id;
        })) {
            item.errors = [{
                message: $localizable('SaveTemplateDialogError', 'A template with same name and author already exists, try creating a new version.'),
                property: 'Name'
            }];
            return false;
        }
        return true;
    }

      function hasSpecialCharacters(item) {
        var specialCharacters = /[~`!#$%\^&*+=\[\]\\';,/{}|:<>\?]/;
        if (specialCharacters.test(item.Name)) {
            item.errors = [{
                message: $localizable('TemplateNameWithSpecialCharacters',
                                      'Special characters not allowed in name'),
                property: 'Name'
            }];
            return true;
        }
        return false; //good user input
    }

      function hasName(item) {
        if (!item.Name || item.Name === '') {
            if (item.Id) {
                item.errors = [{
                  message: $localizable('DesignerMustSetName', 'You must set a name'),
                  property: 'Name'
              }];
            }
            return false;
        }
        return true;
    }

      function hasType(item) {
        if (!item[fileNsPrefix() + 'Type__c'] || item[fileNsPrefix() + 'Type__c'] === '') {
            item.errors = [{
                message: $localizable('DesignerMustSetType', 'You must set a type'),
                property: fileNsPrefix() + 'Type__c'
            }];
            return false;
        }
        return true;
    }

      function hasOrigin(item) {
        if (!item[fileNsPrefix() + 'Author__c'] || item[fileNsPrefix() + 'Author__c'] === '') {
            item.errors = [{
                message: $localizable('DesignerMustSetType', 'You must set an author'),
                property: fileNsPrefix() + 'Author__c'
            }];
            return false;
        }
        return true;
    }

      function hasWrongOrigin(item) {
        //Temporary fix
        //TBD: Implement the check. Currently has issue
        return false;

        //End of temporary fix

        if (item.originalJson) {
            if ((item[fileNsPrefix() + 'Active__c'] != item.originalJson[fileNsPrefix() + 'Active__c']) &&
                $rootScope.insidePckg) {
                return false; //let them save when just activating a vlocity template
            }
        }
        //if(item[fileNsPrefix() + 'Author__c'].trim().toLowerCase() === 'vlocity' && $rootScope.insidePckg) {
        if ($rootScope.locked) {
            item.errors = [{
                message: $localizable('DesignerMustSetAuthor', 'You cannot set Vlocity as your author'),
                property: fileNsPrefix() + 'Author__c'
            }];
            return true;
        }
        return false;
    }

      function shouldSave(item, json) {

          if (item.saving || (item.errors && item.errors.length > 0) ||
              !hasName(item) || !hasType(item) || !hasOrigin(item) || !hasUniqueNameAndVersion(item) ||
              angular.equals(item.originalJson, json) || hasWrongOrigin(item) || hasSpecialCharacters(item)
            ) {
              return false;
          }

          item.originalJson = json;
          item.saving = true;
          item.errors = null;
          return item;
      }

      function getExternalID(template) {
        return template.Name + '/' + template[fileNsPrefix() + 'Version__c'] + '/' + template[fileNsPrefix() + 'Author__c'];
    }

      function saveTemplate(template) {
        return adaptTemplateJsonForSave(template).then(function(jsonToSave) {
            if (shouldSave(template, jsonToSave)) {
                console.log('json to save ',jsonToSave);
                template.saving = true;
                return remoteActions.saveTemplate(jsonToSave)
                  .then(function(updatedTemplate) {
                      template.saving = false;
                      console.log('saved template ',updatedTemplate);
                      $rootScope.templates.push(updatedTemplate);
                      $rootScope.$broadcast('saved', template);
                      if (updatedTemplate) {
                          template.Id = updatedTemplate.Id;
                          var existingId = $window.location.href.split(/[?&]/).find(function(item) {
                              return /^id\=/.test(item);
                          });
                          if (existingId) {
                              existingId = existingId.replace(/^id=/, '');
                          }
                          if (!existingId || existingId !== template.Id) {
                              $timeout(function() {
                                  if (existingId) {
                                      var pathname = $window.location.href.replace(existingId, template.Id);
                                      $window.history.pushState('', '', pathname);
                                  } else {
                                      var newUrl = $window.location.pathname +
                                                  ($window.location.search.length === 0 ? '?' :
                                                   $window.location.search + '&') + 'id=' + template.Id;
                                      $window.history.pushState('','', newUrl);
                                  }
                              });
                          }
                          if (updatedTemplate.errors) {
                              template.errors = updatedTemplate.errors;
                          } else if (updatedTemplate.type === 'exception') {
                              template.errors = [{
                                  message: updatedTemplate.message
                              }];
                          }
                          console.log('returning saved template ',updatedTemplate);
                          return updatedTemplate;
                      } else {
                          return template;
                      }

                  });
            } else {
                return $q.when(template);
            }
        });
    }

      return function save(template) {
        if (!template) {
            return $q.when(template);
        }
        template.errors = [];
        return saveTemplate(template);
    };
  });

},{}],4:[function(require,module,exports){
angular.module("templatehome").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("ErrorModal.tpl.html",'<div class="slds-modal slds-fade-in-open">\n  <div class="slds-modal__container">\n    <div class="slds-modal__header slds-theme--error slds-theme--alert-texture">\n        <h2 class="slds-text-heading--medium"><slds-svg-icon sprite="\'utility\'" icon="\'warning\'" size="\'small\'" extra-classes="\'slds-m-right--small slds-col slds-no-flex\'"></slds-svg-icon>{{title}}</h2>\n    </div>\n    <div class="slds-modal__content slds-p-around--x-large slds-grid slds-grid--vertical">\n        <div class="" role="alert">\n           <slds-svg-icon sprite="\'utility\'" icon="\'warning\'" size="\'small\'" extra-classes="\'slds-icon-text-error\'"></slds-svg-icon>\n            {{content}}\n        </div>\n    </div>\n    <div class="slds-modal__footer">\n        <button type="button" class="slds-button slds-button--neutral"\n            ng-click="$hide()">\n            Close\n        </button>\n    </div>\n  </div>\n</div>'),$templateCache.put("ImportProgressModal.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n  <div class="modal-dialog">\n    <div class="modal-content">\n      <div class="modal-header" ng-show="title">\n        <button type="button" class="close" aria-label="Close" ng-click="$hide()"><span aria-hidden="true">&times;</span></button>\n        <h4 class="modal-title" ng-bind="title"></h4>\n      </div>\n      <div class="modal-body">\n      \t<div class="progress">\n  \t\t  \t<div class="progress-bar" role="progressbar" aria-valuenow="{{($root.templatesProcessed.value / $root.totalTemplates)*100}}" aria-valuemin="0" \n  \t\t  \t\taria-valuemax="100" style="width: {{($root.templatesProcessed.value / $root.totalTemplates)*100}}%;">\n  \t\t  \t</div>\n\t\t    </div>\n\t\t    {{ ::\'TemplateHomeImporting\' | localize: \'Importing Templates: \' }} {{$root.templatesProcessed.value}} / {{$root.totalTemplates}}\n        <div class="list-group" ng-if="$root.templateErrors.length > 0">\n          <h5>Errors - {{$root.templateErrors.length}} found</h5>\n          <a href="#" class="list-group-item" ng-repeat="error in $root.templateErrors">\n            <h5 class="list-group-item-heading">{{error.name}}</h5>\n            <p class="list-group-item-text text-danger">{{error.message}}.</p>\n          </a>\n        </div>\n      </div>\n      <div class="modal-footer">\n        <button type="button" class="btn btn-default" ng-if="!doneImporting" ng-disabled="!doneImporting" ng-click="$hide()">{{ ::\'TemplateHomeDismiss\' | localize: \'Importing...\' }}</button>\n        <button type="button" class="btn btn-primary" ng-if="doneImporting" ng-click="$hide()">{{ ::\'TemplateHomeDone\' | localize: \'Complete!\' }}</button>\n      </div>\n    </div>\n  </div>\n</div>'),$templateCache.put("InputNewTemplateInfoModal.tpl.html",'<div class="modal vlocity" tabindex="-1" role="dialog" aria-hidden="true">\n  <div class="modal-dialog">\n    <div class="modal-content">\n      <div class="modal-header" ng-show="title">\n        <button type="button" class="close" aria-label="Close" ng-click="$hide()"><span aria-hidden="true">&times;</span></button>\n        <h4 class="modal-title" ng-bind="title"></h4>\n      </div>\n      <!--div class="modal-body" ng-bind="content"></div-->\n\n      <div class="col-sm-12">\n            <form role="form">\n              <div class="row">\n                <div class="form-group col-sm-8" ng-class="{\'has-error\': saveTemplateNameInvalid}">\n                  <label for="name">Template Name</label>\n                  <input class="form-control" ng-model="saveTemplateName" placeholder="Enter name" type="text" />\n                </div>\n                <div class="form-group col-sm-8">\n                  <div id="name-alert-container"></div>\n                </div>\n              </div>\n              <div class="row">\n                <div class="form-group col-sm-8" ng-class="{\'has-error\': saveTemplateTypeInvalid}">\n                  <label for="name">Template Type</label>\n                  <input class="form-control" ng-model="saveTemplateType" placeholder="Enter type" type="text" bs-options="type for type in $root.templateTypes" bs-typeahead />\n                </div>\n                <div class="form-group col-sm-8">\n                  <div id="type-alert-container"></div>\n                </div>\n              </div>\n              <div class="row">\n                <div class="form-group col-sm-8" ng-class="{\'has-error\': saveTemplateAuthorInvalid}">\n                  <label for="name">Author</label>\n                  <input class="form-control" ng-model="saveTemplateAuthor" type="text" />\n                </div>\n                <div class="form-group col-sm-8">\n                  <div id="author-alert-container"></div>\n                </div>\n              </div>\n            </form>\n      </div>\n\n      <div class="modal-footer">\n        <button type="button" class="btn btn-primary" ng-click="saveTemplate()">{{ ::\'SaveTemplateDialogConfirmOk\' | localize: \'Save\' }}</button>\n      </div>\n    </div>\n  </div>\n</div>'),$templateCache.put("cloneModal.tpl.html",'<div role="dialog" class="slds-modal slds-fade-in-open">\n    <div>\n        <div class="slds-modal__container">\n            <div class="slds-modal__header">\n                <h2 class="slds-text-heading--medium">CLONE TEMPLATE</h2>\n            </div>\n            <div ng-if="clonedTemplate.errors">\n                <div class="slds-notify slds-notify--alert slds-theme--error slds-theme--alert-texture" role="alert" ng-repeat="error in clonedTemplate.errors">\n                    <h2>\n                    <svg class="slds-icon slds-icon--small slds-m-right--x-small" aria-hidden="true">\n                        <use xlink:href="/assets/icons/utility-sprite/svg/symbols.svg#ban"></use>\n                    </svg>{{error.message}}</h2>\n                </div>\n            </div>\n            <div class="slds-modal__content slds-p-around--x-large" style="min-height: 200px;">\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="layoutName">Template Name</label>\n                    <div class="slds-form-element__control">\n                        <input type="text"  class="slds-input" placeholder="Enter template name" ng-model="clonedTemplate.name" required=""/>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="select-01">Template Type</label>\n                    <div class="slds-form-element__control">\n                        <select id="select-01" class="slds-select" ng-model="clonedTemplate.type">\n                            <option ng-repeat="layoutType in $root.templateTypes" value="{{layoutType}}">{{ layoutType }}</option>\n                        </select>\n                    </div>\n                </div>\n                <div class="slds-form-element">\n                    <label class="slds-form-element__label" for="layoutName">Template Author</label>\n                    <div class="slds-form-element__control">\n                        <input type="text" id="layoutName" class="slds-input"  placeholder="Enter template author"  ng-model="clonedTemplate.author" required=""/>\n                    </div>\n                </div>\n            </div>\n            <div class="slds-modal__footer">\n                <button type="button" class="slds-button slds-button--neutral"\n                        ng-click="$hide()">\n                        Close\n                </button>\n                <button type="button" ng-disabled="disableCloneBtn" class="slds-button slds-button--brand"\n                        ng-click="saveTemplate($hide);" >\n                        Clone\n                </button>\n            </div>\n        </div>\n    </div>\n</div>\n')}]);
},{}]},{},[1]);

})();