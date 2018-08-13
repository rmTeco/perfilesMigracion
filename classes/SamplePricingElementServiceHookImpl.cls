/* This class is used as a sample hook implementation to the PricingElementServiceImplementation.
* To use this class, create a PricingElementServiceImplementationH interface under All Tabs > Interface Implementations
* and set SamplePricingElementServiceHookImpl as the default and active implementation class. The invokeMethod of this
* hook class will be called both before and after the invokeMethod of the PricingElementServiceImplementation.
* The methods will be suffixed with PreInvoke and PostInvoke respectively to indicate whether it is being called before
* or after the PricingElementServiceImplementation method.
*/
 
global with sharing class SamplePricingElementServiceHookImpl implements vlocity_cmt.VlocityOpenInterface{
 
   global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
 

       try
       {
          System.debug('--- SamplePricingElementServiceHookImpl methodName: ' + methodName);
          if (methodName.equalsIgnoreCase('priceLineItems.PreInvoke'))
          {
             priceLineItemsPreInvoke(input, output,options);
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
    private void priceLineItemsPreInvoke(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {

        SObject parent = (SObject)input.get('parent');
        String parentObjName;
        String parentId;
        if (parent != null) {
            parentId = String.valueOf(parent.Id);
            //either Quote/Order or Opportunity
            parentObjName = parent.getSObjectType().getDescribe().getName();
        }
        List<SObject> itemList = (List<SObject>)input.get('itemList');
        //System.debug('--- priceLineItemsPreInvoke parent: ' + JSON.serialize(parent));
        //System.debug('--- priceLineItemsPreInvoke itemList: ' + JSON.serialize(itemList));
        
        String cartAction = (String)input.get('cartAction');
        
        // Only execute when cartAction is adding items to the cart
        //Ankit - Commented the if condition as the reprice is required for UpdateCartItem
        //if (cartAction != 'AddCartItem' && cartAction != 'AddCartPromotionItem') return;
        
        // collect the items by product names we want to set external prices for
        Set<String> prodNames = new Set<String>{'<<Your Set of Products>>'};
        Map<String, List<SObject>> productNameToItemObjs = new Map<String, List<SObject>>();
        for (SObject item : itemList)
        {
            string prodName = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('Name');
            System.debug('ProdName --'+prodName);
            System.debug('prodNames --' +prodNames);
            if (prodNames.contains(prodName))
            {
                List<SObject> itemObjList = productNameToItemObjs.get(prodName);
                if (itemObjList == null)
                {
                    itemObjList = new List<SObject>();
                    productNameToItemObjs.put(prodName, itemObjList);
                }
                itemObjList.add(item);
            }
        }

        // simulate external prices
        Type t = Type.forName('vlocity_cmt.SetCartItemExternalPriceService');
        System.debug(t);
        if (t != null)
        {   
            vlocity_cmt.VlocityOpenInterface externalPriceService = (vlocity_cmt.VlocityOpenInterface)t.newInstance();
            Map<String, Object> externalPriceServiceInput = new Map<String, Object>();
            Map<String, Object> externalPriceServiceOutput = new Map<String, Object>();
            Map<String, Object> externalPriceServiceOptions = new Map<String, Object>();
            Map<String, Object> itemFields = new Map<String, Object>();
            for (String productName : productNameToItemObjs.keySet()){

                List<SObject> itemObjList = productNameToItemObjs.get(productName);
                if (itemObjList != null)
                {
                    for (SObject itemObj : itemObjList)
                    {
                        Map<String, Object> itemFieldDetails = new Map<String, Object>();
                        Map<String, Object> matrixInput = new Map<String, Object>();
                        matrixInput.put('parentId', parentId);
                        matrixInput.put('parentObjName', parentObjName);
                        matrixInput.put('itemId', String.valueOf(itemObj.Id));
                        
                        Map<String, Object> matrixOutput = lookupPricesFromMatrix('Device_Pricing_Procedure' , matrixInput);
                        
                        Map<String, Object> fieldVals = new Map<String, Object>();
                        fieldVals.put('value', Decimal.ValueOf((String)matrixOutput.get('MRC')));
                        fieldVals.put('detail', 'Priced from Matrix');
                        itemFieldDetails.put('vlocity_cmt__RecurringCharge__c', fieldVals);
                        fieldVals = new Map<String, Object>();
                        fieldVals.put('value', Decimal.ValueOf((String)matrixOutput.get('NRC')));
                        fieldVals.put('detail', 'Priced from Matrix');
                        itemFieldDetails.put('vlocity_cmt__OneTimeCharge__c', fieldVals);
                        itemFields.put(String.valueOf(itemObj.Id), itemFieldDetails);
                        
                    }
                }
            }
        
            if (!itemFields.isEmpty())
            {
                externalPriceServiceInput.put('parent', parent);
                externalPriceServiceInput.put('itemList', itemList);
                externalPriceServiceInput.put('itemFieldsInfo', itemFields);
                //System.debug('--- setExternalPrices externalPriceServiceInput: ' + JSON.serialize(externalPriceServiceInput));
                externalPriceService.invokeMethod('setItemPrices', externalPriceServiceInput, externalPriceServiceOutput, externalPriceServiceOptions);
            }
        } 
    }
    private Map<String, Object> lookupPricesFromMatrix(String matrixName, Map<String, Object> matrixData){

        // We need to construct the matrix calculaytion service
        Type t = Type.forName('vlocity_cmt.PricingMatrixCalculationService');
        vlocity_cmt.VlocityOpenInterface matrixService = (vlocity_cmt.VlocityOpenInterface)t.newInstance();
       
        List<String> tempList = new List<String>();
        tempList.add('Dummy');
        Map<String, Object> matrixOutput = new Map<String, Object>();
        Map<String, Object> matrixOptions = new Map<String, Object>{
            'configurationName' => matrixName, // String procedureName = 'TestCalculationProcedure'   
            'mode' => null,
            'verbose' => true,
            'matchInputVariables' => true,
            'effectiveDate' => String.valueOf(System.Now()),
            'configurationVersionId' => null, // Set the matrix version id. Null version id picks the latest version with highest priority
            'sourceObjectIds' => tempList //Dummy input to Preprocessor, calculation procedure does not get saved without this input.
        };
        Map<String, Object> matrixInput = new Map<String, Object>{
            'input' => matrixData
        };   
        // invoke the matrix lookup
        matrixService.invokeMethod('calculate', matrixInput, matrixOutput, matrixOptions);
        //Parse the calculation procedure response
        List<Object> outList = (List<Object>)matrixOutput.get('output');
        List<Object> objectList;
        if (outList != null && !outList.isEmpty()) {
            vlocity_cmt.PricingCalculationService.CalculationProcedureResults calcProcResults = (vlocity_cmt.PricingCalculationService.CalculationProcedureResults)outList[0];
            objectList = calcProcResults.calculationResults;                      
        }
        Map<String, Object> matrixResult = new Map<String, Object>();                
        for (Object obj : objectList) {
                            
            // This is a row in the calculation procedure output
            Map<String, Object> row = (Map<String, Object>)obj;
           // String incomingMatrix = 'MultiAttribute_Device_Pricing_Matrix';
            string incomingMatrix = [select vlocity_cmt__CalculationMatrixId__r.Name from vlocity_cmt__CalculationProcedureStep__c  where vlocity_cmt__CalculationProcedureVersionId__r.vlocity_cmt__CalculationProcedureId__r.Name=:matrixName limit 1].vlocity_cmt__CalculationMatrixId__r.Name;
            matrixResult.put('MRC', row.get(incomingMatrix+'__MRC'));
            matrixResult.put('NRC', row.get(incomingMatrix+'__NRC'));
        }
        // return the output
        return matrixResult;
    }
}