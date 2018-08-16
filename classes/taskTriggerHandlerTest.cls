@IsTest
public class taskTriggerHandlerTest {
    @IsTest static void initiateBillingIntegrationProcessTest(){
        List<Account> listAcc = TestDataFactory.createAccounts(1,'Billing');
        List<Asset> listAsset = TestDataFactory.createAssets(1,listAcc[0]);
        List<Case> listCase = TestDataFactory.createCases(2,listAcc[0].Id,listAsset[0].Id,'test case');
        
        List<Id> listId = new List<Id>();
        listId.add(listCase[0].Id);
        listId.add(listCase[1].Id);
        
        List<Task> listTask = TestDataFactory.createTask(listId);
        system.debug('listAcc[0].Id = '+listAcc[0].Id);
        listTask[0].Status = 'Completed';
        listTask[1].Subject = 'Actualización de cuenta de facturación: ' + listAcc[0].Id;
        //listTask[1].Subject = 'Call';
        listTask[1].Status = 'In Progress';
        Update listTask;
        
        Test.startTest();
        TaskTriggerHandler.initiateBillingIntegrationProcess(listTask);
		Test.stopTest();
        
        Case testCase = [SELECT Id, Status FROM Case WHERE Id =: listTask[0].WhatId LIMIT 1];
        system.debug('testCase = '+testCase);
        system.assertNotEquals('Closed', testCase.Status);
    }
    
    @IsTest static void repeatedCallsTest(){
        List<Account> listAcc = TestDataFactory.createAccounts(1,'Billing');
        List<Asset> listAsset = TestDataFactory.createAssets(1,listAcc[0]);
        List<Case> listCase = TestDataFactory.createCases(2,listAcc[0].Id,listAsset[0].Id,'test case');
        
        List<Id> listId = new List<Id>();
        listId.add(listCase[0].Id);
        listId.add(listCase[1].Id);
        
        List<Task> listTask = TestDataFactory.createTask(listId);
        listTask[0].Type = 'Call';
        listTask[0].Subject = 'RepeatedCall';
        Update listTask;
        
        Test.startTest();
        TaskTriggerHandler.repeatedCalls(listTask);
		Test.stopTest();
        
        Case testCase = [SELECT Id, RepeatedCalls__c FROM Case WHERE Id =: listTask[0].WhatId];
        system.assertEquals(1, testCase.RepeatedCalls__c);
    }
}