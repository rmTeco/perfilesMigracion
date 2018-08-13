global with sharing class ProfileTagsHandler implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;

        try {
            if (methodName.equals('GetProfileTags')) {
                GetProfileTags(inputMap, outMap);
            }
            result = false;  
        } 
        catch (Exception e) {
            System.debug('ProfileTagsHandler:invokeMethod -> exception: ' + e);
            result = false;
        }

        return result;
    }

    void GetProfileTags(Map<String,Object> inputMap, Map<String, Object> outMap) {
        String accountId = (String) inputMap.get('id');

        String query = 'SELECT Id, vlocity_cmt__AttributeName__c, vlocity_cmt__CategoryName__c FROM vlocity_cmt__AttributeAssignment__c WHERE (vlocity_cmt__ObjectId__c = \'0016C000008eeAoQAI\') ORDER BY vlocity_cmt__CategoryName__c';

        List<vlocity_cmt__AttributeAssignment__c> profileTags = Database.query(query);

        List<Map<String, String>> categoriesList = new List<Map<String, String>>();
        List<Map<String, String>> attributesList = new List<Map<String, String>>();

        Boolean firstTime = true;
        String categoryName;

        for (vlocity_cmt__AttributeAssignment__c profileTag : profileTags) {
            Map<String, String> categoryTempMap = new Map<String, String>();

            if (firstTime) {
                firstTime = false;
                categoryTempMap.put('Name', profileTag.vlocity_cmt__CategoryName__c);
                categoriesList.add(categoryTempMap);
                categoryName = profileTag.vlocity_cmt__CategoryName__c; 
            }

            if (categoryName != profileTag.vlocity_cmt__CategoryName__c) {
                categoryTempMap.put('Name', profileTag.vlocity_cmt__CategoryName__c);
                categoriesList.add(categoryTempMap);
                categoryName = profileTag.vlocity_cmt__CategoryName__c;
            }
        }

        outMap.put('Categories', categoriesList);
    }  
}