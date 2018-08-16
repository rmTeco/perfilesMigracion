trigger trigMasterAttachment on Attachment (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            AttachmentTriggerHandler.attachToClosedCaseValidation(Trigger.new);
        }
        if (Trigger.isUpdate) { }
        if (Trigger.isDelete) { }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // AttachmentTriggerHandler.checkAttachmentLimits(Trigger.new); 
        }
        if (Trigger.isUpdate) { }
    }
}