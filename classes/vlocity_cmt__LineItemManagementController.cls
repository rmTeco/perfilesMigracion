/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class LineItemManagementController {
    global List<Account> billingAccounts {
        get;
        set;
    }
    global String columnsList {
        get;
        set;
    }
    global String columnsLookupMap {
        get;
        set;
    }
    global List<Map<String,String>> columnsMap {
        get;
        set;
    }
    global String currencySymbol {
        get;
    }
    global String decimalSep {
        get;
    }
    global List<vlocity_cmt.ItemWrapper> displayItemsList {
        get;
        set;
    }
    global String feature {
        get;
        set;
    }
    global Boolean isOrderActivated {
        get;
        set;
    }
    global Boolean isSubmittable {
        get;
    }
    global List<SObject> lineItems;
    global Map<String,vlocity_cmt__ProductChildItem__c> lineNumbertoChildItems {
        get;
        set;
    }
    global String namespacePrefix {
        get;
    }
    global String nextPage {
        get;
    }
    global SObject parentItem {
        get;
        set;
    }
    global Id parentItemId;
    global List<vlocity_cmt__Premises__c> premises {
        get;
        set;
    }
    global List<System.SelectOption> pricebooks;
    global String recordType {
        get;
        set;
    }
    global List<Account> serviceAccounts {
        get;
        set;
    }
    global ApexPages.StandardController stdController {
        get;
        set;
    }
    global String thousandSep {
        get;
    }
    global LineItemManagementController() {

    }
    global LineItemManagementController(ApexPages.StandardController standardController) {

    }
    global void UpdateRow() {

    }
    global System.PageReference cfgProduct() {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ObjectCopier cpqCreate(String objId) {
        return null;
    }
    global void deleteProduct() {

    }
    global void doSynchToQuote() {

    }
    global Boolean getIsEmptyCart() {
        return null;
    }
    global String getLineItemSobjectType() {
        return null;
    }
    global List<SObject> getLineItems() {
        return null;
    }
    global List<Schema.FieldSetMember> getPDFFields() {
        return null;
    }
    global SObject getParentItem() {
        return null;
    }
    global void handleCpq() {

    }
    global void handleDeltaOrder() {

    }
    global void initializeData() {

    }
    global void initializeState() {

    }
    global void priceLineItems() {

    }
    global void splitLine() {

    }
global class InvalidImplementationException extends Exception {
}
}
