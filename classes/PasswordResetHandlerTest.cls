@isTest
public class PasswordResetHandlerTest {
  
  @TestSetup static void creatingTestingData(){
    Contact c = new Contact(
        FirstName='firstName',
        LastName='lastName'
        //AccountId=a.Id
      );
    insert c;

    Account a = new Account();
    a.Name='TestAccount';
    a.AccountIntegrationId__c = '10';
    a.CustomerIntegrationId__c = 100;
    a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
    a.vlocity_cmt__PrimaryContactId__c = c.Id;
    a.OwnerId = Id.valueOf(UserInfo.getUserId());
    insert a;
    
    c.AccountId=a.Id;
    update c;
    
    /*User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    u.ContactId = c.Id;
    update u;
    */
  }

    @isTest static void PasswordReset(){
    //GIVEN
    String methodName = 'PasswordReset';
    
    Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
     
    Account accountObject = [SELECT id, vlocity_cmt__PrimaryContactId__c FROM Account WHERE Name = 'TestAccount'];     
    System.debug('Account: '+ accountObject);
      
    input.put('ContextId', accountObject.Id);
    
    PasswordResetHandler PasswordResetHandler = new PasswordResetHandler();
        
    //WHEN
    Test.startTest();
        Boolean result = PasswordResetHandler.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
        
        //THEN
        System.assertEquals(false, result);
  }
}