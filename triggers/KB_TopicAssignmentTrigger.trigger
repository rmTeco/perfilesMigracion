trigger KB_TopicAssignmentTrigger on TopicAssignment (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

	if (Trigger.isBefore) {
		if (Trigger.isDelete) { 
			KB_TopicAssigmentTriggerHandler.onDeleteTopicAssignment(Trigger.Old);
		}
	} else if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate){
        	KB_TopicAssigmentTriggerHandler.onInsertUpdateTopicAssignment(Trigger.New);
        }
    }
}