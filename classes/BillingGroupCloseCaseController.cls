global with sharing class BillingGroupCloseCaseController{
    global String algo{get; set; }

    @RemoteAction
    global static Boolean closeCase(String caseNumber){
        try
        {
            System.debug('El caseNumber es:' + caseNumber);
            Case selectedCase = [SELECT Id, CaseNumber, Status FROM Case WHERE CaseNumber = :caseNumber];
            selectedCase.Status = 'Cancelada';
            selectedCase.Resolution_Comment__c = 'El proceso fue cancelado.';
            update selectedCase;
            
            return true;
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
            return false;       
        }
        
    }

    @RemoteAction
    global static Map<String, Object> addLineItemToOrder(String orderId, String priceBookId, String productCode){
        try
        {
            System.debug('orderId:' + orderId);
            System.debug('priceBookEntryId:' + priceBookId);
            System.debug('productCode:' + productCode);

            Map<String, Object> input = GetInputJson(orderId, priceBookId, productCode);
            Map<String, Object> options = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();

            if(!Test.isRunningTest()){
                vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
                cpqAppHandler.invokeMethod('postCartsItems', input, output, options);
    
                System.debug('output: ' + output);
            }

            return output;
        }
        catch(Exception ex)
        {
            System.debug(ex.getMessage());
            throw ex;      
        }
    }

    private static Map<String, Object> GetInputJson(String orderId, String priceBookId, String productCode) {
        try {
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> item = new Map<String, Object>();
            List<Map<String, Object>> items = new List<Map<String, Object>>();

            PriceBookEntry priceBookEntry = [SELECT Id,
                                                    ProductCode,
                                                    Pricebook2Id
                                                FROM PriceBookEntry
                                                WHERE ProductCode = :productCode
                                                        AND Pricebook2Id = :priceBookId];
                                          
            item.put('itemId', priceBookEntry.Id);
            //item.put('itemId', '01u6C000000xL46QAE');
            
            items.add(item);

            input.put('cartId', orderId);
            input.put('items', items);

            return input;
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    
    global BillingGroupCloseCaseController(){
    
    }
}