/**
* @Author: Julia Carranza
* @Description: Trigger Handler Class for the Team Member Object.
*/
public class TeamMemberTrigger {

	public static void onAfterInsert(){
		Map<String, Object> input = new Map<String, Object>();
		String method;

		Set<Id> teamMemberSet = new Set<Id>();
		
		Map<Id,String> UserRoleAPINameByUserId = new Map<Id, String>();
		Map<Id,Object> usersToAssignmentPermissionSet = new Map<Id, Object>();
		for(Team_Member__c teamMember : (List<Team_Member__c>)Trigger.new){
			if(teamMember.Is_Active__c == true){
				teamMemberSet.add(teamMember.Id);
				if (String.isNotBlank(teamMember.UserRoleAPIName__c)) {
					UserRoleAPINameByUserId.put(teamMember.User_member__c,teamMember.UserRoleAPIName__c);
				}
				usersToAssignmentPermissionSet.put(teamMember.User_member__c,teamMember); //Assignment Permission if Is_Active__c == true
			}
		}
		
		if (!UserRoleAPINameByUserId.keySet().isEmpty()) {
			method = 'SyncUserRoleByUserRoleAPINameOfTeamMember';
			input.put('UserRoleAPINameByUserId', UserRoleAPINameByUserId);
			if (!Test.isRunningTest()) System.enqueueJob(new WorkTeamQueueable(method, input));
		}
		//--------------------------------------------------------------------//	
		
		
		//Assignment Permission if Is_Active__c == true
		System.debug('antes del if');
		if (!usersToAssignmentPermissionSet.keySet().isEmpty()) {
			System.debug('dentro del if');
			method = 'AssigmentPermisionSetByUserId';
			input = new Map<String, Object>();
			input.put('usersToAssignmentPermissionSet', usersToAssignmentPermissionSet);
			if (!Test.isRunningTest()) System.enqueueJob(new WorkTeamQueueable(method, input));
		}	
	}
    
    //onBeforeUpdate() --> Name Changed By Luiscarl Jordán
	public static void onBeforeUpdate(){

		Set<Id> teamMemberActiveSet = new Set<Id>();
		Set<Id> teamMemberNoActiveSet = new Set<Id>();

		//ACTIVE
		for(Team_Member__c teamMember : (List<Team_Member__c>)Trigger.new){
			if(teamMember.Is_Active__c == true){
				teamMemberActiveSet.add(teamMember.Id);
			} else if(teamMember.Is_Active__c == false){
				teamMemberNoActiveSet.add(teamMember.Id);
			}
		} 
		WorkTeamTriggerHelper.addGroupMembers(teamMemberActiveSet);
		
		//INACTIVE
		Set<Id> setWTId = new Set<Id>();
		for(Team_Member__c tMember : (List<Team_Member__c>)Trigger.old){
			if(teamMemberNoActiveSet.contains(tMember.Id)){
				setWTId.add(tMember.Work_Team__c);
			}
		}
		WorkTeamTriggerHelper.deleteGroupMembersFromInactiveTM(setWTId);
	}

	public static void onAfterDelete(){
		//is active - trigger old
		List<GroupMember> toDelete = new List<GroupMember>();
		Map<String, Set<Id>> workTeamExtIDToUsersMap = new Map<String, Set<Id>>();
		Map<Id, String> workTeamToExtIDMap = new Map<Id, String>();
		Set<String> setUsersId = new Set<String>();
		Set<Id> setTMId = new Set<Id>();
		Set<Id> setWTId = new Set<Id>();
		Set<Id> setGMId = new Set<Id>();

		for(Team_Member__c tMember : (List<Team_Member__c>)Trigger.old){
			if(tMember.Is_Active__c == true){
				setWTId.add(tMember.Work_Team__c);
			}
		}

		List<WorkTeam__c> wtList = new List<WorkTeam__c>([SELECT Id, PublicGroupAPIName__c FROM WorkTeam__c WHERE Id IN:setWTId]);
		for(WorkTeam__c wt : wtList){

			workTeamToExtIDMap.put(wt.Id,wt.PublicGroupAPIName__c);
		}

		for(Team_Member__c tMember : (List<Team_Member__c>)Trigger.old){

			if(tMember.Is_Active__c == true){
				setUsersId.add(tMember.User_member__c);
				String apiName = workTeamToExtIDMap.get(tMember.Work_Team__c);
				if(!workTeamExtIDToUsersMap.containsKey(apiName)){
					workTeamExtIDToUsersMap.put(apiName, new Set<Id>());
				}

				workTeamExtIDToUsersMap.get(apiName).add(tMember.User_member__c);
			}
		}
		
		System.debug('setUsersId: ' + setUsersId);
		//List<Group> groupList = new List<Group>([SELECT Id, developername, (SELECT Id FROM GroupMembers WHERE UserOrGroupId IN:setUsersId) FROM Group WHERE developername IN: workTeamExtIDToUsersMap.keySet()]);
		List<Group> groupList = new List<Group>([SELECT Id, developername, (SELECT Id, UserOrGroupId FROM GroupMembers WHERE UserOrGroupId IN:setUsersId) FROM Group WHERE developername IN: workTeamExtIDToUsersMap.keySet()]);
		System.debug('groupList: ' + groupList);
		for(group g : groupList){
			System.debug('g: ' + g);
			Set<Id> currentGroupUsersSet = workTeamExtIDToUsersMap.get(g.developername);
			for(GroupMember gm : g.GroupMembers){
				System.debug('gm: ' + gm);
				if(currentGroupUsersSet.contains(gm.UserOrGroupId)){
				toDelete.add(gm);
				}
			}
		}

		for(GroupMember gm : toDelete){
			setGMId.add(gm.id);
		}

		WorkTeamTriggerHelper.deleteGroupMembers(setGMId);
	}
	
	//Created by: Luiscarl Jordán
	//Description: Events After Update
	public static void onAfterUpdate() {
		Map<String, Object> input = new Map<String, Object>();
		String method;
		//(Update UserRole of User Object)
		Map<Id,String> UserRoleAPINameByUserId = new Map<Id, String>();
		for (Id teamMemberId: Trigger.newMap.keySet()) {
			if(((Team_Member__c)Trigger.newMap.get(teamMemberId)).Is_Active__c && ((Team_Member__c)Trigger.oldMap.get(teamMemberId)).UserRoleAPIName__c != ((Team_Member__c)Trigger.newMap.get(teamMemberId)).UserRoleAPIName__c) {
				UserRoleAPINameByUserId.put(((Team_Member__c)Trigger.newMap.get(teamMemberId)).User_member__c,((Team_Member__c)Trigger.newMap.get(teamMemberId)).UserRoleAPIName__c);
			}
		}
		if (!UserRoleAPINameByUserId.keySet().isEmpty()) {
			method = 'SyncUserRoleByUserRoleAPINameOfTeamMember';
			input.put('UserRoleAPINameByUserId', UserRoleAPINameByUserId);
			if (!Test.isRunningTest()) System.enqueueJob(new WorkTeamQueueable(method, input));
		}
		//--------------------------------------------------------------------//
		
		//Delete Permission if Is_Active__c == false
		Map<Id,Object> usersToDeletePermissionSet = new Map<Id, Object>();
		for (Id teamMemberId: Trigger.newMap.keySet()) {
			if(!(((Team_Member__c)Trigger.newMap.get(teamMemberId)).Is_Active__c) && ((Team_Member__c)Trigger.oldMap.get(teamMemberId)).Is_Active__c && ((Team_Member__c)Trigger.newMap.get(teamMemberId)).User_Member__r.IsActive) {
				usersToDeletePermissionSet.put(((Team_Member__c)Trigger.newMap.get(teamMemberId)).User_member__c,(Team_Member__c)Trigger.newMap.get(teamMemberId));
			}
		}
		
		if (!usersToDeletePermissionSet.keySet().isEmpty()) {
			method = 'DeletePermisionSetByUserId';
			input.put('usersToDeletePermissionSet', usersToDeletePermissionSet);
			if (!Test.isRunningTest()) System.enqueueJob(new WorkTeamQueueable(method, input));
		}
		//--------------------------------------------------------------------//
		
		//Assignment Permission if Is_Active__c == true
		Map<Id,Object> usersToAssignmentPermissionSet = new Map<Id, Object>();
		for (Id teamMemberId: Trigger.newMap.keySet()) {
			if((((Team_Member__c)Trigger.newMap.get(teamMemberId)).Is_Active__c) && !((Team_Member__c)Trigger.oldMap.get(teamMemberId)).Is_Active__c) {
				usersToAssignmentPermissionSet.put(((Team_Member__c)Trigger.newMap.get(teamMemberId)).User_member__c,(Team_Member__c)Trigger.newMap.get(teamMemberId));
			}
		}
		
		if (!usersToAssignmentPermissionSet.keySet().isEmpty()) {
			method = 'AssigmentPermisionSetByUserId';
			input.put('usersToAssignmentPermissionSet', usersToAssignmentPermissionSet);
			if (!Test.isRunningTest()) System.enqueueJob(new WorkTeamQueueable(method, input));
		}
	}
}