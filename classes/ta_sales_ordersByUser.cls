global with sharing class ta_sales_ordersByUser implements vlocity_cmt.VlocityOpenInterface{
  
    public Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        
        if(methodName.equals('getOrderList')){
            getOrderList(input, outMap, options);
        }

        return true;
    }
    
    private void getOrderList(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        
        String ownerId = (String) input.get('OwnerId');
        
        List<Map<String, Object>> retList = new List<Map<String, Object>>();
        
        Integer count = 0; //Inicializo contador de ordenes
        
        for(Order selOrder : [SELECT Id,
                                     OrderNumber,
                                     Account.Name,
                                     Account.Id,
                                     Account.RecordTypeId,
                                     Status, 
                                     vlocity_cmt__OriginatingChannel__c, 
                                     CreatedDate, 
                                     LastModifiedDate  
                                FROM Order
                               WHERE OwnerId = :ownerId
                               ORDER BY CreatedDate DESC
                               LIMIT 50]){ //Este límite existe porque no hay paginado. TODO: Paginado
            
            String existsInitOS = 'No'; //Inicializo existencia de instancia previa del OS
            String prevInstanceId = ''; //Inicializo id de instancia previa del OS
            String relativeUrl = '';
            count++; //Cuento las ordenes
            
            if(selOrder.Status == 'Draft'){
                List<vlocity_cmt__OmniScriptInstance__c> prevInstances = [SELECT Id, vlocity_cmt__ResumeLink__c
                                                                           FROM vlocity_cmt__OmniScriptInstance__c
                                                                          WHERE OwnerId = :ownerId
                                                                            AND vlocity_cmt__ObjectType__c = 'Order'
                                                                            AND vlocity_cmt__ObjectId__c = :selOrder.Id];

                if(prevInstances.size() > 0){
                    existsInitOS = 'Si';

                    prevInstanceId = prevInstances[0].Id;
                }
            }
            
            Map<String, Object> tempAcc = new Map<String, Object>();
            
            tempAcc.put('Name', selOrder.Account.Name);
            tempAcc.put('Id', selOrder.AccountId);
            tempAcc.put('RecordTypeId', selOrder.Account.RecordTypeId);
            
            Map<String, Object> tempMap = new Map<String, Object>();
            
            tempMap.put('Id', String.ValueOf(selOrder.Id).Substring(0, String.ValueOf(selOrder.Id).Length()-3));
            tempMap.put('OrderNumber', selOrder.OrderNumber);
            tempMap.put('AccountId', selOrder.AccountId);
            tempMap.put('Status', selOrder.Status);
            tempMap.put('vlocity_cmt__OriginatingChannel__c', selOrder.vlocity_cmt__OriginatingChannel__c);
            tempMap.put('CreatedDate', selOrder.CreatedDate);
            tempMap.put('LastModifiedDate', selOrder.LastModifiedDate);
            tempMap.put('PrevInstanceExists', existsInitOS);
            tempMap.put('PrevInstanceId', prevInstanceId);
            tempMap.put('Account', tempAcc);
            
            retList.add(tempMap);
        }
        
        outMap.put('list', retList);
        outMap.put('count', count);
    }
}