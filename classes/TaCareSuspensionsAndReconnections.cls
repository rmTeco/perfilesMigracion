global class TaCareSuspensionsAndReconnections implements vlocity_cmt.VlocityOpenInterface {
    private Map<String, Object> input;
    private Map<String, Object> output;
    private Map<String, Object> options;

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options) {
        try {
            this.input = input;
            this.output = output;
            this.options = options;

            switch on methodName {
                when 'SuspendAssets' {
                    this.SuspendAssets();
                }
                when 'ResumeAssets' {
                    this.ResumeAssets();
                }
                when 'SubmitOrders' {
                    this.SubmitOrders();
                }
                when 'createListChildCasesUnfraudBA' {
                    this.createListChildCasesUnfraudBA();
                }
                when 'SuspencreateListChildCasesFraudBAdAssets' {
                    this.createListChildCasesFraudBA();
                }
                when 'createListChildCasesAssets' {
                    this.createListChildCasesAssets();
                }
                when 'getSuspendedDevicesByAccountId' {
                    this.getSuspendedDevicesByAccountId();
                }
                when 'createTrasactionHistory' {
                    this.createTrasactionHistory();
                }
                when 'GetAssetByIMEI' {
                    this.GetAssetByIMEI();
                }
                when 'GetNewGuid' {
                    this.GetNewGuid();
                }                
            }

            return true;
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    private void SuspendAssets() {
        try {
            Id accountId = (Id) this.options.get('AccountId');
            String suspensionReason = (String) this.options.get('SuspensionReason');
            String deviceAssetIdToSuspend = (String) this.options.get('DeviceAssetIdToSuspend');
            String prepaidAssetIdToSuspend = (String) this.options.get('PrepaidAssetIdToSuspend');
            Set<Id> assetToSuspendIds = new Set<Id>();

            if (String.IsNotEmpty(deviceAssetIdToSuspend))
                assetToSuspendIds.Add(deviceAssetIdToSuspend);
            
            if (String.IsNotEmpty(prepaidAssetIdToSuspend))
                assetToSuspendIds.Add(prepaidAssetIdToSuspend);

            Id orderId = AssetService.Suspend(accountId, assetToSuspendIds, this.GetSuspensionReasonType(suspensionReason));
            this.output.put('OrderId', orderId);
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    private void ResumeAssets() {
        try {
            Id accountId = (Id) this.options.get('AccountId');
            String deviceAssetIdToResume = (String) this.options.get('DeviceAssetIdToResume');
            String prepaidAssetIdToResume = (String) this.options.get('PrepaidAssetIdToResume');
            Set<Id> assetToResumeIds = new Set<Id>();

            if (String.IsNotEmpty(deviceAssetIdToResume))
                assetToResumeIds.Add(deviceAssetIdToResume);
            
            if (String.IsNotEmpty(prepaidAssetIdToResume))
                assetToResumeIds.Add(prepaidAssetIdToResume);

            Id orderId = AssetService.Resume(accountId, assetToResumeIds);
            this.output.put('OrderId', orderId);
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    private void GetAssetByIMEI() {
        try {
            AssetsSelector assetsSelector = (AssetsSelector) Application.Selector.NewInstance(Asset.SObjectType);
            String IMEI = (String) this.options.get('IMEI');

            List<Asset> assets = assetsSelector.SelectByIMEI(new Set<String> { IMEI });

            if (!assets.IsEmpty()) {     
                this.output.put('AccountId', assets[0].AccountId);
                this.output.put('Status', assets[0].Status);
                this.output.put('AssetId', assets[0].Id);
            }
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    private void SubmitOrders() {
        try {
            String orderId = (String) this.options.get('OrderId');
            Set<Id> orderToSubmitIds = new Set<Id>();

            if (String.IsNotEmpty(orderId))
                orderToSubmitIds.Add(orderId);

            OrderService.Submit(orderToSubmitIds);
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    private SuspensionReason GetSuspensionReasonType(String strSuspensionReason) {
        try {
            for (SuspensionReason suspReason : SuspensionReason.values()) {
                if (suspReason.Name() == strSuspensionReason)
                    return suspReason;
            }

            return null;
        }
        catch (Exception ex) {
            throw ex;
        }
    }

    private void createListChildCasesUnfraudBA() {
        Id parentId = (Id) input.get('DRId_Case');
        // Map<String, Object> clientInformation = (Map<String, Object>) inputMap.get('ClientInformation');
        List<Object> billingAccs = (List<Object>)options.get('BillingAccs');
        
        List<Case> listChildCases = new List<Case>();

        for(Object ba : billingAccs){
            Map<String, Object> baMap = (Map<String, Object>) ba; 
            Id accId =  (Id) baMap.get('Id');
            Case myCase = new Case();
            myCase.ParentId = parentId;
            myCase.AccountId = accId;
            myCase.Subject = 'Suspension/Habilitacion por Administrativo';
            myCase.Status = 'Cerrado';
            listChildCases.add(myCase);
        }
        insert listChildCases;
        output.put('Cases',listChildCases);
    }

    private void createListChildCasesFraudBA() {
        Id parentId = (Id)input.get('DRId_Case');
       // Map<String, Object> clientInformation = (Map<String, Object>) inputMap.get('ClientInformation');
        List<Object> billingAccs = (List<Object>)options.get('FraudBillingAccs');

        List<Case> listChildCases = new List<Case>();
        for(Object ba : billingAccs){
            Map<String, Object> baMap = (Map<String, Object>) ba; 
            Id accId =  (Id) baMap.get('Id');
            Case myCase = new Case();
            myCase.ParentId = parentId;
            myCase.AccountId = accId;
            myCase.Subject = 'Suspension/Habilitacion por Administrativo';
            myCase.Status = 'Cerrado';
            listChildCases.add(myCase);
        }
        insert listChildCases;
        output.put('Cases',listChildCases);
    }
    
    private void createListChildCasesAssets() {
        Id parentId = (Id)input.get('DRId_Case');
        Id orderId = (Id) input.get('OrderId');
        Id recordTypeId = (Id) options.get('RecordTypeId');
        Id subtype = (String) options.get('SubType');
       // Map<String, Object> clientInformation = (Map<String, Object>) inputMap.get('ClientInformation');
        List<Object> billingAccs = (List<Object>)options.get('AssetsM');

        List<Case> listChildCases = new List<Case>();
        for(Object ba : billingAccs){
            Map<String, Object> baMap = (Map<String, Object>) ba; 
            System.debug('baMap: ' + baMap);
            Id assetId =  (Id) baMap.get('AssetId');
            Case myCase = new Case();
            myCase.ParentId = parentId;
            System.debug('Asset id: ' + assetId);
            myCase.AssetId = assetId;
            myCase.Subject = 'Suspension/Habilitacion por Administrativo';
            myCase.Status = 'En espera de ejecución';
            myCase.Order__c = orderId;
            myCase.RecordTypeId = recordTypeId;
            myCase.Type = 'Suspensiones y reconexiones';
            myCase.SubType__c = subtype;
            listChildCases.add(myCase);
        }
        insert listChildCases;
        output.put('Cases',listChildCases);
    }
    
    private void getSuspendedDevicesByAccountId ()
    {
        try {
            Id accountId = (Id) this.input.get('ContextId');
            Map<String, Object> recordType = (Map<String, Object>) this.input.get('RecordType');
            Id recordTypeId = (Id) recordType.get('Id');
            List<Map<String, object>> listClientSuspensions = new List<Map<String, object>>();
            
            Map<String, Object> clientSuspensionsMap;
            List<transaction_history__c> clientSuspensions = [SELECT Id, Asset__r.AccountId, Asset__c, Asset__r.id, Asset__r.Name, asset__r.imei__c, imei__c FROM transaction_history__c where new_status__c = 'Active' AND Account__c = :accountId AND RecordTypeId = :recordTypeId AND Description__c = 'Suspensión' AND Type__c = 'Siniestro' AND ((asset__r.tipo_de_producto__c = 'dispositivo' and asset__R.Linked_Product_Family__c = 'Movil') OR (imei__c <> null ))];
            System.debug('clientSuspensions: ' + clientSuspensions);
            for(transaction_history__c susp : clientSuspensions){
                clientSuspensionsMap = new Map<String, String>();
                If(susp.Asset__c != null){
                    clientSuspensionsMap.put('Id', (String) susp.Asset__r.id); 
                    clientSuspensionsMap.put('TransactionId', (String) susp.Id); 
                    clientSuspensionsMap.put('assetName', (String) susp.Asset__r.Name);
                    clientSuspensionsMap.put('Imei', (String) susp.asset__r.imei__c);
                    clientSuspensionsMap.put('AccountId', (String) susp.Asset__r.AccountId);
                }
                else {
                    clientSuspensionsMap.put('TransactionId', (String) susp.Id);
                    clientSuspensionsMap.put('Imei', (String) susp.Imei__c);
                }
                listClientSuspensions.add(clientSuspensionsMap);
            }
            
            
            
            
            System.debug(listClientSuspensions);
            output.put('listClientSuspensions',listClientSuspensions);
        }
        catch (Exception ex) {
            throw ex;
        }
    }
    
    private void createTrasactionHistory() {
            
            //List<transaction_history__c> listTransactionHis = new List<transaction_history__c>();
            Map<String, Object> trasactionData = (Map<String, Object>) this.options.get('transactionHistory'); 
            System.debug('trasactionData: ' + trasactionData);
            transaction_history__c myTransactionHis = new transaction_history__c();
            
            if( trasactionData.get('Id') == null ){
                myTransactionHis.sinister_type__c = (String)trasactionData.get('SinisterType');
                myTransactionHis.Type__c = (String)trasactionData.get('Type');
                myTransactionHis.RecordTypeId = (Id)trasactionData.get('RecordType');
                myTransactionHis.New_Status__c = (String)trasactionData.get('NewStatus');
                myTransactionHis.Imei__c = (String)trasactionData.get('Imei');
                myTransactionHis.Description__c = (string)trasactionData.get('Description');
                myTransactionHis.Account__c = (Id)trasactionData.get('AccountId');
            }else{
                myTransactionHis.Id = (Id)trasactionData.get('Id');
                myTransactionHis.New_Status__c = (String)trasactionData.get('NewStatus');
            }
            
    
        System.debug('myTransactionHis: ' + myTransactionHis);
        upsert myTransactionHis;
        output.put('TransactionHistoryCreate',myTransactionHis);
    }

    //Norwill Gutierrez - To Get unique id for transaction
    private void GetNewGuid(){
        String idUnico = GuidUtil.NewGuid();
        this.output.put('UniqueTransactionID', idUnico);
    }     
}