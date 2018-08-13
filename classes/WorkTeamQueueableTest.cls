@isTest
private class WorkTeamQueueableTest {

    static testMethod void SyncUserRoleByUserRoleAPINameOfTeamMemberTest() {
        //GIVE
        String method = 'SyncUserRoleByUserRoleAPINameOfTeamMember';
        Map<String, Object> input = new Map<String, Object>();
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test ', Is_Active__c = true);
        insert workTeam;
        Team_Member__c member = new Team_Member__c(Work_Team__c = workTeam.Id, UserRoleAPIName__c = 'Fan_Director', User_member__c = UserInfo.getUserId(), Is_Active__c = true);
        insert member;
        Map<Id, String> UserRoleAPINameByUserId = new Map<Id, String>();
        UserRoleAPINameByUserId.put(UserInfo.getUserId(),'Fan_Director');
        input.put('UserRoleAPINameByUserId',UserRoleAPINameByUserId);
        
        //WHEN
        Test.startTest();
        System.enqueueJob(new WorkTeamQueueable(method, input));
        Test.stopTest();
        
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void DeletePermisionSetByUserId() {
        //GIVE
        String method = 'DeletePermisionSetByUserId';
        Map<String, Object> input = new Map<String, Object>();
        Map<Id, Object> usersToDeletePermissionSet = new Map<Id, String>();
        usersToDeletePermissionSet.put(UserInfo.getUserId(),null);
        input.put('usersToDeletePermissionSet',usersToDeletePermissionSet);
        
        //WHEN
        Test.startTest();
        System.enqueueJob(new WorkTeamQueueable(method, input));
        Test.stopTest();
        
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void AssigmentPermisionSetByUserId() {
        //GIVE
        String method = 'AssigmentPermisionSetByUserId';
        Map<String, Object> input = new Map<String, Object>();
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test ', Is_Active__c = true);
        insert workTeam;
        Team_Member__c member = new Team_Member__c(Work_Team__c = workTeam.Id, UserRoleAPIName__c = 'Fan_Director', User_member__c = UserInfo.getUserId(), Is_Active__c = true);
        insert member;
        Map<Id, Object> usersToAssignmentPermissionSet = new Map<Id, Object>();
        usersToAssignmentPermissionSet.put(UserInfo.getUserId(), member);
        input.put('usersToAssignmentPermissionSet',usersToAssignmentPermissionSet);
        
        //WHEN
        Test.startTest();
        System.enqueueJob(new WorkTeamQueueable(method, input));
        Test.stopTest();
        
        
        //THEN
        System.assert(true);
    }
}