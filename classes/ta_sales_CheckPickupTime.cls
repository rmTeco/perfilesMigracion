global with sharing class ta_sales_CheckPickupTime implements Database.Batchable<sObject>, Schedulable{
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, CreatedDate, vlocity_cmt__OriginatingChannel__c FROM Order WHERE Status = \'Activated\' AND TrackingStatus__c = \'Pendiente de entrega\'';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Order> orders = (List<Order>) scope;
        List<Order> ordersToCancel = new List<Order>();
        Map<String, Integer> plazos = new Map<String, Integer>();
        for(PlazoEsperaXCanal__c plazo: PlazoEsperaXCanal__c.getAll().values()){
            plazos.put(plazo.Name,(Integer) plazo.Minutos__c);
        }
        for(Order o: orders){
            if(o.vlocity_cmt__OriginatingChannel__c != '' && o.vlocity_cmt__OriginatingChannel__c != null){
                Integer mins = plazos.get(o.vlocity_cmt__OriginatingChannel__c);
                if(mins != null && o.createdDate.addMinutes(mins) < System.now()){
                    ordersToCancel.add(new Order(Id = o.Id, Status = 'Cancelled', TrackingStatus__c = 'Cancelada - Time Out Store PickUp'));
                }
            }
        }
        if(ordersToCancel.size() > 0){
            update ordersToCancel;
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    public void execute(Schedulablecontext ctx){
        ta_sales_CheckPickupTime batch = new ta_sales_CheckPickupTime();
        Database.executeBatch(batch);
    }
}