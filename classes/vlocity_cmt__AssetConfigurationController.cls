/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AssetConfigurationController {
    global static String columnsList {
        get;
        set;
    }
    global static List<Map<String,String>> columnsMap {
        get;
        set;
    }
    global static String currencyLocaleSymbol {
        get;
    }
    global String decimalSep {
        get;
    }
    global static String fieldSetName {
        get;
        set;
    }
    global static String listTypeAsset {
        get;
        set;
    }
    global String nsPrefix {
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
    global AssetConfigurationController() {

    }
    global AssetConfigurationController(ApexPages.StandardController controller) {

    }
    @RemoteAction
    global static String changeToFDO(Id acctId, List<Id> assetIdList, Date requestDate) {
        return null;
    }
    @RemoteAction
    global static String changeToOrderFromAsset(Id AcctId, List<Id> svcAssetId, String listType) {
        return null;
    }
    global static String changeToOrder(Id AcctId, List<Id> svcAssetId) {
        return null;
    }
    @RemoteAction
    global static String changeToQuoteFromAsset(Id AcctId, List<Id> svcAssetId, String listType) {
        return null;
    }
    global static String changeToQuote(Id AcctId, List<Id> svcAssetId) {
        return null;
    }
    @RemoteAction
    global static List<Object> getAssetList(Id accId, String fieldStName, String listType) {
        return null;
    }
    global static List<Object> getAssets(Id accId, String fieldStName) {
        return null;
    }
}
