global with sharing class ta_sales_CancelAbandonedOrdersBatch implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String query = 'SELECT AccountId, ContactId FROM Asset WHERE Contact.DocumentType__c = \'PAS\' AND Contact.PermanencyDueDate__c < TODAY'

        //DA 16/03/18: Calculo la fecha de hoy - cantidad de horas del CS
        Integer horas = getOVTimeout() * -1;
        DateTime daysto = Datetime.now().addHours(horas);
        String fecha = daysto.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

        //Armo la query y la paso al batch
        String query = 'SELECT Id, Status, TrackingStatus__c, PreInvoiceNumber__c, OrderNumber, Delivery_Method__c, PickUpStoreLocation__r.AssociatedWarehouseId__c FROM Order WHERE CreatedDate < ' + fecha + ' AND Status=\'Draft\'';
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
        
		try {
				taOrderController.CancelOrderAndRelease(orders);
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
        ta_sales_CancelAbandonedOrdersBatch batch = new ta_sales_CancelAbandonedOrdersBatch();
        Database.executeBatch(batch);
    }

}