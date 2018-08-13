@isTest(seeAllData = false)
public with sharing class BodyCPMailTest{
	static testmethod void getBodyCPMailErrorTest(){
		Test.startTest();
		BodyCPMail bm = new BodyCPMail();
		bm.invokeMethod('NotExistantMethod', null, null, null);
		Test.stopTest();
	}
   
	static testmethod void getBodyCPMailEmptyInputTest(){
		Test.startTest();
		BodyCPMail bm = new BodyCPMail();
		bm.invokeMethod('GetEmailBody', null, null, null);
		Test.stopTest();
	}
    
    static testmethod void getBodyCPMailNoCaseIdTest(){
		Map<String,Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, String> obj = new Map<String, String>();
		obj.put('DRId_Case', '');
		inputMap.put('dataInput', obj);

		Test.startTest();
		BodyCPMail bm = new BodyCPMail();
		bm.invokeMethod('GetEmailBody', inputMap, outMap, null);
		Test.stopTest();
    }

    static testmethod void getBodyCPMailNoDescriptionTest(){
		Map<String,Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, String> obj = new Map<String, String>();
        
        Case testCase = new Case(Type = 'Club Personal', Description = 'Unit Test');
		insert testCase;

        obj.put('DRId_Case', testCase.Id);
		obj.put('Case:Description', '');
        inputMap.put('DRId_Case', testCase.Id);
		inputMap.put('inputMap', obj);

		Test.startTest();
		BodyCPMail bm = new BodyCPMail();
		bm.invokeMethod('GetEmailBody', inputMap, outMap, null);
		Test.stopTest();
    } 
    
    static testmethod void getBodyCPMailNoAccountsTest(){
		Map<String,Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> obj = new Map<String, Object>();
        
		Map<String, Map<String, Object>> CP = new Map<String, Map<String, Object>>();
        
		Map<String, Object> CPaccounts = new Map<String, Object>();
        
        List<Account> cAccounts = new List<Account>();
        List<Account> bAccounts = new List<Account>();
        
        CPaccounts.put('consumerAccounts', cAccounts);
        CPaccounts.put('businessAccounts', bAccounts);
        
        Case testCase = new Case(Type = 'Club Personal', Description = 'Unit Test');
		insert testCase;
        
        inputMap.put('DRId_Case', testCase.Id);
        inputMap.put('Case:Type', testCase.Type);
        inputMap.put('Case:SubType', 'Alta');
        inputMap.put('AltaClubPersonal',CPaccounts);
        
		Test.startTest();
		BodyCPMail bm = new BodyCPMail();
		bm.invokeMethod('GetEmailBody', inputMap, outMap, null);
		Test.stopTest();
    } 
    
    static testmethod void getBodyCPMailOKTest(){
		Map<String,Object> inputMap1 = new Map<String, Object>();
        Map<String,Object> inputMap2 = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> obj = new Map<String, Object>();
        
		Map<String, Map<String, Object>> CP = new Map<String, Map<String, Object>>();
        
		Map<String, Object> CPaccounts = new Map<String, String>();
        
        Id recordTypeForCAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        Object ba = new Account(RecordTypeId = recordTypeForCAcc, Name = 'Sample business Account', AccountNumber = '1234');

        Id recordTypeForBAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        Object ca = new Account(RecordTypeId = recordTypeForBAcc, Name = 'Sample consumer Account', AccountNumber = '4321');
        
        List<Object> cAccounts = new List<Object>();
        List<Object> bAccounts = new List<Object>();
        
        cAccounts.add(ca);
        bAccounts.add(ba);
        
        CPaccounts.put('consumerAccounts', (Object)'({AccountNumber=10, ClubMember=false, Id=0016C0000095Vk8QAE, Name=julio enrique, vlcSelected=true})');
        //CPaccounts.put('businessAccounts', bAccounts);
        
        Case testCase = new Case(Type = 'Club Personal', Description = 'Unit Test');
		insert testCase;

        String cuentas = '{consumerAccounts=({AccountNumber=10, ClubMember=false, Id=0016C0000095Vk8QAE, Name=julio enrique, vlcSelected=true})}';

        inputMap1.put('DRId_Case', testCase.Id);
        inputMap1.put('Case:Type', testCase.Type);
        inputMap1.put('Case:Description', 'ALTA');
        inputMap1.put('AltaClubPersonal', CPaccounts);
        
        inputMap2.put('DRId_Case', testCase.Id);
        inputMap2.put('Case:Type', testCase.Type);
        inputMap2.put('Case:Description', 'BAJA');
        inputMap2.put('AltaClubPersonal',CPaccounts);

		Test.startTest();
		BodyCPMail bm = new BodyCPMail();
		bm.invokeMethod('GetEmailBody', inputMap1, outMap, null);
        bm.invokeMethod('GetEmailBody', inputMap2, outMap, null);
		Test.stopTest();
    }
}