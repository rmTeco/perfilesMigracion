global with sharing class taSalesRepeatedFailures implements vlocity_cmt.VlocityOpenInterface
{
    global static Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try{
            if (methodName.equals('RepeatedFailures')){
                outMap.put('RepeatedFailures', RepeatedFailures(options));
            }else{
                result = false;
            }  
        }
        catch(Exception e){
            System.debug('invokeMethod -> exception: '+e);
            throw e;
        }
        return result;
    }
    private static Boolean RepeatedFailures(Map<String,Object> options){
    try{
        Boolean result = false;
        Id assetId = (Id) options.get('assetId');
        List<Case> casos =  getClosedCasesbyAssetId(assetId);
        List<OrderItem> items = getOrderItemsInCases(casos);
        
        Decimal amount = RepeatedFailures__c.getInstance('Failures').Number_Failures__c;

        System.debug('limit items: ' + amount);
        Map<String,Integer> counts = new Map<String,Integer>();

        for (OrderItem i: items){
            if (counts.containsKey(i.ProductName__c)){
                counts.put(i.ProductName__c, counts.get(i.ProductName__c)+1);
            }else{
                counts.put(i.ProductName__c, 1);                
            }
            System.debug('count: ' + i.ProductName__c +' '+ counts.get(i.ProductName__c));
        }
        for (String key : counts.keySet()) {
            result = result || (counts.get(key) >= amount);
        }
        return result;

        }catch(Exception e){
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    
    //Returns list ofTechnical Service cases with status 'Resuelta Exitosa' 
    private static List<Case> getClosedCasesbyAssetId(String assetId) {
        String tsRecordType = '';
        RecordType recordType = [SELECT Id FROM RecordType where SobjectType = 'Case' And Name = 'Technical Service'];
        if (recordType != null)
            tsRecordType= recordType.Id;

        List<Case> casesList = [SELECT Order__c 
                                FROM Case
                                WHERE AssetId = :assetId
                                And recordTypeId = :tsRecordType
                                And Status = 'Resuelta exitosa'];
        return casesList;
    }

    //Return list of orders Items in list of cases
    private static List<OrderItem> getOrderItemsInCases(List<Case> casos) {
        
        List<String> ordersIds = new List<String>();
        
        for (Case c : casos)
            ordersIds.add(c.Order__c);
        List<OrderItem> items = [SELECT Id, ProductName__c from OrderItem where OrderId in :ordersIds And ProductName__c != 'Actualización de Soft' And ProductName__c != 'No verifica falla'];
        return items;
    }
}