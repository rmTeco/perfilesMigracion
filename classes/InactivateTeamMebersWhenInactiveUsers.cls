public with sharing class InactivateTeamMebersWhenInactiveUsers implements Queueable {
	
	private String method;
	private Map<String, Object> input;
	
	public InactivateTeamMebersWhenInactiveUsers (String method, Map<String, Object> input) {
		this.method = method;
		this.input = input;
	}
	
    public void execute(QueueableContext context) {
    	if (method.equals('inactivateTeamMebers')) {
    		inactivateTeamMebers();
    	}
    }
    
    private void inactivateTeamMebers () {
    	List<User> usersInactive = (List<User>) input.get('usersInactive');    	
    	
        // For each listing record, extracts the specific user ID.
        Map<Id,User> usersId = new Map<Id,User>(usersInactive) ;        
        
        // Selecting Approval processes with "Pendientes" status
        List<processInstanceWorkItem> processWorkItem = [SELECT Id, ActorId FROM ProcessInstanceWorkitem WHERE ActorId IN : usersId.keySet() AND Isdeleted = false AND ProcessInstance.Status = 'Pending'];
        
        // Selecting associated cases to the inactivated users to update the Owner field for each one.
        List<Case> userCases = [SELECT CaseNumber, OwnerId FROM Case Where OwnerId IN : usersId.keySet() and IsDeleted = false ];

    	// Selecting the work team where the users are active
    	List<Team_Member__c> userWorkTeam = [SELECT User_Member__c, Work_Team__r.Manager__c, Work_Team__c, Work_Team__r.Parent_Team__c FROM Team_Member__c WHERE IsDeleted = false AND Is_Active__c = true AND User_Member__c IN :usersId.keySet() ];

        // Fill a map for searching the ParentTeam value and its Manager
        Map<Id,WorkTeam__c> parentTeam = new Map<Id,WorkTeam__c>() ; //([SELECT Id, Manager__c FROM WorkTeam__c Where IsDeleted = false]);
        
        for(WorkTeam__c wrk : [SELECT Id, Manager__c, Parent_Team__c FROM WorkTeam__c Where IsDeleted = false AND Is_Active__c = true])
        {
        	parentTeam.put(wrk.id,wrk);
        }             	
    	  	
		// This cycle reads each inactivated user and updating each pending approval case assigned to the inactivated user with the Manager Id, according to:
		// if the team assigned to the inactivated group has or has not a manager
		// In case of the team has not a designated manager, the process skips to the parent team and updates the record with its manager
		// Finally, reads the entire cycle until to find out a parent or to read all data.    	
    	long llTotalWorkTeams = parentTeam.size();    	
    	 
    	for(Team_Member__c usr : userWorkTeam){
    		
    		Id lidMgrTeam = usr.Work_Team__r.Manager__c;
    		
    		if(lidMgrTeam == null && usr.Work_Team__r.Parent_Team__c != null)
    		{
    		   // Selecting a manager for updating th Case Owner
    		   Id lsParentTeam = usr.Work_Team__r.Parent_Team__c;
    		   WorkTeam__c lsWorkTeam = parentTeam.get(lsParentTeam);
    		   
    		   Id lidManager = lsWorkTeam.Manager__c;
    		       		   
    		   long llRecords = 0;
    		   
    		   while(lidManager == null && llRecords < llTotalWorkTeams){ 		       
    		     
    		       try{
    		           WorkTeam__c lwtManagerParent = parentTeam.get(lsWorkTeam.Parent_Team__c);
    		           lidManager = lwtManagerParent.Manager__c;
    		       
    		           lsParentTeam = lwtManagerParent.Parent_Team__c;
    		   	       lsWorkTeam = parentTeam.get(lsParentTeam);
    		       }
    		       catch(System.NullPointerException e){
    		           System.Debug('Parent team missing for user: ' + usr.User_Member__c );	    		       	
    		       }
    		       
    		   	   llRecords ++;
    		   }
    		   
     		   // The Manager Id found out is assigned to the variable for updating
    		   // the inactivated user
    		   lidMgrTeam = lidManager;
   		
    		}
    		
    		 // Reading all cases and updating each one of the inactivated user with
    		 // the owner id found above
    		 	for(Case lcUserCase :userCases ){
    		   	    if(lcUserCase.OwnerId == usr.User_Member__c && lidMgrTeam != null){
    		   	 	    lcUserCase.OwnerId = lidMgrTeam;
    		   	    }
    		    }
    		    
    		 // Reading Approval Processes assigned to the inactivated user and update the ActorId field with 
    		 // the owner id found above
    		    for(ProcessInstanceWorkitem lpIWI :processWorkItem){
    		    	if(lpIWI.ActorId == usr.User_Member__c && lidMgrTeam != null){
    		    		lpIWI.ActorId = lidMgrTeam;
    		    	}
    		    }   		
    	}
    	    	    	
    	Update userCases;
    	
    	Update processWorkItem;
    	    	
    	Map<Id, User> usersById = new Map<Id,User>(usersInactive);
    	
    	List<Team_Member__c> teamMambersToInactivate = [select Is_Active__c from Team_Member__c where Is_Active__c = true AND UserRoleAPIName__c != null AND User_member__c IN :usersById.keySet()];
    	for (Team_Member__c tm: teamMambersToInactivate) {
    		tm.Is_Active__c = false;
    	}
    	if (!teamMambersToInactivate.isEmpty()) update teamMambersToInactivate;
    }
}