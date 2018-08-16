global with sharing class ta_sales_CancelAbandonedOrdersBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String query = 'SELECT AccountId, ContactId FROM Asset WHERE Contact.DocumentType__c = \'PAS\' AND Contact.PermanencyDueDate__c < TODAY'

        //DA 16/03/18: Calculo la fecha de hoy - cantidad de horas del CS
        Integer horas = getOVTimeout() * -1;
        //Integer horas = getOVTimeout() * 1;
        DateTime daysto = Datetime.now().addHours(horas);
        String fecha = daysto.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

        //Armo la query y la paso al batch
        
        //String query = 'SELECT Id, Status, TrackingStatus__c FROM Order WHERE CreatedDate < ' + fecha + ' AND Status=\'Draft\' AND Id =\'8016C0000008bik\' ';
        String query = 'SELECT Id, Status, TrackingStatus__c, PreInvoiceNumber__c FROM Order WHERE CreatedDate < ' + fecha + ' AND Status=\'Draft\' ';
        //String query = 'SELECT Id, Status, TrackingStatus__c FROM Order WHERE CreatedDate < YESTERDAY AND Status=\'Draft\'';
        System.debug('query batch: ' + query);
        return Database.getQueryLocator(query);
    }

    public Integer getOVTimeout(){
        //DA - 16/03/18 Me traigo el Timeout del CS expresado en horas
        Integer retInt;
        Map<String,Object> inMap = new Map<String,Object>();
        Map<String,Object> oMap = new Map<String,Object>();
        Map<String,Object> optMap = new Map<String,Object>();
        Map<String,Object> auxMap = new Map<String,Object>();
        List<Object> csFields = new List<Object>();
        try{
            
            optMap.put('CSName','TASalesCodeValue__c');
            optMap.put('CSAtribute','TimeoutOV');
            auxMap.put('field', 'Value__c');
            csFields.add(auxMap); 
            optMap.put('CSFields',csFields);
            SaleManager sm = new SaleManager();
            sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
            TASalesCodeValue__c cs = (TASalesCodeValue__c) oMap.get('CSValues');
            retInt = Integer.valueOf(cs.Value__c);
            System.debug('retInt: ' + retInt);

        }
        catch(Exception e){
                System.debug('getOVTimeout Msg: ' + e.getMessage());
                System.debug('getOVTimeout Cause: ' + e.getCause());
                System.debug('getOVTimeout Trace: ' + e.getStackTraceString());
        }
        return retInt;

    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {


        List<Order> orders = (List<Order>) scope;
        

        for(Order o: orders){
            try{
                taOrderController.CancelOrderAndRelease(o.Id);
            }
            catch(Exception e){
                System.debug('ta_sales_CancelUnpaiedOrdersBatch Msg: ' + e.getMessage());
                System.debug('ta_sales_CancelUnpaiedOrdersBatch Cause: ' + e.getCause());
                System.debug('ta_sales_CancelUnpaiedOrdersBatch Trace: ' + e.getStackTraceString());
            }
            try{
                if ((o.TrackingStatus__c == 'Pendiente de pago') && o.PreInvoiceNumber__c != null){
                    Map<String,Object> inMap, outMap, optMap;
                    inMap = new Map<String,Object>();
                    outMap = new Map<String,Object>();
                    optMap = new Map<String,Object>();
                    optMap.put('OrderId', o.Id);
                    taSalesAnnulmentHandler.HotInvoiceRollback(inMap, outMap, optMap);
                    o.TrackingStatus__c = 'Cancelada - Timeout Caja';
                }
                else{
                    o.TrackingStatus__c = 'Cancelada - Timeout';
                }

            }
            catch(Exception e){
                System.debug('ta_sales_CancelUnpaiedOrdersBatch Msg: ' + e.getMessage());
                System.debug('ta_sales_CancelUnpaiedOrdersBatch Cause: ' + e.getCause());
                System.debug('ta_sales_CancelUnpaiedOrdersBatch Trace: ' + e.getStackTraceString());
            }
            o.Status = 'Cancelled';

        }

        update orders;
    }

    global void finish(Database.BatchableContext BC) {
        
    }

    public void execute(Schedulablecontext ctx){
        ta_sales_CancelAbandonedOrdersBatch batch = new ta_sales_CancelAbandonedOrdersBatch();
        Database.executeBatch(batch);
    }

}