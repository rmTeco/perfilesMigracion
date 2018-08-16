global with sharing class PricingVariableMapHookImplementation implements vlocity_cmt.VlocityOpenInterface{
 
    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)  
    {
        try
        {
            //System.debug('____ PricingVariableMapHookImplementation ' + methodName);
            //System.debug('____ Input: ' + input);
            if (methodName.equalsIgnoreCase('calculate.PreInvoke'))
            {
                // dump the input
                //System.debug('--- calculate.PreInvoke input: ' + JSON.serialize(input));
            }
            else if (methodName.equalsIgnoreCase('calculate.PostInvoke'))
            {                
                // log the output
                //System.debug('--- calculate.PostInvoke output: ' + JSON.serialize(output));
                System.debug('Input: '+JSON.serialize(input));
                // Retrieve the pricing variable map from the output
                Map<String, Object> pricingVariableCodeToValueMap = (Map<String, Object>)output.get('pricingVariableMap');
                System.debug('pricingVariableCodeToValueMap: '+pricingVariableCodeToValueMap);
 
                // Retrieve the pricing log data map from the output
                Map<String, Object> pricingLogDataMap = (Map<String, Object>)output.get('pricingLogDataMap');
 
                // Retrieve the isRoot flag from the input
                Boolean isRoot = (Boolean)input.get('isRoot');
 
                // Apply Warranty discount and adjust OT_STD_PRC_TOTAL
 
               // Get the LINE_QUANTITY pricing variable value
                Decimal LINE_QUANTITY = (Decimal)pricingVariableCodeToValueMap.get('LINE_QUANTITY');
 
               // Get the OT_STD_PRC pricing variable value
                Decimal OT_STD_PRC = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC');
 
                // Get the OT_STD_PRC_CALC pricing variable value
                Decimal OT_STD_PRC_CALC = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC_CALC');
 
               // Get the OT_STD_PRC_DISC_PCT_MAN pricing variable value
                Decimal OT_STD_PRC_DISC_PCT_MAN = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC_DISC_PCT_MAN');
 
                // Get the OT_STD_PRC_TOTAL pricing variable value
                Decimal OT_STD_PRC_TOTAL = (Decimal)pricingVariableCodeToValueMap.get('OT_STD_PRC_TOTAL');
                
               // Set the Warranty Disc amount from the line in cart having Product2.Product Family = ‘Movil’ AND Product2.Type = ‘Dispositivo’ and OrderItem.Action = ‘Disconnect’
    
                Decimal WarrantyDis = 0.00;
 
                //System.debug('--- WarrantyDis:'+WarrantyDis);
               
                String itemID = (String)input.get('itemId');
                OrderItem originOrderItem = new OrderItem();
                OrderItem finalOrderItem = new OrderItem();
                originOrderItem = [SELECT id, OrderId, Product2Id FROM OrderItem WHERE id =: ItemID];
                //We search for the Subgama value of the original item
                vlocity_cmt__AttributeAssignment__c origAttrAssg = [SELECT vlocity_cmt__Value__c FROM vlocity_cmt__AttributeAssignment__c  WHERE vlocity_cmt__AttributeDisplayNameOverride__c = 'Subgama Equipo' AND vlocity_cmt__ObjectId__c =: originOrderItem.Product2Id];
                vlocity_cmt__PicklistValue__c origPickSeq = [SELECT vlocity_cmt__Sequence__c FROM vlocity_cmt__PicklistValue__c WHERE vlocity_cmt__Value__c =: origAttrAssg.vlocity_cmt__Value__c];
                vlocity_cmt__PicklistValue__c finalPickSeq;
                //
                Order selectedOrder = new Order();
                selectedOrder = [SELECT Gestion__c, Id FROM Order WHERE Id =: originOrderItem.OrderId];
                if(selectedOrder.Gestion__c=='Cambio en Garantia'){
                    List <OrderItem> orderItems = new List <OrderItem>();
                    orderItems = [SELECT id, OrderId, Product2Id  FROM OrderItem WHERE OrderId =: selectedOrder.id];
                    for (orderItem item : orderItems){
                        if (item.id != ItemID){
                            finalOrderItem = item;
                        }
                    }
                    List <vlocity_cmt__PriceListEntry__c> priceListEntries = new List <vlocity_cmt__PriceListEntry__c>();
                    priceListEntries = [SELECT vlocity_cmt__IsBasePrice__c,vlocity_cmt__ProductId__c,Price_Amount__c, vlocity_cmt__IsActive__c, Pricing_Variable_Code__c, vlocity_cmt__EffectiveFromDate__c, vlocity_cmt__EffectiveUntilDate__c FROM vlocity_cmt__PriceListEntry__c WHERE vlocity_cmt__IsBasePrice__c = true AND vlocity_cmt__ProductId__c =: finalOrderItem.Product2Id AND vlocity_cmt__IsActive__c = true AND Pricing_Variable_Code__c = 'OT_STD_PRC' AND vlocity_cmt__EffectiveFromDate__c < TODAY AND (vlocity_cmt__EffectiveUntilDate__c > TODAY OR vlocity_cmt__EffectiveUntilDate__c = null)];
                    //We search for the Subgama value of the final item
                    vlocity_cmt__AttributeAssignment__c finalAttrAssg = [SELECT vlocity_cmt__Value__c FROM vlocity_cmt__AttributeAssignment__c  WHERE vlocity_cmt__AttributeDisplayNameOverride__c = 'Subgama Equipo' AND vlocity_cmt__ObjectId__c =: finalOrderItem.Product2Id];
                    finalPickSeq = [SELECT vlocity_cmt__Sequence__c FROM vlocity_cmt__PicklistValue__c WHERE vlocity_cmt__TextValue__c =: finalAttrAssg.vlocity_cmt__Value__c];

                    if(priceListEntries.size()>0){
                        vlocity_cmt__PriceListEntry__c plEntry = new vlocity_cmt__PriceListEntry__c();
                        plEntry = priceListEntries[0];
                        WarrantyDis = plEntry.Price_Amount__c;
                        System.debug('WarrantyDis: '+WarrantyDis);
                    }
          
                if((OT_STD_PRC - (OT_STD_PRC * OT_STD_PRC_DISC_PCT_MAN / 100) - WarrantyDis<0) || (finalPickSeq.vlocity_cmt__Sequence__c <= origPickSeq.vlocity_cmt__Sequence__c)){
                    //pricingVariableCodeToValueMap.put('OT_STD_PRC_DISC_PCT_MAN',OT_STD_PRC);
                    System.debug('Entro en el put');                    
                    finalOrderItem.put('vlocity_cmt__OneTimeManualDiscount__c', OT_STD_PRC);
                    //OT_STD_PRC_CALC = 0;
                }else{
                    OT_STD_PRC_CALC = OT_STD_PRC - (OT_STD_PRC * OT_STD_PRC_DISC_PCT_MAN / 100) - WarrantyDis;}
                }else{
                    OT_STD_PRC_CALC = OT_STD_PRC - (OT_STD_PRC * OT_STD_PRC_DISC_PCT_MAN / 100);
                }

                // Override the default calculation formula. The formula being overridden is:
 
                // OT_STD_PRC_CALC = OT_STD_PRC - (OT_STD_PRC * OT_STD_PRC_DISC_PCT_MAN / 100)
 
                // Get the ROLLUP_OT_MNTH_STD_PRC_TOTAL pricing variable value
                Decimal ROLLUP_OT_STD_PRC_TOTAL = (Decimal)pricingVariableCodeToValueMap.get('ROLLUP_OT_STD_PRC_TOTAL');
 
                // Calculate line level total
                OT_STD_PRC_TOTAL = (OT_STD_PRC_CALC + ROLLUP_OT_STD_PRC_TOTAL) * LINE_QUANTITY;
               
                // Save the new OT_STD_PRC_TOTAL rounded to 2 decimals in the pricing variable map of the line item
                pricingVariableCodeToValueMap.put('OT_STD_PRC_TOTAL', OT_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));
 
                // Set the new pricing details information for the OT_STD_PRC_TOTAL
                pricingLogDataMap.put('OT_STD_PRC_TOTAL',
                    new Map<String, Object>{
                        'format'=>'[{0} ({1}) x {2} ({3})] + Rollup {4} ({5})',
                        'data'=>new List<String>{'OT_STD_PRC_CALC',                      // replaces {0}
                                                  String.valueOf(OT_STD_PRC_CALC),       // replaces {1}
                                                 'LINE_QUANTITY',                        // replaces {2}
                                                 String.valueOf(LINE_QUANTITY),          // replaces {3}
                                                 'OT_STD_PRC_TOTAL',                     // replaces {4}
                                                 String.valueOf(ROLLUP_OT_STD_PRC_TOTAL) // replaces {5}
                                             }});
 
                // If this is the root, then set the EFF_OT_STD_PRC_TOTAL of the line item to be the same as
                // OT_STD_PRC_TOTAL value. EFF_OT_STD_PRC_TOTAL participates in a rollup summary field in the parent header
                if (isRoot)
                {
                    Decimal EFF_OT_STD_PRC_TOTAL = 0;
                    pricingVariableCodeToValueMap.put('EFF_OT_STD_PRC_TOTAL', EFF_OT_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));
                }
                System.debug('Output: '+JSON.serialize(output));
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