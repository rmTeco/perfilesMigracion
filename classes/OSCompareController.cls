global with sharing class OSCompareController {
    
    @AuraEnabled
    public static List<vlocity_cmt__OmniScript__c> OSList(){
        List<vlocity_cmt__OmniScript__c> omniscriptList = [SELECT Id, Name, vlocity_cmt__Version__c 
                                                           FROM vlocity_cmt__OmniScript__c 
                                                           ORDER BY Name, vlocity_cmt__Version__c DESC];
        return omniscriptList;
    }
    
    @AuraEnabled
    public static List<vlocity_cmt__Element__c> OSElement(String omniscriptId){
        List<vlocity_cmt__Element__c> elementList = [SELECT Id, Name, vlocity_cmt__OmniScriptId__r.vlocity_cmt__Version__c, vlocity_cmt__Active__c, vlocity_cmt__InternalNotes__c,
                                                     vlocity_cmt__Level__c, vlocity_cmt__Order__c, vlocity_cmt__ParentElementId__c,
                                                     vlocity_cmt__ParentElementName__c, vlocity_cmt__ParentElementType__c,
                                                     vlocity_cmt__PropertySet__c, vlocity_cmt__ReusableOmniScript__c,
                                                     vlocity_cmt__SearchKey__c, vlocity_cmt__Type__c, CreatedDate, CreatedBy.Name
                                                     FROM vlocity_cmt__Element__c 
                                                     WHERE vlocity_cmt__OmniScriptId__c = :omniscriptId
                                                     ORDER BY vlocity_cmt__Order__c];
        return elementList;
    }
}