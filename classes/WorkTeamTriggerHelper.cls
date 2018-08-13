public without sharing class WorkTeamTriggerHelper{
    
  public WorkTeamTriggerHelper(){
      
  }
  
  /**
  * @Author: Julia Carranza
  * @Description: Not used at the moment.
  */
  /*public static void addMembers(Set<Id> userIds, WorkTeam__c workteam){

      Group currentGroup = [SELECT Id FROM Group WHERE Name = :workteam.PublicGroupAPIName__c];
      
      //Assign users to the group
      List<GroupMember> GpList = new List<GroupMember>();
      for(Id userId: userIds) {
          GroupMember GrpMem = new GroupMember();
          GrpMem.GroupId = currentGroup.Id;
          GrpMem.UserOrGroupId = userId;
          GpList.add(GrpMem);
      }
      
      if(!GpList.isEmpty()) {
          insert GpList;
      }
  }*/

  /**
  * @Author: Julia Carranza
  * @Description: Create Group Members when Work Team Members are created or are activated or deactivated.
  */
  @future
  public static void addGroupMembers(Set<Id> setTeamMembers){
    List<Team_Member__c> temMemberList = new List<Team_Member__c>([SELECT Id, Work_Team__c, User_member__c, Is_Active__c 
                                                                    FROM Team_Member__c 
                                                                    WHERE Id IN:setTeamMembers]);
    System.debug('DEBUG temMemberList: ' + temMemberList);
    Map<Id, Set<Id>> workTeamToUsersMap = new Map<Id, Set<Id>>();

    for(Team_Member__c tMember : temMemberList){
      System.debug('DEBUG tMember: ' + tMember);
      if(!workTeamToUsersMap.containsKey(tMember.Work_Team__c)){
        workTeamToUsersMap.put(tMember.Work_Team__c, new Set<Id>());
      }

      workTeamToUsersMap.get(tMember.Work_Team__c).add(tMember.User_member__c);
    }
    
    System.debug('DEBUG workTeamToUsersMap: ' + workTeamToUsersMap);
    
    Map<String, Group> groupsMap = new Map<String, Group>();
    Map<Id, Workteam__c > workteamsMap = new Map<Id, Workteam__c>([SELECT Id, PublicGroupAPIName__c 
                                                                    FROM WorkTeam__c 
                                                                    WHERE Id IN:workTeamToUsersMap.keySet()]);

    for(WorkTeam__c wt : workteamsMap.values()){
      groupsMap.put(wt.PublicGroupAPIName__c, null);
    }

    for(Group gr : [SELECT Id,developerName FROM Group where developername in:groupsMap.keySet()]){
      groupsMap.put(gr.developerName, gr);
    }

    List<GroupMember> members = new List<GroupMember>();
    for(Id ktId : workTeamToUsersMap.keySet()){
      //estoy sobre un workteam
      Workteam__c wt = workteamsMap.get(ktId);
      Group gr = groupsMap.get(wt.PublicGroupAPIName__c);
      if(gr != Null){
        for(Id userId : workTeamToUsersMap.get(ktId)){
          System.debug('DEBUG workTeamToUsersMap.get(ktId): ' + workTeamToUsersMap.get(ktId));
          //recorro sus usuarios
          GroupMember gm = new GroupMember(GroupId = gr.Id, UserOrGroupId = userId);
          members.add(gm);
        }
      }
    }
    insert members;
  }

  /**
  * @Author: Julia Carranza
  * @Description: Delete a Group Member when a Team Member is deactivated.
  */
  public static void deleteGroupMembersFromInactiveTM(Set<Id> setWTId){

    //tengo que recibir el set ID de los workteam
    List<GroupMember> toDelete = new List<GroupMember>();
    Map<String, Set<Id>> workTeamExtIDToUsersMap = new Map<String, Set<Id>>();
    Map<Id, String> workTeamToExtIDMap = new Map<Id, String>();
    Set<String> setUsersId = new Set<String>();
    Set<Id> setTMId = new Set<Id>();
    Set<Id> setGMId = new Set<Id>();

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

    List<Group> groupList = new List<Group>([SELECT Id, developername, (SELECT Id, UserOrGroupId FROM GroupMembers WHERE UserOrGroupId IN:setUsersId) FROM Group WHERE developername IN: workTeamExtIDToUsersMap.keySet()]);
    for(group g : groupList){
      Set<Id> currentGroupUsersSet = workTeamExtIDToUsersMap.get(g.developername);
      for(GroupMember gm : g.GroupMembers){
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

  /**
  * @Author: Julia Carranza
  * @Description: Delete the corresponding Group Members.
  */
  @future
  public static void deleteGroupMembers(Set<Id> setGMId){
    List<GroupMember> toDelete = new List<GroupMember>([SELECT Id FROM GroupMember WHERE Id IN: setGMId]);
    delete toDelete;
  }

  /**
  * @Author: Julia Carranza
  * @Description: Delete the corresponding Public Group.
  */
  @future
  public static void deleteGroups(Set<String> groupAPINamesSet){
    List<Group> groupsToDelete = new List<Group>([SELECT Id, developername FROM Group WHERE developername IN: groupAPINamesSet]);
    delete groupsToDelete;
  }

  /**
  * @Author: Norwill Gutierrez
  * @Description: Delete the corresponding Public Group when workteam is inactive
  */
  @future
  public static void deleteGroupMember(Set<String> queueAPINamesSet){
		Set<Id> idGrps = new Set<Id>();
		List<Group> grpList = [SELECT Id,DeveloperName FROM Group 
                           WHERE Type = 'Regular' AND DeveloperName =: queueAPINamesSet];
							
		for(Group grp : grpList){
			idGrps.add(grp.Id);
		}    
    
    List<GroupMember> grpMemberToDelete = new List<GroupMember>([SELECT GroupId,Id,UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN :idGrps]);
    delete grpMemberToDelete;
  }  
}