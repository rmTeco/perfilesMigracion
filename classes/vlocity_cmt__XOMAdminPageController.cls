/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class XOMAdminPageController {
    global Boolean isDeltaTrackingEnabled {
        get;
    }
    global Boolean isInsurance {
        get;
    }
    global Boolean isThorEnabled {
        get;
    }
    global String labelsServicesUrl {
        get;
    }
    global String namespacePrefix {
        get;
    }
    global String uiServicesUrl {
        get;
    }
    global XOMAdminPageController() {

    }
    @RemoteAction
    global static List<Map<String,Object>> calcScopeForSyncDelta() {
        return null;
    }
    @RemoteAction
    global static Boolean cleanupSyncDelta() {
        return null;
    }
    @RemoteAction
    global static void createDataRaptorBundlesForBackSync() {

    }
    @RemoteAction
    global static Boolean ensureGlobalKeys() {
        return null;
    }
    @RemoteAction
    global static Integer ensureGlobalKeysBatch(Integer idx) {
        return null;
    }
    @RemoteAction
    global static void populateSyncDelta(String request) {

    }
    @RemoteAction
    global static void refreshCustomLabelsCache(List<String> customLabels) {

    }
}
