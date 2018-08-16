global with sharing class Venkat_DeltaOrder implements vlocity_cmt.VlocityOpenInterface {


    /**
    *  DeltaOrder
    *  Author: Bill Coppens
    *  Method: CompareLineItems
    *  MethodDescription: Compare the line items. of an OrderId sent in.  It returns lists of new / deleted / change 
    **/
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        Boolean retval = false;

        if (methodName == 'CompareLineItems') {
            return compareLineItems(inputMap,outMap,options);
        }

        return retval;
    }

    /**
    * Compare and update the line items
    * Select the line items and the associated products.
    * use the product details to determine if there is a change is product, if they are the same products
    **/

    public Boolean CompareLineItems(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {

        Boolean retval = false;

        List<String> oiFields = vlocity_cmt.DBHelper.getFields('OrderItem');
        List<String> prodFields = vlocity_cmt.DBHelper.getFields('Product2');
        String orderId = (String)inputMap.get('OrderId');

        // Build the query for order items and ite product details for the order
        String soql = 'select ' + String.join(oiFields,',') + ', PricebookEntry.Product2.' 
                        + String.join(prodFields,',PricebookEntry.Product2.') 
                        + ' from OrderItem where orderId = :orderId';


        
        // set up the processing structure definition.
        List<OrderItem> newOI = new List<OrderItem>();
        List<OrderItem> oldOI = new List<OrderItem>();
        List<Map<String,OrderItem>> deltaOI = new List<Map<String,OrderItem>>();
        List<Map<String,OrderItem>> sameOI = new List<Map<String,OrderItem>>();
        List<OrderItem> removeOI = new List<OrderItem>();

       

        //outMap.put('soql',soql);  // A degug if needed.

        // Execute the query
        List<OrderItem> ois = database.query(soql);

        outmap.put('itemSize',ois.size());
        outMap.put('orderId',orderId);
        retval = true;

        // determine if the line item is net new in the order or if it was moved from assets.
        for (OrderItem oi : ois) {
            if (isNew(oi)) {
                newOI.add(oi);
            } else {
                oldOI.add(oi);      
//              oi.vlocity_cmt__Action__c       = 'Disconnect';
                // assume they will change as the default measure.
                oi.vlocity_cmt__SubAction__c    = 'Change';
            }
        }


        // perform a check to see if the line item should replace a previous OrderItem, or change the old OrderItem 
        for (OrderItem noi: newOI) {
            for (OrderItem ooi: oldOI) {
                if (compareLike(noi,ooi)) {

                    if (compareChange(noi,ooi)) {
                        Map<String,OrderItem> temp = new Map<String,OrderItem>();
                        temp.put('new',noi);
                        temp.put('old',ooi);
                        deltaOI.add(temp);
                        ooi.vlocity_cmt__ProvisioningStatus__c  = 'Deleted';
                        noi.vlocity_cmt__SubAction__c           = 'Change';
                    }

                    if (compareSame(noi,ooi)) {
                        Map<String,OrderItem> temp = new Map<String,OrderItem>();
                        temp.put('new',noi);
                        temp.put('old',ooi);
                        sameOI.add(temp);
                        ooi.vlocity_cmt__ProvisioningStatus__c  = 'Deleted';
                        noi.vlocity_cmt__SubAction__c           = 'Move';
                        noi.vlocity_cmt__AssetReferenceId__c    = ooi.vlocity_cmt__AssetReferenceId__c;
                        noi.vlocity_cmt__AssetId__c             = ooi.vlocity_cmt__AssetId__c;
                        noi.vlocity_cmt__JSONAttribute__c       = ooi.vlocity_cmt__JSONAttribute__c;
                        noi.vlocity_cmt__SerialNumber__c        = ooi.vlocity_cmt__SerialNumber__c;
                    }
                    break;
                }
            }
        }

        for (OrderItem ooi: oldOI) {
            for (OrderItem noi: newOI) {
                if (!compareChange(noi,ooi) && !compareSame(noi,ooi)) {
                    removeOI.add(ooi);
                }
            }
        }

        update ois;
        
         // Set up the return structure
        outmap.put('deltaItems',deltaOI);
        outmap.put('sameItems',sameOI);
        outmap.put('removeItems',removeOI);

        return retval;
        
        // If the same child product of the source plan is not present, then we need to delete that child product in the cart.
        // 
    }

    /**
    *  Check to see is the order item is new
    **/
    public Boolean isNew(OrderItem oi) {
        Boolean retval = false;

        if (oi.vlocity_cmt__Action__c != 'Existing') {
            retval = true;
        }

        return retval;
    }

    /**
    *  Compare the 2 orderItems.  Return true if it appears that they ar alike
    **/

    public Boolean comparelike(OrderItem newOI, OrderItem oldOI) {
        Boolean retval = false;
        if ((newOI.PricebookEntry.Product2.vlocity_cmt__Type__c == oldOI.PricebookEntry.Product2.vlocity_cmt__Type__c)
            && (newOI.PricebookEntry.Product2.Family == oldOI.PricebookEntry.Product2.Family)
        ) {
            retval = true;
        }
        return retval;
    }
    /**
    *  Compare the 2 orderItems.  Return true if it appears that the the new order item should
    *  replace the old order item.
    **/

    public Boolean compareChange(OrderItem newOI, OrderItem oldOI) {
        Boolean retval = false;
        if ((newOI.PricebookEntry.Product2.vlocity_cmt__Type__c == oldOI.PricebookEntry.Product2.vlocity_cmt__Type__c)
            && (newOI.PricebookEntry.Product2.Family == oldOI.PricebookEntry.Product2.Family)
            && (newOI.PricebookEntry.Product2.ProductCode != oldOI.PricebookEntry.Product2.ProductCode)
        ) {
            retval = true;
        }
        return retval;
    }

    /**
    *   Compare and see if the new order item is the same as the old and simply needs to 
    *   move the asset identifiers from the old order item to the new order item. 
    **/
    public Boolean compareSame(OrderItem newOI, OrderItem oldOI) {
        Boolean retval = false;
        if ((newOI.PricebookEntry.Product2.vlocity_cmt__Type__c == oldOI.PricebookEntry.Product2.vlocity_cmt__Type__c)
            && (newOI.PricebookEntry.Product2.Family == oldOI.PricebookEntry.Product2.Family)
            && (newOI.PricebookEntry.Product2.ProductCode == oldOI.PricebookEntry.Product2.ProductCode)
        ) {
            retval = true;
        }
        return retval;
    }
}