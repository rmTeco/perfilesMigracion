trigger trigMasterTeamMember on Team_Member__c (before insert, before update, before delete,
                            after insert, after update, after delete, after undelete){

	if(Trigger.isBefore){
        if(Trigger.isInsert){
            
        }
        if(Trigger.isUpdate){
            TeamMemberTrigger.onBeforeUpdate();
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            TeamMemberTrigger.onAfterInsert();
        }
        if(Trigger.isUpdate){
        	TeamMemberTrigger.onAfterUpdate();
        }
        if(Trigger.isDelete){
        	TeamMemberTrigger.onAfterDelete();
        }
    }
}