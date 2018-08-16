/*
 * Created by alazarev on 15/05/2018.
 */
@IsTest
private class PackageMaintenanceTest {

	@TestSetup public static void createSetofOs(){
		List<vlocity_cmt__OmniScript__c> listOfOs = new List<vlocity_cmt__OmniScript__c>();

		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='TestOS',vlocity_cmt__Version__c=1));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='TestOS',vlocity_cmt__Version__c=2));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='TestOS',vlocity_cmt__Version__c=3));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='TestOS',vlocity_cmt__Version__c=4));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='TestOS',vlocity_cmt__Version__c=5));



		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='OSt1',vlocity_cmt__Version__c=7));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='OSt1',vlocity_cmt__Version__c=9));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='OSt1',vlocity_cmt__Version__c=11));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='OSt1',vlocity_cmt__Version__c=10));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='OSt1',vlocity_cmt__Version__c=8));
		listOfOs.add(new vlocity_cmt__OmniScript__c(Name='OSt1',vlocity_cmt__Version__c=14));

		insert listOfOs;
	}

	@IsTest public static void testOsMaintenance(){

		Integer osVersionsLimit = 1;

		Test.startTest();
		PackageMaintenance.omniscriptMaintenance(1);
		Test.stopTest();

		List<vlocity_cmt__OmniScript__c> finalList = [SELECT Id,Name,LastModifiedDate,vlocity_cmt__Version__c,vlocity_cmt__IsActive__c
				FROM vlocity_cmt__OmniScript__c WHERE Name = 'TestOS'];
		System.assertEquals(osVersionsLimit,finalList.size());
	}
}