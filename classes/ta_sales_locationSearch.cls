global with sharing class ta_sales_locationSearch implements vlocity_cmt.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){

        if(methodName.equals('PopulateLocations')){
            PopulateLocations(input, outMap, options);
        }
        if(methodName.equals('PopulateLocationsTypeAHead')){
            PopulateLocationsTypeAHead(input, outMap, options);
        }
        if(methodName.equals('PopulateStateLocationsPickupAvailable')){
            PopulateStateLocationsPickupAvailable(input, outMap, options);
        }
        if(methodName.equals('PopulateCityLocationsPickupAvailable')){
            PopulateCityLocationsPickupAvailable(input, outMap, options);
        }
        if(methodName.equals('PopulateLocationsNewTypeAHead')){
            PopulateLocationsNewTypeAHead(input, outMap, options);
        }
        return true;
    }

    public void PopulateLocations(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('PopulateLocations');

        Map<String, List<Map<String, String>>> dependency = new Map<String,List<Map<String, String>>>();
        for (Location__c rel : [SELECT Id, Name, LocationCode__c, StateCode__c FROM Location__c ORDER BY Name]){
            if (!dependency.containsKey(rel.StateCode__c)){
                dependency.put(rel.StateCode__c, new List<Map<String, String>>());
            }
        
            Map<String, String> tempMap = new Map<String, String>();

            tempMap.put('name', rel.LocationCode__c);
            tempMap.put('value', rel.Name);

            dependency.get(rel.StateCode__c).add(tempMap);
        }

        outMap.put('dependency', dependency);
    }

    public void PopulateLocationsTypeAHead(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            Map<String, Object> accountData = (Map<String, Object>) input.get('AccountData');
            String state = (String) accountData.get('State');

            List<Location__c> locations = [SELECT Name, LocationCode__c
                                    FROM Location__c WHERE StateCode__c = :state
                                    ORDER BY Name];

            outMap.put('locations', locations);
        }catch (Exception e){}
    }

    public void PopulateStateLocationsPickupAvailable(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('Populate State Locations');
        Map<String, String> statePicklistValues = new Map<String, String>();
        List<Map<String, String>> returnedPicklistValues = new List<Map<String, String>>();

        //Gets the value of the Points of Sale available for Store Pickup
        List<vlocity_cmt__BusinessSite__c> businessSitesList = [SELECT vlocity_cmt__State__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleStorePickupEnabled__c = true];
        Set<String> stateAvailable = new Set<String>();
        for (vlocity_cmt__BusinessSite__c businessSite : businessSitesList) {
            if (businessSite.vlocity_cmt__State__c != null && businessSite.vlocity_cmt__State__c != '') {
                stateAvailable.add(businessSite.vlocity_cmt__State__c);
            }
        }

        //Gets the value of the states
        List<Schema.PicklistEntry> statePicklistEntries = Account.BillingStateCode.getDescribe().getPicklistValues();
        statePicklistEntries = sortPicklistEntryListByLabel(statePicklistEntries);

        for (Schema.PicklistEntry picklistEntry : statePicklistEntries) {
            if (stateAvailable.contains(picklistEntry.getValue())) {
                if (!statePicklistValues.containsKey(picklistEntry.getValue())) {
                    statePicklistValues.put(picklistEntry.getValue(), picklistEntry.getLabel());
                }
                Map<String, String> tempMap = new Map<String, String>();

                tempMap.put('name', picklistEntry.getValue());
                tempMap.put('value', statePicklistValues.get(picklistEntry.getValue()));

                returnedPicklistValues.add(tempMap);
            }
        }
        outMap.put('options', returnedPicklistValues);
    }

    public void PopulateCityLocationsPickupAvailable(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('Populate Locations');
        Map<String, List<Map<String, String>>> returnedPicklistValues = new Map<String, List<Map<String, String>>>();

        //Gets the value of the Points of Sale available for Store Pickup
        List<vlocity_cmt__BusinessSite__c> businessSitesList = [SELECT vlocity_cmt__City__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleStorePickupEnabled__c = true];
        Set<String> cityAvailable = new Set<String>();
        for (vlocity_cmt__BusinessSite__c businessSite : businessSitesList) {
            if (businessSite.vlocity_cmt__City__c != null && businessSite.vlocity_cmt__City__c != '') {
                cityAvailable.add(businessSite.vlocity_cmt__City__c);
            }
        }

        //Gets the value of the states
        List<Location__c> cityPicklistValues = [SELECT Name, LocationCode__c, StateCode__c FROM Location__c ORDER BY Name];
        for (Location__c location : cityPicklistValues) {

            if (cityAvailable.contains(location.LocationCode__c)) {
                if (!returnedPicklistValues.containsKey(location.StateCode__c)) {
                    returnedPicklistValues.put(location.StateCode__c, new List<Map<String, String>>());
                }
                Map<String, String> tempMap = new Map<String, String>();

                tempMap.put('name', location.LocationCode__c);
                tempMap.put('value', location.Name);

                returnedPicklistValues.get(location.StateCode__c).add(tempMap);
            }
        }
        outMap.put('dependency', returnedPicklistValues);
    }

    private List<Schema.PicklistEntry> sortPicklistEntryListByLabel(List<Schema.PicklistEntry> stringListEntries) {
        System.debug('Sort List');
        List<String> auxListToSort = new List<String>();
        List<Schema.PicklistEntry> sortedListToReturn = new List<PicklistEntry>();
        for (Schema.PicklistEntry picklistEntry : stringListEntries) {
            auxListToSort.add(picklistEntry.getLabel());
        }
        auxListToSort.sort();
        for (String label : auxListToSort) {
            for (Schema.PicklistEntry picklistEntry : stringListEntries) {
                if (picklistEntry.getLabel().equals(label)) {
                    sortedListToReturn.add(picklistEntry);
                }
            }
        }
        return sortedListToReturn;
    }
    
    public void PopulateLocationsNewTypeAHead(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        try{
            String state = (String) options.get('state');
            
            List<Location__c> locations = [SELECT Name, LocationCode__c
                                    FROM Location__c WHERE StateCode__c = :state
                                    ORDER BY Name];

            outMap.put('locations', locations);
        }catch (Exception e){}
    }
}