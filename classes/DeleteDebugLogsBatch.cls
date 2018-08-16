global with sharing class DeleteDebugLogsBatch implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT ID FROM DebugInfo__c'
        );
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<DebugInfo__c> records = (List<DebugInfo__c>) scope;
        delete records;
    }    

    global void finish(Database.BatchableContext BC){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, CreatedById
            FROM AsyncApexJob
            WHERE Id = :BC.getJobId()];

            String sendTo = String.valueOf(job.CreatedBy.Email);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {sendTo}; 
            mail.setToAddresses(toAddresses);
            mail.setSubject('Proceso Batch');
            mail.setPlainTextBody('Se emiliminaron correctamente los registros del objecto DebugLogs');

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }

    public void execute(Schedulablecontext ctx){
        DeleteDebugLogsBatch batch = new DeleteDebugLogsBatch();
        Database.executeBatch(batch);
    }
}