global with sharing class taSalesSearchBusinessSites implements vlocity_cmt.VlocityOpenInterface{
    
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        
        if(methodName.equals('getBusinessSitesByCity')){
            getBusinessSitesByCity(outMap);
        }
        
        if(methodName.equals('getStorePickUpBusinessSitesByCity')){
            getStorePickUpBusinessSitesByCity(outMap);
        }
        
        if(methodName.equals('getPostOfficesByCity')){
            getPostOfficesByCity(outMap);
        }
        //INI - GS - PFTA-3595
        if(methodName.equals('getStorePickUpBusinessSitesByCityLookup')){
            getStorePickUpBusinessSitesByCityLookup(input, outMap, options);
        }
        //FIN - GS - PFTA-3595
        
        return true;
    }

    public void getBusinessSitesByCity(Map<String, Object> outMap){
        Map<String, List<Map<String, String>>> businessSitesDependency = new Map<String,List<Map<String, String>>>();

        for (vlocity_cmt__BusinessSite__c stores : [SELECT PointOfSaleId__c, vlocity_cmt__City__c, vlocity_cmt__StreetAddress__c, PointOfSaleAddressNumber__c FROM vlocity_cmt__BusinessSite__c ORDER BY vlocity_cmt__StreetAddress__c]){
            if (!businessSitesDependency.containsKey(stores.vlocity_cmt__City__c)){
                businessSitesDependency.put(stores.vlocity_cmt__City__c, new List<Map<String, String>>());
            }

            Map<String, String> tempMap = new Map<String, String>();
            
            tempMap.put('name', String.valueOf(stores.PointOfSaleId__c));
            tempMap.put('value', stores.vlocity_cmt__StreetAddress__c + ' ' + stores.PointOfSaleAddressNumber__c);
            
            businessSitesDependency.get(stores.vlocity_cmt__City__c).add(tempMap);
        }
        outMap.put('dependency', businessSitesDependency);
    }
    
    public void getStorePickUpBusinessSitesByCity(Map<String, Object> outMap){
        System.debug('paso 1 >>>>>>>>>>>>>>>');    
        Map<String, List<Map<String, String>>> businessSitesDependency = new Map<String,List<Map<String, String>>>();
        System.debug('paso 1 ');
        for (vlocity_cmt__BusinessSite__c store : [SELECT Name, PointOfSaleId__c, vlocity_cmt__City__c, vlocity_cmt__StreetAddress__c, PointOfSaleAddressNumber__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleStorePickupEnabled__c = true AND Type__c = 'POS' ORDER BY vlocity_cmt__StreetAddress__c]){
            if (!businessSitesDependency.containsKey(store.vlocity_cmt__City__c)){
                businessSitesDependency.put(store.vlocity_cmt__City__c, new List<Map<String, String>>());
            }
            
            Map<String, String> tempMap = new Map<String, String>();
            
            tempMap.put('name', store.Id);
            tempMap.put('value', store.Name + ' - ' + store.vlocity_cmt__StreetAddress__c + ' ' + store.PointOfSaleAddressNumber__c);
            
            businessSitesDependency.get(store.vlocity_cmt__City__c).add(tempMap);
        }
        System.debug('paso 1.1 ->'+ businessSitesDependency);
        outMap.put('dependency', businessSitesDependency);
    }
    
    public void getPostOfficesByCity(Map<String, Object> outMap) {
        try {
            Map<String, List<Map<String, String>>> businessSitesDependency = new Map<String,List<Map<String, String>>>();
            System.debug('paso 1.1' );
            List<vlocity_cmt__BusinessSite__c> storeLocations = [SELECT Name, Id, PostOfficeCode__c, vlocity_cmt__City__c, vlocity_cmt__StreetAddress__c, PointOfSaleAddressNumber__c
                                           FROM vlocity_cmt__BusinessSite__c
                                          WHERE RecordTypeId IN (SELECT Id
                                                                  FROM RecordType
                                                                 WHERE SobjectType = 'vlocity_cmt__BusinessSite__c'
                                                                   AND Name = 'Sucursales de Correo')
                                            AND Status__c = 'Activo'
                                          ORDER BY vlocity_cmt__StreetAddress__c];
                        
            for (vlocity_cmt__BusinessSite__c store : storeLocations){
                if (!businessSitesDependency.containsKey(store.vlocity_cmt__City__c)){
                    businessSitesDependency.put(store.vlocity_cmt__City__c, new List<Map<String, String>>());
                }
                
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', String.valueOf(store.Id));
                tempMap.put('value', store.PostOfficeCode__c + ' - ' + store.Name);
                
                businessSitesDependency.get(store.vlocity_cmt__City__c).add(tempMap);
            }
            outMap.put('dependency', businessSitesDependency);
        }
        catch(Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public void getStorePickUpBusinessSitesByCityLookup(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            String orderId = (String) inputMap.get('orderId');
            String location = (String) ((Map<String, Object>) inputMap.get('SalesChannelConfiguration')).get('City');
            System.debug('location: ' + location);

            Order order = [SELECT Id, OriginStoreLocation__c, vlocity_cmt__OriginatingChannel__c
                            FROM Order
                            WHERE Id = :orderId];

            vlocity_cmt__BusinessSite__c storeOrigin = [SELECT Name, vlocity_cmt__City__c
                                                        FROM vlocity_cmt__BusinessSite__c
                                                        WHERE Id = :order.OriginStoreLocation__c];

            List<Map<String, String>> tempList = new List<Map<String, String>>();
            List<vlocity_cmt__BusinessSite__c> storeLocations = [SELECT Name,
                                                                        PointOfSaleId__c,
                                                                        vlocity_cmt__City__c,
                                                                        vlocity_cmt__StreetAddress__c,
                                                                        PointOfSaleAddressNumber__c,
                                                                        PointOfSaleChannel__c
                                                                FROM vlocity_cmt__BusinessSite__c
                                                                WHERE PointOfSaleStorePickupEnabled__c = true
                                                                    AND Type__c = 'POS'
                                                                    AND Location__c = :location
                                                                ORDER BY vlocity_cmt__StreetAddress__c];

            for (vlocity_cmt__BusinessSite__c store : storeLocations) {
                Map<String, String> tempMap = new Map<String, String>();
                tempMap.put('name', store.Id);
                tempMap.put('value', store.Name + ' - ' + store.vlocity_cmt__StreetAddress__c + ' ' + store.PointOfSaleAddressNumber__c);

                if (orderId == '' || orderId == 'null')
                    tempList.add(tempMap);
                else {
                    if (order.vlocity_cmt__OriginatingChannel__c == 'Presencial Agente') {
                        if (store.Name.contains(storeOrigin.name))
                            tempList.add(tempMap);
                        else {
                            String aux = String.valueOf(store.PointOfSaleChannel__c);
                            if (aux == 'Presencial Oficina Comercial')
                                tempList.add(tempMap);
                        }
                    }
                    else
                        tempList.add(tempMap);
                }
            }

            outMap.put('options', tempList);
        }
        catch(Exception e) {
            System.debug('getStorePickUpBusinessSitesByCityLookup Exception Msg: ' + e.getMessage());
            System.debug('getStorePickUpBusinessSitesByCityLookup Exception Cause: ' + e.getCause());
            System.debug('getStorePickUpBusinessSitesByCityLookup Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
}