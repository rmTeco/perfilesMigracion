/**
* @author       Norwill Gutiérrez href=<ngutierrez@aconcaguabs.com>
* Project:      Telecom Security
* Description:  Visual Force Page Controller
*
* Changes (Version)
* -------------------------------------
*      No.    Date          Author                 Description
*      -----  ----------    --------------------   ---------------
*      1.0    2018-03-09    Norwill Gutiérrez      Class creation.
*************************************************************************************************************/
public with sharing class assignmentProcessByWorkTeamController{
    public Id vlcActionId {get; set;}
    public String vlcActionName {get; set;}
    public Id workTeamId {get; set;}
    public String workTeamName {get; set;}
    public CustomPermission customPermission {get; set;}
    public static List<String> customPermissionLabelList{get;set;}
    public List<SelectOption> permissionSetOptionsList{get;set;}
    public static String selectedPermissionSetName {get;set;}

    public assignmentProcessByWorkTeamController() {
        customPermission = new CustomPermission();
    }

    public pageReference getPermissionSetsRef() {
      return null;
    }      

    @RemoteAction
    public static void populateCustomPermissionByName(){

    }

    @RemoteAction
    public static String getAllWorkTeams(String permissionSetName){
        String jsonChilds;
        List<workTeamWrapper> tmrList = new List<workTeamWrapper>();
        Set<Id> workTeamsSet = new Set<Id>();
        Set<Id> existingWorkTeamsSet = new Set<Id>();
        String parent;
        List<workteam__c> workTeams = new List<workteam__c> ();
        boolean flagIn = false;
        String permission = '';

        workTeams = [SELECT Id, Team_name__c, Parent_Team__c FROM Workteam__c WHERE Is_Active__c = true AND WorkteamLevel__c != null];

        for(workteam__c w : workTeams){
            workTeamsSet.add(w.Id);
        }

        List<Work_Team_Permission__c> wtpResult = [SELECT Id, Work_Team__c, RecordTypeId, Permission_Set_API_Name__c, Is_Active__c
                                                   FROM  Work_Team_Permission__c 
                                                   WHERE Work_Team__c IN :workTeamsSet AND Is_Active__c = true
                                                   AND Permission_Set_API_Name__c = :permissionSetName ]; 

       for(workteam__c wt : workTeams){
            flagIn = false;
            for(Work_Team_Permission__c wtp : wtpResult){
                if(wtp.Work_team__c == wt.Id){
                    flagIn = true;
                    workTeamWrapper wtr = new workTeamWrapper();
                    wtr.id = wt.id;
                    wtr.text = wt.Team_name__c;
                    if(wt.Parent_Team__c == null){
                        wtr.parent = '#';
                    }else{
                        wtr.parent = wt.Parent_Team__c;
                    }
                    Map<String, boolean> workTeamState = new Map<String, boolean>();
                    workTeamState.put('selected', true);
                    wtr.state = workTeamState;
                    tmrList.add(wtr);
                }
            }
            if(flagIn == false){
                workTeamWrapper wtr = new workTeamWrapper();
                wtr.id = wt.id;
                wtr.text = wt.Team_name__c;
                if(wt.Parent_Team__c == null){
                    wtr.parent = '#';
                }else{
                    wtr.parent = wt.Parent_Team__c;
                }
                Map<String, boolean> workTeamState = new Map<String, boolean>();
                workTeamState.put('selected', false);
                wtr.state = workTeamState;
                tmrList.add(wtr);
            }
        }

        system.debug(JSON.serialize(tmrList));
        return JSON.serialize(tmrList);
    }

 
    @AuraEnabled
    public static Boolean getPermissionAsigmentResult(String teamId, String permissionId, String vlcActionName, String[] selectedTeams){            
        //TODO: COMPARAR LISTA ENVIADA CON LISTA RECIBIDAD Y GUARDAR LOS RESULTADOS
        Boolean saveResult;
        List<RecordType> wtpRecordType = [SELECT Id,Name FROM RecordType WHERE 
                                        sObjectType = 'Work_Team_Permission__c' AND Name = 'Permissions by work team'
                                        LIMIT 1];         
        try{
            if(String.isNotBlank(teamId) && String.isNotBlank(permissionId)){
                Set<Id> wtPAdded = new Set<Id>();
                Set<Id> teamAdded = new Set<Id>();
                List<Work_Team_Permission__c> wtPermissions = new List<Work_Team_Permission__c>();
                if(selectedTeams.size() > 0){
                    for(String teamHierarchy :selectedTeams){
                        teamAdded.add((Id)teamHierarchy);
                    }

                    List<vlocity_cmt__VlocityAction__c> lstQueryVlcName = [SELECT Id, ApplicablePermissionSet__c 
                                                        FROM vlocity_cmt__VlocityAction__c
                                                        WHERE vlocity_cmt__DisplayLabel__c = :vlcActionName
                                                        LIMIT 1 ];
                                                                
                    List<Work_Team_Permission__c> wtpResult = [SELECT 
                                                                    Id, Work_Team__c, RecordTypeId, Permission_Set_API_Name__c, Is_Active__c
                                                                FROM 
                                                                    Work_Team_Permission__c 
                                                                WHERE 
                                                                    Work_Team__c IN :teamAdded 
                                                                    AND Permission_Set_API_Name__c = :lstQueryVlcName[0].ApplicablePermissionSet__c]; 
                    
                    for(Work_Team_Permission__c wtP :wtpResult){
                        wtP.Is_Active__c = true;
                        wtPermissions.add(wtP);
                        wtPAdded.add(wtP.Work_Team__c);
                    }

                    for(String wtH :selectedTeams){
                        if(!wtPAdded.contains((Id)wtH)){
                            Work_Team_Permission__c wtPermission = new Work_Team_Permission__c();
                            wtPermission.Work_Team__c  = (Id)wtH;
                            wtPermission.Permission_Set_API_Name__c  = lstQueryVlcName[0].ApplicablePermissionSet__c;
                            wtPermission.RecordTypeId = wtpRecordType[0].Id;
                            wtPermission.Is_Active__c = true;
                            wtPermissions.add(wtPermission);
                        }
                    }
                }
                upsert wtPermissions;
                saveResult = true;
            }
        }catch(Exception e){
            system.debug('ERROR: ' + e.getMessage());
            saveResult = false;
        }
        return saveResult;
    }

    @AuraEnabled
    public static List<WorkTeamHierarchyNode> getHierarchyWorkTeam(String teamId, String permissionId, String vlcActionName){  
        List<WorkTeam__c> teams = new List<WorkTeam__c>();
        List<WorkTeamHierarchyNode> hierarchyTeams = new List<WorkTeamHierarchyNode>();
        try {
            if(String.isNotBlank(teamId) && String.isNotBlank(permissionId)){
                teams = [SELECT 
                        Id, Team_Name__c, Parent_Team__c, WorkTeamLevel__c                                         
                        FROM WorkTeam__c 
                        WHERE Id = :teamId AND Is_Active__c = true AND WorkteamLevel__c != null];
            }
            if(teams.size() > 0){
                Map<Id, Work_Team_Permission__c> permissionMap = new Map<Id, Work_Team_Permission__c>();
                Set<Id> teamSetIds = WorkTeamHierarchyNode.getSetWorkTeamIds(teams);

                List<vlocity_cmt__VlocityAction__c> lstQueryVlcName = [SELECT Id, ApplicablePermissionSet__c  
                                                                        FROM vlocity_cmt__VlocityAction__c
                                                                        WHERE Id = :permissionId
                                                                        LIMIT 1 ];

                List<Work_Team_Permission__c> wtpResult = [SELECT 
                                                                Id, Work_Team__c, RecordTypeId, Permission_Set_API_Name__c, Is_Active__c
                                                            FROM 
                                                                Work_Team_Permission__c 
                                                            WHERE 
                                                                Work_Team__c IN :teamSetIds 
                                                                AND Permission_Set_API_Name__c = :lstQueryVlcName[0].ApplicablePermissionSet__c ]; 
                
                for(Work_Team_Permission__c wtP :wtpResult){            
                    permissionMap.put(wtP.Work_Team__c, wtP);
                }
                
                hierarchyTeams.add(WorkTeamHierarchyNode.getWorkTeamHierarchyNode(teams, permissionMap));

                return hierarchyTeams;
            }else{
                return null;
            }            
        } catch (Exception e) {
            system.debug('ERROR: ' + e.getMessage());
            return null;   
        }
    }


    public class workTeamWrapper{
        public id id {get;set;}
        public String text {get;set;}
        public String parent {get;set;}
        public boolean children {get;set;}
        public Map<String, boolean> state {get;set;}
    }

    //Work Team Wrapper.
    public class WorkTeamWrapperChanges {
        public Boolean checked{ get; set;}
        public Id wtId { get; set;} 

        public WorkTeamWrapperChanges (Id currentWt, boolean isChecked){
            wtId = currentWt;
            checked = isChecked;
        }
    }
}