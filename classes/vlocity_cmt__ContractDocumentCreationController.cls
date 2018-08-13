/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ContractDocumentCreationController {
    global ContractDocumentCreationController() {

    }
    @RemoteAction
    global static void checkIn(Id versionId) {

    }
    @RemoteAction
    global static Boolean checkInContentVersionForContractVersion(Map<String,Object> inputMap) {
        return null;
    }
    @RemoteAction
    global static void createContractSections(Id templateId, Id versionId) {

    }
    @RemoteAction
    global static vlocity_cmt.DocumentContentStructure createContractSectionsforVersion(Id templateId, Id versionId) {
        return null;
    }
    @RemoteAction
    global static String downloadPdf(Id parId, String docName) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt__ContractVersion__c getActiveVersion(Id objId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.DocumentContentStructure getContractSectionsForVersion(Id versionId) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ContractDocumentCreationController.ContractDocumentWrapper getContractVersionDocument(String contractVersionId, String relsXml) {
        return null;
    }
    @RemoteAction
    global static vlocity_cmt.ContractDocumentCreationController.ContractDocumentWrapper getDocTemplateForContractType(Id contractVersionid) {
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
    global static Map<String,Object> getTokenData(Map<String,Object> inputMap) {
        return null;
    }
    @RemoteAction
    global static Id linkContentVersionToContractVersion(Map<String,Object> inputMap) {
        return null;
    }
    @RemoteAction
    global static void removeContractSections(Id versionId) {

    }
    @RemoteAction
    global static void saveContractSections(vlocity_cmt.DocumentContentStructure docStructure) {

    }
    @RemoteAction
    global static void saveDocx(Id parentId, String data) {

    }
    @RemoteAction
    global static void saveNewDocumentSections(vlocity_cmt.DocumentContentStructure docStructureJSON) {

    }
    @RemoteAction
    global static void savePdf(Id parId) {

    }
    @RemoteAction
    global static Boolean unlinkContentVersionFromContractVersion(Map<String,Object> inputMap) {
        return null;
    }
    @RemoteAction
    global static void updateContractSections(Id templateId, Id versionId) {

    }
global class ContractDocumentWrapper {
    global ContractDocumentWrapper() {

    }
}
}
