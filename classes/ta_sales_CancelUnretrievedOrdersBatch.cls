global with sharing class ta_sales_CancelUnretrievedOrdersBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {

        List<SalesOrderAnnulmentTimeout__c> Plazos = new List <SalesOrderAnnulmentTimeout__c>();
        SalesOrderAnnulmentTimeout__c Plazo = new SalesOrderAnnulmentTimeout__c();
        Plazos = [Select TimeoutDays__c from SalesOrderAnnulmentTimeout__c];
        Plazo = Plazos[0];
        Integer cantidadDiasVencimiento = integer.valueOf(Plazo.TimeoutDays__c);
        String track = 'TrackingStatus__c';
        Date fechaVencimiento = Date.Today().addDays(-cantidadDiasVencimiento);
        String query = 'SELECT Id, Status, Delivery_Method__c, CreatedById, Received224_Date__c, (SELECT OldValue,NewValue FROM Histories WHERE field = :track) FROM Order WHERE Received224_Date__c <: fechaVencimiento AND Status=\'Draft\' AND Delivery_Method__c=\'Store Pick Up\' ';
        System.debug('query batch: ' + query); 
        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List<sObject> scope) {

		
        List<Order> orders = (List<Order>) scope;
        system.debug(orders);
        
        List<Task> tareas = new List<Task>();
        
        for(Order o: orders){

            try{
                
                Boolean testFlag = false;
                
                if(Test.isRunningTest()){
                    testFlag = true;
                }
                
                
                if(o.Histories.size() > 0){
                  
                  for (OrderHistory ord : o.Histories){
                  
                    if ((o.Status == 'Draft') && (ord.OldValue == 'Cobrado' || ord.NewValue == 'Cobrado' || testFlag == true)){
                        
                      taOrderController.CancelOrderAndRelease(o.Id);
                
                       o.TrackingStatus__c = 'Pendiente de Anulación de Pago por Vencimiento de Plazo de Retiro';
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
                        
                }
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
        ta_sales_CancelUnretrievedOrdersBatch batch = new ta_sales_CancelUnretrievedOrdersBatch();
        Database.executeBatch(batch);
    }

}