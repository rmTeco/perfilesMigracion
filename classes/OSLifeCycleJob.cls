/**
 * Created by Alex Lazarev 25/10/2017
 *
 * Implements Database.Batchable<sObject>, Database.Stateful, Schedulable
 * Provides the needed logic to support the OS Instances
 * matching vs OSLifeCycle__c custom setting list
 *
 * Objects: + OSLifeCycle__c
 *          + vlocity_cmt__OmniScriptInstance__c
 *
 * Important: Batcheable and Scheduleable
 *
 * Version: 1.5
 */


public with sharing class OSLifeCycleJob implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    public String queryString { get;set; }
    public List<OSLifeCycle__c> osLifeCycles { get;set; }

    public OSLifeCycleJob(){
        osLifeCycles = OSLifeCycleHelper.lifeCyclesGetter();
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        queryString = 'SELECT Id,Name,LastModifiedDate,vlocity_cmt__Status__c FROM vlocity_cmt__OmniScriptInstance__c WHERE vlocity_cmt__Status__c != \'Completed\'  LIMIT 2000';
        return Database.getQueryLocator(queryString);
    }
    
    public void execute(Database.BatchableContext bc, List<vlocity_cmt__OmniScriptInstance__c> scope){

        List<vlocity_cmt__OmniScriptInstance__c> osIdsToDeleteList = new List<vlocity_cmt__OmniScriptInstance__c>();
        Set<vlocity_cmt__OmniScriptInstance__c> osIdsSet = new Set<vlocity_cmt__OmniScriptInstance__c>();

        for(vlocity_cmt__OmniScriptInstance__c osInstance : scope){
            for (OSLifeCycle__c osLifeCycle : osLifeCycles) {

                // Trying to match the declared OS Instances with their lifeCycles
                if((osInstance.Name == osLifeCycle.Name) ||
                        osInstance.Name.startsWith('Preview-Saved-OmniScript-') ==
                                osLifeCycle.Name.startsWith('Preview-Saved-OmniScript-')){
                    // Checking if the instance has fulfilled the lifecycle hours limit
                    // current - lastModified > than max allowed lifetime hours
                    if((Decimal.valueOf(OSLifeCycleHelper.getHoursFromDatetime(Datetime.now())
                            - OSLifeCycleHelper.getHoursFromDatetime(osInstance.LastModifiedDate)))
                            > osLifeCycle.LifecycleHours__c){
                        // We add the Id to be deleted since it has more lifetime hours that whata cycle allows
                        osIdsSet.add(new vlocity_cmt__OmniScriptInstance__c(Id = osInstance.Id));
                    }
                } else if(osLifeCycle.Name == 'Generic' && osLifeCycle.LifecycleHours__c > 0){
                    osIdsSet.add(new vlocity_cmt__OmniScriptInstance__c(Id = osInstance.Id));
                }
            }
        }


        osIdsToDeleteList.addAll(osIdsSet);

        /*
        System.debug('queryString status: ' + queryString);
        System.debug('Batch Scope status: ' + scope);
        System.debug('Batch Scope size: ' + scope.size());
        System.debug('List Custom Setting LifeCycles status: ' + osLifeCycles);
        System.debug('List osIdsToDeleteList status: ' + osIdsToDeleteList);
        System.debug('List osIdsToDeleteList size: ' + osIdsToDeleteList.size());
        */

        try {
            delete osIdsToDeleteList;
        } catch (DmlException dmlEx) {
            System.debug('OSLifeCycleJob DML Exception:' + dmlEx);
            System.debug('queryString status: ' + queryString);
            System.debug('Batch Scope status: ' + scope);
            System.debug('Batch Scope size: ' + scope.size());
            System.debug('List Custom Setting LifeCycles status: ' + osLifeCycles);
            System.debug('List osIdsToDeleteList status: ' + osIdsToDeleteList);
            System.debug('List osIdsToDeleteList size: ' + osIdsToDeleteList.size());
        }
    }    
    
    public void execute(SchedulableContext sc){
        Database.executeBatch(new OSLifeCycleJob(), 1000);
        
    }
    
    public void finish(Database.BatchableContext bc){
        // Check if there are no OSInstances left
        List<vlocity_cmt__OmniScriptInstance__c> osLeftInstances = OSLifeCycleHelper.getOSInstancesNotCompleted();
        List<vlocity_cmt__OmniScriptInstance__c> osLeftInstancesThatMatch = new List<vlocity_cmt__OmniScriptInstance__c>();

        for(vlocity_cmt__OmniScriptInstance__c omniScriptInstance : osLeftInstances){
            for (OSLifeCycle__c osLifeCycle : osLifeCycles) {
                if(omniScriptInstance.Name == osLifeCycle.Name){
                        osLeftInstancesThatMatch.add(omniScriptInstance);
                }
            }
        }

        if(!osLeftInstancesThatMatch.isEmpty()){
            // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
            // Schedules to run in 15 minutes
            String jobID = System.schedule('OSLifeCycleJob - ' + Datetime.now(), '0 15 * * * ?', new OSLifeCycleJob());
        } else {
            //If there are no instances left to process in the batch we schedule for next 24hs
            String jobID = System.schedule('OSLifeCycleJob - ' + Datetime.now(), '0 0 23 * * ?', new OSLifeCycleJob());

        }
    }  

}