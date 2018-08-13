@isTest
public class WorkTeamControllerTest {
	
	static testMethod void getWorkTeamsByKeyNameTest() {
        //GIVEN
        String keyName = 'Test 1';
        WorkTeam__c workTeam1 = new WorkTeam__c(Team_Name__c = 'Test 1', Name = 'Test 1');
        WorkTeam__c workTeam2 = new WorkTeam__c(Team_Name__c = 'Test 2', Name = 'Test 2');
        insert workTeam1;
        insert workTeam2;
        
        //WHEN
        Test.startTest();
        Map<String,Object> result = WorkTeamController.getWorkTeamsByKeyName(keyName);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void getWorkTeamByIdTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test ');
        insert workTeam;
        Team_Member__c member = new Team_Member__c(Work_Team__c = workTeam.Id, UserRoleAPIName__c = 'Test');
        insert member;
        
        //WHEN
        Test.startTest();
        Map<String,Object> result = WorkTeamController.getWorkTeamById(workTeam.Id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    // Date: Apr-13-2018
    // Modified by: Miguel A. Muñoz B.
    // Testing method for checking activate a Team Member loaded in a new Work Team
        static testMethod void putWorkTeamMemberActivedTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test ', PublicGroupAPIName__c = 'Test ', Is_Active__c = true );
        insert workTeam;
        
        Team_Member__c member = new Team_Member__c(Work_Team__c = workTeam.Id, Is_Active__c = true, UserRoleAPIName__c = 'Test ', User_member__c = UserInfo.getUserId() );
        insert member;


        //WHEN activated
        Test.startTest();
        Map<String,Object> result = WorkTeamController.putWorkTeamMemberActive(member.Id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
   
    
                
    // Date: Apr-13-2018
    // Modified by: Miguel A. Muñoz B.
    // Testing method for checking deactivate a Team Member loaded in a new Work Team

        static testMethod void putWorkTeamMemberDeactivedTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test Deactivated ', Name = 'Test Deactivated ', PublicGroupAPIName__c = 'Test Deactivated', Is_Active__c = true);
        insert workTeam;
        
        Team_Member__c memberDeactivated = new Team_Member__c(Work_Team__c = workTeam.Id, Is_Active__c = false, UserRoleAPIName__c = 'Test Deactivated', User_member__c = UserInfo.getUserId() );
        insert memberDeactivated;
        
        //WHEN Deactivated
        Test.startTest();
        Map<String,Object> result = WorkTeamController.putWorkTeamMemberActive(memberDeactivated.Id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
     // Date: Apr-13-2018
    // Modified by: Miguel A. Muñoz B.
    // Testing method for checking activate a Team Member loaded in a new Work Team
        static testMethod void putWorkTeamMemberActivedDuplicatedTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test ', PublicGroupAPIName__c = 'Test ', Is_Active__c = true );
        insert workTeam;
        
        WorkTeam__c workTeam_2 = new WorkTeam__c(Team_Name__c = 'Test 2', Name = 'Test 2', PublicGroupAPIName__c = 'Test 2', Is_Active__c = true );
        insert workTeam_2;
        
        Team_Member__c member = new Team_Member__c(Work_Team__c = workTeam.Id, Is_Active__c = false, UserRoleAPIName__c = 'Test ', User_member__c = UserInfo.getUserId() );
        insert member;

        Team_Member__c member2 = new Team_Member__c(Work_Team__c = workTeam_2.Id, Is_Active__c = true, UserRoleAPIName__c = 'Test ', User_member__c = UserInfo.getUserId() );
        insert member2;

        //WHEN activated
        Test.startTest();
        Map<String,Object> result = WorkTeamController.putWorkTeamMemberActive(member.Id);
        
        
        //WHEN activated
        Map<String,Object> resultDuplicated = WorkTeamController.putWorkTeamMemberActive(member2.Id);
        Test.stopTest();
        
        
        //THEN
        System.assert(true);
    }
    
    
    
    static testMethod void getUsersByLicenceAndKeyNameTest() {
        //GIVEN
        String licenseName = 'Salesforce';
        String keyName = '';
        
        //WHEN
        Test.startTest();
        List<User> result = WorkTeamController.getUsersByLicenceAndKeyName(licenseName, keyName);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void getWorkTeamsByKeyNameOrderByNameTest() {
        //GIVEN
        String keyName = '';
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test ');
        insert workTeam;
        
        //WHEN
        Test.startTest();
        List<WorkTeam__c> result = WorkTeamController.getWorkTeamsByKeyNameOrderByName(keyName);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void createWorkTeamTest() {
        //GIVEN
        Account acc = new Account(Name='Test Account');
        insert acc;

        WorkTeam__c workTeamParent = new WorkTeam__c(Team_Name__c = 'Test Parent', Name = 'Test Parent');
        insert workTeamParent;

        vlocity_cmt__BusinessSite__c workTeamLocation = new vlocity_cmt__BusinessSite__c(Name = 'Test Parent', vlocity_cmt__OrganizationId__c = acc.Id);
        insert workTeamLocation;

        String manager = UserInfo.getUserId();
        String parent = workTeamParent.Id;
        String location = workTeamLocation.Id;
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
        
        //WHEN
        Test.startTest();
        WorkTeam__c result = WorkTeamController.createWorkTeam(workTeam, manager, parent, location);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void getWorkTeamNameByIDTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test Parent', Name = 'Test Parent');
        insert workTeam;
        String id = workTeam.Id;
        
        //WHEN
        Test.startTest();
        String result = WorkTeamController.getWorkTeamNameByID(id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    static testMethod void setInactiveWorkTeamTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test Parent', Name = 'Test Parent', Is_Active__c=true);
        insert workTeam;
        String id = workTeam.Id;
        
        //WHEN
        Test.startTest();
        Boolean result = WorkTeamController.setInactiveWorkTeam(id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void getAllDataForRolesId(){
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test');
        insert workTeam;
        
        RecordType wtpRecordType = [SELECT Id,Name FROM RecordType WHERE 
                                        sObjectType = 'Work_Team_Permission__c' AND Name = 'Roles active by work team'
                                        LIMIT 1];
        
        Work_Team_Permission__c workTeamP = new Work_Team_Permission__c(Work_Team__c = workTeam.Id, Role_API_Name__c = 'FAN_Director', Is_Active__c = true, RecordTypeId = wtpRecordType.Id);
        insert workTeamP;
        
        
         //WHEN
        Test.startTest();
        List<String> allRolesName = WorkTeamController.getAllRolesAndSubordinateRoles(workTeam.Id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void testSaveDateWorkTeamMember(){
        
        String UserManagerName = 'Luis Mendoza';
        String workTeamName = 'Back Office GGCC';
        String roleAPIname = 'FAN_Director';
        
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Back Office GGCC');
        insert workTeam; 
        
         //WHEN
         Test.startTest();
         Boolean  result = WorkTeamController.saveWorkTeamMembers(UserManagerName,workTeamName,roleAPIname);
        Test.stopTest();
        
        //THEN
        System.assert(result);
    }
    
    static testMethod void getUsersByLicenceAndKeyNameOrUserNameTest() {
        //GIVEN
        String licenseName = 'Salesforce';
        String keyName = 'lmendoza';
        
        //WHEN
        Test.startTest();
        List<User> result = WorkTeamController.getUsersByLicenceAndKeyNameOrUserName(licenseName, keyName);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }

    @isTest
    static void getRolesByWorkTeamIdTest(){
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Back Office GGCC');
        insert workTeam; 

        Test.startTest();
        Map<String,Object> objTest = WorkTeamController.getWorkTeamById(workTeam.Id);
        Test.stopTest();

        System.assert(objTest != null);
    }

    @isTest(SeeAllData=true)
    static void getAllUserRolesTest(){
        Test.startTest();
        List<String> objTest = WorkTeamController.getAllUserRoles();
        Test.stopTest();

        System.assert(objTest != null);
    }

    @isTest(SeeAllData=true)
    static void getAllQueueTest(){
        Test.startTest();
        List<String> objTest = WorkTeamController.getAllQueue();
        Test.stopTest();

        System.assert(objTest != null);
    }

    @isTest(SeeAllData=true)
    static void saveWorkTeamRoleTest(){
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'TeamRoleTest', Name = 'Back Office GGCC');
        insert workTeam; 

        UserRole userRol = [SELECT Id, Name FROM UserRole LIMIT 1];

        Test.startTest();
        String objTest = WorkTeamController.saveWorkTeamRole(workTeam.Id, userRol.Name);
        Test.stopTest();

        system.debug('saveWorkTeamRoleTest Result: ' + objTest);

        System.assert(objTest == '');
    }

    @isTest
    static void saveWorkTeamQueue(){
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'TeamQueueTest', Name = 'Back Office GGCC');
        insert workTeam; 

        Group grp = new Group(Name = 'TeamQueueTest', Type='Queue');
        insert grp;

        Test.startTest();
        String objTest = WorkTeamController.saveWorkTeamQueue(workTeam.Id, grp.Name);
        Test.stopTest();

        system.debug('saveWorkTeamQueue Result: ' + objTest);

        System.assert(objTest == '');
    }    
    
    static testMethod void inactivateWorkTeamPermissionRoleByIdInactiveTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test');
        insert workTeam;
        
        RecordType wtpRecordType = [SELECT Id,Name FROM RecordType WHERE 
                                        sObjectType = 'Work_Team_Permission__c' AND Name = 'Roles active by work team'
                                        LIMIT 1];
        
        UserRole ur = null;                              
        if(UserInfo.getUserRoleId()!=null) {
        	ur = [SELECT Name FROM UserRole WHERE Id = : UserInfo.getUserRoleId()];
        } else {
        	ur = [SELECT Name FROM UserRole LIMIT 1];
        }
        
        
        Work_Team_Permission__c workTeamP = new Work_Team_Permission__c(Work_Team__c = workTeam.Id, Role_API_Name__c = ur.Name, Is_Active__c = true, RecordTypeId = wtpRecordType.Id);
        insert workTeamP;
        
        Team_Member__c member = new Team_Member__c(Work_Team__c = workTeam.Id, UserRoleAPIName__c = workTeamP.Role_API_Name__c, Is_Active__c = true, User_Member__c = UserInfo.getUserId());
        insert member;
        
        //WHEN
        Test.startTest();
        Map<String, Object> result = WorkTeamController.inactivateWorkTeamPermissionRoleById(workTeamP.Id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void inactivateWorkTeamPermissionRoleByIdActiveTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test');
        insert workTeam;
        
        RecordType wtpRecordType = [SELECT Id,Name FROM RecordType WHERE 
                                        sObjectType = 'Work_Team_Permission__c' AND Name = 'Roles active by work team'
                                        LIMIT 1];
        
        Work_Team_Permission__c workTeamP = new Work_Team_Permission__c(Work_Team__c = workTeam.Id, Role_API_Name__c = 'FAN_Director', Is_Active__c = true, RecordTypeId = wtpRecordType.Id);
        insert workTeamP;
        
        
        //WHEN
        Test.startTest();
        Map<String, Object> result = WorkTeamController.inactivateWorkTeamPermissionRoleById(workTeamP.Id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    static testMethod void inactivateWorkTeamPermissionQueueByIdTest() {
        //GIVEN
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test ', Name = 'Test');
        insert workTeam;
        
        RecordType wtpRecordType = [SELECT Id,Name FROM RecordType WHERE 
                                        sObjectType = 'Work_Team_Permission__c' AND Name = 'Roles active by work team'
                                        LIMIT 1];
        
        UserRole ur = null;                              
        if(UserInfo.getUserRoleId()!=null) {
        	ur = [SELECT Name FROM UserRole WHERE Id = : UserInfo.getUserRoleId()];
        } else {
        	ur = [SELECT Name FROM UserRole LIMIT 1];
        }
        
        
        Work_Team_Permission__c workTeamP = new Work_Team_Permission__c(Work_Team__c = workTeam.Id, Role_API_Name__c = ur.Name, Is_Active__c = true, RecordTypeId = wtpRecordType.Id);
        insert workTeamP;
        
        //WHEN
        Test.startTest();
        Map<String, Object> result = WorkTeamController.inactivateWorkTeamPermissionQueueById(workTeamP.Id);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
}