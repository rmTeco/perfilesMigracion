@IsTest
public class VlocityIntegrationProcedureTestUtTest {
    
    @TestSetup public static void ipsForTest(){
        
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IP_Test1', '{"response": true}');
        
        //Account acc = new Account();
        //Map<String, Object> respMap = new Map<String, Object>();
        //respMap.put('responseMap', (Object) acc);
        //VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IPTest2', respMap);
        
    }
    
    @IsTest public static void mockIntegrationProcedureTest(){
        
        Test.startTest();
        vlocity_cmt__OmniScript__c ip = [SELECT Id, Name FROM vlocity_cmt__OmniScript__c WHERE Name = 'Test'];
        Test.stopTest();
        System.assertEquals('Test', ip.Name);
    }

}