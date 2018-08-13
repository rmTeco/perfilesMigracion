/**
 * Created by Alex Lazarev 10/08/2017
 *
 * Implements Set<Id> bcTaskIds, Map<Id,Integer> newBillingMap
 * Provides the needed logic to process tasks for billing cycle change
 *
 * Object: Task
 *
 * Important: The method uses an Integration method that does a callout
 *
 * Version: 2.1
 */


public with sharing class BillingIntegrationHandler {
    public BillingIntegrationHandler() {}

    // Since the method is doing a callout, the only way to do it being called by a trigger is through @future
    @future (callout=true)
    public static void processBillingChanges(Set<Id> bcTaskIds, Map<Id,String> newBillingMap) {

        Boolean debug = true;

        // List of json requests for the Iterator
        List<String> request = new List<String>();
        List<Map<String,Object>> response = new List<Map<String, Object>>();

        // Billing Accounts List
        List<Account> bcAccounts = new List<Account>();

        // Billing Cycle Tasks
        List<Task> bcTasks = new List<Task>();

        // List Attachments for error states
        List<Attachment> tasksAttch = new List<Attachment>();

        if(debug){System.debug('newBillingMap BillingIntegrationHandler: ' + newBillingMap);}
        if(!newBillingMap.isEmpty()){
            // Getting Accounts data from the Case/task reported billingAccountIds to update
            bcAccounts = [SELECT Id, Name, AccountIntegrationId__c, Billing_Day__c FROM Account WHERE Id IN :newBillingMap.keySet()];
        }

        if(debug){System.debug('bcTaskIds BillingIntegrationHandler: ' + bcTaskIds);}
        if(!bcTaskIds.isEmpty()) {
            // Fetching Billing Tasks from primitives
            bcTasks = [SELECT Id, Subject, Status, Description, WhatId FROM Task WHERE Id IN :bcTaskIds];
        }

        if(debug){System.debug('bcAccounts BillingIntegrationHandler: ' + bcAccounts);}
        if(debug){System.debug('newBillingMap BillingIntegrationHandler: ' + newBillingMap);}
        if(!bcAccounts.isEmpty() && !newBillingMap.isEmpty()) {

            try {

                for(Account acc : bcAccounts){
        if(debug){System.debug('acc BillingIntegrationHandler: ' + acc);}

                    JSONGenerator j = JSON.createGenerator(false); //false is for pritty format


                    j.writeStartObject();
                    //not used
                    //j.writeStringField('identificadorRecurso','');
                    //j.writeStringField('codCuenta','');

                    // Production
                    //j.writeStringField('idCuenta',String.valueOf(acc.AccountIntegrationId__c));
                    // Testing
                    j.writeStringField('idCuenta',acc.AccountIntegrationId__c);
                    if(String.valueOf(acc.Billing_Day__c)!=null){
                        j.writeStringField('cicloFacturacionAnterior',String.valueOf(acc.Billing_Day__c));
                    } else {
                        j.writeStringField('cicloFacturacionAnterior','');
                    }
                    j.writeStringField('cicloFacturacion',String.valueOf(newBillingMap.get(acc.Id)));
                    j.writeStringField('ejecucionCambio','I');
                    j.writeStringField('fechaEjecucionCambio','');
                    j.writeEndObject();

                    //Add the json request to List<String> request
                    request.add(j.getAsString());
                }

        if(debug){System.debug('request BillingIntegrationHandler: ' + request);}
                // Calling external integrtion method
                if(!request.isEmpty()) {
                    response = IFS_S038_Iterator.Iterate(request);
                }

        if(debug){System.debug('response BillingIntegrationHandler: ' + response);}

                // Processing response
                if(!response.isEmpty()) {
                    for (Map<String,Object> res : response) {
                        // Checking if there is a node 'respuesta' which means that the answer is ok
                        if (res.containsKey('respuesta')) {
                            for(Task btask : bcTasks) {
                                // Matching task and updating tasks list
                                if(btask.Subject == 'Actualización de cuenta de facturación: '+res.get('idCuenta')){
                                    btask.Status = 'Completed';
                                }
                                // Matching account and updating accounts list
                                for(Account updateAcc : bcAccounts) {
                                    if(updateAcc.Id == res.get('idCuenta')) {
                                        updateAcc.Billing_Day__c = String.valueOf(newBillingMap.get(updateAcc.Id));
                                    }
                                }
                            }
                        }
                        // Checking if there is a node 'codigo' which means that the answer is not ok
                        if (res.containsKey('codigo')){
                            //System.debug('Codigo Error: ' + res.get('codigo'));
                            //System.debug('Mensaje Error: ' + res.get('mensaje'));

                            // Matching task and updating tasks list
                            for(Task btask : bcTasks){
                                if(btask.Subject == 'Actualización de cuenta de facturación: '+res.get('idCuenta')){
                                    btask.Status = 'Waiting on someone else';

                                    // Generating Response Att for errors
                                    Attachment responseAttch = new Attachment();
                                    responseAttch.ParentId = btask.Id;
                                    responseAttch.Name = String.valueOf(res.get('mensaje'));
                                    responseAttch.ContentType = 'text/plain';
                                    responseAttch.Body = Blob.valueOf(res.get('codigo') + ': '+ res.get('mensaje'));
                                    // Storing Attachments list for later insert
                                    tasksAttch.add(responseAttch);
                                }
                            }
                        }
                    }

                    // Updating tasks Lists
                    update bcTasks;
                    // Inserting tasks attachments if there were any
                    if(!tasksAttch.isEmpty()) { insert tasksAttch; }
                    // Updating accounts with new Billing Date
                    System.debug('Update accounts: ' + bcAccounts);
                    update bcAccounts;
                }
            } catch (Exception e) {
                System.debug('Exception(' + e.getMessage() + ') ');
                //System.debug('exception: ' + ex.getMessage());
            }
        }

    }

    public static List<AccountHistory> lastEditPerAccountHistory(List<Account> billingAccounts){

        // List of billing accounts with Billing_Day__c changes
        List<AccountHistory> updatedBillingAccs = new List<AccountHistory>();
        Id currentAccountId = null;

        List<AccountHistory> accountHistory = [SELECT AccountId, OldValue, NewValue, Field, CreatedById, CreatedDate
                FROM AccountHistory WHERE AccountId IN :billingAccounts AND Field = 'Billing_Day__c'
        ORDER BY CreatedDate DESC];

        for(AccountHistory ah : accountHistory){
            //Access only once per account
            if(currentAccountId!=ah.AccountId){
                // Check that we are getting the last modification
                currentAccountId = ah.AccountId;
                updatedBillingAccs.add(ah);
            }
        }

        return updatedBillingAccs;
    }

    public static void updateCasesStatusOnTaskResults(List<Task> tasks) {

        Set<Id> casesIds = new Set<Id>();
        Set<Id> billingCasesIds = new Set<Id>();
        List<Case> finishedCases = new List<Case>();

        // if we have a task that is not completed we increase the counter
        Integer nonFinishedTasks = 0;

        // Creating set of cases ids to get their tasks
        for (Task t : tasks){
            casesIds.add(t.WhatId);
        }

        List<Case> billingCases = [SELECT Id FROM Case WHERE Id IN :casesIds AND Subject = 'Cambio del Ciclo de Facturación'];

        // Creating set of cases ids to get their tasks
        for (Case bc: billingCases){
            billingCasesIds.add(bc.Id);
        }

        // Grabbing the list of all the tasks available for the cases that are in the loop
        List<Task> allTasksForCases = [SELECT Id, Subject, Status, Description, WhatId FROM Task WHERE WhatId IN :billingCasesIds];

        // Match cases Ids with tasks WhatId to see if there are not Completed
        for (Id c : billingCasesIds) {
            for (Task t : allTasksForCases) {
                if(c == t.WhatId){
                    if(t.Status != 'Completed'){
                        nonFinishedTasks++;
                    }
                }
            }
            // For each case we check if the have any not Completed task
            // If there are not any we add the Case to the list to be updated
            if(nonFinishedTasks==0){
                finishedCases.add(new Case(Id =c,Status ='Closed', Resolution_Comment__c = 'El caso se resolvió con éxito.'));
            }
        }
        try {
            if(!finishedCases.isEmpty()) {
                update finishedCases;
            }
        } catch (DmlException e) {
            System.debug('DML: ' + e);
        }
    }


}