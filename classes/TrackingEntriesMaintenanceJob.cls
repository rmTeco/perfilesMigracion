global class TrackingEntriesMaintenanceJob implements Database.Batchable<sObject>,Database.Stateful{
    // to remember List Of dml rows.
   //global Set<Id> sobjList = new Set<Id>();
   global Boolean allDone = true;  
   // constructor 
   global TrackingEntriesMaintenanceJob (){
   }
   global Database.QueryLocator start(Database.BatchableContext batchContext) { 
     // do sqol to get data 
     return Database.getQueryLocator('SELECT Id FROM vlocity_cmt__VlocityTrackingEntry__c WHERE CreatedDate < YESTERDAY LIMIT 5000'); 
   }
   global void execute(Database.BatchableContext BC, List<vlocity_cmt__VlocityTrackingEntry__c> vteList){
      allDone = false;
          delete(vteList);
          List<vlocity_cmt__VlocityTrackingEntry__c> vteRemaining = [SELECT Id FROM vlocity_cmt__VlocityTrackingEntry__c WHERE CreatedDate < YESTERDAY LIMIT 5000];
          if(vteRemaining.isEmpty()){
              allDone = true;
              System.debug('vteRemaining.isEmpty() alldone: ' + allDone);
          }
   }
   global void finish(Database.BatchableContext BC){
      // chain the batch job
      if(!allDone){
      System.debug('!alldone: ' + allDone);
          Database.executeBatch(this); 
      } else {
         System.debug('All done.');// fire a trigger or email to start another process.
      } 
   }
}