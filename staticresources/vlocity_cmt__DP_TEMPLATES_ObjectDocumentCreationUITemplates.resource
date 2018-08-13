{
    "dataPackId": "",
    "dataPacks": [
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__CustomJavascript__c": "baseCtrl.prototype.setIPScope = function(scp) {\n    'use strict';\n    var afterSlash = '/' + window.location.href.split('.com/')[1].split('/')[0];\n    window.VlocOmniSI = scp;\n    if (afterSlash === 'apex') {\n        afterSlash = '';\n    }\n    scp.applyCallResp({\n        urlPrefix: window.location.origin + afterSlash\n    });\n\n    window.addEventListener('message', function(event) {\n        if (event.data && event.data.constructor === Object && event.data.hasOwnProperty('docGenAttachmentId')) {\n            window.VlocOmniSI.applyCallResp(event.data);\n        }\n    }, false);\n};\n",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "",
                        "%vlocity_namespace%__ExternalID__c": "object-document-creation-default/1/Vlocity/1494014625407",
                        "%vlocity_namespace%__HTML__c": "<div ng-if=\"baseCtrl.setIPScope(this)\"></div>\n<iframe ng-if=\"bpTree.response.docId\" ng-show=\"src = bpTree.response.urlPrefix + '/apex/' + baseCtrl.$scope.nsPrefix + 'ObjectDocumentCreation?id='+bpTree.response.docId+'&templateId='+bpTree.response.templateId+'&documentName='+bpTree.response.documentName+'&contextId='+bpTree.response.qId\" id=\"obj-doc-creation-os-iframe\" ng-src=\"{{src}}\" style=\"width: 100%; border: none;\" height=\"0\" onload=\"this.height = '200';\" vloc-prop-set=\"{{control.propSetMap}}\"></iframe>",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__SampleJson__c": "{\n    \"AddToCart\": \"Add to Cart\",\n    \"OmniMonthly\": \"Monthly Cost\",\n    \"OmniOneTime\": \"One Time Cost\",\n    \"control\": {\n        \"itemsKey\": \"results\",\n        \"propSetMap\": {\n            \"label\": \"Property Label\"\n        },\n        \"vlcSI\": {\n            \"results\": [\n                {\n                    \"Description\": \"Product Description\",\n                    \"MonthlyCost\": 20,\n                    \"Name\": \"Product Name\",\n                    \"OneTimeCost\": 100,\n                    \"added\": false\n                }\n            ]\n        }\n    }\n}",
                        "%vlocity_namespace%__Type__c": "OmniScript Selectable Items",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "object-document-creation-default",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/object-document-creation-default/%vlocity_namespace%__VlocityUITemplate__c/object-document-creation-default"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/object-document-creation-default",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/object-document-creation-default",
            "VlocityDataPackName": "object-document-creation-default",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUITemplate__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__CustomJavascript__c": "baseCtrl.prototype.setIPScope = function(scp) {\n    'use strict';\n    var afterSlash = '/' + window.location.href.split('.com/')[1].split('/')[0];\n    window.VlocOmniSI = scp;\n    if (afterSlash === 'apex') {\n        afterSlash = '';\n    }\n    scp.applyCallResp({\n        urlPrefix: window.location.origin + afterSlash\n    });\n\n    window.addEventListener('message', function(event) {\n        if (event.data && event.data.constructor === Object && event.data.hasOwnProperty('docGenAttachmentId')) {\n            window.VlocOmniSI.applyCallResp(event.data);\n        }\n    }, false);\n};",
                        "%vlocity_namespace%__Definition__c": "",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__DisplayOn__c": "",
                        "%vlocity_namespace%__ExternalID__c": "object-document-creation-docx-template/1/Vlocity/1522774559577",
                        "%vlocity_namespace%__HTML__c": "<div ng-if=\"baseCtrl.setIPScope(this)\"></div>\n<iframe ng-show=\"src = bpTree.response.urlPrefix + '/apex/' + baseCtrl.$scope.nsPrefix + 'ObjectDocumentCreationDocXTemplate?contextId='+bpTree.response.qId+'&templateId='+bpTree.response.templateId+'&templateType='+bpTree.response.templateType+'&documentType='+bpTree.response.documentType+'&inTest='+bpTree.response.inTest+'&customClass='+bpTree.response.customClass+'&customMethod='+bpTree.response.customMethod\" id=\"obj-doc-creation-docx-os-iframe\" ng-src=\"{{src}}\" style=\"width: 100%; border: none;\" height=\"0\" onload=\"this.height = '500';\" vloc-prop-set=\"{{control.propSetMap}}\"></iframe>",
                        "%vlocity_namespace%__ParentID__c": "object-document-creation-default/1/Vlocity/1494014625407",
                        "%vlocity_namespace%__SampleJson__c": "{\n    \"AddToCart\": \"Add to Cart\",\n    \"OmniMonthly\": \"Monthly Cost\",\n    \"OmniOneTime\": \"One Time Cost\",\n    \"control\": {\n        \"itemsKey\": \"results\",\n        \"propSetMap\": {\n            \"label\": \"Property Label\"\n        },\n        \"vlcSI\": {\n            \"results\": [\n                {\n                    \"Description\": \"Product Description\",\n                    \"MonthlyCost\": 20,\n                    \"Name\": \"Product Name\",\n                    \"OneTimeCost\": 100,\n                    \"added\": false\n                }\n            ]\n        }\n    }\n}",
                        "%vlocity_namespace%__Type__c": "OmniScript Selectable Items",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "object-document-creation-docx-template",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUITemplate__c",
                        "VlocityRecordSourceKey": "VlocityUITemplate/object-document-creation-docx-template/%vlocity_namespace%__VlocityUITemplate__c/object-document-creation-docx-template"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUITemplate/object-document-creation-docx-template",
                "VlocityDataPackType": "VlocityUITemplate"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUITemplate/object-document-creation-docx-template",
            "VlocityDataPackName": "object-document-creation-docx-template",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUITemplate"
        }
    ],
    "name": "ObjectDocumentCreation",
    "primaryDataPackKey": "VlocityDeploy",
    "processMultiple": true,
    "status": "Complete",
    "version": 1
}