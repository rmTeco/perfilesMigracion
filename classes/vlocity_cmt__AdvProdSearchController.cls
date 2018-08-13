/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AdvProdSearchController {
    global String currencyLocaleSymbol {
        get;
    }
    global String decimalSep {
        get;
    }
    global String nsPrefix {
        get;
    }
    global static vlocity_cmt.ProductLineItemActionParam productLineItemActionParam;
    global static String query {
        get;
        set;
    }
    global String thousandSep {
        get;
    }
    global AdvProdSearchController() {

    }
    @RemoteAction
    global static List<vlocity_cmt.ItemWrapper> addProducts(Id objectId, Id priceBookEntryId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ObjectCopier cpqCreate(String objId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ItemWrapper> deleteItem(String objId, Id deletedItemId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.AvailablePricebook> getPriceBooks(Id oid) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ProductWrapper> getProducts(Id oid) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ItemWrapper> getlistErrorItems(String objId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ItemWrapper> getlistItems(String objId) {
        return null;
    }
    global static void populateAttachments(List<vlocity_cmt.ProductWrapper> productWrapperList) {

    }
    @RemoteAction
    global static void setPricebook(Id oid, Id pbId) {

    }
    @RemoteAction
    global static List<vlocity_cmt.ItemWrapper> updateItemQuantity(String objId, Id updateItemId, String quantity) {
        return null;
    }
global class InvalidImplementationException extends Exception {
}
}
