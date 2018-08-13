@isTest
public class TriggeredSendNotificationServiceTest {

  @isTest static void testTriggeredSendMethods(){
    Map<String,Object> inputMap = new Map<String,Object>();
    Map<String,Object> outMap = new Map<String,Object>();
	Map<String,Object> options = new Map<String,Object>();
    
    Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
    account.AccountIntegrationId__c = '10000000564';

    List <Order> order = TestDataFactory.createOrders(2, account);
    options.put('orderId', order[0].Id);
    options.put('oldOrderId', order[1].Id);
    options.put('trackingStatus', 'Anulado');
    options.put('orderApprovalStatus', null);
    options.put('trackingStatusAnnulment', 'Exitoso');
        
    insert new TriggeredSendNotificationSettings__c(Name = 'CloseAnnulmentOrder', TriggeredSendMCId__c = 'CloseAnnulmentOrder');
    
    List<object> obj = new List<Object>();
    Map<String, Object> toMap = new Map<String, Object>();
    toMap.put('Address', '003temail@tes.com');
    toMap.put('SubscriberKey', '003temail@tes.com');
    toMap.put('Options', 'Options');
    toMap.put('Channel', 'Email');
    toMap.put('processName', 'CloseAnnulmentOrder');
    obj.add(toMap);
    inputMap.put('To', toMap);
    
    List<Object> toSendList = VlocityOpenInterfaceHelper.getListObjectsFromMap(inputMap, 'To');
    toMap = (Map<String, Object>)toSendList[0];
    
    Test.startTest();     
    TriggeredSendNotificationService tts = new TriggeredSendNotificationService();
    Map<String, Object> mapt = tts.validateParameters(toMap);  
    tts.invokeMethod('sendMessage', inputMap, outMap, options);
    tts.sendMessage(inputMap, outMap, 'typeSend');
    Test.stopTest();
  }
}