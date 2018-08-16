/*-------------------------------------------------------------------------------------------------------------------------------------------------------
	Author=>		Jeisson Rojas(JARN)
	Description=>	Controller Asset New Hierarchy
	<Date>					<Author>				<Change Description>
	06/06/2018				Jeisson Rojas(JARN)		Update Test Class.
     --------------------------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
public with sharing class ta_sales_locationSearchTest
{
	@isTest static void unitTest1()
	{
		String strg;
		Location__c objLocation = TestDataFactory.createLocations();
		TestDataFactory.createStreet(strg);
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> options = new Map<String, Object>();
		List<Schema.PicklistEntry> stringListEntries = new List<Schema.PicklistEntry>();
		options.put('LocationId',objLocation.Id);
		ta_sales_locationSearch salesLocation = new ta_sales_locationSearch();
		Test.startTest();
			salesLocation.invokeMethod('PopulateLocations', inputMap, outMap, options);
			salesLocation.invokeMethod('PopulateLocationsTypeAHeadbyOptions', inputMap, outMap, options);
			salesLocation.invokeMethod('validateAdressRange', inputMap, outMap, options);
			salesLocation.invokeMethod('PopulateStateLocationsPickupAvailable', inputMap, outMap, options);
			salesLocation.invokeMethod('PopulateCityLocationsPickupAvailable', inputMap, outMap, options);
			salesLocation.invokeMethod('PopulateLocationsNewTypeAHead', inputMap, outMap, options);
			salesLocation.invokeMethod('PopulateStreetsTypeAHead', inputMap, outMap, options);
			//salesLocation.invokeMethod('PopulateLocationsTypeAHead', inputMap, outMap, options);
			//stringListEntries.sortPicklistEntryListByLabel(stringListEntries);
		Test.stopTest();
	}
	@isTest static void unitTest2()
	{
		Map<String, Object> outMap = new Map<String, Object>();
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> options = new Map<String, Object>();
		Map<String, object> mapState = new Map<String, object>();
		mapState.put('State','B');
		inputMap.put('AccountData', mapState);
		ta_sales_locationSearch salesLocation = new ta_sales_locationSearch();
		Test.startTest();
			salesLocation.invokeMethod('PopulateLocationsTypeAHead', inputMap, outMap, options);
		Test.stopTest();
	}
}