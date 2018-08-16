@IsTest
public class ta_care_MarksManagement_test {
	
    @testSetup static void setup() {
        vlocity_cmt__AttributeCategory__c attCategory = new vlocity_cmt__AttributeCategory__c();
		attCategory.name = 'Marks';
		attCategory.vlocity_cmt__Code__c = 'Marks';
		attCategory.vlocity_cmt__DisplaySequence__c = 999;
		insert attCategory;
		
		vlocity_cmt__Attribute__c vAttribute = new vlocity_cmt__Attribute__c();
		vAttribute.name = 'test mark';
		vAttribute.vlocity_cmt__AttributeCategoryId__c = attCategory.id;
		insert vAttribute;
		
		//Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;
		//Id businessRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business' AND SobjectType = 'Account' LIMIT 1].Id;
		Id consumerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account parentAcc = new Account (Name='New Test Parent Account', RecordTypeId = consumerRecordTypeId);
		insert parentAcc;
		Account childAcc = new Account (Name='New Test Child Account', RecordTypeId = businessRecordTypeId, ParentId = parentAcc.Id);
		insert childAcc;
		
		vlocity_cmt__AttributeAssignment__c attrAssignment = new vlocity_cmt__AttributeAssignment__c ();
		attrAssignment.vlocity_cmt__ObjectId__c= childAcc.Id;
		attrAssignment.isParentMark__c = true;
		attrAssignment.vlocity_cmt__AttributeCategoryId__c= attCategory.Id;
        attrAssignment.vlocity_cmt__AttributeId__c = vAttribute.Id;
		attrAssignment.vlocity_cmt__Data__c = 'test att';
		insert attrAssignment;
		
    }
    
    @IsTest static void invoke_getMarks(){
        String methodName = 'getMarks';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        ta_care_MarksManagement marks = new ta_care_MarksManagement();
        
		Test.startTest();
        marks.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
		system.assertNotEquals(null, outMap.get('options'));
    }
	
	@IsTest static void invoke_upsertClientAttributeAssignments(){
		String methodName = 'upsertClientAttributeAssignments';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        ta_care_MarksManagement marks = new ta_care_MarksManagement();
		
		
		vlocity_cmt__Attribute__c Attr = [SELECT id,name FROM vlocity_cmt__Attribute__c WHERE name='test mark'];
		Account accTest = [SELECT Id,name FROM Account WHERE name='New Test Parent Account'];
		Account childAcc = [SELECT Id,name FROM Account WHERE name='New Test Child Account'];
		vlocity_cmt__AttributeCategory__c category = [SELECT Id,name FROM vlocity_cmt__AttributeCategory__c WHERE name='Marks'];
		
		options.put('ContextId',accTest.id);
		
		String body = '{"AttributeId": "'+Attr.id+'","StartDate": "2018-02-14T03:00:00.000Z","EndDate": "2018-02-16T03:00:00.000Z","isParentMark": true,"hasBeenRemoved": false,"CategoryId": "'+category.Id+'","ContextId": "'+accTest.id+'","DaysOfGrace": "","Id": ""}';
		Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(body);
        options.put('AttrAssignment', responseNode);
		

        Test.startTest();
        marks.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
				
		vlocity_cmt__AttributeAssignment__c attAssig = [SELECT Id,name,vlocity_cmt__ObjectId__c,vlocity_cmt__Data__c FROM vlocity_cmt__AttributeAssignment__c WHERE vlocity_cmt__ObjectId__c =: childAcc.Id AND vlocity_cmt__Data__c !='test att'];
		
        system.assertNotEquals(null,attAssig);
		
	}
	
	@IsTest static void invoke_updateClientAttributeAssignments_update(){
		String methodName = 'updateClientAttributeAssignments';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        ta_care_MarksManagement marks = new ta_care_MarksManagement();
		
		Account accTest = [SELECT Id,name FROM Account WHERE name='New Test Parent Account'];
		vlocity_cmt__Attribute__c Attr = [SELECT id,name FROM vlocity_cmt__Attribute__c WHERE name='test mark'];
		
		options.put('contextId',accTest.id);
		options.put('endDate','2018-02-21T03:00:00.000Z');
		options.put('isDeleted',false);
		options.put('markID',Attr.id);
		
		
		Test.startTest();
        marks.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
		
        vlocity_cmt__AttributeAssignment__c attAssig = [SELECT id,name,isParentMark__c,vlocity_cmt__ObjectId__c,vlocity_cmt__AttributeId__c,vlocity_cmt__Data__c,vlocity_cmt__RemoveDate__c FROM vlocity_cmt__AttributeAssignment__c WHERE vlocity_cmt__Data__c='test att'];
		
        string s = string.valueOfGmt(attAssig.vlocity_cmt__RemoveDate__c);

		system.assertEquals('2018-02-21 00:00:00',string.valueOfGmt(attAssig.vlocity_cmt__RemoveDate__c));
	}
    
    @IsTest static void invoke_updateClientAttributeAssignments_delete(){
    	String methodName = 'updateClientAttributeAssignments';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        ta_care_MarksManagement marks = new ta_care_MarksManagement();
		
		Account accTest = [SELECT Id,name FROM Account WHERE name='New Test Parent Account'];
		vlocity_cmt__Attribute__c Attr = [SELECT id,name FROM vlocity_cmt__Attribute__c WHERE name='test mark'];
		
		options.put('contextId',accTest.id);
		options.put('isDeleted',true);
		options.put('markID',Attr.id);
		
		Test.startTest();
        marks.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
        
        vlocity_cmt__AttributeAssignment__c attAssig = [SELECT id,name,isParentMark__c,vlocity_cmt__ObjectId__c,vlocity_cmt__AttributeId__c,vlocity_cmt__Data__c,vlocity_cmt__RemoveDate__c,vlocity_cmt__RemovedFlag__c FROM vlocity_cmt__AttributeAssignment__c WHERE vlocity_cmt__Data__c='test att'];
        
        system.assertEquals(true,attAssig.vlocity_cmt__RemovedFlag__c);
    }
    
    @IsTest static void invoke_setFraudAndValidAssetForContextIdAndAccountID(){
    	String methodName = 'setFraudAndValidAssetForContextIdAndAccountID';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
		
        ta_care_MarksManagement marks = new ta_care_MarksManagement();
		
		Account childAcc = [SELECT Id,name FROM Account WHERE name='New Test Child Account'];
        
        String body = '{"Marks":{"Name": "Dias de Gracia"},"ActiveAssets": false,"Name": "test account 1","AccountId": "'+childAcc.Id+'","Fraud": false}';
		List<Map<String, Object>> responseNode = new List<Map<String, Object>>();
        responseNode.add((Map<String, Object>)JSON.deserializeUntyped(body));
        
        options.put('BillingAccounts', responseNode);
		options.put('accountId',childAcc.Id);
		options.put('numberArray',2);

        Test.startTest();
        marks.invokeMethod(methodName, input, outMap, options);
		Test.stopTest();
        
        system.assertEquals(true,outMap.get('AccountIdExist'));
    }
}