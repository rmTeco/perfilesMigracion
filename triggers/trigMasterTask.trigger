trigger trigMasterTask on Task (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

	if (Trigger.isBefore) {

	} else if (Trigger.isAfter) {
		if (Trigger.isInsert) {
			TaskTriggerHandler.initiateBillingIntegrationProcess(Trigger.new);
			TaskTriggerHandler.repeatedCalls(Trigger.new);
		}

		if (Trigger.isUpdate) {
			TaskTriggerHandler.initiateBillingIntegrationProcess(Trigger.new);
			TaskTriggerHandler.repeatedCalls(Trigger.new);
		}
	}
}