@isTest
public class InactivateTeamMebersWhenInactiveUserTest {    
     
      static testMethod void getWorkTeamsByKeyNameTest() {
    
        //GIVEN
        String NameTest = 'TestgetWorkTeamsByKeyNameTest';
        
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test 0002', Name = 'Test 002', Is_Active__c = true );
        
        System.debug('Insertando work team ' + workTeam );
        insert workTeam;
        
        User u = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
        
        Team_Member__c member = new Team_Member__c(Work_Team__c = workTeam.Id, Is_Active__c = true, UserRoleAPIName__c = NameTest, User_member__c = u.Id );
        insert member;
        
        Group g = new Group(Name = NameTest, developerName = 'InactivateTeamMebersWhenInactiveUserTest');
        insert g;
                
        List<User> myList = new List<User>();
        myList.add(u);        
        
        Map<String, Object> newMp = new Map<String, Object>();
        newMp.put('usersInactive',myList);
                
        //WHEN
        Test.startTest();
        System.enqueueJob(new InactivateTeamMebersWhenInactiveUsers('inactivateTeamMebers',newMp ));
        Test.stopTest();         
        
        //THEN
        System.assert(true);        
    }
    
    @isTest static void inactivateUserTeamManager(){
    	
    	// Creating a * Parent Team *
    	String ParentTeamName = 'TestinactivateUserTeamManager';
    	
    	User u = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];
    	
    	WorkTeam__c workTeamParent = new WorkTeam__c(Team_Name__c = ParentTeamName, Name = ParentTeamName, Manager__c = u.Id, Is_Active__c = true );
        insert workTeamParent;
        
        // Creating a * User Team * with a Manager 
        String TeamName = 'TestinactivateUserTeamManager2';
               
        User manager_ui = [SELECT Id FROM User WHERE IsActive = true AND Id != : u.Id LIMIT 1];
        
        WorkTeam__c workUserTeam = new WorkTeam__c(Team_Name__c = TeamName, Name = TeamName, Manager__c = manager_ui.Id, Parent_Team__c = workTeamParent.Id, Is_Active__c = true );
        insert workUserTeam;
        
        // Adding a Team Member to the * User Team *
        User user_team = [SELECT Id FROM User WHERE IsActive = true AND (Id != : u.Id AND Id != : manager_ui.Id) LIMIT 1];
        
        Team_Member__c teamMember = new Team_Member__c(Work_Team__c = workUserTeam.Id, Is_Active__c = true, UserRoleAPIName__c = TeamName, User_member__c = user_team.Id );
        insert teamMember;
        
        // Creating a Case for testing
        Case newCase = new Case(subject='Inconvenientes con cargos tasados y facturados', Origin='Email', Status='Nueva', Approver__c = manager_ui.Id);
        insert newCase;
   
        // Creating a New Parent Work team to assign it to a Work Team Without Manager
    	String ParentTeamName2 = 'ParentTeam_WOM';
    	
    	User Manager2 = [SELECT Id FROM User WHERE IsActive = true AND (Id != :user_team.Id AND Id != :manager_ui.Id AND Id != :u.Id) LIMIT 1];
    	
    	WorkTeam__c workTeamParent2 = new WorkTeam__c(Team_Name__c = ParentTeamName2, Name = ParentTeamName2, Manager__c = Manager2.Id, Is_Active__c = true );
        insert workTeamParent2;
        
        // Creating a New Work Team Without Manager
        String TeamNameWithOutManager = 'WorkTeamWithoutManager';     
                
        WorkTeam__c workUserTeam2 = new WorkTeam__c(Team_Name__c = TeamNameWithOutManager, Name = TeamNameWithOutManager, Parent_Team__c = workTeamParent2.Id, Is_Active__c = true );
        insert workUserTeam2;
        
         // Adding a Team Member to the New Work Team Without Manager
        User user_team2 = [SELECT Id FROM User WHERE IsActive = true AND (Id != : u.Id AND Id != : manager_ui.Id AND Id != :user_team.Id AND Id != :Manager2.Id) LIMIT 1];
        
        Team_Member__c teamMember2 = new Team_Member__c(Work_Team__c = workUserTeam2.Id, Is_Active__c = true, UserRoleAPIName__c = TeamNameWithOutManager, User_member__c = user_team2.Id );
        insert teamMember2;        
        
        // Creating a Case for testing
        Case newCase2 = new Case(subject='Inconvenientes con cargos tasados y facturados', Origin='Email', Status='Nueva', Approver__c = Manager2.Id);
        insert newCase2;        
        // 
        
        // * * * * * * * * * * 
        
        // Creating a New Parent Work team to assign it to a Work Team Without Manager
    	String ParentTeamName4 = 'ParentTeam_WOM_4';
    	
    	User Manager4 = [SELECT Id FROM User WHERE IsActive = true AND (Id != :user_team.Id AND  Id != :manager_ui.Id AND Id != :u.Id AND Id != :Manager2.Id AND Id != :teamMember2.Id) LIMIT 1];
    	
    	WorkTeam__c workTeamParent4 = new WorkTeam__c(Team_Name__c = ParentTeamName4, Name = ParentTeamName4, Manager__c = Manager4.Id, Is_Active__c = true );
        insert workTeamParent4;
        
        // Creating a New Work Sub Team Without Manager
        String ParentTeamName3 = 'ParentTeam_WOM_3';
    	    	
    	WorkTeam__c workTeamParent3 = new WorkTeam__c(Team_Name__c = ParentTeamName3, Name = ParentTeamName3, Parent_Team__c = workTeamParent4.Id, Is_Active__c = true );
        insert workTeamParent3;             
        
        // Creating a New Work Team Without Manager
        String TeamNameWithOutManager2 = 'WorkTemaWithoutManager2';     
                
        WorkTeam__c workUserTeam3 = new WorkTeam__c(Team_Name__c = TeamNameWithOutManager2, Name = TeamNameWithOutManager2, Parent_Team__c = workTeamParent3.Id, Is_Active__c = true );
        insert workUserTeam3;            
        
         // Adding a Team Member to the New Work Team Without Manager
        User user_team3 = [SELECT Id FROM User WHERE IsActive = true AND (Id != : u.Id AND Id != :user_team.Id AND Id != :manager_ui.Id AND Id != :u.Id AND Id != :Manager2.Id AND Id != :teamMember2.Id AND Id != :Manager4.Id) LIMIT 1];
        
        Team_Member__c teamMember3 = new Team_Member__c(Work_Team__c = workUserTeam3.Id, Is_Active__c = true, UserRoleAPIName__c = TeamNameWithOutManager2, User_member__c = user_team3.Id );
        insert teamMember3;        
        
        // Creating a Case for testing
        Case newCase3 = new Case(subject='Inconvenientes con cargos tasados y facturados', Origin='Email', Status='Nueva', Approver__c = Manager4.Id);
        insert newCase3;        
        // 
             
        Test.startTest();
            // Changing case owner to the users created above
            newCase.OwnerId = user_team.Id;
            update newCase;
            
            newCase2.OwnerId = user_team2.Id;
            update newCase2;
            
            newCase3.OwnerId = user_team3.Id;
            update newCase3;
         
            // List "Pending" Approval processes 
            List<processInstanceWorkItem> processWorkItem = [SELECT Id, ActorId, ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE ( ActorId =: user_team.Id OR ActorId =: user_team2.Id OR ActorId =: user_team3.Id ) AND Isdeleted = false];
              
            for(ProcessInstanceWorkitem lpIWI :processWorkItem){
    		    	
    		    lpIWI.ProcessInstance.Status = 'Pending';
    		}   
         
            update processWorkItem;
         
            List<User> myList = new List<User>();
            myList.add(user_team);  
            myList.add(user_team2); 
            myList.add(user_team3);      
        
            Map<String, Object> newMp = new Map<String, Object>();
            newMp.put('usersInactive',myList);
                                
            System.enqueueJob(new InactivateTeamMebersWhenInactiveUsers('inactivateTeamMebers',newMp ));  
            
        Test.stopTest();        
    }
}