trigger trigMasterContact on Contact (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert){
            ContactTriggerHandler.OnBeforeInsert(Trigger.New);
            AttributesUsage.checkObjectAttributesRules();
            AttributesUsage.checkObjectAttributesProfilePermissions();
            ContactTriggerHandler.contactAttributesWeighingValidation();
        }
        if (Trigger.isUpdate){
            ContactTriggerHandler.OnBeforeUpdate(Trigger.New);
            AttributesUsage.checkObjectAttributesRules();
            AttributesUsage.checkObjectAttributesProfilePermissions(); 
            ContactTriggerHandler.contactAttributesWeighingValidation();
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            //ContactTriggerHandler.updateAttributeAccountField();
        }
    }
}