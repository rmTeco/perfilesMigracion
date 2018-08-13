/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MultiSiteOrder {
    global String namespacePrefix {
        get;
    }
    @RemoteAction
    global static List<Order> addChildOrder(String objId, String Name, String accountId) {
        return null;
    }
    @RemoteAction
    global static Id cloneOrder(String objId, String newOrderName, String accountId, String toCloneOrderId) {
        return null;
    }
    @RemoteAction
    global static List<Order> cloneOrders(String objId, String toCloneOrderId, String selectedSiteAccountIds) {
        return null;
    }
    @RemoteAction
    global static List<OrderItem> getAllLineItems(String objId) {
        return null;
    }
    @RemoteAction
    global static List<Order> getChildOrders(String objId) {
        return null;
    }
    @RemoteAction
    global static Order getOrder(String objId) {
        return null;
    }
    @RemoteAction
    global static List<Account> getServiceAccounts(String objId) {
        return null;
    }
    @RemoteAction
    global static Object saveAttributeChanges(String updatedLineItemsJSON) {
        return null;
    }
}
