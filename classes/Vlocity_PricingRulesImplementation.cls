global with sharing class Vlocity_PricingRulesImplementation implements vlocity_cmt.GlobalInterfaces.PricingInterface {
    global void priceLineItems(SObject parent, List<SObject> itemList) {
        if(itemList.isEmpty())return;
        
        vlocity_cmt.DefaultPricingImplementation defaultPricing = new vlocity_cmt.DefaultPricingImplementation();
        defaultPricing.priceLineItems(parent, itemList);
       
        
        String objectName = String.valueOf(itemList[0].getSObjectType());
        List<Id> ruleIds = new List<Id>();
        
        System.debug('objectNameDebug: ' + objectName);
        
        Map <String,Id> mapRules = new Map <String,Id>();
        
        for(vlocity_cmt__Rule__c rule : [SELECT Id, Name FROM vlocity_cmt__Rule__c WHERE vlocity_cmt__Type__c = 'Pricing' AND vlocity_cmt__ObjectName__c =: objectName AND vlocity_cmt__IsActive__c = true]){
            mapRules.put(rule.name,rule.id);
        }
        
        ruleIds.add(mapRules.get('ORDER: MulitAttributeBasedPricing') );
        
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        input.put('ruleIdentifierType', 'Id');
        input.put('ruleIdentifiersList', ruleIds);
        
        vlocity_cmt.FlowStaticMap.flowMap.put('parent', parent);
        vlocity_cmt.FlowStaticMap.flowMap.put('itemList', itemList);
        input.put('isTriggeredByFlow', false);
        input.put('flowMap', vlocity_cmt.FlowStaticMap.flowMap);
        
        vlocity_cmt.RuleSupport ruleSupport = new vlocity_cmt.RuleSupport();
        RuleSupport.invokeMethod('executeRules',input, output, null);    
        
        System.debug('Done');   
           
    }
}