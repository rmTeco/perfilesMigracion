global with sharing class IFS_EndpointFixer {
    public  String FixEndpoint(String fieldName, Object field, EndPointService__c endpoint) {
        String replacementField = String.valueOf(field);
        String endpointText = endpoint.EndPoint__c;
        String fixedEndpoint;
        if (endpointText.contains('{'+fieldName+'}')){
            fixedEndpoint=endpoint.endpoint__c.replace('{'+fieldName+'}',replacementField);
        }
        else{
            fixedEndpoint=endpointText;
        }
        return fixedEndpoint;    
    }
    public  String FixEndpointGetService(String fieldName, Object field, EndPointService__c endpoint,String body) {
        String replacementField = String.valueOf(field);
        String endpointText = endpoint.EndPoint__c;
        String fixedEndpoint;
        if (endpointText.contains('{'+fieldName+'}')){
            endpointText=endpoint.endpoint__c.replace('{'+fieldName+'}',replacementField);
            fixedEndpoint=endpointText+'?'+body;
        }
        else{
            fixedEndpoint=endpointText+'?'+body;
        }
        return fixedEndpoint;    
    }
    
}