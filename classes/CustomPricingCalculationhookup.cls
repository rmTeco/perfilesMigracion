global with sharing class CustomPricingCalculationhookup implements vlocity_cmt.VlocityOpenInterface{

    String CHARGE_CODE = 'Charge Code';
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)  
    {
        try
        {
            if (methodName.equalsIgnoreCase('calculate.PreInvoke'))
            {
                // dump the input
                //System.debug('--- calculate.PreInvoke input: ' + JSON.serialize(input));
            }
            else if (methodName.equalsIgnoreCase('calculate.PostInvoke'))
            {                
                Map<String, Object> pricingVariableCodeToValueMap = (Map<String, Object>)output.get('pricingVariableMap');
              
                
                // Retrieve the isRoot flag from the input
                Boolean isRoot = (Boolean)input.get('isRoot');
                
                try{
                    Map<Id, Map<String, Object>> priceVarMap = vlocity_cmt.PricingPlanService.getLineItemPricingVariableValues();
                    List<Sobject> itemList = (List<SObject>)vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');
                     OrderItem ItemwithTaxRate = [SELECT id,product2.Alicuota__c FROM OrderItem Where id =: (String)input.get('itemId')];
                    
                              
                    Decimal TAX_RATE = Decimal.valueOf(ItemwithTaxRate.product2.Alicuota__c); 
                    
                    Decimal OT_STD_PRC = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC');
                    Decimal OT_STD_PRC_CALC =  (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC_CALC');
                    Decimal REC_MNTH_STD_PRC = (Decimal)pricingVariableCodeToValueMap.get('REC_MNTH_STD_PRC');
                    Decimal REC_MNTH_STD_PRC_CALC = (Decimal)pricingVariableCodeToValueMap.get('REC_MNTH_STD_PRC_CALC');
                    
                    pricingVariableCodeToValueMap.put('OT_STD_PRC_W_TAX', OT_STD_PRC * (1 + TAX_RATE));
                    pricingVariableCodeToValueMap.put('OT_STD_PRC_CALC_W_TAX',OT_STD_PRC_CALC * (1 + TAX_RATE));
                    pricingVariableCodeToValueMap.put('REC_MNTH_STD_PRC_W_TAX', REC_MNTH_STD_PRC * (1 + TAX_RATE));
                    pricingVariableCodeToValueMap.put('REC_MNTH_STD_PRC_CALC_W_TAX', REC_MNTH_STD_PRC_CALC * (1 + TAX_RATE));
                    
                    Decimal OT_STD_PRC_CALC_W_TAX = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC_CALC_W_TAX');
                    Decimal ROLLUP_OT_STD_PRC_TOTAL_W_TAX =  (Decimal)pricingVariableCodeToValueMap.get('ROLLUP_OT_STD_PRC_TOTAL_W_TAX');
                    Decimal REC_MNTH_STD_PRC_CALC_W_TAX = (Decimal)pricingVariableCodeToValueMap.get('REC_MNTH_STD_PRC_CALC_W_TAX');
                    Decimal LINE_QUANTITY = (Decimal)pricingVariableCodeToValueMap.get('LINE_QUANTITY');
                    Decimal ROLLUP_REC_MNTH_STD_PRC_TOTAL_W_TAX = (Decimal)pricingVariableCodeToValueMap.get('ROLLUP_REC_MNTH_STD_PRC_TOTAL_W_TAX');
                    
                    
                    Decimal OT_STD_PRC_TOTAL_W_TAX  = (OT_STD_PRC_CALC_W_TAX + ROLLUP_OT_STD_PRC_TOTAL_W_TAX) * LINE_QUANTITY;
                    pricingVariableCodeToValueMap.put('OT_STD_PRC_TOTAL_W_TAX', OT_STD_PRC_TOTAL_W_TAX);
                    if (isRoot ) {
                        pricingVariableCodeToValueMap.put('EFF_OT_STD_PRC_TOTAL_W_TAX',  OT_STD_PRC_TOTAL_W_TAX  );
                    }
                    else {
                        pricingVariableCodeToValueMap.put('EFF_OT_STD_PRC_TOTAL_W_TAX',  0  );
                    }
                    Decimal REC_MNTH_STD_PRC_TOTAL_W_TAX = (REC_MNTH_STD_PRC_CALC_W_TAX + ROLLUP_REC_MNTH_STD_PRC_TOTAL_W_TAX) * LINE_QUANTITY;  
                    pricingVariableCodeToValueMap.put('REC_MNTH_STD_PRC_TOTAL_W_TAX', REC_MNTH_STD_PRC_TOTAL_W_TAX); 
                    if (isRoot ) {
                        pricingVariableCodeToValueMap.put('EFF_REC_MNTH_STD_PRC_TOTAL_W_TAX', REC_MNTH_STD_PRC_TOTAL_W_TAX);
                    }
                    else {
                        pricingVariableCodeToValueMap.put('EFF_REC_MNTH_STD_PRC_TOTAL_W_TAX', 0);
                    }
                }
           catch(Exception ex)
        {
            System.debug(LoggingLevel.ERROR, ex);
            System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
            throw ex;
        }                  
            }
            return true;
        }
        catch (Exception ex)
        {
            System.debug('--- Exception: ' + ex.getMessage());
            System.debug('--- Stack Trace: ' + ex.getStackTraceString());
            throw ex;
        }
    }
    
   
}