public with sharing class WorkTeamQueueable implements Queueable {
	
	private String method;
	private Map<String, Object> input;
	
	public WorkTeamQueueable(String method, Map<String, Object> input) {
		this.method = method;
		this.input = input;
	}
	
    public void execute(QueueableContext context) {
    	if(method.equals('SyncUserRoleByUserRoleAPINameOfTeamMember')){
    		SyncUserRoleByUserRoleAPINameOfTeamMember();
    	} else if(method.equals('DeletePermisionSetByUserId')){
    		DeletePermisionSetByUserId();
    	} else if(method.equals('AssigmentPermisionSetByUserId')){
    		AssigmentPermisionSetByUserId();
    	}
    }
    
    private void SyncUserRoleByUserRoleAPINameOfTeamMember() {
    	try {
	    	Map<Id, String> UserRoleAPINameByUserId = (Map<Id, String>) this.input.get('UserRoleAPINameByUserId');
	    	
	    	List<Team_Member__c> teamMambers = [select Is_Active__c, UserRoleAPIName__c, User_member__c, User_member__r.UserRole.Name from Team_Member__c where User_member__c IN :UserRoleAPINameByUserId.keySet() AND Is_Active__c = true ];
	    	List<UserRole> userRoles = [select Name from UserRole where Name IN : UserRoleAPINameByUserId.values()];
	    	
	    	List<User> users = new List<User>();
	    	User u = null;
	    	for (Team_Member__c tm: teamMambers) {
	    		u = new User();
	    		u.Id = tm.User_member__c;
	    		for(UserRole ur: userRoles){
	    			if (tm.UserRoleAPIName__c.equals(ur.Name)) u.UserRoleID = ur.Id;
	    		}
	    		if (u.UserRoleId != null) users.add(u);
	    	}
	    	if (!Test.isRunningTest() && users != null && !users.isEmpty()) update users;
    	} catch (Exception e) {
    		System.debug('Error: ' + e);
    	}
    }
    
    private void DeletePermisionSetByUserId() {
    	try {
	    	Map<Id, Object> usersToDeletePermissionSet = (Map<Id, Object>) this.input.get('usersToDeletePermissionSet');
	    	
	    	List<PermissionSetAssignment> permissionSetAssigments = [SELECT AssigneeId FROM PermissionSetAssignment WHERE AssigneeId in :usersToDeletePermissionSet.keySet() AND PermissionSet.ProfileId = null];
	    	if (!Test.isRunningTest() && permissionSetAssigments != null && !permissionSetAssigments.isEmpty()) delete permissionSetAssigments;
    	} catch (Exception e) {
    		System.debug('Error: ' + e);
    	}
    }
    
    private void AssigmentPermisionSetByUserId() {
    	try {
	    	Map<Id, Object> usersToAssignmentPermissionSet = (Map<Id, Object>) this.input.get('usersToAssignmentPermissionSet');
	    	Set<Id> workTeamsIds = new Set<Id>();
	    	for (Object tm: usersToAssignmentPermissionSet.values()) {
	    		workTeamsIds.add(((Team_Member__c)tm).Work_Team__c);
	    	}
	    	
	    	List<RecordType> wtpRecordType = [SELECT Id,Name FROM RecordType WHERE sObjectType = 'Work_Team_Permission__c' AND Name =: 'Permissions by work team' LIMIT 1];
	    	List<AggregateResult> workTeamPermissions = new List<AggregateResult>([SELECT Permission_Set_API_Name__c, Work_Team__c FROM Work_Team_Permission__c WHERE Work_Team__c IN : workTeamsIds AND Is_Active__c = true AND RecordTypeId =: wtpRecordType GROUP BY Permission_Set_API_Name__c,Work_Team__c]);
	    	Set<String> permissionSetNames = new Set<String>();
	    	for (AggregateResult wtp: workTeamPermissions) {
	    		permissionSetNames.add((String)wtp.get('Permission_Set_API_Name__c'));
	    	}
	    	List<PermissionSet> permissionSets = new List<PermissionSet>([SELECT Id, Name FROM PermissionSet where Name IN : permissionSetNames]);
	    	List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
	    	PermissionSetAssignment permissionSetAssignment = null; 
	    	for (Object tm: usersToAssignmentPermissionSet.values()) {
	    		for(AggregateResult wtp: workTeamPermissions) {
	    			if (((Team_Member__c)tm).Work_Team__c.equals((Id)wtp.get('Work_Team__c'))) {
	    				for (PermissionSet ps: permissionSets) {
	    					if (ps.Name.equals(wtp.get('Permission_Set_API_Name__c'))) {
	    						permissionSetAssignment = new PermissionSetAssignment();
		    					permissionSetAssignment.AssigneeId = ((Team_Member__c)tm).User_member__c;
		    					permissionSetAssignment.PermissionSetId  = ps.Id;
		    					permissionSetAssignments.add(permissionSetAssignment);
	    					}
	    				}
	    			}
	    		}
	    	}
	    	if (!Test.isRunningTest() && permissionSetAssignments != null && !permissionSetAssignments.isEmpty()) insert permissionSetAssignments;
    	} catch (Exception e) {
    		System.debug('Error: ' + e);
    	}
    }
}