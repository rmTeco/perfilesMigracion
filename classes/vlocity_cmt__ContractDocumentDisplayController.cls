/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ContractDocumentDisplayController {
    global System.PageReference contractDocumentEditSections {
        get;
    }
    global System.PageReference contractPreviewURL {
        get;
    }
    global Boolean isEditable {
        get;
        set;
    }
    global String isEditableValue {
        get;
    }
    global String nameSpacePrefix {
        get;
    }
    global String versionName {
        get;
    }
    global ContractDocumentDisplayController() {

    }
    global ContractDocumentDisplayController(ApexPages.StandardController stdController) {

    }
    @RemoteAction
    global static Boolean canEditContractVersion(Id contractVersionId) {
        return null;
    }
    @RemoteAction
    global static void checkIn(Id versionId) {

    }
    @RemoteAction
    global static void checkInDocument(vlocity_cmt__ContractVersion__c contractVersion) {

    }
    @RemoteAction
    global static void createContractSections(Id templateId, Id versionId) {

    }
    @RemoteAction
    global static vlocity_cmt.DocumentContentStructure createContractSectionsforVersion(Id templateId, Id versionId) {
        return null;
    }
    @RemoteAction
    global static void deleteContractDocumentAttachment(Id docId) {

    }
    @RemoteAction
    global static void deleteCustomSetting(Id objId) {

    }
    @RemoteAction
    global static String downloadPdf(Id parId, String docName) {
        return null;
    }
    @RemoteAction
    global static Id editNewContractVersion(Id contractVersionId) {
        return null;
    }
    @RemoteAction
    global static String formatProductSection(vlocity_cmt__ContractSection__c section) {
        return null;
    }
    @RemoteAction
    global static String formatSignatureSection(String sectionContent) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__ContractVersion__c getActiveVersion(Id objId) {
        return null;
    }
    @RemoteAction
    global static String getContractDocumentAccessControl() {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.Action> getContractDocumentActions(Id contractId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getContractIdFromVersion(Id contractVersionId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.DocumentContentStructure getContractSectionsForVersion(Id versionId) {
        return null;
    }
    @RemoteAction
    global static List<Attachment> getContractVersionAttachments(Id contractVersionId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ContractDocumentCreationController.ContractDocumentWrapper getContractVersionDocument(String contractVersionId, String relsXml) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt.Action> getContractVersionDocumentActions(Id contractVersionId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__ContractDocumentCollection__c> getContractVersionDocumentCollections(Id contractVersionId) {
        return null;
    }
    @RemoteAction
    global static List<vlocity_cmt__ContractVersion__c> getContractVersions(Id contractId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ContractDocumentCreationController.ContractDocumentWrapper getDocTemplateForContractType(Id versionId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ContractDocumentCreationController.ContractDocumentWrapper getDocxTemplate() {
        return null;
    }
    @RemoteAction
    global static List<SObject> getTemplateList(Id versionId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> handleWordDocImport(Map<String,Object> wordDocContentsMap) {
        return null;
    }
    @RemoteAction
    global static void insertNewAttachmentIntoDocumentCollection(Id attachmentId) {

    }
    @RemoteAction
    global static Object invokeVOIMethod(String className, String methodName, String inputJson, String optionJson) {
        return null;
    }
    @RemoteAction
    global static void removeContractSections(Id versionId) {

    }
    @RemoteAction
    global static void saveContractSections(vlocity_cmt.DocumentContentStructure docStructure) {

    }
    @RemoteAction
    global static void saveNewDocumentSections(vlocity_cmt.DocumentContentStructure docStructureJSON) {

    }
    @RemoteAction
    global static void saveOneSection(vlocity_cmt__ContractSection__c section) {

    }
    @RemoteAction
    global static void updateContractSections(Id templateId, Id versionId) {

    }
}
