public class Orders extends ApplicationDomain {
    public Orders(List<Order> orders) {
        Super(orders);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain Construct(List<SObject> sObjectList) {
            return new Orders(sObjectList);
        } 
    }

    public override void OnAfterUpdate(Map<Id, SObject> existingOrders) {
        fflib_ISObjectUnitOfWork unitOfWork = Application.UnitOfWork.NewInstance();
        Set<Id> suspensionAndReconnectionsOrdersActivated = new Set<Id>();

        for (Order order : (List<Order>) this.Records) {
            if (this.IsActivated(order.Status, ((Order) existingOrders.Get(order.Id)).Status)) {
                if (order.Gestion__c == OrderType.Suspension.Name() || order.Gestion__c == OrderType.Resume.Name()) {
                    suspensionAndReconnectionsOrdersActivated.add(order.Id);
                }
            }
        }

        if (!suspensionAndReconnectionsOrdersActivated.IsEmpty())
            this.RegisterTransactionEntry(unitOfWork, suspensionAndReconnectionsOrdersActivated, existingOrders);

        unitOfWork.CommitWork();
    }

    public void ComposeSuspension(fflib_ISObjectUnitOfWork unitOfWork, SuspensionReason suspensionReason) {
        for (Order order : (List<Order>) this.Records) {
            order.Gestion__c = OrderType.Suspension.Name();

            OrderItems orderItems = (OrderItems) Application.Domain.NewInstance(order.OrderItems);
            orderItems.SetActionsForSuspension(unitOfWork, suspensionReason);

            unitOfWork.RegisterDirty(order);
        }
    }

    public void ComposeReconnection(fflib_ISObjectUnitOfWork unitOfWork, Map<Id, Asset> assetsWithActiveSuspension) {
        for (Order order : (List<Order>) this.Records) {
            order.Gestion__c = OrderType.Resume.Name();

            OrderItems orderItems = (OrderItems) Application.Domain.NewInstance(order.OrderItems);
            orderItems.SetActionsForResume(unitOfWork, assetsWithActiveSuspension);

            unitOfWork.RegisterDirty(order);
        }
    }

    private Boolean IsActivated(String currentOrderStatus, String oldOrderStatus) {
        return (currentOrderStatus != oldOrderStatus && currentOrderStatus == 'Activated');
    }

    private void RegisterTransactionEntry(fflib_ISObjectUnitOfWork unitOfWork,
        Set<Id> suspensionAndReconnectionsOrdersActivated, Map<Id, SObject> existingOrders) {
        CasesSelector casesSelector = (CasesSelector) Application.Selector.NewInstance(Case.SObjectType);
        Set<Id> suspensionAndReconnectionsParentCaseIds = new Set<Id>();
        List<Case> suspensionAndReconnectionCases = casesSelector.SelectByOrderIdWithAsset(suspensionAndReconnectionsOrdersActivated);

        for (Case caseObj : suspensionAndReconnectionCases)
            suspensionAndReconnectionsParentCaseIds.Add(caseObj.ParentId);
        
        Map<Id, Case> suspensionAndReconnectionsParentCases = new Map<Id, Case>(casesSelector.SelectById(suspensionAndReconnectionsParentCaseIds));
       
        Id assetTransactionRecordTypeId = Schema.SObjectType.Transaction_History__c
            .GetRecordTypeInfosByName().Get('Asset Transaction History').GetRecordTypeId();

        for (Case caseObj : suspensionAndReconnectionCases) {
            caseObj.Status = 'Realizada exitosa';

            if (caseObj.ParentId != null) {
                Case parentCase = suspensionAndReconnectionsParentCases.Get(caseObj.ParentId);
                Order order = (Order) existingOrders.Get(caseObj.Order__c);

                Transaction_History__c suspensionToRegister = new Transaction_History__c();
                suspensionToRegister.Account__c = parentCase.AccountId;
                suspensionToRegister.Asset__c = caseObj.AssetId;
                suspensionToRegister.RecordTypeId = assetTransactionRecordTypeId;

                if (parentCase.SubType__c == 'Suspensión siniestro') {
                    suspensionToRegister.Description__c = 'Suspensión';
                    suspensionToRegister.Type__c = 'Siniestro';
                    suspensionToRegister.Sinister_type__c = parentCase.Reason;
                    suspensionToRegister.New_Status__c = 'Active';
                }
                else if (parentCase.SubType__c == 'Reconexión siniestro') {
                    suspensionToRegister.Type__c = 'Siniestro';
                    suspensionToRegister.Description__c = 'Reconexión';
                }
                else if (parentCase.SubType__c == 'Suspensión administrativa') {
                    suspensionToRegister.Description__c = 'Suspensión';
                    suspensionToRegister.Type__c = 'Administrativa';
                    suspensionToRegister.New_Status__c = 'Active';
                }
                else if (parentCase.SubType__c == 'Reconexión administrativa') {
                    suspensionToRegister.Type__c = 'Administrativa';
                    suspensionToRegister.Description__c = 'Reconexión';
                }

                unitOfWork.RegisterNew(suspensionToRegister);
            }

            unitOfWork.RegisterDirty(caseObj);
        }
    }
}