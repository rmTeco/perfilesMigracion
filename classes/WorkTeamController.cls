public with sharing class WorkTeamController {
    @AuraEnabled
    public static Map<String,Object> getWorkTeamsByKeyName(String keyName) {
        
        Map<String,Object> result = new Map<String,Object>();
        
        try {
            List<String> keys = buildKeys(keyName);
            List<WorkTeam__c> resultTMP = [select Name, WorkTeam__c.Manager__r.Name, WorkTeam__c.Parent_Team__r.Name, AmountOfActiveChildTeams__c, Work_Team_Number__c, Is_Active__c from WorkTeam__c where Name like: keys];
            resultTMP = orderListByKeyName(resultTMP, keyName);
            result.put('workteams',resultTMP);
            Map<String,Object> labels = new Map<String,Object>();
            labels.put('LabelWorkTeamName',getFieldLabelFromObject('WorkTeam__c','Name'));
            labels.put('LabelWorkTeamManager',getFieldLabelFromObject('WorkTeam__c','Manager__c'));
            labels.put('LabelWorkTeamParent',getFieldLabelFromObject('WorkTeam__c','Parent_Team__c'));
            labels.put('LabelWorkTeamAmountOfActiveChildTeams',getFieldLabelFromObject('WorkTeam__c','AmountOfActiveChildTeams__c'));
            labels.put('LabelWorkTeamCodigo',getFieldLabelFromObject('WorkTeam__c','Work_Team_Number__c'));
            labels.put('LabelWorkTeamIsActive',getFieldLabelFromObject('WorkTeam__c','Is_Active__c'));
            result.put('labels',labels);
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
        return result;
    }

    @AuraEnabled
    public static Map<String,Object> getWorkTeamById(String id) {
        Map<String,Object> result = new Map<String,Object>();
        
        try {
            WorkTeam__c WorkTeam = [select Name, WorkTeam__c.Manager__r.Name, WorkTeam__c.Manager__r.Id, WorkTeam__c.Manager__r.Profile.UserLicense.Name, WorkTeam__c.Parent_Team__r.Name, WorkTeam__c.Work_Place__r.Name, WorkTeam__c.Parent_Team__r.Id, AmountOfActiveChildTeams__c, Work_Team_Number__c, Team_Queue__c, Is_Active__c from WorkTeam__c where Id =: id];
            System.debug('este es el workteam: ' + WorkTeam);
            result = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(WorkTeam));
            result.put('Parent_Team__r',WorkTeam.Parent_Team__r);
            result.put('Manager__r',WorkTeam.Manager__r);
            result.put('Work_Place__r',WorkTeam.Work_Place__r);            
            result.put('LabelWorkTeamName',getFieldLabelFromObject('WorkTeam__c','Name'));
            result.put('LabelWorkTeamManager',getFieldLabelFromObject('WorkTeam__c','Manager__c'));
            result.put('LabelWorkTeamParent',getFieldLabelFromObject('WorkTeam__c','Parent_Team__c'));
            result.put('LabelWorkTeamAmountOfActiveChildTeams',getFieldLabelFromObject('WorkTeam__c','AmountOfActiveChildTeams__c'));
            result.put('LabelWorkTeamCodigo',getFieldLabelFromObject('WorkTeam__c','Work_Team_Number__c'));
            result.put('LabelWorkTeamIsActive',getFieldLabelFromObject('WorkTeam__c','Is_Active__c'));
            
            List<Team_Member__c> TeamMembers = [select Name, User_member__r.Name, Is_Active__c, MemberUsername__c, User_member__r.Profile.Name, MemberUserrole__c, Legajo__c from Team_Member__c where Work_Team__c =: id AND Is_Active__c = true AND User_member__r.IsActive = true];
            result.put('TeamMembers',TeamMembers);
            result.put('LabelTeamMembersName',getFieldLabelFromObject('Team_Member__c','Name'));
            result.put('LabelTeamMembersUserName',getFieldLabelFromObject('User','Name'));
            result.put('LabelTeamMembersIsActive',getFieldLabelFromObject('Team_Member__c','Is_Active__c'));
            
            List<Work_Team_Permission__c> WorkTeamRoles = getRolesOrQuotesByWorkTeamId(Id, 'Roles active by work team');
            result.put('WorkTeamRoles',WorkTeamRoles);
            result.put('WorkTeamRolesName',getFieldLabelFromObject('UserRole','Name'));
            result.put('WorkTeamRolesIsActive',getFieldLabelFromObject('Work_Team_Permission__c','Is_Active__c'));
            
            List<Work_Team_Permission__c> WorkTeamQueues = getRolesOrQuotesByWorkTeamId(Id, 'Queues by work team');
            result.put('WorkTeamQueues',WorkTeamQueues);
            result.put('WorkTeamQueuesName',getFieldLabelFromObject('UserRole','Name'));
            result.put('WorkTeamQueuesIsActive',getFieldLabelFromObject('Work_Team_Permission__c','Is_Active__c'));            
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
        
        return result;
    }
    
    private static List<Work_Team_Permission__c> getRolesOrQuotesByWorkTeamId(String workTeamId, String recordTypeName){
        List<RecordType> wtpRecordType = [SELECT Id,Name FROM RecordType WHERE 
                                        sObjectType = 'Work_Team_Permission__c' AND Name =: recordTypeName
                                        LIMIT 1];
        List<Work_Team_Permission__c> wtpResult;

        if(recordTypeName == 'Roles active by work team'){
            wtpResult = [SELECT Id,Is_Active__c,Name,RecordTypeId,Role_API_Name__c,Work_Team__c 
                        FROM Work_Team_Permission__c 
                        WHERE RecordTypeId = :wtpRecordType AND Work_Team__c = :workTeamId AND Is_Active__c = true];
        }else if(recordTypeName == 'Queues by work team'){
            wtpResult = [SELECT Id,Is_Active__c,Name,RecordTypeId,Queue_API_Name__c,Work_Team__c 
                        FROM Work_Team_Permission__c 
                        WHERE RecordTypeId = :wtpRecordType AND Work_Team__c = :workTeamId AND Is_Active__c = true];            
        }

        return wtpResult;
    }

    @AuraEnabled
    public static Map<String, Object> inactivateWorkTeamPermissionRoleById(String id) {
    	Map<String, Object> result = new Map<String,Object>();
    	try {
    		Work_Team_Permission__c wtPermission = [SELECT Role_API_Name__c, Is_Active__c, Work_Team__c FROM Work_Team_Permission__c WHERE Id =: id];
    		System.debug('wtPermission: ' + wtPermission);
    		List<Team_Member__c> teamMembers = [SELECT Name, User_member__r.Name, Is_Active__c, MemberUsername__c, User_member__r.Profile.Name, MemberUserrole__c, Legajo__c, User_member__r.UserRole.Name FROM Team_Member__c WHERE User_member__r.UserRole.Name =: wtPermission.Role_API_Name__c AND Is_Active__c = true AND Work_Team__c = :wtPermission.Work_Team__c];
    		if (teamMembers.isEmpty()) {
    			System.debug('teamMembers: ' + teamMembers);
    			wtPermission.Is_Active__c = false;
    			update wtPermission;
    			result = getWorkTeamById(wtPermission.Work_Team__c);
    		} else {
    			System.debug('teamMembers: ' + teamMembers);
    			result.put('WorkTeamMembersWithRoleToInactivate',teamMembers);
	            result.put('LabelTeamMembersUserName',getFieldLabelFromObject('User','Name'));
	            result.put('LabelTeamMembersRole',getFieldLabelFromObject('UserRole','Name'));
	            result.put('LabelTeamMembersProfile',getFieldLabelFromObject('Profile','Name'));
	            result.put('LabelTeamMembersLegajo',getFieldLabelFromObject('Team_Member__c','Legajo__c'));
    		}
    	} catch (Exception e) {
    		System.debug('Error: ' + e);
    	}
    	return result;
    }

    @AuraEnabled
    public static Map<String, Object> inactivateWorkTeamPermissionQueueById(String id) {
    	Map<String, Object> result = new Map<String,Object>();
    	try {
    		Work_Team_Permission__c wtPermission = [SELECT Role_API_Name__c, Is_Active__c, Work_Team__c FROM Work_Team_Permission__c WHERE Id =: id];
    		System.debug('wtPermission: ' + wtPermission);
            wtPermission.Is_Active__c = false;
            update wtPermission;
            result = getWorkTeamById(wtPermission.Work_Team__c);
    	} catch (Exception e) {
    		System.debug('Error: ' + e);
    	}
    	return result;
    }
    
    @AuraEnabled
    public static List<User> getUsersByLicenceAndKeyName(String licenseName, String keyName) {
        List<User> users = new List<User>();
        try {
            users = [SELECT Name, User.Profile.Name, User.UserRole.Name, FederationIdentifier FROM User WHERE Name like: keyName+'%' AND User.Profile.UserLicense.Name =: licenseName AND IsActive = true ORDER BY Name];
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
        return users;
    }
    
    @AuraEnabled
    public static List<WorkTeam__c> getWorkTeamsByKeyNameOrderByName(String keyName) {
        List<WorkTeam__c> workTeams = new List<WorkTeam__c>();
        try {
            workTeams = [SELECT Name FROM WorkTeam__c WHERE Name like: keyName+'%' ORDER BY Name];
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
        return workTeams;
    }
    
    @AuraEnabled
    public static WorkTeam__c createWorkTeam(WorkTeam__c workTeam, String manager, String parent, String location) {
        
        try {
            if (String.isNotBlank(manager)) workTeam.Manager__c = manager;
            if (String.isNotBlank(parent)) workTeam.Parent_Team__c = parent;
            if (String.isNotBlank(location)) workTeam.Work_Place__c = location;
            if (String.isBlank(workTeam.Id)) workTeam.Is_Active__c = true;
            upsert workTeam;
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
        return workTeam;
    }
    
    @AuraEnabled
    public static String getWorkTeamNameByID(String IdName) {
        List<WorkTeam__c> allWorkTeams = new List<WorkTeam__c>();
        String workTeamB;
        
        try {
            allWorkTeams = [SELECT Id,Name FROM WorkTeam__c where Id =: IdName LIMIt 1];
        } catch (Exception e) {
            System.debug('Error All WorkTeam: ' + e);
        }
        for(WorkTeam__c dd : allWorkTeams ){
            workTeamB = dd.Name; 
        }
        return workTeamB;
    }
    
    // Date: Apr-12-2018
    // Modified by: Miguel A. Munoz B.
    // Description: Update "is_Active__c" field in Team_Memeber__c validating whether this team_memeber is active/deactive in other objects
    @AuraEnabled
    public static Map<String,Object> putWorkTeamMemberActive(String IdMember) {
        Team_Member__c teamMember = new Team_Member__c();
        List<Team_Member__c> teamMembers = new List<Team_Member__c>();
        Map<String,Object> result = new Map<String,Object>();
        
        try {
            teamMember = [SELECT Is_Active__c, Work_Team__c, User_member__c FROM Team_Member__c where Id =: IdMember];
            
            teamMembers = [SELECT Is_Active__c, Work_Team__c, User_member__c FROM Team_Member__c where User_member__c =: teamMember.User_member__c and Is_Active__c = true and Work_Team__c !=: teamMember.Work_Team__c ];
            
            if (teamMembers.isEmpty()) {
                System.debug('es vacio');
                teamMember.Is_Active__c = !teamMember.Is_Active__c;
                update teamMember;
                result = getWorkTeamById(teamMember.Work_Team__c);
            } else {
                System.debug('no es vacio');
                result.put('messageAlert','No se puede desactivar TeamMember');
            }
        } catch (Exception e) {
            System.debug('Error: ' + e);
            result.put('messageAlert','No se puede desactivar TeamMember');
        }
        
        return result;
    }
    
    @AuraEnabled
    public static Boolean setInactiveWorkTeam(String id) {
        WorkTeam__c WorkTeam = new WorkTeam__c();
        Boolean result = false;    	
        try {
            List<Team_Member__c> TeamMembers = [SELECT Id FROM Team_Member__c WHERE Work_Team__c =: id AND Is_Active__c = true];
            if (TeamMembers.isEmpty()) {
                WorkTeam = [SELECT Is_Active__c FROM WorkTeam__c where Id =: id];
                WorkTeam.Is_Active__c = false;           
                update WorkTeam;
                result = true;	
            } else {
                result = false;
            }
            
            
        } catch (Exception e) {
            System.debug('Member: ' + e);
            result = false;
        }
        return result;
    }
    
    private static List<String> buildKeys(String keyName) {
        List<String> keys = new List<String>();
        keys = keyName.split(' ');
        
        for (Integer i = 0; i < keys.size(); i++) {
            keys[i] = '%' + keys[i] + '%'; 
        }
        
        return keys;
    }
    
    private static List<WorkTeam__c> orderListByKeyName(List<WorkTeam__c> WorkTeams, String keyName) {
        List<WorkTeam__c> result = new List<WorkTeam__c>();
        List<WorkTeam__c> resultTMP = new List<WorkTeam__c>();
        for (WorkTeam__c wt1: WorkTeams) {
            if (wt1.Name.length() >= keyName.length() && wt1.Name.substring(0, keyName.length()).equals(keyName)) {
                result.add(wt1);
            }else{
                resultTMP.add(wt1);
            }
        }
        result.addAll(resultTMP);
        return result;
    }
    
    private static String getFieldLabelFromObject(String objectType, String fieldName) {
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectType);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        return fieldMap.get(fieldName).getDescribe().getLabel();
    }
    
    @AuraEnabled
    public static List<String> getAllRolesAndSubordinateRoles(String WorkTeamId){
        List<String> allNameForRoles = new List<String>();
        List<String> allIdForRoles = new List<String>();
        System.debug('WorkTeamId- -' + WorkTeamId);
        
        List<RecordType> wtpRecordType = [SELECT Id,Name FROM RecordType WHERE 
                                        sObjectType = 'Work_Team_Permission__c' AND Name = 'Roles active by work team'
                                        LIMIT 1];
        
        List<Work_Team_Permission__c> nameForRoles = [Select Id,Role_API_Name__c,Work_Team__c From Work_Team_Permission__c where Work_Team__c = :WorkTeamId AND RecordTypeId = :wtpRecordType AND Is_Active__c = true];
        
        for(Work_Team_Permission__c rolesWorkTeam : nameForRoles){
            allIdForRoles.add(rolesWorkTeam.Role_API_Name__c);
        }
        
        /* UserRole[] acctOwners = [SELECT Id, Name FROM UserRole WHERE Id IN :allIdForRoles]; 
for(UserRole nameRoles : acctOwners){
allNameForRoles.add(NameRoles.Name);
}
set<Id> children  = getSubordinateRoles(userRoleId);
children.add(userRoleId);*/
        
        System.debug('Name----' + allIdForRoles);
        return allIdForRoles;
        
    }

    @AuraEnabled
    public static List<String> getAllUserRoles(){
        List<String> allNameForRoles = new List<String>();
        
        UserRole[] acctOwners = [SELECT Id, Name FROM UserRole]; 
		for(UserRole nameRoles : acctOwners){
			allNameForRoles.add(nameRoles.Name);
		}
        
        return allNameForRoles;
        
    }

    @AuraEnabled
    public static List<String> getAllQueue(){
        List<String> allNameForQueue = new List<String>();
        
        Group[] acctGroup = [SELECT Id, Name FROM Group WHERE Type = 'Queue']; 
		for(Group nameGroup : acctGroup){
			allNameForQueue.add(nameGroup.Name);
		}
        
        return allNameForQueue;
        
    }

    @AuraEnabled
    public static Boolean saveWorkTeamMembers(String UserManagerName, String workTeamName, String roleAPIname){
        
        Id idWorkTeam;
        String roleIdAPIName;
        Id userIdName;        
        try{
            System.debug('Name workTeam_-'+ workTeamName );
            List<WorkTeam__c> workTeamn = [select Id, Name from WorkTeam__c where Name = :workTeamName];
            
            for(WorkTeam__c allWorkTeam : workTeamn){
                idWorkTeam = allWorkTeam.Id;
            }
            System.debug('WorkTeam__c --- ' +  workTeamn );
            
            List<UserRole> idRoleApiName = [SELECT Name FROM UserRole where Name Like :('%'+ roleAPIname +'%') LIMIT 1];
            
            for(UserRole idApiName : idRoleApiName){
                roleIdAPIName = idApiName.Name;
            }
            System.debug('UserRole --- ' +  idRoleApiName ); 
            
            List<User> idUserName = [SELECT Id,Name FROM User where Name Like :('%'+ UserManagerName +'%') LIMIT 1];    
            for(User userName : idUserName){
                userIdName = userName.Id;
            }
            System.debug('User --- ' +  idUserName );
            
            List<Team_Member__c> allMemberTeam =[select Id,Name,UserRoleAPIName__c from Team_Member__c where User_member__c  = :userIdName];
            
            if(allMemberTeam.size() > 0 ){
                List<Team_Member__c> memberG = new List<Team_Member__c>();
                for(Team_Member__c memberTeamD : allMemberTeam){
                    if(memberTeamD.UserRoleAPIName__c != null){
                       memberTeamD.Is_Active__c = False; 
                       memberG.add(memberTeamD);
                    }                    
                }
                System.debug('List new --'+ memberG);
                update memberG;
            }
            Team_Member__c memberTeam = new Team_Member__c();
            memberTeam.Is_Active__c = True;
            memberTeam.User_member__c = userIdName;
            memberTeam.UserRoleAPIName__c = roleIdAPIName;
            memberTeam.Work_Team__c = idWorkTeam;
            
            insert memberTeam;
            System.debug('New WorKteamMember---' + memberTeam);   
            return true;
        } catch (Exception e) {
            System.debug('Error: ' + e);
            return false;
        }
    }
    
    @AuraEnabled
    public static String saveWorkTeamRole(String workTeamId, String roleAPIname){
        
        Id idWorkTeam;
        Id roleIdAPIName;
		String strResult;       
        try{
			strResult = '';
			List<RecordType> wtRoleRecordType = [SELECT Id,Name FROM RecordType WHERE 
												sObjectType = 'Work_Team_Permission__c' AND Name = 'Roles active by work team'
												LIMIT 1];

			List<Work_Team_Permission__c> workTeamRole = [SELECT Role_API_Name__c  FROM Work_Team_Permission__c 
														  WHERE RecordTypeId = :wtRoleRecordType[0].Id
										   				  AND Role_API_Name__c = :roleAPIname
														  AND Work_Team__c = :workTeamId
														  AND Is_Active__c = true];

			if(workTeamRole.size() >0){
				strResult = 'El rol ya se encuentra asignado al equipo de trabajo';
			}else{
				List<Work_Team_Permission__c> wtRNoActive = [SELECT Role_API_Name__c  FROM Work_Team_Permission__c 
															WHERE RecordTypeId = :wtRoleRecordType[0].Id
															AND Role_API_Name__c = :roleAPIname
															AND Work_Team__c = :workTeamId
															AND Is_Active__c = false];
				if(wtRNoActive.size() >0){					
					wtRNoActive[0].Is_Active__c = true;
					update wtRNoActive;
					strResult = '';
				}else{
					Work_Team_Permission__c newWtP = new Work_Team_Permission__c();
					newWtP.RecordTypeId = wtRoleRecordType[0].Id;
					newWtP.Role_API_Name__c = roleAPIname;
					newWtP.Is_Active__c = true;
					newWtP.Work_Team__c = workTeamId;
					
					insert newWtP;
					strResult = '';
				}				
			}
            
            return strResult;
        } catch (Exception e) {
			strResult = 'Ha ocurrido un error inesperado';
            System.debug('Error: ' + e);
            return strResult;
        }
    }
    
    @AuraEnabled
    public static String saveWorkTeamQueue(String workTeamId, String queueName){
        
        Id idWorkTeam;
        Id roleIdAPIName;
		String strResult;       
        try{
			strResult = '';
			List<RecordType> wtRoleRecordType = [SELECT Id,Name FROM RecordType WHERE 
												sObjectType = 'Work_Team_Permission__c' AND Name = 'Queues by work team'
												LIMIT 1];

			List<Work_Team_Permission__c> workTeamRole = [SELECT Queue_API_Name__c  FROM Work_Team_Permission__c 
														  WHERE RecordTypeId = :wtRoleRecordType[0].Id
										   				  AND Queue_API_Name__c = :queueName
														  AND Work_Team__c = :workTeamId
														  AND Is_Active__c = true];

			if(workTeamRole.size() >0){
				strResult = 'El queue ya se encuentra asignado al equipo de trabajo';
			}else{
				List<Work_Team_Permission__c> wtRNoActive = [SELECT Queue_API_Name__c  FROM Work_Team_Permission__c 
															WHERE RecordTypeId = :wtRoleRecordType[0].Id
															AND Queue_API_Name__c = :queueName
															AND Work_Team__c = :workTeamId
															AND Is_Active__c = false];
				if(wtRNoActive.size() >0){					
					wtRNoActive[0].Is_Active__c = true;
					update wtRNoActive;
					strResult = '';
				}else{
					Work_Team_Permission__c newWtP = new Work_Team_Permission__c();
					newWtP.RecordTypeId = wtRoleRecordType[0].Id;
					newWtP.Queue_API_Name__c = queueName;
					newWtP.Is_Active__c = true;
					newWtP.Work_Team__c = workTeamId;
					
					insert newWtP;
					strResult = '';
				}				
			}
            
            return strResult;
        } catch (Exception e) {
			strResult = 'Ha ocurrido un error inesperado';
            System.debug('Error: ' + e);
            return strResult;
        }
    }

    @AuraEnabled
    public static List<User> getUsersByLicenceAndKeyNameOrUserName(String licenseName, String keyName) {
        List<User> users = new List<User>();
        
        try {
            users = [SELECT Name,UserName, User.Profile.Name, User.UserRole.Name, FederationIdentifier FROM User WHERE Name like:('%'+ keyName +'%') AND User.Profile.UserLicense.Name =: licenseName AND IsActive = true ORDER BY Name];
            
            if( users.size() == 0){
                System.debug('Here into user ---' + keyName );
                
                users = [SELECT Name,UserName, User.Profile.Name, User.UserRole.Name, FederationIdentifier FROM User WHERE UserName like:('%'+ keyName +'%') AND User.Profile.UserLicense.Name =: licenseName AND IsActive = true ORDER BY Name];
            	
                if(users.size() == 0){
                    users = [SELECT Name,UserName, User.Profile.Name, User.UserRole.Name, FederationIdentifier FROM User WHERE FederationIdentifier like:('%'+ keyName +'%') AND User.Profile.UserLicense.Name =: licenseName AND IsActive = true ORDER BY Name];
                }
                
            }
            
            System.debug('User---' + users );
            
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
        return users;
    }
    
    @InvocableMethod (label='Inactivate Team Members By User Inactive')
    public static void inactivateTeamMembersByUserInactiveInvocable(List<User> usersToUpdate){
        List<User> usersInactive = new List<User>();
        for(User u: usersToUpdate) {
        	if (!u.IsActive) {
        		usersInactive.add(u);
        	}
        }
        if (!usersInactive.isEmpty()) {
        	Map<String, Object> input = new Map<String, Object>();
        	input.put('usersInactive', usersInactive);
        	System.enqueueJob(new InactivateTeamMebersWhenInactiveUsers('inactivateTeamMebers', input));
        }
    }

    @AuraEnabled
    public static List<vlocity_cmt__BusinessSite__c> getStoreLocationByWorkTeamName(String keyName) {
        List<vlocity_cmt__BusinessSite__c> teamSites = new List<vlocity_cmt__BusinessSite__c>();
        try {
            teamSites = [SELECT Name FROM vlocity_cmt__BusinessSite__c WHERE Name like: keyName+'%' ORDER BY Name];
        } catch (Exception e) {
            System.debug('Error: ' + e);
        }
        return teamSites;
    }    
}