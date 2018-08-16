@isTest
public class ta_security_wmassignment_test {
    static testMethod void myUnitTest(){
            
            List<workteam__c> workteams = new List<workteam__c>();
        workteam__c workTeam1 = new workteam__c(Name='Test1' ,team_Name__c='Test1',is_Active__c = true, Manager__c = UserInfo.getUserId());
        workteam__c workTeam2 = new workteam__c(Name='Test2' ,team_Name__c='Test2',is_Active__c = true, Manager__c = UserInfo.getUserId());
            workteams.add(workTeam1);
            workteams.add(workTeam2);
            insert workteams;

            team_member__c member = new team_member__c(user_member__c = UserInfo.getUserId(), UserRoleAPIName__c='Test', is_Active__c = true, work_team__c = workTeam1.Id);
            insert member;            

        Test.StartTest();
        PageReference pageRef1 = Page.ta_security_workmemberassignment;
        Ta_security_wmassignment_controller cont1 = new ta_security_wmassignment_Controller();
        Ta_security_wmassignment_controller.feedTree();
            cont1.selectedId = workTeam1.Id;
            cont1.view();
            cont1.saveId = workTeam2.Id;
            cont1.save();
            cont1.foreignMember.user_member__c = UserInfo.getUserId();
            cont1.selectedId = workTeam1.Id;
            cont1.viewTeam();
            cont1.foreignMember.UserRoleAPIName__c='Test';
            cont1.assign();
            cont1.getRoleAPINames();
            Test.StopTest();
   }
    
    static testMethod void myUnitTest2(){
            
        List<workteam__c> workteams = new List<workteam__c>();
        workteam__c workTeam1 = new workteam__c(Name='Test1' ,team_Name__c='Test1',is_Active__c = true, Manager__c = UserInfo.getUserId());
        workteams.add(workTeam1);
        insert workteams;  

        Test.StartTest();
        PageReference pageRef1 = Page.ta_security_workmemberassignment;
        Ta_security_wmassignment_controller cont1 = new ta_security_wmassignment_Controller();
        cont1.foreignMember = new team_member__c(user_member__c = UserInfo.getUserId(), UserRoleAPIName__c='Test2', is_Active__c = true, work_team__c = workTeam1.Id);
        cont1.saveMember();
        Test.StopTest();
   }
}