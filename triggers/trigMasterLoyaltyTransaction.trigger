trigger trigMasterLoyaltyTransaction on LoyaltyTransaction__c (before insert, before update, before delete,
                            after insert, after update, after delete, after undelete ) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
        }
        if(Trigger.isUpdate){
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
        }
        if(Trigger.isUpdate){
        	//LoyaltyTransactionTriggers.sendSMSAfterTransactionReverted();
        }
    }
}