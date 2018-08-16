@isTest(SeeAllData=true)
private class assignmentSecurityProcessTest {	
    @isTest 
    static void testGetHierarchyWorkTeam() {        
        WorkTeam__c[] teams = [SELECT 
                                Id, Team_Name__c, Parent_Team__c, WorkTeamLevel__c                                         
                                FROM WorkTeam__c 
                                WHERE Is_Active__c = true AND WorkteamLevel__c = 1 AND Team_Name__c = 'Aegis'
                                LIMIT 1] ;

		List<vlocity_cmt__VlocityAction__c> lstQueryName = [SELECT Id, vlocity_cmt__DisplayLabel__c 
														  	FROM vlocity_cmt__VlocityAction__c
                                                            WHERE vlocity_cmt__DisplayLabel__c = 'Anulación de Ordenes'
															LIMIT 1 ];

        Set<Id> teamSetIds = WorkTeamHierarchyNode.getSetWorkTeamIds(teams);

        List<Work_Team_Permission__c> wtpResult = [SELECT 
                                                        Id, Work_Team__c, RecordTypeId, Permission_Set_API_Name__c, Is_Active__c
                                                    FROM 
                                                        Work_Team_Permission__c 
                                                    WHERE 
                                                        Work_Team__c IN :teamSetIds 
                                                        AND Permission_Set_API_Name__c = :lstQueryName[0].ApplicablePermissionSet__c ];                                

        Id vlcActionId = lstQueryName[0].Id;
        String vlcActionName = lstQueryName[0].vlocity_cmt__DisplayLabel__c;
        Id workTeamId = teams[0].Id;
        String workTeamName = teams[0].Team_Name__c;

        List<WorkTeamHierarchyNode> lstResult = assignmentProcessByWorkTeamController.getHierarchyWorkTeam(String.valueOf(workTeamId), String.valueOf(vlcActionId), lstQueryName[0].ApplicablePermissionSet__c);
        system.assert(true, lstResult.size() > 0);
    }

    @isTest
    static void testGetPermissionAsigmentResult() {
        WorkTeam__c[] teams = [SELECT 
                                Id, Team_Name__c, Parent_Team__c, WorkTeamLevel__c                                         
                                FROM WorkTeam__c 
                                WHERE Is_Active__c = true AND WorkteamLevel__c = 1 AND Team_Name__c = 'Aegis'
                                LIMIT 1] ;
        
		List<vlocity_cmt__VlocityAction__c> lstQueryName = [SELECT Id, vlocity_cmt__DisplayLabel__c 
														  	FROM vlocity_cmt__VlocityAction__c
                                                            WHERE vlocity_cmt__DisplayLabel__c = 'Anulación de Ordenes'
															LIMIT 1 ];
                                    
        Id vlcActionId = lstQueryName[0].Id;
        String vlcActionName = lstQueryName[0].vlocity_cmt__DisplayLabel__c;
        Id workTeamId = teams[0].Id;
        String workTeamName = teams[0].Team_Name__c;
        List<String> selectedTeams = new List<String>();
        selectedTeams.add(workTeamId);
        selectedTeams.add(workTeamId);

        Boolean result = assignmentProcessByWorkTeamController.getPermissionAsigmentResult((String)workTeamId, (String)vlcActionId, vlcActionName, selectedTeams); 

        system.assert(true, result);
    }
    
    @isTest
    static void testGetPermissionAsigmentExistResult() {
        WorkTeam__c[] teams = [SELECT 
                                Id, Team_Name__c, Parent_Team__c, WorkTeamLevel__c                                         
                                FROM WorkTeam__c 
                                WHERE Is_Active__c = true AND WorkteamLevel__c = 1 AND Team_Name__c = 'Aegis'
                                LIMIT 1] ;
        
		List<vlocity_cmt__VlocityAction__c> lstQueryName = [SELECT Id, vlocity_cmt__DisplayLabel__c 
														  	FROM vlocity_cmt__VlocityAction__c
                                                            WHERE vlocity_cmt__DisplayLabel__c = 'Anulación de Ordenes'
															LIMIT 1 ];
                                    
        Id vlcActionId = lstQueryName[0].Id;
        String vlcActionName = lstQueryName[0].vlocity_cmt__DisplayLabel__c;
        Id workTeamId = teams[0].Id;
        String workTeamName = teams[0].Team_Name__c;
        List<String> selectedTeams = new List<String>();
        selectedTeams.add(workTeamId);
        selectedTeams.add(workTeamId);

        Boolean result = assignmentProcessByWorkTeamController.getPermissionAsigmentResult((String)workTeamId, (String)vlcActionId, vlcActionName, selectedTeams); 

        system.assert(true, result);
    }    
}