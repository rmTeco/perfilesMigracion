@isTest
public class SMSbyPINValidationTest {
    @IsTest static void generateValidationPINTest(){
        System.debug('ENTRO SMSbyPINValidationTest.generateValidationPINTest');
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        SMSbyPINValidation smsByPinValid = new SMSbyPINValidation();
        
        String methodName = 'generateValidationPIN';
        
        List<Account> testAccount = TestDataFactory.createAccounts(1,'Consumer');
        List<Contact> testContact = TestDataFactory.createContacts(1,testAccount[0]);
        
        testContact[0].MobilePhone = '0800456400';
        Update testContact[0];
        
        String body = '{"MobilePhone": "'+testContact[0].MobilePhone+'"}';
    Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(body);
        input.put('Contact',responseNode);
        
        Test.startTest();
        smsByPinValid.invokeMethod(methodName, input, outMap, options);
    Test.stopTest();
        
        system.assertEquals( true, outMap.get('SMSbyPINValidation'));
               
    }
}