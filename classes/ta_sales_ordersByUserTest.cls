@isTest
public class ta_sales_ordersByUserTest
{
  public static testmethod void unitTest1()
  {
    Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
    Id billingRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Billing' LIMIT 1].Id;
    Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
    insert acc;
    List<Account> accList = new List<Account>();
    accList.add(acc);    
      
    List<Order>OrdList = TestDataFactory.createOrders(2,accList[0]);
    OrdList[0].PaymentMethodType__c ='1001';
    OrdList[0].vlocity_cmt__OriginatingChannel__c ='Presencial Oficina Comercial';
    OrdList[0].ownerId =  UserInfo.getUserId();
    update OrdList;
    Map<String, Object> input = new Map<String, Object>();
    Map<String, Object> output = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    input.put('OwnerId', OrdList[0].ownerId);
    System.debug('AccList ===> '+AccList);
    system.debug('OwnerId ===> '+input);
    test.startTest();
      ta_sales_ordersByUser clsInvois = new ta_sales_ordersByUser();
      clsInvois.invokeMethod('getOrderList', input, output, options);
    test.stopTest();
  }
}