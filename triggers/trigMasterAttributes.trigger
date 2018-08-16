trigger trigMasterAttributes on vlocity_cmt__Attribute__c (before insert, before update, before delete) {

    if(trigger.isBefore){
        if(trigger.isUpdate){
            AttributeTriggers.ValidateAssignments();
        }
        if(trigger.isDelete){
            AttributeTriggers.ValidateAssignments();            
        }
    }
}