global with sharing class taOrderController implements vlocity_cmt.VlocityOpenInterface {

    public class ServiceException extends Exception {}
    public static final String PENDIENTE_ARMADO_NOTIFICATION = 'OrderNotification-Pendiente-Armado';
    public static final String PENDIENTE_ENTREGA_NOTIFICATION = 'OrderNotification-Pendiente-Entrega';
    public static final String INSTANCE_VENTA_NORMAL = 'VTAN';
    public static final String INSTANCE_ANULAR_RESERVA = 'ANULARESERVA';
    static final String COD_PRODUCTO_ENVIO_BASE = 'FAN_ENV_000';

    public String valor { get; set; }
    public String ipOrigin { get; set; }

    private Integer count = 0; 

    Public taOrderController() {
        if(ApexPages.currentPage() !=  null) {
            System.debug('replace ipOrigin');
            ipOrigin=ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        }

        System.debug('X-Salesforce-SIP: '+ipOrigin);
    }

    //Constructor para utilizar la clase como controller extension
    Public taOrderController (ta_techCare_technical_service_controller sttController){}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try {
            if (methodName.equals('OrderPreparationUpdate')) {
                OrderPreparationUpdate(inputMap, outMap, options);
            }

            if (methodName.equals('OrderHandOverUpdate')) {
                OrderHandOverUpdate(inputMap, outMap, options);
            }

            if (methodName.equals('GetProductNMU')) {
                GetProductNMU(inputMap, outMap, options);
            }

            if (methodName.equals('GetPointOfSaleWarehouse')) {
                GetPointOfSaleWarehouse(inputMap, outMap, options);
            }

            if (methodName.equals('DeleteOrder')) {
                DeleteOrder(inputMap, outMap, options);
            }

            if (methodName.equals('CancelOrder')) {
                CancelOrder(inputMap, outMap, options);
            }

            if (methodName.equals('CancelOrderAndRelease')) {
                CancelOrderAndRelease(inputMap, outMap, options);
            }

            if (methodName.equals('GetManageableIdentityValidation')) {
                GetManageableIdentityValidation(inputMap, outMap, options);
            }

            if (methodName.equals('GetPaymentsAdjustments')) {
                GetPaymentsAdjustments(inputMap, outMap, options);
            }

            if (methodName.equals('ValidateTelecomNumbers')) {
                ValidateTelecomNumbers(inputMap, outMap, options);
            }

            if (methodName.equals('CanUseBalanceDiscount')) {
                CanUseBalanceDiscount(inputMap, outMap, options);
            }

            /*if (methodName.equals('GetCreditReChargeAmmount')) {
                GetCreditReChargeAmmount(inputMap, outMap, options);
            }*/

            if (methodName.equals('GetMACDRequestDate')) {
                List<Object> lAssetOIds = (List<Object>) inputMap.get('assetIdList');
                system.debug('lAssetOIds ====> '+lAssetOIds);
                List<String> lAssetIds = new List<String>();
                for(Object i : lAssetOIds) {
                    lAssetIds.add((String) i);
                }
                //Date retDate = GetMACDRequestDate((String) options.get('AssetId'), lAssetIds, outMap);
                Date retDate = GetMACDRequestDate((String) inputMap.get('ContextId'), lAssetIds);
                System.debug('retDate: ' + retDate);
                outMap.put('RequestDate', retDate);
            }

            if (methodName.equals('CreateMACD')) {
                /*
                List<Object> lAssetOIds = (List<Object>) inputMap.get('assetIdList');
                String cId = (String) inputMap.get('ContextId');
                String aId = (String) inputMap.get('accountId');
                List<String> lAssetIds = new List<String>();
                for(Object i : lAssetOIds){
                    lAssetIds.add((String) i);
                }
                //Date retDate = GetMACDRequestDate((String) options.get('AssetId'), lAssetIds, outMap);
               Boolean canC = CreateMACD(aId, cId, lAssetIds);
               outMap.put('canCreateFDO', canC);
               */
               CreateMACD2(inputMap, outMap, options);
            }

            if(methodName.equals('UpdateOrderCreditRefillSOS')) {
                UpdateOrderCreditRefillSOS(inputMap, outMap, options);
            }

            if(methodName.equals('ValidateTangibleExistence')) {
                String orderId = String.ValueOf(options.get('orderId'));
                System.debug('orderId: ' + orderId);
                outMap.put('hasTangibles', ValidateTangibleExistence(orderId));
            }

            if(methodName.equals('DeleteCartItem')) {
                Map<String, Object> request = (Map<String, Object>)options.get('deleteCartItemRequest');
                System.debug('options: ' + JSON.serialize(request));
                // outMap.put('hasTangibles', ValidateTangibleExistence(orderId));

                outMap = deleteCartItem(request);
            }

            // PFTA-7756 - INI
            if (methodName.equals('AddToCartItemsDelivery')) {
                AddToCartItemsDelivery(inputMap, outMap, options);
            }

            if (methodName.equals('AddToCartItemsDeliveryChild')) {
                AddToCartItemsDeliveryChild(inputMap, outMap, options);
            }

            if (methodName.equals('DeleteCartItemsDelivery')) {
                DeleteCartItemsDelivery(inputMap, outMap, options);
            }

            if (methodName.equals('DeleteCartItemsDeliveryChild')) {
                DeleteCartItemsDeliveryChild(inputMap, outMap, options);
            }
            // PFTA-7756 - FIN

            result = false;
        }
        catch(Exception e) {
            System.debug('taOrderController:invokeMethod -> exception: ' + e);
            result = false;
        }

        return result;
    }

    void CancelOrder(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('CancelOrder');
        try {
            String orderId = (String) options.get('orderId');
            AnulaStockReserved(orderId);
            RealeaseNmuReserve(orderId);
            CancelOrder(orderId);
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    void DeleteOrder(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('DeleteOrder');
        try {
            String orderId = (String) options.get('orderId');
            Order order = new Order();
            order.Id = orderId;
            delete order;
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    void OrderPreparationUpdate(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('OrderPreparationUpdate');
        try {
            String orderId = (String) options.get('idOrder');
            String channel = (String) options.get('Channel');
            String deliveryMethod = (String) options.get('DeliveryMethod');
            if(deliveryMethod == 'Store Pick Up' && channel == 'Agentes')
                UpdateOrderStatus(orderId, 'Entregado');
            else
            {
                UpdateOrderStatus(orderId, 'Pendiente de Entrega');
                DeleteTasks(orderId, PENDIENTE_ARMADO_NOTIFICATION);
                CreateStateTask(orderId, PENDIENTE_ENTREGA_NOTIFICATION);
            }
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    void OrderHandOverUpdate(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('OrderHandOverUpdate');
        try {
            String orderId = (String) options.get('idOrder');
            String storePickUp = (String) options.get('StorePickUp');
            Order order = [SELECT Delivery_Method__c, Gestion__c, OriginStoreLocation__r.AssociatedWarehouseId__c FROM Order where Id = :orderId];
            String codDeposito = order.OriginStoreLocation__r.AssociatedWarehouseId__c;
            if (order.Gestion__c == 'Cambio en Garantia')
            {
                CegStockMovement(orderId);
                UpdateOrderStatus(orderId, 'Entregado');
                DeleteTasks(orderId, PENDIENTE_ENTREGA_NOTIFICATION);
            }
            else
            {
                List<OrderItem> orderItems = taOrderController.GetOrderSerials(orderId);
                Map<String,String> serialNumbersToDeliver = new Map<String,String>();
                for(OrderItem item : orderItems) serialNumbersToDeliver.put(item.vlocity_cmt__SerialNumber__c, null);
                taOrderController.MoveSerialsStock('VTAN', 'FACTURA', serialNumbersToDeliver, order.OriginStoreLocation__r.AssociatedWarehouseId__c, order.Delivery_Method__c);
                UpdateOrderStatus(orderId, 'Entregado');
                DeleteTasks(orderId, PENDIENTE_ENTREGA_NOTIFICATION);
            }
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            throw e;
        }
    }

    public void CegStockMovement(Id cegOrderId) {
        try {
            Order order = [SELECT Delivery_Method__c, SubGestion__c, Gestion__c, OriginStoreLocation__r.AssociatedWarehouseId__c FROM Order WHERE Id = :cegOrderId];//Se obtiene el tipo de CEG
            List<OrderItem> orderItems = taOrderController.GetOrderSerials(cegOrderId);
            /*List<Order> orders = [SELECT Delivery_Method__c, SubGestion__c, Gestion__c, OriginStoreLocation__r.AssociatedWarehouseId__c FROM Order WHERE Id IN :cegOrderIds];//Se obtiene el tipo de CEG
            Map<Id, Order> ordersMap = new Map<Id, Order>(orders);
            List<OrderItem> orderItems = taOrderController.GetOrderSerials(cegOrderIds);
            Map<Id, OrderItem> ordersItemsMap = new Map<Id, OrderItem>(orderItems);
            */
            Set<Id> assetsIds = new Set<Id>();
            for(OrderItem item : orderItems)
                if (item.vlocity_cmt__AssetId__c != null) assetsIds.add(item.vlocity_cmt__AssetId__c);
            List<AssetHistory> assetHistoryList = [SELECT CreatedDate, NewValue, OldValue FROM AssetHistory WHERE AssetId in :assetsIds AND Field = 'imei__c' AND IsDeleted = false ORDER BY CreatedDate];
            Map<Id,String> assetHistoryMap = new Map<Id,String>();
            for(AssetHistory item : assetHistoryList)
            {
                assetHistoryMap.put(item.AssetId,(String)item.OldValue);
            }
            Map<String,String> serialNumbersToDeliver = new Map<String,String>();//Por ahora limitado a presencial
            Map<String,String> serialNumbersForReturn = new Map<String,String>();
            for(OrderItem item : orderItems){
                if (item.vlocity_cmt__Action__c == 'Disconnect')
                {
                    //List<AssetHistory> assetHistoryList = [SELECT CreatedDate, NewValue, OldValue FROM AssetHistory WHERE AssetId = :item.vlocity_cmt__AssetId__c AND Field = 'imei__c' AND IsDeleted = false ORDER BY CreatedDate DESC];
                    //if (assetHistoryList.size() > 1) item.vlocity_cmt__SerialNumber__c = (String) assetHistoryList.get(0).OldValue;
                    String serialCAPLA = (String) assetHistoryMap.get(item.vlocity_cmt__AssetId__c);
                    if(String.isNotBlank(serialCAPLA)) item.vlocity_cmt__SerialNumber__c = serialCAPLA;
                    if (order.SubGestion__c != 'Ley de defensa del consumidor') item.FromStock__c = null;
                    serialNumbersForReturn.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                }
                else
                    serialNumbersToDeliver.put(item.vlocity_cmt__SerialNumber__c, null);
            }
            CegStockMovement(serialNumbersForReturn, serialNumbersToDeliver, order.SubGestion__c, order.OriginStoreLocation__r.AssociatedWarehouseId__c, order.Delivery_Method__c);
        }
        catch(ServiceException sEx) {
            throw sEx;
        }
        catch(Exception ex) {
            System.debug('taOrderController:MoveSerialsStock -> exception: '+ex);
            System.debug('Exception Stack Trace: ' + ex.getStackTraceString());
            throw new ServiceException('Error al realizar el movimiento de stock');
        }
    }

    public void CegStockMovement(Map<String,String> serialNumbersForReturn, Map<String,String> serialNumbersToDeliver, String cegMotive, String codDeposito, String deliveryMethod) {
        String operation, instance;
        Boolean serialReturnMade = false;
        try {
            //Devolucion CEG
            if (cegMotive == 'Ley de defensa del consumidor'){
                operation = 'ANUV';
                instance = 'ANULAVENTA';
            }
            else
            {
                operation = 'DEVG';
                instance = 'FACTURA';
            }
            taOrderController.MoveSerialsStock(operation, instance, serialNumbersForReturn, codDeposito, 'NOAPLICA');
            serialReturnMade = true;
            taOrderController.MoveSerialsStock('VTAN', 'FACTURA', serialNumbersToDeliver, codDeposito, deliveryMethod);
        }
        catch(Exception e) {
            if (serialReturnMade)
                taOrderController.MoveSerialsStock('ANUG', 'ANULADEVOLUCION', serialNumbersForReturn, codDeposito, 'NOAPLICA');
            System.debug('taOrderController:MoveSerialsStock -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw new ServiceException('Error al realizar el movimiento de stock');
        }
    }

    void GetProductNMU(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('GetProductNMU');
        try {
            String productCode = (String) options.get('ProductCode');
            System.debug('Product Code:'+productCode);
            Product2 product = [SELECT vlocity_cmt__JSONAttribute__c FROM Product2 WHERE ProductCode = :productCode];
            String NMU = GetNMU(product.vlocity_cmt__JSONAttribute__c);
            outMap.put('ProductNMU',NMU);
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    void GetPointOfSaleWarehouse(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('GetPointOfSaleWarehouse');
        try {
            String orderId = (String) options.get('orderId');
            Map<String,String> getPointOfSaleWarehouseResponse = GetPointOfSaleWarehouse(orderId);
            String codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            String codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            outMap.put('codDeposito',codDeposito);
            outMap.put('codPuntoDeVenta',codPuntoDeVenta);
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    public static void UpdateOrderStatus(String orderId, String Status) {
        System.debug('UpdateOrderStatus');
        try {
            Order order = new Order();
            order.Id = orderId;
            //order.Status = Status;
            order.TrackingStatus__c = Status;
            update order;
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    @RemoteAction
    global static void CancelOrderAndRedirect(string id) {
        try{
            System.debug('En CancelOrderAndRedirect');
            AnulaStockReserved(id);
            //PFTA-11544
            ReleaseLinesFromOrder(id);
            RealeaseNmuReserve(id);
            CancelOrder(id);
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    @RemoteAction
    global static void OrderTimeOut(string orderId) {
        try {
            System.debug('OrderTimeOut');
            Order order = [SELECT Delivery_Method__c FROM Order WHERE Id = :orderId];
            List<OrderItem> orderItems = GetOrderSerials(orderId);
            System.debug('orderItems ===> '+orderItems);
            Map<String,String> getPointOfSaleWarehouseResponse = GetPointOfSaleWarehouse(orderId);
            String codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            String codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            Map<String, Map<String, Object>> nmusMap = new Map<String, Map<String, Object>>();
            //List<String> oldSerialNumbers = new List<String>();
            Map<String,String> oldSerialNumbers = new Map<String,String>();
            for(OrderItem item : orderItems){
                if (string.isNotBlank(item.vlocity_cmt__SerialNumber__c))
                {
                    //oldSerialNumbers.add(item.vlocity_cmt__SerialNumber__c);
                    oldSerialNumbers.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                    item.vlocity_cmt__SerialNumber__c = null;
                }
                else
                {
                    String nmu = GetNMU(item.vlocity_cmt__JSONAttribute__c);
                    AddNmuToRelease(nmusMap,nmu,codDeposito);
                }
            }
            //if (oldSerialNumbers.size() > 0)
            if (oldSerialNumbers.KeySet().size() > 0 && !Test.isRunningTest())
            {
                //DeReserveSerialNumber(oldSerialNumbers, codDeposito, order.Delivery_Method__c);
                MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_ANULAR_RESERVA,oldSerialNumbers, codDeposito, order.Delivery_Method__c);
                update orderItems;
            }
            else
            {
              if(!Test.isRunningTest())
              {
                ManageReservedNmus('L',nmusMap,codPuntoDeVenta,codDeposito, orderId);
              }
            }
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }

    private static void ReleaseLines(string jsonOrder) {
        try{
            System.debug('ReleaseLines');
            System.debug('jsonOrder: ' + jsonOrder);
            Map<string, Object> order =  (Map<string, Object>)JSON.deserializeUntyped(jsonOrder);
            List<Object> planes =(List<Object>) order.get('planes');
            Map<string, string> linesToRelease = new Map<string, string>();
            LinesManager lineManager = new LinesManager();

            for (Object p : planes){
                Map<string, Object> plan = (Map<string, Object>) p;
                List<Object> lines = (List<Object>)plan.get('lineas');
                for (Object l : lines){
                    Map<String, Object> line = (Map<String, Object>) l;
                    String lineAux = (String)line.get('linea');
                    if (String.isNotBlank(lineAux)) linesToRelease.put(lineAux, 'DESBLOQ');
                }
            }

            if(linesToRelease.KeySet().size() > 0 )
                lineManager.FreeReservedLines(linesToRelease);
        }
        catch(DmlException ex) {
            System.debug(ex.getMessage());
        }
    }

    private void CancelOrderAndRelease(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        String orderId = (String) options.get('orderId');
        CancelOrderAndRelease(orderId);
    }

    public static void CancelOrderAndRelease(Id orderId) {
        /**
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Cancel Order and Release Lines, Numbers and Stock
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   Damian Avrij
        * @date     2018-03-05
        * @param    orderId: The order Id
        * @return   nothing
        */
        try{
            ReleaseLinesFromOrder(orderId);
            RealeaseNmuReserve(orderId);
            AnulaStockReserved(orderId);
            //CancelOrder(orderId);
        }
        catch(Exception e) {
            System.debug('CancelOrderAndRelease Msg: ' + e.getMessage());
            System.debug('CancelOrderAndRelease Cause: ' + e.getCause());
            System.debug('CancelOrderAndRelease Stack Trace: ' + e.getStackTraceString());
        }
    }

    public static void ReleaseLinesFromOrder(Id orderId) {
        /**ß
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Release Lines previously reserved in an Order
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   Damian Avrij
        * @date     2018-03-05
        * @param    orderId: The order Id
        * @return   nothing
        */
        String lineNumber;
        Map<string, string> linesToRelease = new Map<string, string>();
        Map<String,Object> jsonAttribute;
        List<OrderItem> plansProducts;
        String lineAux;

        try {
            System.debug('ReleaseLines');

            plansProducts = [SELECT Id, Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__Type__c, vlocity_cmt__SerialNumber__c, vlocity_cmt__JSONAttribute__c, FromStock__c FROM OrderItem WHERE OrderId = :orderId AND Product2.vlocity_cmt__Type__c = 'Plan Prepago'];
            for (OrderItem planProduct : plansProducts){
                jsonAttribute = AssetAttributesUtils.GetJSONAttribute(planProduct.vlocity_cmt__JSONAttribute__c, 'Numero de Linea');
                lineNumber = (String)((Map<String, Object>)jsonAttribute.get('attributeRunTimeInfo')).get('value');
                if (String.isNotBlank(lineNumber)) linesToRelease.put(lineNumber, 'DESBLOQ');
            }

            LinesManager lineManager = new LinesManager();
            if(linesToRelease.KeySet().size() > 0 )
                lineManager.FreeReservedLines(linesToRelease);
        }
        catch(Exception e) {
            System.debug('ReleaseLines Msg: ' + e.getMessage());
            System.debug('ReleaseLines Cause: ' + e.getCause());
            System.debug('ReleaseLines Stack Trace: ' + e.getStackTraceString());
        }
    }

    public static void CreateMACD2(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean outB;
        try{
            System.debug('CreateMACD2');

            vlocity_cmt.OmniFDOWrapper ow = new vlocity_cmt.OmniFDOWrapper();
            if(!Test.isRunningTest())
            {
              ow.invokeMethod('getAccountId',inputMap,outMap,options);
            }

            List<Object> lAssetOIds = (List<Object>) outMap.get('assetIdList');
            inputMap.put('assetIdList',lAssetOIds);
            List<String> lAssetIds = new List<String>();
            System.debug('lAssetOIds ===> '+lAssetOIds);
            for(Object i : lAssetOIds){
                lAssetIds.add((String) i);
            }
            //Date retDate = GetMACDRequestDate((String) options.get('AssetId'), lAssetIds, outMap);
            Date reqDa = GetMACDRequestDate((String) inputMap.get('ContextId'), lAssetIds);
            Datetime dt = Datetime.newInstance(reqDa.year(), reqDa.month(),reqDa.day());
            String dateString = dt.format('yyyy-MM-dd');

            //inMap.put('accountId', accountId);
            //inMap.put('assetIdList', assetIdList);
            Map<String,Object> auxMap = new Map<String,Object>();
            auxMap.put('RequestDate', dateString);

            inputMap.put('Request Date', auxMap);

            if(!Test.isRunningTest())
            {
              ow.invokeMethod('canCreateFDO',inputMap,outMap,options);
            }

            outB = (Boolean) outMap.get('canCreateFDO');
            inputMap.put('canCreateFDO',outMap.get('canCreateFDO'));
            System.debug('outMap: ' + outMap);
            inputMap.put('disconnectedAssets', outMap.get('disconnectedAssets'));
            inputMap.put('Request Date',outMap.get('Request Date'));
            System.debug('inputMap: ' + inputMap);

            if (outB){
                vlocity_cmt.CpqAppHandler cp = new vlocity_cmt.CpqAppHandler();
                inputMap.put('id', inputMap.get('ContextId'));
                //inMap.put('requestDate', reqDa);
                inputMap.put('methodName','assetToOrder');
                cp.invokeMethod('assetToOrder',inputMap,outMap,options);

                //ow.invokeMethod('CreateFDO',inMap,outMap,optMap);
                System.debug('outMap create: ' + outMap);
            }
        }
        catch(Exception e){
            System.debug('CreateMACD Msg: ' + e.getMessage());
            System.debug('CreateMACD Cause: ' + e.getCause());
            System.debug('CreateMACD Stack Trace: ' + e.getStackTraceString());
        }
    }

    public static Date GetMACDRequestDate(String assetId, List<String> assetIdList) {
        Date rDate;
        //List<Date> rDates;
        List<OrderItem> rOItems;
        try{
            System.debug('GetMACDRequestDate');
            System.debug('assetId: ' + assetId);
            System.debug('assetIdList: ' + assetIdList);

            List<Asset> assetList = [select Id,  vlocity_cmt__AssetReferenceId__c from Asset where Id in :assetIdList];
            List<String> assetRefIds = new List<String>();
            for(Asset a : assetList){
                if(a.vlocity_cmt__AssetReferenceId__c != null)
                    assetRefIds.add(a.vlocity_cmt__AssetReferenceId__c);
            }

            System.debug('assetRefIds: ' + assetRefIds);

            rOItems = [select vlocity_cmt__RequestDate__c from OrderItem where vlocity_cmt__AssetReferenceId__c in :assetRefIds and vlocity_cmt__RequestDate__c != null order by vlocity_cmt__RequestDate__c desc];
            //rOItems = [select vlocity_cmt__RequestDate__c from OrderItem where vlocity_cmt__AssetId__c = :assetId and vlocity_cmt__RequestDate__c != null order by vlocity_cmt__RequestDate__c desc];

            /*
            Map<String,Object> itemap;
            List<Object> litemap = new List<Object>();
            for(OrderItem oi : rOItems){
                itemap = new Map<String,Object>();
                itemap.put('Id',oi.Id);
                itemap.put('fecha',oi.vlocity_cmt__RequestDate__c);
                litemap.add(itemap);
            }
            outMap.put('MACDOrders', litemap);
            */

            if (rOItems.isEmpty()){
                rDate = Date.today();
            }
            else{
                rDate = rOItems.get(0).vlocity_cmt__RequestDate__c;
                System.debug('rDate -1: ' + rDate);
                rDate = rDate.addDays(1);
                /*
                if (rDate < Date.today())
                    rDate = Date.today();
                */
                if (rDate <= Date.today())
                    rDate = Date.today().addDays(1);
            }

            System.debug('rDate: ' + rDate);
        }catch(Exception e){
            System.debug('GetMACDRequestDate Msg: ' + e.getMessage());
            System.debug('GetMACDRequestDate Cause: ' + e.getCause());
            System.debug('GetMACDRequestDate Stack Trace: ' + e.getStackTraceString());
        }
        return rDate;
    }

    private static void AnulaStockReserved(string orderId) {
        System.debug('AnulaStockReserved');
        /*PFTA-6757 CALL ANULARESERVA */
        system.debug('Anulación Orderd ====> '+orderId);
        Order order = [SELECT Delivery_Method__c FROM Order WHERE Id = :orderId];
        List<OrderItem> orderItems = GetOrderSerials(orderId);
        Map<String,String> getPointOfSaleWarehouseResponse = GetPointOfSaleWarehouse(orderId);
        String codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
        String codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
        //List<String> oldSerialNumbers = new List<String>();
        Map<String,String> oldSerialNumbers = new Map<String,String>();
        System.debug('PRINT orderItems SIZE ON CANCEL');
        System.debug(orderItems.size());
        if(orderItems.size() > 0){
            System.debug('CANCEL ORDER INSIDE IF > 0');
            for(OrderItem item : orderItems){
                if (string.isNotBlank(item.vlocity_cmt__SerialNumber__c))
                {
                    System.debug('vlocity_cmt__SerialNumber__c IS NOT BLANK');
                    //oldSerialNumbers.add(item.vlocity_cmt__SerialNumber__c);
                    oldSerialNumbers.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                    item.vlocity_cmt__SerialNumber__c = null;
                }
            }

            System.debug('oldSerialNumbers SIZE -> ' + oldSerialNumbers.size());
            if (oldSerialNumbers.size() > 0)
            {
                //DeReserveSerialNumber(oldSerialNumbers, codDeposito, order.Delivery_Method__c);
                MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_ANULAR_RESERVA,oldSerialNumbers, codDeposito, order.Delivery_Method__c);
                update orderItems;
            }
        }
        /* PFTA-6757 FIN */
    }

    private static void CancelOrder(string orderId) {
        try {
            System.debug('CancelOrder');
            Order o = new Order();
            o.Id = orderId;
            o.Status='Cancelled';
            update o;
        }
        catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    private static void RealeaseNmuReserve(string orderId) {
        try{
            System.debug('RealeaseNmuReserve');
            Map<String,String> getPointOfSaleWarehouseResponse = taOrderController.GetPointOfSaleWarehouse(orderId);
            String codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            String codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            String codAplicacion = '2';

            Order o = [SELECT Id, OrderNumber FROM Order WHERE Id =: orderId];
            //PFTA - 10326 - Se envia siempre punto de venta 0
            String idUnicoTransaccion = GuidUtil.NewGuid();
            System.debug('taOrderController:idUnicoTransaccion: ' + idUnicoTransaccion);
            Map<string, Object> response = IFS_S101_reserveOrRelease.reserveOrRelease('L', codAplicacion, o.OrderNumber, '0', idUnicoTransaccion, new Map<String, Map<String, Object>>());
            System.debug('response: ' + response);

        }catch(DmlException e){
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }

    public static Map<String,String> GetPointOfSaleWarehouse(String idOrder) {
        System.debug('GetPointOfSaleWarehouse');
        try
        {
            Map<String,String> response = new Map<String,String>();
            String codPuntoDeVenta;
            String codDeposito;
            List<Order> orderList = [SELECT PickUpStoreLocation__c, PickUpStoreLocation__r.PointOfSaleId__c , PickUpStoreLocation__r.AssociatedWarehouseId__c, Delivery_Method__c, OriginStoreLocation__c, OriginStoreLocation__r.PointOfSaleId__c, OriginStoreLocation__r.AssociatedWarehouseId__c, OriginStoreLocation__r.AssociatedWarehouseDefault__c  FROM Order WHERE Id =: idOrder];
            if(!orderList.isEmpty())
            {
                Order order = orderList.get(0);
                System.debug('SELECT PointOfSaleId__c');
                codPuntoDeVenta = String.valueOf(order.OriginStoreLocation__r.PointOfSaleId__c);
                codDeposito = order.OriginStoreLocation__r.AssociatedWarehouseId__c;

                if(String.isNotBlank(order.PickUpStoreLocation__c))
                {
                    System.debug(' if(String.isNotBlank(order.PickUpStoreLocation__c)');
                    codPuntoDeVenta = String.valueOf(order.PickUpStoreLocation__r.PointOfSaleId__c);
                    codDeposito = order.PickUpStoreLocation__r.AssociatedWarehouseId__c;
                }
                else if (order.Delivery_Method__c == 'Delivery')
                {
                    System.debug('order.Delivery_Method__c');
                    codDeposito = order.OriginStoreLocation__r.AssociatedWarehouseDefault__c;
                }

                System.debug('OUT');
            }
            response.put('codPuntoDeVenta',codPuntoDeVenta);
            response.put('codDeposito',codDeposito);
            return response;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public static void DeleteTasks(String idOrder, String type) {
        System.debug('DeleteTasks');
        try
        {
            List<Task> tasks = [SELECT Id from Task where WhatId = :idOrder and Type = :type];
            delete tasks;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public static void CreateStateTask(String idOrder, String type) {
        System.debug('CreateStateTask');
        try
        {
            Task task= new Task();
            task.Subject = 'Esto es un ejemplo para testear el topic';
            task.Type = type;
            task.WhatId  = idOrder;
            insert task;
        }
        catch(Exception e)
        {
            throw e;
        }
    }

    public static Boolean ValidateTangibleExistence (String orderId) {
        try {
            List<OrderItem> items = [SELECT Product2.Name FROM OrderItem WHERE OrderId = :orderId AND Product2.Tangible__c = true];
            Boolean serviceExists = false ;
            system.debug('orderID'+OrderId);
            system.debug(items);
            
            

            if (items.size() > 0)
                serviceExists = true;
            
            return serviceExists;
        }
        catch(Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    //public static void DeReserveSerialNumber(List<String> serialNumbers, String codDeposito, String deliveryMethod)
    public static void MoveSerialsStock(String operation, String instance, Map<String,String> serialNumbers, String codDeposito, String deliveryMethod) {
        try
        {
            System.debug('INTO MoveSerialsStock');
            System.debug('INTO MoveSerialsStock');
            System.debug('codDeposito-->' + codDeposito);
            String codOperation;
            String destinationDepositCode;
            Map<String,Object> serialNumbersToMove = new Map<String,Object>();
            //Serials Numbers On Cancel OV
            for(String serial : serialNumbers.KeySet())
            {
                String originStock = (String) serialNumbers.get(serial);
                if (!String.IsNotBlank(originStock)) originStock = 'NOAPLICA';
                Map<string, Object> response = TaMatrixUtils.getStockMovementOperation(operation, instance, deliveryMethod, originStock);
                System.debug(response);
                if(response != null){
                    codOperation =  (String) response.get('StockMovementOperation__OperationCode');
                    destinationDepositCode = (String) response.get('StockMovementOperation__DestinationDepositCode');
                    System.debug(instance + ' -> Codigo operacion: ' + codOperation + ' Codigo deposito: ' + destinationDepositCode );
                    if(destinationDepositCode == 'VICLIE')
                        codDeposito = 'VICLIE0001';
                }
                Map<String,Object> serialNode = new Map<String,Object>();
                serialNode.put('codOperacion',codOperation);
                serialNode.put('codDeposito',codDeposito);
                serialNumbersToMove.put(serial, serialNode);
            }

            if(!Test.isRunningTest()){
                StockUtils.StockMovement(serialNumbersToMove);
            }

        }
        catch(CallOutException e){
            System.debug('taOrderController:MoveSerialsStock -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw new ServiceException('Error al realizar el movimiento de stock');
        }
        catch(Exception e){
            System.debug('taOrderController:MoveSerialsStock -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw new ServiceException('Error al realizar el movimiento de stock');
        }
    }

    public static String GetStockCodeByOperation(String operation, String subOperation, String deliveryMethod) {
        try
        {
            Map<string, Object> response = TaMatrixUtils.getStockMovementOperation(operation,subOperation, deliveryMethod, 'NOAPLICA');
            String codOperation =  (String) response.get('StockMovementOperation__OperationCode');
            return codOperation;
        }
        catch(Exception e){
            System.debug('taOrderController:GetStockCodeByOperation -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            return null;
        }
    }

    public static void AddNmuToRelease(Map<String, Map<String, Object>> nmusMap, String nmu, String codDeposito) {
        try
        {
            Map<String, Object> existingNmu = (Map<String, Object>) nmusMap.get(nmu);
            if (existingNmu != null)
            {
                Integer cantidad = (Integer) existingNmu.get('cantidad');
                existingNmu.put('cantidad', cantidad + 1);
                nmusMap.put(nmu, existingNmu);
            }
            else
            {
                Map<String, Object> newNmu = new Map<String, Object>();
                newNmu.put('codNMU', nmu);
                newNmu.put('codDeposito', codDeposito);
                newNmu.put('cantidad', 1);
                nmusMap.put(nmu, newNmu);
            }

        }
        catch(Exception e){
            System.debug('taOrderController:AddNmuToRelease -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
        }
    }

    public static void ManageReservedNmus(String operationCode, Map<String, Map<String, Object>> nmusMap, String codPuntoDeVenta, String codDeposito, String orderId) {
        try
        {
            system.debug('llegue yo ====> ');
            //PFTA - 10326 - Se envia siempre punto de venta 0
            String idUnicoTransaccion = GuidUtil.NewGuid();
            System.debug('taOrderController:idUnicoTransaccion: ' + idUnicoTransaccion);
            Map<String,Object> response = new Map<String,Object>();

            if(!Test.isRunningTest()){
                response = IFS_S101_reserveOrRelease.reserveOrRelease(operationCode, '2', orderId, '0', idUnicoTransaccion, nmusMap);
            }else {
                response.put('httpStatusCode', '200');
            }

            String httpResponseCode = (String) response.get('httpStatusCode');
            if (httpResponseCode != '200')
                throw new FuncException('Error al invocar al servicio de reserva por NMU. ' + response);
        }
        catch(FuncException e){
            System.debug('taOrderController:ManageReservedNmus -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw new ServiceException('Error al realizar la reserva/liberacion del sotck');
        }
        catch(Exception e){
            System.debug('taOrderController:ManageReservedNmus -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw new ServiceException('Error al realizar la reserva/liberacion del sotck');
        }
    }

    public static String GetNMU(String vlocitycmtJSONAttribute) {
        System.debug('GetNMU');
        try
        {
            Map<String, Object> mapa = (Map<String, Object>) JSON.deserializeUntyped(vlocitycmtJSONAttribute);
            System.debug('mapa: ' + mapa);
            List<Object> FAN_ATTCAT = (List<Object>) mapa.get('FAN_ATTCAT_000048');
            Map<String, Object> attributeRunTimeInfo = (Map<String, Object>) FAN_ATTCAT[2];
            System.debug('attributeRunTimeInfo: ' + attributeRunTimeInfo);
            Map<String, Object> attributeRunTimeInfo2 = (Map<String, Object>) attributeRunTimeInfo.get('attributeRunTimeInfo');
            List<Object> values = (List<Object>) attributeRunTimeInfo2.get('values');
            System.debug('values: ' + values);
            Map<String, Object> nmu = (Map<String, Object>) values[0];
            String nmuValue = (String) nmu.get('value');
            return nmuValue;
        }
        catch(Exception e){
            System.debug('taOrderController:GetNMU -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            return null;
        }
    }

    public static List<OrderItem> GetOrderSerials(String orderId) {
        System.debug('GetOrderSerials');
        try
        {
            List<Id> orderIds = new List<Id>();
            orderIds.add(orderId);
            return GetOrderSerials(orderIds);
        }
        catch(Exception e)
        {
            System.debug('taOrderController:GetOrderSerials -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    public static List<OrderItem> GetOrderSerials(List<Id> orderIds) {
        System.debug('GetOrderSerials');
        try
        {
            List<OrderItem> tangibleItems = new List<OrderItem>();
            List<OrderItem> items = [SELECT Id, Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__Type__c, Product2.NMU__c, vlocity_cmt__SerialNumber__c, Product2.Tangible__c, vlocity_cmt__JSONAttribute__c, FromStock__c, vlocity_cmt__Action__c, Operation_Code__c, Deposit_Code__c, vlocity_cmt__AssetId__c FROM OrderItem WHERE OrderId IN :orderIds];
            system.debug('GetOrderSerials items ====> '+items);
            for(OrderItem item : items)
            {
                Boolean isTangible = item.Product2.Tangible__c;
                system.debug('item.Product2.Tangible__c ====> '+item.Product2.Tangible__c);
                system.debug('isTangible ====> '+item.Product2.Tangible__c);
                if (isTangible) tangibleItems.add(item);
            }
            System.debug('tangibleItems: ' + tangibleItems);
            return tangibleItems;
        }
        catch(Exception e)
        {
            System.debug('taOrderController:GetOrderSerials -> exception: '+e);
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    void GetManageableIdentityValidation(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('PRINT INPUT GetManageableIdentityValidation');
        System.debug(inputMap);
        Boolean validationRequired = false;
        String paymentMethodItem = '0000';
        String orderId = (String) inputMap.get('IdOrder');

        if (orderId == null)
            orderId = (String) inputMap.get('ContextId');

        if (orderId == null)
            orderId = (String) inputMap.get('DRId_Order');


        System.debug(orderId);
        Boolean isNewPackExistingLine = (Boolean) inputMap.get('IsNewPackExistingLine');
        Boolean isMACDValidationIdentitySubmit = (Boolean) inputMap.get('IsMACDValidationIdentitySubmit');
        Boolean isMACDValidationIdentityABMSubmit = (Boolean) inputMap.get('IsMACDValidationIdentityABMSubmit');
        Boolean isAnnulment = (Boolean) inputMap.get('isAnnulment');

        System.debug('isAnnulment: ' + isAnnulment);
        System.debug('isNewPackExistingLine: ' + isNewPackExistingLine);
        System.debug('isMACDValidationIdentitySubmit: ' + isMACDValidationIdentitySubmit);
        System.debug('isMACDValidationIdentityABMSubmit: ' + isMACDValidationIdentityABMSubmit);

        Order order = [
            SELECT Id, AccountId, Status, Delivery_Method__c, vlocity_cmt__OriginatingChannel__c, PaymentMethodType__c,
            (SELECT Id, Product2.ProductCode, Product2.Name,
            Product2.vlocity_cmt__Type__c FROM OrderItems) FROM Order WHERE Id = :orderId LIMIT 1
        ];

        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentsList = [
            SELECT Id,
            vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c
            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE Order__r.Id = :orderId
        ];

        if(isMACDValidationIdentitySubmit == true){

            validationRequired = consultingMatrixValidationRequired('NA', 'CambioPlan');
            if(validationRequired == true){
                System.debug('Assign order and contact');
                Account orderAccount = [SELECT vlocity_cmt__PrimaryContactId__c FROM Account WHERE Id = :order.AccountId];
                System.debug(orderAccount.vlocity_cmt__PrimaryContactId__c);

                outMap.put('contactId', orderAccount.vlocity_cmt__PrimaryContactId__c);
                outMap.put('IdOrder', orderId);

            }
        } else if(isAnnulment == true) {
            System.debug('IN isAnnulment');
            validationRequired = consultingMatrixValidationRequired('NA', 'Desconexion');
            System.debug('validationRequiredAnnulment: ' + validationRequired);
        } else if(isMACDValidationIdentityABMSubmit == true){

            if(paymentAdjustmentsList.size() > 0){

                for(vlocity_cmt__PaymentAdjustment__c paymentMethod : paymentAdjustmentsList){

                    System.debug(paymentMethod);
                    System.debug(paymentMethod.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c);
                    paymentMethodItem = paymentMethod.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c;
                    System.debug('CODIGO METODO DE PAGO: ' + paymentMethodItem);

                    try
                    {
                        /*MACDServices Alta Baja Servicios*/
                        validationRequired = consultingMatrixValidationRequired(paymentMethodItem, 'MACDServices');
                        System.debug('RESPONSE consultingMatrixValidationRequired: '+validationRequired);
                    }
                    catch(Exception e){
                        System.debug('taOrderController:GetManageableIdentityValidation -> exception: '+e);
                    }

                    if(validationRequired == true)
                        break;

                }

            }

        } else {

            if(order.OrderItems.size() > 0){
                for(OrderItem item : order.OrderItems){
                    System.debug('PRINT TYPE');
                    System.debug(item.Product2.vlocity_cmt__Type__c);
                    System.debug('Print ITEM');
                    System.debug(item.Product2);
                    if (string.isNotBlank(item.Product2.vlocity_cmt__Type__c))
                    {
                        if(paymentAdjustmentsList.size() > 0){

                            for(vlocity_cmt__PaymentAdjustment__c paymentMethod : paymentAdjustmentsList){

                                System.debug(paymentMethod);
                                System.debug(paymentMethod.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c);
                                paymentMethodItem = paymentMethod.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c;
                                System.debug('CODIGO METODO DE PAGO: ' + paymentMethodItem);

                                try
                                {
                                    validationRequired = consultingMatrixValidationRequired(paymentMethodItem, item.Product2.vlocity_cmt__Type__c);
                                    System.debug('Print RESPONSE ');
                                    System.debug(validationRequired);

                                    if(isNewPackExistingLine == true && item.Product2.vlocity_cmt__Type__c == 'Pack'){
                                        System.debug('PACK DO BREAK');
                                        break;
                                    } else if(isNewPackExistingLine == true && item.Product2.vlocity_cmt__Type__c != 'Pack'){
                                        System.debug('SALE PACK NEXT');
                                        validationRequired = false;
                                    } else if(isNewPackExistingLine != true){
                                        if(validationRequired == true)
                                            break;
                                    }
                                }
                                catch(Exception e){
                                    System.debug('taOrderController:GetManageableIdentityValidation -> exception: '+e);
                                }
                            }

                            if(validationRequired == true)
                                break;

                        } else {
                            paymentMethodItem = order.PaymentMethodType__c;
                            try
                            {
                                validationRequired = consultingMatrixValidationRequired(paymentMethodItem, item.Product2.vlocity_cmt__Type__c);
                                System.debug('Print RESPONSE ');
                                System.debug(validationRequired);

                                if(isNewPackExistingLine == true && item.Product2.vlocity_cmt__Type__c == 'Pack'){
                                    System.debug('PACK DO BREAK');
                                    break;
                                } else if(isNewPackExistingLine != true){
                                    if(validationRequired == true)
                                        break;
                                }
                            }
                            catch(Exception e){
                                System.debug('taOrderController:GetManageableIdentityValidation -> exception: '+e);

                            }
                        }
                    }
                }
            }
        }

        outMap.put('validationRequired', validationRequired);
    }

    public static Boolean consultingMatrixValidationRequired(String paymentMethodItem, String code) {
            Boolean validationRequired = false;
            Map<string, Object> response = TaMatrixUtils.GetManageableIdentityValidationMatrix(paymentMethodItem, code);
            System.debug(response);
            if(response != null) {
                String validationRequiredS = (String) response.get('ManageableIdentityValidation__ValidationRequired');
                validationRequired = Boolean.valueOf(validationRequiredS);
            }

            if(Test.isRunningTest()){
                validationRequired = true;
            }

            return validationRequired;
    }

    /*public void GetCreditReChargeAmmount(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options){
        System.debug('GetCreditReChargeAmmount');
        Id idObject = '01t6C000000Zw0h';
        List<String> attName = new List<String>();
        attName.add('Monto de Recarga');
        Map<String, Object> response = new Map<String, Object>();
        List<Product2> objProds = [Select vlocity_cmt__JSONAttribute__c From Product2 Where id = :idObject];
        Product2 objProd = objProds[0];
        Map<String, Object> mapJsonAttributes = (Map<String, Object>) JSON.deserializeUntyped(objProd.vlocity_cmt__JSONAttribute__c);
        List<Map<String, String>> ammountsList = new List<Map<String, String>>();
        Set<String> attributesKeys = mapJsonAttributes.keySet();
            //Attributes may have more than one parent node so this iterates the first child nodes
            for(String attributeKey : attributesKeys){
                List<Object> attributes = (List<Object>)mapJsonAttributes.get(attributeKey);

                //Iterates the second childs
                for(Object attribute : attributes){
                    System.debug(attribute);
                    Map<String, Object> mapAttribute = (Map<String, Object>) attribute;

                    //Iterates the String List send in the parameters
                    for(String displayName : attName){
                        System.debug(displayName);
                        String attValue = '';

                        //Fields with datatype Picklist have the selected value on another child
                        if(displayName == (String) mapAttribute.get('attributedisplayname__c')) {
                            List<Object> pickListValues;
                            Map<String, Object> mapAttributeRunTimeInfo = (Map<String, Object>)mapAttribute.get('attributeRunTimeInfo');
                            if((String) mapAttributeRunTimeInfo.get('dataType') == 'Picklist'){
                                pickListValues = (List<Object>)mapAttributeRunTimeInfo.get('values');
                                for(Object item: pickListValues){
                                    Map<String,Object> nodeMap = (Map<String,Object>) item;
                                    System.debug('nodeMap: ' + nodeMap);
                                    Map<String, String> tempMap = new Map<String, String>();
                                    tempMap.put('name', (string) nodeMap.get('value'));
                                    tempMap.put('value', (string) nodeMap.get('displayText'));
                                    //tempMap.put('id', (Integer) nodeMap.get('id'));
                                    ammountsList.add(tempMap);
                                }
                            }
                            //System.debug(pickListValues);
                            //response.put(displayName, pickListValues);
                        }

                    }
                }
            }
        /*
        List<Object> pickListValues = (List<Object>) response.get(displayName);
        List<Map<String, String>> ammountsList = new List<Map<String, String>>();
        for(Object item: pickListValues){
            Map<String,Object> nodeMap = (Map<String,Object>) item;
            Map<String, String> tempMap = new Map<String, String>();
            tempMap.put('name', (string) nodeMap.get('value'));
            tempMap.put('value', (string) nodeMap.get('displayText'));
            ammountsList.add(tempMap);
        }
        /comentario cerrado con *
        outMap.put('options', ammountsList);
    }*/

    @RemoteAction
    global static Map<String, Object> GetPaymentMethods(Map<String, Object> input) {
        ta_sales_paymentMethod paymentMethodClass = new ta_sales_paymentMethod();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        paymentMethodClass.getPaymentMethods(input, outMap, options);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> GetDocumentTypes(Map<String, Object> input) {
        taNewContact newContactClass = new taNewContact();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        newContactClass.getDocumentTypes(outMap);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> PopulateEntidades(Map<String, Object> input) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        paymentMethodClass.PopulateEntidades(input, outMap, options);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> GetCardsByBank(String bankCode) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        return paymentMethodClass.GetCardsByBank(bankCode);
    }

    @RemoteAction
    global static Map<String, Object> GetInstallmentsByCard(String bankCode, String cardCode) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        return paymentMethodClass.GetInstallmentsByCard(bankCode, cardCode);
    }

    @RemoteAction
    global static Map<String, Object> GetMatrixDpfCft(String installments) {
        System.debug('GetMatrixDpfCft');
        Map<string, Object> response =  TaMatrixUtils.GetPromocionesFinancierasVigentes('DPF', 'NA', 'NA', installments);
        System.debug(response);
        return response;
    }

    @RemoteAction
    global static List<OrderItem> GetOrderItemsBillable(String orderId) {

        List<OrderItem> orderItems = [
            SELECT
                Id,
                vlocity_cmt__Product2Id__r.Name,
                vlocity_cmt__Product2Id__r.ProductCode,
                vlocity_cmt__Product2Id__r.StockKeepingUnit,
                vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c,
                vlocity_cmt__Product2Id__r.Tangible__c,
                vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c,
                vlocity_cmt__Product2Id__r.Family,
                vlocity_cmt__Product2Id__r.Alicuota__c,
                Quantity,
                vlocity_cmt__EffectiveOneTimeTotal__c,
                vlocity_cmt__EffectiveRecurringTotal__c,
                vlocity_cmt__Product2Id__r.FAN_IntegrationKey__c,
                Huawei_Invoice_Item_Sequence__c,
                vlocity_cmt__PricingLogData__c
            FROM OrderItem
            WHERE
                OrderId = :orderId
                AND IsBillable__c = true
                AND vlocity_cmt__Action__c = 'Add'
            ORDER BY CreatedDate DESC
        ];
        // System.debug(JSON.serialize(orderItems));

        List<OrderItem> billables = new List<OrderItem>();
        for(OrderItem item : orderItems)
        {
            Boolean isBillable = false;
            // System.debug('vlocity_cmt__JSONAttribute__c');
            // System.debug(item.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c);
            Map<String, Object> attrbBillable = AssetAttributesUtils.GetJSONAttribute(item.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c, 'Facturable en Venta');
            if(attrbBillable != null && attrbBillable.get('value__c') != null && 
                (attrbBillable.get('value__c') == 'Requerido' || attrbBillable.get('value__c') == 'Opcional')){
                // isBillable = Boolean.valueOf(attrbBillable.get('value__c'));
                billables.add(item);
            }
            // if (isBillable) billables.add(item);
        }
        // System.debug(JSON.serialize(billables));
        return billables;
        // ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        // return paymentMethodClass.GetInstallmentsByCard(bankCode, cardCode);
    }

    public static void ValidateTelecomNumbers(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('ValidateTelecomNumbers');

        try
        {
            System.debug(options.get('lineNumbers'));
            List<Object> lineNumbers = (List<Object>) options.get('lineNumbers');

            List<String> nums = new List<String>();
            String sItem;

            for(Object item : lineNumbers)
            {
                sItem = (String) item;
                if (!ValidateTelecomNumber(sItem))
                    nums.add(sItem);

            }
            outMap.put('noTPnumbers',nums);
        }
        catch(Exception e) {
            System.debug('ValidateTelecomNumbers Msg: ' + e.getMessage());
            System.debug('ValidateTelecomNumbers Cause: ' + e.getCause());
            System.debug('ValidateTelecomNumbers Trace: ' + e.getStackTraceString());
        }
    }

    @RemoteAction
    global static Boolean ValidateTelecomNumber(string lineNumber) {
        try{
            String integProcName = 'IFS_S464';
            String codTipoVenta = 'NOR';
            Map<String, Object> input = new Map<String, Object>();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object>();
            String body = '{"nroLinea":"' + lineNumber + '","codTipoVenta":"' + codTipoVenta + '"}';
            input.put('body', body);
            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod(integProcName, input, output, options);
            Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
            Integer result = Integer.valueof(response.get('resultado'));
            if (result == 0)
                return true;
            else return false;
        }catch(DmlException e){
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return false;
        }
    }

    void UpdateOrderCreditRefillSOS(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
            System.debug('UpdateOrderCreditRefillSOS');
            String orderId = (String) inputMap.get('orderId');
            String status = (String) inputMap.get('Status');
            String substatus = (String) inputMap.get('SubStatus');
            System.debug(orderId);
            System.debug(status);
            System.debug(substatus);

        try
        {
            Order order = new Order();
            order.Id = orderId;
            order.Status = status;
            order.TrackingStatus__c = substatus;
            update order;
            outMap.put('Order', order);

        }
        catch(Exception e)
        {
            System.debug('taOrderController:UpdateOrderCreditRefillSOS -> exception: '+e);
        }
    }

    // Payment Method Credit Card Logic With Custom Object - JARA
    @RemoteAction
    global static Map<String, Object> PopulateEntidadesFromObject(Map<String, Object> input) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        paymentMethodClass.PopulateEntidadesFromObject(input, outMap, options);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> GetCardsByBankFromObject(Map<String, Object> input) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        paymentMethodClass.PopulateTarjetasFromObject(input, outMap, options);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> GetPromotionsByBankCardFromObject(String bankCode, String cardCode, Map<String, Object> options) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        return paymentMethodClass.GetPromotionsByBankCard(bankCode, cardCode, options);
    }

    @RemoteAction
    global static Map<String, Object> GetInstallmentsByPromotion(String bankCode, String cardCode, String promotionName, Map<String, Object> options) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        return paymentMethodClass.GetInstallmentsByPromotions(bankCode, cardCode, promotionName, options);
    }

    @RemoteAction
    global static Map<String, Object> RollbackForRetryPaymentMethods(Map<String, Object> options) {
        String orderId = (String) options.get('orderId');
        AnulaStockReserved(orderId);
        taSalesAnnulmentHandler.call_S457_Hot_Invoice_Rollback(orderId);

        Map<String, Object> outMap = new Map<String, Object>();
        outMap.put('error', false);

        return outMap;

    }

    @RemoteAction
    global static Map<String, Object> PopulateDPFInstallmentsFromObject(Map<String, Object> input) {
        ta_sales_paymentMethodLogic paymentMethodClass = new ta_sales_paymentMethodLogic();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        paymentMethodClass.PopulateDPFInstallmentsFromObject(input, outMap, options);
        return outMap;
    }

    public static List<vlocity_cmt__PaymentAdjustment__c> GetPaymentAdjustmentsWithCFT(String OrderId) {
        List<vlocity_cmt__PaymentAdjustment__c> payments = [
            SELECT
                Id,
                vlocity_cmt__Amount__c,
                vlocity_cmt__InstallmentAmount__c,
                vlocity_cmt__Method__c,
                Huawei_Invoice_Item_Sequence__c,
                Financial_Promotion__r.Percentage__c
            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE
                Order__c = :OrderId
                AND Financial_Promotion__r.Percentage__c > 0
            ORDER BY CreatedDate ASC
        ];

        return payments;
    }

    public void GetPaymentsAdjustments(Map<String, Object> input, Map<String, Object> outMap, Map<String, Object> options) {
        System.debug('GetPaymentsAdjustments');
        String OrderId = String.valueOf(options.get('OrderId'));
        // System.debug('OrderId: ' + OrderId);

        List<vlocity_cmt__PaymentAdjustment__c> payments = GetPaymentsAdjustments(OrderId);
        // System.debug(payments);
        outMap.put('data', payments);
    }

    public static List<vlocity_cmt__PaymentAdjustment__c> GetPaymentsAdjustments(String OrderId) {
        List<vlocity_cmt__PaymentAdjustment__c> payments = [
            SELECT
                Id,
                vlocity_cmt__Amount__c,
                vlocity_cmt__InstallmentAmount__c,
                vlocity_cmt__Method__c,
                Financial_Promotion__r.Percentage__c,
                Financial_Promotion__r.Interest__c,
                Huawei_Invoice_Item_Sequence__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__Last4Numbers__c,
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c
            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE
                Order__c = :OrderId
            ORDER BY
                vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c DESC,
                CreatedDate ASC
        ];

        return payments;
    }

    @RemoteAction
    global static Map<String, Object> getFinancialPromotions(Map<String, Object> input) {
        Map<String, Object> outMap = new Map<String, Object>();

        String userId = (String) input.get('userId');
        vlocity_cmt__BusinessSite__c tm = ta_sales_UserUtils.getStoreLocation(userId);

        String idOrder = (String) input.get('IdOrder');
        List<OrderItem> itemsList = [SELECT Id, Product2Id
                                       FROM OrderItem
                                      WHERE OrderId = :idOrder];


        String recordTypeName = (String) input.get('recordTypeName');

        Order order = [SELECT Id, Vlocity_cmt__OriginatingChannel__c, OriginStoreLocation__r.Channel__c
                         FROM Order
                        WHERE Id = :idOrder LIMIT 1];

        List<String> productList = new List<String>();
        String location = tm.Location__c;

        for(OrderItem item : itemsList){
            productList.add(item.Product2Id);
        }

        Date todaydate = Date.Today();
        List<FinancialPromotion__c> financialPromotions = [SELECT BankEntities__c, CreditCards__c, NombrePromocion__c, Instalment__c, Interest__c, Percentage__c
                                                             FROM FinancialPromotion__c
                                                            WHERE RecordType.Name = :recordTypeName
                                                              AND From__c <= :todaydate
                                                              AND To__c >= :todaydate
                                                              AND ChannelPromotion__c = :order.OriginStoreLocation__r.Channel__c
                                                              AND ProductPromotion__c IN :productList
                                                              AND LocationPromotion__c = :location
                                                              AND PromotionStatus__c = 'Vigente'];

        List<FinancialPromotion__c> genericPromotions = new List<FinancialPromotion__c>();
        genericPromotions = [SELECT BankEntities__c, CreditCards__c, NombrePromocion__c, Instalment__c, Interest__c, Percentage__c
                               FROM FinancialPromotion__c
                              WHERE RecordType.Name = :recordTypeName
                                AND From__c <= :todaydate
                                AND To__c >= :todaydate
                                AND ChannelPromotion__c = null
                                AND ProductPromotion__c = null
                                AND LocationPromotion__c = null
                                AND PromotionStatus__c = 'Vigente'];

        if(financialPromotions.isEmpty()){
            financialPromotions.addAll(genericPromotions);
        }
        else{
            for(FinancialPromotion__c gp : genericPromotions){

                Boolean aggregate = true;
                for(FinancialPromotion__c fp : financialPromotions){
                    if(gp.BankEntities__c == fp.BankEntities__c &&
                       gp.CreditCards__c  == fp.CreditCards__c  &&
                       gp.Instalment__c   == fp.Instalment__c &&
                       gp.Percentage__c == fp.Percentage__c){
                        aggregate = false;
                        break;
                    }
                }
                if(aggregate){
                    financialPromotions.add(gp);
                }
            }
        }
        String serializedList = JSON.serialize(financialPromotions);
        outMap.put('options', serializedList);
        return outMap;
    }

    /*JARN: No borrar*/
    public static List<vlocity_cmt__PaymentAdjustment__c> GetCashPayments(String OrderId) {
        List<vlocity_cmt__PaymentAdjustment__c> payments = [
            SELECT
            Id,
            vlocity_cmt__Amount__c
            // vlocity_cmt__InstallmentAmount__c,
            // vlocity_cmt__Method__c,
            // Financial_Promotion__r.Percentage__c,
            // Financial_Promotion__r.Interest__c,
            // Huawei_Invoice_Item_Sequence__c,
            // vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c,
            // vlocity_cmt__PaymentMethodId__r.vlocity_cmt__Last4Numbers__c,
            // vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c
            // vlocity_cmt__PaymentMethodId__r.Concatenate__c
            // Security__c
            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE
            Order__c = :OrderId
            AND vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c = '1001'
            ORDER BY
            vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c DESC,
            CreatedDate ASC
        ];

        return payments;
    }

    public static List<vlocity_cmt__PaymentAdjustment__c> GetCardsPayments(String OrderId) {
        List<vlocity_cmt__PaymentAdjustment__c> payments = [
            SELECT
            Id,
            vlocity_cmt__Amount__c,
            vlocity_cmt__TotalInstallments__c,
            // vlocity_cmt__InstallmentAmount__c,
            // vlocity_cmt__Method__c,
            // Financial_Promotion__r.Percentage__c,
            // Financial_Promotion__r.Interest__c,
            // Huawei_Invoice_Item_Sequence__c,
            vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c,
            // vlocity_cmt__PaymentMethodId__r.vlocity_cmt__Last4Numbers__c,
            vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c,
            vlocity_cmt__PaymentMethodId__r.Concatenate__c,
            vlocity_cmt__PaymentMethodId__r.Security__c,
            Order__c
            FROM vlocity_cmt__PaymentAdjustment__c
            WHERE
                Order__c = :OrderId
            AND (vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c = '2001'
                OR vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c = '4002')
            ORDER BY
            vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c DESC,
            CreatedDate ASC
        ];

        return payments;
    }

    // son los descuentos agrupados por order item
    public static Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>> GetPriceAdjustmentsGroupByOrderItem(string orderId) {
        List<vlocity_cmt__OrderPriceAdjustment__c> lstOrderPriceAdjustment = [
            SELECT
                vlocity_cmt__OrderItemId__c,
                vlocity_cmt__OrderItemId__r.vlocity_cmt__PricingLogData__c,
                vlocity_cmt__Amount__c,
                vlocity_cmt__PricingVariableCode__c,
                vlocity_cmt__AdjustmentValue__c,
                vlocity_cmt__Sequence__c,
                vlocity_cmt__PriceListEntryId__r.vlocity_cmt__PricingElementId__r.vlocity_cmt__Code__c,
                vlocity_cmt__PriceListEntryId__r.vlocity_cmt__PricingElementId__r.vlocity_cmt__DisplayText__c
            FROM vlocity_cmt__OrderPriceAdjustment__c
            WHERE vlocity_cmt__OrderId__c = :orderId
            ORDER BY vlocity_cmt__OrderItemId__c DESC
        ];

        Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>> hashDescuentos = null;
        if(lstOrderPriceAdjustment.size() > 0){
            hashDescuentos = new Map<String, List<vlocity_cmt__OrderPriceAdjustment__c>>();
            // se hace con un corte de control porque puede haber mas de un descuento para el mismo orderItem
            // por lo tanto agrupamos para un unico orderItem, varias promociones
            Integer i = 0;
            while (i < lstOrderPriceAdjustment.size()) {
                List<vlocity_cmt__OrderPriceAdjustment__c> auxList = new List<vlocity_cmt__OrderPriceAdjustment__c>();
                Id anterior = lstOrderPriceAdjustment[i].vlocity_cmt__OrderItemId__c;
                while (i < lstOrderPriceAdjustment.size() && anterior == lstOrderPriceAdjustment[i].vlocity_cmt__OrderItemId__c) {
                    auxList.add(lstOrderPriceAdjustment[i]);
                    i++;
                }
                hashDescuentos.put(anterior, auxList);
            }
        }

        return hashDescuentos;
    }
    /*JARN: No borrar FIN*/

    //JARN: Controlaor creado para ser invocado desde la voualforce pagAprobalADV.page PFTA-9428
    private final Order o;
    
    public taOrderController(ApexPages.StandardController stdController) {
        this.o = (Order)stdController.getRecord();
    }

    public PageReference rechazarOrderADV() {
        String theId = ApexPages.currentPage().getParameters().get('id');
        String motivo = ApexPages.currentPage().getParameters().get('j_id0:j_id1:motivo');
        String descr = ApexPages.currentPage().getParameters().get('j_id0:j_id1:desc');
        Map<String, String> value = ApexPages.currentPage().getParameters();
        Order order1 = [SELECT Id,OrderApprovalStatus__c,AccountId,OwnerId,ApprovalUserMail__c FROM Order WHERE Id = :theId];
        Account account1 = [SELECT Id,Phone FROM Account Where Id = :order1.AccountId];
        Team_Member__c lstTeamMember = [    Select 
                                                    id, Is_Active__c, 
                                                    User_member__c,
                                                    Work_Team__r.Id
                                                from Team_Member__c WHERE User_member__c =: order1.OwnerId and Is_Active__c = true
                                             ];
        System.debug('rechazarOrderADV:lstTeamMember ->' +  lstTeamMember);


        WorkTeam__c lstTeam = [ Select 
                                                    Id,Is_Active__c,Manager__r.email 
                                                    from WorkTeam__c WHERE Id =: lstTeamMember.Work_Team__c and Is_Active__c = true
                                             ];
        order1.OrderApprovalStatus__c = 'Rechazada por ADV';
        order1.SaleMotivoRechazoADV__c = motivo;
        order1.RejectionReason__c = descr;
        order1.ApprovalUserMail__c = lstTeam.Manager__r.Email;
        update order1;
        account1.Phone = '';
        update account1;
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference devolverOrderADV() {
        String theId = ApexPages.currentPage().getParameters().get('id');
        String motivo = ApexPages.currentPage().getParameters().get('j_id0:j_id1:motivo');
        String descr = ApexPages.currentPage().getParameters().get('j_id0:j_id1:desc');
        Map<String, String> value = ApexPages.currentPage().getParameters();
        Order order1 = [SELECT Id,OrderApprovalStatus__c,OwnerId,ApprovalUserMail__c FROM Order WHERE Id = :theId LIMIT 1];
        Team_Member__c lstTeamMember = [    Select 
                                                    id, Is_Active__c, 
                                                    User_member__c,
                                                    Work_Team__r.Id
                                                from Team_Member__c WHERE User_member__c =: order1.OwnerId and Is_Active__c = true LIMIT 1
                                             ];

        System.debug('devolverOrderADV:lstTeamMember ->' +  lstTeamMember);
        
        WorkTeam__c lstTeam = [ Select 
                                                    Id,Is_Active__c,Manager__r.email 
                                                    from WorkTeam__c WHERE Id =: lstTeamMember.Work_Team__c and Is_Active__c = true LIMIT 1
                                             ];
        order1.OrderApprovalStatus__c = 'Devuelto al Vendedor';
        order1.SaleMotivoRechazoADV__c = motivo;
        order1.RejectionReason__c = descr;
        order1.ApprovalUserMail__c = lstTeam.Manager__r.Email;
        update order1;
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    //Fin JARN PFTA-9428

    // Filitto : PFTA-9428
    public PageReference aprobarOrderADV() {
        String theId = ApexPages.currentPage().getParameters().get('id');
        system.debug('test Id page ===> '+theId);
        list<Order> lstorder1 = [SELECT Id,OrderApprovalStatus__c FROM Order WHERE Id = :theId];
        system.debug('test Id page2 2 ===> '+lstorder1);
        for(Order objOr: lstorder1)
        {
          objOr.OrderApprovalStatus__c = 'Aprobado por ADV';
          update objOr;
        }
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    // FIN Filitto : PFTA-9428

    /* AM 25/04/2018 PFTA-6992 COMPRA PACKS*/
    @RemoteAction
    global static Map<String, Object> getCarts(String cartId) {
        System.debug('getCarts');
        String methodName='getCarts';
        System.debug('cartId: ' +cartId);
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        /*Usar el cartId del input data to work */
        input.put('cartId', cartId);
        input.put('price', true);
        input.put('validate', true);
        System.debug('input data: ' + input);
        vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
        if(!Test.isRunningTest()){
            Object cpqAppHandlerReturn = cpqAppHandler.invokeMethod(methodName, input, outputMap, null);
            System.debug(cpqAppHandlerReturn);      
        }

        return outputMap;
    }

    @RemoteAction
    global static Map<String, Object> getExpandedPacksItems(String cartId, String itemId, String productHierarchyPath) {
        System.debug('getExpandedPacksItems');
        String methodName='getExpandedItems';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        /*Usar el cartId e itemId del input data to work */
        input.put('cartId', cartId);
        input.put('itemId', itemId);
        input.put('fields','vlocity_cmt__OneTimeLoyaltyPrice__c,vlocity_cmt__OneTimeLoyaltyTotal__c,vlocity_cmt__CurrencyPaymentMode__c,Id,vlocity_cmt__LineNumber__c,vlocity_cmt__Action__c,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__JSONAttribute__c,PricebookEntry.Product2.Name,PricebookEntry.Product2.ProductCode,PricebookEntry.Product2.Id,PricebookEntry.Product2.Type__c,PricebookEntry.Product2.vlocity_cmt__IsConfigurable__c,PricebookEntryId,PricebookEntry.Pricebook2Id,ListPrice,UnitPrice,Quantity,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__RootItemId__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__ProductHierarchyPath__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__RecurringCalculatedPrice__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__RecurringDiscountPrice__c,vlocity_cmt__RecurringTotal__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__CpqMessageData__c,vlocity_cmt__ServiceAccountId__c,vlocity_cmt__ServiceAccountId__r.Name,vlocity_cmt__ServiceAccountId__r.Id,vlocity_cmt__BillingAccountId__c,vlocity_cmt__BillingAccountId__r.Name,vlocity_cmt__BillingAccountId__r.Id,vlocity_cmt__PricingLogData__c,vlocity_cmt__ItemName__c');
        input.put('productHierarchyPath', productHierarchyPath);
        System.debug('input data: ' + input);
        vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
        if(!Test.isRunningTest()){
            Object cpqAppHandlerReturn = cpqAppHandler.invokeMethod(methodName, input, outputMap, null);
            System.debug(cpqAppHandlerReturn);

            System.debug(outputMap);

            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outputMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);
            List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;
            
            for(vlocity_cmt.JSONRecord record: pbeList){
                vlocity_cmt.JSONResult resultChildProducts = (vlocity_cmt.JSONResult)record.nameResult.get('childProducts');
                if(resultChildProducts != null){
                    List<vlocity_cmt.JSONRecord> pbeChildList  =  (List<vlocity_cmt.JSONRecord>)resultChildProducts.records;
                    for(vlocity_cmt.JSONRecord recordChild: pbeChildList){
                        Map<String, Object> pricingElementMap = new Map<String, Object>();
                        Product2 product2Fields = (product2)recordChild.fields.get('Product2');
                        if(product2Fields != null){
                            vlocity_cmt__PriceListEntry__c priceListEntry = [select Id, Name, vlocity_cmt__ProductId__c,vlocity_cmt__PricingElementId__c  from vlocity_cmt__PriceListEntry__c where vlocity_cmt__ProductId__c = :product2Fields.Id LIMIT 1];
                            vlocity_cmt__PricingElement__c pricingElement = [select Id, vlocity_cmt__Amount__c from vlocity_cmt__PricingElement__c where Id = :priceListEntry.vlocity_cmt__PricingElementId__c LIMIT 1];
                            Map<String, Object> otPrice = new Map<String, Object>();
                            otPrice.put('label', 'Pricing Element');
                            otPrice.put('value', pricingElement.vlocity_cmt__Amount__c);
                            recordChild.fields.put('vlocity_cmt__PricingElement__c', otPrice);
                        }

                    }
                }
            }

            result.records = pbeList;

        }

        return outputMap;

    }

    @RemoteAction
    global static Map<String, Object> addToCartItems(Map<String, Object> inputMap) {
        System.debug('addToCartItems');
        vlocity_cmt.CPQAppHandler app = new vlocity_cmt.CPQAppHandler ();
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        List<Map<String,Object>> items = new List<Map<String,Object>>();
        Map<String,Object> mappa = new Map<String,Object>();
        String methodName = (String) inputMap.get('methodName');
        String cartId = (String) inputMap.get('cartId');
        String itemId = (String) inputMap.get('itemId');
        String parentId = (String) inputMap.get('parentId');
        String parentHierarchyPath = (String) inputMap.get('parentHierarchyPath');
        String product2Id = (String) inputMap.get('product2Id');
        String name = (String) inputMap.get('name');
        String id = (String) inputMap.get('id');
        Map<String, Object> parentRecordFields = new Map<String, Object>();
        
        mappa.put('itemId', itemId);
        if(!String.isEmpty(parentId)){
            mappa.put('parentId', parentId);
        }
        
        if(!String.isEmpty(parentHierarchyPath)){
            mappa.put('parentHierarchyPath', parentHierarchyPath);
            parentRecordFields.put('productHierarchyPath', parentHierarchyPath);
        }

        if(!String.isEmpty(product2Id)){
            parentRecordFields.put('Product2Id', product2Id);
            parentRecordFields.put('isVirtualItem', true);
            parentRecordFields.put('hasChildren', true);
        }

        if(!String.isEmpty(name)){
            parentRecordFields.put('Name', name);
        }
        
        if(!String.isEmpty(id)){
            parentRecordFields.put('Id', id);
        }

        Map<String, Object> parentRecord = new Map<String, Object>();
        parentRecord.put('records', new List<Object>());

        ((List<Object>)parentRecord.get('records')).add(parentRecordFields);
        if(!parentRecordFields.isEmpty()){
            mappa.put('parentRecord', parentRecord);
        }
        items.add(mappa);
        input.put('cartId', cartId);
        input.put('items', items);
        input.put('price', true);
        input.put('validate', true);

        if(parentId == null && parentHierarchyPath == null && product2Id == null && name == null && id == null){
            input.put('includeAttachment', false);
            input.put('pagesize', 10);
            input.put('lastRecordId', null);
            input.put('hierarchy', -1);
        }

        System.debug('addToCartItems->input: '+JSON.serialize(input));
        if(!Test.isRunningTest()){
            app.invokeMethod('postCartsItems',input, output, options);
        }
        System.debug('output: '+output);
        return output;

    }

    @RemoteAction
    global static Map<String, Object> getCartsProductsById(Map<String, Object> inputMap) {
        System.debug('taOrderController:getCartsProductsById');
        String cartId = (String) inputMap.get('cartId');
        String productId = (String) inputMap.get('productId');
        String methodName = 'getCartsProducts';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        input.put('cartId', cartId);
        input.put('fields', 'IsActive,Id,Name,UnitPrice,ProductCode,vlocity_cmt__RecurringPrice__c,product2.description,product2.Tipo_de_Bien_de_Uso__c,Product2.Marca__c,Product2.vlocity_cmt__HelpText__c,Product2.PrefaRequired__c,Product2.vlocity_cmt__CategoryData__c,Product2.Family,Product2.TA_Custom_Description__c,Product2.vlocity_cmt__JSONAttribute__c,Product2.vlocity_cmt__Type__c' );
        input.put('hierarchy', 10);
        input.put('includeAttachment', true);
        input.put('filters', 'Id:'+productId);

        if(!Test.isRunningTest()){
        
            taCpqAppHandler cpqHandler = new taCpqAppHandler();
            cpqHandler.invokeMethod(methodName, input, outputMap, options);
            System.debug('outputMap: ' + outputMap);
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outputMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);
            List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;

            System.debug('pbeList: '+ pbeList);
            
            for(vlocity_cmt.JSONRecord record: pbeList){
                vlocity_cmt.JSONResult resultChildProducts = (vlocity_cmt.JSONResult)record.nameResult.get('childProducts');
                Product2 product2Result = (product2)record.fields.get('Product2');
                System.debug('product2Result: ' +product2Result);
                if(resultChildProducts != null){
                    List<vlocity_cmt.JSONRecord> pbeChildList  =  (List<vlocity_cmt.JSONRecord>)resultChildProducts.records;
                    for(vlocity_cmt.JSONRecord recordChild: pbeChildList){
                        Map<String, Object> pricingElementMap = new Map<String, Object>();
                        Product2 product2Fields = (product2)recordChild.fields.get('Product2');
                        System.debug('product2Fields: ' + product2Fields);
                        if(product2Fields != null){

                            List<vlocity_cmt__CompiledAttributeOverride__c>  overrideItem = [SELECT Name, vlocity_cmt__AttributeRules__c,vlocity_cmt__JSONAttribute__c,vlocity_cmt__ProductId__c FROM vlocity_cmt__CompiledAttributeOverride__c WHERE vlocity_cmt__ProductId__c = :product2Result.Id];

                            if(overrideItem.size() > 0) {
                                for(vlocity_cmt__CompiledAttributeOverride__c recordOverride: overrideItem){
                                    if(recordOverride.Name.indexOf(product2Fields.Id) != -1){
                                        product2Fields.vlocity_cmt__JSONAttribute__c = recordOverride.vlocity_cmt__JSONAttribute__c;
                                    }
                                }
                            }
                            

                        }

                    }
                }
            }

            result.records = pbeList;
        }
        
        return outputMap;
    }

    @RemoteAction
    global static Map<String, Object> deleteCartItem(Map<String, Object> inputMap) {
        System.debug('deleteCartItem');
        //String methodName = (String) inputMap.get('methodName');
        String methodName = 'deleteCartsItems';
        String cartId = (String) inputMap.get('cartId');
        String id = (String) inputMap.get('Id');
        String parentHierarchyPath = (String) inputMap.get('parentHierarchyPath');
        String product2Id = (String) inputMap.get('product2Id');
        String name = (String) inputMap.get('name');
        String groupId = (String) inputMap.get('groupId');
        String inCartQuantityId = (String) inputMap.get('inCartQuantityId');
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        List<Map<String,Object>> items = new List<Map<String,Object>>();
        Map<String,Object> mappa = new Map<String,Object>();
        Map<String, Object> parentRecordFields = new Map<String, Object>();

        if(!String.isEmpty(parentHierarchyPath)){
            parentRecordFields.put('productHierarchyPath', parentHierarchyPath);
        }

        if(!String.isEmpty(product2Id)){
            parentRecordFields.put('Product2Id', product2Id);
        }

        if(!String.isEmpty(name)){
            parentRecordFields.put('Name', name);
        }

        if(!String.isEmpty(groupId)){
            parentRecordFields.put('Id', groupId);
        }

        if(!String.isEmpty(inCartQuantityId)){
            Map<String,Object> inCartQuantity = new Map<String,Object>();
            inCartQuantity.put(inCartQuantityId, 1);
            System.debug('inCartQuantity: '+ inCartQuantity);
            Map<String,Object> value = new Map<String,Object>();
            value.put('value', inCartQuantity);

            parentRecordFields.put('vlocity_cmt__InCartQuantityMap__c', value);
        }

        if(!parentRecordFields.isEmpty()){
            parentRecordFields.put('isVirtualItem', true);
            Map<String, Object> parentRecord = new Map<String, Object>();
            parentRecord.put('records', new List<Object>());
            ((List<Object>)parentRecord.get('records')).add(parentRecordFields);
            mappa.put('parentRecord', parentRecord);
            items.add(mappa);
            input.put('items', items);
        }     

        input.put('cartId', cartId);
        input.put('id', id);
        input.put('hierarchy', -1);
        input.put('includeAttachment', false);
        input.put('pagesize', 20);
        input.put('price', true);
        input.put('validate', true);

        System.debug('deleteCartItem->input data: ' + JSON.serialize(input));
        vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
        if(!Test.isRunningTest()){
            Object cpqAppHandlerReturn = cpqAppHandler.invokeMethod(methodName, input, outputMap, null);
        }
        System.debug('outputMap: ' + outputMap);
        return outputMap;
    }

    void CanUseBalanceDiscount(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('CanUseBalanceDiscount');

        Boolean canUseBalanceDiscount = false;

        String orderId = (String) options.get('orderId');
            List<OrderItem> orderItems = [
            SELECT
                Id,
                vlocity_cmt__Product2Id__r.Name,
                vlocity_cmt__Product2Id__r.ProductCode,
                vlocity_cmt__Product2Id__r.StockKeepingUnit,
                vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c,
                vlocity_cmt__Product2Id__r.Tangible__c,
                vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c,
                vlocity_cmt__Product2Id__r.Family,
                Quantity,
                vlocity_cmt__EffectiveOneTimeTotal__c,
                vlocity_cmt__EffectiveRecurringTotal__c,
                vlocity_cmt__Product2Id__r.FAN_IntegrationKey__c,
                Huawei_Invoice_Item_Sequence__c,
                vlocity_cmt__PricingLogData__c
            FROM OrderItem
            WHERE
                OrderId = :orderId
                AND IsBillable__c = true
                AND vlocity_cmt__Action__c = 'Add'
            ORDER BY CreatedDate DESC
        ];
        // System.debug(JSON.serialize(orderItems));

        List<OrderItem> billablesFacturableEnVentaObligatorio = new List<OrderItem>();
        for(OrderItem item : orderItems)
        {
            Boolean isBillable = false;
            // System.debug('vlocity_cmt__JSONAttribute__c');
            // System.debug(item.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c);
            Map<String, Object> attrbBillable = AssetAttributesUtils.GetJSONAttribute(item.vlocity_cmt__Product2Id__r.vlocity_cmt__JSONAttribute__c, 'Facturable en Venta');
            if(attrbBillable != null && attrbBillable.get('value__c') != null && 
                (attrbBillable.get('value__c') == 'Requerido')){
                // isBillable = Boolean.valueOf(attrbBillable.get('value__c'));
                billablesFacturableEnVentaObligatorio.add(item);
            }
            // if (isBillable) billablesFacturableEnVentaObligatorio.add(item);
        }
        // System.debug(JSON.serialize(billablesFacturableEnVentaObligatorio));
        if(orderItems.size() > 0 && billablesFacturableEnVentaObligatorio.size() == 0){
            canUseBalanceDiscount = true;
        }

        outMap.put('canUseBalanceDiscount', canUseBalanceDiscount);
    }
    /* FIN AM PFTA-6992 COMPRA PACKS*/

    // PFTA-7756 - INI
    void AddToCartItemsDelivery(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            String orderId = String.valueOf(options.get('orderId'));
            String deliveryMethodService = String.valueOf(options.get('deliveryMethodService'));

            if (orderId != null) {
                Map<String, Object> deliveryMethodServiceNode = taMatrixUtils.getDeliveryMethodServiceCode(deliveryMethodService);
                deliveryMethodService = (String) deliveryMethodServiceNode.get('DeliveryMethodServiceCodes__DeliveryMethodServiceCode');

                // SE AGREGA ENVIO BASE
                List<Product2> listProductos = [SELECT Id FROM Product2 WHERE ProductCode = :COD_PRODUCTO_ENVIO_BASE];

                List<Pricebook2> listPricebook = [SELECT Id FROM Pricebook2 WHERE Id IN (SELECT Pricebook2Id FROM PricebookEntry WHERE Product2Id = :listProductos[0].Id) AND IsActive = true];

                List<PricebookEntry> listPricebookEntry = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :listPricebook[0].Id AND Product2Id = :listProductos[0].Id];

                inputMap.put('itemId', listPricebookEntry[0].Id);
                inputMap.put('cartId', orderId);
                Map<String, Object> response = taOrderController.addToCartItems(inputMap);
                if(!Test.isRunningTest()){
                    vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult) response.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);
                    List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>) result.records;
                    
                    for (vlocity_cmt.JSONRecord record : pbeList) {
                        Product2 product2Fields = (Product2) record.fields.get('Product2');
                        vlocity_cmt.JSONField idFields = (vlocity_cmt.JSONField) record.fields.get('Id');
                        String idFieldValue = (String) idFields.value;
                        
                        vlocity_cmt.JSONResult resultChildProducts = (vlocity_cmt.JSONResult) record.nameResult.get('childProducts');
                        if(resultChildProducts != null) {
                            List<vlocity_cmt.JSONRecord> pbeChildList = (List<vlocity_cmt.JSONRecord>) resultChildProducts.records;

                            for (vlocity_cmt.JSONRecord recordChild : pbeChildList) {
                                Map<String, Object> productCodeFields = (Map<String, Object>) recordChild.fields.get('ProductCode');
                                String productCodeValue = (String) productCodeFields.get('value');

                                if (productCodeValue == deliveryMethodService) {
                                    vlocity_cmt.JSONAction actionAddToCart = (vlocity_cmt.JSONAction) recordChild.actions.get('addtocart');
                                    vlocity_cmt.JSONAction.JSONRemoteAction actionAddToCartRemote = (vlocity_cmt.JSONAction.JSONRemoteAction) actionAddToCart.remote;
                                    Map<String, Object> params = (Map<String, Object>) actionAddToCartRemote.params;
                                    String methodName = (String) params.get('methodName');
                                    String cartId = (String) params.get('cartId');
                                    List<Map<String, Object>> items = (List<Map<String, Object>>) params.get('items');
                                    String itemId = (String) items[0].get('itemId');
                                    String parentId = (String) items[0].get('parentId');
                                    String parentHierarchyPath = (String) items[0].get('parentHierarchyPath');
                                    String product2Id = (String) product2Fields.get('Id');
                                    String name = (String) product2Fields.get('Name');

                                    Map<String, Object> inputMapChild = new Map<String, Object>();
                                    inputMapChild.put('methodName', methodName);
                                    inputMapChild.put('cartId', cartId);
                                    inputMapChild.put('itemId', itemId);
                                    inputMapChild.put('parentHierarchyPath', parentHierarchyPath);
                                    inputMapChild.put('parentId', parentId);
                                    inputMapChild.put('product2Id', product2Id);
                                    inputMapChild.put('name', name);
                                    inputMapChild.put('id', idFieldValue);

                                    // AddToCart splitted in two methods (add for Envio & add for product child) to avoid Governor Limit
                                    // OS flow continues in the AddToCartItemsDeliveryChild with the data gathered here
                                    // Map<String, Object> responseChildAdd = taOrderController.addToCartItems(inputMapChild);
                                    outMap.put('inputMapChild', inputMapChild);

                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    void AddToCartItemsDeliveryChild(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            System.debug('AddToCartItemsDeliveryChild');
            System.debug('INPUT: ' + inputMap);
            System.debug('OPTIONS: ' + options);

            Map<String, Object> inputMapChild = new Map<String, Object>();
            inputMapChild = (Map<String, Object>) options.get('inputMapChild');

            Map<String, Object> responseChildAdd = taOrderController.addToCartItems(inputMapChild);
            outMap.put('responseChild', responseChildAdd);
            System.debug('responseChildAdd: ' + responseChildAdd);
        }
        catch (Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    void DeleteCartItemsDelivery(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            String orderId = String.valueOf(options.get('orderId'));

            List<OrderItem> listOrderItems = [SELECT Id FROM OrderItem WHERE OrderId = :orderId AND ProductCode__c = :COD_PRODUCTO_ENVIO_BASE];

            Map<String, Object> inputMapDelete = new Map<String, Object>();
            inputMapDelete.put('cartId', orderId);
            inputMapDelete.put('Id', listOrderItems[0].Id);

            Map<String, Object> responseDelete = taOrderController.deleteCartItem(inputMapDelete);
        }
        catch (Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }

    void DeleteCartItemsDeliveryChild(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            String orderId = String.valueOf(options.get('orderId'));

            List<OrderItem> listProdEnvio = [SELECT Id FROM OrderItem WHERE OrderId = :orderId AND ProductCode__c = 'FAN_ENV_000'];

            List<OrderItem> listProdEnvioChild = [SELECT Id FROM OrderItem WHERE OrderId = :orderId AND vlocity_cmt__ParentItemId__c = :listProdEnvio[0].Id];

            if (listProdEnvioChild.size() == 1) {
                Map<String, Object> inputMapDelete = new Map<String, Object>();
                inputMapDelete.put('cartId', orderId);
                inputMapDelete.put('Id', listProdEnvioChild[0].Id);

                Map<String, Object> responseDelete = taOrderController.deleteCartItem(inputMapDelete);
            }
        }
        catch (Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
    // PFTA-7756 - FIN
  // PFTA-11425 #Start
  
    public static void ReleaseLinesFromOrder(List<Order> orders) {
        /**ß
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Release Lines previously reserved in an Order
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   rocio.s.caceres
        * @date     2018-07-18
        * @param    Order Set 
        * @return   nothing
        */
        String lineNumber;
        Map<string, string> linesToRelease = new Map<string, string>();
        Map<String,Object> jsonAttribute;
        List<OrderItem> plansProducts;
        String lineAux;

        try {
            System.debug('ReleaseLines');
            
            Set<Id> orderIds = new Set<Id>();
		    for(Order o : orders)
		    {
			   orderIds.add(o.id);
		    }

            plansProducts = [SELECT Id, Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__Type__c, vlocity_cmt__SerialNumber__c, vlocity_cmt__JSONAttribute__c, FromStock__c 
							FROM OrderItem WHERE OrderId IN :orderIds AND Product2.vlocity_cmt__Type__c = 'Plan Prepago'];
            
			for (OrderItem planProduct : plansProducts){
                jsonAttribute = AssetAttributesUtils.GetJSONAttribute(planProduct.vlocity_cmt__JSONAttribute__c, 'Numero de Linea');
                lineNumber = (String)((Map<String, Object>)jsonAttribute.get('attributeRunTimeInfo')).get('value');
                if (String.isNotBlank(lineNumber)) linesToRelease.put(lineNumber, 'DESBLOQ');
            }

            LinesManager lineManager = new LinesManager();
            if(linesToRelease.KeySet().size() > 0 )
                lineManager.FreeReservedLines(linesToRelease);
        }
        catch(Exception e) {
            System.debug('ReleaseLines Msg: ' + e.getMessage());
            System.debug('ReleaseLines Cause: ' + e.getCause());
            System.debug('ReleaseLines Stack Trace: ' + e.getStackTraceString());
        }
    }
    
    	
	private static void RealeaseNmuReserve( List<Order> orders) {
        try{
            System.debug('RealeaseNmuReserve List');
			String codAplicacion = '2';
			String idUnicoTransaccion = GuidUtil.NewGuid();
			System.debug('taOrderController:idUnicoTransaccion: ' + idUnicoTransaccion);
			for(Order o: orders){
                if(!Test.isRunningTest()){
            		Map<string, Object> response = IFS_S101_reserveOrRelease.reserveOrRelease('L', codAplicacion, o.OrderNumber, '0', idUnicoTransaccion, new Map<String, Map<String, Object>>());
				    System.debug('response: ' + response);
                }
				
			}

        }catch(DmlException e){
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            throw e;
        }
    }
    
    
    private static void AnulaStockReserved(List<Order> orders) {
		
        System.debug('AnulaStockReserved');
		//Se crea una lista de ID para no volver a reescribir el metodo GetOrderSerials
		List <Id> orderList =  New List <Id> ();
		for(Order o : orders)
		    {
			   orderList.add(o.id);
		    }
        List<OrderItem> orderItems = GetOrderSerials(orderList);
        Map<String,String> oldSerialNumbers = new Map<String,String>();
        System.debug('PRINT orderItems SIZE ON CANCEL');
        System.debug(orderItems.size());
        if(orderItems.size() > 0){
            System.debug('CANCEL ORDER INSIDE IF > 0');
            for(OrderItem item : orderItems){
                if (string.isNotBlank(item.vlocity_cmt__SerialNumber__c))
                {
                    System.debug('vlocity_cmt__SerialNumber__c IS NOT BLANK');
                    oldSerialNumbers.put(item.vlocity_cmt__SerialNumber__c, item.FromStock__c);
                    item.vlocity_cmt__SerialNumber__c = null;
                }
            }

            System.debug('oldSerialNumbers SIZE -> ' + oldSerialNumbers.size());
            if (oldSerialNumbers.size() > 0)
            {
				for(Order o  : orders){
					MoveSerialsStock(INSTANCE_VENTA_NORMAL,INSTANCE_ANULAR_RESERVA,oldSerialNumbers, o.PickUpStoreLocation__r.AssociatedWarehouseId__c, o.Delivery_Method__c);
				}
                update orderItems;
            }
        }

    }
    
    public static void CancelOrderAndRelease(List<Order> orders) {
        /**
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Cancel Order and Release Lines, Numbers and Stock
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   rocio.s.caceres
        * @date     2018-18-07
        * @return   nothing
        */
		   
   		   ReleaseLinesFromOrder(orders);
		   RealeaseNmuReserve(orders);
		   AnulaStockReserved(orders);
		   for(Order o: orders){	   
				
			  try{
					if ((o.TrackingStatus__c == 'Pendiente de pago') && o.PreInvoiceNumber__c != null){
						Map<String,Object> inMap, outMap, optMap;
						inMap = new Map<String,Object>();
						outMap = new Map<String,Object>();
						optMap = new Map<String,Object>();
						optMap.put('OrderId', o.Id);
                        if(!Test.isRunningTest()){
						    taSalesAnnulmentHandler.HotInvoiceRollback(inMap, outMap, optMap);
                        }
						o.TrackingStatus__c = 'Cancelada - Timeout Caja';
					}
					else{
						o.TrackingStatus__c = 'Cancelada - Timeout';
					}

				}
				catch(Exception e){
					System.debug('CancelOrderAndRelease Msg: ' + e.getMessage());
					System.debug('CancelOrderAndRelease Cause: ' + e.getCause());
					System.debug('CancelOrderAndRelease Trace: ' + e.getStackTraceString());
				}
          
				o.Status = 'Cancelled';
			}
		update orders;

    }
    
  
    
  // PFTA-11425 #Finish
}