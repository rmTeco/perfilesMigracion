/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/DataRaptor')
global abstract class DRGlobal {
    global DRGlobal() {

    }
    global static vlocity_cmt.DRProcessResult doPost(String objectList, String bundleName, String filesMap) {
        return null;
    }
    @HttpPost
    global static vlocity_cmt.DRProcessResult processObjectsJSON(String objectList, String bundleName) {
        return null;
    }
    global static vlocity_cmt.DRProcessResult processObjects(List<SObject> objectList) {
        return null;
    }
    global static vlocity_cmt.DRProcessResult processObjects(List<SObject> objectList, String bundleName) {
        return null;
    }
    global static vlocity_cmt.DRProcessResult processObjects(List<SObject> objectList, String bundleName, Map<String,Object> additionalInfo) {
        return null;
    }
    global static vlocity_cmt.DRProcessResult processObjects(List<SObject> objectList, String bundleName, Map<String,Object> additionalInfo, Map<String,Object> filesMap) {
        return null;
    }
    global static Map<String,Object> processPost(Map<String,Object> bodyData) {
        return null;
    }
    global static vlocity_cmt.DRProcessResult processString(String input, String bundleName) {
        return null;
    }
    global static vlocity_cmt.DRProcessResult process(List<Map<String,Object>> objectList, String bundleName) {
        return null;
    }
    global static vlocity_cmt.DRProcessResult process(Map<String,Object> objectList, String bundleName) {
        return null;
    }
    global static void process(List<SObject> objectList) {

    }
    global static void process(List<SObject> objectList, String bundleName) {

    }
    global static void process(List<SObject> objectList, String bundleName, Map<String,Object> additionalInfo) {

    }
    global static void process(List<SObject> objectList, String bundleName, Map<String,Object> additionalInfo, Map<String,Object> filesMap) {

    }
    global static List<SObject> queryAllFields(List<SObject> toQuery) {
        return null;
    }
    global static void triggerHandler(List<SObject> objectList) {

    }
global class DROpenImplementation implements vlocity_cmt.VlocityOpenInterface2 {
    global DROpenImplementation() {

    }
    global Object invokeMethod(String methodName, Map<String,Object> inputs, Map<String,Object> output, Map<String,Object> options) {
        return null;
    }
}
}
