@isTest
private class ta_sales_notifyIncomingExpirationsTest {

   @isTest Static Void testschedule(){
        ta_sales_notifyIncomingExpirations m = new ta_sales_notifyIncomingExpirations();
      String sch = '0 28 11 * * ?';

    TestDataFactory.createMessagingConfig(); 

        test.startTest();
        String jobID = system.schedule('Test Notify Incoming Expirations', sch, m);
        test.stopTest();      
        
        //No se puede testear un batchd entro de schedule.
        //No debería ser ambas cosas la clase  
    }
    
    @isTest Static void testBatchEmail(){
      String idRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
      TestDataFactory.createMessagingConfig();
      Date daysto = Date.Today().addDays(1);
      
      insert new CrossObject__c(
        Picklist1__c='Vencimiento de plazo de permanencia',
        RecordTypeId=idRecordType,
        String1__c='Se esta por vencer el plazo de permanencia'
    );
    
    Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];
    acc.vlocity_cmt__ContactPreferences__c = 'eMail';
    update acc;
    
    Contact ct = TestDataFactory.createContacts(1, acc)[0]; 
    ct.PermanencyDueDate__c = daysto;
    update ct;
      
      Test.startTest();
        ta_sales_notifyIncomingExpirations notifyInc = new ta_sales_notifyIncomingExpirations();
        Id batchId = Database.executeBatch(notifyInc);
        Test.stopTest();
        
        List<CrossObject__c> lstCo = [SELECT Id FROM CrossObject__c];
        
        System.assertEquals(2, lstCo.size());
    }
    
    @isTest Static void testBatchSMS(){
      String idRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
      TestDataFactory.createMessagingConfig();
      Date daysto = Date.Today().addDays(1);
      
      insert new CrossObject__c(
        Picklist1__c='Vencimiento de plazo de permanencia',
        RecordTypeId=idRecordType,
        String1__c='Se esta por vencer el plazo de permanencia'
    );
    
    Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];
    acc.vlocity_cmt__ContactPreferences__c = 'SMS';
    update acc;
    
    Contact ct = TestDataFactory.createContacts(1, acc)[0]; 
    ct.PermanencyDueDate__c = daysto;
    update ct;
      
      Test.startTest();
        ta_sales_notifyIncomingExpirations notifyInc = new ta_sales_notifyIncomingExpirations();
        Id batchId = Database.executeBatch(notifyInc);
        Test.stopTest();
        
        List<CrossObject__c> lstCo = [SELECT Id FROM CrossObject__c];
        
        System.assertEquals(2, lstCo.size());
    }
}