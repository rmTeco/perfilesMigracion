trigger WorkTeamPermissionTrigger on Work_Team_Permission__c (before insert, before update, before delete, 
													after insert, after update, after delete, after undelete ) { 
    WorkTeamPermissionHandler handler = new WorkTeamPermissionHandler(Trigger.isExecuting, Trigger.size);

	if(Trigger.isInsert && Trigger.isAfter){
		handler.OnAfterInsert(Trigger.new);
	}	
	else if(Trigger.isUpdate && Trigger.isAfter){
		handler.OnAfterUpdate(Trigger.oldMap, Trigger.newMap);
	}
}