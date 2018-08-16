global with sharing class ta_sales_CancelBatchSupport implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful, Schedulable{
 
 global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'SELECT Id, Status, TrackingStatus__c, PreInvoiceNumber__c, OrderNumber, Delivery_Method__c, PickUpStoreLocation__r.AssociatedWarehouseId__c FROM Order WHERE Status=\'Draft\'';
        System.debug('query batch: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        List<Order> orders = (List<Order>) scope;
        
		try {
				taMatrixForSupport.checkIPSMatrix();
            }
        catch(Exception e){
                System.debug('execute Msg: ' + e.getMessage());
                System.debug('execute Cause: ' + e.getCause());
                System.debug('execute Trace: ' + e.getStackTraceString());
            }
    }

    global void finish(Database.BatchableContext BC) {
        
    }

    public void execute(Schedulablecontext ctx){
        ta_sales_CancelBatchSupport batch = new ta_sales_CancelBatchSupport();
        Database.executeBatch(batch);
    }
    
}