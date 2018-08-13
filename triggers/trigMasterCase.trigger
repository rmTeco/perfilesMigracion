/**
 * Created by Lino Acosta
 * Refactor by Alex Lazarev @ 02/08/2017
 *     - Moved all the business logic to a class to create a trigger handler logic CaseTriggerHandler
 *
 * Version: 2.1
 *
 */

trigger trigMasterCase on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
        if (Trigger.isBefore) {
            if (Trigger.isInsert) { 
                CaseTriggerHandler.updateCaseDataOnInsert(Trigger.new);
                CaseTriggerHandler.SetOwnerTeam(Trigger.new,null);
                CaseTriggerHandler.updateCaseTechServiceCriteria(Trigger.new, null);
            }
            if (Trigger.isUpdate) { 
                CaseTriggerHandler.updateCaseOnUpdate(Trigger.new);
                CaseTriggerHandler.SetOwnerTeam(Trigger.new,Trigger.oldMap); 
                CaseTriggerHandler.updateCaseForAdjustment(Trigger.new, Trigger.oldMap);
                CaseTriggerHandler.updateCaseTechServiceCriteria(Trigger.new , Trigger.oldMap);
            }
            if (Trigger.isDelete) { 
                CaseTriggerHandler.checkUserProfileOnDelete(Trigger.old); 
                CaseTriggerHandler.deleteChildonMassive(Trigger.old);
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) { CaseTriggerHandler.updateCaseAfterInsert(Trigger.new); }
            if (Trigger.isUpdate) { 
                CaseTriggerHandler.updateChildonMassive(Trigger.new, Trigger.oldMap);
                CaseTriggerHandler.createEntitlementToTechServiceCase(Trigger.new);
                CaseTriggerHandler.updateOrderBudgetStatus(Trigger.new, Trigger.oldMap);
                CaseTriggerHandler.updateMassiveonChild(Trigger.new, Trigger.oldMap);
            }
        }
    
}