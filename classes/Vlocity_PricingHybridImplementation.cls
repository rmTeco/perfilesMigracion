global with sharing class Vlocity_PricingHybridImplementation implements vlocity_cmt.GlobalInterfaces.PricingInterface, vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName,
                                Map<String, Object> input,
                                Map<String, Object> output,
                                Map<String, Object> options)
    {
        try
        {
            if (methodName == 'priceLineItems')
            {
                SObject parent = (SObject)input.get('parent');
                List<SObject> itemList = (List<SObject>)input.get('itemList');
                priceLineItems(parent, itemList);
                return true;
            }
            else
            {
                vlocity_cmt.VOIInvoker invokerService = vlocity_cmt.VOIInvoker.getInstance();
                invokerService.invoke('PricingDelegate', methodName, input, output, options);
                return true;
                
                //return (Boolean)invokerService.invoke('PricingElementServiceImplementation', methodName, input, output, options);
            }
        }
        catch (Exception ex)
        {
            System.debug(LoggingLevel.ERROR, ex);
            System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
            throw ex;
        }
    }

    global void priceLineItems(SObject parent, List<SObject> itemList) {
        if(itemList.isEmpty())return;
        vlocity_cmt.DefaultPricingImplementation defaultPricing = new vlocity_cmt.DefaultPricingImplementation();
        defaultPricing.priceLineItems(parent, itemList);
        
        // Invoke the pricing element service
        Map<String, Object> inputInvoker = new Map<String, Object>();
        inputInvoker.put('parent', parent);
        inputInvoker.put('itemList', itemList);
        Map<String, Object> outputInvoker = new Map<String, Object>();
        Map<String, Object> optionsInvoker = new Map<String, Object>();

        vlocity_cmt.VOIInvoker invokerService = vlocity_cmt.VOIInvoker.getInstance();
        invokerService.invoke('PricingDelegate', 'priceLineItems', inputInvoker, outputInvoker, optionsInvoker);
        
        String objectName = String.valueOf(itemList[0].getSObjectType());
        List<Id> ruleIds = new List<Id>();
        
        System.debug('objectNameDebug: ' + objectName);
        
        Map <String,Id> mapRules = new Map <String,Id>();
        
        for(vlocity_cmt__Rule__c rule : [SELECT Id, Name FROM vlocity_cmt__Rule__c WHERE vlocity_cmt__Type__c = 'Pricing' AND vlocity_cmt__ObjectName__c =: objectName AND vlocity_cmt__IsActive__c = true]){
            mapRules.put(rule.name,rule.id);
        }
        
        ruleIds.add(mapRules.get('OrderLineItem Customer Segment Waive Charges') );
        
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