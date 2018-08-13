trigger trigMasterPaymentMethod on vlocity_cmt__PaymentMethod__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			PaymentMethodTriggerHandler.processPaymentMethodUpdates(Trigger.new);
		}

		if (Trigger.isUpdate) {
			PaymentMethodTriggerHandler.processPaymentMethodUpdates(Trigger.new);
		}

	} else if (Trigger.isAfter) {
		if (Trigger.isInsert) {
		}

		if (Trigger.isUpdate) {
		}
	}

}