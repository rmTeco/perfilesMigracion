trigger trigMasterUser on User (after delete, after insert, after undelete, after update, before delete, before insert, before update) 
{
    //Runs business logic to Dynamically Select the Approver in a Approval Process
    UserTriggerHandler handler = new UserTriggerHandler(Trigger.isExecuting, Trigger.size);
    
     if(Trigger.isBefore){
       // handler.OnBeforeUpdate(Trigger.newMap,Trigger.old, Trigger.new );
     }   
}