trigger WorkTeamTrigger on WorkTeam__c (before insert, before update, before delete,
                            after insert, after update, after delete, after undelete ) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            WorkTeamTriggerHandler.convertToDeveloperName();
        }
        if(Trigger.isUpdate){
            
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {

        }
        if(Trigger.isUpdate){
            WorkTeamTriggerHandler.OnAfterUpdate(Trigger.new);
        }
        if(Trigger.isDelete){
            WorkTeamTriggerHandler.syncAfterDelete();
        }
    }
}