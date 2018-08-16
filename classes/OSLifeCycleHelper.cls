/**
 * Created by Alex Lazarev 25/10/2017
 *
 * Helper for OSLifeCycleJob
 *
 * Objects: + OSLifeCycle__c
 *          + vlocity_cmt__OmniScriptInstance__c
 *
 * Important: Provides de List of Not completed OS Instances and converts Datetime to hours
 *
 * Version: 1.5
 */


public with sharing class OSLifeCycleHelper {

    public static List<OSLifeCycle__c> lifeCyclesGetter(){
        List<OSLifeCycle__c> oslcs = OSLifeCycle__c.getall().values();

        return oslcs;
    }

    public static List<vlocity_cmt__OmniScriptInstance__c> getOSInstancesNotCompleted(){

        List<vlocity_cmt__OmniScriptInstance__c> osiList = [SELECT Id,Name,LastModifiedDate,vlocity_cmt__Status__c FROM vlocity_cmt__OmniScriptInstance__c WHERE vlocity_cmt__Status__c != 'Completed'  LIMIT 2000];

        //System.debug('CreatedDate: ' + osiList[0].LastModifiedDate);
        //System.debug('Now: ' + Datetime.now());
        //System.debug(OSLifeCycleHelper.getHoursFromDatetime(Datetime.now())
        //        - OSLifeCycleHelper.getHoursFromDatetime(osiList[0].CreatedDate));

        return osiList;
    }

    public static Long getHoursFromDatetime(Datetime dt){

        //Getting time in milliseconds
        Long milliseconds = dt.getTime();
        //Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        Long hours = minutes / 60;
        Long days = hours / 24;

        return hours;
    }
}