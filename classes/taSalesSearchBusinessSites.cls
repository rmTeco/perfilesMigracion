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
        Map<String, List<Map<String, String>>> businessSitesDependency = new Map<String,List<Map<String, String>>>();
        
        for (vlocity_cmt__BusinessSite__c store : [SELECT Name, PointOfSaleId__c, vlocity_cmt__City__c, vlocity_cmt__StreetAddress__c, PointOfSaleAddressNumber__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleStorePickupEnabled__c = true AND Type__c = 'POS' ORDER BY vlocity_cmt__StreetAddress__c]){
            if (!businessSitesDependency.containsKey(store.vlocity_cmt__City__c)){
                businessSitesDependency.put(store.vlocity_cmt__City__c, new List<Map<String, String>>());
            }
            
            Map<String, String> tempMap = new Map<String, String>();
            
            tempMap.put('name', store.Id);
            tempMap.put('value', store.Name + ' - ' + store.vlocity_cmt__StreetAddress__c + ' ' + store.PointOfSaleAddressNumber__c);
            
            businessSitesDependency.get(store.vlocity_cmt__City__c).add(tempMap);
        }
        outMap.put('dependency', businessSitesDependency);
    }
    
    public void getPostOfficesByCity(Map<String, Object> outMap){
        Map<String, List<Map<String, String>>> businessSitesDependency = new Map<String,List<Map<String, String>>>();
        
        for (vlocity_cmt__BusinessSite__c stores : [SELECT Name, Id, PostOfficeCode__c, vlocity_cmt__City__c, vlocity_cmt__StreetAddress__c, PointOfSaleAddressNumber__c FROM vlocity_cmt__BusinessSite__c WHERE Type__c = 'PostOffice' AND PostOfficeEndDate__c = null ORDER BY vlocity_cmt__StreetAddress__c]){
            if (!businessSitesDependency.containsKey(stores.vlocity_cmt__City__c)){
                businessSitesDependency.put(stores.vlocity_cmt__City__c, new List<Map<String, String>>());
            }
            
            Map<String, String> tempMap = new Map<String, String>();
            
            tempMap.put('name', String.valueOf(stores.Id));
            //Venkatesh : PFTA-7463
            //tempMap.put('value', stores.Name + ' - ' + stores.vlocity_cmt__StreetAddress__c + ' ' + stores.PointOfSaleAddressNumber__c);
            tempMap.put('value', stores.PostOfficeCode__c + ' - ' + stores.Name );
            
            businessSitesDependency.get(stores.vlocity_cmt__City__c).add(tempMap);
        }
        outMap.put('dependency', businessSitesDependency);
    }
    
    //INI - GS - PFTA-3595
    
    public void getStorePickUpBusinessSitesByCityLookup(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
      try{
            List<Map<String, String>> tempList = new List<Map<String, String>>();
            String idOrder = (String) input.get('orderId');
            System.debug('idOrder: ' + idOrder);
            Map<String, Object> json = (Map<String, Object>) input.get('SalesChannelConfiguration');
            String city = (String) json.get('City');
            Order ord = new Order();
            ord = [SELECT Id, OriginStoreLocation__c, vlocity_cmt__OriginatingChannel__c FROM Order WHERE Id = :idOrder];
            vlocity_cmt__BusinessSite__c storeOrigin = new vlocity_cmt__BusinessSite__c();
            storeOrigin = [SELECT Name, vlocity_cmt__City__c FROM vlocity_cmt__BusinessSite__c WHERE Id = :ord.OriginStoreLocation__c];
            
            
            for (vlocity_cmt__BusinessSite__c store : [SELECT Name, PointOfSaleId__c, vlocity_cmt__City__c, vlocity_cmt__StreetAddress__c, PointOfSaleAddressNumber__c, PointOfSaleChannel__c FROM vlocity_cmt__BusinessSite__c WHERE PointOfSaleStorePickupEnabled__c = true AND Type__c = 'POS' AND vlocity_cmt__City__c = :city ORDER BY vlocity_cmt__StreetAddress__c]){
                
                Map<String, String> tempMap = new Map<String, String>();
                
                tempMap.put('name', store.Id);
                tempMap.put('value', store.Name + ' - ' + store.vlocity_cmt__StreetAddress__c + ' ' + store.PointOfSaleAddressNumber__c);
                System.debug('Store: ' + store);
                if(idOrder == '' || idOrder == 'null'){
                    tempList.add(tempMap);
                }else{  
                    if(ord.vlocity_cmt__OriginatingChannel__c == 'Presencial Agente'){
                        if(store.Name.contains(storeOrigin.name)){
                            tempList.add(tempMap);
                        }else{
                            String aux = String.valueOf(store.PointOfSaleChannel__c);
                            if(aux == 'Presencial Oficina Comercial'){ //CAMBIO PARA COMPATIBILIDAD ORDER.ORIGINATINGCHANNEL__c
                                tempList.add(tempMap);
                            }
                        }
                    }else{
                        tempList.add(tempMap);
                    }
                }
            }
            outMap.put('options', tempList);
      }
        catch(exception e){system.debug('Excep'+e);}
    }
    
    //FIN - GS - PFTA-3595
    
    
}