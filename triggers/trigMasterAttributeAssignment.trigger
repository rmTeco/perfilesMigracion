trigger trigMasterAttributeAssignment on vlocity_cmt__AttributeAssignment__c (after delete, after insert, after undelete, 
                                                                              after update, before delete, before insert, 
                                                                              before update) {

    /*if(Trigger.isBefore){
        if(Trigger.isInsert){
            AttributeAssignmentTriggers.validateAttributes();
        }
        if(Trigger.isUpdate){
            AttributeAssignmentTriggers.validateAttributes();
        }
    }   
    if(Trigger.isAfter){
        if(Trigger.isUpdate || Trigger.isInsert){
            AttributeAssignmentTriggers.setAccountAttribute();
        }
    }*/
}