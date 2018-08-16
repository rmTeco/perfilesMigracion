@isTest
public class TriggeredSendNotificationServiceTest {
    
    @testSetup static void setup() {
        MktgCloudAPISettings__c mktgCloudAPISettings = MarketingCloudAPIUtilTest.getMktgCloudAPISettings();
        mktgCloudAPISettings.TokenDuration__c = 3400;
        mktgCloudAPISettings.TokenCreationDate__c = Datetime.now();
        mktgCloudAPISettings.MCAPIAccessToken__c = '12345';
        insert mktgCloudAPISettings;
        
        TriggeredSendNotificationSettings__c triggeredSendNotifSettings = new TriggeredSendNotificationSettings__c();
        triggeredSendNotifSettings.Name = 'EmailSingleSend';
        triggeredSendNotifSettings.TriggeredSendMCId__c = '4288';
        insert triggeredSendNotifSettings;
    }
    
    static testMethod void sendMessageTest(){
        String methodName = 'sendMessage';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        MarketingCloudAPIUtil.skipAPICall = true;
        
        TriggeredSendNotificationService sendNotifService = new TriggeredSendNotificationService();
        
        List<Map<String, Object>> toList = new List<Map<String, Object>>();
        Map<String, Object> toMap = new Map<String, Object>();
        Map<String, Object> contactAttributes = new Map<String, Object>();
        
        toMap.put('processName', 'EmailSingleSend');
        toMap.put('Channel', 'Email');
        toMap.put('Options', 'SYNC');
        toMap.put('SubscriberKey', 'test@test.com');
        toMap.put('Address', 'test@test.com');
        
        contactAttributes.put('LastName', 'TestLastName');
        contactAttributes.put('FirstName', 'TestFirstName');
        
        toMap.put('ContactAttributes', contactAttributes);
        toList.add(toMap);
        inputMap.put('To', toList);
        Test.startTest();
        sendNotifService.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    
    static testMethod void sendMessageTestWithErrors(){
        String methodName = 'sendMessage';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        MarketingCloudAPIUtil.skipAPICall = true;
        
        TriggeredSendNotificationService sendNotifService = new TriggeredSendNotificationService();
        
        List<Map<String, Object>> toList = new List<Map<String, Object>>();
        Map<String, Object> toMap = new Map<String, Object>();
        Map<String, Object> contactAttributes = new Map<String, Object>();
        
        toMap.put('processName', 'InvalidProcessName');
        toMap.put('Channel', 'InvalidChannel');
        toMap.put('Options', 'SYNC');
        toMap.put('SubscriberKey', 'Invalid SubscriberKey');
        toMap.put('Address', 'Invalid Address');
        
        contactAttributes.put('LastName', 'TestLastName');
        contactAttributes.put('FirstName', 'TestFirstName');
        
        toMap.put('ContactAttributes', contactAttributes);
        toList.add(toMap);
        inputMap.put('To', toList);
        Test.startTest();
        sendNotifService.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
}