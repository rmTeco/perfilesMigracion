public class ta_security_adminwtmemberscontroller {
    public List<Team_member__c> workteam_Members {get;set;}
    public static List<workteam__c> workTeams {get;set;}
    public List<memberWrapper> teamMembers {get;set;}
    public List<memberWrapper> membersToMove {get;set;}
    public List<Team_member__c> membersToSave {get;set;}
    public Set<Id> membersSet {get;set;}
    public String selectedId {get;set;}
    public String saveId {get;set;}
    public Boolean displayPopup {get;set;}
    public Team_member__c foreignMember {get;set;}
    public List<SelectOption> permissionOptions {get;set;}
    public String userFile {get;set;}

    public ta_security_adminwtmemberscontroller(){
        initialize();
    }

    private void initialize(){
        permissionOptions = new List<SelectOption>();
        workTeams = new List<workteam__c>();
        foreignMember = new Team_member__c();
        saveId = null;
        selectedId = null;
        membersSet = new Set<Id>();
        displayPopup = false;
        workteam_Members = new List<Team_member__c>();
        membersToMove = new List<memberWrapper>();
        teamMembers = new List<memberWrapper>();
    }

    @RemoteAction
    public static String getWorkTeamsByParentId(String rootFlag){
        String jsonChilds;
        List<workTeamWrapper> tmrList = new List<workTeamWrapper>();
        Set<Id> workTeamsSet = new Set<Id>();
        Set<Id> existingWorkTeamsSet = new Set<Id>();
        String parent;
        List<workteam__c> workTeams = new List<workteam__c> ();
        //Constants
        //teamId = 'a4l6C00000006rj';
        //vlocityAction = 'a356C000000Mg8NQAS';
        system.debug('rootFlag: '+rootFlag);
        system.debug('parent: '+parent);


        if(rootFlag == '#'){
            workTeams = [SELECT Id, Team_name__c FROM Workteam__c WHERE Parent_Team__c = null AND Is_Active__c = true AND WorkteamLevel__c != null];
        }else{
            workTeams = [SELECT Id, Team_name__c FROM Workteam__c WHERE Parent_Team__c  = :rootFlag AND Is_Active__c = true AND WorkteamLevel__c != null];
        }


       for(workteam__c wt : workTeams){
            workTeamWrapper wtr = new workTeamWrapper();
            wtr.id = wt.id;
            wtr.text = wt.Team_name__c;
            if(rootFlag == '#'){
                wtr.parent = '#';
            }else{
                wtr.parent = rootFlag;
            }
            wtr.children = true;
            tmrList.add(wtr);
        }

        system.debug(JSON.serialize(tmrList));
        return JSON.serialize(tmrList);
    }

    @RemoteAction
    public static String feedTree(){
        Set<Id> treeIds = new Set<Id>();
        List<workTeamWrapper> workTeamsTree = new List<workTeamWrapper>();
        workTeams = [SELECT Id, Team_name__c, Parent_Team__c
                       FROM Workteam__c 
                      WHERE Manager__c = :UserInfo.getUserId()
                        AND Is_Active__c = true
                   ORDER BY Team_name__c];

        for(Workteam__c wt : workTeams){
            WorkTeamWrapper newTm = new workTeamWrapper();
            newTm.id = wt.Id;
            newTm.text = wt.Team_Name__c;
            newTm.parent = wt.Parent_Team__c;
            workTeamsTree.add(newTm);
            treeIds.add(wt.Id);
        }

        for(WorkTeamWrapper wt : workTeamsTree){
            if(!treeIds.contains(wt.parent)){
                wt.parent = '#';
            }
        }
        return JSON.serialize(workTeamsTree);
    }

    public void View(){
        teamMembers.clear();
        workteam_Members = [SELECT Id, User_member__c, User_member__r.Name, User_member__r.FederationIdentifier, 
                                   UserRoleAPIName__c, Work_team__c
                              FROM Team_member__c 
                             WHERE Work_team__c = :selectedId
                               AND Is_Active__c = true
                             ORDER BY User_member__r.Name];
        for(Team_member__c tm : workteam_Members){
            teamMembers.add(new memberWrapper(tm));
        }
    }

    public void Move(){//No borrar!
    }

    public void Save(){
        membersToMove.clear();
        for(memberWrapper mw : teamMembers){
            if(mw.selected == true){
                membersToMove.add(mw);
            }
        }
        membersToSave = new List<Team_member__c>();
        for(memberWrapper mw : membersToMove){
            membersSet.add(mw.team_member.User_member__c);
            mw.team_member.Is_Active__c = false;
            membersToSave.add(mw.team_member);
        }
        upsertRecords();
        initialize();
    }

    public void upsertRecords(){
        Set<Id> existingIds = new Set<Id>();
        List<Team_member__c> existingMembers = [SELECT Id, User_member__c, UserRoleAPIName__c, Work_team__c
                                                  FROM Team_member__c
                                                 WHERE User_member__c IN :membersSet
                                                   AND Work_team__c = :saveId];
        
        for(Team_member__c tmToActivate : existingMembers){
            tmToActivate.Is_Active__c = true;
            existingIds.add(tmToActivate.User_member__c);
        }

        for(Team_member__c tmToSave : membersToSave){
            if(existingIds.contains(tmToSave.User_member__c)){
                continue;
            }
            existingMembers.add(new Team_member__c(Is_Active__c = true,
                                                   User_member__c = tmToSave.User_member__c,
                                                   UserRoleAPIName__c = tmToSave.UserRoleAPIName__c,
                                                   Work_team__c = saveId));
        }
        update membersToSave;
        upsert existingMembers;
    }
    
    public void ViewTeam(){
        foreignMember.Work_team__c = selectedId;
        workteam_Members = [SELECT Id, User_member__c, User_member__r.Name, User_member__r.FederationIdentifier, UserRoleAPIName__c, Work_team__c
                              FROM Team_member__c 
                             WHERE Work_team__c = :selectedId
                               AND Is_Active__c = true
                             ORDER BY User_member__r.Name];
    }

    public Void Assign(){
        if(foreignMember.User_member__c == Null){
            return;
        }

        if(selectedId == Null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.MustSelectWorkTeam));
            return;
        }

        List<Team_member__c> existingMembers = new List<Team_member__c>();
        List<Team_member__c> activeAssignments = new List<Team_member__c>();
        foreignMember.UserRoleAPIName__c = '0';

        activeAssignments = [SELECT Id, Is_Active__c, User_member__c, UserRoleAPIName__c, Work_team__c
                               FROM Team_member__c
                              WHERE User_member__c = :foreignMember.User_member__c
                                AND Is_Active__c = true];

        if(activeAssignments.size()>0){
            for(Team_member__c tm : activeAssignments){
                tm.Is_Active__c = false;
                existingMembers.add(tm);
            }
        }
        List<Team_member__c> existingMember = [SELECT Id, User_member__c, UserRoleAPIName__c, Work_team__c
                                                 FROM Team_member__c
                                                WHERE User_member__c = :foreignMember.User_member__c
                                                  AND Work_team__c = :selectedId LIMIT 1];
        if(existingMember.size()>0){
            existingMember[0].Is_Active__c = true;
            existingMembers.add(existingMember[0]);
        }else{
            if(foreignMember.UserRoleAPIName__c != null){
                existingMembers.add(new Team_member__c(Is_Active__c = true,
                                                       User_member__c = foreignMember.User_member__c,
                                                       UserRoleAPIName__c = foreignMember.UserRoleAPIName__c,
                                                       Work_team__c = selectedId));
            }else{
                if(foreignMember.User_member__c != null 
                && foreignMember.Work_team__c != null){
                    displayPopup = true;
                    getRoleAPINames();
                    return;
                }
            }
        }
        if(existingMembers.size()>0){
            Team_member__c currentMember = existingMembers[0];
            if(currentMember.UserRoleAPIName__c == Null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.WrongUserConfiguration));
            } else {
                try {
                    upsert existingMembers;
                } catch (exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.ExistingUserInWorkTeam));
                    return;
                }
            }
        }
        view();
    }

    public void getRoleAPINames(){
        List<Work_Team_Permission__c> permissionList;
        permissionList = [SELECT Id, Role_API_Name__c
                            FROM Work_Team_Permission__c
                           WHERE Work_team__c = :selectedId
                             AND RecordType.DeveloperName = 'Roles_active_by_work_team'];
        for(Work_Team_Permission__c wtp : permissionList){
            permissionOptions.add(new SelectOption(wtp.Role_API_Name__c,wtp.Role_API_Name__c));
        }
    }

    public void saveMember(){
        foreignMember.Is_Active__c = true;
        membersToSave = new List<Team_member__c>();
        membersToSave.add(foreignMember);
        insert membersToSave;
        foreignMember = new Team_member__c();
        closePopup();
        view();
    }

    public void closePopup(){
        displayPopup = false;
    }

    public void SearchByUserFile(){
        List<User> userList = new List<User>();
        userList = [SELECT Id FROM User WHERE FederationIdentifier = :userFile];
        if(userList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.NotExistingUserByFile));
            return;
        }
        foreignMember.User_member__c = userList.get(0).Id;
    }

    public class workTeamWrapper{   
        public String id {get;set;}
        public String text {get;set;}
        public String parent {get;set;}
        public boolean children {get;set;}
        public Map<String, boolean> state {get;set;}
    }

    public class memberWrapper{
        public Boolean selected {get;set;}
        public Team_member__c team_member {get;set;}
        public memberWrapper(Team_member__c tm){
            selected = false;
            team_member = tm;
        }
    }

}