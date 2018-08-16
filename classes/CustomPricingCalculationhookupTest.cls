@isTest
public class CustomPricingCalculationhookupTest {
    
    Testmethod static void preInvokemethodTest() {
            
            Product2 p1 = new Product2(Name='Medical PPO 200', Alicuota__c = '0.105');
            insert p1;
            
            // Create Price book and Price book entries
            Pricebook2 standardBook =  new Pricebook2(Id=Test.getStandardPricebookId(), Name = 'StandardPricebook', IsActive = true);
            
            Pricebook2 testPricebook = new Pricebook2(Name = 'TestPricebook', IsActive = true);
            insert testPricebook;
            
            // Create Pricebook entries
            PricebookEntry teststdpbEntry = new PricebookEntry(Pricebook2Id = standardBook.Id, Product2Id = p1.Id, UnitPrice = 10, IsActive = true, UseStandardPrice = false);
            insert teststdpbEntry;
            
            PricebookEntry testpbEntry1 = new PricebookEntry(Pricebook2Id = testPricebook.Id, Product2Id = p1.Id, UnitPrice = 11, IsActive = true, UseStandardPrice = false);
            insert testpbEntry1;
        
            Account testAccount = new Account();
            testAccount.Name = 'Test Account';
            insert testAccount;
            
            Order testOrder = new Order();
            testOrder.AccountId = testAccount.Id; 
            testOrder.Pricebook2Id = testPricebook.Id;
            testOrder.Name = 'TestOrderHeader';
            testOrder.EffectiveDate = system.today();
            testOrder.Status = 'Draft';
            testOrder.ShippingPostalCode = '94549';
            testOrder.ShippingState = 'NY';
            insert testOrder;
            
            
            
            OrderItem testOrderItem = new OrderItem(OrderId = testOrder.Id,vlocity_cmt__LineNumber__c = '0001',
                                                    PricebookEntryId = testpbEntry1.Id, Quantity = 2, UnitPrice = 22,vlocity_cmt__ProvisioningStatus__c = 'New', 
                                                    vlocity_cmt__RecurringManualDiscount__c=10, vlocity_cmt__OneTimeManualDiscount__c=10);
            
            
            
            
            insert testOrderItem;
            test.startTest();
            CustomPricingCalculationhookup CPricingHookup = new CustomPricingCalculationhookup();
            
            String methodName = 'calculate.PostInvoke';
            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped( '{"paymentMode": null,"itemId": "' + testOrderItem.id  +'", "isRoot": true, ' +
                                                                                      '"parentItemEffectiveQuantity": null, "pricingLogDataMap": {}, "pricingVariableMap": {"ROLLUP_OT_STD_PRC_TOTAL": 0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL": 55.00,' +
                                                                                      '"OT_STD_PRC_CALC": 0.00,"OT_STD_PRC": 0.00,"REC_MNTH_STD_PRC_DISC_PCT_MAN": 0.00,"OT_STD_PRC_DISC_PCT_MAN": 0.00, "LINE_QUANTITY": 1.00, "REC_MNTH_STD_PRC_TOTAL": 0.00,'+
                                                                                      '"REC_MNTH_STD_PRC_CALC": 0.00,"REC_MNTH_STD_PRC": 0.00,"OT_STD_PRC_TOTAL": 0.00}}');
            
            
            String outputStr = '{"pricingLogDataMap": { "OT_LTY_TOTAL": {"data": ["OT_LTY_TOTAL", "0.00","ROLLUP_OT_LTY_TOTAL", "0.00", "LINE_QUANTITY","1.00"], "format": "[{0} ({1}) + Rollup {2} ({3})] x {4} ({5})" },"REC_MNTH_STD_PRC_TOTAL": {'+
                '"data": ["REC_MNTH_STD_PRC_CALC", "0.00","REC_MNTH_STD_PRC_TOTAL","55.00","LINE_QUANTITY", "1.00"], "format": "[{0} ({1}) + Rollup {2} ({3})] x {4} ({5})"},' +
                '"REC_MNTH_STD_PRC_CALC": { "data": ["REC_MNTH_STD_PRC","0.00","REC_MNTH_STD_PRC_DISC_PCT_MAN","0.00"],"format": "{0} ({1}) - {2} ({3}%)"},' + 
                
                '"OT_STD_PRC_TOTAL": { "chargeTiming": "One-Time","data": ["OT_STD_PRC_CALC", "0.00","OT_STD_PRC_TOTAL", "0.00","LINE_QUANTITY","1.00"],"format": "[{0} ({1}) + Rollup {2} ({3})] x {4} ({5})"' + 
                '},"OT_STD_PRC_CALC": {"data": ["OT_STD_PRC","0.00","OT_STD_PRC_DISC_PCT_MAN","0.00"],"format": "{0} ({1}) - {2} ({3}%)"}},' +
                
                '"pricingVariableMap": {"DISP_OT_LTY": 0.00, "EFF_OT_LTY_TOTAL": 0.00,"ROLLUP_OT_LTY_TOTAL": 0.00,"OT_LTY_TOTAL": 0.00,"OT_LTY": 0.00, "EFFECTIVE_QUANTITY": 1.00,' + 
                
                '"DISP_OT_STD_PRC": 0.00,"EFF_REC_MNTH_STD_PRC_TOTAL": 55.00,"EFF_OT_STD_PRC_TOTAL": 0.00,"ROLLUP_OT_STD_PRC_TOTAL": 0.00,"ROLLUP_REC_MNTH_STD_PRC_TOTAL": 55.00,"OT_STD_PRC_CALC": 0.00,' + 
                
                '"OT_STD_PRC": 0.00, "ROLLUP_OT_STD_PRC_TOTAL_W_TAX": 12, "REC_MNTH_STD_PRC_DISC_PCT_MAN": "0.00", "ROLLUP_REC_MNTH_STD_PRC_TOTAL_W_TAX" : 0.09,"ROLLUP_REC_MNTH_STD_PRC_TOTAL_W_TAX": 0.12, "OT_STD_PRC_DISC_PCT_MAN": 0.00,"LINE_QUANTITY": 1.00, "REC_MNTH_STD_PRC_TOTAL": 55.00, "REC_MNTH_STD_PRC_CALC": 0.00,"REC_MNTH_STD_PRC": 0.00, "OT_STD_PRC_TOTAL": 0.00},'  + 
                
                '"errorCode": "INVOKE-200","error": "OK"}';
            
            
            Map<String, Object> output =(Map<String, Object>) JSON.deserializeUntyped(outputStr) ;
            Map<String, Object> options = new Map<String, Object> (); 
            
        CPricingHookup.invokemethod(methodName, input, output, options); 
       
        input.put('isRoot', false);
        CPricingHookup.invokemethod(methodName, input, output, options); 
         Test.stopTest();
        
    }

}