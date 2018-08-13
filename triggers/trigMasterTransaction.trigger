trigger trigMasterTransaction on LoyaltyTransaction__c (before insert, before update, before delete,
	after insert, after update, after delete, after undelete) {
        if(Trigger.isAfter){
            
            if(Trigger.isDelete){
                
            }else if(Trigger.isUpdate){
                transactionsTriggers.recalculateLoyaltyAccountPoints();
                
            }else if(Trigger.isInsert){
                transactionsTriggers.recalculateLoyaltyAccountPoints();
            }
        }  
}