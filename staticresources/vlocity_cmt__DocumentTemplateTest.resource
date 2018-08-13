{
    "useVlocityTriggers": true,
    "status": "Error",
    "processMultiple": true,
    "primaryDataPackType": "OmniScript",
    "primaryDataPackKey": "8ca435130f9c4d1a1f3c69f6cc9ce01f",
    "maxDepth": -1,
    "isChunked": false,
    "ignoreAllErrors": false,
    "forceQueueable": false,
    "dataPacks": [
    {
        "VlocityPrimarySourceId": "a1g6A000001LWLXQA4",
        "VlocityPreviousPageKey": null,
        "VlocityMultiPackParentKey": null,
        "VlocityDepthFromPrimary": 0,
        "VlocityDataPackType": "OmniScript",
        "VlocityDataPackStatus": "Success",
        "VlocityDataPackRelationshipType": "Primary",
        "VlocityDataPackRecords": [],
        "VlocityDataPackParents": ["db82226120762786a3c1ae9a9649b267", "19795f99c02759a2216214d0508e6e5a", "52d8ead081f54da36c2336f03741504e"],
        "VlocityDataPackName": "Generic Document Generation",
        "VlocityDataPackMessage": null,
        "VlocityDataPackLabel": "OmniScript",
        "VlocityDataPackKey": "8ca435130f9c4d1a1f3c69f6cc9ce01f",
        "VlocityDataPackIsNotSupported": false,
        "VlocityDataPackIsIncluded": true,
        "VlocityDataPackData":
        {
            "VlocityDataPackRelationshipType": "Primary",
            "VlocityDataPackKey": "8ca435130f9c4d1a1f3c69f6cc9ce01f",
            "VlocityDataPackLabel": "OmniScript",
            "VlocityDataPackType": "OmniScript",
            "Id": "a1g6A000001LWLXQA4",
            "%vlocity_namespace%__OmniScript__c": [
            {
                "Id": "a1g6A000001LWLXQA4",
                "Name": "Generic Document Generation",
                "%vlocity_namespace%__CustomJavaScript__c": "baseCtrl.prototype.onSelectItemCustomized = function(control, option, index, scp, bFlip)\n        {\n            if(control === undefined || control === null || option === undefined || option === null)\n                return;\n            // multi-select, single select\n            var bSetVal = true;\n            var response = [];\n            if(bFlip)\n            {\n                if(option.vlcSelected === undefined || option.vlcSelected === null)\n                {\n                    option.vlcSelected = bSetVal;\n                }\n                else\n                {\n                    bSetVal = !option.vlcSelected;\n                    option.vlcSelected = bSetVal;\n                }\n            }\n\n            // update 'Selectable Items' response\n            var recSet = control.vlcSI[control.itemsKey];\n            // HP bug, use $$hashKey to check\n            for(var i=0; i<recSet.length; i++)\n            {\n                if(option.$$hashKey !== recSet[i].$$hashKey && bFlip && bSetVal && control.propSetMap.selectMode === 'Single')\n                     recSet[i].vlcSelected = false;\n                if(recSet[i].vlcSelected === true)\n                {\n                    recSet[i].Status = 'Inactive';\n                    response.push(recSet[i]);\n                }\n            }\n\n            if(response.length > 0)\n                control.response = response;\n            else\n                control.response = null;\n\n            if(control.propSetMap.dataJSON === true)\n                scp.aggregate(scp, control.index, control.indexInParent, true, -1);\n        };\n\n\n  baseCtrl.prototype.setIPScope = function(scp)\n{\n    window.VlocOmniSI = scp;\n    var afterSlash = '/' + window.location.href.split('.com/')[1].split('/')[0];\n    if (afterSlash === 'apex') {\n        afterSlash = '';\n    }\n   scp.applyCallResp({'urlPrefix':window.location.origin + afterSlash});\n}\n\n    window.top.addEventListener('message', function(event){\n             if(event.data && event.data.constructor===Object && event.data.hasOwnProperty(\"docGenAttachmentId\") ){\n              window.VlocOmniSI.applyCallResp(event.data);\n        }\n    }, false);",
                "%vlocity_namespace%__IsProcedure__c": false,
                "%vlocity_namespace%__IsReusable__c": false,
                "%vlocity_namespace%__Language__c": "English",
                "%vlocity_namespace%__PropertySet__c": "{\"includeCustomization\":true,\"persistentComponent\":[{\"render\":false,\"label\":\"\",\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteTimeout\":30000,\"remoteOptions\":{\"preTransformBundle\":\"\",\"postTransformBundle\":\"\"},\"preTransformBundle\":\"\",\"postTransformBundle\":\"\",\"sendJSONPath\":\"\",\"sendJSONNode\":\"\",\"responseJSONPath\":\"\",\"responseJSONNode\":\"\",\"id\":\"vlcCart\",\"itemsKey\":\"cartItems\",\"modalConfigurationSetting\":{\"modalHTMLTemplateId\":\"vlcProductConfig.html\",\"modalController\":\"ModalProductCtrl\",\"modalSize\":\"lg\"}},{\"render\":false,\"label\":\"\",\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteTimeout\":30000,\"remoteOptions\":{\"preTransformBundle\":\"\",\"postTransformBundle\":\"\"},\"preTransformBundle\":\"\",\"postTransformBundle\":\"\",\"id\":\"vlcKnowledge\",\"itemsKey\":\"knowledgeItems\",\"modalConfigurationSetting\":{\"modalHTMLTemplateId\":\"\",\"modalController\":\"\",\"modalSize\":\"lg\"}}],\"allowSaveForLater\":true,\"saveNameTemplate\":null,\"saveExpireInDays\":null,\"saveForLaterRedirectPageName\":\"sflRedirect\",\"saveForLaterRedirectTemplateUrl\":\"vlcSaveForLaterAcknowledge.html\",\"saveContentEncoded\":false,\"autoSaveOnStepNext\":false,\"elementTypeToHTMLTemplateMapping\":{},\"seedDataJSON\":{\"inTest\":false},\"enableKnowledge\":false,\"knowledgeArticleTypeQueryFieldsMap\":{},\"timeTracking\":true,\"customPages\":{\"ContractPreview\":\"%vlocity_namespace%__ContractAmendmentPreview?verticalMode=true\"},\"visualforcePagesAvailableInPreview\":{},\"cancelType\":\"SObject\",\"cancelSource\":\"%ContextId%\",\"cancelRedirectPageName\":\"OmniScriptCancelled\",\"cancelRedirectTemplateUrl\":\"vlcCancelled.html\",\"saveObjectId\":\"%ContextId%\",\"trackingCustomData\":{},\"consoleTabLabel\":\"New\",\"wpm\":false,\"ssm\":false,\"message\":{},\"autoFocus\":false,\"saveURLPatterns\":{},\"currencyCode\":\"\",\"showInputWidth\":false,\"hideStepChart\":false,\"rtpSeed\":false,\"consoleTabTitle\":null,\"consoleTabIcon\":\"custom:custom18\"}",
                "%vlocity_namespace%__SubType__c": "Generation",
                "%vlocity_namespace%__TestHTMLTemplates__c": "<script type=\"text/ng-template\" id=\"navButton.html\">\n   <fieldset>\n         <button style=\"margin-top:2em\" create-document >Generate Document</button>\n   </fieldset>\n</script>\n<script type=\"text/ng-template\" id=\"templates.html\">\n            <div class='slds-col--padded slds-size--1-of-1'>\n              <table class=\"slds-table slds-table--bordered slds-table--cell-buffer vlc-slds-table\">\n              <thead>\n                <tr class=\"slds-text-heading--label\">\n                  <th width=\"20px\"/>\n                  <th scope=\"col\">\n                    <div class=\"slds-truncate\">Template Name</div>\n                  </th>\n                 <th scope=\"col\">\n                    <div class=\"slds-truncate\">Version Number</div>\n                 </th>               \n               </tr>\n             </thead>\n             <tbody>\n               <tr ng-repeat='p in control.vlcSI[control.itemsKey]' ng-class=\"{ 'vlc-selectableitem-selected' : p.vlcSelected }\" >\n                 <th class=\"slds-cell-shrink\">\n                    <label class=\"slds-checkbox\">\n                        <input type=\"checkbox\" ng-model='p.vlcSelected' ng-change='onSelectItem(control, p, $index, this)'/>\n                        <span class=\"slds-checkbox--faux\"></span>\n                        <span class=\"slds-assistive-text\">Select</span>\n                    </label>\n                </th>\n                <td>\n                    <div class=\"slds-truncate\">{{p['Name']}}</div>\n                </td>\n                <td>\n                    <div class=\"slds-truncate\">{{p['VersionNumber']}}</div>\n                </td>\n            </tr>\n        </tbody>\n    </table>\n</div>\n</script>\n <script type=\"text/ng-template\" id=\"iframe.html\">\n     <div ng-if=\"baseCtrl.setIPScope(this)\"></div>\n       <iframe ng-if=\"bpTree.response.docId\" ng-show=\"src = bpTree.response.urlPrefix + '/apex/%vlocity_namespace%__ObjectDocumentCreation?id='+bpTree.response.docId+'&templateId='+bpTree.response.templateId+'&documentName='+bpTree.response.documentName+'&contextId='+bpTree.response.qId\" id=\"obj-doc-creation-os-iframe\" ng-src=\"{{src}}\" style=\"width: 100%; border: none;\" height=\"0\" onload=\"this.height = '200';\" vloc-prop-set=\"{{control.propSetMap}}\"></iframe>\n </script>",
                "%vlocity_namespace%__Type__c": "Generic Document",
                "%vlocity_namespace%__Version__c": 2,
                "%vlocity_namespace%__IsActive__c": true,
                "%vlocity_namespace%__Element__c": [
                {
                    "Id": "a1d6A000000BAcLQAW",
                    "Name": "PickTemplate",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 0,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 4,
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"=\",\"field\":\"templateId\",\"data\":null}]}},\"label\":\"Pick a template\",\"validationRequired\":true,\"previousLabel\":\"Previous\",\"previousWidth\":3,\"nextLabel\":\"Next\",\"nextWidth\":3,\"cancelLabel\":\"Cancel\",\"cancelMessage\":\"Are you sure?\",\"saveLabel\":\"Save for later\",\"saveMessage\":\"Are you sure you want to save it for later?\",\"completeLabel\":\"Complete\",\"completeMessage\":\"Are you sure you want to complete the script?\",\"instruction\":\"<p>(Allow only one template to be selected)</p>\",\"showPersistentComponent\":[false,false],\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteTimeout\":30000,\"remoteOptions\":{},\"knowledgeOptions\":{\"language\":\"English\",\"publishStatus\":\"Online\",\"keyword\":\"\",\"dataCategoryCriteria\":\"\",\"remoteTimeout\":30000},\"conditionType\":\"Hide if False\"}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Step",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcLQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__ParentElementId__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcMQAW",
                    "Name": "CreateObjDocument",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 0,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 6,
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"=\",\"field\":\"TemplateType\",\"data\":\"Vlocity Web Template\"}]}},\"label\":null,\"controlWidth\":12,\"remoteClass\":\"ObjectDocumentService\",\"remoteMethod\":\"createObjectDocument\",\"remoteOptions\":{\"preTransformBundle\":\"\",\"postTransformBundle\":\"\",\"contextId\":\"%qId%\",\"templateId\":\"%templateId%\",\"useTemplateDRExtract\":\"Yes\"},\"remoteTimeout\":30000,\"preTransformBundle\":\"\",\"postTransformBundle\":\"\",\"sendJSONPath\":\"\",\"sendJSONNode\":\"\",\"responseJSONPath\":\"\",\"responseJSONNode\":\"\",\"inProgressMessage\":\"In Progress\",\"postMessage\":\"Done\",\"failureNextLabel\":\"Continue\",\"failureAbortLabel\":\"Abort\",\"failureAbortMessage\":\"Are you sure?\",\"validationRequired\":\"None\",\"redirectPageName\":\"\",\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPreviousLabel\":\"Previous\",\"redirectPreviousWidth\":3,\"showPersistentComponent\":[false,false],\"HTMLTemplateId\":\"\",\"wpm\":false,\"ssm\":false,\"message\":{},\"extraPayload\":{}}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Remote Action",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcMQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__ParentElementId__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcNQAW",
                    "Name": "Set Values",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 0,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 5,
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":null,\"label\":null,\"controlWidth\":12,\"validationRequired\":\"None\",\"elementValueMap\":{\"templateId\":\"=IF(%templateId% == null, %PickTemplate|1:DocumentTemplate|1:Id%, %templateId%)\",\"qId\":\"=%EnterObject:ObjectId%\",\"templateType\":\"=%TemplateType%\",\"documentType\":\"='all'\",\"inTest\":\"=%inTest%\"},\"showPersistentComponent\":[false,false],\"HTMLTemplateId\":\"\",\"wpm\":false,\"ssm\":false,\"message\":{}}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Set Values",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcNQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__ParentElementId__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcOQAW",
                    "Name": "Email",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 1,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 3,
                    "%vlocity_namespace%__ParentElementId__c":
                    {
                        "Name": "Generate Document",
                        "%vlocity_namespace%__OmniScriptId__c": "a1g6A000001LWLXQA4",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcJQAW"
                    },
                    "%vlocity_namespace%__ParentElementName__c": "Generate Document",
                    "%vlocity_namespace%__ParentElementType__c": "Step",
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"=\",\"field\":\"inTest\",\"data\":\"false\"}]}},\"label\":\"Email\",\"controlWidth\":12,\"useTemplate\":false,\"emailTemplateInformation\":{\"emailTemplateName\":\"\",\"emailTargetObjectId\":\"\",\"saveAsActivity\":false,\"whatId\":\"\"},\"emailInformation\":{\"toAddressList\":[],\"ccAddressList\":[],\"bccAddressList\":[],\"emailSubject\":\"This is a test email\",\"emailBody\":\"This is a test email\",\"setHtmlBody\":false},\"fileAttachments\":\"\",\"staticDocList\":[],\"docList\":\"\",\"attachmentList\":\"%docGenAttachmentId%\",\"remoteTimeout\":30000,\"inProgressMessage\":\"In Progress\",\"postMessage\":\"Done\",\"failureNextLabel\":\"Continue\",\"failureAbortLabel\":\"Abort\",\"failureAbortMessage\":\"Are you sure?\",\"validationRequired\":\"Step\",\"redirectPageName\":\"\",\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPreviousLabel\":\"Previous\",\"redirectPreviousWidth\":3,\"showPersistentComponent\":[false,false],\"HTMLTemplateId\":\"\",\"wpm\":false,\"ssm\":false,\"message\":{}}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Email Action",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcOQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcQQAW",
                    "Name": "GenerateDocumentWebTemplate",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 1,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 2,
                    "%vlocity_namespace%__ParentElementId__c":
                    {
                        "Name": "Generate Document",
                        "%vlocity_namespace%__OmniScriptId__c": "a1g6A000001LWLXQA4",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcJQAW"
                    },
                    "%vlocity_namespace%__ParentElementName__c": "Generate Document",
                    "%vlocity_namespace%__ParentElementType__c": "Step",
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":{\"group\":{\"operator\":\"OR\",\"rules\":[{\"condition\":\"=\",\"field\":\"TemplateType\",\"data\":\"Vlocity Web Template\"}]}},\"label\":\"Proposal\",\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteOptions\":{\"preTransformBundle\":\"\",\"postTransformBundle\":\"\"},\"remoteTimeout\":30000,\"preTransformBundle\":\"\",\"postTransformBundle\":\"\",\"sendJSONPath\":\"\",\"sendJSONNode\":\"\",\"responseJSONPath\":\"\",\"responseJSONNode\":\"\",\"HTMLTemplateId\":\"object-document-creation-default\",\"accessibleInFutureSteps\":false,\"documentType\":\"pdf,word\",\"disOnTplt\":false}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Input Block",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcQQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcRQAW",
                    "Name": "Pick a Template Type",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 0,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 2,
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":{\"group\":{\"operator\":\"AND\",\"rules\":[{\"condition\":\"=\",\"field\":\"inTest\",\"data\":\"false\"}]}},\"label\":\"Pick a Template Type\",\"disOnTplt\":false,\"validationRequired\":true,\"previousLabel\":\"Previous\",\"previousWidth\":3,\"nextLabel\":\"Next\",\"nextWidth\":3,\"cancelLabel\":\"Cancel\",\"cancelMessage\":\"Are you sure?\",\"saveLabel\":\"Save for later\",\"saveMessage\":\"Are you sure you want to save it for later?\",\"completeLabel\":\"Complete\",\"completeMessage\":\"Are you sure you want to complete the script?\",\"instruction\":\"\",\"showPersistentComponent\":[false,false],\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteTimeout\":30000,\"remoteOptions\":{},\"knowledgeOptions\":{\"language\":\"English\",\"publishStatus\":\"Online\",\"keyword\":\"\",\"dataCategoryCriteria\":\"\",\"remoteTimeout\":30000},\"conditionType\":\"Hide if False\",\"HTMLTemplateId\":\"\"}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Step",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcRQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__ParentElementId__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcPQAW",
                    "Name": "ObjectId",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 1,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 1,
                    "%vlocity_namespace%__ParentElementId__c":
                    {
                        "Name": "EnterObject",
                        "%vlocity_namespace%__OmniScriptId__c": "a1g6A000001LWLXQA4",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcSQAW"
                    },
                    "%vlocity_namespace%__ParentElementName__c": "EnterObject",
                    "%vlocity_namespace%__ParentElementType__c": "Step",
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":null,\"label\":\"Object Id\",\"disOnTplt\":false,\"controlWidth\":12,\"showInputWidth\":false,\"inputWidth\":12,\"required\":false,\"repeat\":false,\"repeatClone\":false,\"readOnly\":false,\"help\":false,\"helpText\":\"\",\"mask\":\"\",\"pattern\":\"\",\"ptrnErrText\":\"\",\"minLength\":0,\"maxLength\":255,\"conditionType\":\"Hide if False\",\"accessibleInFutureSteps\":false,\"debounceValue\":0,\"HTMLTemplateId\":\"\",\"hide\":false}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Text",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcPQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcSQAW",
                    "Name": "EnterObject",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 0,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 1,
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":null,\"label\":\"Enter Object Id\",\"disOnTplt\":false,\"validationRequired\":true,\"previousLabel\":\"Previous\",\"previousWidth\":3,\"nextLabel\":\"Next\",\"nextWidth\":3,\"cancelLabel\":\"Cancel\",\"cancelMessage\":\"Are you sure?\",\"saveLabel\":\"Save for later\",\"saveMessage\":\"Are you sure you want to save it for later?\",\"completeLabel\":\"Complete\",\"completeMessage\":\"Are you sure you want to complete the script?\",\"showPersistentComponent\":[false,false],\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteTimeout\":30000,\"remoteOptions\":{},\"knowledgeOptions\":{\"language\":\"English\",\"publishStatus\":\"Online\",\"keyword\":\"\",\"dataCategoryCriteria\":\"\",\"remoteTimeout\":30000},\"conditionType\":\"Hide if False\"}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Step",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcSQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__ParentElementId__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcTQAW",
                    "Name": "TemplateType",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 1,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 1,
                    "%vlocity_namespace%__ParentElementId__c":
                    {
                        "Name": "Pick a Template Type",
                        "%vlocity_namespace%__OmniScriptId__c":
                        {
                            "Name": "Generic Document Generation",
                            "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                            "VlocityDataPackType": "VlocityMatchingKeyObject",
                            "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                        },
                        "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcRQAW"
                    },
                    "%vlocity_namespace%__ParentElementName__c": "Pick a Template Type",
                    "%vlocity_namespace%__ParentElementType__c": "Step",
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":null,\"label\":\"Template Types\",\"disOnTplt\":false,\"controlWidth\":12,\"showInputWidth\":false,\"inputWidth\":12,\"required\":false,\"repeat\":false,\"repeatClone\":false,\"readOnly\":false,\"help\":false,\"helpText\":\"\",\"options\":[{\"name\":\"Vlocity Web Template\",\"value\":\"Vlocity Web Template\"},{\"name\":\"Microsoft Word .DOCX Template\",\"value\":\"Microsoft Word .DOCX Template\"},{\"name\":\"Microsoft Powerpoint .PPTX Template\",\"value\":\"Microsoft Powerpoint .PPTX Template\"}],\"optionSource\":{\"type\":\"\",\"source\":\"\"},\"controllingField\":{\"element\":\"\",\"type\":\"\",\"source\":\"\"},\"conditionType\":\"Hide if False\",\"accessibleInFutureSteps\":false,\"HTMLTemplateId\":\"\",\"hide\":false}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Select",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcTQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcHQAW",
                    "Name": "DocumentTemplate",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 1,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 1,
                    "%vlocity_namespace%__ParentElementId__c":
                    {
                        "Name": "PickTemplate",
                        "%vlocity_namespace%__OmniScriptId__c":
                        {
                            "Name": "Generic Document Generation",
                            "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                            "VlocityDataPackType": "VlocityMatchingKeyObject",
                            "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                        },
                        "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcLQAW"
                    },
                    "%vlocity_namespace%__ParentElementName__c": "PickTemplate",
                    "%vlocity_namespace%__ParentElementType__c": "Step",
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":null,\"label\":\"Templates\",\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteOptions\":{\"preTransformBundle\":\"\",\"postTransformBundle\":\"\"},\"remoteTimeout\":30000,\"preTransformBundle\":\"\",\"postTransformBundle\":\"\",\"sendJSONPath\":\"\",\"sendJSONNode\":\"\",\"responseJSONPath\":\"\",\"responseJSONNode\":\"\",\"HTMLTemplateId\":\"templates.html\",\"itemsKey\":\"recSet\",\"selectMode\":\"Single\",\"dataJSON\":true,\"modalHTMLTemplateId\":\"vlcModalContent.html\",\"modalController\":\"ModalInstanceCtrl\",\"modalSize\":\"\",\"maxCompareSize\":4,\"modalConfigurationSetting\":{\"modalHTMLTemplateId\":\"vlcProductConfig.html\",\"modalController\":\"ModalProductCtrl\",\"modalSize\":\"lg\"},\"accessibleInFutureSteps\":true}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Selectable Items",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcHQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcJQAW",
                    "Name": "Generate Document",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 0,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 7,
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":null,\"label\":\"Generate Document\",\"validationRequired\":true,\"previousLabel\":\"Previous\",\"previousWidth\":3,\"nextLabel\":\"Next\",\"nextWidth\":3,\"cancelLabel\":\"Cancel\",\"cancelMessage\":\"Are you sure?\",\"saveLabel\":\"Save for later\",\"saveMessage\":\"Are you sure you want to save it for later?\",\"completeLabel\":\"Complete\",\"completeMessage\":\"Are you sure you want to complete the script?\",\"instruction\":\"\",\"showPersistentComponent\":[false,false],\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteTimeout\":30000,\"remoteOptions\":{},\"knowledgeOptions\":{\"language\":\"English\",\"publishStatus\":\"Online\",\"keyword\":\"\",\"dataCategoryCriteria\":\"\",\"remoteTimeout\":30000},\"conditionType\":\"Hide if False\",\"HTMLTemplateId\":\"\"}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Step",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcJQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__ParentElementId__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcIQAW",
                    "Name": "GenerateDocumentWordPPT",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 1,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 1,
                    "%vlocity_namespace%__ParentElementId__c":
                    {
                        "Name": "Generate Document",
                        "%vlocity_namespace%__OmniScriptId__c": "a1g6A000001LWLXQA4",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcJQAW"
                    },
                    "%vlocity_namespace%__ParentElementName__c": "Generate Document",
                    "%vlocity_namespace%__ParentElementType__c": "Step",
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":{\"group\":{\"operator\":\"OR\",\"rules\":[{\"condition\":\"=\",\"field\":\"TemplateType\",\"data\":\"Microsoft Word .DOCX Template\"},{\"condition\":\"=\",\"field\":\"TemplateType\",\"data\":\"Microsoft Powerpoint .PPTX Template\"}]}},\"label\":\"Proposal\",\"remoteClass\":\"\",\"remoteMethod\":\"\",\"remoteOptions\":{\"preTransformBundle\":\"\",\"postTransformBundle\":\"\"},\"remoteTimeout\":30000,\"preTransformBundle\":\"\",\"postTransformBundle\":\"\",\"sendJSONPath\":\"\",\"sendJSONNode\":\"\",\"responseJSONPath\":\"\",\"responseJSONNode\":\"\",\"HTMLTemplateId\":\"object-document-creation-docx-template\",\"accessibleInFutureSteps\":false,\"documentType\":\"word\",\"disOnTplt\":false}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "Input Block",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcIQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                },
                {
                    "Id": "a1d6A000000BAcKQAW",
                    "Name": "GetDocumentTemplates",
                    "%vlocity_namespace%__OmniScriptId__c":
                    {
                        "Name": "Generic Document Generation",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                        "VlocityDataPackType": "VlocityMatchingKeyObject",
                        "VlocityMatchingRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4"
                    },
                    "%vlocity_namespace%__Active__c": true,
                    "%vlocity_namespace%__Level__c": 0,
                    "%vlocity_namespace%__OmniScriptVersion__c": 2,
                    "%vlocity_namespace%__Order__c": 3,
                    "%vlocity_namespace%__PropertySet__c": "{\"show\":null,\"label\":\"Get Document Templates\",\"controlWidth\":12,\"bundle\":\"GetDocumentTemplatesForType\",\"dataRaptor Input Parameters\":[{\"inputParam\":\"templateType\",\"element\":\"TemplateType\"}],\"remoteTimeout\":30000,\"responseJSONPath\":\"\",\"responseJSONNode\":\"\",\"inProgressMessage\":\"In Progress\",\"postMessage\":\"Done\",\"failureNextLabel\":\"Continue\",\"failureAbortLabel\":\"Abort\",\"failureAbortMessage\":\"Are you sure?\",\"validationRequired\":\"None\",\"redirectPageName\":\"\",\"redirectTemplateUrl\":\"vlcAcknowledge.html\",\"redirectNextLabel\":\"Next\",\"redirectNextWidth\":3,\"redirectPreviousLabel\":\"Previous\",\"redirectPreviousWidth\":3,\"showPersistentComponent\":[false,false],\"wpm\":false,\"ssm\":false,\"message\":{}}",
                    "%vlocity_namespace%__ReusableOmniScript__c": false,
                    "%vlocity_namespace%__Type__c": "DataRaptor Extract Action",
                    "VlocityRecordSObjectType": "%vlocity_namespace%__Element__c",
                    "VlocityDataPackType": "SObject",
                    "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1d6A000000BAcKQAW",
                    "VlocityDataPackIsIncluded": true,
                    "%vlocity_namespace%__InternalNotes__c": "",
                    "%vlocity_namespace%__ParentElementId__c": "",
                    "%vlocity_namespace%__SearchKey__c": ""
                }],
                "VlocityRecordSObjectType": "%vlocity_namespace%__OmniScript__c",
                "VlocityDataPackType": "SObject",
                "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1g6A000001LWLXQA4",
                "VlocityDataPackIsIncluded": true,
                "%vlocity_namespace%__AdditionalInformation__c": "",
                "%vlocity_namespace%__DataRaptorBundleId__c": "",
                "%vlocity_namespace%__ProcedureKey__c": ""
            }],
            "VlocityDataPackIsIncluded": true
        },
        "VlocityDataPackAllRelationships":
        {
            "07af904f110d4f86c81113064f3b9d5e": "Reference by Salesforce Id",
            "db82226120762786a3c1ae9a9649b267": "Reference by Salesforce Id",
            "19795f99c02759a2216214d0508e6e5a": "Reference by Salesforce Id",
            "52d8ead081f54da36c2336f03741504e": "Reference by Salesforce Id",
            "b3d6579be526107e15325522e99a94ab": "Reference by Name"
        },
        "DataPackAttachmentSize": 32560,
        "DataPackAttachmentParentId": "a156A000002rhB9QAI",
        "DataPackAttachmentId": "00P6A000009DuwfUAC",
        "ActivationStatus": "Ready"
    }],
    "dataPackId": "a156A000002rhB9QAI",
    "alreadyExportedKeys": [],
    "name": "Generic Document Generation",
    "version": 1
}