@isTest
public class WorkTeamPermissionTriggersTest {

    @isTest
    public static void TestWorkTeamPermissionTrigger(){
        Id RecordTypePermissions = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Permissions by work team').getRecordTypeId();   
        Id RecordTypeQueue = Schema.SObjectType.Work_Team_Permission__c.getRecordTypeInfosByName().get('Queues by work team').getRecordTypeId();
        
        WorkTeam__c workTeamNew = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test');
        insert workTeamNew;

        Test.startTest();
            Work_Team_Permission__c workTeamP = new Work_Team_Permission__c(Work_Team__c = workTeamNew.Id, Role_API_Name__c = 'FAN_Director', Queue_API_Name__c = 'TestWTP', Is_Active__c = true, RecordTypeId = RecordTypePermissions);
            insert workTeamP;
            Work_Team_Permission__c workTeamQ = new Work_Team_Permission__c(Work_Team__c = workTeamNew.Id, Role_API_Name__c = 'FAN_Director', Queue_API_Name__c = 'TestWTP', Is_Active__c = true, RecordTypeId = RecordTypeQueue);
            insert workTeamQ;

            Team_Member__c member = new Team_Member__c(Work_Team__c = workTeamNew.Id, UserRoleAPIName__c = workTeamP.Role_API_Name__c, Is_Active__c = true, User_Member__c = UserInfo.getUserId());
            insert member;

            workTeamQ.Is_Active__c = false;
            update workTeamQ;
            workTeamQ.Is_Active__c = true;
            update workTeamQ;
            workTeamP.Is_Active__c = false;
            update workTeamP;
            workTeamP.Is_Active__c = true;
            update workTeamP;
            workTeamNew.Is_Active__c = true;
            update workTeamNew;
        Test.stopTest();

        System.assert(true);
    }
}