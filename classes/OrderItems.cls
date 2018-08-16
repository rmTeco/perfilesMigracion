public class OrderItems extends ApplicationDomain {
    public OrderItems(List<OrderItem> orderItems) {
        Super(orderItems);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain Construct(List<SObject> sObjectList) {
            return new OrderItems(sObjectList);
        } 
    }

    public void SetActionsForSuspension(fflib_ISObjectUnitOfWork unitOfWork, SuspensionReason suspReason) {
        for (OrderItem orderItem : (List<OrderItem>) this.Records) {
            orderItem.Vlocity_cmt__Action__c = OrderItemAction.Change.Name();
            orderItem.Vlocity_cmt__ProvisioningStatus__c = OrderItemProvisioningStatus.Suspend.Name();

            if (suspReason == SuspensionReason.Administrativa)
                orderItem.Vlocity_cmt__SubAction__c = 'Suspend-Fraude';
            else
                orderItem.Vlocity_cmt__SubAction__c = 'Suspend-Siniestro';

            if (orderItem.vlocity_cmt__Product2Id__r.Tangible__c == true)
                orderItem.Codigo_Movimiento_Inventario__c = this.GetStockMovementCode(OrderType.Suspension, suspReason.Name());

            unitOfWork.RegisterDirty(orderItem);
        }
    }

    public void SetActionsForResume(fflib_ISObjectUnitOfWork unitOfWork, Map<Id, Asset> assetsWithActiveSuspension) {
        for (OrderItem orderItem : (List<OrderItem>) this.Records) {
            orderItem.Vlocity_cmt__Action__c = OrderItemAction.Change.Name();
            orderItem.Vlocity_cmt__ProvisioningStatus__c = OrderItemProvisioningStatus.Resume.Name();

            if (orderItem.vlocity_cmt__Product2Id__r.Tangible__c == true) {
                Asset orderItemAsset;

                if (orderItem.Vlocity_cmt__AssetId__r.Vlocity_cmt__RootItemId__c != null)
                    orderItemAsset = (Asset) assetsWithActiveSuspension.Get(orderItem.Vlocity_cmt__AssetId__r.Vlocity_cmt__RootItemId__c);
                else 
                    orderItemAsset = (Asset) assetsWithActiveSuspension.Get(orderItem.Vlocity_cmt__AssetId__c);

                if (orderItemAsset.Transaction_History_Entries__r != null && orderItemAsset.Transaction_History_Entries__r.Size() > 0) {
                    String suspensionReason = orderItemAsset.Transaction_History_Entries__r[0].Sinister_type__c;            
                    orderItem.Codigo_Movimiento_Inventario__c = this.GetStockMovementCode(OrderType.Resume, suspensionReason);
                }
            }

            unitOfWork.RegisterDirty(orderItem);
        }
    }

     private String GetStockMovementCode(OrderType orderGestion, String suspReason) {
        String stockMovementCode;

        if (orderGestion == OrderType.Suspension) {
            if (suspReason == SuspensionReason.Robo.Name())
                stockMovementCode = 'STCR';
            else if (suspReason == SuspensionReason.Hurto.Name() || suspReason == SuspensionReason.Administrativa.Name())
                stockMovementCode = 'STCH';
            else if (suspReason == SuspensionReason.Extravio.Name())
                stockMovementCode = 'STCE';
        }
        else if (orderGestion == OrderType.Resume) {
            if (suspReason == SuspensionReason.Robo.Name())
                stockMovementCode = 'RTCR';
            else if (suspReason == SuspensionReason.Hurto.Name() || suspReason == SuspensionReason.Administrativa.Name())
                stockMovementCode = 'RTCH';
            else if (suspReason == SuspensionReason.Extravio.Name())
                stockMovementCode = 'RTCE';
        }
        
        return stockMovementCode;
    }
}