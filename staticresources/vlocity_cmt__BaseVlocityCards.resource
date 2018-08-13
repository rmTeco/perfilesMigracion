{
  "status": "Saved",
  "primaryDataPackKey": "909fa223ac4b5ae772ed1f3febd55850",
  "dataPacks": [
    {
      "VlocityPrimarySourceId": null,
      "VlocityDataPackType": "MultiPack",
      "VlocityDataPackStatus": "Hidden",
      "VlocityDataPackRelationshipType": "Primary",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "MultiPack",
      "VlocityDataPackKey": "909fa223ac4b5ae772ed1f3febd55850",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPacksToCombine": [
          "a1815000001Tp0PAAS",
          "a1815000001Tp0KAAS",
          "a1815000001TpLQAA0",
          "a1815000001TpYDAA0"
        ],
        "VlocityCombinedDataPackEntries": [
          {
            "CreatedBy": "Diego Garcia",
            "CreatedDate": "2016-05-06T20:32:06.000Z",
            "LastModifiedBy": "Diego Garcia",
            "LastModifiedDate": "2016-05-06T20:33:12.000Z",
            "Type": "Export",
            "Version": 1,
            "Source": "Local",
            "Status": "Published",
            "Description": "Default Grid layout for Vlocity Cards",
            "Name": "Console Cards Layout",
            "Id": "a1815000001Tp0PAAS"
          },
          {
            "Id": "a1815000001Tp0KAAS",
            "Name": "Console Sidebar Layout",
            "Description": null,
            "Status": "Published",
            "Source": "Local",
            "Version": 1,
            "Type": "Export",
            "LastModifiedDate": "2016-05-06T20:30:47.000Z",
            "LastModifiedBy": "Diego Garcia",
            "CreatedDate": "2016-05-06T20:26:30.000Z",
            "CreatedBy": "Diego Garcia"
          },
          {
            "CreatedBy": "Diego Garcia",
            "CreatedDate": "2016-05-09T14:09:41.000Z",
            "LastModifiedBy": "Diego Garcia",
            "LastModifiedDate": "2016-05-09T22:59:45.000Z",
            "Type": "Export",
            "Version": 1,
            "Source": "Local",
            "Status": "Published",
            "Description": null,
            "Name": "Community Content Layout",
            "Id": "a1815000001TpLQAA0"
          },
          {
            "Id": "a1815000001TpYDAA0",
            "Name": "community-content-layout-flyout-sample",
            "Description": null,
            "Status": "Published",
            "Source": "Local",
            "Version": 2,
            "Type": "Export",
            "LastModifiedDate": "2016-05-09T23:00:20.000Z",
            "LastModifiedBy": "Diego Garcia",
            "CreatedDate": "2016-05-09T22:59:55.000Z",
            "CreatedBy": "Diego Garcia"
          }
        ],
        "VlocityDataPacksAlreadyAdded": [
          "a1815000001Tp0PAAS",
          "a1815000001Tp0KAAS",
          "a1815000001TpLQAA0",
          "a1815000001TpYDAA0"
        ]
      }
    },
    {
      "VlocityPrimarySourceId": "a0m15000004r4LHAAY",
      "VlocityDataPackType": "VlocityUILayout",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Id: a0m15000004r4LHAAY",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity UI Layout",
      "VlocityDataPackKey": "1e86b654ec00e85ed5691c0fc9e15463",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "%vlocity_namespace%__VlocityUILayout__c": [
          {
            "%vlocity_namespace%__Type__c": "Layout",
            "%vlocity_namespace%__Version__c": 1,
            "%vlocity_namespace%__Active__c": true,
            "%vlocity_namespace%__Definition__c": "{\"Cards\":[\"Contact\"],\"templates\":{\"0\":{\"templateUrl\":\"card-canvas\"}},\"dataSource\":{\"type\":\"Query\",\"value\":{\"query\":\"SELECT Id, Name FROM Contact WHERE AccountId = '{{params.id}}'\"},\"contextVariables\":[{\"name\":\"params.id\",\"val\":\"0011500001ChJqa\"}]}}",
            "Name": "Grid",
            "Id": "a0m15000004r4LHAAY",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0m15000004r4LHAAY",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "Id": "a0m15000004r4LHAAY",
        "VlocityDataPackType": "VlocityUILayout",
        "VlocityDataPackLabel": "Vlocity UI Layout",
        "VlocityDataPackKey": "1e86b654ec00e85ed5691c0fc9e15463",
        "VlocityDataPackRelationshipType": "Primary",
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a0l1500000HD0FnAAL",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Contact",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "4537fa5f3f77c17f6b84042b80b3832d",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "4537fa5f3f77c17f6b84042b80b3832d",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Contact",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0l1500000HD0FnAAL",
            "Id": "a0l1500000HD0FnAAL",
            "Name": "Contact",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['Id']\",\"label\":\"Id\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true},{\"name\":\"['Name']\",\"label\":\"Name\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Active\",\"templateUrl\":\"card-active\"}],\"filter\":{},\"title\":\"Contact\"}",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a0m150000079wtxAAA",
      "VlocityDataPackType": "VlocityUILayout",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Id: a0m150000079wtxAAA",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity UI Layout",
      "VlocityDataPackKey": "28f96d6a200dd3b68a01cd125aae43b3",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackIsIncluded": true,
        "VlocityDataPackRelationshipType": "Primary",
        "VlocityDataPackKey": "28f96d6a200dd3b68a01cd125aae43b3",
        "VlocityDataPackLabel": "Vlocity UI Layout",
        "VlocityDataPackType": "VlocityUILayout",
        "Id": "a0m150000079wtxAAA",
        "%vlocity_namespace%__VlocityUILayout__c": [
          {
            "VlocityDataPackIsIncluded": true,
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0m150000079wtxAAA",
            "Id": "a0m150000079wtxAAA",
            "Name": "console-sidebar",
            "%vlocity_namespace%__Definition__c": "{\"Cards\":[\"profile-account\",\"profile-account-info\"],\"templates\":{\"0\":{\"templateUrl\":\"console-sidebar\"}},\"dataSource\":{\"type\":\"Query\",\"value\":{\"query\":\"SELECT Id, Name, BillingAddress,Phone, PhotoURL, Website FROM Account WHERE Id = '{{params.id}}'\"}}}",
            "%vlocity_namespace%__Active__c": true,
            "%vlocity_namespace%__Version__c": 1,
            "%vlocity_namespace%__Type__c": "Layout"
          }
        ]
      }
    },
    {
      "VlocityPrimarySourceId": "a0l15000007pMPEAA2",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "profile-account",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "a4090528422760d542ce61d14856c2ef",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackIsIncluded": true,
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityDataPackIsIncluded": true,
            "%vlocity_namespace%__Definition__c": "{\"title\":\"Profile\",\"filter\":{\"attributes\":{\"type\":\"Account\"}},\"definedActions\":[{\"filter\":\"$scope.data.status == 'active'\",\"actionIds\":[{\"type\":\"Vlocity Action\",\"id\":\"Add\"}]}],\"templates\":[{\"filter\":\"$scope.data.status == 'active'\",\"templateUrl\":\"left-profile\"},{\"filter\":\"$scope.data.status == 'non-existent'\",\"templateUrl\":\"left-profile\"}],\"Alerts\":[],\"dataSource\":{\"type\":null,\"value\":{\"query\":\"SELECT Id, Name, BillingAddress, Phone, PhotoURL, Website FROM Account WHERE Id = '{{params.id}}'\"},\"contextVariables\":[{\"name\":\"params.id\",\"val\":\"0011500001ChJqa\"}]},\"states\":[{\"filter\":\"$scope.data.status == 'active'\",\"templateUrl\":\"left-profile\",\"flyout\":\"\",\"alerts\":[],\"fields\":[],\"definedActions\":{\"actions\":[]},\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"blankStateCheck\":false,\"name\":\"active\"}]}",
            "Name": "profile-account",
            "Id": "a0l15000007pMPEAA2",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0l15000007pMPEAA2",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c"
          }
        ],
        "Id": "profile-account",
        "VlocityDataPackType": "VlocityCard",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackKey": "a4090528422760d542ce61d14856c2ef",
        "VlocityDataPackRelationshipType": "Sibling"
      }
    },
    {
      "VlocityPrimarySourceId": "a0l15000007pMPJAA2",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "profile-account-info",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "8915df1abe5ccb2adf56f4d29de60b86",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackIsIncluded": true,
        "Id": "profile-account-info",
        "VlocityDataPackType": "VlocityCard",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackKey": "8915df1abe5ccb2adf56f4d29de60b86",
        "VlocityDataPackRelationshipType": "Sibling",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityDataPackIsIncluded": true,
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0l15000007pMPJAA2",
            "Id": "a0l15000007pMPJAA2",
            "Name": "profile-account-info",
            "%vlocity_namespace%__Definition__c": "{\"title\":\"Profile\",\"filter\":{\"attributes\":{\"type\":\"Account\"}},\"templates\":[{\"filter\":\"$scope.data.status == 'active'\",\"templateUrl\":\"left-account-info\"},{\"filter\":\"$scope.data.status == 'non-existent'\",\"templateUrl\":\"left-account-info\"}],\"Alerts\":[],\"dataSource\":{\"type\":null,\"value\":{\"query\":\"\"},\"contextVariables\":[{\"name\":\"params.id\",\"val\":\"0011500001ChJqa\"}]},\"states\":[{\"filter\":\"$scope.data.status == 'active'\",\"templateUrl\":\"left-account-info\",\"flyout\":\"\",\"alerts\":[],\"fields\":[],\"definedActions\":{\"actions\":[]},\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"blankStateCheck\":false,\"name\":\"active\",\"collapse\":false}],\"definedActions\":[{\"filter\":\"$scope.data.status == 'active'\",\"actionIds\":[{\"type\":\"Vlocity Action\",\"id\":\"Add\"}]}]}"
          }
        ]
      }
    },
    {
      "VlocityPrimarySourceId": "a0m150000079I3mAAE",
      "VlocityDataPackType": "VlocityUILayout",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Id: a0m150000079I3mAAE",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity UI Layout",
      "VlocityDataPackKey": "af22a378bdc4fa6bcdcd8ffd7619c99f",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Primary",
        "VlocityDataPackKey": "af22a378bdc4fa6bcdcd8ffd7619c99f",
        "VlocityDataPackLabel": "Vlocity UI Layout",
        "VlocityDataPackType": "VlocityUILayout",
        "Id": "a0m150000079I3mAAE",
        "%vlocity_namespace%__VlocityUILayout__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0m150000079I3mAAE",
            "Id": "a0m150000079I3mAAE",
            "Name": "community-content-layout",
            "%vlocity_namespace%__Definition__c": "{\"Title\":\"New Layout\",\"Filter\":\"\",\"Context\":\"\",\"Cards\":[\"Community-account-card-sample\"],\"templates\":[{\"filter\":{},\"templateUrl\":\"community-content-detail\"}],\"dataSource\":{\"type\":\"Query\",\"value\":{\"query\":\"SELECT AccountNumber,AccountSource,AnnualRevenue,BillingAddress,BillingCity,BillingCountry,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,CreatedById,CreatedDate,Description,Fax,Industry,IsCustomerPortal,IsDeleted,IsPartner,Name,Phone,PhotoUrl,Rating,RecordTypeId,ShippingAddress,ShippingCity,ShippingCountry,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,Website FROM Account LIMIT 5\"}}}",
            "%vlocity_namespace%__Active__c": true,
            "%vlocity_namespace%__Version__c": 1,
            "%vlocity_namespace%__Type__c": "Layout",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a0l1500000HDGUUAA5",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Community-account-card-sample",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "f24b4397ce5a16af47df72cd2bacaa36",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['Name']\",\"label\":\"Name\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true},{\"name\":\"['Phone']\",\"label\":\"Phone\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true},{\"name\":\"['Website']\",\"label\":\"Website\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true},{\"name\":\"['Industry']\",\"label\":\"Industry\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true},{\"name\":\"['AccountNumber']\",\"label\":\"AccountNumber\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Account state\",\"templateUrl\":\"community-content-account\",\"sObjectType\":\"Account\",\"flyout\":{\"layout\":\"community-content-layout-flyout-sample\",\"data\":\"$scope.data\"}}],\"filter\":{},\"title\":\"Community Account Card Sample\"}",
            "Name": "Community-account-card-sample",
            "Id": "a0l1500000HDGUUAA5",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0l1500000HDGUUAA5",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "Id": "Community-account-card-sample",
        "VlocityDataPackType": "VlocityCard",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackKey": "f24b4397ce5a16af47df72cd2bacaa36",
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a0m15000004r4RPAAY",
      "VlocityDataPackType": "VlocityUILayout",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Id: a0m15000004r4RPAAY",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity UI Layout",
      "VlocityDataPackKey": "6410436a9cf6e4c68254b908ee034876",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackIsIncluded": true,
        "VlocityDataPackRelationshipType": "Primary",
        "VlocityDataPackKey": "6410436a9cf6e4c68254b908ee034876",
        "VlocityDataPackLabel": "Vlocity UI Layout",
        "VlocityDataPackType": "VlocityUILayout",
        "Id": "a0m15000004r4RPAAY",
        "%vlocity_namespace%__VlocityUILayout__c": [
          {
            "VlocityDataPackIsIncluded": true,
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0m15000004r4RPAAY",
            "Id": "a0m15000004r4RPAAY",
            "Name": "community-content-layout-flyout-sample",
            "%vlocity_namespace%__Definition__c": "{\"Cards\":[\"community-content-layout-flyout-sample\"],\"templates\":{\"0\":{\"templateUrl\":\"flyout-grid\"}},\"dataSource\":{\"type\":\"Inherit\"}}",
            "%vlocity_namespace%__Active__c": true,
            "%vlocity_namespace%__Version__c": 1,
            "%vlocity_namespace%__Type__c": "Flyout"
          }
        ]
      }
    },
    {
      "VlocityPrimarySourceId": "a0l1500000HDGUZAA5",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "community-content-layout-flyout-sample",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "2decd11f7dc73cc3e3e4fb9e0219dd09",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackIsIncluded": true,
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityDataPackIsIncluded": true,
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Community Card Flyout Card Sample\",\"templateUrl\":\"card-active\"}],\"filter\":{},\"title\":\"Community Card Flyout Card Sample\"}",
            "Name": "community-content-layout-flyout-sample",
            "Id": "a0l1500000HDGUZAA5",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a0l1500000HDGUZAA5",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c"
          }
        ],
        "Id": "community-content-layout-flyout-sample",
        "VlocityDataPackType": "VlocityCard",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackKey": "2decd11f7dc73cc3e3e4fb9e0219dd09",
        "VlocityDataPackRelationshipType": "Sibling"
      }
    },
    {
      "VlocityPrimarySourceId": "a1xj0000000PicGAAS",
      "VlocityDataPackType": "VlocityUILayout",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Primary",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Id: a1xj0000000PicGAAS",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity UI Layout",
      "VlocityDataPackKey": "9ce2b80d94731a394c98bf0be614a200",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Primary",
        "VlocityDataPackKey": "9ce2b80d94731a394c98bf0be614a200",
        "VlocityDataPackLabel": "Vlocity UI Layout",
        "VlocityDataPackType": "VlocityUILayout",
        "Id": "a1xj0000000PicGAAS",
        "%vlocity_namespace%__VlocityUILayout__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1xj0000000PicGAAS",
            "%vlocity_namespace%__Definition__c": "{\"Cards\":[\"Policy Story\",\"Non Held Policy Story\",\"Opportunity Story\",\"Case Story\",\"Event Story\",\"Saved OmniScript Story\",\"Task Story\",\"Campaign Story\",\"Claim Story\"],\"templates\":{\"0\":{\"templateUrl\":\"story-card-canvas\"}},\"dataSource\":{\"type\":\"ApexRest\",\"value\":{\"endpoint\":\"/services/apexrest/%vlocity_namespace%/v1/story/{{params.Id}}\",\"methodType\":\"GET\",\"resultVar\":\"Stories\"},\"contextVariables\":[{\"name\":\"params.Id\",\"val\":\"001j000000G90xA\"}]}}",
            "Id": "a1xj0000000PicGAAS",
            "Name": "story-slds",
            "%vlocity_namespace%__Active__c": true,
            "%vlocity_namespace%__Type__c": "Layout",
            "%vlocity_namespace%__Version__c": 1,
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQVqAAO",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Policy Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "e8b9223374a701559b913b7422b2e9e5",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "e8b9223374a701559b913b7422b2e9e5",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Policy Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQVqAAO",
            "Id": "a1wj0000000LQVqAAO",
            "Name": "Policy Story",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Policy Status\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"Policy Number\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[{\"type\":\"Vlocity Action\",\"id\":\"Policy-PolicyDetails\"},{\"type\":\"Vlocity Action\",\"id\":\"Policy-Log Dispute\"}]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"%vlocity_namespace%__Policy__c\"}],\"filter\":{\"['objType']\":\"Policy\"},\"title\":\"Policy\"}",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQcmAAG",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Non Held Policy Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "15eb44b300f8b01be24e43b867a49556",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "15eb44b300f8b01be24e43b867a49556",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Non Held Policy Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQcmAAG",
            "Id": "a1wj0000000LQcmAAG",
            "Name": "Non Held Policy Story",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['highlight']\",\"label\":\"Policy Type\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['subtitle']\",\"label\":\"LOB\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[{\"type\":\"Vlocity Action\",\"id\":\"Policy-PolicyDetails\"},{\"type\":\"Vlocity Action\",\"id\":\"Policy-Log Dispute\"}]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"%vlocity_namespace%__Policy__c\"}],\"filter\":{\"['objType']\":\"Policy\"},\"title\":\"Non Held Policy\"}",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQcIAAW",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Opportunity Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "f80185d05da840aabfb807a15aeaa6d1",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "f80185d05da840aabfb807a15aeaa6d1",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Opportunity Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQcIAAW",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Stage\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"Amount\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[{\"type\":\"Vlocity Action\",\"id\":\"Opportunity-PersonalMarketing\"}]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"Opportunity\"}],\"filter\":{\"['objType']\":\"Opportunity\"},\"title\":\"Opportunity\"}",
            "Id": "a1wj0000000LQcIAAW",
            "Name": "Opportunity Story",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQcNAAW",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Case Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "077430760f56eaec4817248f342084e4",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "077430760f56eaec4817248f342084e4",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Case Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQcNAAW",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Status\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"Case Type\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"Case\"}],\"filter\":{\"['objType']\":\"Case\"},\"title\":\"Case\"}",
            "Id": "a1wj0000000LQcNAAW",
            "Name": "Case Story",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQcSAAW",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Event Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "f73bc6ae880e111a015336b19352273b",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "f73bc6ae880e111a015336b19352273b",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Event Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQcSAAW",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Location\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"Type\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"Case\"}],\"filter\":{\"['objType']\":\"Event\"},\"title\":\"Event\"}",
            "Id": "a1wj0000000LQcSAAW",
            "Name": "Event Story",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQcXAAW",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Saved OmniScript Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "981baaff0f994565fb24cc761ac7a82d",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "981baaff0f994565fb24cc761ac7a82d",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Saved OmniScript Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQcXAAW",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Status\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"OmniScript Type\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"Case\"}],\"filter\":{\"['objType']\":\"Saved OmniScript\"},\"title\":\"Saved OmniScript\"}",
            "Id": "a1wj0000000LQcXAAW",
            "Name": "Saved OmniScript Story",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQccAAG",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Task Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "30bb9087d3b0d2981ffbf0699ccc51eb",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "30bb9087d3b0d2981ffbf0699ccc51eb",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Task Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQccAAG",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Priority\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"Status\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"Case\"}],\"filter\":{\"['objType']\":\"Task\"},\"title\":\"Task\"}",
            "Id": "a1wj0000000LQccAAG",
            "Name": "Task Story",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQchAAG",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Campaign Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "046c0b532300de282ac746199fb18e45",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "046c0b532300de282ac746199fb18e45",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Campaign Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQchAAG",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Status\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"Type\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['activityType']\",\"label\":\"Responded\",\"type\":\"string\",\"fieldType\":\"custom\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"Case\"}],\"filter\":{\"['objType']\":\"Campaign\"},\"title\":\"Campaign\"}",
            "Id": "a1wj0000000LQchAAG",
            "Name": "Campaign Story",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    },
    {
      "VlocityPrimarySourceId": "a1wj0000000LQcrAAG",
      "VlocityDataPackType": "VlocityCard",
      "VlocityDataPackStatus": "Success",
      "VlocityDataPackRelationshipType": "Sibling",
      "VlocityDataPackRecords": [],
      "VlocityDataPackParents": [],
      "VlocityDataPackName": "Claim Story",
      "VlocityDataPackMessage": null,
      "VlocityDataPackLabel": "Vlocity Card",
      "VlocityDataPackKey": "7d95036a7e9e6caed63051227cf06bdf",
      "VlocityDataPackIsNotSupported": false,
      "VlocityDataPackData": {
        "VlocityDataPackRelationshipType": "Sibling",
        "VlocityDataPackKey": "7d95036a7e9e6caed63051227cf06bdf",
        "VlocityDataPackLabel": "Vlocity Card",
        "VlocityDataPackType": "VlocityCard",
        "Id": "Claim Story",
        "%vlocity_namespace%__VlocityCard__c": [
          {
            "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
            "VlocityDataPackType": "SObject",
            "VlocityRecordSourceKey": "VlocityRecordSourceKey:a1wj0000000LQcrAAG",
            "%vlocity_namespace%__Definition__c": "{\"states\":[{\"fields\":[{\"name\":\"['subtitle']\",\"label\":\"Claim Number\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false},{\"name\":\"['highlight']\",\"label\":\"Loss Type\",\"type\":\"string\",\"fieldType\":\"standard\",\"collapse\":true,\"editing\":false}],\"conditions\":[{\"field\":\"$scope.data.status\",\"operator\":\"===\",\"value\":\"'active'\",\"type\":\"system\"}],\"definedActions\":{\"actions\":[]},\"name\":\"Policy Expiration\",\"templateUrl\":\"story-card\",\"collapse\":false,\"sObjectType\":\"Case\"}],\"filter\":{\"['objType']\":\"Claim\"},\"title\":\"Claim\"}",
            "Id": "a1wj0000000LQcrAAG",
            "Name": "Claim Story",
            "VlocityDataPackIsIncluded": true
          }
        ],
        "VlocityDataPackIsIncluded": true
      }
    }
  ],
  "dataPackId": "a1815000001TpbHAAS",
  "name": "Vlocity Base Cards + Layouts",
  "version": 3
}