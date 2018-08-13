/*
 * Input type must have validation, minimum, and required properties
 * Quantity validation: 'lineItemIdsWithInvalidQuantity'
 * One Time Discount Validation: 'lineItemIdsWithInvalidOneTimeDiscount'
 * Name must have classSuffix: 'name'. Other classSuffix's are generated from the type
 *
 * Custom Labels can be used by passing the Custom Label Name into the field label key.
 * If you pass in a string that is not found in your org's Custom Labels, that string
 * will be used as the label.
 */
window.CPQ_PRICING_VIEWS = [{
        label: 'Default',
        fields: [{
            name: 'Name',
            type: 'text',
            label: '',
            classSuffix: 'name'
        }, {
            name: 'Quantity',
            type: 'input',
            label: 'Quantity',
            validation: 'lineItemIdsWithInvalidQuantity',
            minimum: 1,
            required: true
        }, {
            name: '%namespace%RecurringTotal__c',
            type: 'price',
            label: 'Recurring Total'
        }, {
            name: '%namespace%OneTimeTotal__c',
            type: 'price',
            label: 'One Time Total'
        }, {
            name: '%namespace%RecurringManualDiscount__c',
            type: 'input',
            label: 'Recurring Manual Discount',
            validation: 'lineItemIdsWithInvalidOneTimeDiscount',
            minimum: 0,
            required: false
        }, {
            name: '%namespace%OneTimeManualDiscount__c',
            type: 'input',
            label: 'One Time Manual Discount',
            validation: 'lineItemIdsWithInvalidOneTimeDiscount',
            minimum: 0,
            required: false
        }]
    }, {
        label: 'Custom View',
        fields: [{
            name: 'Name',
            type: 'text',
            label: '',
            classSuffix: 'name'
        }, {
            name: '%namespace%LineNumber__c',
            type: 'text',
            label: 'Line Number'
        }, {
            name: 'Quantity',
            type: 'input',
            label: 'Quantity',
            validation: 'lineItemIdsWithInvalidQuantity',
            minimum: 1,
            required: true
        }, {
            name: '%namespace%RecurringCalculatedPrice__c',
            type: 'price',
            label: 'Recurring Calculated Price'
        }, {
            name: '%namespace%OneTimeCalculatedPrice__c',
            type: 'price',
            label: 'One Time Calculated Price'
        }, {
            name: '%namespace%OneTimeCharge__c',
            type: 'price',
            label: 'One Time Charge'
        }, {
            name: '%namespace%RecurringCharge__c',
            type: 'price',
            label: 'Recurring Charge'
        }, {
            name: 'ListPrice',
            type: 'price',
            label: 'List Price'
        }, {
            name: '%namespace%RecurringManualDiscount__c',
            type: 'input',
            label: 'Recurring Manual Discount',
            validation: 'lineItemIdsWithInvalidOneTimeDiscount',
            minimum: 0,
            required: false
        }, {
            name: '%namespace%OneTimeManualDiscount__c',
            type: 'input',
            label: 'One Time Manual Discount',
            validation: 'lineItemIdsWithInvalidOneTimeDiscount',
            minimum: 0,
            required: false
        }]
    }
];