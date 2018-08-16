global class xOMCreateReproOrders implements Database.Batchable<sObject> {
	
	String query = 'Select Id From ReproLine__c Where OrderCreated__c = false order by Priority__c desc, CreatedDate asc limit 100';
	
	global xOMCreateReproOrders() {
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		//Modificado por Joshua Juanchini.
		//Se modifica lógica para utilizar la nueva definición del método createOrdersFromBulkJob
		//Replicado de xOMCreateOrdersForReproBulkJobs
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


		/*try {
			xOMReproLoader.ResultObj result = xOMReproLoader.createOrdersFromBulkJob(scope);

			if(result.resultCode == 1) {
				update scope;
			}
		}
		catch(Exception ex) {
			finish(BC);
		}*/
	}
	
	global void finish(Database.BatchableContext BC) {
		// report progress back to BeFAN
	}
	
}