global with sharing class ta_techCare_technical_service_ext_ctrl{

    public List<OrderItem> repairs { get; set; }
    public List<CaseComment> comments { get; set; }
    public Case tsCase { get; set; }
    public String brand { get; set; }
    public Map<String, String> saleWarranty { get; set; }
    
    public ta_techCare_technical_service_ext_ctrl(ApexPages.StandardController stdController){
        try{
            Case pageCase = (Case)stdController.getRecord();
            this.saleWarranty = new Map<String, String>();            
            getCaseData(pageCase.Id);            
            Apexpages.currentPage().getHeaders().put('content-disposition', 'filename=' + tsCase.CaseNumber + '.pdf');
            
        } catch(Exception e){}
    }
    
    private void getCaseData(Id caseId){
        this.tsCase = [SELECT CaseNumber,
                              Status,
                              Owner.Name,
                              Description,
                              SuppliedEmail,
                              SuppliedPhone,
                              MuleTerminal__c,
                              RepairWarranty__c,
                              RepairWarrantyEndDate__c,
                              Protection__r.Name,
                              Contact.Name,
                              Contact.Phone,
                              Contact.Email,
                              Asset.Id,
                              Asset.imei__c,
                              Asset.Name,
                              Asset.StockKeepingUnit,
                              Order__c
                         FROM Case
                        WHERE Id = :caseId];
        
        if(tsCase.Order__c != null){
            Order caseOrder = [SELECT Id,
                                      (SELECT Product2.Name, 
                                              vlocity_cmt__EffectiveOneTimeTotal__c 
                                         FROM OrderItems) 
                                 FROM Order 
                                WHERE Id = :tsCase.Order__c];
            
            if(caseOrder.OrderItems.size() > 0)
                this.repairs = caseOrder.OrderItems;
            else
                this.repairs = new List<OrderItem>();
        }

        this.comments = [SELECT Id, 
                                CommentBody, 
                                CreatedBy.FirstName, 
                                CreatedBy.LastName, 
                                CreatedDate 
                           FROM CaseComment
                          WHERE ParentId = :tsCase.Id
                       ORDER BY CreatedDate];

        String methodName = 'GetDeviceInfoByAssetId';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Ta_techCare_technical_service techServ = new Ta_techCare_technical_service();
        options.put('AssetId', tsCase.Asset.Id);
        techServ.invokeMethod(methodName, input, outMap, options);

        Map<String, Object> aux = (Map<String, Object>) outMap.get('Device');
        aux = (Map<String, Object>) aux.get('Brand');
        brand = (String) aux.get('displayText');

        aux = (Map<String, Object>) outMap.get('Device');
        aux = (Map<String, Object>) aux.get('SaleWarranty');
        
        saleWarranty.put('applies', (String) aux.get('applies'));
        saleWarranty.put('from', ((Datetime) aux.get('from')).format('dd/MM/yyyy'));
        saleWarranty.put('to', ((Datetime) aux.get('to')).format('dd/MM/yyyy'));
    }
}