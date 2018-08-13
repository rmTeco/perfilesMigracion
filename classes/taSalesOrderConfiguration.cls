global with sharing class taSalesOrderConfiguration implements vlocity_cmt.VlocityOpenInterface{

    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

        if(methodName.equals('getBillingCycleByDeliveryMethod')){
            getBillingCycleByDeliveryMethod(inputMap, outMap);
        }

        return true;
    }
    
    public void getBillingCycleByDeliveryMethod(Map<String, Object> inputMap, Map<String, Object> outMap)
    {
        System.debug('inputMap: ' + inputMap);
        Integer deliveryDefaultBillingCycle = (Integer) inputMap.get('DeliveryDefaultBillingCycle');
        System.debug('deliveryDefaultBillingCycle: ' + deliveryDefaultBillingCycle);
        
        String deliveryMethod = null;
        Map<String, Object> billingOrder = new Map<String, Object>();
        billingOrder = (Map<String, Object>) inputMap.get('BillingOrder');
        System.debug('billingOrder: ' + billingOrder);
        deliveryMethod = (String) billingOrder.get('Delivery_Method');
        System.debug('deliveryMethod: ' + deliveryMethod);

        List<Map<String, String>> options = new List<Map<String, String>>();
        Schema.DescribeFieldResult fieldResult = Order.Billing_Cycles__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        if(deliveryMethod == 'Delivery')
        {
            for(Schema.PicklistEntry f : ple)
            {
                if(f.value == String.valueOf(deliveryDefaultBillingCycle))
                {
                    Map <String, String> tempMap = new Map<String, String>();
                    tempMap.put('name', f.getValue());
                    tempMap.put('value', f.getLabel());
                    options.add(tempMap);
                }
            }
        }
        else
        {
            for(Schema.PicklistEntry f : ple)
            {
                Map <String, String> tempMap = new Map<String, String>();
                tempMap.put('name', f.getValue());
                tempMap.put('value', f.getLabel());
                options.add(tempMap);
            }
        }
        outMap.put('options', options);
    }
}