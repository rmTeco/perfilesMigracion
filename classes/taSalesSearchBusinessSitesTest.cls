@isTest(seeAllData=false)
public with sharing class taSalesSearchBusinessSitesTest {
    
	public static testmethod void getBusinessSitesByCityTest(){
		Account acc = new Account(Name = 'test');
		insert acc;
		Map<String, Object> outMap = new Map<String, Object>();
        vlocity_cmt__BusinessSite__c bussite = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c = 'LE');
		insert bussite;
		Test.startTest();
		taSalesSearchBusinessSites tsl = new taSalesSearchBusinessSites();
		tsl.invokeMethod('getBusinessSitesByCity', null, outMap, null);
		Test.stopTest();
	}

	public static testmethod void getStorePickUpBusinessSitesByCityTest(){
		Account acc = new Account(Name = 'test');
		insert acc;
		Map<String, Object> outMap = new Map<String, Object>();
		insert new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c = 'LE', Type__c = 'POS', PointOfSaleStorePickupEnabled__c = true);
		Test.startTest();
		taSalesSearchBusinessSites tsl = new taSalesSearchBusinessSites();
		tsl.invokeMethod('getStorePickUpBusinessSitesByCity', null, outMap, null);
		Test.stopTest();
	}
    
	public static testmethod void getPostOfficesByCityTest(){
		Account acc = new Account(Name = 'test');
		insert acc;
		Map<String, Object> outMap = new Map<String, Object>();
		insert new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c = 'LE', Type__c = 'PostOffice', PostOfficeEndDate__c = null);
		Test.startTest();
		taSalesSearchBusinessSites tsl = new taSalesSearchBusinessSites();
		tsl.invokeMethod('getPostOfficesByCity', null, outMap, null);
		Test.stopTest();
	}
    
	public static testmethod void getStorePickUpBusinessSitesByCityLookupTest(){
        MockupFactory.generate();
        String city = 'Tigre';
        
		Account acc = [SELECT Id FROM Account LIMIT 1];
        Order ord = [SELECT Id FROM Order LIMIT 1];
		vlocity_cmt__BusinessSite__c busSite = new vlocity_cmt__BusinessSite__c(vlocity_cmt__City__c = city, PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c = 'LE', Type__c = 'POS', PointOfSaleStorePickupEnabled__c = true);
        insert busSite;
        
        ord.OriginStoreLocation__c = busSite.Id;
        ord.vlocity_cmt__OriginatingChannel__c = 'Presencial Agente';
        update ord;
        
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap.put('City', city);
        inputMap.put('orderId', ord.Id);
        inputMap.put('SalesChannelConfiguration', auxMap);
        
		Test.startTest();
		taSalesSearchBusinessSites tsl = new taSalesSearchBusinessSites();
		tsl.invokeMethod('getStorePickUpBusinessSitesByCityLookup', inputMap, outMap, null);
		Test.stopTest();
	}
    public static testmethod void getStorePickUpBusinessSitesByCityLookupTest2(){
        MockupFactory.generate();
        String city = 'Tigre';
        
		Account acc = [SELECT Id FROM Account LIMIT 1];
        Order ord = [SELECT Id FROM Order LIMIT 1];
        ord.vlocity_cmt__OriginatingChannel__c = '';
        update ord;
		vlocity_cmt__BusinessSite__c busSite = new vlocity_cmt__BusinessSite__c(vlocity_cmt__City__c = city, PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c = 'LE', Type__c = 'POS', PointOfSaleStorePickupEnabled__c = true);
        insert busSite;
        
        ord.OriginStoreLocation__c = busSite.Id;
        ord.vlocity_cmt__OriginatingChannel__c = 'Presencial Agente';
        update ord;
        
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap.put('City', city);
        inputMap.put('orderId', ord.Id);
        inputMap.put('SalesChannelConfiguration', auxMap);
        
		Test.startTest();
		taSalesSearchBusinessSites tsl = new taSalesSearchBusinessSites();
		tsl.invokeMethod('getStorePickUpBusinessSitesByCityLookup', inputMap, outMap, null);
		Test.stopTest();
	}
        public static testmethod void getStorePickUpBusinessSitesByCityLookupTestNull(){
        MockupFactory.generate();
        String city = 'Tigre';
        
		Account acc = [SELECT Id FROM Account LIMIT 1];
        Order ord = [SELECT Id FROM Order LIMIT 1];
		vlocity_cmt__BusinessSite__c busSite = new vlocity_cmt__BusinessSite__c(vlocity_cmt__City__c = city, PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c = 'LE', Type__c = 'POS', PointOfSaleStorePickupEnabled__c = true);
        insert busSite;
        
        ord.OriginStoreLocation__c = busSite.Id;
        ord.vlocity_cmt__OriginatingChannel__c = 'Presencial Agente';
        update ord;
        
		Map<String, Object> inputMap = new Map<String, Object>();
		Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap.put('City', city);
        inputMap.put('orderId', '');
        inputMap.put('SalesChannelConfiguration', auxMap);
        
		Test.startTest();
		taSalesSearchBusinessSites tsl = new taSalesSearchBusinessSites();
		tsl.invokeMethod('getStorePickUpBusinessSitesByCityLookup', inputMap, outMap, null);
		Test.stopTest();
	}
}