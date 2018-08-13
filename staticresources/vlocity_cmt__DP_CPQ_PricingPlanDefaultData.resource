{
    "dataPackId": "",
    "dataPacks": [
        {
            "VlocityDataPackData": {
                "%vlocity_namespace%__PricingPlan__c": [
                    {
                        "%vlocity_namespace%__Code__c": "DEFAULT_PRICING_PLAN",
                        "%vlocity_namespace%__Description__c": "",
                        "%vlocity_namespace%__EffectiveFromDate__c": "",
                        "%vlocity_namespace%__EffectiveUntilDate__c": "",
                        "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                        "%vlocity_namespace%__IsActive__c": true,
                        "%vlocity_namespace%__PricingPlanStep__c": [
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "223f6077-5b04-14cc-e8a9-ef0708502a59",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "ApplyOfferAdjustments",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 40,
                                "Name": "Apply Offer Adjustments",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Apply Offer Adjustments"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "22d1a88b-b037-6ae3-faaa-82ccbf73739b",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "InitializePricingVariables",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 30,
                                "Name": "Initialize Pricing Variables",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Initialize Pricing Variables"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "29f15864-a6f8-3b0e-87a6-25fad01f108e",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "ApplyChargeManualAdjustments",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 60,
                                "Name": "Apply Charge Manual Adjustments",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Apply Charge Manual Adjustments"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "2ed962d3-8753-a239-51a7-a5e2bbf04288",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "SaveLineItems",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 80,
                                "Name": "Save Line Items",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Save Line Items"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "48d8cff8-332a-fdcd-917c-13d2e11f599a",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "LoadTightestMatchPriceListEntries",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 20,
                                "Name": "Load Price List Entries",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Load Price List Entries"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "be96a233-f8eb-bda7-cb1b-2dde97b26f06",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "InitializePricingContext",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 10,
                                "Name": "Initialize Pricing Context",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Initialize Pricing Context"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "d67fe382-178b-5c64-3eb3-aa36700d7ea4",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "ApplyParentVariables",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 90,
                                "Name": "Apply Parent Variables",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Apply Parent Variables"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "e3c410ff-3442-cab2-fbd9-1d3bd1d51532",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "ApplyPromotionAdjustments",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 50,
                                "Name": "Apply Promotion Adjustments",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Apply Promotion Adjustments"
                            },
                            {
                                "%vlocity_namespace%__Description__c": "",
                                "%vlocity_namespace%__GlobalKey__c": "e9bc5708-b773-6ba0-63f1-19b61921ab02",
                                "%vlocity_namespace%__ImplementationName__c": "DefaultPricingPlanImplementation",
                                "%vlocity_namespace%__IsActive__c": true,
                                "%vlocity_namespace%__MethodName__c": "CalculateRollups",
                                "%vlocity_namespace%__PricingPlanId__c": {
                                    "%vlocity_namespace%__GlobalKey__c": "7d610715-25f7-6949-3e21-0c24d7152cc4",
                                    "VlocityDataPackType": "VlocityMatchingKeyObject",
                                    "VlocityMatchingRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan",
                                    "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c"
                                },
                                "%vlocity_namespace%__Sequence__c": 70,
                                "Name": "Calculate Rollups",
                                "VlocityDataPackIsIncluded": true,
                                "VlocityDataPackType": "SObject",
                                "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlanStep__c",
                                "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlanStep__c/Calculate Rollups"
                            }
                        ],
                        "Name": "Default Pricing Plan",
                        "VlocityDataPackIsIncluded": true,
                        "VlocityDataPackType": "SObject",
                        "VlocityRecordSObjectType": "%vlocity_namespace%__PricingPlan__c",
                        "VlocityRecordSourceKey": "%vlocity_namespace%__PricingPlan__c/Default Pricing Plan"
                    }
                ],
                "VlocityDataPackIsIncluded": true,
                "VlocityDataPackKey": "PricingPlan/Default Pricing Plan",
                "VlocityDataPackType": "PricingPlan"
            },
            "VlocityDataPackIsIncluded": true,
            "VlocityDataPackKey": "PricingPlan/Default Pricing Plan",
            "VlocityDataPackName": "Default Pricing Plan",
            "VlocityDataPackRelationshipType": "Primary",
            "VlocityDataPackStatus": "Success",
            "VlocityDataPackType": "PricingPlan"
        }
    ],
    "name": "VlocityDeploy",
    "primaryDataPackKey": "VlocityDeploy",
    "processMultiple": true,
    "status": "Complete",
    "version": 1
}