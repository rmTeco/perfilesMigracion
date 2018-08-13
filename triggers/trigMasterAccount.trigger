trigger trigMasterAccount on Account (before insert, before update, before delete,
                            after insert, after update, after delete, after undelete ) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            System.debug('Before insert');
            AttributesUsage.checkObjectAttributesRules();
            AttributesUsage.checkObjectAttributesProfilePermissions();
            AccountTriggers.attributesWeighingValidation();
            AccountTriggers.checkUniqueConsumerAccount();
            AccountTriggers.calculateSegments();
            AccountTriggers.setAccountIntegrationId();
        }
        if(Trigger.isUpdate){
            AttributesUsage.checkObjectAttributesRules();
            AttributesUsage.checkObjectAttributesProfilePermissions();
            AccountTriggers.attributesWeighingValidation();
            AccountTriggers.checkUniqueConsumerAccount();
            AccountTriggers.calculateSegments();
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountTriggers.callIntegrationServices();
        }
        if(Trigger.isUpdate){
            //AccountTriggers.sendSMSAfterCPCancellation();
            //AccountTriggers.updateAttributeAccountField();
        }
    }
}