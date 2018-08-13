global with sharing class AssetUtils implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        
        try {
            if (methodName.Equals('getNegotiations')) {
                getNegotiations(inputMap, outMap, options);
            }            
        }
        catch(Exception ex) {
            outMap.put('error', ex.getStackTraceString());
            result = false;
        }
        return result;
    }
    
    public List<OrderItem> getOrdersByAsset(String assetId) {
        
        List<OrderItem> orderItemList = [SELECT Id,OrderId, Order.OrderNumber, Order.Name, toLabel(Order.Status), Order.CreatedDate
                                         FROM OrderItem 
                                         WHERE vlocity_cmt__AssetId__c = :assetId
                                         ORDER BY Order.CreatedDate DESC];
        return orderItemList;
    }
    
    public List<Case> getCasesByAsset(String assetId) {
        List<Case> casesList = [SELECT AssetId,CaseNumber,CreatedDate,Id,toLabel(Status),Subject 
                                FROM Case
                                WHERE AssetId = :assetId
                                ORDER BY CreatedDate DESC];
        return casesList;
    }

    public static Order getOrderByAsset(String assetId){
        Asset asset = [SELECT vlocity_cmt__OrderProductId__r.OrderId FROM Asset WHERE Id = :assetId LIMIT 1];
        System.debug(asset);
        Order order = [SELECT Id, OriginStoreLocation__c, CreatedDate, DeliveryDate__c, Delivery_Method__c, vlocity_cmt__OriginatingChannel__c
                         FROM Order
                        WHERE Id = : asset.vlocity_cmt__OrderProductId__r.OrderId];
        return order;
    }
    
    void getNegotiations(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        AssetsMinimalDateFilter__c assetFilterDate = AssetsMinimalDateFilter__c.getValues('FilterDate');
        outMap.put('AssetMinDate',assetFilterDate.AssetMinDate__c);
        
        List<Negotiation> negList = new List<Negotiation>();
        if (inputMap.containsKey('Id')) {
            system.debug('if');
            String assetId = (String)inputMap.get('Id');
            List<OrderItem> orderItemList = getOrdersByAsset(assetId);
            List<Case> casesList = getCasesByAsset(assetId);
            for (OrderItem item : orderItemList){
                Negotiation negItem = new Negotiation(item.OrderId, item.Order.Name, item.Order.Status, item.Order.OrderNumber, 'Order', item.Order.CreatedDate);
                negList.add(negItem);
            }
            for (Case c : casesList){
                Negotiation negItem = new Negotiation(c.Id, c.Subject, c.Status, c.CaseNumber, 'Case', c.CreatedDate);
                negList.add(negItem);
            }
            outMap.put('Negotiations', negList);
        }
    }
    
    public class Negotiation {
        public Id Id;
        public String Name = '';
        public String status = '';
        public String negNumber = '';
        public String negType = '';
        public Datetime negDate;
        
        public Negotiation(){}
        
        public Negotiation(Id Id, String Name, String status, String negNumber, String negType, Datetime negDate){
            this.Id = Id;
            this.Name = Name;
            this.status = status;
            this.negNumber = negNumber;
            this.negType = negType;
            this.negDate = negDate;
        }
    }
}