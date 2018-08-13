{
    "dataPackId": "",
    "dataPacks": [
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"Campaign\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Status\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"custom\",\n                    \"label\": \"Responded\",\n                    \"name\": \"['activityType']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Campaign\",\n            \"sObjectType\": \"Case\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Campaigns\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Campaign Story/Vlocity/1495043462778",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Campaign Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Campaign Story/%vlocity_namespace%__VlocityCard__c/Campaign Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Campaign-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Campaign-Story",
            "VlocityDataPackName": "Campaign-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"Case\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Status\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Case Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Case\",\n            \"sObjectType\": \"Case\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Cases\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Case Story/Vlocity/1495043462780",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Case Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Case Story/%vlocity_namespace%__VlocityCard__c/Case Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Case-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Case-Story",
            "VlocityDataPackName": "Case-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"%vlocity_namespace%__InsuranceClaim__c\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Claim Number\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Loss Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Claim\",\n            \"sObjectType\": \"%vlocity_namespace%__InsuranceClaim__c\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Claims\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Claim Story/Vlocity/1495043462783",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Claim Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Claim Story/%vlocity_namespace%__VlocityCard__c/Claim Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Claim-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Claim-Story",
            "VlocityDataPackName": "Claim-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/community-content-layout": "Reference by Name",
                "VlocityUITemplate/community-content-account": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n    },\n    \"states\": [\n        {\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Name\",\n                    \"name\": \"['Name']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Phone\",\n                    \"name\": \"['Phone']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Website\",\n                    \"name\": \"['Website']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Industry\",\n                    \"name\": \"['Industry']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"AccountNumber\",\n                    \"name\": \"['AccountNumber']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"flyout\": {\n                \"data\": \"$scope.data\",\n                \"layout\": \"community-content-layout-flyout-sample\"\n            },\n            \"name\": \"Account state\",\n            \"sObjectType\": \"Account\",\n            \"templateUrl\": \"community-content-account\"\n        }\n    ],\n    \"title\": \"Community Account Card Sample\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Community-account-card-sample/Vlocity/1495043462716",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Community-account-card-sample",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Community-account-card-sample/%vlocity_namespace%__VlocityCard__c/Community-account-card-sample"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Community-account-card-sample",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Community-account-card-sample",
            "VlocityDataPackName": "Community-account-card-sample",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/Grid": "Reference by Name",
                "VlocityUITemplate/card-active": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n    },\n    \"states\": [\n        {\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Id\",\n                    \"name\": \"['Id']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Name\",\n                    \"name\": \"['Name']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Active\",\n            \"templateUrl\": \"card-active\"\n        }\n    ],\n    \"title\": \"Contact\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Contact/Vlocity/1495043462711",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Contact",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Contact/%vlocity_namespace%__VlocityCard__c/Contact"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Contact",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Contact",
            "VlocityDataPackName": "Contact",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"%vlocity_namespace%__CustomerInteraction__c\"\n    },\n    \"icon\": \"custom15\",\n    \"sprite\": \"custom\",\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Customer Interaction\",\n            \"sObjectType\": \"%vlocity_namespace%__CustomerInteraction__c\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Customer Interactions\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Customer Interaction Story/Vlocity/1495043462805",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Customer Interaction Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Customer Interaction Story/%vlocity_namespace%__VlocityCard__c/Customer Interaction Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Customer-Interaction-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Customer-Interaction-Story",
            "VlocityDataPackName": "Customer-Interaction-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"Event\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Account\",\n                    \"name\": \"['parentName']\",\n                    \"relationshipId\": \"parentId\",\n                    \"relationshipTypeField\": \"parentObjAPIName\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Time\",\n                    \"name\": \"['strActivityDate']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Location\",\n                    \"name\": \"['subtitle']\",\n                    \"relationshipType\": \"_map\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Attendees\",\n                    \"name\": \"attendees\",\n                    \"relationshipType\": \"_sobjects\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"filter\": \"$scope.obj && (!$scope.obj.detailValueMap || !(('' + $scope.obj.detailValueMap.IsAllDayEvent).toLowerCase() == 'true' || ('' +$scope.obj.detailValueMap.isAllDayEvent).toLowerCase() == 'true'))\",\n            \"name\": \"Event\",\n            \"sObjectType\": null,\n            \"templateUrl\": \"story-card\"\n        },\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Account\",\n                    \"name\": \"['parentName']\",\n                    \"relationshipId\": \"parentId\",\n                    \"relationshipTypeField\": \"parentObjAPIName\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Date\",\n                    \"name\": \"['formatedLastActivityDate']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Location\",\n                    \"name\": \"['subtitle']\",\n                    \"relationshipType\": \"_map\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Attendees\",\n                    \"name\": \"attendees\",\n                    \"relationshipType\": \"_sobjects\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"filter\": \"$scope.obj && $scope.obj.detailValueMap && (('' + $scope.obj.detailValueMap.IsAllDayEvent).toLowerCase() == 'true' || ('' +$scope.obj.detailValueMap.isAllDayEvent).toLowerCase() == 'true')\",\n            \"name\": \"All Day Event\",\n            \"sObjectType\": null,\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Events\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Event Story/Vlocity/1495043462785",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Event Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Event Story/%vlocity_namespace%__VlocityCard__c/Event Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Event-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Event-Story",
            "VlocityDataPackName": "Event-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"Asset\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Status\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Held Product\",\n            \"sObjectType\": \"Asset\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Held Products\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Held Product Story/Vlocity/1495043462793",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Held Product Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Held Product Story/%vlocity_namespace%__VlocityCard__c/Held Product Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Held-Product-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Held-Product-Story",
            "VlocityDataPackName": "Held-Product-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"%vlocity_namespace%__NonHeldPolicy__c\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                    {\n                        \"id\": \"Policy-PolicyDetails\",\n                        \"type\": \"Vlocity Action\"\n                    },\n                    {\n                        \"id\": \"Policy-Log Dispute\",\n                        \"type\": \"Vlocity Action\"\n                    }\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Policy Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"LOB\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Non Held Policy\",\n            \"sObjectType\": \"%vlocity_namespace%__NonHeldPolicy__c\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Non Held Policies\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Non Held Policy Story/Vlocity/1495043462787",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Non Held Policy Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Non Held Policy Story/%vlocity_namespace%__VlocityCard__c/Non Held Policy Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Non-Held-Policy-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Non-Held-Policy-Story",
            "VlocityDataPackName": "Non-Held-Policy-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"%vlocity_namespace%__NonHeldProduct__c\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Reference Number\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Non-Held Product\",\n            \"sObjectType\": \"%vlocity_namespace%__NonHeldProduct__c\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Non-Held Products\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Non Held Product Story/Vlocity/1495043462793",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Non Held Product Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Non Held Product Story/%vlocity_namespace%__VlocityCard__c/Non Held Product Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Non-Held-Product-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Non-Held-Product-Story",
            "VlocityDataPackName": "Non-Held-Product-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"Note\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n            ],\n            \"name\": \"Note\",\n            \"sObjectType\": \"Note\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Notes\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Note Story/Vlocity/1495043462788",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Note Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Note Story/%vlocity_namespace%__VlocityCard__c/Note Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Note-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Note-Story",
            "VlocityDataPackName": "Note-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"Opportunity\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Stage\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Amount\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Opportunity\",\n            \"sObjectType\": \"Opportunity\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Opportunities\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Opportunity Story/Vlocity/1495043462790",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Opportunity Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Opportunity Story/%vlocity_namespace%__VlocityCard__c/Opportunity Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Opportunity-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Opportunity-Story",
            "VlocityDataPackName": "Opportunity-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"%vlocity_namespace%__Policy__c\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                    {\n                        \"id\": \"Policy-PolicyDetails\",\n                        \"type\": \"Vlocity Action\"\n                    },\n                    {\n                        \"id\": \"Policy-Log Dispute\",\n                        \"type\": \"Vlocity Action\"\n                    }\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Policy Status\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Policy Number\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Policy\",\n            \"sObjectType\": \"%vlocity_namespace%__Policy__c\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Policies\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Policy Story/Vlocity/1495043462792",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Policy Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Policy Story/%vlocity_namespace%__VlocityCard__c/Policy Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Policy-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Policy-Story",
            "VlocityDataPackName": "Policy-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"%vlocity_namespace%__OmniScriptInstance__c\"\n    },\n    \"states\": [\n        {\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Status\",\n                    \"name\": \"['subtitle']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"OmniScript Type\",\n                    \"name\": \"['highlight']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Saved OmniScript\",\n            \"sObjectType\": \"%vlocity_namespace%__OmniScriptInstance__c\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Saved OmniScripts\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Saved OmniScript Story/Vlocity/1495043462794",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Saved OmniScript Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Saved OmniScript Story/%vlocity_namespace%__VlocityCard__c/Saved OmniScript Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Saved-OmniScript-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Saved-OmniScript-Story",
            "VlocityDataPackName": "Saved-OmniScript-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityAction/Story_updateTask": "Reference by Name",
                "VlocityUILayout/story-slds": "Reference by Name",
                "VlocityUITemplate/story-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {\n        \"['objAPIName']\": \"Task\"\n    },\n    \"states\": [\n        {\n            \"actionCtxId\": \"['Id']\",\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"custom\",\n                    \"label\": \"Assigned To\",\n                    \"name\": \"['ownerValueMap']['Owner']\",\n                    \"relationshipId\": \"owner\",\n                    \"relationshipName\": \"ownerValueMap\",\n                    \"relationshipType\": \"User\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"fieldType\": \"custom\",\n                    \"label\": null,\n                    \"name\": \"['parentName']\",\n                    \"relationshipId\": \"parentId\",\n                    \"relationshipName\": \"ownerValueMap\",\n                    \"relationshipTypeField\": \"parentObjAPIName\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Task\",\n            \"sObjectType\": \"Task\",\n            \"templateUrl\": \"story-card\"\n        }\n    ],\n    \"title\": \"Tasks\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "Task Story/Vlocity/1495043462796",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "Task Story",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/Task Story/%vlocity_namespace%__VlocityCard__c/Task Story"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/Task-Story",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/Task-Story",
            "VlocityDataPackName": "Task-Story",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/console-right-sidebar-slds": "Reference by Name",
                "VlocityUITemplate/acuity-sidebar-offer-card": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"001o000000SLNueAAH\"\n            }\n        ],\n        \"type\": \"ApexRest\",\n        \"value\": {\n            \"endpoint\": \"/services/apexrest/%vlocity_namespace%/v1/acuity/localoptions?contextId={{params.id}}&pageSize=3\",\n            \"methodType\": \"GET\"\n        }\n    },\n    \"filter\": {},\n    \"states\": [\n        {\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": []\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"label\": \"Name\",\n                    \"name\": \"['resource']['Name']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"label\": \"Description\",\n                    \"name\": \"['resource']['%vlocity_namespace%__Description__c']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"name\": \"Offer\",\n            \"sObjectType\": null,\n            \"templateUrl\": \"acuity-sidebar-offer-card\"\n        }\n    ],\n    \"title\": \"Acuity Sidebar Offer Card\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "acuity-sidebar-offer-card/Vlocity/1495043462798",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "acuity-sidebar-offer-card",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/acuity-sidebar-offer-card/%vlocity_namespace%__VlocityCard__c/acuity-sidebar-offer-card"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/acuity-sidebar-offer-card",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/acuity-sidebar-offer-card",
            "VlocityDataPackName": "acuity-sidebar-offer-card",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"filter\": {},\n    \"states\": [\n        {\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": []\n            },\n            \"fields\": [],\n            \"name\": \"Community Card Flyout Card Sample\",\n            \"templateUrl\": \"card-active\"\n        }\n    ],\n    \"title\": \"Community Card Flyout Card Sample\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "community-content-layout-flyout-sample/Vlocity/1495043462717",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "community-content-layout-flyout-sample",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/community-content-layout-flyout-sample/%vlocity_namespace%__VlocityCard__c/community-content-layout-flyout-sample"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/community-content-layout-flyout-sample",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/community-content-layout-flyout-sample",
            "VlocityDataPackName": "community-content-layout-flyout-sample",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/console-sidebar": "Reference by Name",
                "VlocityUITemplate/left-profile": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Alerts\": [\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"0011500001ChJqa\"\n            }\n        ],\n        \"type\": null,\n        \"value\": {\n            \"query\": \"SELECT Id, Name, BillingAddress, Phone, PhotoURL, Website FROM Account WHERE Id = '{{params.id}}'\"\n        }\n    },\n    \"definedActions\": [\n        {\n            \"actionIds\": [\n                {\n                    \"id\": \"Add\",\n                    \"type\": \"Vlocity Action\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\"\n        }\n    ],\n    \"filter\": {\n        \"attributes\": {\n            \"type\": \"Account\"\n        }\n    },\n    \"states\": [\n        {\n            \"alerts\": [\n            ],\n            \"blankStateCheck\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n            ],\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"flyout\": \"\",\n            \"name\": \"active\",\n            \"templateUrl\": \"left-profile\"\n        }\n    ],\n    \"templates\": [\n        {\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"templateUrl\": \"left-profile\"\n        },\n        {\n            \"filter\": \"$scope.data.status == 'non-existent'\",\n            \"templateUrl\": \"left-profile\"\n        }\n    ],\n    \"title\": \"Profile\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "profile-account/Vlocity/1495043462713",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "profile-account",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/profile-account/%vlocity_namespace%__VlocityCard__c/profile-account"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/profile-account",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/profile-account",
            "VlocityDataPackName": "profile-account",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/console-sidebar-slds": "Reference by Name",
                "VlocityUITemplate/action-grid-card-slds": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Alerts\": [\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"0011500001ChJqa\"\n            }\n        ],\n        \"type\": null,\n        \"value\": {\n            \"query\": \"\"\n        }\n    },\n    \"definedActions\": [\n        {\n            \"actionIds\": [\n                {\n                    \"id\": \"Add\",\n                    \"type\": \"Vlocity Action\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\"\n        }\n    ],\n    \"filter\": {\n        \"attributes\": {\n            \"type\": \"Account\"\n        }\n    },\n    \"states\": [\n        {\n            \"actionCtxId\": \"['Id']\",\n            \"alerts\": [\n            ],\n            \"blankStateCheck\": false,\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                    {\n                        \"id\": \"Account-ChangeAddress\",\n                        \"type\": \"Vlocity Action\"\n                    },\n                    {\n                        \"id\": \"AgencyBrokerage-Survey\",\n                        \"type\": \"Vlocity Action\"\n                    },\n                    {\n                        \"id\": \"Account-Commercial-New Quote\",\n                        \"type\": \"Vlocity Action\"\n                    },\n                    {\n                        \"id\": \"Alerts\",\n                        \"type\": \"Vlocity Action\"\n                    },\n                    {\n                        \"id\": \"Create Assets\",\n                        \"type\": \"Vlocity Action\"\n                    }\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Phone\",\n                    \"name\": \"['Phone']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"label\": \"Billing Address\",\n                    \"name\": \"['BillingAddress']['city']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Website\",\n                    \"name\": \"['Website']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"flyout\": \"\",\n            \"name\": \"active\",\n            \"sObjectType\": \"Account\",\n            \"templateUrl\": \"action-grid-card-slds\"\n        }\n    ],\n    \"templates\": [\n        {\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"templateUrl\": \"action-grid-card-slds\"\n        },\n        {\n            \"filter\": \"$scope.data.status == 'non-existent'\",\n            \"templateUrl\": \"action-grid-card-slds\"\n        }\n    ],\n    \"title\": \"Actions\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "profile-account-ActionGrid-slds/Vlocity/1495043462800",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "profile-account-ActionGrid-slds",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/profile-account-ActionGrid-slds/%vlocity_namespace%__VlocityCard__c/profile-account-ActionGrid-slds"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/profile-account-ActionGrid-slds",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/profile-account-ActionGrid-slds",
            "VlocityDataPackName": "profile-account-ActionGrid-slds",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/console-sidebar": "Reference by Name",
                "VlocityUITemplate/left-account-info": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Alerts\": [\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"0011500001ChJqa\"\n            }\n        ],\n        \"type\": null,\n        \"value\": {\n            \"query\": \"\"\n        }\n    },\n    \"definedActions\": [\n        {\n            \"actionIds\": [\n                {\n                    \"id\": \"Add\",\n                    \"type\": \"Vlocity Action\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\"\n        }\n    ],\n    \"filter\": {\n        \"attributes\": {\n            \"type\": \"Account\"\n        }\n    },\n    \"states\": [\n        {\n            \"alerts\": [\n            ],\n            \"blankStateCheck\": false,\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n            ],\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"flyout\": \"\",\n            \"name\": \"active\",\n            \"templateUrl\": \"left-account-info\"\n        }\n    ],\n    \"templates\": [\n        {\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"templateUrl\": \"left-account-info\"\n        },\n        {\n            \"filter\": \"$scope.data.status == 'non-existent'\",\n            \"templateUrl\": \"left-account-info\"\n        }\n    ],\n    \"title\": \"Profile\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "profile-account-info/Vlocity/1495043462714",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "profile-account-info",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/profile-account-info/%vlocity_namespace%__VlocityCard__c/profile-account-info"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/profile-account-info",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/profile-account-info",
            "VlocityDataPackName": "profile-account-info",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/console-sidebar-slds": "Reference by Name",
                "VlocityUITemplate/left-account-info-slds": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Alerts\": [\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"0011500001ChJqa\"\n            }\n        ],\n        \"type\": null,\n        \"value\": {\n            \"query\": \"\"\n        }\n    },\n    \"definedActions\": [\n        {\n            \"actionIds\": [\n                {\n                    \"id\": \"Add\",\n                    \"type\": \"Vlocity Action\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\"\n        }\n    ],\n    \"filter\": {\n        \"attributes\": {\n            \"type\": \"Account\"\n        }\n    },\n    \"states\": [\n        {\n            \"alerts\": [\n            ],\n            \"blankStateCheck\": false,\n            \"collapse\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Phone\",\n                    \"name\": \"['Phone']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"editing\": false,\n                    \"label\": \"Billing Address\",\n                    \"name\": \"['BillingAddress']['city']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Website\",\n                    \"name\": \"['Website']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"flyout\": \"\",\n            \"name\": \"active\",\n            \"templateUrl\": \"left-account-info-slds\"\n        }\n    ],\n    \"templates\": [\n        {\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"templateUrl\": \"left-account-info-slds\"\n        },\n        {\n            \"filter\": \"$scope.data.status == 'non-existent'\",\n            \"templateUrl\": \"left-account-info-slds\"\n        }\n    ],\n    \"title\": \"Profile\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "profile-account-info-slds/Vlocity/1495043462802",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "profile-account-info-slds",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/profile-account-info-slds/%vlocity_namespace%__VlocityCard__c/profile-account-info-slds"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/profile-account-info-slds",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/profile-account-info-slds",
            "VlocityDataPackName": "profile-account-info-slds",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityUILayout/console-sidebar-slds": "Reference by Name",
                "VlocityUITemplate/left-profile-slds": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityCard__c": [
                    {
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Alerts\": [\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"0011500001ChJqa\"\n            }\n        ],\n        \"type\": null,\n        \"value\": {\n            \"query\": \"SELECT Id, Name, BillingAddress, Phone, PhotoURL, Website FROM Account WHERE Id = '{{params.id}}'\"\n        }\n    },\n    \"definedActions\": [\n        {\n            \"actionIds\": [\n                {\n                    \"id\": \"Add\",\n                    \"type\": \"Vlocity Action\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\"\n        }\n    ],\n    \"filter\": {\n        \"attributes\": {\n            \"type\": \"Account\"\n        }\n    },\n    \"states\": [\n        {\n            \"alerts\": [\n            ],\n            \"blankStateCheck\": false,\n            \"conditions\": [\n                {\n                    \"field\": \"$scope.data.status\",\n                    \"operator\": \"===\",\n                    \"type\": \"system\",\n                    \"value\": \"'active'\"\n                }\n            ],\n            \"definedActions\": {\n                \"actions\": [\n                ]\n            },\n            \"fields\": [\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Name\",\n                    \"name\": \"['Name']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Type\",\n                    \"name\": \"['Type']\",\n                    \"type\": \"string\"\n                },\n                {\n                    \"collapse\": true,\n                    \"fieldType\": \"standard\",\n                    \"label\": \"Industry\",\n                    \"name\": \"['Industry']\",\n                    \"type\": \"string\"\n                }\n            ],\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"flyout\": \"\",\n            \"name\": \"active\",\n            \"sObjectType\": null,\n            \"templateUrl\": \"left-profile-slds\"\n        }\n    ],\n    \"templates\": [\n        {\n            \"filter\": \"$scope.data.status == 'active'\",\n            \"templateUrl\": \"left-profile-slds\"\n        },\n        {\n            \"filter\": \"$scope.data.status == 'non-existent'\",\n            \"templateUrl\": \"left-profile-slds\"\n        }\n    ],\n    \"title\": \"Profile\"\n}",
                        "%vlocity_namespace%__GlobalKey__c": "profile-account-slds/Vlocity/1495043462804",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "",
                        "Name": "profile-account-slds",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityCard__c",
                        "VlocityRecordSourceKey": "VlocityCard/profile-account-slds/%vlocity_namespace%__VlocityCard__c/profile-account-slds"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityCard/profile-account-slds",
                "VlocityDataPackType": "VlocityCard"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityCard/profile-account-slds",
            "VlocityDataPackName": "profile-account-slds",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityCard"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/Contact": "Reference by Name",
                "VlocityUITemplate/card-canvas": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"Contact\"\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"001o000000SLNul\"\n            }\n        ],\n        \"type\": \"Query\",\n        \"value\": {\n            \"query\": \"SELECT Id, Name FROM Contact WHERE AccountId = '{{params.id}}'\"\n        }\n    },\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"card-canvas\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "Grid/1/Vlocity/1495043708170",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "Grid",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/Grid/%vlocity_namespace%__VlocityUILayout__c/Grid"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/Grid",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/Grid",
            "VlocityDataPackName": "Grid",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/Community-account-card-sample": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"Community-account-card-sample\"\n    ],\n    \"Context\": \"\",\n    \"Filter\": \"\",\n    \"Title\": \"New Layout\",\n    \"dataSource\": {\n        \"type\": \"Query\",\n        \"value\": {\n            \"query\": \"SELECT AccountNumber,AccountSource,AnnualRevenue,BillingAddress,BillingCity,BillingCountry,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStreet,CreatedById,CreatedDate,Description,Fax,Industry,IsCustomerPortal,IsDeleted,IsPartner,Name,Phone,PhotoUrl,Rating,RecordTypeId,ShippingAddress,ShippingCity,ShippingCountry,ShippingLatitude,ShippingLongitude,ShippingPostalCode,ShippingState,ShippingStreet,Website FROM Account LIMIT 5\"\n        }\n    },\n    \"templates\": [\n        {\n            \"filter\": {\n            },\n            \"templateUrl\": \"community-content-detail\"\n        }\n    ]\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "community-content-layout/1/Vlocity/1495043708173",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "community-content-layout",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/community-content-layout/%vlocity_namespace%__VlocityUILayout__c/community-content-layout"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/community-content-layout",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/community-content-layout",
            "VlocityDataPackName": "community-content-layout",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": null,
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"community-content-layout-flyout-sample\"\n    ],\n    \"dataSource\": {\n        \"type\": \"Inherit\"\n    },\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"flyout-grid\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "community-content-layout-flyout-sample/1/Vlocity/1495043708174",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Flyout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "community-content-layout-flyout-sample",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/community-content-layout-flyout-sample/%vlocity_namespace%__VlocityUILayout__c/community-content-layout-flyout-sample"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/community-content-layout-flyout-sample",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/community-content-layout-flyout-sample",
            "VlocityDataPackName": "community-content-layout-flyout-sample",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/acuity-sidebar-offer-card": "Reference by Name",
                "VlocityUITemplate/console-right-sidebar-slds": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"acuity-sidebar-offer-card\"\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"001o000000SLNueAAH\"\n            }\n        ],\n        \"type\": \"Query\",\n        \"value\": {\n            \"query\": \"SELECT Id, Name, BillingAddress, Phone, PhotoURL, Type, Industry, Website, %vlocity_namespace%__CustomerValue__c FROM Account WHERE Id = '{{params.id}}'\"\n        }\n    },\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"console-right-sidebar-slds\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "console-right-sidebar-slds/1/Vlocity/1495043708215",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "console-right-sidebar-slds",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/console-right-sidebar-slds/%vlocity_namespace%__VlocityUILayout__c/console-right-sidebar-slds"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/console-right-sidebar-slds",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/console-right-sidebar-slds",
            "VlocityDataPackName": "console-right-sidebar-slds",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/profile-account": "Reference by Name",
                "VlocityCard/profile-account-info": "Reference by Name",
                "VlocityUITemplate/console-sidebar": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"profile-account\",\n        \"profile-account-info\"\n    ],\n    \"dataSource\": {\n        \"type\": \"Query\",\n        \"value\": {\n            \"query\": \"SELECT Id, Name, BillingAddress,Phone, PhotoURL, Website FROM Account WHERE Id = '{{params.id}}'\"\n        }\n    },\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"console-sidebar\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "console-sidebar/1/Vlocity/1495043708171",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "console-sidebar",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/console-sidebar/%vlocity_namespace%__VlocityUILayout__c/console-sidebar"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/console-sidebar",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/console-sidebar",
            "VlocityDataPackName": "console-sidebar",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/profile-account-info-slds": "Reference by Name",
                "VlocityCard/profile-account-slds": "Reference by Name",
                "VlocityUITemplate/console-sidebar-slds": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"profile-account-slds\",\n        \"profile-account-info-slds\"\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"001o000000SLNueAAH\"\n            }\n        ],\n        \"type\": \"Query\",\n        \"value\": {\n            \"query\": \"SELECT Id, Name, BillingAddress, Phone, PhotoURL, Type, Industry, Website, %vlocity_namespace%__CustomerValue__c FROM Account WHERE Id = '{{params.id}}'\"\n        }\n    },\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"console-sidebar-slds\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "console-sidebar-slds/1/Vlocity/1495043708218",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "console-sidebar-slds",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/console-sidebar-slds/%vlocity_namespace%__VlocityUILayout__c/console-sidebar-slds"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/console-sidebar-slds",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/console-sidebar-slds",
            "VlocityDataPackName": "console-sidebar-slds",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        },
        {
            "VlocityDataPackAllRelationships": {
                "VlocityCard/Campaign Story": "Reference by Name",
                "VlocityCard/Case Story": "Reference by Name",
                "VlocityCard/Claim Story": "Reference by Name",
                "VlocityCard/Customer Interaction Story": "Reference by Name",
                "VlocityCard/Event Story": "Reference by Name",
                "VlocityCard/Held Product Story": "Reference by Name",
                "VlocityCard/Non Held Policy Story": "Reference by Name",
                "VlocityCard/Non Held Product Story": "Reference by Name",
                "VlocityCard/Note Story": "Reference by Name",
                "VlocityCard/Opportunity Story": "Reference by Name",
                "VlocityCard/Policy Story": "Reference by Name",
                "VlocityCard/Saved OmniScript Story": "Reference by Name",
                "VlocityCard/Task Story": "Reference by Name",
                "VlocityUITemplate/story-card-canvas": "Reference by Name"
            },
            "VlocityDataPackData": {
                "%vlocity_namespace%__VlocityUILayout__c": [
                    {
                        "%vlocity_namespace%__Active__c": true,
                        "%vlocity_namespace%__Author__c": "Vlocity",
                        "%vlocity_namespace%__Definition__c": "{\n    \"Cards\": [\n        \"Campaign Story\",\n        \"Case Story\",\n        \"Claim Story\",\n        \"Customer Interaction Story\",\n        \"Event Story\",\n        \"Held Product Story\",\n        \"Non Held Policy Story\",\n        \"Non Held Product Story\",\n        \"Note Story\",\n        \"Opportunity Story\",\n        \"Policy Story\",\n        \"Saved OmniScript Story\",\n        \"Task Story\"\n    ],\n    \"dataSource\": {\n        \"contextVariables\": [\n            {\n                \"name\": \"params.id\",\n                \"val\": \"001o000000wFyLS\"\n            }\n        ],\n        \"type\": \"Dual\",\n        \"value\": {\n            \"apexRemoteResultVar\": \"Stories\",\n            \"apexRestResultVar\": \"Stories\",\n            \"endpoint\": \"/services/apexrest/%vlocity_namespace%/v1/story/{{params.id}}?pageSize=10\",\n            \"inputMap\": {\n                \"pageSize\": \"10\",\n                \"storyId\": \"{{params.id}}\"\n            },\n            \"methodType\": \"GET\",\n            \"remoteClass\": \"StoryListHandler\",\n            \"remoteMethod\": \"getStories\",\n            \"remoteNSPrefix\": \"%vlocity_namespace%\",\n            \"resultVar\": \"Stories\"\n        }\n    },\n    \"templates\": {\n        \"0\": {\n            \"templateUrl\": \"story-card-canvas\"\n        }\n    }\n}",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "story-slds/1/Vlocity/1495043708219",
                        "%vlocity_namespace%__ParentID__c": "",
                        "%vlocity_namespace%__Type__c": "Layout",
                        "%vlocity_namespace%__Version__c": 1,
                        "Name": "story-slds",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__VlocityUILayout__c",
                        "VlocityRecordSourceKey": "VlocityUILayout/story-slds/%vlocity_namespace%__VlocityUILayout__c/story-slds"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "VlocityUILayout/story-slds",
                "VlocityDataPackType": "VlocityUILayout"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "VlocityUILayout/story-slds",
            "VlocityDataPackName": "story-slds",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "VlocityUILayout"
        }
    ],
    "name": "Vlocity Base Cards + Layouts",
    "primaryDataPackKey": "VlocityDeploy",
    "processMultiple": true,
    "status": "Complete",
    "version": 1
}