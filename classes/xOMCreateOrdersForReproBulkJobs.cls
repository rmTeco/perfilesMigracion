global class xOMCreateOrdersForReproBulkJobs implements Database.Batchable<sObject>, Schedulable {
    String query = 'Select Id, JSON__c, Order__c From XOMBatchLineJob__c Where Type__c = \'Repro\' and OrderCreated__c = false and order by Priority__c desc, CreatedDate asc limit 10';
    
    global void execute(SchedulableContext SC) {
        xOMCreateOrdersForReproBulkJobs batchCLass = new xOMCreateOrdersForReproBulkJobs();
        Database.executebatch(batchCLass, 1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        try {
            Repro_Loader_Settings__c settings = Repro_Loader_Settings__c.getOrgDefaults();
            boolean result = xOMReproLoader.createOrdersFromBulkJob((List<XOMBatchLineJob__c>) scope, settings);
            xOMReproLoader.ResultObj res;
            if(result) {
                res.resultCode = 1;
                update scope;
            }
        }
        catch(Exception ex) {
            finish(BC);
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        // report progress back to BeFAN
    }
    
}