global with sharing class taSalesAnnulmentHandler implements vlocity_cmt.VlocityOpenInterface{
    public static final String OPERATION_TYPE_ANULACION = 'ANUV';
    public static final String OPERATION_TYPE_ANULACIONCEG = 'ANUG';
    public static final String INSTANCE_ANULAR_VENTA = 'ANULAVENTA';
    public static final String INSTANCE_ANULAR_DEVOLUCION = 'ANULADEVOLUCION';
    public static final String STOCK_MOVEMENT_NO_APLICA = 'NOAPLICA';
    public static final String STOCK_MOVEMENT_CODDEPOSITO_CLIENTE = 'VICLIE0001';

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if (methodName.equals('PaymentRollback')){
                PaymentRollback(inputMap, outMap, options);
            }

            if (methodName.equals('HotInvoiceRollback')){
                HotInvoiceRollback(inputMap, outMap, options);
            }

            if (methodName.equals('GetChargesByInvoiceCBS')){
                GetChargesByInvoiceCBS(inputMap, outMap, options);
            }

            if (methodName.equals('CorrectionCBS')){
                CorrectionCBS(inputMap, outMap, options);
            }

            if (methodName.equals('ValidateSuspensions')){
                Boolean hasSuspensions = ValidateSuspensions((String) options.get('orderId'));
                outMap.put('hasSuspensions', hasSuspensions);
            }

            if (methodName.equals('ValidateAnnulmentTerm')){
                ValidateAnnulmentTerm(inputMap, outMap, options);
            }

            if (methodName.equals('ValidateAnnulmentChannel')){
                ValidateAnnulmentChannel(inputMap, outMap, options);
            }

            if (methodName.equals('ReturnSerialsToStock')){
                ReturnSerialsToStock(inputMap, outMap, options);
            }
            
            if (methodName.equals('ReturnSerialsToStockCEG')){
                ReturnSerialsToStockCEG(inputMap, outMap, options);
            }
            
            if (methodName.equals('ValidateAnnulmentStoreLocation')){
                ValidateAnnulmentStoreLocation(inputMap, outMap, options);
            }
            
            //PFTA-8082
            if (methodName.equals('AnnulmentTermError')){
                AnnulmentTermError(inputMap, outMap, options);
            }
            
            if (methodName.equals('AnnulmentChannelError')){
                AnnulmentChannelError(inputMap, outMap, options);
            }
            
            if (methodName.equals('AnnulmentSuspensionsError')){
                AnnulmentSuspensionsError(inputMap, outMap, options);
            }
            
            if (methodName.equals('ValidateDeliveredOM')){
                ValidateDeliveredOM(inputMap, outMap, options);
            }
            
            if (methodName.equals('CreateCancelCase')){
                CreateCancelCase(inputMap, outMap, options);
            }
            //PFTA-8082
            
            //PFTA-8520
            if (methodName.equals('ValidateOrderCEG')){
                ValidateOrderCEG(inputMap, outMap, options);
            }
            
            if (methodName.equals('ValidatePuntoDeVenta')){
                Boolean puntodeventa = ValidatePuntoDeVenta((Id) options.get('orderId'), (Id) options.get('annulmentOrderId'), outMap);
                outMap.put('puntodeventa', puntodeventa);
            }
            
            if (methodName.equals('ValidateCanalPresencial')){
                Boolean canalpresencial = ValidateCanalPresencial((Id) options.get('orderId'), (Id) options.get('annulmentOrderId'));
                outMap.put('canalpresencial', canalpresencial);
            }
            //PFTA-8520
            

            if (methodName.equals('CloseAnnulmentOrder')){
                Map<String, Object> oMap;
                String ordId = (String) options.get('orderId');
                String oldOrdId = (String) options.get('oldOrderId');
                String trackingStatus = (String) options.get('trackingStatus');
                String orderApprovalStatus = (String) options.get('orderApprovalStatus');
                String trackingStatusAnnulment = (String) options.get('trackingStatusAnnulment');
                Boolean stat = CloseAnnulmentOrder(ordId, oldOrdId, trackingStatus, orderApprovalStatus, trackingStatusAnnulment);
                outMap.put('CloseOrderStatus', stat);
            }

            if (methodName.equals('CreateOrCheckAnnulmentOrder')){
                Map<String, Object> oMap;
                String ordId = (String) options.get('orderId');
                List<Order> objOrderList = [SELECT
                                    Id,
                                    TrackingStatus__c,
                                    OrderNumber,
                                    Gestion__c
                                FROM Order
                                WHERE Id = :ordId AND Gestion__c='Desconexión' AND TrackingStatus__c='Pendiente de Anulacion'];

                Order objOrder = (objOrderList != null && objOrderList.size()>0) ? objOrderList[0] : null;
                System.debug(objOrder);
                if(objOrder != null){
                    outMap.put('annulmentOrderId',objOrder.Id);
                    outMap.put('OrderNumber', objOrder.OrderNumber);
                } else {
                    oMap = taSalesCreateOrderController.CloneOrder(ordId, true);
                    outMap.put('annulmentOrderId', oMap.get('IdOrder'));
                    outMap.put('OrderNumber', oMap.get('OrderNumber'));
                }
            }

            if (methodName.equals('GetCashPayments')){
                System.debug('GetCashPayments');
                String orderId = (String) options.get('OrderId');
                System.debug(orderId);
                List<vlocity_cmt__PaymentAdjustment__c> payments = taOrderController.GetCashPayments(orderId);
                System.debug(payments);
                outMap.put('data', payments);
                System.debug(JSON.serialize(outMap));
            }

            if (methodName.equals('GetCardsPayments')){
                String orderId = (String) options.get('OrderId');
                List<vlocity_cmt__PaymentAdjustment__c> payments = taOrderController.GetCardsPayments(orderId);
                List<Map<String, Object>> data = new List<Map<String, Object>>();
                for(vlocity_cmt__PaymentAdjustment__c payment :payments){
                    Map<String, Object> aux = new Map<String, Object>();

                    aux.put('PaymentAdjustmentId', payment.Id);
                    aux.put('CardNumber', payment.vlocity_cmt__PaymentMethodId__r.Concatenate__c);
                    aux.put('Ammount', payment.vlocity_cmt__Amount__c);
                    aux.put('SecurityCode', null);

                    data.add(aux);
                }

                outMap.put('data', data);
            }

            result = false;
        }
        catch(Exception e)
        {
            System.debug('taSalesAnnulmentHandler:invokeMethod -> exception: '+e);
            throw e;
            //result = false;
        }
        return result;
    }

    global static void ReturnSerialsToStock(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try
        {
            String orderId = String.valueOf(options.get('orderId'));
            ReturnSerialsToStock(orderId);
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    global static void ReturnSerialsToStock(String orderId)
    {
        try
        {
            List<OrderItem> orderItems = taOrderController.GetOrderSerials(orderId);
            Order originOrder = [Select id, OriginStoreLocation__r.AssociatedWarehouseId__c from Order where id = : orderId];
            
            Map<String,String> returnedSerialNumbers = new Map<String,String>();
            for(OrderItem item : orderItems){
                if (string.isNotBlank(item.vlocity_cmt__SerialNumber__c) && (item.Product2.vlocity_cmt__Type__c != 'Simcard'))
                {
                    returnedSerialNumbers.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                }
            }
            if (!Test.isRunningTest())
                if (returnedSerialNumbers.KeySet().size() > 0)
                    taOrderController.MoveSerialsStock(OPERATION_TYPE_ANULACION,INSTANCE_ANULAR_VENTA, returnedSerialNumbers, originOrder.OriginStoreLocation__r.AssociatedWarehouseId__c, STOCK_MOVEMENT_NO_APLICA);
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    
    global static void ReturnSerialsToStockCEG(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try
        {
            String orderId = String.valueOf(options.get('orderId'));
            ReturnSerialsToStockCEG(orderId);
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    
    global static void ReturnSerialsToStockCEG(String orderId)
    {
        try
        {
            List<OrderItem> orderItems = taOrderController.GetOrderSerials(orderId);
            
            Map<String,String> returnedSerialNumbers = new Map<String,String>();
            Map<String,String> serialNumbersForReturn = new Map<String,String>();
            
            Order originOrder = [Select id, OriginStoreLocation__r.AssociatedWarehouseId__c from Order where id = : orderId];
            
            for(OrderItem item : orderItems){
                if (string.isNotBlank(item.vlocity_cmt__SerialNumber__c) && (item.Product2.vlocity_cmt__Type__c != 'Simcard') && (item.vlocity_cmt__Action__c == 'Disconnect'))
                {
                    serialNumbersForReturn.put(item.vlocity_cmt__SerialNumber__c, null);
                }
                if (string.isNotBlank(item.vlocity_cmt__SerialNumber__c) && (item.Product2.vlocity_cmt__Type__c != 'Simcard') && (item.vlocity_cmt__Action__c == 'Add'))
                {
                    returnedSerialNumbers.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                    
                }
            }
            
            /*Map<String,Object> mapaANUL = new Map<String,Object>();
            
            mapaANUL.put('serialesANUL', returnedSerialNumbers);
            mapaANUL.put('operationType', OPERATION_TYPE_ANULACION);
            mapaANUL.put('instanceAnulacion', INSTANCE_ANULAR_VENTA);
            mapaANUL.put('codDepositoCliente',STOCK_MOVEMENT_CODDEPOSITO_CLIENTE);
            
            outMap.put('MovStockAnulacionVenta',mapaANUL);
            
            
            Map<String,Object> mapaANUG = new Map<String,Object>();
            
            mapaANUG.put('serialesANUL', serialNumbersForReturn);
            mapaANUG.put('operationType', OPERATION_TYPE_ANULACIONCEG);
            mapaANUG.put('instanceAnulacion', INSTANCE_ANULAR_DEVOLUCION);
            mapaANUG.put('codDepositoCliente', originOrder.OriginStoreLocation__r.AssociatedWarehouseId__c);
            
            outMap.put('MovStockAnulacionCEG',mapaANUG);
            */
            
            if (!Test.isRunningTest())
                if (returnedSerialNumbers.KeySet().size() > 0 && serialNumbersForReturn.KeySet().size() > 0){
                    taOrderController.MoveSerialsStock(OPERATION_TYPE_ANULACION, INSTANCE_ANULAR_VENTA, returnedSerialNumbers, originOrder.OriginStoreLocation__r.AssociatedWarehouseId__c, STOCK_MOVEMENT_NO_APLICA);
                    taOrderController.MoveSerialsStock(OPERATION_TYPE_ANULACIONCEG, INSTANCE_ANULAR_DEVOLUCION, serialNumbersForReturn, originOrder.OriginStoreLocation__r.AssociatedWarehouseId__c, STOCK_MOVEMENT_NO_APLICA);
                    
                    
                    
        }}
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    global static void PaymentRollback(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        String orderId = String.valueOf(options.get('OrderId'));
        //JARN: llamada que serealiza al metodo para la historia PFTA-8616
        listPaymentAdjustment(orderId);
        //Jarn: FIn
        List<Object> cardsPaymentsCharged = (List<Object>)options.get('CardsPaymentsCharged');
        Map<String, Object> response = call_S072_Payment_Rollback(orderId, cardsPaymentsCharged);
        Map<String, Object> ipResult = (Map<String, Object>)response.get('IPResult');

        // hardcode para mostrar distintos casos
        // if(orderId.startsWithIgnoreCase('8016C0000008coZ') || orderId.startsWithIgnoreCase('8016C0000008coy')){
        //     System.debug('ENTROOOO');
        //     ipResult = new Map<String, Object>();

        //     //revertirPagosRespuesta.put('listaInformacionPagos', null);
        //     ipResult.put('revertirPagosRespuesta', null);
        //     ipResult.put('mensaje', 'error');
        // }

        outMap.put('IPResult', ipResult);
    }

    global static void HotInvoiceRollback(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        String orderId = String.valueOf(options.get('OrderId'));

        Map<String, Object> response = call_S457_Hot_Invoice_Rollback(orderId);

        outMap.put('IPResult', response.get('IPResult'));
    }

    global static void CorrectionCBS(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        String orderId = String.valueOf(options.get('OrderId'));

        Map<String, Object> response = call_S485_Correction_CBS(orderId);

        Map<String, Object> ipResult = (Map<String, Object>)response.get('IPResult');

        if(ipResult.isEmpty())
        {
            ipResult.put('detalle', null);
            ipResult.put('mensaje', 'ok');
            ipResult.put('codigo', null);
        }

        outMap.put('IPResult', ipResult);
    }

    global static void GetChargesByInvoiceCBS(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        String orderId = String.valueOf(options.get('OrderId'));

        Map<String, Object> response = call_S479_Get_Charges_By_Invoice_CBS(orderId);

        Map<String, Object> ipResult = (Map<String, Object>)response.get('IPResult');

        Order order = new Order(Id=orderId);
        order.ChargesInvoicePayload__c = JSON.serialize(ipResult);
        update order;

        if(ipResult.get('codigo') == null)
            ipResult.put('mensaje', 'ok');

        outMap.put('IPResult', ipResult);
    }

    private static Map<String, Object> call_S479_Get_Charges_By_Invoice_CBS(String orderId)
    {
        Order order = [
            SELECT OrderNumber,
                Account.AccountIntegrationId__c,
                LegalInvoiceNumber__c
            FROM Order
            WHERE Id = :orderId
            ];
        
        Map<String, Object> request = new Map<String, Object>();

        Map<String, Object> body = new Map<String, Object>();

        Map<String, Object> solicitudCorreccionInformacion = new Map<String, Object>();

        Map<String, Object> objetoConsulta = new Map<String, Object>();

        Map<String, Object> codigoDeAccesoCuenta = new Map<String, Object>();

        //codigoDeAccesoCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);
        codigoDeAccesoCuenta.put('idCuenta', '1000000011810001');

        objetoConsulta.put('codigoDeAccesoCuenta', codigoDeAccesoCuenta);

        solicitudCorreccionInformacion.put('objetoConsulta', objetoConsulta);
        solicitudCorreccionInformacion.put('numeroComprobante', order.LegalInvoiceNumber__c);
        body.put('solicitudCorreccionInformacion', solicitudCorreccionInformacion);
        request.put('body', body);
        // List<Map<String, Object>> listaInformacionPagos = new List<Map<String, Object>>();

        // // Empieza el FOR
        // for(vlocity_cmt__PaymentAdjustment__c padj : payments){
        //     Map<String, Object> informacionPago = new Map<String, Object>();
        //     // informacionPago.put('codPago', padj.PaymentCode__c);

        //     Map<String, Object> codAcceso = new Map<String, Object>();
        //     Map<String, Object> codAccesoCuenta = new Map<String, Object>();
        //     codAccesoCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);
        //     codAcceso.put('codAccesoCuenta', codAccesoCuenta);
        //     informacionPago.put('codAcceso', codAcceso);

        //     Map<String, Object> wondersoftInfo = new Map<String, Object>();
        //     // wondersoftInfo.put('ipOrigen', 'COMPLETAAAAR');

        //     Map<String, Object> infoBanco = new Map<String, Object>();
        //     if(padj.vlocity_cmt__PaymentMethodId__r.BankEntityName__c != null){
        //         infoBanco.put('codEntidadFinanciera', padj.vlocity_cmt__PaymentMethodId__r.BankEntityName__c.leftPad(3, '0'));
        //     }

        //     // infoBanco.put('codSucursalEntidad', 'COMPLETAAAAAR');
        //     // infoBanco.put('codMedioPago', 'COMPLETAAAAAR');
        //     infoBanco.put('nroTarjetaEncriptado', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c);
        //     infoBanco.put('codEntidadTC', padj.Financial_Promotion__r.CreditCards__c);
        //     infoBanco.put('nombreActor', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c);
        //     infoBanco.put('fechaVencimientoTarjeta', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c + padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c);
        //     String pin = pines.get(padj.Id);
        //     infoBanco.put('codSeguridadTarjeta', pin);

        //     if(padj.vlocity_cmt__TotalInstallments__c != null){
        //         infoBanco.put('cantidadCuotasTarjeta', String.valueOf(padj.vlocity_cmt__TotalInstallments__c).leftPad(2, '0'));
        //     }

        //     wondersoftInfo.put('infoBanco', infoBanco);

        //     wondersoftInfo.put('nombreActor', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c);
        //     wondersoftInfo.put('tipoDocumento', padj.vlocity_cmt__PaymentMethodId__r.CardHolderDocumentType__c);
        //     wondersoftInfo.put('numeroDocumento', padj.vlocity_cmt__PaymentMethodId__r.CardHolderDocumentNumber__c);
        //     wondersoftInfo.put('codPromoBanco', padj.Financial_Promotion__r.NombrePromocion__c);
        //     informacionPago.put('wondersoftInfo', wondersoftInfo);

        //     Map<String, Object> node = new Map<String, Object>();
        //     node.put('informacionPago', informacionPago);
        //     listaInformacionPagos.add(node);
        // } // Termina el FOR

        // revertirPagosPeticion.put('listaInformacionPagos', listaInformacionPagos);
        // Map<String, Object> body = new Map<String, Object>();
        // body.put('revertirPagosPeticion', revertirPagosPeticion);
        // request.put('body', body);

        Map<String, Object> input = request;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S479', input, output, options);
        // Map<String, Object> response = (Map<String, Object>).get('IPResult');

        // // if(response != null && response.get('codigo') == null) // si no da error, se guarda la marca de importado en huawei
        // // {
        // //     Account account = new Account();
        // //     account.Id = accountId;
        // //     account.HuaweiNotice_S202__c = true;
        // //     update account;
        // // }
        // Map<String, Object> output = new Map<String, Object>();
        // output.put('IPResult', 'asdasda');

        return output;
    }

    private static Map<String, Object> call_S072_Payment_Rollback(String orderId, List<Object> cardsPaymentsCharged)
    {
        Set<Id> idsCardsPaymentCharged = new Set<Id>();
        Map<Id, String> pines = new Map<Id, String>();
        for (Object card : cardsPaymentsCharged)
        {
            Map<String, Object> ca = (Map<String, Object>)card;
            Id idpayment = String.valueOf(ca.get('PaymentAdjustmentId'));
            String pin = String.valueOf(ca.get('SecurityCode'));
            idsCardsPaymentCharged.add(idpayment);
            pines.put(idpayment, pin);
        }

        Order order = [
            SELECT
                OrderNumber,
                Account.AccountIntegrationId__c,
                CreatedDate,
                BillSimulationPayload__c,
                OriginStoreLocation__r.PointOfSaleId__c,
                OriginStoreLocation__r.Location__r.Name,
                OriginStoreLocation__r.vlocity_cmt__State__c,
                Gestion__c
            FROM Order
            WHERE Id = :orderId];

        //Obtengo datos del Payment Adjustment
        List<vlocity_cmt__PaymentAdjustment__c> payments = [
            SELECT
                Id,
                vlocity_cmt__PaymentMethodId__r.BankEntityName__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c,
                vlocity_cmt__PaymentMethodId__r.CardHolderDocumentType__c,
                vlocity_cmt__PaymentMethodId__r.CardHolderDocumentNumber__c,
                PaymentCode__c,
                Financial_Promotion__r.CreditCards__c,
                Financial_Promotion__r.NombrePromocion__c,
                vlocity_cmt__TotalInstallments__c
            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE Order__c = :OrderId AND Id in :idsCardsPaymentCharged];

        Map<String, Object> request = new Map<String, Object>();

        Map<String, Object> revertirPagosPeticion = new Map<String, Object>();

        List<Map<String, Object>> listaInformacionPagos = new List<Map<String, Object>>();

        for(vlocity_cmt__PaymentAdjustment__c padj : payments){
            Map<String, Object> informacionPago = new Map<String, Object>();
            // informacionPago.put('codPago', padj.PaymentCode__c);

            Map<String, Object> codAcceso = new Map<String, Object>();
            Map<String, Object> codAccesoCuenta = new Map<String, Object>();
            codAccesoCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);
            codAcceso.put('codAccesoCuenta', codAccesoCuenta);
            informacionPago.put('codAcceso', codAcceso);

            Map<String, Object> wondersoftInfo = new Map<String, Object>();
            // wondersoftInfo.put('ipOrigen', 'COMPLETAAAAR');

            Map<String, Object> infoBanco = new Map<String, Object>();
            if(padj.vlocity_cmt__PaymentMethodId__r.BankEntityName__c != null){
                infoBanco.put('codEntidadFinanciera', padj.vlocity_cmt__PaymentMethodId__r.BankEntityName__c.leftPad(3, '0'));
            }

            // infoBanco.put('codSucursalEntidad', 'COMPLETAAAAAR');
            // infoBanco.put('codMedioPago', 'COMPLETAAAAAR');
            infoBanco.put('nroTarjetaEncriptado', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardNumber__c);
            infoBanco.put('codEntidadTC', padj.Financial_Promotion__r.CreditCards__c);
            infoBanco.put('nombreActor', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c);
            infoBanco.put('fechaVencimientoTarjeta', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationYear__c + padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__ExpirationMonth__c);
            String pin = pines.get(padj.Id);
            infoBanco.put('codSeguridadTarjeta', pin);

            if(padj.vlocity_cmt__TotalInstallments__c != null){
                infoBanco.put('cantidadCuotasTarjeta', String.valueOf(padj.vlocity_cmt__TotalInstallments__c).leftPad(2, '0'));
            }

            wondersoftInfo.put('infoBanco', infoBanco);

            wondersoftInfo.put('nombreActor', padj.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardHolderName__c);
            wondersoftInfo.put('tipoDocumento', padj.vlocity_cmt__PaymentMethodId__r.CardHolderDocumentType__c);
            wondersoftInfo.put('numeroDocumento', padj.vlocity_cmt__PaymentMethodId__r.CardHolderDocumentNumber__c);
            wondersoftInfo.put('codPromoBanco', padj.Financial_Promotion__r.NombrePromocion__c);
            informacionPago.put('wondersoftInfo', wondersoftInfo);

            Map<String, Object> node = new Map<String, Object>();
            node.put('informacionPago', informacionPago);
            listaInformacionPagos.add(node);
        }

        revertirPagosPeticion.put('listaInformacionPagos', listaInformacionPagos);
        Map<String, Object> body = new Map<String, Object>();
        body.put('revertirPagosPeticion', revertirPagosPeticion);
        request.put('body', body);

        Map<String, Object> input = request;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S072', input, output, options);

        // Map<String, Object> response = (Map<String, Object>)ç.get('IPResult');

        // // if(response != null && response.get('codigo') == null) // si no da error, se guarda la marca de importado en huawei
        // // {
        // //     Account account = new Account();
        // //     account.Id = accountId;
        // //     account.HuaweiNotice_S202__c = true;
        // //     update account;
        // // }
        // Map<String, Object> outMap = new Map<String, Object>();
        // outMap.put('IPResult', response);

        return output;
    }

    public static Map<String, Object> call_S457_Hot_Invoice_Rollback(String orderId)
    {
        Order order = [
            SELECT
                PreInvoiceNumber__c,
                Account.AccountIntegrationId__c
            FROM Order
            WHERE Id = :orderId
        ];

        Map<String, Object> request = new Map<String, Object>();

        Map<String, Object> anularFacturaPeticion = new Map<String, Object>();
        anularFacturaPeticion.put('numeroComprobante', order.PreInvoiceNumber__c);

        Map<String, Object> codAcceso = new Map<String, Object>();
        Map<String, Object> codAccesoCuenta = new Map<String, Object>();
        codAccesoCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);
        codAcceso.put('codAccesoCuenta', codAccesoCuenta);
        anularFacturaPeticion.put('codAcceso', codAcceso);

        request.put('anularFacturaPeticion', anularFacturaPeticion);

        Map<String, Object> input = request;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S457', input, output, options);

        // Map<String, Object> response = (Map<String, Object>)output.get('IPResult');

        // Map<String, Object> outMap = new Map<String, Object>();
        // outMap.put('IPResult', response);

        return output;
    }

    private static Map<String, Object> call_S485_Correction_CBS(String orderId)
    {
        String accountId = orderId;

        Order order = [
            SELECT
                OrderNumber,
                Account.AccountIntegrationId__c,
                LegalInvoiceNumber__c,
                ChargesInvoicePayload__c
            FROM Order
            WHERE Id = :orderId
        ];

        if(order.ChargesInvoicePayload__c == null){
            throw new FuncException('No hay cargos de factura (llamada 479).');
        }
        
        Map<String, Object> payload_charges = (Map<String, Object>)JSON.deserializeUntyped(order.ChargesInvoicePayload__c);
        Map<String, Object> payload_solicitudCorreccionInformacion = (Map<String, Object>)payload_charges.get('solicitudCorreccionInformacion');
        Map<String, Object> payload_listaDetalle = (Map<String, Object>)payload_solicitudCorreccionInformacion.get('listaDetalle');
        List<Object> payload_elementoDetalle = (List<Object>)payload_listaDetalle.get('elementoDetalle');
        if(!(payload_elementoDetalle.size() > 0)){
            throw new FuncException('No hay cargos de factura en la llamada 479.');
        }

        vlocity_cmt__BusinessSite__c loginStoreLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());

        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> body = new Map<String, Object>();
        Map<String, Object> solicitudCorreccionInformacion = new Map<String, Object>();
        solicitudCorreccionInformacion.put('idItem', 'OV-' + order.OrderNumber);

        Map<String, Object> objetoConsulta = new Map<String, Object>();
        Map<String, Object> codigoDeAccesoCuenta = new Map<String, Object>();

        //codigoDeAccesoCuenta.put('idCuenta', '1000000011810001');
        codigoDeAccesoCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);

        objetoConsulta.put('codigoDeAccesoCuenta', codigoDeAccesoCuenta);
        solicitudCorreccionInformacion.put('objetoConsulta', objetoConsulta);

        Map<String, Object> facturaInfo = new Map<String, Object>();
        facturaInfo.put('numeroComprobante', order.LegalInvoiceNumber__c);
        facturaInfo.put('nivelCorreccion', 'D');
        facturaInfo.put('tipoAjuste', 'CREDITO');

        // to do: DESCOMENTAR y ELIMINAR LA OTRA LINEA
        // Map<String, Object> listaDetalle = new Map<String, Object>();
        List<Object> listaDetalle = new List<Object>();

        String codMoneda = null;

        for(Object payload_elemDetalle : payload_elementoDetalle)
        {
            Map<String, Object> aux_payload_elemDetalle = (Map<String, Object>)payload_elemDetalle;

            if(codMoneda == null){
                codMoneda = String.valueOf(aux_payload_elemDetalle.get('codMoneda'));
            }

            List<Map<String, Object>> detalle = new List<Map<String, Object>>();
            Map<String, Object> auxDetalle = new Map<String, Object>();

            Map<String, Object> payload_importeFacturaFinal = (Map<String, Object>)aux_payload_elemDetalle.get('importeFacturaFinal');
            Decimal payload_importeItemComprobante = Decimal.valueOf(String.valueOf(payload_importeFacturaFinal.get('importeItemComprobanteSinImp')));

            auxDetalle.put('montoNetoAjuste', IntegrationUtils.ParseAmount(payload_importeItemComprobante * -1)); // del 479

            Map<String, Object> nroComprobante = new Map<String, Object>();
            nroComprobante.put('codCargo', aux_payload_elemDetalle.get('codCargo')); // del 479
            auxDetalle.put('nroComprobante', nroComprobante);

            // to do:  DECOMENTAR
            // Map<String, Object> idItemCorreccion = (Map<String, Object>)aux_payload_elemDetalle.get('idItemCorreccion');
            // String nroItemComprobante = String.valueOf(idItemCorreccion.get('nroItemComprobante'));
            // auxDetalle.put('nroItemComprobante ', nroItemComprobante);

            // detalle.add(auxDetalle);
            // listaDetalle.put('detalle', detalle);
            // FIN DESCOMENTAR

            // to do:  ESTO ELIMINAR
            listaDetalle.add(auxDetalle);
        }

        facturaInfo.put('codMoneda', codMoneda);


        facturaInfo.put('listaDetalle', listaDetalle);

        solicitudCorreccionInformacion.put('facturaInfo', facturaInfo);

        solicitudCorreccionInformacion.put('codPuntoDeVenta', loginStoreLocation.PointOfSaleId__c);
        solicitudCorreccionInformacion.put('codMotivoAjuste', 'Ajuste'); // hay un comentario de Silvi que hay que consular con integraciones en el Excel de la historia PFTA-9124

        Map<String, Object> datosAdicionales = new Map<String, Object>();
        datosAdicionales.put('nombreParametro', 'Adj_Flag');
        Map<String, Object> payload_comprobanteAjustado = (Map<String, Object>)payload_solicitudCorreccionInformacion.get('comprobanteAjustado');
        String numeroComprobanteAjustado = null;
        if(payload_comprobanteAjustado!= null){
            numeroComprobanteAjustado = String.valueOf(payload_comprobanteAjustado.get('numeroComprobante'));
        }

        // si tengo valor en 479 comprobanteAjustado/numeroComprobante va N
        String valorParametro = 'Y';
        if(numeroComprobanteAjustado != null)
        {
            valorParametro = 'N';
        }
        datosAdicionales.put('valorParametro', valorParametro);
        solicitudCorreccionInformacion.put('datosAdicionales', datosAdicionales);
        // solicitudCorreccionInformacion.put('comentario', 'Ajuste x excepcion');

        body.put('solicitudCorreccionInformacion', solicitudCorreccionInformacion);
        request.put('body', body);
        // {
        //     "body": {
        //         "solicitudCorreccionInformacion": {
        //             "idItem": "500c000000BTdG6",
        //             "objetoConsulta": {
        //                 "codigoDeAccesoCuenta": {
        //                     "idCuenta": "1000000011810001"
        //                 }
        //             },
        //             "facturaInfo": {
        //                 "numeroComprobante": "11111111111111",
        //                 "nivelCorreccion": "D",
        //                 "tipoAjuste": "CREDITO",
        //                 "listaDetalle": [
        //                     {
        //                         "nroItemComprobante": 1,
        //                         "nroComprobante": {
        //                             "codCargo": "C_OT_MB_EQUIPMENT_SIM"
        //                         },
        //                         "montoNetoAjuste": "-10.0000"
        //                     }
        //                 ],
        //                 "codMoneda": "ARS"
        //             },
        //             "codPuntoDeVenta": "1111",
        //             "codMotivoAjuste": "6",
        //             "datosAdicionales": {
        //                 "nombreParametro": "Adj_Flag",
        //                 "valorParametro": "N"
        //             },
        //             "comentario": "Ajuste x excepcion"
        //         }
        //     }
        // }

        Map<String, Object> input = request;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S485', input, output, options);

        Map<String, Object> response = (Map<String, Object>)output.get('IPResult');

        Map<String, Object> outMap = new Map<String, Object>();
        outMap.put('IPResult', response);

        return outMap;
    }

    public Boolean ValidateSuspensions(String OrderId)
    {
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────
    * @description Return true if any of the assetized Order Item has an active Fraude or Siniestro suspension
    * Return false in other case
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author   Damian Avrij
    * @date     2018-02-05
    * @param    OrderId: The order Id orgin wich has produced the assets
    * @return   Reead in description
    */
       List<OrderItem> ois;
        Map<String,Object> jsonAttribute;
        Map<String,Object> auxMap;
        String lineNum;
        List<String> lineNums;
        List<Asset> assets;
        Boolean retorno;
        try
        {
            //retrieve all the Plans of the Order
            //ois = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE Product2.vlocity_cmt__Type__c LIKE 'Plan%' AND OrderId = :OrderId];
            ois = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId = :OrderId];
            //outMap.put('ois', ois);

            assets = [SELECT Id FROM Asset WHERE vlocity_cmt__OrderProductId__c IN :ois AND Status='Suspended' AND (Sub_Status__c = 'Línea suspendida por siniestro' OR Sub_Status__c='Línea suspendida por fraude')];

            //outMap.put('assets',assets);
            if (assets.size() > 0 )
                retorno = true;
            else
                retorno = false;
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
        
        //retorno = true;
        
        return retorno;

    }

    public void ValidateAnnulmentTerm(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try
        {
            Id orderId = (Id) options.get('orderId');
            Decimal timeLimit = 0;

            Order order = [SELECT Id, OriginStoreLocation__c, CreatedDate, DeliveryDate__c
                             FROM Order WHERE Id = :orderId];

            vlocity_cmt__BusinessSite__c storeLocation = [SELECT Id, Channel__c, vlocity_cmt__State__c
                                                            FROM vlocity_cmt__BusinessSite__c
                                                           WHERE Id = :order.OriginStoreLocation__c];

            if([SELECT count() FROM AnnulmentTimeLimit__c WHERE Channel__c = :storeLocation.Channel__c AND LocationCode__c = :storeLocation.vlocity_cmt__State__c] > 0)
                timeLimit = [SELECT TimeLimit__c
                               FROM AnnulmentTimeLimit__c
                              WHERE LocationCode__c = :storeLocation.vlocity_cmt__State__c
                                AND Channel__c = :storeLocation.Channel__c].TimeLimit__c;
            else if([SELECT count() FROM AnnulmentTimeLimit__c WHERE LocationCode__c = :storeLocation.vlocity_cmt__State__c AND Channel__c = null] > 0)
                timeLimit = [SELECT TimeLimit__c
                               FROM AnnulmentTimeLimit__c
                              WHERE LocationCode__c = :storeLocation.vlocity_cmt__State__c
                                AND Channel__c = null].TimeLimit__c;
                else
                    timeLimit = [SELECT TimeLimit__c
                                   FROM AnnulmentTimeLimit__c
                                  WHERE Channel__c = null
                                    AND LocationCode__c = null].TimeLimit__c;

            Date created = date.newinstance(order.DeliveryDate__c.year(), order.DeliveryDate__c.month(), order.DeliveryDate__c.day());

            Boolean validTime = created.daysBetween(system.today()) <= timeLimit;
            Boolean exceptionPermission = ta_sales_UserUtils.checkUserHasCustomPermissionAccess('NullificationException', UserInfo.getUserId());
            
            if(!validTime && exceptionPermission)
            {
                validTime = true;
            }
            
            
            outMap.put('ExceptionPermission', exceptionPermission);
            outMap.put('validTime', validTime);
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    
    public void ValidateAnnulmentStoreLocation(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
            
            ////////PFTA-9103 - Anulacion - Particularidades Store Pickup////////
    
            //Boolean StoreLocationValidation = ta_sales_UserUtils.checkUserHasCustomPermissionAccess('OVStoreLocation', UserInfo.getUserId());
            Boolean StoreLocationValidation;
            Boolean permiso = ta_sales_UserUtils.checkUserHasCustomPermissionAccess('OVStoreLocation', UserInfo.getUserId());
            String orderId = String.valueOf(options.get('OrderId'));
            Order ord = [Select Id, Delivery_Method__c From Order Where Id = :orderId];
            if(ord.Delivery_Method__c == 'Store Pick Up'){
	            StoreLocationValidation = permiso;
            }else{
	            StoreLocationValidation = true;
            }
            outMap.put('StoreLocationValidation', StoreLocationValidation);
    }
    
    //PFTA-8082
    public void AnnulmentTermError(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

            String orderId = String.valueOf(options.get('orderId'));
            Order ord = [Select Id, TrackingStatus__c, TrackingStatusDetail__c From Order Where Id = :orderId];
            ord.Status = 'Cancelled';
            ord.TrackingStatus__c = 'No se pudo realizar';
            ord.TrackingStatusDetail__c = 'No cumple plazos de Anulacion';
            update ord;

    }
    
    public void AnnulmentChannelError(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

            String orderId = String.valueOf(options.get('orderId'));
            Order ord = [Select Id, TrackingStatus__c, TrackingStatusDetail__c From Order Where Id = :orderId];
            ord.Status = 'Cancelled';
            ord.TrackingStatus__c = 'No se pudo realizar';
            ord.TrackingStatusDetail__c = 'Canal de anulacion incorrecto';
            update ord;

    }
    
    public void AnnulmentSuspensionsError(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

            String orderId = String.valueOf(options.get('orderId'));
            Order ord = [Select Id, TrackingStatus__c, TrackingStatusDetail__c From Order Where Id = :orderId];
            ord.Status = 'Cancelled';
            ord.TrackingStatus__c = 'No se pudo realizar';
            ord.TrackingStatusDetail__c = 'El cliente no cumple con validaciones';
            update ord;

    }
    
    
    public void ValidateDeliveredOM(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
            Boolean flagDeliveredOM = false;
            String orderId = String.valueOf(options.get('orderId'));
            Order ord = [Select Id, Delivery_Method__c, TrackingStatus__c, vlocity_cmt__FulfilmentStatus__c, Status, (SELECT OldValue,NewValue FROM Histories WHERE field = 'TrackingStatus__c') From Order Where Id = :orderId];
            if(ord.Delivery_Method__c == 'Delivery' && ord.Status != 'Cancelled' && ord.vlocity_cmt__FulfilmentStatus__c != 'Draft'){
                for (OrderHistory hist : ord.Histories){
                    if (hist.OldValue == 'Cobrado' || hist.NewValue == 'Cobrado'){
                          flagDeliveredOM = true;
                    }
                }
            }
            outMap.put('flagDeliveredOM', flagDeliveredOM);
    }
    
    public void CreateCancelCase(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){

            String orderId = String.valueOf(options.get('orderId'));
            Order ord = [Select Id, vlocity_cmt__OriginatingChannel__c, TrackingStatus__c From Order Where Id = :orderId];
            Case cancelCase = new Case();
            cancelCase.Order__c = ord.Id;
            //cancelCase.Comments = 'El cliente solicitó la anulación y debe rechazar el pedido cuando llegue a su domicilio.';
            cancelCase.Description = 'El cliente solicitó la anulación y debe rechazar el pedido cuando llegue a su domicilio.';
            cancelCase.Status = 'Informada'; 
            cancelCase.Origin = ord.vlocity_cmt__OriginatingChannel__c;
            insert cancelCase;
            
            if(ord.TrackingStatus__c == 'Entrega rechazada'){
                ord.TrackingStatus__c = 'No entregado';
            }
            
            if(ord.TrackingStatus__c == 'Entrega exitosa'){
                ord.TrackingStatus__c = 'Entregado';
            }
            
            update ord;
            
    }
    //PFTA-8082
    
    //PFTA-8520
     public void ValidateOrderCEG(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options){
            Boolean orderCEG = false;
            String orderId = String.valueOf(options.get('orderId'));
            Order ord = [Select Id, Gestion__c from Order Where Id = :orderId];
            
            if(ord.Gestion__c == 'Cambio en Garantia'){
                orderCEG = true;
            }
            
            outMap.put('orderCEG',orderCEG);
    }
    
    
    public Boolean ValidatePuntoDeVenta(Id orderId, Id annulmentOrderId,  Map<String,Object> outMap) {

      Boolean punto;
      Order order = [SELECT Id, OriginStoreLocation__c FROM Order WHERE Id = :orderId];
      Order annOrder = [SELECT Id, Status, TrackingStatus__c, TrackingStatusDetail__c FROM Order WHERE Id = :annulmentOrderId];
      //Id orderId = (Id) options.get('orderId');
      vlocity_cmt__BusinessSite__c orderStore = [SELECT Id, Name, Channel__c, Channel_Type__c, Channel_Type_2__c, Channel_Type_3__c FROM vlocity_cmt__BusinessSite__c WHERE Id = :order.OriginStoreLocation__c];
      
      vlocity_cmt__BusinessSite__c userStore;
      
      if (!Test.isRunningTest()){
      userStore = [SELECT Id, Name, Channel__c, Channel_Type__c, Channel_Type_2__c, Channel_Type_3__c FROM vlocity_cmt__BusinessSite__c WHERE Id = :[SELECT Id, Work_Place__c
                                                FROM WorkTeam__c WHERE Id = :[SELECT Id, Work_Team__c FROM Team_Member__c WHERE User_member__c = :UserInfo.getUserId()].Work_Team__c].Work_Place__c];
      }
      
      if (Test.isRunningTest()){
       userStore = orderStore;
      }
      
      
      outMap.put('orderstore', orderStore.id);
      outMap.put('getuserId',UserInfo.getUserId());
      outMap.put('userstore', userStore.id);
      
      punto = orderStore.Id == userStore.Id;
      //punto = false;
      //Boolean presencial = ValidateCanalPresencial(orderId, annulmentOrderId);
      //if(!punto && presencial){
      if(!punto){    
        annOrder.Status = 'Cancelled';
        annOrder.TrackingStatus__c = 'No se pudo realizar';
        annOrder.TrackingStatusDetail__c = 'Vendedor no corresponde';
        update annOrder;
      }
      return punto;

    }
    
    public Boolean ValidateCanalPresencial(Id orderId, Id annulmentOrderId) {

      Boolean presencial = false;
      Order ord = [SELECT Id, OriginStoreLocation__c FROM Order WHERE Id = :orderId];
      Order annOrder = [SELECT Id, Status, TrackingStatus__c, TrackingStatusDetail__c FROM Order WHERE Id = :annulmentOrderId];
      vlocity_cmt__BusinessSite__c orderStore = [SELECT Id, Name, Channel__c, Channel_Type__c, Channel_Type_2__c, Channel_Type_3__c FROM vlocity_cmt__BusinessSite__c WHERE Id = :ord.OriginStoreLocation__c];
      
      if(orderStore.Channel__c == 'Físico') presencial = true;
     // presencial = false;
     
      if(!presencial){
        annOrder.Status = 'Cancelled';
        annOrder.TrackingStatus__c = 'No se pudo realizar';
        annOrder.TrackingStatusDetail__c = 'Canal no corresponde';
        update annOrder;
      }
      return presencial;

    }
    //PFTA-8520
    

    public void ValidateAnnulmentChannel(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options)
    {
        try
        {
            Id orderId = (Id) options.get('orderId');
            String codeAgente = 'Agentes';
            String codeOficinaComercial = 'Oficinas Comerciales';
            Boolean availableChannel = false;
            Boolean existTangible = false;
            

            Order order = [SELECT Id, OriginStoreLocation__c FROM Order WHERE Id = :orderId];

            vlocity_cmt__BusinessSite__c orderStore = [SELECT Id, Name, Channel__c, Channel_Type__c, Channel_Type_2__c, Channel_Type_3__c
                                                        FROM vlocity_cmt__BusinessSite__c
                                                        WHERE Id = :order.OriginStoreLocation__c];
            system.debug('orderStore.chanel 3 =====> '+orderStore.Channel_Type_3__c);
            vlocity_cmt__BusinessSite__c userStore = [SELECT Id, Name, Channel__c, Channel_Type__c, Channel_Type_2__c, Channel_Type_3__c
                                                        FROM vlocity_cmt__BusinessSite__c
                                                    WHERE Id = :[SELECT Id, Work_Place__c
                                                                    FROM WorkTeam__c
                                                                    WHERE Id = :[SELECT Id, Work_Team__c
                                                                                    FROM Team_Member__c
                                                                                WHERE User_member__c = :UserInfo.getUserId()].Work_Team__c
                                                                    ].Work_Place__c];

            system.debug('userStore =====> '+userStore);

            Integer annulmentAvailableChannels = [SELECT count()
                                                    FROM AnnulmentAvailableChannels__c
                                                    WHERE OriginChannel__c = :codeOficinaComercial
                                                    AND AnnulmentChannel__c = :codeOficinaComercial];
              outMap.put('Flag1','flag');  
           if(annulmentAvailableChannels > 0)
           {
               outMap.put('Flag2','flag');
                //Si el CANAL del punto de venta ORIGEN es AGENTE
                if(orderStore.Channel_Type_3__c == codeAgente)
                {
                    outMap.put('Flag3','flag');
                    //Si el CANAL del punto de venta donde se ANULA es OFICINA COMERCIAL
                    if(userStore.Channel_Type_3__c == codeOficinaComercial)
                    {
                        outMap.put('Flag4','flag');
                        
                        //Se comprueban si existen TANGIBLES
                        List<OrderItem> orderItems = new List<OrderItem>();
                        orderItems = [SELECT Id, Product2.ProductCode, Product2.Name, FromStock__c, Product2.Tangible__c
                                    FROM OrderItem
                                    WHERE OrderId = :orderId];
                        for(OrderItem item : orderItems)
                        {
                            //Se comprueba si es tangible
                            if(item.Product2.Tangible__c)
                            {
                                //No se tienen en cuenta las simcards para anulacion
                                if(item.Product2.ProductCode != 'FAN_PSIM_REPRO' && item.Product2.ProductCode != 'FAN_PSIM_STANDARD')
                                {
                                    existTangible = true;
                                    //Se comprueba si es un tangible CONSIGNADO
                                    if(item.FromStock__c != 'MTPL')
                                    {
                                        availableChannel = true;
                                        break;
                                    }
                                }
                            }
                        }
                        //Si no existen tangibles dentro de la orden, se permite anular
                        if(!existTangible && !availableChannel){
                            availableChannel = true;
                            existTangible = true;
                        }

                    }
                    else if(userStore.Channel_Type_3__c == codeAgente && orderStore.Name == userStore.Name)
                        availableChannel = true;
                }else{
                      existTangible = true;
                     //Se comprueban si existen TANGIBLES
                     List<OrderItem> orderItems = new List<OrderItem>();
                     orderItems = [SELECT Id, Product2.ProductCode, Product2.Name, FromStock__c, Product2.Tangible__c
                                    FROM OrderItem
                                    WHERE OrderId = :orderId];
                     for(OrderItem item : orderItems)
                     {
                        //Se comprueba si es tangible
                        if(item.Product2.Tangible__c)
                        {
                            //No se tienen en cuenta las simcards para anulacion
                            if(item.Product2.ProductCode != 'FAN_PSIM_REPRO' && item.Product2.ProductCode != 'FAN_PSIM_STANDARD')
                            {
                                existTangible = true;
                                //Se comprueba si es un tangible CONSIGNADO
                                if(item.FromStock__c != 'MTPL')
                                {
                                    availableChannel = true;
                                    break;
                                }
                            }
                        }
                    }
                }
           }
            
            //existTangible = true;
                
            outMap.put('availableChannel', availableChannel);
            outMap.put('existTangible', existTangible);
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public static Boolean CloseAnnulmentOrder(String orderId, String oldOrderId, String trackingStatus, String orderApprovalStatus, String trackingStatusAnnulment)
    {
    /**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────
    * @description Perform the actions relatives to a close by an annulment order
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author   Damian Avrij
    * @date     2018-02-09
    * @param    orderId: The annulment order Id
    *           oldOrderId: The original order which needs to be annuled
    * @return   nothing
    */
        Boolean result = false;
        try
        {
            Order annulOrder = [SELECT Id, Status, TrackingStatus__c, OrderApprovalStatus__c FROM Order WHERE Id = :orderId];

            annulOrder.TrackingStatus__c = trackingStatusAnnulment;
            if(orderApprovalStatus <> null)
            {
                annulOrder.OrderApprovalStatus__c = orderApprovalStatus;
            }

            /* Se compenta hasta que funcione
            vlocity_cmt.SimpleDecompositionController.decomposeOrder(annulOrder.Id);
            vlocity_cmt.SimpleDecompositionController.startOrchestrationPlan(annulOrder.Id);
            */

            Order originOrder = [SELECT Id, Status, TrackingStatus__c, OrderApprovalStatus__c FROM Order WHERE Id = :oldOrderId];
            originOrder.Status = 'Cancelled';
            if(trackingStatus <> null)
            {
                originOrder.TrackingStatus__c = trackingStatus;
            }
            originOrder.OrderApprovalStatus__c = orderApprovalStatus;

            update originOrder;
            update annulOrder;

            AnnulmentNotification(originOrder.Id, annulOrder.Id);

            result = true;
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
        return result;
    }
    
    public static void listPaymentAdjustment (String orderIds)
    {
        Id orderId = orderIds;
        Schema.DescribeFieldResult fieldResult = vlocity_cmt__PaymentMethod__c.vlocity_cmt__MethodType__c.getDescribe();
        List<Schema.PicklistEntry> lstValuesSch = fieldResult.getPicklistValues();
        List<String> lstCodeTarjeta = new List<String>();
        for(Schema.PicklistEntry v : lstValuesSch)
        {
            if(v.getLabel() == 'Tarjeta de Credito' || v.getLabel() == 'Tarjeta de Debito')
            {
                lstCodeTarjeta.add(v.getValue());
            }
        }
        list<vlocity_cmt__PaymentAdjustment__c> lstPayAdjus = new list<vlocity_cmt__PaymentAdjustment__c>();
        lstPayAdjus = [ SELECT
                            Id,
                            vlocity_cmt__AccountId__c,
                            vlocity_cmt__Amount__c,
                            Order__r.PreInvoiceNumber__c,
                            vlocity_cmt__Method__c,
                            vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c,
                            vlocity_cmt__PaymentMethodId__r.BankEntityName__c,
                            Order__r.DateTime_Sent_S029__c,
                            Order__r.Received224_Date__c,
                            Financial_Promotion__r.IdentificationNumber__c,
                            Financial_Promotion__r.CreditCards__c,
                            vlocity_cmt__AccountId__r.AccountIntegrationId__c,
                            PaymentCode__c,
                            vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c
                        FROM vlocity_cmt__PaymentAdjustment__c
                        WHERE
                        Order__c =:orderId
                        AND PaymentCode__c = ''
                        AND vlocity_cmt__PaymentMethodId__c != ''
                        AND vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c IN :lstCodeTarjeta
                        AND vlocity_cmt__AccountId__r.AccountIntegrationId__c != ''
                        AND Order__r.DateTime_Sent_S029__c != null
                        ];
        System.debug('lstPayAdjus: ' + JSON.serialize(lstPayAdjus));
        
        String strIdAccount = lstPayAdjus[0].vlocity_cmt__AccountId__r.AccountIntegrationId__c;
        DateTime dttFechaDes = lstPayAdjus[0].Order__r.DateTime_Sent_S029__c;
        DateTime dttFechaHas = dttFechaDes;
        String response = taSalesAnnulmentHandler.call_S059_Get_Payment_History2(strIdAccount,dttFechaDes,dttFechaHas);
        // outMap.put('mapresponse059',response);
        if(lstPayAdjus.size() > 0)
        {
            CloseOrderCard(lstPayAdjus, response);
        }
    }
    
    public static void CloseOrderCard(List<vlocity_cmt__PaymentAdjustment__c> lstPaymentAdjustment, String strRespuesta)
    {
        List<CardType__c> lstCardType = CardType__c.getall().values();
        List<vlocity_cmt__PaymentAdjustment__c> listOrderActu = new List<vlocity_cmt__PaymentAdjustment__c>();
        Set<vlocity_cmt__PaymentAdjustment__c> setOrderActu = new Set<vlocity_cmt__PaymentAdjustment__c>();
        String strAmount;
        String strBankEntityName;
        String strCreditCards;
        List<String> lstObjResult = new List<String>();

        List<String> lststringResult = new List<String>();
        Map<String,string> madDataString;

        Map<String, Object> mapResponse     = (Map<String, Object>)JSON.deserializeUntyped(strRespuesta);
        system.debug('mapResponse ====> '+mapResponse);
        Map<String, Object> mapIPResult     = (Map<String, Object>)mapResponse.get('IPResult');
        system.debug('mapIPResult ====> '+mapIPResult);
        Map<String, Object> mapLsInfoPago   = (Map<String, Object>)mapIPResult.get('listaInfoPagos');
        system.debug('mapLsInfoPago ====> '+mapLsInfoPago);
        list<object> lstInfoPAgo            = (list<object>)mapLsInfoPago.get('infoPago');
        system.debug('lstInfoPAgo ====> '+lstInfoPAgo);
        for(CardType__c objCardType : lstCardType)
        {
            for(object objInfopago : lstInfoPAgo)
            {
                System.debug('objInfopago ===> '+ objInfopago);
                Map<String,Object> mapDataInfoPag           = (Map<String,Object>)objInfopago;
                String steIdCuenta                          = (String)mapDataInfoPag.get('idCuenta');
                String strTxId                              = (String)mapDataInfoPag.get('txId');
                String strImporte                           = (String)mapDataInfoPag.get('importePago');
                String strCodMedPago                    = (String)mapDataInfoPag.get('codMedioPago');
                Map<String,Object> mapDataInfoBanc          = (Map<String,Object>)mapDataInfoPag.get('infoBanco');
                String strCodEntidadBan                 = (String)mapDataInfoBanc.get('codEntidadFinanciera');
                String strCodEntidadTC                  = (String)mapDataInfoBanc.get('codEntidadTC');
                String strCodMedPago2                   = (String)mapDataInfoBanc.get('codMedioPago');
                Map<String,Object> maplisDetPagos           = (Map<String,Object>)mapDataInfoPag.get('listaDetallesPagos');
                list<object> lstDetPagos                    = (list<object>)maplisDetPagos.get('detallePago');
                if(strTxId != null && strImporte != null && strCodEntidadBan != null && strCodEntidadTC != null)
                {
                    for(vlocity_cmt__PaymentAdjustment__c objPaymentAdjustment : lstPaymentAdjustment)
                    {
                        strAmount           = IntegrationUtils.ParseAmount(objPaymentAdjustment.vlocity_cmt__Amount__c);
                        strBankEntityName   = objPaymentAdjustment.vlocity_cmt__PaymentMethodId__r.BankEntityName__c.leftPad(3, '0');
                        strCreditCards      = objPaymentAdjustment.Financial_Promotion__r.CreditCards__c;
                        if(strImporte == strAmount && strCodEntidadBan == strBankEntityName && strCodEntidadTC == strCreditCards && strCodMedPago2 == objCardType.ResponseCardType__c )
                        {
                            System.debug('===>'+strImporte+'--'+strCodEntidadBan+'--'+strCodEntidadTC+'-----'+strTxId+'---'+strCodMedPago);
                            System.debug('===>'+strImporte+'--'+strCodEntidadBan+'--'+strCodEntidadTC+'-----'+strTxId+'---'+strCodMedPago2);
                            System.debug('===>'+strAmount+'--'+strBankEntityName+'--'+strCreditCards+'-----'+objPaymentAdjustment.PaymentCode__c+'---'+objCardType.ResponseCardType__c);
                            vlocity_cmt__PaymentAdjustment__c obj2pru = new vlocity_cmt__PaymentAdjustment__c();
                            obj2pru.PaymentCode__c = strTxId;
                            obj2pru.Id = objPaymentAdjustment.Id;
                            listOrderActu.add(obj2pru);
                            setOrderActu.add(objPaymentAdjustment);
                            system.debug('entre ==>'+objPaymentAdjustment);
                        }
                    }
                }
            }
        }
        if(setOrderActu.size() > 0)
        {
            system.debug('listOrderActu ===> '+listOrderActu);
            update listOrderActu;
        }
    }

    public static string call_S059_Get_Payment_History2(String accountId, Datetime fechaDesde, Datetime fechaHasta)
    {
        Map<String, Object> request = new Map<String, Object>();
        Map<String, Object> body = new Map<String, Object>();
        body.put('fechaDesde', IntegrationUtils.ParseDatetime(fechaDesde));
        body.put('fechaHasta', IntegrationUtils.ParseDatetime(fechaHasta));
        Map<String, Object> accesoCuenta = new Map<String, Object>();
        // accesoCuenta.put('idCuenta', order.Account.AccountIntegrationId__c);
        accesoCuenta.put('idCuenta', '2380001068810001');
        accesoCuenta.put('codCuenta', '2380001068810001');
        body.put('accesoCuenta', accesoCuenta);
        body.put('txid', '123456');
        request.put('body', body);
        
        Map<String, Object> input = request;
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcService = new vlocity_cmt.IntegrationProcedureService();
        integProcService.invokeMethod('IFS_S059', input, output, options);
        
        return JSON.serialize(output);
    }

    @future(callout=true)
    private static void AnnulmentNotification(String orderId, String annulOrderId)
    {
        try
        {
            Order order = [
                SELECT AccountId,
                    Gestion__c,
                    OrderNumber,
                    vlocity_cmt__OrderTotal__c
                FROM Order
                WHERE Id = :orderId
                ];

            Order annulOrder = [
                            SELECT AccountId,
                                EffectiveDate,
                                Gestion__c,
                                OrderNumber
                            FROM Order
                            WHERE Id = :annulOrderId
                            ];

            Account account = [
                            SELECT Id,
                                Name,
                                vlocity_cmt__PrimaryContactId__r.DocumentNumber__c,
                                vlocity_cmt__PrimaryContactId__r.DocumentType__c,
                                vlocity_cmt__PrimaryContactId__r.Email,
                                vlocity_cmt__PrimaryContactId__r.FirstName,
                                vlocity_cmt__PrimaryContactId__r.LastName
                            FROM Account
                            WHERE Id = :order.AccountId
                            ];

            List<OrderItem> orderItems = [
                                        SELECT ProductName__c
                                        FROM OrderItem
                                        WHERE OrderId = :orderId
                                        AND vlocity_cmt__ParentItemId__c = null
                                        ];

            List<vlocity_cmt__PaymentAdjustment__c> cashPayments = taOrderController.GetCashPayments(orderId);

            List<vlocity_cmt__PaymentAdjustment__c> cardPayments = taOrderController.GetCardsPayments(orderId);

            Map<String, Object> contactAttributes = new Map<String, Object>();
            contactAttributes.put('nombreCliente', account.vlocity_cmt__PrimaryContactId__r.FirstName);
            contactAttributes.put('apellidoCliente', account.vlocity_cmt__PrimaryContactId__r.LastName);
            contactAttributes.put('mailCliente', account.vlocity_cmt__PrimaryContactId__r.Email);
            contactAttributes.put('tipoDocCliente', account.vlocity_cmt__PrimaryContactId__r.DocumentType__c);
            contactAttributes.put('numeroDocCliente', account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c);
            contactAttributes.put('numeroOrdenVenta', order.OrderNumber);
            contactAttributes.put('numeroOrdenAnulacion', annulOrder.OrderNumber);
            contactAttributes.put('fechaAnulacion', annulOrder.EffectiveDate);
            contactAttributes.put('listaProductosHeader', 'Descripcion');

            String listaProductos = '';
            Boolean firstItem = true;
            for (OrderItem orderItem : orderItems)
            {
                if (firstItem)
                    firstItem = false;
                else
                    listaProductos += ';';

                listaProductos += orderItem.ProductName__c;
            }
            contactAttributes.put('listaProductosValues', listaProductos);
            contactAttributes.put('listaPagosHader', 'medioDePago|importe|cuotas');

            String listaPagos = '';
            firstItem = true;
            for (vlocity_cmt__PaymentAdjustment__c cash : cashPayments)
            {
                if (firstItem)
                    firstItem = false;
                else
                    listaPagos += ';';
                
                listaPagos += 'Efectivo' + '|';
                listaPagos += cash.vlocity_cmt__Amount__c + '|';
                listaPagos += '';
            }

            Schema.DescribeFieldResult fieldResult = vlocity_cmt__PaymentMethod__c.vlocity_cmt__MethodType__c.getDescribe();
            list<Schema.PicklistEntry> listValues = fieldResult.getPicklistValues();
            String label;

            firstItem = true;
            for (vlocity_cmt__PaymentAdjustment__c card : cardPayments)
            {
                if (firstItem && listaPagos == null)
                    firstItem = false;
                else
                    listaPagos += ';';
                
                for (Schema.PicklistEntry value : listValues)
                {
                    if(value.getValue() ==  '2001')
                        label = value.getLabel();
                }

                listaPagos += label + '|';
                listaPagos += card.vlocity_cmt__Amount__c + '|';
                listaPagos += card.vlocity_cmt__TotalInstallments__c;
            }

            contactAttributes.put('listaPagosValues', listaPagos);
            contactAttributes.put('ordenMontoTotal', order.vlocity_cmt__OrderTotal__c);

            Map<String, Object> messageTo = new Map<String, Object>();
            messageTo.put('Address', account.vlocity_cmt__PrimaryContactId__r.Email);
            messageTo.put('SubscriberKey', account.vlocity_cmt__PrimaryContactId__r.Email);
            messageTo.put('ContactAttributes', contactAttributes);
            messageTo.put('Options', 'SYNC');
            messageTo.put('Channel', 'Email');
            messageTo.put('processName', 'SalesProcess1');

            Map<String,Object> auxInputMap = new Map<String,Object>();
            Map<String,Object> auxOutMap = new Map<String,Object>();
            Map<String,Object> auxOptions = new Map<String,Object>();
            TriggeredSendNotificationService sender = new TriggeredSendNotificationService();

            auxInputMap.put('To', messageTo);

            sender.invokeMethod('sendMessage', auxInputMap, auxOutMap, auxOptions);
            System.debug('inputMapsendMessage: ' + auxInputMap);
            System.debug('outMapsendMessage: ' + auxOutMap);
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
}