/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CardCanvasController implements vlocity_cmt.VlocityOpenInterface2 {
    global String currentInstanceUrlWithPath {
        get;
    }
    global System.PageReference homeUrl {
        get;
    }
    global Boolean isLanguageRTL {
        get;
        set;
    }
    global String loggedUser {
        get;
    }
    global System.PageReference newUrl {
        get;
    }
    global String nsPrefix {
        get;
    }
    global String nsPrefixDotNotation {
        get;
    }
    global String records {
        get;
        set;
    }
    global String sfInstanceUrl {
        get;
    }
    global CardCanvasController() {

    }
    global CardCanvasController(ApexPages.StandardController stdController) {

    }
    global CardCanvasController(Object stdController) {

    }
    global System.PageReference checkAuth() {
        return null;
    }
    @RemoteAction
    global static void deleteCard(vlocity_cmt__VlocityCard__c card) {

    }
    @RemoteAction
    global static void deleteCardById(String cardId) {

    }
    @RemoteAction
    global static void deleteLayout(vlocity_cmt__VlocityUILayout__c layout) {

    }
    @RemoteAction
    global static void deleteLayoutById(String layoutId) {

    }
    @RemoteAction
    global static void deleteTemplate(vlocity_cmt__VlocityUITemplate__c template) {

    }
    @RemoteAction
    global static Object doCheckClassType(String sClassName, String sNS) {
        return null;
    }
    @RemoteAction
    global static Object doGenericInvoke(String sClassName, String sMethodName, String input, String options) {
        return null;
    }
    @RemoteAction
    global static String doNamedCredentialCallout(String inputJSON) {
        return null;
    }
    @RemoteAction
    global static String getAccountById(Id accountId) {
        return null;
    }
    @RemoteAction
    global static String getAccounts() {
        return null;
    }
    @RemoteAction
    global static String getActionDetails(String sObjType, String sFilterContextId, String displayOn, String linkType) {
        return null;
    }
    @RemoteAction
    global static String getActionDetailsByName(String sObjType, String sFilterContextId, String displayOn, String linkType, List<String> actionNames) {
        return null;
    }
    @RemoteAction
    global static String getActions(String sObjType, String sObjectJSON) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityAction__c> getActionsInfo() {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityCard__c> getActiveCardsByNames(List<String> cardNames) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUILayout__c> getActiveLayouts(List<String> layouts) {
        return null;
    }
    @RemoteAction
    global static List<String> getActiveTemplateNames() {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityAction__c> getAllActionsInfo() {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityCard__c> getAllCardDefinitions() {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUILayout__c> getAllLayouts() {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> getAllObjects() {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__VlocityCard__c getCardByName(String cardName) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityCard__c> getCardDefinitionsForIds(List<Id> Ids) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityCard__c> getCardsByGlobalKeys(List<String> keys) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityCard__c> getCardsByNames(List<String> cardNames) {
        return null;
    }
    @RemoteAction
    global static String getConsoleCardsAction(String sObjType, String sFilterContextId) {
        return null;
    }
    @RemoteAction
    global static String getCustomLabelValue(String labelName) {
        return null;
    }
    @RemoteAction
    global static String getCustomLabels(List<String> labelNames, String language) {
        return null;
    }
    @RemoteAction
    global static List<CustomPermission> getCustomPermissionsForUser() {
        return null;
    }
    @RemoteAction
    global static String getCustomSettings(String customSettingName) {
        return null;
    }
    @RemoteAction
    global static Object getDataViaDataRaptor(Map<String,Object> inputMap, String bundleName) {
        return null;
    }
    @RemoteAction
    global static String getDataViaDynamicSoql(String soqlStmt) {
        return null;
    }
    @RemoteAction
    global static String getDataViaDynamicSosl(String soslStmt) {
        return null;
    }
    @RemoteAction
    global static String getDatasourceQuery(String soqlStmt) {
        return null;
    }
    @RemoteAction
    global static Map<String,Map<String,Object>> getFieldsForObject(String interfaceObjectName) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__VlocityUILayout__c getLayoutById(String id) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUILayout__c> getLayoutByName(String layoutName) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUILayout__c> getLayout(String searchCriterionType, String searchParam) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUILayout__c> getLayoutsByName(List<String> layouts) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUILayout__c> getLayoutsInfo() {
        return null;
    }
    @RemoteAction
    global static String getSearchQuery(String soslStmt) {
        return null;
    }
    @RemoteAction
    global static String getStaticResourcesUrl() {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__VlocityUITemplate__c getTemplate(String templateName) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__VlocityUITemplate__c getTemplateByName(String templateName) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUITemplate__c> getTemplatesByNames(List<String> templateNames) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUITemplate__c> getTemplatesInfo() {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUITemplate__c> getTemplates() {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.UserProfile getUserProfile() {
        return null;
    }
    @RemoteAction
    global static Boolean isInsidePckg() {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__VlocityCard__c saveCard(vlocity_cmt__VlocityCard__c card) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__VlocityUILayout__c saveLayout(vlocity_cmt__VlocityUILayout__c layout) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__VlocityUITemplate__c saveTemplate(vlocity_cmt__VlocityUITemplate__c template) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityUILayout__c> setLayoutStatus(List<String> ids, Boolean status) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> trackVlocityInteraction(String trackingData) {
        return null;
    }
    @RemoteAction
    global static void updateTask(vlocity_cmt.InteractionObj interactionObj, Id interactionId) {

    }
    global static Object vlcContinuationCallback(List<String> labels, Object state) {
        return null;
    }
}
