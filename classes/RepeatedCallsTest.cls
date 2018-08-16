@isTest
public class RepeatedCallsTest {
    @isTest public static void simpleTest() {
        Case testCase = new Case(
            RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Service').getRecordTypeId(),
            Type='Asteriscos TP',
            SubType__c='*150 (saldo)',
            Incident__c='La caracteristica No existe',
            Status='New'
        );
        
        insert testCase;
        
        List<Task> testTasks = new List<Task>{
            new Task(WhatId=testCase.Id, Subject='RepeatedCall', Type='Call'),
            new Task(WhatId=testCase.Id, Subject='RepeatedCall', Type='Call')
                };
        
        insert testTasks;
        
        Case c = [SELECT Id, RepeatedCalls__c  FROM Case WHERE Id = :testCase.Id];
        
        System.assertEquals(2, c.RepeatedCalls__c);
    }
}