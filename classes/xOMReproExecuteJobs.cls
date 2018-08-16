global class xOMReproExecuteJobs implements Database.Batchable<sObject>, Schedulable {
	String query = 'Select Id, JSON__c, Order__c From XOMBatchLineJob__c Where Type__c = \'Repro\' and OrderCreated__c = true and OrderProcessed__c = false order by Priority__c desc, CreatedDate asc limit 10000';
	
	global void execute(SchedulableContext SC) {
		xOMReproExecuteJobs batchCLass = new xOMReproExecuteJobs();
		Database.executebatch(batchCLass, 10);
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		try {
			Boolean result = xOMReproLoader.executeOrdersFromBulkJob((List<XOMBatchLineJob__c>) scope);

			if(result) {
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

//String sch = '20 30 8 10 2 ?';
//String jobID = system.schedule('Merge Job', sch, m);