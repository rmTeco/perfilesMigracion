public with sharing class PackageMaintenance {

    public static Boolean debug = false;

    public static void omniscriptMaintenance(Integer osVersionsLimit){

        Map<String, List<vlocity_cmt__OmniScript__c>> osMap = new Map<String, List<vlocity_cmt__OmniScript__c>>();
        List<vlocity_cmt__OmniScript__c> surplusList = new List<vlocity_cmt__OmniScript__c>();

        //
        try {
            // This has to return the Map of String,List<vlocity_cmt__OmniScript__c>
            osMap = PackageMaintenance.processOmniscriptsToMap(osVersionsLimit);
        } catch (Exception ex){
            System.debug('OmniScript Maintenance Exception: ' + ex);
        }

        if(!osMap.isEmpty()){
            // Looping through map to get the OS name with its ammount of versions in the list,
            if(debug) System.debug('OS Versions Limited on: ' + osVersionsLimit);
            if(debug) System.debug('OmniScrips Map: '+ osMap.size());
            surplusList = PackageMaintenance.processSurplusList(osMap,osVersionsLimit);

        } else {
            System.debug('There are no OmniScripts lists that exceed the limit.');
        }

        if(!surplusList.isEmpty()){
            try {
                if(debug) { System.debug('Surplus List to delete: '+ surplusList.size()); }
                delete surplusList;
            } catch (DmlException dmlex){
                System.debug('Cannot delete surplus list: ' + dmlex);
            }
        } else {
            System.debug('There are no OmniScripts to delete in the surplus list.');
        }
    }

    public static Map<String, List<vlocity_cmt__OmniScript__c>> processOmniscriptsToMap(Integer osVersionsLimit) {

        String osName = '';
        Boolean firstRun = true;
        // The map that we will fill with the lists of OSs that need to be cleanedup due > osVersionsLimit
        Map<String, List<vlocity_cmt__OmniScript__c>> osMap = new Map<String, List<vlocity_cmt__OmniScript__c>>();
        // Iteration list for OSs sorted by OSName
        List<vlocity_cmt__OmniScript__c> osToMapList = new List<vlocity_cmt__OmniScript__c>();

        List<vlocity_cmt__OmniScript__c> osFullList =
                [SELECT Id,Name,LastModifiedDate,vlocity_cmt__Version__c,vlocity_cmt__IsActive__c
                FROM vlocity_cmt__OmniScript__c WHERE vlocity_cmt__IsActive__c = false
                ORDER BY Name ASC NULLS FIRST LIMIT 10000];


        for (vlocity_cmt__OmniScript__c os : osFullList) {


            // if it's the firstRun then we add the OS to the List and set the OS Name, and change firstRun
            if(firstRun) {
                //if(debug) { System.debug('firstRun: ' + firstRun); }
                osToMapList.add(os);
                //if(debug) { System.debug('firstRun - osToMapList: ' + osToMapList); }
                osName = os.Name;
                //if(debug) { System.debug('firstRun - osName: ' + osName); }
                firstRun = false;

            // if its not the first run but we are looping through the same OS Name, we still adding them to the list
            } else if(!firstRun && osName == os.Name) {
                //if(debug) { System.debug('!firstRun && osName == os.Name'); }
                osToMapList.add(os);
                //if(debug) { System.debug('!firstRun && osName == os.Name - osToMapList: ' + osToMapList); }

            // if its not the first run but the os name changed, means that we need to add the handled list so far
            // to the map, reset the list, add the new os to it and set the new os name
            } else if(!firstRun && osName != os.Name) {
                //if(debug) { System.debug('!firstRun && osName != os.Name'); }
                // Add preexisting list to the map with the last stored in list OS Name
                // Only adding the lists that are bigger that the limit
                //if(debug) { System.debug('!firstRun && osName != os.Name - osToMapList: ' + osToMapList); }
                if(osToMapList.size() > osVersionsLimit) {
                    osMap.put(osName, osToMapList);
                }
                //if(debug) { System.debug('!firstRun && osName != os.Name - osMap: ' + osMap); }

                // reset the list to store the different os name
                osToMapList = new List<vlocity_cmt__OmniScript__c>();
                //if(debug) { System.debug('!firstRun && osName != os.Name - osToMapList RESET: ' + osToMapList); }

                // store the new os to the clean list
                osToMapList.add(os);

                //if(debug) { System.debug('!firstRun && osName != os.Name - osName PRE : ' + osToMapList); }
                osName = os.Name;
                //if(debug) { System.debug('!firstRun && osName != os.Name - osName POST: ' + osToMapList); }
            }
            // last list of OSs need to be stored too:
            if(osToMapList.size() > osVersionsLimit) {
                osMap.put(osName, osToMapList);
            }

        }

        // Returning the Map for cleanup processing
        return osMap;
    }

    public static List<vlocity_cmt__OmniScript__c> processSurplusList(Map<String, List<vlocity_cmt__OmniScript__c>> osMap, Integer osVersionsLimit) {
        // List of surplus os
        List<vlocity_cmt__OmniScript__c> surplusList = new List<vlocity_cmt__OmniScript__c>();

        // Going through the map
        for(List<vlocity_cmt__OmniScript__c> osList : osMap.values()){

            // Sorting the oslist
            // The sorting will be done ASC by Name and lastModifiedDate
            osList.sort();

            /*if(debug) {
                System.debug('sort');
                for (vlocity_cmt__OmniScript__c oss : osList) {
                    //System.debug('OS: '+ oss.Name + ' - Version: '+oss.vlocity_cmt__Version__c);
                    System.debug(oss);
                }
            }*/

            // Reversed sorting to leave the lattest versions first and if the size() > allowed limit of OS
            // the we will populate the surplus list with those that should be deleted
            for(Integer i = osList.size() - (osVersionsLimit+1); i >= 0; i--){
                surplusList.add(osList[i]);
                if(debug) { System.debug('OS: '+ osList[i].Name + ' - Version: '+osList[i].vlocity_cmt__Version__c); }
            }
        }
        return surplusList;
    }
}