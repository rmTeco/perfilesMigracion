global with sharing class Components {
    
    private static Map<String, List<DRInfo>> drExtract;
    private static Map<String, List<DRInfo>> drLoad;
    private static Map<String, Id> classesMap;
    
    @AuraEnabled
    public static List<vlocity_cmt__OmniScript__c> OSList(){
        List<vlocity_cmt__OmniScript__c> omniscriptList = [SELECT Id, Name, vlocity_cmt__Version__c, vlocity_cmt__IsProcedure__c
                                                           FROM vlocity_cmt__OmniScript__c 
                                                           ORDER BY Name, vlocity_cmt__Version__c DESC];
        return omniscriptList;
    }
    
    @AuraEnabled
    public static List<Element> OSElement(String omniscriptId){
        classesMap = getClass();
        drExtract = dataRaptorExtract();
        drLoad = dataRaptorLoad();
        Map<String, List<Element>> IPElementsMap = IPElement();
        List<Element> elementList = new List<Element>();
        for (vlocity_cmt__Element__c e : [SELECT 
                                          	Id, Name, vlocity_cmt__Type__c, vlocity_cmt__ParentElementId__c, vlocity_cmt__PropertySet__c, 
                                          	vlocity_cmt__Active__c, vlocity_cmt__OmniScriptId__r.Name 
                                          FROM vlocity_cmt__Element__c 
                                          WHERE vlocity_cmt__OmniScriptId__c = :omniscriptId
                                          ORDER BY vlocity_cmt__Order__c]) {
            Element el = new Element();
            el.elementId = e.Id;
            el.elementName = e.Name;
            el.elementType = e.vlocity_cmt__Type__c;
            el.parentElementId = e.vlocity_cmt__ParentElementId__c;
            el.elementStatus = e.vlocity_cmt__Active__c;
            Map<String, Object> propertyMap = (Map<String, Object>)JSON.deserializeUntyped(e.vlocity_cmt__PropertySet__c);
            if(e.vlocity_cmt__Type__c.equalsIgnoreCase('DataRaptor Extract Action')) {
                if (drExtract.containsKey(String.valueOf(propertyMap.get('bundle')))) {
                    el.elementDR = drExtract.get(String.valueOf(propertyMap.get('bundle')));
                }
            } else if (e.vlocity_cmt__Type__c.equalsIgnoreCase('DataRaptor Post Action')) {
                if (drLoad.containsKey(String.valueOf(propertyMap.get('bundle')))) {
                    el.elementDR = drLoad.get(String.valueOf(propertyMap.get('bundle')));
                }
            }
            if (e.vlocity_cmt__Type__c.contains('Remote Action')) {
                String className = String.valueOf(propertyMap.get('remoteClass'));
                if(className.contains('vlocity_cmt.')) className = className.remove('vlocity_cmt.');
                if (classesMap.containsKey(className)) {
                    el.className = className;
                    el.classId = classesMap.get(className);
                }
            }
            if (e.vlocity_cmt__Type__c == 'Integration Procedure Action') {
                if (IPElementsMap.containsKey(String.valueOf(propertyMap.get('integrationProcedureKey')))) {
                    List<Element> elementIP = IPElementsMap.get(String.valueOf(propertyMap.get('integrationProcedureKey')));
                    for (Element IPel : elementIP) {
                        IPel.elementName += ' ( Integration Procedure ) > ' + propertyMap.get('integrationProcedureKey') ;
                        elementList.add(IPel);
                    }
                }
            }
            elementList.add(el);
        }
        return elementList;
    }
    
    @AuraEnabled
    public static Map<String, List<DRInfo>> dataRaptorExtract(){
        Map<String, List<DRInfo>> drElements = new Map<String, List<DRInfo>>();
        for (vlocity_cmt__DRMapItem__c drItemList : [SELECT vlocity_cmt__InterfaceFieldAPIName__c, vlocity_cmt__InterfaceObjectName__c, Name 
                                                     FROM vlocity_cmt__DRMapItem__c 
                                                     ORDER BY vlocity_cmt__DomainObjectCreationOrder__c]){
			DRInfo info = new DRInfo();
            info.fieldName = drItemList.vlocity_cmt__InterfaceFieldAPIName__c;
            info.objectName = drItemList.vlocity_cmt__InterfaceObjectName__c;
            if (drElements.containsKey(drItemList.Name)) {
                drElements.get(drItemList.Name).add(info);
            } else {
                List<DRInfo> infoList = new List<DRInfo>();
                infoList.add(info);
                drElements.put(drItemList.Name, infoList);
            }
                                                         
		}
        return drElements;
    }
    
    @AuraEnabled
    public static Map<String, List<DRInfo>> dataRaptorLoad(){
        Map<String, List<DRInfo>> drElements = new Map<String, List<DRInfo>>();
        for (vlocity_cmt__DRMapItem__c drItemList : [SELECT vlocity_cmt__DomainObjectAPIName__c,vlocity_cmt__DomainObjectFieldAPIName__c,Name 
                                                     FROM vlocity_cmt__DRMapItem__c]){
            DRInfo info = new DRInfo();
            info.fieldName = drItemList.vlocity_cmt__DomainObjectFieldAPIName__c;
            info.objectName = drItemList.vlocity_cmt__DomainObjectAPIName__c;
            if (drElements.containsKey(drItemList.Name)) {
                drElements.get(drItemList.Name).add(info);
            } else {
                List<DRInfo> infoList = new List<DRInfo>();
                infoList.add(info);
                drElements.put(drItemList.Name, infoList);
            }
        }
        return drElements;
    }
    
    private static Set<Id> IPSet(){
        Set<Id> idIPSet = new Set<Id>();
        for (vlocity_cmt__OmniScript__c os : [SELECT Id, Name, vlocity_cmt__Version__c 
                                              FROM vlocity_cmt__OmniScript__c 
                                              WHERE vlocity_cmt__IsActive__c = true 
                                              	AND vlocity_cmt__IsProcedure__c = true 
                                              ORDER BY Name, vlocity_cmt__Version__c DESC]) {
            idIPSet.add(os.Id);
        }
        return idIPSet;
    }
    
    private static Map<String, List<Element>> IPElement(){
        Set<Id> idIPSet = IPSet();
        Map<String, List<Element>> elementMap = new Map<String, List<Element>>();
        for (vlocity_cmt__Element__c e : [SELECT 
                                          	Id, Name, vlocity_cmt__Type__c, vlocity_cmt__ParentElementId__c, vlocity_cmt__PropertySet__c, 
                                          	vlocity_cmt__Active__c, vlocity_cmt__OmniScriptId__c, vlocity_cmt__OmniScriptId__r.vlocity_cmt__ProcedureKey__c 
                                          FROM vlocity_cmt__Element__c 
                                          WHERE vlocity_cmt__OmniScriptId__c IN :idIPSet 
                                          ORDER BY vlocity_cmt__Order__c]) {
            Element el = new Element();
            el.elementId = e.Id;
            el.elementName = e.Name;
            el.elementType = e.vlocity_cmt__Type__c;
            el.parentElementId = e.vlocity_cmt__ParentElementId__c;
            el.elementStatus = e.vlocity_cmt__Active__c;
            Map<String, Object> propertyMap = (Map<String, Object>)JSON.deserializeUntyped(e.vlocity_cmt__PropertySet__c);
            if(e.vlocity_cmt__Type__c.equalsIgnoreCase('DataRaptor Extract Action')) {
                if (drExtract.containsKey(String.valueOf(propertyMap.get('bundle')))) {
                    el.elementDR = drExtract.get(String.valueOf(propertyMap.get('bundle')));
                }
            } else if (e.vlocity_cmt__Type__c.equalsIgnoreCase('DataRaptor Post Action')) {
                if (drLoad.containsKey(String.valueOf(propertyMap.get('bundle')))) {
                    el.elementDR = drLoad.get(String.valueOf(propertyMap.get('bundle')));
                }
            }
            if (e.vlocity_cmt__Type__c.contains('Remote Action')) {
                String className = String.valueOf(propertyMap.get('remoteClass'));
                if(className.contains('vlocity_cmt.')) className = className.remove('vlocity_cmt.');
                if (classesMap.containsKey(className)) {
                    el.className = className;
                    el.classId = classesMap.get(className);
                }
            }
            if (elementMap.containsKey(e.vlocity_cmt__OmniScriptId__r.vlocity_cmt__ProcedureKey__c)) {
                elementMap.get(e.vlocity_cmt__OmniScriptId__r.vlocity_cmt__ProcedureKey__c).add(el);
            } else {
                List<Element> elementList = new List<Element>();
                elementList.add(el);
                elementMap.put(e.vlocity_cmt__OmniScriptId__r.vlocity_cmt__ProcedureKey__c, elementList);
            }
        }
        return elementMap;
    }
    
    private static Map<String, Id> getClass() {
        Map<String, Id> classMap = new Map<String, Id>();
        for (ApexClass ac : [SELECT Id,Name,NamespacePrefix 
                             FROM ApexClass]){
            classMap.put(ac.Name, ac.Id);
        }
        return classMap;
    }

    global class Element {
        @AuraEnabled global String elementId;
        @AuraEnabled global String elementName;
        @AuraEnabled global String elementType;
        @AuraEnabled global String parentElementId;
        @AuraEnabled global List<DRInfo> elementDR;
        @AuraEnabled global String className;
        @AuraEnabled global String classId;
        @AuraEnabled global Boolean elementStatus;
    }
    
    global class DRInfo {
        @AuraEnabled global String fieldName;
        @AuraEnabled global String objectName;
    }
}