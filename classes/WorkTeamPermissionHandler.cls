/**
* @author       Norwill Gutiérrez href=<ngutierrez@aconcaguabs.com>
* Project:      Telecom Security
* Description:  WorkTeamPermissionTrigger Handler
*
* Changes (Version)
* -------------------------------------
*      No.    Date          Author                 Description
*      -----  ----------    --------------------   ---------------
*      1.0    2018-03-09    Norwill Gutiérrez      Class creation.
*      2.0    2018-04-27    Norwill Gutiérrez      To process queue.
*************************************************************************************************************/
public with sharing class WorkTeamPermissionHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    Id RecordTypePermissions;
    Id RecordTypeRoles;
    Id RecordTypeQueue;
    
    public WorkTeamPermissionHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;  
        RecordTypePermissions = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Permissions by work team').getRecordTypeId();
        RecordTypeRoles = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Roles active by work team').getRecordTypeId();     
        RecordTypeQueue = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Queues by work team').getRecordTypeId();
    }
    
    public void OnAfterInsert(Work_Team_Permission__c[] newWorkTeamsPermission){
        String[] permissionsSet = new String[]{};
        String[] idsSet = new String[]{};
        Map<Id, Work_Team_Permission__c> wtpMap = new Map<Id, Work_Team_Permission__c>();
        String[] wtpIDs = new String[]{};
        for(Work_Team_Permission__c wtP : newWorkTeamsPermission){
            if (wtP.RecordTypeId == RecordTypeQueue){
                wtpIDs.add(wtP.Id);
            } if (wtP.RecordTypeId == RecordTypePermissions) {
                idsSet.add(wtP.Work_Team__c);
                permissionsSet.add(wtP.Permission_Set_API_Name__c);
            }
        }
        if(wtpIDs.size() > 0)
            WorkTeamPermissionHelper.processGroupQueue(wtpIDs);
        if(permissionsSet.size() > 0 && idsSet.size() > 0)
            WorkTeamPermissionHelper.grantPermissionToUser(permissionsSet, idsSet);
    }
    
    public void OnAfterUpdate(Map<ID, Work_Team_Permission__c> oldWorkTeamPermissionMap, Map<ID, Work_Team_Permission__c> newWorkTeamPermissionMap){       
        String[] permissionsSet = new String[]{};
        String[] idsSet = new String[]{};
        String[] deletePermissionsSet = new String[]{};
        String[] deleteIdsSet = new String[]{};

        Map<Id, Work_Team_Permission__c> wtpMap = new Map<Id, Work_Team_Permission__c>();
        String[] wtpIDs = new String[]{};
        for(Work_Team_Permission__c wtP : newWorkTeamPermissionMap.values()){
            if (wtP.RecordTypeId == RecordTypeQueue){
                wtpIDs.add(wtP.Id);
            } else if (wtP.RecordTypeId == RecordTypePermissions) {
                if (wTP.Is_Active__c) {
                    idsSet.add(wtP.Work_Team__c);
                    permissionsSet.add(wtP.Permission_Set_API_Name__c);
                } else {
                    deleteIdsSet.add(wtP.Work_Team__c);
                    deletePermissionsSet.add(wtP.Permission_Set_API_Name__c);
                }
            }
        }
        if(wtpIDs.size() > 0)
            WorkTeamPermissionHelper.processGroupQueue(wtpIDs);
        if(deletePermissionsSet.size() > 0 && deleteIdsSet.size() > 0)
            WorkTeamPermissionHelper.deleteUserPermission(deletePermissionsSet, deleteIdsSet);           
        if(permissionsSet.size() > 0 && idsSet.size() > 0)
            WorkTeamPermissionHelper.grantPermissionToUser(permissionsSet, idsSet);
        
    }
}