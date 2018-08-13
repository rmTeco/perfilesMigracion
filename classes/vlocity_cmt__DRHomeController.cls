/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DRHomeController {
    global vlocity_cmt__DRBundle__c focusBundle {
        get;
    }
    global static String focusBundleName {
        get;
        set;
    }
    global String namespacePrefix {
        get;
    }
    @RemoteAction
    global static String deleteBundle(String focusBundleIdParam) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__DRBundle__c> getAllBundles(Integer offsetValue, Integer limitValue) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.DRHomeController.HomePageTableData> getTableJSONFiltered(Boolean showAll) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.DRHomeController.HomePageTableData> getTableJSON() {
        return null;
    }
    @RemoteAction
    global static System.PageReference showErrors(String focusBundleNameParam) {
        return null;
    }
    @RemoteAction
    global static System.PageReference showMappings(String focusBundleIdParam) {
        return null;
    }
    @RemoteAction
    global static System.PageReference showSuccess(String focusBundleNameParam) {
        return null;
    }
global class HomePageTableData {
}
}
