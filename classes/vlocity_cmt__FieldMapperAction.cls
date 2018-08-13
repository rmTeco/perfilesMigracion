/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FieldMapperAction {
    global FieldMapperAction() {

    }
    @InvocableMethod
    global static List<vlocity_cmt.FieldMapperAction.FieldMapperResult> invokeMethod(List<vlocity_cmt.FieldMapperAction.FieldMapperRequest> requests) {
        return null;
    }
global class FieldMapperRequest {
    @InvocableVariable( required=false)
    global String action;
    @InvocableVariable( required=false)
    global String childDestinationObject;
    @InvocableVariable( required=false)
    global String childSourceObject;
    @InvocableVariable( required=false)
    global List<String> childSourceObjectIds;
    @InvocableVariable( required=false)
    global String destinationObject;
    @InvocableVariable( required=false)
    global String destinationObjectId;
    @InvocableVariable( required=false)
    global String destinationToParentLookupField;
    @InvocableVariable( required=false)
    global String sourceObject;
    @InvocableVariable( required=false)
    global String sourceObjectId;
    @InvocableVariable( required=false)
    global String sourceToParentLookupField;
    global FieldMapperRequest() {

    }
}
global class FieldMapperResult {
    @InvocableVariable( required=false)
    global String error;
    @InvocableVariable( required=false)
    global Boolean hasErrors;
    global FieldMapperResult() {

    }
}
global class InvalidImplementationException extends Exception {
}
}
