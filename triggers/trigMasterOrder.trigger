trigger trigMasterOrder on Order (after delete, after insert, after undelete, before delete, before insert, after update, before update) {
    try{
        if (Trigger.isBefore){
            if (Trigger.isInsert) {
                system.debug('Entra a isBefore isInsert');
                OrderTriggerHandler.setTrackingStatus(Trigger.new);
                OrderTriggerHandler.updateLeadSourceOnOrderCreation(Trigger.new);
                OrderTriggerHandler.updatePriceListOnOrderCreation(Trigger.new);
                OrderTriggerHandler.setDefaultOrdervalues(Trigger.new);

             }
            if(Trigger.isUpdate){
                system.debug('Entra a isBefore isUpdate');
                OrderTriggerHandler.updateCanceledOrderStatus(Trigger.new);
                OrderTriggerHandler.getAprobacionAutomaticaADV(Trigger.new);
                OrderTriggerHandler.updateCaseOnOrderConciliate(Trigger.new);

            }
        }
        if(Trigger.isAfter){
            if(Trigger.isUpdate){
                system.debug('Entra a updateAccountSegmentLevel2');
                OrderTriggerHandler.updateAccountSegmentLevel2(Trigger.new);
                //OrderTriggerHandler.updateCanceledOrderStatus(Trigger.new);
            }
        }
    }catch(Exception e){
        system.debug('Stack trace: ' + e.getStackTraceString());
        system.debug('Error trigMasterOrder ' + e.getMessage() + 'linea: ' + e.getLineNumber());
    }
    //      ApplicationDomain.TriggerHandler(Orders.Class);
}