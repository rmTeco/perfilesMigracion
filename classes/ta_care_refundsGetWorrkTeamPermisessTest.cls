@IsTest
public class ta_care_refundsGetWorrkTeamPermisessTest {
    
    @IsTest static void invoke_getQueueByWorkTeamPermisess(){
    	String methodName = 'getQueueByWorkTeamPermisess';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String body ='{"workTeamId": "a4l6C00000007GBQAY","Id": "a866C000000sa66QAA","APIName": "Tenedor_Fondo_Fijo_Aeroparque"}';
        Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(body);
        List<Object> bodyList = new List<Object>();
        bodyList.add(bodyMap); 
        options.put('PermissesName',bodyList);
        ta_care_refundsGetWorrkTeamPermisess refunds = new ta_care_refundsGetWorrkTeamPermisess();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        system.assertNotEquals(null,outMap);
    }
    
    @IsTest static void invoke_CreateEntitlementTest(){
        String methodName = 'CreateEntitlement';
        List<Account> accountTest = TestDataFactory.createAccounts(1,'Business');
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('Account',accountTest[0].Id);
        options.put('Entitlement','Test entitle');
        
        ta_care_refundsGetWorrkTeamPermisess refunds = new ta_care_refundsGetWorrkTeamPermisess();
        
		Test.startTest();
        refunds.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
    }

}