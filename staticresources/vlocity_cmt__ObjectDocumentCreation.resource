(function(){var fileNsPrefix=function(){"use strict";var scripts=document.getElementsByTagName("script");var lastScript=scripts[scripts.length-1];var scriptName=lastScript.src;var parts=scriptName.split("/");var thisScript=parts[parts.length-1];if(thisScript===""){thisScript=parts[parts.length-2]}if(scriptName.indexOf("__")!=-1&&thisScript.indexOf("__")==-1){thisScript=parts[5]&&parts[5].indexOf("__")!=-1?parts[5]:thisScript}var lowerCasePrefix=thisScript.indexOf("__")==-1?"":thisScript.substring(0,thisScript.indexOf("__")+2);lowerCasePrefix=lowerCasePrefix===""&&localStorage.getItem("nsPrefix")?localStorage.getItem("nsPrefix"):lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}if(lowerCasePrefix.length===0){return function(){lowerCasePrefix=window.nsPrefix?window.nsPrefix:lowerCasePrefix;if(lowerCasePrefix!==""){lowerCasePrefix=/__$/.test(lowerCasePrefix)?lowerCasePrefix:lowerCasePrefix+"__"}return lowerCasePrefix}}else{var resolvedNs=null;return function(){if(resolvedNs){return resolvedNs}try{var tofind=lowerCasePrefix.replace("__","");var name;var scanObjectForNs=function(object,alreadySeen){if(object&&object!==window&&alreadySeen.indexOf(object)==-1){alreadySeen.push(object);Object.keys(object).forEach(function(key){if(key==="ns"){if(typeof object[key]==="string"&&object[key].toLowerCase()===tofind){name=object[key]+"__";return false}}if(Object.prototype.toString.call(object[key])==="[object Array]"){object[key].forEach(function(value){var result=scanObjectForNs(value,alreadySeen);if(result){name=result;return false}})}else if(typeof object[key]=="object"){var result=scanObjectForNs(object[key],alreadySeen);if(result){name=result;return false}}if(name){return false}});if(name){return name}}};if(typeof Visualforce!=="undefined"){scanObjectForNs(Visualforce.remoting.Manager.providers,[])}else{return lowerCasePrefix}if(name){return resolvedNs=name}else{return resolvedNs=lowerCasePrefix}}catch(e){return lowerCasePrefix}}}}();var fileNsPrefixDot=function(){var prefix=fileNsPrefix();if(prefix.length>1){return prefix.replace("__",".")}else{return prefix}};
(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
angular.module('objectDocumentCreation', ['vlocity', 'ngSanitize', 'sldsangular'])
    .config(['remoteActionsProvider', function(remoteActionsProvider) {
        'use strict';
        var nsPrefixDotNotation = fileNsPrefixDot();
        var remoteActions = {
            createObjectDocument: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationController.createObjectDocument',
                config: {escape: false,  buffer: false}
            },
            savePdf: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationController.savePdf',
                config: {escape: false,  buffer: false}
            },
            downloadPdf: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationController.downloadPdf',
                config: {escape: false,  buffer: false}
            },
            saveDocx: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationController.saveDocx',
                config: {escape: false,  buffer: false}
            },
            getDocTemplateResource: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationController.getDocTemplateResource',
                config: {escape: false,  buffer: false}
            },
            getObjVersionDocument: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationController.getObjVersionDocument',
                config: {escape: false,  buffer: false}
            },
            deleteAttachment: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationController.deleteAttachment',
                config: {escape: false,  buffer: false}
            },
            getTokenData: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationDocxController.getTokenData',
                config: {escape: false,  buffer: false}
            },
            linkContentVersionToObject: {
                action: nsPrefixDotNotation + 'ObjectDocumentCreationDocxController.linkContentVersionToObject',
                config: {escape: false,  buffer: false}
            }
        };
        // Only desktop would need RemoteActions
        if (typeof Visualforce !== 'undefined') {
            remoteActionsProvider.setRemoteActions(remoteActions || {});
        }
    }])
    .run(['$rootScope', function($rootScope) {
        'use strict';
        $rootScope.nsPrefix = fileNsPrefix();
        $rootScope.loading = false;
    }]);

// Directives
require('./modules/objectDocumentCreation/directive/FilePreviewEmbedSwf.js');
require('./modules/objectDocumentCreation/directive/ObjectDocumentCreationDropdownHandler.js');

// Controllers
require('./modules/objectDocumentCreation/controller/ObjectDocumentCreationController.js');
require('./modules/objectDocumentCreation/controller/ObjectDocumentCreationDocXController.js');

// Templates

// Factories
require('./modules/objectDocumentCreation/factory/ObjectDocumentCreationService.js');

},{"./modules/objectDocumentCreation/controller/ObjectDocumentCreationController.js":2,"./modules/objectDocumentCreation/controller/ObjectDocumentCreationDocXController.js":3,"./modules/objectDocumentCreation/directive/FilePreviewEmbedSwf.js":4,"./modules/objectDocumentCreation/directive/ObjectDocumentCreationDropdownHandler.js":5,"./modules/objectDocumentCreation/factory/ObjectDocumentCreationService.js":6}],2:[function(require,module,exports){
angular.module('objectDocumentCreation').controller('objectDocumentCreationController',
    ['$scope', 'ObjectDocumentCreationService', function($scope, ObjectDocumentCreationService) {
    'use strict';
    $scope.objDocCreationService = ObjectDocumentCreationService;

    // Logic that decides the doctype
    $scope.dropdownItems = [];
    if ($scope.objDocCreationService.documentType === 'attachment') {
        $scope.dropdownItems = [{
            label: 'Generate PDF',
            type: 'pdf'
        }, {
            label: 'Generate Word',
            type: 'word'
        }];
    } else {
        $scope.dropdownItems = [{
            label: 'Generate ' + $scope.objDocCreationService.documentType.toUpperCase(),
            type: $scope.objDocCreationService.documentType
        }];
    }
}]);

},{}],3:[function(require,module,exports){
angular.module('objectDocumentCreation').controller('objectDocumentCreationDocXController', [
    '$scope', 'remoteActions', function($scope, remoteActions) {
    'use strict';

    function base64ToArrayBuffer(base64) {
        var binary_string = window.atob(base64);
        var len = binary_string.length;
        var bytes = new Uint8Array(len);
        for (var i = 0; i < len; i++) {
            bytes[i] = binary_string.charCodeAt(i);
        }
        return bytes.buffer;
    }

    $scope.getDocXTokenData = function(contextId, templateId, templateType) {
        $scope.vlcLoading = true;
        var inputData = {
            'contextId': contextId,
            'templateId': templateId
        };
        remoteActions.getTokenData(inputData).then(function(result) {
            var contentVersionId = result.contentVersionId;
            var docXTokenData = result.tokenMap;

            sforce.connection.sessionId = window.sessionId;
            var queryString = 'Select Id, Title, VersionData FROM ContentVersion where Id = \'' + contentVersionId + '\'';
            sforce.connection.query(queryString, {
                onSuccess: function(result) {
                    $scope.templateContentVersion = {
                        'Id': result.records.Id,
                        'Title': result.records.Title,
                        'VersionData': base64ToArrayBuffer(result.records.VersionData)
                    }
                    $scope.generateDocXFromTokenData($scope.templateContentVersion.VersionData, docXTokenData, templateType);
                },  
                onFailure: function(result) {
                    $scope.vlcLoading = false;
                    $scope.$apply();
                    var errorMsg = result.faultstring;
                    console.error('errorMsg: ', errorMsg);
                }
            });
        }, function(error) {
            $scope.vlcLoading = false;
        });
    };

    $scope.generateDocXFromTokenData = function(fileContentData, docXTokenData, templateType) {
        var zip = new JSZip(fileContentData);
        var doc = new Docxtemplater();
        doc.setOptions({
            delimiters: {
                start: '{{', 
                end: '}}'
            }
        });
        doc.loadZip(zip);

        if (templateType === 'Microsoft Word .DOCX Template') {
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
        }

        // replace the tokens with real data in the document
        doc.setData(docXTokenData);

        try {
            // render the document
            doc.render();
        } catch (error) {
            $scope.vlcLoading = false;
            console.error('DocXTemplate error:', error);
            // The error thrown here contains additional information when logged with JSON.stringify (it contains a property object).
            throw error;
        }

        var outputFileName = $scope.templateContentVersion.Title;
        var outputFileConfig;
        if (templateType === 'Microsoft Word .DOCX Template') {
            outputFileConfig = {
                'type': 'blob',
                'mimeType': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
            };
        } else if (templateType === 'Microsoft Powerpoint .PPTX Template') {
            outputFileConfig = {
                'type': 'blob',
                'mimeType': 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
            };
        }
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
                $scope.generatedContentVersion = {
                    'Id': generatedContentVersionId,
                    'Title': fileName,
                    'VersionData': fileContent
                };

                if ($scope.inTest) {
                    $scope.vlcLoading = false;
                    $scope.$apply();
                } else {
                    $scope.linkContentVersionToObject(generatedContentVersionId);
                }
            },
            onFailure: function(result) {
                $scope.vlcLoading = false;
                $scope.$apply();
                var errorMsg = result.faultstring;
                console.error('errorMsg: ', errorMsg);
            }
        });
    };

    $scope.linkContentVersionToObject = function(contentVersionId) {
        var inputData = {
            'contentVersionId': contentVersionId,
            'contextId': $scope.contextId
        };
        remoteActions.linkContentVersionToObject(inputData).then(function(result) {
            $scope.vlcLoading = false;
        }, function(error) {
            $scope.vlcLoading = false;
        });
    };

    $scope.downloadFile = function(downloadPdf) {
        location.href = '/sfc/servlet.shepherd/version/download/' + $scope.generatedContentVersion.Id + '?asPdf=' + downloadPdf;
    };

    this.$onInit = function() {
        $scope.labels = (window.labels || {});
        var vlocObjDocCreation = window.vlocObjDocCreation || {};
        $scope.contextId = vlocObjDocCreation.contextId;
        $scope.templateId = vlocObjDocCreation.templateId;
        $scope.templateType = vlocObjDocCreation.templateType;
        $scope.documentType = (vlocObjDocCreation.documentType || 'all');
        $scope.inTest = (vlocObjDocCreation.inTest && vlocObjDocCreation.inTest === 'true');

        $scope.showDownloadWord = ($scope.templateType === 'Microsoft Word .DOCX Template' && ($scope.inTest || $scope.documentType === 'all' || $scope.documentType === 'word'));
        $scope.showDownloadPPT = ($scope.templateType === 'Microsoft Powerpoint .PPTX Template' && ($scope.inTest || $scope.documentType === 'all' || $scope.documentType === 'ppt'));
        $scope.showDownloadPDF = ($scope.inTest || $scope.documentType === 'all' || $scope.documentType === 'pdf');
        
        $scope.getDocXTokenData($scope.contextId, $scope.templateId, $scope.templateType);
    };
}]);

},{}],4:[function(require,module,exports){
angular.module('objectDocumentCreation').directive('filePreviewEmbedSwf', function() {
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
angular.module('objectDocumentCreation').directive('dropdownHandler', function($document) {
    'use strict';
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var onClick = function(event) {
                var isChild = element.has(event.target).length > 0;
                var isSelf = element[0] === event.target;
                var isInside = isChild || isSelf;
                if (!isInside) {
                    scope.$apply(attrs.dropdownHandler);
                    $document.off('click', onClick);
                }
            };
            element.on('click', function() {
                $document.on('click', onClick);
            });
        }
    };
});

},{}],6:[function(require,module,exports){
angular.module('objectDocumentCreation').factory('ObjectDocumentCreationService',
['$rootScope', '$window', 'remoteActions', function($rootScope, $window, remoteActions) {
    'use strict';
    var vlocObjDocCreation = window.vlocObjDocCreation || {};
    var omniscriptPropSetMap = angular.fromJson(angular.element($('#obj-doc-creation-os-iframe', window.parent.document)).attr('vloc-prop-set'));
    var objDocLabelString = omniscriptPropSetMap.label;
    function getDocumentType() {
        if (omniscriptPropSetMap && (omniscriptPropSetMap.documentType.indexOf('pdf') > -1 && omniscriptPropSetMap.documentType.indexOf('word') > -1)) {
            return 'attachment';
        } else if (omniscriptPropSetMap && (omniscriptPropSetMap.documentType === 'pdf' || omniscriptPropSetMap.documentType === 'word')) {
            return omniscriptPropSetMap.documentType;
        } else {
            return 'pdf';
        }
    }

    function throwNotification(message, type) {
        return {
            message: message,
            type: type,
            active: true
        };
    }

    function b64toBlob(b64Data, contentType, sliceSize) {
        var byteCharacters = atob(b64Data);
        var byteArrays = [];
        var offset, slice, byteNumbers, i, byteArray, blob;
        contentType = contentType || '';
        sliceSize = sliceSize || 512;
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

    function getTemplateZip(result) {
        var zip = new JSZip(result.template, {base64: true});
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
            zip.file('word/numbering.xml', result.contractData.numberingXML, {});
        }
        if (typeof result.contractData.DocxRels !== 'undefined' && result.contractData.DocxRels !== null) {
            zip.remove('word/_rels/document.xml.rels');
            zip.file('word/_rels/document.xml.rels', result.contractData.DocxRels, {});
        }
        doc = new Docxgen(zip);
        doc.setData(contractData);
        doc.render();

        if (type === 'blob') {
            out = doc.getZip().generate({type: 'blob'});
        } else {
            out = doc.getZip().generate({type: 'base64'});
        }
        return out;
    }

    // Consolidated method (downloadAttachment) uses downloadPdf or downloadDocx in return object
    function downloadPdf() {
        remoteActions.downloadPdf(vlocObjDocCreation.parentId, vlocObjDocCreation.documentName).then(function(result) {
            var data = result;
            var blob = b64toBlob(data, 'application/pdf');
            saveAs(blob, vlocObjDocCreation.documentName + '.pdf');
        }, function(error) {
            console.log('savePdf error', error);
        });
    }

    function downloadDocx() {
        remoteActions.getDocTemplateResource(vlocObjDocCreation.templateId).then(function(result) {
            var zip = getTemplateZip(result);
            var headerString = getRelsFile(zip);
            console.log('savePdf result', result);
            if (result.errorString !== undefined) {
                alert(result.errorString);
            } else {
                remoteActions.getObjVersionDocument(vlocObjDocCreation.parentId, headerString, vlocObjDocCreation.documentName).then(function(docXresult) {
                    saveAs(generateDocx(docXresult, 'blob', zip), vlocObjDocCreation.documentName + '.docx');
                }, function(error) {
                    console.log('getObjVersionDocument error', error);
                });
            }
        }, function(error) {
            console.log('getDocTemplateResource error', error);
        });
    }

    // Service return object:
    return {
        documentType: getDocumentType(),
        attachmentId: null,
        documentGenerated: false,
        objDocLabel: objDocLabelString,
        notification: {
            message: null,
            type: 'alert-texture',
            active: false
        },
        clearNotification: function() {
            this.notification.active = false;
        },
        attachPdf: function() {
            var self = this;
            this.clearNotification();
            $rootScope.loading = true;
            remoteActions.savePdf(vlocObjDocCreation.contextId, vlocObjDocCreation.parentId, vlocObjDocCreation.documentName).then(function(result) {
                console.log('savePdf result', result);
                self.attachmentId = result;
                self.documentType = 'pdf';
                self.documentGenerated = true;
                self.notification = throwNotification('Successfully generated PDF attachment.', 'success');
                // Post the attachmentId to parent
                window.parent.postMessage({'docGenAttachmentId': self.attachmentId}, '*');
                $rootScope.loading = false;
            }, function(error) {
                console.log('savePdf error', error);
                self.notification = throwNotification('There was an error generating the PDF attachment.', 'error');
                $rootScope.loading = false;
            });
        },
        previewAttachment: function(event) {
            var self = this;
            if (!self.attachmentId || event.target.parentElement.className.indexOf('objdoc-generate-doc') > -1) {
                return;
            } else {
                $window.open(window.location.origin + '/servlet/servlet.FileDownload?file=' + self.attachmentId, '_blank');
            }
        },
        attachDocx: function() {
            var self = this;
            this.clearNotification();
            $rootScope.loading = true;
            remoteActions.getDocTemplateResource(vlocObjDocCreation.templateId).then(function(result) {
                var zip = getTemplateZip(result);
                var headerString = getRelsFile(zip);
                if (result.errorString !== undefined) {
                    alert(result.errorString);
                } else {
                    remoteActions.getObjVersionDocument(vlocObjDocCreation.parentId, headerString, vlocObjDocCreation.documentName).then(function(objResult) {
                        console.log('getObjVersionDocument', objResult);
                        remoteActions.saveDocx(vlocObjDocCreation.contextId, vlocObjDocCreation.documentName, generateDocx(objResult, 'base64', zip)).then(function(result) {
                            console.log('saveDocx result', result);
                            self.attachmentId = result;
                            self.documentGenerated = true;
                            self.documentType = 'word';
                            self.notification = throwNotification('Successfully generated WORD attachment.', 'success');
                            window.parent.postMessage({'docGenAttachmentId': self.attachmentId}, '*');
                            $rootScope.loading = false;
                        }, function(error) {
                            console.log('saveDocx error', error);
                            self.notification = throwNotification('There was an error generating the WORD attachment.', 'error');
                            $rootScope.loading = false;
                        });
                    }, function(error) {
                        console.log('getObjVersionDocument error', error);
                        self.notification = throwNotification('There was an error generating the WORD attachment.', 'error');
                        $rootScope.loading = false;
                    });
                }
            }, function(error) {
                console.log('getDocTemplateResource error', error);
                $rootScope.loading = false;
            });
        },
        downloadAttachment: function(documentType) {
            if (documentType === 'pdf') {
                downloadPdf();
            } else if (documentType === 'word') {
                downloadDocx();
            }
        },
        deleteAttachment: function() {
            var self = this;
            this.clearNotification();
            $rootScope.loading = true;
            remoteActions.deleteAttachment(self.attachmentId).then(function(result) {
                console.log('deleteAttachment result', result);
                self.documentGenerated = false;
                self.attachmentId = null;
                self.documentType = getDocumentType();
                self.notification = throwNotification('Successfully deleted the attachment.', 'success');
                $rootScope.loading = false;
            }, function(error) {
                console.log('deleteAttachment error', error);
                self.notification = throwNotification('There was an error deleting the attachment.', 'error');
                $rootScope.loading = false;
            });
        }
    };
}]);

},{}]},{},[1]);

})();