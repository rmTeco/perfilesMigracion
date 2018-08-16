public with sharing class UserTriggerHandler {
	private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public UserTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    public static void OnBeforeUpdate(Map<ID, User> userMap, User[] oldUsers, User[] updatedUsers){
        
        Map<ID, User> newUsrIds = new Map<ID, User>();
      //  Boolean indProceso= false;
        
        for ( User newUser : updatedUsers){
        	
        	if (newUser.IsActive == false){
        		newUsrIds.put(newUser.Id, newUser);
        		//indProceso = true;
        	}        	
        }
        
    /*    if (!indProceso){
        	System.debug('No existen usuarios inactivos para procesar');
            return;        	
        }
                  */      
        try {
                // Retrieve all approvals assigned to the users with active status equal to false
                List<ProcessInstanceWorkItem> procItemList = [Select p.ProcessInstance.Status, 
                                                              p.ProcessInstance.TargetObjectId,
                                                              p.ProcessInstanceId,
                                                              p.OriginalActorId,
                                                              p.Id,
                                                              p.ActorId
                                                         From ProcessInstanceWorkitem p 
                                                        where p.OriginalActorId = :newUsrIds.keySet()
                                                          and p.IsDeleted = false
                                                          and p.ProcessInstance.CompletedDate = null
                                                     ORDER BY p.OriginalActorId ASC NULLS LAST];
                
                if(procItemList.size() > 0){
                    Id newId = '0056C000000xw4A';
                    
                    Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                    req2.setComments('Approving request for User Inactivation.');
                    req2.setAction('Approve');
                    req2.setNextApproverIds(new Id[] {newId});
                    
                }else{
                	System.debug('No tiene Aprobaciones Pendientes');
                	return;
                }                 	
        }
        catch(Exception e) {
    		System.debug('Se produjo un error en la re-asignacion de Aprobaciones: ' + e);
    		return;
        }
         
        return ;
    }
}