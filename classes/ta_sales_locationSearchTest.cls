@isTest
public with sharing class ta_sales_locationSearchTest {
	public static testmethod void unitTest1(){
		Map<String, Object> outMap = new Map<String, Object>();
		insert new Location__c(Name = 'TestLoc', StateCode__c = '12');
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> accountData = new Map<String, Object>();
		accountData.put('State', '123');
		inputMap.put('AccountData', accountData);

		Test.startTest();
		ta_sales_locationSearch tsl = new ta_sales_locationSearch();
		tsl.invokeMethod('PopulateLocations', null, outMap, null);
		tsl.invokeMethod('PopulateLocationsTypeAHead', inputMap, outMap, null);
		tsl.invokeMethod('PopulateLocationsTypeAHead', null, null, null);
		Test.stopTest();
	}

	public static testmethod void unitTest2(){
		MockupFactory.generate();
		Map<String, Object> outMap = new Map<String, Object>();
		insert new Location__c(Name = 'TestLoc', StateCode__c = '12');
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> accountData = new Map<String, Object>();
		accountData.put('State', '123');
		inputMap.put('AccountData', accountData);

		Account acct = [SELECT Id FROM Account where AccountNumber = '1234' LIMIT 1];
		List<Location__c> cityPicklistValues = [SELECT Name, LocationCode__c, StateCode__c, DepartmentCode__c FROM Location__c WHERE DepartmentCode__c != NULL ORDER BY Name];

		vlocity_cmt__BusinessSite__c businessSite = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=acct.Id, PointOfSaleStorePickupEnabled__c=true, vlocity_cmt__City__c=cityPicklistValues[0].LocationCode__c, vlocity_cmt__State__c=cityPicklistValues[0].StateCode__c);
		insert businessSite;

		Test.startTest();
		ta_sales_locationSearch tsl = new ta_sales_locationSearch();
		tsl.invokeMethod('PopulateStateLocationsPickupAvailable', inputMap, outMap, null);
		tsl.invokeMethod('PopulateCityLocationsPickupAvailable', inputMap, outMap, null);
		Test.stopTest();

	}
}