@isTest
private class BillingIntegrationHandler_test {
    
    static testMethod void Billing_IntegrationHandler() {
        BillingIntegrationHandler Handler = new BillingIntegrationHandler();
        Map<Id,string> AccList = new Map<Id,string>();
        List<Account> BillingAccList = TestDataFactory.createAccounts(1,'Billing') ;
        List<Id> AccId = new List<Id>();
        set<Id> TaskId = new set<Id>();
          Test.startTest();
        for(Account acc : BillingAccList){
            AccId.add(acc.id);
            acc.Billing_Day__c = '01';
            AccList.put(acc.id,'Resp');
        }
        upsert BillingAccList;
        List<task> TaskList = TestDataFactory.createTask(AccId);
        for( Task t :TaskList){
            TaskId.add(t.id);
        } 
        IFS_S038_updateCycleMock mock = new IFS_S038_updateCycleMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        BillingIntegrationHandler.processBillingChanges(TaskId,AccList);
        
        accountHistory AH = new accountHistory(AccountId=BillingAccList[0].id,Field = 'Billing_Day__c');
        insert AH;
        BillingIntegrationHandler.lastEditPerAccountHistory(BillingAccList);
        
        Case cse = new Case( Subject='Cambio del Ciclo de Facturación',AccountId = BillingAccList[0].id);
        Insert cse;
        
        TaskList[0].WhatId = cse.id; 
        
        BillingIntegrationHandler.updateCasesStatusOnTaskResults(TaskList);
          Test.stopTest();
    }
    
    
}