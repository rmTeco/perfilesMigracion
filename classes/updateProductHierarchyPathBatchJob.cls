public with sharing class updateProductHierarchyPathBatchJob implements Database.Batchable<sObject>, Database.Stateful {
    public Id jobId;
    public final String query;
    
    public updateProductHierarchyPathBatchJob(String query)
    {
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        this.jobId = BC.getJobId();
        return Database.getQueryLocator(query);
        
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        updateProductHierarchyPath(BC, scope);
        
    }
    
    public void finish(Database.BatchableContext BC)
    {

        
    }
    
    // bind attribute values to sobject fields
    public void updateProductHierarchyPath(Database.BatchableContext BC, List<sObject> scope)
    {
        
        String nsPrefix = 'vlocity_cmt__';
        //String nsPrefix = '';
        Set<String> productIds = new Set<String>();
        for(sObject item : scope)
        {
            String prodHierarchyPath = (String)item.get(nsPrefix + 'ProductHierarchyPath__c');
            productIds.addAll(prodHierarchyPath.split('<'));
        }
        Map<String, String> sourceProductIdToNewId = new Map<String, String>();
        String queryString = 'SELECT Id, SourceOrgProductId__c FROM Product2 WHERE SourceOrgProductId__c IN :productIds';
        //for(Product2 productSO :[SELECT Id, SourceOrgProductId__c FROM Product2 WHERE SourceOrgProductId__c IN :productIds])
        for(Product2 productSO :Database.query(queryString))
        {
            //sourceProductIdToNewId.put(productSO.SourceOrgProductId__c, productSO.Id);
            sourceProductIdToNewId.put((String)productSO.get('SourceOrgProductId__c'), productSO.Id);
        }
        
        for(sObject item : scope)
        {
            String prodHierarchyPath = (String)item.get(nsPrefix + 'ProductHierarchyPath__c');
            //only translate 2 or more levels paths
            //the remaining will be handled by the DR
            if(!prodHierarchyPath.contains('<'))
            {
                continue;
            }
            
            List<String> oldProductIds = prodHierarchyPath.split('<');
            List<String> newProductIds = new List<String>();
            for(String productId : oldProductIds)
            {
                newProductIds.add(sourceProductIdToNewId.get(productId));

            }

            item.put(nsPrefix + 'ProductHierarchyPath__c', String.join(newProductIds, '<'));
            

        }
        
        update scope;
        
    } 
    
}