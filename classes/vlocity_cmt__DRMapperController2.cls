/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DRMapperController2 {
    global SObject currentRecord {
        get;
        set;
    }
    global System.PageReference homeUrl {
        get;
    }
    global Boolean isLanguageRTL {
        get;
        set;
    }
    global String namespacePrefix {
        get;
    }
    global String sObjectType {
        get;
        set;
    }
    global String sObjectTypeLabel {
        get;
        set;
    }
    global String sParentObjectLabel {
        get;
        set;
    }
    global ApexPages.StandardController stdController;
    @RemoteAction
    global static String BundleJson(String bundleName) {
        return null;
    }
    @RemoteAction
    global static List<Database.DeleteResult> DeleteMappings(List<Map<Object,Object>> mappings) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> GenerateMappings(Map<String,Object> bundleData) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__DRBundle__c> GetAllBundles() {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> GetAllObjects() {
        return null;
    }
    @RemoteAction
    global static String GetDocumentData(String templateName) {
        return null;
    }
    @RemoteAction
    global static List<Document> GetDocuments() {
        return null;
    }
    @RemoteAction
    global static List<Map<String,Object>> GetExternalObjects() {
        return null;
    }
    @RemoteAction
    global static Map<String,Map<String,Object>> GetFieldsForObject(String interfaceObjectName) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__DRMapItem__c> GetFullMapItems(String interfaceObject, String mapName) {
        return null;
    }
    @RemoteAction
    global static List<Map<String,String>> GetInterfaceObjects() {
        return null;
    }
    @RemoteAction
    global static Set<String> GetMapNames(String interfaceObjectName) {
        return null;
    }
    @RemoteAction
    global static String GetNamespace() {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> GetObjectsWithExternalFields() {
        return null;
    }
    @RemoteAction
    global static String JsonToXml(String jsonS) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__DRBundle__c SaveBundle(vlocity_cmt__DRBundle__c bundle) {
        return null;
    }
    @RemoteAction
    global static Database.UpsertResult SaveBundleJSON(Map<Object,Object> bundleData) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__DRMapItem__c SaveMapping(vlocity_cmt__DRMapItem__c mapping) {
        return null;
    }
    @RemoteAction
    global static List<Database.UpsertResult> SaveMappings(List<Map<Object,Object>> mappings) {
        return null;
    }
    @RemoteAction
    global static String XmlToJson(String xmlString) {
        return null;
    }
    @RemoteAction
    global static Id cloneDRBundle(Id drBundleId, String newName) {
        return null;
    }
    @RemoteAction
    global static String drPreviewExecute(Map<String,Object> bodyData) {
        return null;
    }
    @RemoteAction
    global static List<String> getAllJSONBasedDocumentTemplates() {
        return null;
    }
    @RemoteAction
    global static List<String> getAllTokensForJSONBasedDocumentTemplate(String templateName) {
        return null;
    }
    @RemoteAction
    global static String getDefaultBundleForInterface(String interfaceName) {
        return null;
    }
    @RemoteAction
    global static String getDocuSignTemplateData(String templateID) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__VlocityDocuSignTemplate__c> getDocuSignTemplates() {
        return null;
    }
    @RemoteAction
    global static Boolean validateUniqueField(String objectType, String fieldName, Id thisId, Object value) {
        return null;
    }
    @RemoteAction
    global static List<String> vlocityFormulaParserFunctions() {
        return null;
    }
}
