public without sharing class xOMReproCreateOrders implements Database.Batchable<sObject>, Schedulable {
    String query = 'Select Id, JSON__c, Order__c, Account__c From XOMBatchLineJob__c Where Type__c = \'Repro\' and OrderCreated__c = false and ProcessingFailed__c = false order by Priority__c desc, CreatedDate asc limit 10000';
    
    public void execute(SchedulableContext SC) {
        xOMReproCreateOrders batchCLass = new xOMReproCreateOrders();
        Database.executebatch(batchCLass, 1000);
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('start');
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        try {
            system.debug('execute');
            Repro_Loader_Settings__c settings = Repro_Loader_Settings__c.getOrgDefaults();
            system.debug('settings ' + settings);

            if(!settings.Active__c) return;

            Boolean result = xOMReproLoader.createOrdersFromBulkJob((List<XOMBatchLineJob__c>) scope, settings);
            system.debug('result ' + result);
            if(result) {
                update scope;
            }
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        // report progress back to BeFAN
    }
    
}

//String sch = '20 30 8 10 2 ?';
//String jobID = system.schedule('Merge Job', sch, m);