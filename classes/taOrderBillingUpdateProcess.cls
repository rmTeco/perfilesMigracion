global with sharing class taOrderBillingUpdateProcess {//implements vlocity_cmt.VlocityOpenInterface{
    
    global static void BillUpdateOrder(String id)
    {
        System.debug('taOrderBillingUpdateProcess.BillUpdateOrder');
        try
        {
            //PFTA-7438 - Store Pickup - Flujo de Derivacion - INI
            System.debug('IdOrder: ' + id);
            Order order = [SELECT OriginStoreLocation__c, Delivery_Method__c FROM Order where Id =: id];

            System.debug('OriginStoreLocation: ' + order.OriginStoreLocation__c);
            vlocity_cmt__BusinessSite__c store = [SELECT Channel_Type__c FROM vlocity_cmt__BusinessSite__c WHERE Id =: order.OriginStoreLocation__c];

            System.debug('ChannelType: ' + store.Channel_Type__c);
            if(store.Channel_Type__c == 'Oficinas Comerciales')
            {
                taOrderController.UpdateOrderStatus(id, 'Preparar pedido');
                taOrderController.CreateStateTask(id, taOrderController.PENDIENTE_ARMADO_NOTIFICATION);
            }
            else if(store.Channel_Type__c == 'Agentes')
            {
                if(order.Delivery_Method__c == 'Presencial' || order.Delivery_Method__c == 'Delivery')
                {
                    taOrderController.UpdateOrderStatus(id, 'Entregado');
                }
                if(order.Delivery_Method__c == 'Store Pick Up')
                {
                    taOrderController.UpdateOrderStatus(id, 'Preparar pedido');
                    taOrderController.CreateStateTask(id, taOrderController.PENDIENTE_ARMADO_NOTIFICATION);
                }
            }
            /*
            System.debug(order.Delivery_Method__c);
            if(order.Delivery_Method__c == 'Presencial' || order.Delivery_Method__c == 'Store Pick Up' )
            {
                String codDeposito = '';
                Map<string, Object> response = TaMatrixUtils.getStockMovementOperation('VTAN','FACTURA', order.Delivery_Method__c);
                String codOperation =  (String) response.get('StockMovementOperation__OperationCode');
                String destinationDepositCode = (String) response.get('StockMovementOperation__DestinationDepositCode');
                System.debug('FACTURA -> Codigo operacion: ' + codOperation + ' Codigo deposito: ' + destinationDepositCode );
                if(destinationDepositCode == 'VICLIE')
                    codDeposito = 'VICLIE0001';

                if (String.isNotBlank(codOperation) && String.isNotBlank(codDeposito))
                    StockUtils.StockMovement(id, codOperation, codDeposito);
                }
            if (taOrderController.ValidateTangibleExistence(id))
            {
                taOrderController.UpdateOrderStatus(id,'Preparar Pedido');
                taOrderController.CreateStateTask(id,taOrderController.PENDIENTE_ARMADO_NOTIFICATION);
            }
            else taOrderController.UpdateOrderStatus(id,'Cobrado');
            */
            //PFTA-7438 - Store Pickup - Flujo de Derivacion - FIN
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }
/*
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('DeliverStorePickUp'))
            {
                DeliverStorePickUp(inputMap, outMap);
            }
            result = false;  
        } 
        catch(Exception e)
        {
            System.debug('taOrderBillingUpdateProcess:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    void DeliverStorePickUp(Map<String,Object> inputMap, Map<String,Object> outMap)
    {
        System.debug('DeliverStorePickUp');
        try
        {
            Map<String, Object> order = (Map<String, Object>) inputMap.get('BillingOrder');
            String orderId = (String) order.get('Id');
            StockUtils.StockMovement(orderId, 'FVOC', 'VICLIE0001');
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }
    */
}