global with sharing class ta_sales_CancelUnconfirmedOrdersBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        //ta_sales_CancelUnconfirmedExpiredOrdersBatch is the original name, but Identifier Name is too long for Salesforce.
        //History PFTA-10206, Link: https://vlocity.atlassian.net/browse/PFTA-10206 
        //Cancels Orders that have been paid but said payment has failed due to a number of circumstances
        
        String query = 'SELECT Id, Status, Delivery_Method__c, CreatedById, TrackingStatus__c FROM Order WHERE Status=\'Draft\' AND Delivery_Method__c=\'Store Pick Up\' AND (TrackingStatus__c=\'Pago Fallido\' OR TrackingStatus__c=\'Pagos Imputados\') ';
        System.debug('query batch: ' + query); 
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List<sObject> scope) {

		
        List<Order> orders = (List<Order>) scope;
        system.debug(orders);
        
        List<Task> tareas = new List<Task>();
        
        for(Order o: orders){

            try{
                
                  
                    if ((o.Status == 'Draft') && (o.TrackingStatus__c == 'Pagos Imputados')){
                        
                      taOrderController.CancelOrderAndRelease(o.Id);
                        
                       //TO BE DETERMINED WHAT TRACKING STATUS TO SET BY TA!
                       o.TrackingStatus__c = 'Pendiente de Anulación de Pago';
                       o.Status = 'Cancelled';
                       //o.TrackingStatus__c = 'Pendiente de Anulación de Pago';
                       Task tarea = new Task();
                       tarea.ownerId = o.CreatedById;
                       tarea.ActivityDate = Date.today();
                       tarea.subject = 'Orden-Anulación de Pago';
                       tarea.WhatId = o.id;
                       tareas.add(tarea);
                       system.debug(tareas);
                    }
                    if ((o.Status == 'Draft') && (o.TrackingStatus__c == 'Pago Fallido')){
                        
                      taOrderController.CancelOrderAndRelease(o.Id);
                        
                       //TO BE DETERMINED WHAT TRACKING STATUS TO SET BY TA!
                       //o.TrackingStatus__c = 'Pendiente de Anulación de Pago';
                       o.Status = 'Cancelled';
                       //o.TrackingStatus__c = 'Pendiente de Anulación de Pago';

                    }
                        
                
           }
        
            catch(Exception e){
                System.debug('ta_sales_CancelUnretrievedOrdersBatch Msg: ' + e.getMessage());
                System.debug('ta_sales_CancelUnretrievedOrdersBatch Cause: ' + e.getCause());
                System.debug('ta_sales_CancelUnretrievedOrdersBatch Trace: ' + e.getStackTraceString());
            }

        }
        
        insert tareas;
        update orders;
    }

    global void finish(Database.BatchableContext BC) {
        
    }
 
    public void execute(Schedulablecontext ctx){
        ta_sales_CancelUnconfirmedOrdersBatch batch = new ta_sales_CancelUnconfirmedOrdersBatch();
        Database.executeBatch(batch);
    }

}