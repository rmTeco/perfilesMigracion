/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ProductConfigurationController {
    global String currencyLocaleSymbol {
        get;
    }
    global String decimalSep {
        get;
    }
    global static String feature;
    global String nsPrefix {
        get;
    }
    global static String saveMode {
        get;
        set;
    }
    global String thousandSep {
        get;
    }
    global ProductConfigurationController() {

    }
    @RemoteAction
    global static Map<String,Object> addProductToCart(Id oId, Id pricebookEntryId, String productDefinition) {
        return null;
    }
    @RemoteAction
    global static void addProductsToCart(Id oId, List<Id> pricebookEntryIds) {

    }
    @RemoteAction
    global static Boolean checkCacheEnabled() {
        return null;
    }
    @RemoteAction
    global static Boolean checkPaginationMode(Id itemId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> configureProductFromCart(String objId, Id lineItemId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ObjectCopier cpqCreate(String objId) {
        return null;
    }
    @RemoteAction
    global static void deleteImplSavedLineItems(Id oId) {

    }
    @RemoteAction
    global static Map<String,Object> deleteProductFromCart(Id objId, Id deletedItemId) {
        return null;
    }
    @RemoteAction
    global static Object executeQueryableMethod(String className, String methodName, String input, String options) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getAttributes(Id oId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ItemWrapper> getCartDetails(Id oId, Integer refreshMode) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ItemWrapper> getCartItems(Id oId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getContextProductHierarchy(Id prodId, Id priceBookEntryId, Integer level, String lineNumber, Id parentObjectId) {
        return null;
    }
    @RemoteAction
    global static String getContextualData(String requestParamsString) {
        return null;
    }
    @RemoteAction
    global static String getCpqSettings(String key) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getOrderSummaryConfig(Id oId, String features) {
        return null;
    }
    @RemoteAction
    global static List<Object> getOrderSummaryDetails(String columnMapString, Id oId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.AvailablePricebook> getPriceBooks(Id oId) {
        return null;
    }
    @RemoteAction
    global static String getProdAttribCheckMode() {
        return null;
    }
    @RemoteAction
    global static String getProdConfMode() {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getProductForAttribCheckMode(String prodIds) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ProductWrapper> getProductHierarchy(Id prodId, Id priceBookEntryId, Integer level, String lineNumber) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getProductsList(Id oId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.ProductWrapper> getProducts(Id oId) {
        return null;
    }
    global static List<vlocity_cmt.ProductWrapper> getProducts(Id oId, String query1) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> implicitSaveProduct(Id oId, Id pricebookEntryId, String productDefinition, Id lineItemId) {
        return null;
    }
    @RemoteAction
    global static Boolean isSignitureRequired(Id contextId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> nextProducts(Id oId, Integer currentInd, String searchText, String prodIds, String sortBy) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> previousProducts(Id oId, Integer currentInd, String searchText, String prodIds, String sortBy) {
        return null;
    }
    @RemoteAction
    global static void priceHeader(Id oId) {

    }
    @RemoteAction
    global static void priceLineItems(Id oId, List<Id> lineItemIds) {

    }
    @RemoteAction
    global static String productConfSaveMode() {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> saveProductPostConfigure(Id oId, Id pricebookEntryId, String productDefinition) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> searchProducts(Id oId, String searchText, String prodIds, String sortBy) {
        return null;
    }
    @RemoteAction
    global static void setPriceBook(Id oid, Id pbId) {

    }
    @RemoteAction
    global static Map<String,Object> updateItemQuantity(String objId, Id updateItemId, String quantity) {
        return null;
    }
    @RemoteAction
    global static Object updateProductAttributes(Id productId, String JSONAttribute) {
        return null;
    }
    @RemoteAction
    global static void updateProvisioningStatusForImplSave(Id objId, Id lineItemId) {

    }
    @RemoteAction
    global static void validateProductConfiguration() {

    }
global class InvalidImplementationException extends Exception {
}
global class ProductConfigurationException extends Exception {
}
global class ProductConfiugrationException extends Exception {
}
}
