@isTest
public class ProfileTagsHandlerTest {
	
	@testSetup static void createDataTest() {
		List<vlocity_cmt__AttributeAssignment__c> attributeAssignments = new List<vlocity_cmt__AttributeAssignment__c>();
		vlocity_cmt__AttributeAssignment__c attributeAssignment1 = new vlocity_cmt__AttributeAssignment__c(
			vlocity_cmt__ObjectId__c = '0016C000008eeAoQAI'
		);
		vlocity_cmt__AttributeAssignment__c attributeAssignment2 = new vlocity_cmt__AttributeAssignment__c(
			vlocity_cmt__ObjectId__c = '0016C000008eeAoQAI'
		);
		attributeAssignments.add(attributeAssignment1);
		attributeAssignments.add(attributeAssignment2);
		insert attributeAssignments;
	}

    @isTest static void GetProfileTagsTest() {
        //GIVEN
        String nameMethod = 'GetProfileTags';
        
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        ProfileTagsHandler ProfileTagsHandler = new ProfileTagsHandler();
        
        //WHEN
        Test.startTest();
        ProfileTagsHandler.invokeMethod(nameMethod, input, output, options);
        Test.stopTest();
        
        //THEN
        System.assertEquals(true,output.containsKey('Categories'));
        List<Map<String,String>> categoriesList = (List<Map<String,String>>) output.get('Categories'); 
        System.assertEquals(false,categoriesList.isEmpty());
    }
}