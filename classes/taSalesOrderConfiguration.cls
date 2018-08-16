global with sharing class taSalesOrderConfiguration implements vlocity_cmt.VlocityOpenInterface{

    public boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result;
        try {
            if(methodName.equals('getBillingCycleByDeliveryMethod')) {
                getBillingCycleByDeliveryMethod(inputMap, outMap);
            }

            if(methodName.equals('getDeliveryMethodByProduct')) {
                getDeliveryMethodByProduct(inputMap, outMap, options);
            }

            result = true;
        }
        catch(Exception e) {
            System.debug('taSalesOrderConfiguration:invokeMethod -> exception: ' + e);
            throw e;
            result = false;
        }

        return result;
    }
    
    public void getBillingCycleByDeliveryMethod(Map<String, Object> inputMap, Map<String, Object> outMap) {
        Integer deliveryDefaultBillingCycle = (Integer) inputMap.get('DeliveryDefaultBillingCycle');
        
        String deliveryMethod = null;
        Map<String, Object> billingOrder = new Map<String, Object>();
        billingOrder = (Map<String, Object>) inputMap.get('BillingOrder');
        deliveryMethod = (String) billingOrder.get('Delivery_Method');

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

    void getDeliveryMethodByProduct(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            System.debug('getDeliveryMethodByProduct');
            String orderId = (String) options.get('orderId');
            System.debug('orderId: ' + orderId);
            String tipoEnvio;

            Product2 productEnvio = [SELECT Id
                                       FROM Product2
                                      WHERE ProductCode = 'FAN_ENV_000'
                                        AND IsActive = true];

            OrderItem oiEnvio = [SELECT Id
                                   FROM OrderItem
                                  WHERE OrderId = :orderId
                                    AND vlocity_cmt__Product2Id__c = :productEnvio.Id];

            if(oiEnvio != null) {
                OrderItem oiTipoEnvio = [SELECT Id,
                                                ProductCode__c,
                                                ProductName__c
                                           FROM OrderItem
                                          WHERE OrderId = :orderId
                                            AND vlocity_cmt__ParentItemId__c = :oiEnvio.Id];

                if(oiTipoEnvio != null) {
                    switch on oiTipoEnvio.ProductCode__c {
                        when 'FAN_ENV_001' {
                            tipoEnvio = 'Standard';
                        }	
                        when 'FAN_ENV_002' {
                            tipoEnvio = 'Express';
                        }
                        when 'FAN_ENV_003' {
                            tipoEnvio = 'Retiro';
                        }
                        when else {
                            tipoEnvio = 'Error producto envio';
                        }
                    }
                }
            }
            System.debug('tipoEnvio: ' + tipoEnvio);
            outMap.put('tipoEnvio', tipoEnvio);
        }
        catch (Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
}