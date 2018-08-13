/**
* @Author: Julia Carranza
* @Description: This test tests the AttributesUsage Class for the Account Object.
*/
@isTest
public class WorkTeamTriggersTest {
	
	@isTest static void workTeamAndTeamMeberSync(){

		List<User> userList = new List<User>([SELECT Id FROM User LIMIT 1]);
		User user1 = userList[0];
		WorkTeam__c wt1 = new WorkTeam__c(Name = 'wt1 Name', Is_Active__c = true, Team_Name__c = 'wt1 Name');

		Test.startTest();

		Database.Insert(wt1);
		Team_Member__c tm1 = new Team_Member__c(Is_Active__c = true, User_member__c = user1.Id, Work_Team__c = wt1.Id, UserRoleAPIName__c = 'FAN_Director');
		Database.Insert(tm1);
		tm1.Is_Active__c = false;
		Database.Update(tm1);
		tm1.Is_Active__c = true;
		Database.Update(tm1);
		Database.Delete(tm1);
		wt1.Is_Active__c = false;
		Database.Update(wt1);
		Database.Delete(wt1);

		Test.stopTest();
	}
}