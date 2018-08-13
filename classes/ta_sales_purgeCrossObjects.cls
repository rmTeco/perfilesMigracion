global class ta_sales_purgeCrossObjects implements Database.Batchable<sObject>, Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, DateTime1__c FROM CrossObject__c WHERE MarkForDeletion__c = TRUE OR (RecordType.DeveloperName = \'SMSTracking\' AND DateTime1__c < TODAY)';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    public void execute(Schedulablecontext ctx){
        ta_sales_purgeCrossObjects batch = new ta_sales_purgeCrossObjects ();
        Database.executeBatch(batch);
    }
}