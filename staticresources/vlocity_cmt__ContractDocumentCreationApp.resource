(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var contractDocumentCreationApp = angular.module('contractDocumentCreationApp', ['vlocity', 'viaDirectives', 'mgcrea.ngStrap', 'ngSanitize',
'ngAnimate', 'sldsangular'
]).config(['remoteActionsProvider', function(remoteActionsProvider) {
    'use strict';
    remoteActionsProvider.setRemoteActions(window.remoteActions || {});
}]);

// Factories
require('./modules/contractDocumentCreationApp/factory/ValidationErrorHandler.js');
require('./modules/contractDocumentCreationApp/factory/ReconcileChanges.js');

// Services
require('./modules/contractDocumentCreationApp/services/BrowserDetection.js');

// Controllers
// require('./modules/contractDocumentCreationApp/controller/ContractVersionPdfController.js');
require('./modules/contractDocumentCreationApp/controller/ContractDocumentCreationController.js');

// Directives
require('./modules/contractDocumentCreationApp/directive/FilePreviewEmbedSwf.js');
require('./modules/contractDocumentCreationApp/directive/VlcLoader.js');

// Components
require('./modules/contractDocumentCreationApp/component/docxTemplateComponent.js');

// Templates
require('./modules/contractDocumentCreationApp/templates/templates.js');

},{"./modules/contractDocumentCreationApp/component/docxTemplateComponent.js":2,"./modules/contractDocumentCreationApp/controller/ContractDocumentCreationController.js":3,"./modules/contractDocumentCreationApp/directive/FilePreviewEmbedSwf.js":4,"./modules/contractDocumentCreationApp/directive/VlcLoader.js":5,"./modules/contractDocumentCreationApp/factory/ReconcileChanges.js":6,"./modules/contractDocumentCreationApp/factory/ValidationErrorHandler.js":7,"./modules/contractDocumentCreationApp/services/BrowserDetection.js":8,"./modules/contractDocumentCreationApp/templates/templates.js":9}],2:[function(require,module,exports){
angular.module('contractDocumentCreationApp').component('docxTemplateComponent', {
    templateUrl: 'component/docxTemplateComponent.tpl.html',
    bindings: {
        contentVersion: '<',
        labels: '<'
    },
    controller: function($scope) {
        var ctrl = this;
    
        ctrl.$onChanges = function(changes) {
            if (changes.contentVersion) {
                $scope.contentVersion = changes.contentVersion.currentValue;
            }
            if (changes.labels) {
                $scope.labels = changes.labels.currentValue;
            }
        };
    }
});

},{}],3:[function(require,module,exports){
angular.module('contractDocumentCreationApp').controller('contractDocumentCreationCtrl', function($scope, $rootScope,
    remoteActions, ValidationErrorHandler, ReconcileChanges, browserDetection, $sldsModal) {
    'use strict';
    $scope.nameSpacePrefix = '';
    $scope.contractVersionId = '';
    $scope.editPageUrl = '';
    $scope.isSforce = (typeof sforce !== 'undefined' && typeof sforce.one !== 'undefined') ? (true) : (false);
    $scope.parentId = '';
    $scope.sourceId = '';
    $scope.versionName = '';
    $scope.docName = '';
    $scope.docType = '';
    $scope.containsRedlines = '';
    $scope.baseRequestUrl = '';
    if (window.nameSpacePrefix !== undefined) {
        $scope.nameSpacePrefix = window.nameSpacePrefix;
    }
    if (window.contractVersionId !== undefined) {
        $scope.contractVersionId = window.contractVersionId;
    }
    if (window.editSectionPage !== undefined) {
        $scope.editPageUrl = window.editSectionPage;
    }
    if (window.parentId !== undefined) {
        $scope.parentId = window.parentId;
    }
    if (window.sourceId !== undefined) {
        $scope.sourceId = window.sourceId;
    }
    if (window.versionName !== undefined) {
        $scope.versionName = window.versionName;
    }
    if (window.docName !== undefined) {
        $scope.docName = window.docName;
    }
    if (window.docType !== undefined) {
        $scope.docType = window.docType;
    }
    if (window.containsRedlines !== undefined) {
        $scope.containsRedlines = window.containsRedlines;
    }
    if (window.baseRequestUrl !== undefined) {
        $scope.baseRequestUrl = window.baseRequestUrl;
    }
    if (window.inLightningExperience !== undefined) {
        $scope.inLightningExperience = window.inLightningExperience;
    }
    $scope.vlcLoading = true;
    $scope.activeTemplates = true;
    $scope.showSuccessMessage = false;
    $scope.showRemovedMessage = false;
    $scope.validationMessage = {
        'type': 'alert-success',
        'content': '',
        'error': false
    };
    // warning message shows if sections length is 0, so we add a dummy index:
    $scope.versionData = {
        'sections': ['dataOnLoad'],
        'template': {}
    };
    $scope.originalSections = {};
    $scope.initialTemplateOption = {
        templateLabel: 'Select a Template'
    };
    $scope.versionLoadedData = {};
    $scope.contractTemplates = [];
    $scope.templateAttached = false;
    $scope.currentAttachedTemplate = undefined;
    $scope.availableTemplatesLabel = 'Available Templates';
    $scope.versionUrl = document.referrer.split('?')[0];
    $scope.newVersionId = '';
    $scope.isConsole = sforce.console.isInConsole();
    $scope.isSforce = (typeof sforce !== 'undefined' && typeof sforce.one !== 'undefined') ? (true) : (false);
    $scope.browser = browserDetection.detectBrowser();
    $scope.isSafari = ($scope.browser === 'safari') ? true : false;
    $scope.isInternetExplorer = ($scope.browser === 'msielte10' || $scope.browser === 'msiegt10') ? true : false;
    $scope.browserVersion = browserDetection.getBrowserVersion();
    $scope.labels = {};
    if (window.labels !== undefined) {
        $scope.labels = window.labels;
    }
    function refreshCurrentPrimaryTab() {
        sforce.console.getFocusedPrimaryTabId(showTabId);
    }

    function showTabId(result) {
        var tabId = result.id;
        sforce.console.refreshPrimaryTabById(tabId , true, refreshSuccess);
    }

    function refreshSuccess(result) {
        //Report whether action was successful
        if (result.success === true) {
            if ($scope.showSuccessMessage) {
                alert('Successfully Attached Template to Contract Version.');
                $scope.showSuccessMessage = false;
            } else if ($scope.showRemovedMessage) {
                alert('Successfully Removed Template from Contract Version.');
                $scope.showRemovedMessage = false;
            }
        } else {
            //alert('Primary did not refresh');
        }
    }

    /*function openVersionSubtab(result) {
        //Now that we have the primary tab ID, we can open a new subtab in it
        var primaryTabId = result.id;
        var navigateUrl = './' + $scope.parentId;
        sforce.console.openSubtab(primaryTabId , navigateUrl, true, $scope.versionName);
    }

    window.onload = function() {
        if ($scope.isConsole) {
            previewOpenSubtab();
        }
    };

    function previewOpenSubtab() {
        //First find the ID of the primary tab to put the new subtab in
        sforce.console.getEnclosingPrimaryTabId(openSubtab);
    }

    function openSubtab(result) {
        //Now that we have the primary tab ID, we can open a new subtab in it
        var primaryTabId = result.id;
        //console.log('primary tab id' + primaryTabId);
        var navigateUrl = $scope.editPageUrl + '&contractVersionId=' + $scope.newVersionId;
        sforce.console.openSubtab(primaryTabId , navigateUrl, true, 'Customize Document');
    }*/

    function getTemplateZip(result) {
        var zip = new JSZip(result.templateEncoded, {base64: true});
        return zip;
    }

    function getRelsFile(zip) {
        var file = zip.file('word/_rels/document.xml.rels');
        if (file != null) {
            return file.asText();
        }
        return '';
    }

    function generateDocx(result, type, zip) {
        var i, doc, out;
        var contractData = result.contractData;
        var imageCount = result.imageData.numImages;
        for (i = 0; i < imageCount; i++) {
            if (typeof result.imageData['imageData' + i] !== 'undefined' && result.imageData['imageData' + i] !== null) {
                zip.file('word/media/imageData' + i + '.png', result.imageData['imageData' + i], {base64: true});
            }
        }
        if (result.contractData.numberingXML !== null && result.contractData.numberingXML !== '') {
            zip.remove('word/numbering.xml');
            zip.file('word/numbering.xml',result.contractData.numberingXML,{});
        }
        if (typeof result.contractData.DocxRels !== 'undefined' && result.contractData.DocxRels !== null) {
            zip.remove('word/_rels/document.xml.rels');
            zip.file('word/_rels/document.xml.rels', result.contractData.DocxRels, {});
        }
        doc = new Docxtemplater();
        doc.loadZip(zip);
        doc.setData(contractData);
        doc.render();

        if (type === 'blob') {
            out = doc.getZip().generate({type: 'blob'});
        } else {
            out = doc.getZip().generate({type: 'base64'});
        }

        return out;
    }

    function b64toBlob(b64Data, contentType, sliceSize) {
        var byteCharacters, byteArrays, offset, slice, byteNumbers, i, byteArray, blob;
        contentType = contentType || '';
        sliceSize = sliceSize || 512;
        byteCharacters = atob(b64Data);
        byteArrays = [];

        for (offset = 0; offset < byteCharacters.length; offset += sliceSize) {
            slice = byteCharacters.slice(offset, offset + sliceSize);
            byteNumbers = new Array(slice.length);
            for (i = 0; i < slice.length; i++) {
                byteNumbers[i] = slice.charCodeAt(i);
            }
            byteArray = new Uint8Array(byteNumbers);
            byteArrays.push(byteArray);
        }
        blob = new Blob(byteArrays, {type: contentType});
        return blob;
    }

    function base64ToArrayBuffer(base64) {
        var binary_string = window.atob(base64);
        var len = binary_string.length;
        var bytes = new Uint8Array(len);
        for (var i = 0; i < len; i++) {
            bytes[i] = binary_string.charCodeAt(i);
        }
        return bytes.buffer;
    }

    //this is dupliate with navigateBack().
    /*$scope.goBack = function() {
        $scope.vlcLoading = true;
        if ($scope.isConsole) {
            //close current tab
            sforce.console.getEnclosingTabId(function(result) {
                var tabId = result.id;
                sforce.console.closeTab(tabId);
            });
            //refresh primary tab
            refreshCurrentPrimaryTab();
        } else {
            if (!$scope.isSforce) {
                window.top.location.href = $scope.baseRequestUrl + '/' + $scope.versionLoadedData.documentObj.Id;
                return false;
            } else if ($scope.isSforce) {
                sforce.one.navigateToURL($scope.baseRequestUrl + '/' + $scope.versionLoadedData.documentObj.Id);
            }
        }
    };*/

    $scope.navigateBackAndCheckin = function() {
        if ($scope.templateAttached) {
            $sldsModal({
                title: $scope.labels.clmContractDocCheckInDoc,
                templateUrl: 'checkin-modal.tpl.html',
                html: true,
                scope: $scope,
                container: 'div.vlocity',
                placement: 'center',
                prefixEvent: 'checkinModal'
            });
        } else {
            $scope.navigateBack();
        }
    };

    $scope.navigateBack = function() {
        //navigate back to page that issue send
        if ($scope.isConsole) {
            //close the preview tab
            sforce.console.getEnclosingTabId(function(result) {
                var tabId = result.id;
                sforce.console.closeTab(tabId);
            });
            refreshCurrentPrimaryTab();
        } else {
            if (!$scope.isSforce) {
                window.top.location.href = $scope.baseRequestUrl + '/' + $scope.versionLoadedData.documentObj.Id;
                return false;
            } else if ($scope.isSforce) {
                sforce.one.navigateToURL($scope.baseRequestUrl + '/' + $scope.versionLoadedData.documentObj.Id);
            }
        }
    };

    $scope.checkIn = function() {
        remoteActions.checkIn($scope.parentId).then(function(result) {
            console.log(result);
        }, function(error) {
            $scope.validationErrorHandler(error);
        });
    };

    $scope.preDownloadPdf = function() {
        if ($scope.containsRedlines) {
            $sldsModal({
                title: $scope.labels.clmContractDocDownloadPDFDoc,
                templateUrl: 'pdf-contains-redlines-modal.tpl.html',
                html: true,
                scope: $scope,
                container: 'div.vlocity',
                placement: 'center'
            });
        } else {
            $scope.downloadPdf();
        }
    };

    $scope.downloadPdf = function() {
        if ($scope.inLightningExperience) {
            $scope.downloadGeneratedFile(true);
        } else {
            remoteActions.downloadPdf($scope.parentId, $scope.docName).then(function(result) {
                var data = result;
                var blob = b64toBlob(data, 'application/pdf');
                saveAs(blob,$scope.docName + '.pdf');
            }, function(error) {
                $scope.validationErrorHandler(error);
            });
        }
    };

    $scope.preDownloadDocx = function() {
        if (!$scope.inLightningExperience && $scope.isSafari) {
            $sldsModal({
                title: $scope.labels.safariNoSupportLabel,
                template: '<div class="slds-notify_container">' +
                            '<div class="slds-notify slds-notify--alert slds-theme--error slds-theme--alert-texture" role="alert">' +
                                '<span class="slds-assistive-text">Error</span>' +
                                '<span class="slds-icon_container slds-icon-utility-ban slds-m-right_x-small" title="Error">' +
                                '<slds-svg-icon sprite="\'utility\'" icon="\'ban\'" size="\'x-small\'"></slds-svg-icon>' +
                                '</span>' +
                                '<h2>This operation is currently not supported in the Safari browser. Please use another browser like&nbsp;' +
                                '<a href="https://www.google.com/chrome/browser" target="_blank">Chrome</a>&nbsp;or&nbsp;' +
                                '<a href="https://www.mozilla.org/firefox" target="_blank">Firefox</a>.</h2>' +
                                '<button class="slds-button slds-button_icon slds-notify__close slds-button_icon-inverse" title="Close" ng-click="$hide()">' +
                                '<slds-button-svg-icon sprite="\'utility\'" icon="\'close\'" size="\'small\'"></slds-button-svg-icon>' +
                                '<span class="slds-assistive-text">Close</span>' +
                                '</button>' +
                            '</div>' +
                        '</div>',
                html: true,
                container: 'div.vlocity',
                placement: 'center'
            });
        } else {
            if ($scope.containsRedlines) {
                $sldsModal({
                    title: $scope.labels.clmContractDocDownloadWordDoc,
                    templateUrl: 'docx-contains-redlines-modal.tpl.html',
                    html: true,
                    scope: $scope,
                    container: 'div.vlocity',
                    placement: 'center'
                });
            } else {
                $scope.downloadDocx();
            }
        }
    };

    $scope.downloadDocx = function() {
        if ($scope.inLightningExperience) {
            $scope.downloadGeneratedFile(false);
        } else {
            remoteActions.getDocxTemplate($scope.parentId).then(function(result) {
                var zip = getTemplateZip(result);
                remoteActions.downloadDocx($scope.parentId, getRelsFile(zip)).then(function(resultTwo) {
                    saveAs(generateDocx(resultTwo, 'blob', zip), $scope.docName + '.docx');
                }, function(error) {
                    $scope.validationErrorHandler(error);
                });
            }, function(error) {
                $scope.validationErrorHandler(error);
            });
        }
    };

    $scope.attachPdf = function() {
        $scope.vlcLoading = true;
        remoteActions.savePdf($scope.parentId).then(function() {
            $scope.navigateBack();
        }, function(error) {
            $scope.validationErrorHandler(error);
        });
    };

    $scope.attachDocx = function() {
        $scope.vlcLoading = true;
        remoteActions.getDocxTemplate($scope.parentId).then(function(result) {
            var zip;
            if (result.errorString !== undefined) {
                alert(result.errorString);
            } else {
                zip = getTemplateZip(result);
                remoteActions.downloadDocx($scope.parentId, getRelsFile(zip)).then(function(docXresult) {
                    if (result.errorString !== undefined) {
                        alert(result.errorString);
                        $scope.vlcLoading = false;
                    } else {
                        remoteActions.attachDocx($scope.parentId, generateDocx(docXresult, 'base64', zip)).then(function(result) {
                            console.log(result);
                            $scope.navigateBack();
                        }, function(error) {
                            $scope.validationErrorHandler(error);
                        });
                    }
                }, function(error) {
                    $scope.validationErrorHandler(error);
                });
            }
        }, function(error) {
            $scope.validationErrorHandler(error);
        });
    };

    $scope.saveDocx = function() {
        window.top.location.href = $scope.baseRequestUrl + '/apex/' + $scope.nameSpaceprefix + 'ContractVersionDocxGen?Id=' + $scope.parentId;
    };

    $scope.generateFile = function() {
        $scope.vlcLoading = true;
        $scope.checkIn();
        if ($scope.docType === 'Word') {
            $scope.attachDocx();
        } else if ($scope.docType === 'PDF') {
            $scope.attachPdf();
        } else if ($scope.docType === 'Word,PDF') {
            remoteActions.savePdf($scope.parentId).then(function(result) {
                console.log(result);
            }, function(error) {
                $scope.validationErrorHandler(error);
            });
            $scope.attachDocx();
        } else if ($scope.docType === 'None') {
            $scope.navigateBack();
        }
    };

    var templateTypeCodeMap = {
        'Vlocity Web Template': 'Web',
        'Microsoft Word .DOCX Template': 'DocX'
    };

    // Need to cache already attached template data:
    // Get list of templates from the server and customize an array of objects for our select
    // dropdown. Then automatically select the default as "Select a Template"
    $scope.tabs = {};
    $scope.isReconciledView = false;
    $scope.getTemplateList = function() {
        remoteActions.getContractSectionsForVersion($scope.parentId).then(function(result) {
            $scope.versionLoadedData = result;
            console.log('INIT data: ', result);
            // Instatiating ReconcileChanges Factory:
            $scope.reconcileChanges = new ReconcileChanges($scope);
            if (window.location.search.indexOf('reconcile=true') > -1) {
                $scope.tabs.activeTab = 'Reconcile Changes';
                $scope.reconcileChanges.toggleView.label = $scope.labels.clmReconcileDocViewDoc;
                $scope.reconcileChanges.toggleView.icon = 'icon-v-view';
            } else {
                $scope.tabs.activeTab = 'Document View';
            }
            // Check if reconciled view
            if (window.location.search.indexOf('preview=true') > -1 &&
                $scope.versionLoadedData.documentVersionObj[$scope.nameSpacePrefix + 'DocumentCreationSource__c'] === 'Reconcile Word') {
                $scope.isReconciledView = true;
            }
            console.log($scope.reconcileChanges);

            if (result.contentVersionMap && result.contentVersionMap.contentVersionId) {
                $scope.generatedContentVersion = {
                    'Id': result.contentVersionMap.contentVersionId,
                    'Title': result.contentVersionMap.contentDocumentTitle
                };
                $scope.contractDocumentCollectionId = result.contentVersionMap.contractDocumentCollectionId;
                $scope.generatedContentCheckedIn = result.contentVersionMap.contentCheckedIn;
            }
        }, function(error) {
            $scope.validationErrorHandler(error);
        }).then(function() {
            var selectedTemplateLabel, selectedTemplate, i, j, temporaryObj, temporaryVersion;
            remoteActions.getTemplateList($scope.parentId).then(function(result) {
                var isTemplatePresentInList = false;
                var attachedTemplateId = $scope.versionLoadedData.documentVersionObj[$scope.nameSpacePrefix + 'DocumentTemplateId__c'];
                if (attachedTemplateId) {
                    var templateName = $scope.versionLoadedData.documentVersionObj[$scope.nameSpacePrefix + 'DocumentTemplateName__c'];
                    var templateVersion = $scope.versionLoadedData.documentVersionObj[$scope.nameSpacePrefix + 'DocumentTemplateVersion__c'];
                    var templateType = $scope.versionLoadedData.documentVersionObj[$scope.nameSpacePrefix + 'DocumentTemplateFormatType__c'];
                    selectedTemplateLabel = templateName + ' (version ' + templateVersion + ') ' + '[' + templateTypeCodeMap[templateType] + ']';
                    selectedTemplate = {
                        templateGroup: 'Attached Template',
                        templateId: attachedTemplateId,
                        templateVersion: templateVersion,
                        templateType: templateType,
                        templateLabel: selectedTemplateLabel
                    };
                }
                $scope.versionData.template = selectedTemplate;
                $scope.selectedTemplate = selectedTemplate;
                $scope.versionData.sections = $scope.versionLoadedData.documentSectionObjs;
                if ($scope.versionLoadedData.documentSectionObjs.length === 0) {
                    $scope.contractTemplates.push($scope.initialTemplateOption);
                    $scope.currentAttachedTemplate = false;
                } else {
                    $scope.currentAttachedTemplate = true;
                }
                if (result !== null) {
                    for (i = 0; i < result.length; i++) {
                        var templateType = result[i][$scope.nameSpacePrefix + 'TemplateContentFormat__c'];
                        temporaryVersion = result[i][$scope.nameSpacePrefix + 'VersionNumber__c'];
                        temporaryObj = {
                            templateLabel: result[i].Name + ' (version ' + temporaryVersion + ') [' + templateTypeCodeMap[templateType] + ']',
                            templateVersion: temporaryVersion,
                            templateId: result[i].Id,
                            templateType: templateType,
                            templateGroup: $scope.availableTemplatesLabel
                        };
                        $scope.contractTemplates.push(temporaryObj);
                        
                        if (result[i].Id === attachedTemplateId) {
                            $scope.currentAttachedTemplate = true;
                            selectedTemplate.templateType = result[i][$scope.nameSpacePrefix + 'TemplateContentFormat__c'];
                        }
                    }
                } else {
                    $scope.activeTemplates = false;
                }
                if (selectedTemplate) {
                    $scope.showWebTemplate = (selectedTemplate.templateType === 'Vlocity Web Template');
                    $scope.showDocXTemplate = (selectedTemplate.templateType === 'Microsoft Word .DOCX Template');
                }
                console.log('$scope.currentAttachedTemplate: ', $scope.currentAttachedTemplate);
                console.log('$scope.showWebTemplate: ', $scope.showWebTemplate);
                console.log('$scope.showDocXTemplate: ', $scope.showDocXTemplate);
                // Check which template to select and sections to show on page load:
                if (attachedTemplateId) {
                    if (isTemplatePresentInList) {
                        for (j = 0; j < $scope.contractTemplates.length; j++) {
                            if ($scope.contractTemplates[j].templateId === attachedTemplateId) {
                                isTemplatePresentInList = true;
                                $scope.versionData.template = $scope.contractTemplates[j];
                                $scope.selectedTemplate = $scope.contractTemplates[j];
                                $scope.contractTemplates[j].templateGroup = 'Attached Template';
                                $scope.templateAttached = true;
                            }
                        }
                    }
                } else {
                    // If there is no template ID, then we just show the default "Select a Template" in the dropdown:
                    $scope.versionData.template = $scope.contractTemplates[0];
                    $scope.selectedTemplate = $scope.contractTemplates[0];
                }
                if (!isTemplatePresentInList && attachedTemplateId) {
                    $scope.contractTemplates.push(selectedTemplate);
                    $scope.selectedTemplate = selectedTemplate;
                    $scope.templateAttached = true;
                }
                console.log('Template attached: ' + $scope.templateAttached);
                console.log($scope.versionData.template);
                console.log($scope.contractTemplates);
                console.log('Selected Template: ', $scope.selectedTemplate);
                $scope.vlcLoading = false;

                if ($scope.inLightningExperience && $scope.currentAttachedTemplate && $scope.showWebTemplate && !$scope.generatedContentVersion) {
                    remoteActions.getDocxTemplate($scope.parentId).then(function(result) {
                        var zip = getTemplateZip(result);
                        remoteActions.downloadDocx($scope.parentId, getRelsFile(zip)).then(function(resultTwo) {
                            var outputContentBlob = generateDocx(resultTwo, 'blob', zip)
                            var outputFileName = $scope.docName + '.docx';
                            var dataReader = new FileReader();
                            dataReader.addEventListener('load', function() {
                                var outputContentBase64 = dataReader.result;
                                var base64Mark = 'base64,';
                                var dataStart = outputContentBase64.indexOf(base64Mark) + base64Mark.length;
                                outputContentBase64 = outputContentBase64.substring(dataStart);
                                
                                // save the generated file as a new ContentVersion record
                                $scope.saveGeneratedDocXFile(outputFileName, outputContentBase64);
                            });
                            dataReader.readAsDataURL(outputContentBlob);
                        }, function(error) {
                            $scope.validationErrorHandler(error);
                        });
                    }, function(error) {
                        $scope.validationErrorHandler(error);
                    });
                }
            }, function(error) {
                $scope.validationErrorHandler(error);
            });
        });
    };

    this.$onInit = function() {
        $scope.getTemplateList();
    };

    $scope.changeDocumentTemplate = function(currentTemplate) {
        $scope.vlcLoading = true;
        if (currentTemplate.templateType === 'Vlocity Web Template') {
            if ($scope.templateAttached) {
                // There is an associated template, which needs to be removed first
                if ($scope.versionData.template.templateType === 'Vlocity Web Template') {
                    if ($scope.generatedContentVersion && $scope.generatedContentVersion.Id) {
                        $scope.unlinkContentVersionFromContractVersion($scope.versionLoadedData.documentVersionObj.Id, $scope.generatedContentVersion.Id, $scope.contractDocumentCollectionId, false);
                    }
                    remoteActions.removeContractSections($scope.parentId).then(function() {
                        $scope.createContractSectionsforVersion(currentTemplate);
                        $scope.showWebTemplate = true;
                        $scope.showDocXTemplate = false;
                    }, function(error) {
                        $scope.vlcLoading = false;
                        $scope.validationErrorHandler.throwError(error);
                    });
                } else if ($scope.versionData.template.templateType === 'Microsoft Word .DOCX Template') {
                    var inputData = {
                        'contractVersionId': $scope.versionLoadedData.documentVersionObj.Id,
                        'contentVersionId': $scope.generatedContentVersion.Id,
                        'contractDocumentCollectionId': $scope.contractDocumentCollectionId
                    };
                    remoteActions.unlinkContentVersionFromContractVersion(inputData).then(function(result) {
                        $scope.createContractSectionsforVersion(currentTemplate);
                        $scope.showWebTemplate = true;
                        $scope.showDocXTemplate = false;
                    }, function(error) {
                        $scope.vlcLoading = false;
                        $scope.validationErrorHandler.throwError(error);
                    });
                }
            } else {
                // There is no associated template
                $scope.createContractSectionsforVersion(currentTemplate);
                $scope.showWebTemplate = true;
                $scope.showDocXTemplate = false;
            }
        } else if (currentTemplate.templateType === 'Microsoft Word .DOCX Template') {
            if ($scope.templateAttached) {
                // There is an associated template, which needs to be removed first
                if ($scope.versionData.template.templateType === 'Vlocity Web Template') {
                    if ($scope.generatedContentVersion && $scope.generatedContentVersion.Id) {
                        $scope.unlinkContentVersionFromContractVersion($scope.versionLoadedData.documentVersionObj.Id, $scope.generatedContentVersion.Id, $scope.contractDocumentCollectionId, false);
                    }
                    remoteActions.removeContractSections($scope.parentId).then(function() {
                        $scope.getDocXTokenData($scope.versionLoadedData.documentObj.Id, currentTemplate.templateId);
                        $scope.showWebTemplate = false;
                        $scope.showDocXTemplate = true;
                    }, function(error) {
                        $scope.vlcLoading = false;
                        $scope.validationErrorHandler.throwError(error);
                    });
                } else if ($scope.versionData.template.templateType === 'Microsoft Word .DOCX Template') {
                    var inputData = {
                        'contractVersionId': $scope.versionLoadedData.documentVersionObj.Id,
                        'contentVersionId': $scope.generatedContentVersion.Id,
                        'contractDocumentCollectionId': $scope.contractDocumentCollectionId
                    };
                    remoteActions.unlinkContentVersionFromContractVersion(inputData).then(function(result) {
                        $scope.getDocXTokenData($scope.versionLoadedData.documentObj.Id, currentTemplate.templateId);
                        $scope.showWebTemplate = false;
                        $scope.showDocXTemplate = true;
                    }, function(error) {
                        $scope.vlcLoading = false;
                        $scope.validationErrorHandler.throwError(error);
                    });
                }
            } else {
                // There is no associated template
                $scope.getDocXTokenData($scope.versionLoadedData.documentObj.Id, currentTemplate.templateId);
                $scope.showWebTemplate = false;
                $scope.showDocXTemplate = true;
            }
        }
        $scope.versionData.template = currentTemplate;
    };

    // Assign sections of the selected template into a scope variable to loop through and create table
    $scope.createContractSectionsforVersion = function(currentTemplate) {
        var i, temporaryContentAttached, htmlTagRegexAttached, temporaryObjAttached, noTemplateError;
        $scope.vlcLoading = true;
        // warning message shows if sections length is 0, so we add a dummy index:
        $scope.versionData.sections = ['dataOnLoad'];
        // Load the data from the cached $scope.versionLoadedData if we are showing the attached template
        // because this data reflects any edits made to the sections and not the stored section data in
        // the template:
        if (currentTemplate.templateGroup === 'Attached Template') {
            htmlTagRegexAttached = /(<([^>]+)>)/ig;
            for (i = 0; i < $scope.versionLoadedData.documentSectionObjs.length; i++) {
                temporaryContentAttached = $scope.versionLoadedData.documentSectionObjs[i][$scope.nameSpacePrefix + 'SectionContent__c'];
                if (temporaryContentAttached) {
                    temporaryContentAttached = temporaryContentAttached.replace(htmlTagRegexAttached, '');
                }
                temporaryObjAttached = {
                    sectionName: $scope.versionLoadedData.documentSectionObjs[i].Name,
                    sectionType: $scope.versionLoadedData.documentSectionObjs[i][$scope.nameSpacePrefix + 'Type__c'],
                    sectionContent: temporaryContentAttached
                };
                $scope.versionData.sections.push(temporaryObjAttached);
                if ($scope.showSuccessMessage) {
                    $scope.validationMessage.type = 'alert-success';
                    $scope.validationMessage.content = 'Successfully Attached Template to Contract Version.';
                    $scope.showSuccessMessage = false;
                }
            }
            $scope.vlcLoading = false;
        } else if (currentTemplate.templateLabel === $scope.initialTemplateOption.templateLabel) {
            $scope.vlcLoading = false;
        } else {
            remoteActions.createContractSectionsforVersion(currentTemplate.templateId, $scope.parentId).then(function(result) {
                var i, temporaryObj, temporaryContent;
                var htmlTagRegex = /(<([^>]+)>)/ig;
                $scope.originalSections = result;
                console.log($scope.originalSections);
                console.log($scope.versionData);
                for (i = 0; i < result.documentSectionObjs.length; i++) {
                    temporaryContent = result.documentSectionObjs[i][$scope.nameSpacePrefix + 'SectionContent__c'];
                    if (temporaryContent) {
                        temporaryContent = temporaryContent.replace(htmlTagRegex, '');
                    }
                    temporaryObj = {
                        sectionName: result.documentSectionObjs[i].Name,
                        sectionType: result.documentSectionObjs[i][$scope.nameSpacePrefix + 'Type__c'],
                        sectionContent: temporaryContent
                    };
                    $scope.versionData.sections.push(temporaryObj);
                }
                $scope.vlcLoading = false;
                noTemplateError = true;
            }, function(error) {
                noTemplateError = false;
                $scope.vlcLoading = false;
                $scope.validationErrorHandler.throwError(error);
            }).then(function() {
                if (noTemplateError) {
                    // Only call if there were no errors in the previous promise:
                    $scope.saveNewDocumentSections();
                }
            });
        }
    };

    // Attach template sections to contract version
    $scope.saveNewDocumentSections = function() {
        $scope.validationMessage.content = '';
        $scope.validationMessage.error = false;
        $scope.vlcLoading = true;
        if ($scope.templateAttached) {
            console.log('if: ', $scope.versionData.template.templateId);
            remoteActions.updateContractSections($scope.versionData.template.templateId, $scope.parentId).then(function() {
                console.log('Updated contract sections');
                window.location.reload();
            }, function(error) {
                $scope.validationErrorHandler.throwError(error);
            });
        } else {
            console.log('else: ', $scope.originalSections);
            console.log($scope.contractTemplates);
            remoteActions.saveNewDocumentSections($scope.originalSections).then(function() {
                console.log('Saved new document sections');
                console.log($scope.contractTemplates);
                    window.location.reload();
            }, function(error) {
                $scope.validationErrorHandler.throwError(error);
            });
        }
    };

    $scope.removeTemplate = function() {
        if ($scope.versionData.template.templateType === 'Vlocity Web Template') {
            $scope.removeContractSections();
        } else if ($scope.versionData.template.templateType === 'Microsoft Word .DOCX Template') {
            $scope.unlinkContentVersionFromContractVersion($scope.versionLoadedData.documentVersionObj.Id, $scope.generatedContentVersion.Id, $scope.contractDocumentCollectionId, true);
        }
    };

    // Remove template and sections from version
    $scope.removeContractSections = function() {
        $scope.vlcLoading = true;
        if ($scope.generatedContentVersion && $scope.generatedContentVersion.Id) {
            $scope.unlinkContentVersionFromContractVersion($scope.versionLoadedData.documentVersionObj.Id, $scope.generatedContentVersion.Id, $scope.contractDocumentCollectionId, false);
        }
        remoteActions.removeContractSections($scope.parentId).then(function() {
            window.location.reload();
        }, function(error) {
            $scope.validationErrorHandler.throwError(error);
        });
    };

    $scope.checkInDocument = function() {
        if ($scope.versionData.template.templateType === 'Vlocity Web Template') {
            $scope.generateFile();
        } else if ($scope.versionData.template.templateType === 'Microsoft Word .DOCX Template') {
            $scope.checkInContentVersionForContractVersion($scope.versionLoadedData.documentVersionObj.Id, $scope.generatedContentVersion.Id, $scope.contractDocumentCollectionId);
        }
    };

    // Check to see if we should allow Template selection
    $scope.showTemplateSelection = function() {
        if (window.location.search.indexOf('preview=true') > -1) {
            return false;
        }
        return true;
    };

    $scope.customizeDocument = function() {
        $sldsModal({
            title: $scope.labels.clmContractCustomizeDoc,
            templateUrl: 'check-status-modal.tpl.html',
            html: true,
            scope: $scope,
            container: 'div.vlocity',
            placement: 'center'
        });
    };

    $scope.getDocXTokenData = function(contextId, templateId) {
        $scope.vlcLoading = true;
        var inputData = {
            'contextId': contextId,
            'templateId': templateId
        };
        remoteActions.getTokenData(inputData).then(function(result) {
            var contentVersionId = result.contentVersionId;
            var docXTokenData = result.tokenMap;
            console.log('docXTokenData:');
            console.log(docXTokenData);

            sforce.connection.sessionId = window.sessionId;
            var queryString = 'Select Id, Title, VersionData FROM ContentVersion where Id = \'' + contentVersionId + '\'';
            sforce.connection.query(queryString, {
                onSuccess: function(result) {
                    $scope.templateContentVersion = {
                        'Id': result.records.Id,
                        'Title': result.records.Title,
                        'VersionData': base64ToArrayBuffer(result.records.VersionData)
                    }
                    $scope.generateDocXFromTokenData($scope.templateContentVersion.VersionData, docXTokenData);
                },  
                onFailure: function(result) {
                    var errorMsg = result.faultstring;
                    console.error('errorMsg: ', errorMsg);
                    $scope.vlcLoading = false;
                }
            });
        }, function(error) {
            $scope.vlcLoading = false;
        });
    };

    $scope.generateDocXFromTokenData = function(fileContentData, docXTokenData) {
        var zip = new JSZip(fileContentData);
        var doc = new Docxtemplater();
        doc.setOptions({
            delimiters: {
                start: '{{', 
                end: '}}'
            }
        });
        doc.loadZip(zip);

        /* Update table of contents */

        //@TODO: Lots of workarounds or patchs done for updating table of contents; needs to be optimized before using
        var settings = zip.files["word/settings.xml"].asText();
        var settingsXMLDoc = $.parseXML(settings);

        var updateFieldsElement = '<w:updateFields></w:updateFields>';
        var $updateFieldsElement = $(updateFieldsElement).attr("w:val","true");
        $(settingsXMLDoc).children().append($updateFieldsElement);

        // https://github.com/open-xml-templating/docxtemplater/issues/240
        var settingsRaw = (new XMLSerializer()).serializeToString(settingsXMLDoc);
        settingsRaw = settingsRaw.replace(' xmlns="http://www.w3.org/1999/xhtml"', '');
        zip.file("word/settings.xml", settingsRaw);

        // https://blogs.msdn.microsoft.com/pfedev/2010/08/08/openxml-how-to-refresh-a-field-when-the-document-is-opened/
        var documentXML = zip.files["word/document.xml"].asText();
        // @Todo: Update only table of content fields. Code below updates all fields.
        documentXML = documentXML.replace(/<w:fldChar /g, '<w:fldChar w:dirty="true" ');
        zip.file("word/document.xml", documentXML);

        /* End of table of contents changes */

        // replace the tokens with real data in the document
        doc.setData(docXTokenData);

        try {
            // render the document
            doc.render();
        } catch (error) {
            var e = {
                message: error.message,
                name: error.name,
                stack: error.stack,
                properties: error.properties,
            };
            console.log(JSON.stringify({ error: e }));
            // The error thrown here contains additional information when logged with JSON.stringify (it contains a property object).
            throw error;
        }

        var outputFileName = $scope.docName + '.docx';
        var outputFileConfig = {
            'type': 'blob',
            'mimeType': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        };
        var outputContentBlob = doc.getZip().generate(outputFileConfig);

        var dataReader = new FileReader();
        dataReader.addEventListener('load', function() {
            var outputContentBase64 = dataReader.result;
            var base64Mark = 'base64,';
            var dataStart = outputContentBase64.indexOf(base64Mark) + base64Mark.length;
            outputContentBase64 = outputContentBase64.substring(dataStart);
            
            // save the generated file as a new ContentVersion record
            $scope.saveGeneratedDocXFile(outputFileName, outputContentBase64);
        });
        dataReader.readAsDataURL(outputContentBlob);
        //saveAs(outputContentBlob, outputFileName);
    };

    $scope.saveGeneratedDocXFile = function(fileName, fileContent) {
        sforce.connection.sessionId = window.sessionId;

        var contentVersionSObj = new sforce.SObject('ContentVersion');
        contentVersionSObj.Title = fileName;
        contentVersionSObj.PathOnClient = fileName;
        contentVersionSObj.VersionData = fileContent;

        sforce.connection.create([contentVersionSObj], {
            onSuccess: function(result) {
                var status = result[0].getBoolean('success');
                var generatedContentVersionId = result[0].id;
                console.log('generatedContentVersionId: ', generatedContentVersionId);
                $scope.generatedContentVersion = {
                    'Id': generatedContentVersionId,
                    'Title': fileName,
                    'VersionData': fileContent
                };
                $scope.linkContentVersionToContractVersion(generatedContentVersionId);
            },
            onFailure: function(result) {
                var errorMsg = result.faultstring;
                console.error('errorMsg: ', errorMsg);
                $scope.vlcLoading = false;
            }
        });
    };

    $scope.linkContentVersionToContractVersion = function(contentVersionId) {
        var inputData = {
            'contractVersionId': $scope.versionLoadedData.documentVersionObj.Id,
            'contentVersionId': contentVersionId,
            'templateId': $scope.versionData.template.templateId
        };
        remoteActions.linkContentVersionToContractVersion(inputData).then(function(result) {
            console.log('contractDocumentCollectionId:', result);
            window.location.reload();
        }, function(error) {
            $scope.vlcLoading = false;
        });
    };

    $scope.unlinkContentVersionFromContractVersion = function(contractVersionId, contentVersionId, contractDocumentCollectionId, reload) {
        $scope.vlcLoading = true;
        var inputData = {
            'contractVersionId': contractVersionId,
            'contentVersionId': contentVersionId,
            'contractDocumentCollectionId': contractDocumentCollectionId
        };
        remoteActions.unlinkContentVersionFromContractVersion(inputData).then(function(result) {
            console.log('Unlink content version result:', result);
            if (reload) {
                window.location.reload();
            }
        }, function(error) {
            $scope.vlcLoading = false;
        });
    };

    $scope.checkInContentVersionForContractVersion = function(contractVersionId, contentVersionId, contractDocumentCollectionId) {
        $scope.vlcLoading = true;
        var inputData = {
            'contractVersionId': contractVersionId,
            'contentVersionId': contentVersionId,
            'contractDocumentCollectionId': contractDocumentCollectionId
        };
        remoteActions.checkInContentVersionForContractVersion(inputData).then(function(result) {
            console.log('Check in Document results:', result);
            $scope.generatedContentCheckedIn = result;
            $scope.navigateBack();
            $scope.vlcLoading = false;
        }, function(error) {
            $scope.vlcLoading = false;
        });
    };

    $scope.downloadGeneratedFile = function(downloadPdf) {
        location.href = '/sfc/servlet.shepherd/version/download/' + $scope.generatedContentVersion.Id + '?asPdf=' + downloadPdf;
    };

    // Instantiating ValidationErrorHandler Factory:
    $scope.validationErrorHandler = new ValidationErrorHandler();
});

},{}],4:[function(require,module,exports){
angular.module('contractDocumentCreationApp').directive('filePreviewEmbedSwf', function() {
    'use strict';
    return {
        restrict: 'E',
        scope: {
            contentVersionId: '=',
            width: '=',
            height: '='
        },
        link: function(scope, elem, attrs) {
            var src = '/_swf/196007/sfc/flex/DocViewer.swf';
            var flashvars = 'shepherd_prefix=/sfc/servlet.shepherd&v=' + scope.contentVersionId + '&mode=chatterfilepreview&in_tests=false';
            var elementHTML = '<embed src="' + src + 
                                '" flashvars="' + flashvars + 
                                '" width="' + scope.width + 
                                '" height="' + scope.height + 
                                '" align="middle" id="renditionLarge" quality="high" bgcolor="#ffffff" ' + 
                                'allowscriptaccess="sameDomain" allowfullscreen="true" wmode="opaque" ' + 
                                'pluginspage="http://www.adobe.com/go/getflashplayer" type="application/x-shockwave-flash"/>'
            elem.html(elementHTML);
        }
    };
});

},{}],5:[function(require,module,exports){
angular.module('contractDocumentCreationApp').directive('vlcLoader', function() {
    'use strict';
    return {
        restrict: 'E',
        templateNamespace: 'svg',
        replace: true,
        template:
        '<svg x="0px" y="0px" width="28" height="28" viewBox="0 0 48 48">' +
            '<g width="48" height="48">' +
                '<animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 24 24" to="360 24 24" dur="0.75s" repeatCount="indefinite"/>' +
                '<path fill="#dedede" d="M24,45C12.4,45,3,35.6,3,24S12.4,3,24,3V0l0,0C10.7,0,0,10.7,0,24c0,13.3,10.7,24,24,24V45z"/>' +
                '<path fill="#05a6df" d="M24,3c11.6,0,21,9.4,21,21s-9.4,21-21,21v3l0,0c13.3,0,24-10.7,24-24C48,10.7,37.3,0,24,0V3z"/>' +
            '</g>' +
        '</svg>',
        scope: {
            stroke: '@'
        }
    };
});

},{}],6:[function(require,module,exports){
angular.module('contractDocumentCreationApp').factory('ReconcileChanges', function($sce) {
    'use strict';
    var ReconcileChanges = function(scp) {
        var self = this;
        if (window.nameSpacePrefix !== undefined) {
            this.nameSpacePrefix = window.nameSpacePrefix;
        }

        this.initialize = function() {
            // anything that immediately should fire upon instantiation
        };

        // Concatenate all regular view section content HTML
        this.getRegularView = function() {
            var i, regularView;
            regularView = '';
            for (i = 0; i < scp.versionLoadedData.reconciledDocumentSectionList.length; i++) {
                regularView += scp.versionLoadedData.reconciledDocumentSectionList[i];
            }
            return $sce.trustAsHtml(regularView);
        };

        // Concatenate all reconciled section HTML
        this.getReconciledView = function() {
            var i, reconciledView;
            reconciledView = '';
            if (scp.versionLoadedData.documentVersionObj[this.nameSpacePrefix + 'DocumentCreationSource__c'] !== 'Reconcile Word') {
                return;
            }
            for (i = 0; i < scp.versionLoadedData.documentSectionObjs.length; i++) {
                reconciledView += scp.versionLoadedData.documentSectionObjs[i][this.nameSpacePrefix + 'ReconciledSectionContent__c'];
            }
            return $sce.trustAsHtml(reconciledView);
        };

        // Set up the two tabs
        this.tabs = [{
            title: 'Document View',
            html: self.getRegularView()
        }, {
            title: 'Reconcile Changes',
            html: self.getReconciledView()
        }];

        // Toggle button label
        this.toggleView = {
            label: 'View Reconciliation Details',
            icon: 'icon-v-reconcile-word-doc'
        };

        // Toggle between views
        this.toggleContractView = function() {
            if (scp.tabs.activeTab === 'Document View') {
                scp.tabs.activeTab = 'Reconcile Changes';
                this.toggleView.label = scp.labels.clmReconcileDocViewDoc;
                this.toggleView.icon = 'icon-v-view';
            } else {
                scp.tabs.activeTab = 'Document View';
                this.toggleView.label = scp.labels.clmReconcileDocViewReconcileDetail;
                this.toggleView.icon = 'icon-v-reconcile-word-doc';
            }
        };

        // Initialize
        this.initialize();
    };
    return (ReconcileChanges);
});

},{}],7:[function(require,module,exports){
angular.module('contractDocumentCreationApp').factory('ValidationErrorHandler', function(remoteActions, $sldsModal, $rootScope) {
    'use strict';
    var ValidationErrorHandler = function() {
        this.initialize = function() {
            // anything that immediately should fire upon instantiation
        };

        // Error handling helper
        this.throwError = function(error) {
            var statusCode;
            if (!error.message) {
                error.message = 'No error message.';
            }
            if (error.statusCode) {
                statusCode = '(' + error.statusCode + '): ';
            }
            if (typeof error.type === 'string') {
                error.type = error.type.capitalizeFirstLetter() + ' ';
            }
            if (error.message.indexOf('Logged in?') > -1) {
                error.message = 'You have been logged out of Salesforce. Please back up any changes to your document and refresh your browser window to login again.';
                error.type = '';
                statusCode = '';
            }
            $sldsModal({
                title: 'There Has Been An Error',
                templateUrl: 'error-handler-modal.tpl.html',
                content: error.type + statusCode + error.message,
                html: true,
                container: 'div.vlocity',
                placement: 'center'
            });
            $rootScope.vlcLoading = false;
        };

        // Adding to String prototype:
        String.prototype.capitalizeFirstLetter = function() {
            return this.charAt(0).toUpperCase() + this.slice(1);
        };

        // Initialize
        this.initialize();
    };
    return (ValidationErrorHandler);
});

},{}],8:[function(require,module,exports){
(function() {
    'use strict';
    window.angular.module('contractDocumentCreationApp').service('browserDetection', ['$window', function($window) {
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

},{}],9:[function(require,module,exports){
angular.module("contractDocumentCreationApp").run(["$templateCache",function($templateCache){"use strict";$templateCache.put("checkin-modal.tpl.html",'<div class="slds-modal slds-fade-in-open" tabindex="-1" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n           <button class="slds-button slds-button--icon-inverse slds-modal__close" ng-click="$hide();">\n                <slds-svg-icon id="clause-page-header_icon" sprite="\'action\'" icon="\'close\'" size="\'medium\'"></slds-svg-icon>\n            </button>\n            <h4 class="slds-text-heading--medium slds-m-bottom--none" ng-bind-html="title">Warning</h4>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <p>{{labels.customizeReadyCheckInLabel}}</p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral modal-back-btn" ng-click="navigateBack(); $hide()">{{labels.noCheckInLabel}}</button>\n            <button type="button" class="slds-button slds-button--neutral modal-cancel-btn" ng-click="$hide()">{{labels.cancelLabel}}</button>\n            <button type="button" class="slds-button slds-button--brand modal-check-in-btn" ng-click="generateFile(); $hide();">{{labels.yesCheckInLabel}}</button>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("component/docxTemplateComponent.tpl.html",'<div class="document-wrapper">\n    <div class="document-container">\n        <div class="file-details" ng-if="contentVersion.Id">\n            <h3 class="slds-text-heading_small slds-m-bottom_small">{{::contentVersion.Title}}</h3>\n            <file-preview-embed-swf content-version-id="contentVersion.Id" width="\'100%\'" height="\'100%\'"></file-preview-embed-swf>\n        </div>\n    </div>\n</div>'),$templateCache.put("docx-contains-redlines-modal.tpl.html",'<div class="slds-modal slds-fade-in-open" tabindex="-1" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n           <button class="slds-button slds-button--icon-inverse slds-modal__close" ng-click="$hide();">\n                <slds-svg-icon id="clause-page-header_icon" sprite="\'action\'" icon="\'close\'" size="\'medium\'"></slds-svg-icon>\n            </button>\n            <h4 class="slds-text-heading--medium slds-m-bottom--none" ng-bind-html="title">Warning</h4>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <p>{{labels.clmContractDocWordDocRedlines}}</p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral modal-cancel-btn" ng-click="$hide()">{{labels.cancelLabel}}</button>\n            <button type="button" class="slds-button slds-button--brand modal-download-btn" ng-click="downloadDocx(); $hide();">{{labels.clmContractDocDownloadWord}}</button>\n        </div>\n    </div>\n</div>\n'),$templateCache.put("error-handler-modal.tpl.html",'<div class="slds-modal slds-fade-in-open" tabindex="-1" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n            <button class="slds-button slds-button--icon-inverse slds-modal__close" ng-click="$hide();">\n                <slds-svg-icon id="clause-page-header_icon" sprite="\'action\'" icon="\'close\'" size="\'medium\'"></slds-svg-icon>\n            </button>\n            <h4 class="slds-text-heading--medium" ng-bind-html="title">{{modalLabels.CLMTemplateDeleteSection}}</h4>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div class="slds-notify slds-notify--alert slds-theme--error slds-theme--alert-texture" role="alert">\n                <span class="slds-assistive-text">Error</span>\n                <h2>\n                    <slds-svg-icon sprite="\'utility\'" icon="\'ban\'" size="\'small\'" extra-classes="\'slds-m-right--x-small\'"></slds-svg-icon>\n                    {{content}}\n                </h2>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral modal-close-btn" ng-click="$hide()">Close</button>\n        </div>\n    </div>\n</div>\n<div class="slds-backdrop slds-backdrop--open"></div>\n'),$templateCache.put("pdf-contains-redlines-modal.tpl.html",'<div class="slds-modal slds-fade-in-open" tabindex="-1" role="dialog">\n    <div class="slds-modal__container">\n        <div class="slds-modal__header">\n           <button class="slds-button slds-button--icon-inverse slds-modal__close" ng-click="$hide();">\n                <slds-svg-icon id="clause-page-header_icon" sprite="\'action\'" icon="\'close\'" size="\'medium\'"></slds-svg-icon>\n            </button>\n            <h4 class="slds-text-heading--medium slds-m-bottom--none" ng-bind-html="title">Warning</h4>\n        </div>\n        <div class="slds-modal__content slds-p-around--medium">\n            <div>\n                <p>{{labels.clmContractDocPdfRedlines}}</p>\n            </div>\n        </div>\n        <div class="slds-modal__footer">\n            <button type="button" class="slds-button slds-button--neutral modal-cancel-btn" ng-click="$hide()">{{labels.cancelLabel}}</button>\n            <button type="button" class="slds-button slds-button--brand modal-download-btn" ng-click="downloadPdf(); $hide();">{{labels.clmContractDocDownloadYes}}</button>\n        </div>\n    </div>\n</div>\n')}]);
},{}]},{},[1]);

})();