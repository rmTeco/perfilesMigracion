/**
 * Created by Alex Lazarev 23/08/2017
 * Provides logic support to trigMasterTask trigger
 * Object: Task
 *
 * Version: 1.2
 */

public class TaskTriggerHandler {

    public static void initiateBillingIntegrationProcess(List<Task> triggerNew) {
        Boolean debug = true;

        if(debug){System.debug('triggerNew Task: ' + triggerNew);}
        // Setting values to null to reset them on each loop
        Id billingAccount = null;
        String newBillingCycle = null;

        // Clean list of tasks that are usefull for us in billingcycle process
        List<Task> bcTasks = new List<Task>();
        List<Task> completedTasks = new List<Task>();
        Set<Id> bcTaskIds = new Set<Id>();


        // Mapa de id de billing account - nuevoCiclo
        Map<Id,String> billingAccountsMap = new Map<Id, String>();

        // Check if the incoming Tasks list contains the tasks we need
        for (Task t : triggerNew) {
        if(debug){System.debug('Task: ' + t);}
            String taskSubject = null;
            if(t.Subject != null) { taskSubject = t.Subject; }
            String taskStatus = null;
            if(t.Status != null){  taskStatus = t.Status; }

            // Completed Tasks validation is outside the Subject validation to cover those tasks
            // that do not belong but affect Case final status
            if (taskStatus != null && taskStatus == 'Completed'){
                completedTasks.add(t);
            }

            if(debug){System.debug('completedTasks Task: ' + completedTasks);}
            // Store in the clean list those task that belong to the billing cycle process
            if(taskSubject != null && taskSubject.contains('Actualización de cuenta de facturación:')) {
                if(taskStatus == 'Not Started' || taskStatus == 'In Progress') {
                    bcTasks.add(t);
                    bcTaskIds.add(t.Id);
                }
            }

            if(debug){System.debug('bcTasks Task: ' + bcTasks);}
            if(debug){System.debug('bcTaskIds Task: ' + bcTaskIds);}
        }

        // Grabbing the billingAccounts to be sent to the Integration Handler
        if(!bcTasks.isEmpty()) {
            for (Task bct : bcTasks) {
                // Extracting BillingAccountId
                if(bct.Subject!=null){
                    billingAccount = Id.valueOf(bct.Subject.substringAfter('Actualización de cuenta de facturación: '));
                }
                // Extracting new billing Cycle
                if(bct.Description!=null) {
                    newBillingCycle = bct.Description.substringAfter('Nuevo ciclo de facturación: ');
                }
                // Building a map of <AccountId,CycleDay>
                billingAccountsMap.put(billingAccount,newBillingCycle);
                //bcAccountsIds.add(billingAccount);
            }
        }
        if(!completedTasks.isEmpty()) {
            // Updating the relative cases on tasks result
            BillingIntegrationHandler.updateCasesStatusOnTaskResults(completedTasks);
        }

        // This avoids a recursive error -> if we are coming from a @future and waiting for commit, this commit should
        // not force us to loop through the same code.
        System.debug('system.isFuture(): ' + system.isFuture());
        if(system.isFuture()) return;

            if(debug){System.debug('bcTaskIds Task: ' + bcTaskIds);}
            if(debug){System.debug('billingAccountsMap Task: ' + billingAccountsMap);}
        if(!bcTaskIds.isEmpty() && !billingAccountsMap.isEmpty()) {
            // Process billing cycle changes tasks
            BillingIntegrationHandler.processBillingChanges(bcTaskIds, billingAccountsMap);
        }
    }

    public static void repeatedCalls(List<Task> triggerNew){
        Set<Id> caseIds = new Set<Id>();

        for (Task t : triggerNew) {
            if (t.WhatId != null && t.Type == 'Call' && t.Subject == 'RepeatedCall') {
                caseIds.add(t.WhatId);
            }
        }

        List<Case> casesToRollup = new List<Case>();

        for (AggregateResult ar : [SELECT WhatId CaseId, Count(Id) TaskCount
        FROM Task
        WHERE WhatId IN :caseIds
        GROUP BY WhatId]) {
            Case c = new Case();
            c.Id = (Id) ar.get('CaseId');
            c.RepeatedCalls__c = (Integer) ar.get('TaskCount');
            casesToRollup.add(c);
        }
        

        update casesToRollup;
    }
}