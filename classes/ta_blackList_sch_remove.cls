global with sharing class ta_blackList_sch_remove implements Schedulable{

    public void execute(System.SchedulableContext ctx){
        ta_blackList_batch blackListBatch = new ta_blackList_batch();
        
        database.executebatch(blackListBatch, 100);
    }
}