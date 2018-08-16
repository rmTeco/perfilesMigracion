@isTest
public class AministrarWorkTeam_ctrTest {

    @isTest static void AministrarWorkTeam_ctrWithOneWorkTeamTest() {
    	//GIVEN
    	WorkTeam__c wt = new WorkTeam__c(
            Name = 'Test',
            Team_Name__c = 'Test'
        );
    	wt.Work_Place__c = TestDataFactory.createStoreLocation('Test').Id;
    	insert wt;
    	
    	//WHEN
    	Test.startTest();
        AministrarWorkTeam_ctr AministrarWorkTeam_ctr = new AministrarWorkTeam_ctr();
        Test.stopTest();
    }
    @isTest static void AministrarWorkTeam_ctrWithTenWorkTeamTest() {
    	//GIVEN
    	Id storeLocationsId = TestDataFactory.createStoreLocation('Test').Id;
    	for (Integer i = 0; i <= 10; i++) {
    		WorkTeam__c wt = new WorkTeam__c(
	            Name = 'Test'+i,
	            Team_Name__c = 'Test'+i
	        );
	
	        wt.Work_Place__c = storeLocationsId;
	        insert wt;
    	}
    	
    	//WHEN
    	Test.startTest();
        AministrarWorkTeam_ctr AministrarWorkTeam_ctr = new AministrarWorkTeam_ctr();
        Test.stopTest();
    }
}