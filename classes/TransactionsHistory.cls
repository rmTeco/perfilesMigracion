public class TransactionsHistory extends ApplicationDomain {
    public TransactionsHistory(List<Transaction_History__c> transactionsHistory) {
        Super(transactionsHistory);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain Construct(List<SObject> sObjectList) {
            return new TransactionsHistory(sObjectList);
        } 
    }

    public override void OnApplyDefaults() {
        for (Transaction_History__c transactionHistory : (List<Transaction_History__c>) this.Records) {
            this.ApplyDefaultSubscribeDate(transactionHistory);
        }
    }

    public override void OnAfterInsert() {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.NewInstance();
        Set<Id> suspendedSiniestroIds = new Set<Id>();
        Set<Id> suspendedAdministrativaIds = new Set<Id>();

        for (Transaction_History__c transactionEntry : (List<Transaction_History__c>) this.Records)
            if (transactionEntry.Description__c == 'Reconexión') {
                if (transactionEntry.Type__c == 'Siniestro')
                    suspendedSiniestroIds.Add(transactionEntry.Asset__c);
                else if (transactionEntry.Type__c == 'Administrativa')
                    suspendedAdministrativaIds.Add(transactionEntry.Asset__c);
            }
        
        if (!suspendedSiniestroIds.IsEmpty() || !suspendedAdministrativaIds.IsEmpty())
            this.DeactivateCurrentSuspension(unitOfWork, suspendedSiniestroIds, suspendedAdministrativaIds);
        
        unitOfWork.CommitWork();
    }

    private void ApplyDefaultSubscribeDate(Transaction_History__c transactionHistory) {
        if (transactionHistory.Subscribe_Date__c == null)
            transactionHistory.Subscribe_Date__c = DateTime.Now();
    }

    private void DeactivateCurrentSuspension(fflib_ISObjectUnitOfWork unitOfWork, Set<Id> suspendedSiniestroIds, Set<Id> suspendedAdministrativaIds) {
        Set<Id> suspendedAssetIds = new Set<Id>();
        suspendedAssetIds.AddAll(suspendedSiniestroIds);
        suspendedAssetIds.AddAll(suspendedAdministrativaIds);

        List<Transaction_History__c> activeSuspensions =
            new TransactionsHistorySelector().SelectByAssetIdAndStatus(suspendedAssetIds, 'Active');

        for (Transaction_History__c assetActiveSuspension : activeSuspensions) {
            if (assetActiveSuspension.Type__c == 'Siniestro' && suspendedSiniestroIds.Contains(assetActiveSuspension.Asset__c)) {
                assetActiveSuspension.New_Status__c = 'Inactive';
                unitOfWork.RegisterDirty(assetActiveSuspension);
            }
            else if (assetActiveSuspension.Type__c == 'Administrativa' && suspendedAdministrativaIds.Contains(assetActiveSuspension.Asset__c)) {
                assetActiveSuspension.New_Status__c = 'Inactive';
                unitOfWork.RegisterDirty(assetActiveSuspension);
            }
        }
    }
}