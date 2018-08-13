/**
* @author       Norwill Gutiérrez href=<ngutierrez@aconcaguabs.com>
* Project:      Telecom Security
* Description:  WorkTeamPermissionTrigger Helper
*
* Changes (Version)
* -------------------------------------
*      No.    Date          Author                 Description
*      -----  ----------    --------------------   ---------------
*      1.0    2018-03-09    Norwill Gutiérrez      Class creation.
*      2.0    2018-04-27    Norwill Gutiérrez      To process queue.
*************************************************************************************************************/
public with sharing class WorkTeamPermissionHelper {

    @future
    public static void processGroupQueue(String[] wtpIDs){
        try {
            Set<String> wtQueueNames = new Set<String>();
            Set<String> wtpQueueNames = new Set<String>();
            Map<String, Id> grpPublicMap = new Map<String, Id>();
            Map<String, Id> grpQueueMap = new Map<String, Id>();
            List<GroupMember> grpMemberToInsert = new List<GroupMember>();
            List<GroupMember> grpMemberToDelete = new List<GroupMember>();
            
            system.debug('wtpIDs: '+ wtpIDs);

            List<Work_Team_Permission__c> wtpLst = [SELECT Id, Work_Team__c, Work_Team__r.PublicGroupAPIName__c, 
                                                    Queue_API_Name__c, Is_Active__c
                                                    FROM Work_Team_Permission__c WHERE Id IN :wtpIDs];
            
            system.debug('Work_Team_Permission__c: '+ wtpLst);

            for(Work_Team_Permission__c wtP :wtpLst ){
                wtpQueueNames.add(wtP.Queue_API_Name__c);
                wtQueueNames.add(wtP.Work_Team__r.PublicGroupAPIName__c);
            }

            List<Group> grpPublic = [SELECT Id,Name FROM Group 
                                    WHERE Type = 'Regular' AND Name IN :wtQueueNames];
            for(Group grpP : grpPublic){
                grpPublicMap.put(grpP.Name, grpP.Id);
            }

            List<Group> grpList = [SELECT Id,Name FROM Group 
                                WHERE Type = 'Queue' AND Name IN :wtpQueueNames];        
            for(Group grpQ : grpList){
                grpQueueMap.put(grpQ.Name, grpQ.Id);
            }

            for(Work_Team_Permission__c wtP :wtpLst ){
                if(wtP.Is_Active__c){               
                    GroupMember grpMember = new GroupMember();
                    grpMember.GroupId = grpQueueMap.get(wtP.Queue_API_Name__c);
                    grpMember.UserOrGroupId = grpPublicMap.get(wtP.Work_Team__r.PublicGroupAPIName__c);
                    grpMemberToInsert.add(grpMember);
                }else{
                    grpMemberToDelete.add([SELECT GroupId,Id,UserOrGroupId FROM GroupMember 
                                        WHERE GroupId =: grpQueueMap.get(wtP.Queue_API_Name__c)
                                        AND UserOrGroupId =: grpPublicMap.get(wtP.Work_Team__r.PublicGroupAPIName__c)]);
                }
            }
            if(grpMemberToInsert.size() > 0){
                system.debug('grpMemberToInsert: '+ grpMemberToInsert);
                insert grpMemberToInsert;
            }
            if(grpMemberToDelete.size() > 0){
                system.debug('grpMemberToDelete: '+ grpMemberToDelete);
                delete grpMemberToDelete;
            } 
        }catch(Exception ex){
            system.debug('EX: ' + ex );
        }              
    }

    @future
    public static void grantPermissionToUser(String[] permissionSet, String[]  wtpIds) {
        try {
            List<Team_Member__c> tm = [SELECT Id, User_Member__c FROM Team_Member__c WHERE Is_Active__c = true AND Work_Team__c IN :wtpIds AND User_Member__c != NULL];
            List<PermissionSet> permSet = [SELECT Id FROM PermissionSet WHERE Name IN :permissionSet];
            List<PermissionSetAssignment> psa = new List<PermissionSetAssignment>();
            for (Team_Member__c tmember : tm) {
                for (PermissionSet idPerm : permSet) {
                    PermissionSetAssignment newPermissionSetA = new PermissionSetAssignment(PermissionSetId = idPerm.Id, AssigneeId = tmember.User_Member__c);
                    psa.add(newPermissionSetA);
                }
            }
            system.debug('grantPermissionToUser: ' + tm + ' - ' + permSet + ' - ' + psa);
            insert psa;
        }catch(Exception ex){
            system.debug('EX: ' + ex );
        }
    }

    @future
    public static void deleteUserPermission(String[] permissionSet, String[] wtpIds) {
        try {
            system.debug('deleteUserPermission: ' + permissionSet.size() + ' wtpIds: ' + wtpIds.size());
            Set<Id> tmIds = new Set<Id>();
            List<Team_Member__c> lstTM = [SELECT Id, User_Member__c FROM Team_Member__c WHERE Is_Active__c = true AND Work_Team__c IN :wtpIds AND User_Member__c != null];
            system.debug('lstTM: ' + lstTM);
            for(Team_Member__c tm : lstTM){
                tmIds.add(tm.User_Member__c);
            }

            Set<Id> permSet = (new Map<Id, SObject>([SELECT Id FROM PermissionSet WHERE Name IN :permissionSet])).keySet();
            List<PermissionSetAssignment> psa = new List<PermissionSetAssignment>();
            system.debug('tmIds: ' + tmIds);
            system.debug('permSet: ' + permSet);
            List<PermissionSetAssignment> psaResult = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId IN :permSet AND AssigneeId IN :tmIds]; 
            system.debug('psaResult: ' + psaResult);
            for (PermissionSetAssignment psaItem : psaResult) {
                psa.add(psaItem);
            }
            system.debug('deleteUserPermission: ' + psa.size() + ' - ' + tmIds.size() + ' - ' + permSet.size()); 
            delete psa;
        }catch(Exception ex){
            system.debug('EX: ' + ex );
        }
    }
}