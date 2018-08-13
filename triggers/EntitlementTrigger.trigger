/*
 * Created by Leandro Desiata 23/05/2018
 * Version: 1.0
 *
 */

trigger EntitlementTrigger on Entitlement (after insert,after update,before insert, before update) {

    if (Trigger.isBefore) {
    } else if (Trigger.isAfter) {
            if (Trigger.isInsert) { EntitlementTriggerHandler.assignEntitlementToTechServiceCase(Trigger.new); }
        }
}