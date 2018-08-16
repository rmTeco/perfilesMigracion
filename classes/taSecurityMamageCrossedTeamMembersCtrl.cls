public with sharing class taSecurityMamageCrossedTeamMembersCtrl {
    Public  Id vlcActionId {get; set;}
    Public String vlcActionName {get; set;}
    Public Id permissionId {get; set;}
    Public Id workTeamId {get; set;}
    Public String workTeamName {get; set;}

    @RemoteAction
    public static String getWorkTeamsByParentId(String rootFlag, String vlocityAction, String teamId){
    	String jsonChilds;
    	List<workTeamWrapper> tmrList = new List<workTeamWrapper>();
    	Set<Id> workTeamsSet = new Set<Id>();
    	String parent;
    	//Id parentId = Id.valueOf(teamId);

    	system.debug('vlocityAction: '+vlocityAction);
    	system.debug('rootFlag: '+rootFlag);
    	system.debug('teamId: '+teamId);

    	if(rootFlag == '#'){
	        List<vlocity_cmt__VlocityAction__c> lstQueryVlcName = [SELECT Id, ApplicablePermissionSet__c  
	                                                               FROM vlocity_cmt__VlocityAction__c
	                                                               WHERE Id = :vlocityAction
	                                                               LIMIT 1 ];


	        system.debug('lstQueryVlcName: ' + lstQueryVlcName);

			List<workteam__c> workTeams = [SELECT Id, Team_name__c FROM Workteam__c WHERE Parent_Team__c  = :teamId AND Is_Active__c = true AND WorkteamLevel__c != null];

			for(workteam__c w : workTeams){
				workTeamsSet.add(w.Id);
			}

			system.debug('workTeamsSet: ' + workTeamsSet);

	        List<Work_Team_Permission__c> wtpResult = [SELECT Id, Work_Team__c, RecordTypeId, Permission_Set_API_Name__c, Is_Active__c
	                                                   FROM  Work_Team_Permission__c 
	                                                   WHERE Work_Team__c IN :workTeamsSet 
	                                                   AND Permission_Set_API_Name__c = :lstQueryVlcName[0].ApplicablePermissionSet__c ]; 

	        system.debug('wtpResult: ' + wtpResult);

			for(workteam__c wt : workTeams){
				for(Work_Team_Permission__c wtp : wtpResult){
					if(workTeamsSet.contains(wtp.Work_Team__c)){
						if(wtp.Work_team__c == wt.Id){
				            workTeamWrapper wtr = new workTeamWrapper();
				            wtr.id = wt.id;
				            wtr.text = wt.Team_name__c;
				            wtr.parent = '#';
				            wtr.children = true;
				            if(wtp.Is_Active__c){
				            	Map<String, boolean> workTeamState = new Map<String, boolean>();
				            	workTeamState.put('selected', true);
				            	wtr.state = workTeamState;
				            }
				            tmrList.add(wtr);
						}
					}else{
		            	workTeamWrapper wtr = new workTeamWrapper();
			            wtr.id = wt.id;
			            wtr.text = wt.Team_name__c;
			            wtr.parent = '#';
			            wtr.children = true;
		            	Map<String, boolean> workTeamState = new Map<String, boolean>();
		            	workTeamState.put('selected', false);
		            	wtr.state = workTeamState;
			            tmrList.add(wtr);						
					}
				}
			}
    	}else{
        	List<vlocity_cmt__VlocityAction__c> lstQueryVlcName = [SELECT Id, ApplicablePermissionSet__c  
	                                                               FROM vlocity_cmt__VlocityAction__c
	                                                               WHERE Id = :vlocityAction
	                                                               LIMIT 1 ];


	        system.debug('lstQueryVlcName: ' + lstQueryVlcName);

			List<workteam__c> workTeams = [SELECT Id, Team_name__c FROM Workteam__c WHERE Parent_Team__c  = :rootFlag AND Is_Active__c = true AND WorkteamLevel__c != null];

			for(workteam__c w : workTeams){
				workTeamsSet.add(w.Id);
			}

			system.debug('workTeamsSet: ' + workTeamsSet);

	        List<Work_Team_Permission__c> wtpResult = [SELECT Id, Work_Team__c, RecordTypeId, Permission_Set_API_Name__c, Is_Active__c
	                                                   FROM  Work_Team_Permission__c 
	                                                   WHERE Work_Team__c IN :workTeamsSet 
	                                                   AND Permission_Set_API_Name__c = :lstQueryVlcName[0].ApplicablePermissionSet__c ]; 

	        system.debug('wtpResult: ' + wtpResult);

			for(workteam__c wt : workTeams){
				for(Work_Team_Permission__c wtp : wtpResult){
					if(workTeamsSet.contains(wtp.Work_Team__c)){
						if(wtp.Work_team__c == wt.Id){
				            workTeamWrapper wtr = new workTeamWrapper();
				            wtr.id = wt.id;
				            wtr.text = wt.Team_name__c;
				            wtr.parent = rootFlag;
				            wtr.children = true;
				            if(wtp.Is_Active__c){
				            	Map<String, boolean> workTeamState = new Map<String, boolean>();
				            	workTeamState.put('selected', true);
				            	wtr.state = workTeamState;
				            }
				            tmrList.add(wtr);
						}
					}else{
			            workTeamWrapper wtr = new workTeamWrapper();
			            wtr.id = wt.id;
			            wtr.text = wt.Team_name__c;
			            wtr.parent = rootFlag;
			            wtr.children = true;
		            	Map<String, boolean> workTeamState = new Map<String, boolean>();
		            	workTeamState.put('selected', false);
		            	wtr.state = workTeamState;

			            tmrList.add(wtr);				
					}
				}
			}
    	}

		system.debug(JSON.serialize(tmrList));
		return JSON.serialize(tmrList);
	}

    public class workTeamWrapper{
        public id id {get;set;}
        public String text {get;set;}
        public String parent {get;set;}
        public boolean children {get;set;}
        public Map<String, boolean> state {get;set;}
    }
}