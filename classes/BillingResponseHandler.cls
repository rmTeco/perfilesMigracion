global with sharing class BillingResponseHandler implements vlocity_cmt.VlocityOpenInterface
{
    global BillingResponseHandler () {}
    //public class ServiceException extends Exception {}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('callBackService224')){
                callBackService224(inputMap, outMap, options);
            }
            /*if (methodName.equals('testGetSystemURL')){
                testGetSystemURL(inputMap, outMap, options);
            }*/
            if (methodName.equals('prepareOrderForOM')){
                prepareOrderForOM(inputMap, outMap, options);
            }
            if (methodName.equals('callNominationCheckout')){
                callNominationCheckout(inputMap, outMap, options);
            }
            if (methodName.equals('getNominationAssets')){
                getNominationAssets(inputMap, outMap, options);
            }
            if(methodName.equals('sendOrderToOM')){
                String orderId = (String) options.get('IdOrder');
                sendOrderToOM(orderId);
            }
            result = false;  
        } 
        catch(Exception e)
        {
            throw e;
        }
        return result;
    }
    
public static Boolean callBackService224(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
  try {
    inputMap = new Map < String, Object > ();
    if (outMap == null)
      outMap = new Map < String, Object > ();
    String jsonCallBack = (String) options.get('JSONResponse');
    Map < String, Object > objCallBack = (Map < String, Object > ) JSON.deserializeUntyped(jsonCallBack);
    Map < String, Object > objCallBackInfo = (Map < String, Object > ) objCallBack.get('invoiceAndPaymentNotification');
    String orderId;
    //PFTA-11176. La integracion S029 envía un OrderNumber en lugar de un Id, por lo que HW devuelve este parametro
    String orderNum = (String) objCallBackInfo.get('SalesOrderId');
    String callBackStatus = (String) objCallBackInfo.get('Status');
    String legalInvoiceNumber = (String) objCallBackInfo.get('LegalInvoiceNumber');
    String statusInvoice = (String) objCallBackInfo.get('StatusInvoice');

    system.debug('orderNum: ' + orderNum);
    if (orderNum != null) {
      Order objOrder = [
        SELECT
        Id,
        OrderNumber,
        TotalAmount,
        TrackingStatus__c,
        TrackingStatusDetail__c,
        Gestion__c,
        OriginStoreLocation__c,
        Delivery_Method__c,
        LegalInvoiceNumber__c,
        CreatedDate
        FROM Order
        WHERE OrderNumber = : orderNum
      ];

      orderId = objOrder.Id;

      if (callBackStatus == 'payment succeed') {
        System.debug('OriginStoreLocation: ' + objOrder.OriginStoreLocation__c);
        vlocity_cmt__BusinessSite__c store = [SELECT Channel__c, Channel_Type__c FROM vlocity_cmt__BusinessSite__c WHERE Id = : objOrder.OriginStoreLocation__c];
        System.debug('Channel: ' + store.Channel_Type__c);

        switch on objOrder.Gestion__c {
            when 'Recarga' {
                String txId = processRecharge(objOrder, legalInvoiceNumber, statusInvoice);
                outMap.put('txId', txId);
            }
            when 'Reseteo de Cuota' {
                processInternetPackReset(objOrder);
            }
            when else {
                processOrderHandOver(objOrder, store, legalInvoiceNumber, statusInvoice);
            }                
        }
        
        SendSuccesfulOrderClientNotification(objOrder.Id);
        if (store.Channel__c == 'Telefónico' || store.Channel_Type__c == 'Web') {
          SendSuccesfulPaymentClientNotification(objOrder.Id);
        }
      } else {
        String reasonCode = (String) objCallBackInfo.get('ReasonCode');
        String reasonCodeName = (String) objCallBackInfo.get('ReasonCodeName');
        processPaymentError(objOrder, reasonCode, reasonCodeName);
      }
  }
  return true;
} catch (Exception e) {
  System.debug('callBackService224 Msg: ' + e.getMessage());
  System.debug('callBackService224 Cause: ' + e.getCause());
  System.debug('callBackService224 Trace: ' + e.getStackTraceString());
  return false;
}
}

public static void processInternetPackReset(Order objOrder) {
  vlocity_cmt__PaymentAdjustment__c payment = [SELECT Id, toLabel(vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c) FROM vlocity_cmt__PaymentAdjustment__c WHERE Order__r.Id = :objOrder.Id];
  OrderItem item = [SELECT Id, Product2.Id, Product2.vlocity_cmt__JSONAttribute__c, Product2.ProductCode, Product2.ID_Sistema_Origen__c, vlocity_cmt__AssetId__r.Subscription_Id__c, vlocity_cmt__AssetId__r.MSISDN__c FROM OrderItem WHERE OrderId = :objOrder.Id LIMIT 1];
  ta_sales_renovacionDatos.ChangeSubOffering(objOrder.Id, payment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c, item);
  Map<String,Object> inputMap = new Map<String,Object>();
  Map<String,Object> outMap = new Map<String,Object>();
  Map<String,Object> options = new Map<String,Object>();
  inputMap.put('nroLinea',item.vlocity_cmt__AssetId__r.MSISDN__c);
  ta_sales_renovacionDatos.EnviarSMSExito(inputMap, outMap, options);
}

public static void updateOrderFromPaymentStatus(Order objOrder, String legalInvoiceNumber, String statusInvoice) {
  if (legalInvoiceNumber != null) {
    objOrder.LegalInvoiceNumber__c = legalInvoiceNumber;
  }

  objOrder.TrackingStatus__c = 'Pagos Imputados';
  objOrder.Received224_Date__c = Date.Today();

  update objOrder;

  if (statusInvoice == 'invoice succeed') {
    objOrder.TrackingStatus__c = 'Factura Emitida';
    update objOrder;
  }
}

public static void processPaymentError(Order objOrder, String reasonCode, String reasonCodeName) {
  objOrder.TrackingStatus__c = 'Pago Fallido';
  if (reasonCode != null) {
    System.debug('reasonCode: ' + reasonCode);
    objOrder.TrackingStatusDetail__c = '';

    //PFTA-10108 - Notificaciones del servicio S224 durante el cobro y facturación de una orden
    objOrder.Reason_Code__c = reasonCode;

    if (reasonCodeName != null) {
      objOrder.Reason_Code_Name__c = reasonCodeName;
    }

    for (Order_Failed_Payment_Messages__c failedMessages: Order_Failed_Payment_Messages__c.getAll().values()) {
      if (failedMessages.Error_Code__c == reasonCode) {
        objOrder.TrackingStatusDetail__c = failedMessages.Error_Message__c;
      }
    }
    Map < String, Object > inMap = new Map < String, Object > ();
    Map < String, Object > oMap = new Map < String, Object > ();
    Map < String, Object > optMap = new Map < String, Object > ();
    List < Object > csFields = new List < Object > ();

    //DA - 12/03/18 Me traigo los reason codes correspondientes a Anuldada y a Cancelada
    optMap.put('CSName', 'TASalesCodeValue__c');
    optMap.put('CSAtribute', 'IF224ReasonAnulada');
    Map < String, Object > auxMap = new Map < String, Object > ();
    auxMap.put('field', 'Value__c');
    csFields.add(auxMap);
    optMap.put('CSFields', csFields);
    SaleManager sm = new SaleManager();
    sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
    TASalesCodeValue__c cs = (TASalesCodeValue__c) oMap.get('CSValues');
    String codAnulada = cs.Value__c;
    System.debug('codAnulada: ' + codAnulada);
    optMap.put('CSAtribute', 'IF224ReasonCancelada');
    sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
    cs = (TASalesCodeValue__c) oMap.get('CSValues');
    String codCancelada = cs.Value__c;
    System.debug('codCancelada: ' + codCancelada);
    optMap.put('CSAtribute', 'IF224ReasonCambioMedioPago');
    sm.invokeMethod('GetCustomSettingAtribute', inMap, oMap, optMap);
    cs = (TASalesCodeValue__c) oMap.get('CSValues');
    String codCambioMedioPago = cs.Value__c;
    System.debug('codCancelada: ' + codCambioMedioPago);

    //DA - 12/03/18. PFTA-8682 Lógica de acuerdo a respuesta de caja por cancelada o anulada
    if (reasonCode == codCambioMedioPago) { //Codigo 1
      objOrder.TrackingStatus__c = 'Pendiente de Cambio de Medio de Pago';
    }
    if (reasonCode == codAnulada) { //Codigo 2
      objOrder.TrackingStatus__c = 'Pago No Concretado';
    }
    if (reasonCode == codCancelada) { //Codigo 3
      taOrderController.CancelOrderAndRelease(objOrder.Id);
      objOrder.Status = 'Cancelled';
    }
  }
  update objOrder;
}

public static void processOrderHandOver(Order objOrder, vlocity_cmt__BusinessSite__c store, String legalInvoiceNumber, String statusInvoice) {
  updateOrderFromPaymentStatus(objOrder, legalInvoiceNumber, statusInvoice);
  //Código realizado para setear disconnectDate en null tanto para la orden como para sus orderItems
  //Comienzo
  List < orderItem > orderItems = [SELECT Id from orderItem where OrderId = : objOrder.Id];
  if (orderItems.size() > 0) {
    for (orderItem a: orderItems) {
      a.vlocity_cmt__DisconnectDate__c = null;
    }
  }
  Update orderItems;
  //Fin
  getPaymentResponse(objOrder.Id);
  Boolean tangibleExists = taOrderController.ValidateTangibleExistence(objOrder.Id);

  if(tangibleExists = true) {
    if (objOrder.Delivery_Method__c == 'Delivery')
        objOrder.TrackingStatus__c = 'Cobrado';
    else
    {
        switch on store.Channel_Type__c {
            when 'Oficinas Comerciales' {
                //PFTA-11418
                if (statusInvoice == 'invoice succeed') {
                    objOrder.TrackingStatus__c = 'Preparar pedido';
                    taOrderController.CreateStateTask(objOrder.Id, taOrderController.PENDIENTE_ARMADO_NOTIFICATION);
                }
            }
            when 'Agentes' {
                if (objOrder.Delivery_Method__c == 'Presencial') {
                    {
                        Map<String,Object> options = new Map<String,Object>();
                        options.put('idOrder',objOrder.Id);
                        taOrderController orderController = new taOrderController();
                        orderController.invokeMethod('OrderHandOverUpdate',null,null,options);
                    }
                }
                if (objOrder.Delivery_Method__c == 'Store Pick Up') {
                    vlocity_cmt__BusinessSite__c storeLocation = ta_sales_UserUtils.getStoreLocation(UserInfo.getUserId());
                    if (storeLocation.Channel_Type__c == 'Agentes')
                        objOrder.TrackingStatus__c = 'Pendiente de Entrega';
                    else
                        objOrder.TrackingStatus__c = 'Preparar pedido';

                    taOrderController.CreateStateTask(objOrder.Id, taOrderController.PENDIENTE_ARMADO_NOTIFICATION);
                }
            }
            when 'Call Center' {
                if (objOrder.Delivery_Method__c == 'Store Pick Up') {
                    objOrder.TrackingStatus__c = 'Preparar pedido';
                    taOrderController.CreateStateTask(objOrder.Id, taOrderController.PENDIENTE_ARMADO_NOTIFICATION);
                }
            }
        }
    }
  }
  update objOrder;
  system.debug('OM Antes' + objOrder.Id);
  //DA - 3/8/2018: Se envia la Orden a OM a través de un Future para evitar problema de operaciones DML
  //boolean isOmniScript = false;
  //vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(objOrder.Id, isOmniScript);
  List<Id> oIDs = new List<Id>();
  oIDs.add(objOrder.Id);
  sendOrderToOMFuture(OIds);
  system.debug('OM Paso');
  
}

private static void sendOrderToOM(String orderId) {
        
    String responseOM = vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(orderId, false );
    Map<String, Object> mapResponseOM = (Map<String, Object>) JSON.deserializeUntyped(responseOM);

    if(mapResponseOM.get('isOk')!= true){
        throw new FuncException('Error: ' + mapResponseOM.get('errorMsg'));
    }
        
}  

@future(callout=true)
private static void sendOrderToOMFuture(List<Id> orderIds) {
//DA - 3/8/2018: Method used to send an order to OM using future method
    system.debug('sendOrderToOMFuture Begin');
    for (Id oId: orderIds) {
        vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(oId,false);
    }
    system.debug('sendOrderToOMFuture End');    
}

public static String processRecharge(Order objOrder, String legalInvoiceNumber, String statusInvoice) {
  String txId;
  System.debug('Gestion__c: ' + objOrder.Gestion__c);
  OrderItem objOrderItem = [SELECT vlocity_cmt__EffectiveOneTimeTotal__c, vlocity_cmt__JSONAttribute__c, UnitPrice, vlocity_cmt__AssetId__c FROM OrderItem WHERE OrderId = : objOrder.Id];
  System.debug('objOrderItem: ' + objOrderItem);
  String assetId = objOrderItem.vlocity_cmt__AssetId__c;

  Asset objAsset = [SELECT Subscription_Id__c, MSISDN__c FROM Asset WHERE Id = : assetId];

  String nroLinea = objAsset.MSISDN__c;
  //Decimal monto = objOrderItem.vlocity_cmt__EffectiveOneTimeTotal__c;
  Decimal monto = objOrderItem.UnitPrice;
  String sMonto = monto.toPlainString();
  String subscriptionId = objAsset.Subscription_Id__c;

  System.debug('sMonto: ' + sMonto);
  System.debug('nroLinea: ' + nroLinea);
  System.debug('subscriptionId: ' + subscriptionId);
  
  Map < String, Object > inputMap = new Map < String, Object > ();
  Map < String, Object > outMapCRecharge = new Map < String, Object > ();
  Map < String, Object > options = new Map < String, Object > ();

  options.put('nroLinea', nroLinea);
  options.put('ChargeAmmount', monto);
  options.put('subscriptionId', subscriptionId);
  LinesManager lManager = new LinesManager();

  lManager.invokeMethod('CreditRecharge', inputMap, outMapCRecharge, options);
  System.debug('outMapCRecharge: ' + outMapCRecharge);
  updateOrderFromPaymentStatus(objOrder, legalInvoiceNumber, statusInvoice);
  String creditError = (String) outMapCRecharge.get('Error');
  if (creditError == null) {
    objOrder.TrackingStatus__c = 'Recargado';
    txId = (String) outMapCRecharge.get('txId');
    sendClientRechargeConfirmation(nroLinea, sMonto);//Envio SMS al cliente avisando que la recarga fue ok
    objOrder.Status = 'Activated';
  } else {
    objOrder.TrackingStatusDetail__c = creditError;
  }
  update objOrder;
  return txId;
}

@future(callout=true)
public static void sendClientRechargeConfirmation(String nroLinea, String sMonto) {
  Map < String, String > variables = new Map < String, String > ();
    variables.put('monto', sMonto);
    variables.put('linea', nroLinea);
  Boolean SMSsendStatus = taSalesSMSInteraction.sendSMSTemplate(nroLinea, 'Recarga Exitosa', variables);
}

    @future(callout=true)
    public static void SendSuccesfulPaymentClientNotification(Id idOrder){
        Order objOrder = [
                SELECT 
                    Id,
                    Account.vlocity_cmt__PrimaryContactId__r.FirstName,
                    Account.vlocity_cmt__PrimaryContactId__r.LastName,
                    Account.vlocity_cmt__PrimaryContactId__r.Email,
                    Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c,
                    Received224_Date__c,
                    OrderNumber
                FROM Order 
                WHERE Id = :idOrder];

        List<vlocity_cmt__PaymentAdjustment__c> payments = [SELECT Id, toLabel(vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c), toLabel(vlocity_cmt__PaymentMethodId__r.BankEntityName__c), toLabel(vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c), vlocity_cmt__Amount__c FROM vlocity_cmt__PaymentAdjustment__c WHERE Order__c = :objOrder.Id];

        String jsonInput = '{"To": {"Address": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.Email + '","SubscriberKey": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.Email + '",';
        jsonInput += '"ContactAttributes": {';
        jsonInput += '"FirstName": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.FirstName + '",';
        jsonInput += '"LastName": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.LastName + '",';
        jsonInput += '"DocumentNumber": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c + '",';
        jsonInput += '"PaymentMethodsHeader": "MethodType|Entity|Bank|Amount",';
        jsonInput += '"PaymentMethodsValues": "';
        Integer count = 0;
        for (vlocity_cmt__PaymentAdjustment__c payment : payments)
        {
            if (count == 0)
            {
                count++;
            } else
            {
                jsonInput += ';';
            }
            jsonInput += payment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c + '|' + payment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c + '|' + payment.vlocity_cmt__PaymentMethodId__r.BankEntityName__c + '|' + payment.vlocity_cmt__Amount__c;
        }
        jsonInput += '",';
        if (objOrder.Received224_Date__c != null)
            jsonInput += '"PaymentDateTime": "' + objOrder.Received224_Date__c + '",';
        jsonInput += '"OrderNumber": "' + objOrder.OrderNumber + '"},';
        jsonInput += '"Options": "SYNC","Channel": "Email","processName": "SendSuccesfulPaymentClientNotification"}}';

        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        TriggeredSendNotificationService sender = new TriggeredSendNotificationService();
        Map<String,Object> inputMap = (Map<String,Object>) JSON.deserializeUntyped(jsonInput);
        sender.invokeMethod('sendMessage',inputMap, outMap, options);
        System.debug('outMap: ' + outMap);
    }

    @future(callout=true)
    public static void SendSuccesfulOrderClientNotification(Id idOrder){
        Order objOrder = [
                SELECT 
                    Id,
                    Account.vlocity_cmt__PrimaryContactId__r.FirstName,
                    Account.vlocity_cmt__PrimaryContactId__r.LastName,
                    Account.vlocity_cmt__PrimaryContactId__r.Email,
                    Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c,
                    EffectiveDate,
                    OrderNumber,
                    vlocity_cmt__EffectiveOrderTotal__c,
                    EndDate,
                    TrackingStatus__c,
                    Gestion__c,
                    OriginStoreLocation__r.Name,
                    OriginStoreLocation__r.Location__r.StateName__c,
                    OriginStoreLocation__r.vlocity_cmt__StreetAddress__c,
                    OriginStoreLocation__r.PointOfSaleAddressNumber__c,
                    Delivery_Method__c,
                    ShippingStreet__c,
                    vlocity_cmt__ShippingState__c,
                    ShippingStreetNumber__c,
                    ShippingPostalCode,
                    vlocity_cmt__ShippingName__c,
                    ShippingPostOffice__r.Name,
                    ShippingPostOffice__r.Location__r.StateName__c,
                    ShippingPostOffice__r.vlocity_cmt__StreetAddress__c,
                    ShippingPostOffice__r.PointOfSaleAddressNumber__c,
                    PickUpStoreLocation__r.Name,
                    PickUpStoreLocation__r.Location__r.StateName__c,
                    PickUpStoreLocation__r.vlocity_cmt__StreetAddress__c,
                    PickUpStoreLocation__r.PointOfSaleAddressNumber__c
                FROM Order WHERE Id = :idOrder];

        Set<Id> productsIds = new Set<Id>();
        List<OrderItem> items = [SELECT ProductName__c, vlocity_cmt__SerialNumber__c, vlocity_cmt__JSONAttribute__c, Product2.Id, Product2.vlocity_cmt__Type__c FROM OrderItem WHERE OrderId = :objOrder.Id AND (Product2.vlocity_cmt__Type__c = 'Dispositivo' OR Product2.vlocity_cmt__Type__c = 'Plan Prepago')];
        List<vlocity_cmt__PaymentAdjustment__c> payments = [SELECT Id, toLabel(vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c), toLabel(vlocity_cmt__PaymentMethodId__r.BankEntityName__c), toLabel(vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c), vlocity_cmt__Amount__c, vlocity_cmt__TotalInstallments__c FROM vlocity_cmt__PaymentAdjustment__c WHERE Order__c = :objOrder.Id];

        String jsonInput = '{"To": {"Address": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.Email + '","SubscriberKey": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.Email + '",';
        jsonInput += '"ContactAttributes": {';
        jsonInput += '"FirstName": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.FirstName + '",';
        jsonInput += '"LastName": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.LastName + '",';
        jsonInput += '"DocumentNumber": "' + objOrder.Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c + '",';
        jsonInput += '"OrderNumber": "' + objOrder.OrderNumber + '",';
        jsonInput += '"Gestion": "' + objOrder.Gestion__c + '",';
        jsonInput += '"OrderState": "' + objOrder.TrackingStatus__c + '",';
        jsonInput += '"Inicio de la gestion": "' + objOrder.EffectiveDate + '",';
        if (objOrder.EndDate != null) jsonInput += '"Cierre de la gestion": "' + objOrder.EndDate + '",';
        jsonInput += '"LinesHeader": "Lineas",';
        jsonInput += '"LinesValues": "';
        Integer count = 0;
        for (OrderItem item : items)
        {
            productsIds.add(item.Product2.Id);
            if (item.Product2.vlocity_cmt__Type__c == 'Plan Prepago')
            {
                if (count == 0) count++;
                else jsonInput += ';';
                String lineNumber;
                if(!Test.isRunningTest()){
                    Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(item.vlocity_cmt__JSONAttribute__c, 'Numero de Linea');
                    lineNumber = (String)((Map<String, Object>)jsonAttribute.get('attributeRunTimeInfo')).get('value');
                } else {
                    lineNumber = '31241234132';
                }
                if(String.IsNotBlank(lineNumber))
                        jsonInput += lineNumber;
            }
        }
        jsonInput += '",';
        jsonInput += '"ServiceHeader": "Description",';
        jsonInput += '"ServiceValues": "';
        count = 0;
        for (OrderItem item : items)
        {
            if (item.Product2.vlocity_cmt__Type__c == 'Plan Prepago')
            {
                if (count == 0) count++;
                else jsonInput += ';';

                jsonInput += item.ProductName__c;
            }
        }
        jsonInput += '",';
        jsonInput += '"TerminalsHeader": "Modelo|Marca|Gama|IMEI",';
        jsonInput += '"TerminalsValues": "';
        count = 0;
        for (OrderItem item : items)
        {
            if (item.Product2.vlocity_cmt__Type__c == 'Dispositivo')
            {
                if (count == 0) count++;
                else jsonInput += ';';

                String model, brand, gama;

                if(!Test.isRunningTest()){
                    Map<String,Object> jsonAttribute = AssetAttributesUtils.GetJSONAttribute(item.vlocity_cmt__JSONAttribute__c, 'Modelo');
                    if(jsonAttribute != null && jsonAttribute.get('value__c') != null){
                            model = String.valueOf(jsonAttribute.get('value__c'));
                        }
                    jsonAttribute = AssetAttributesUtils.GetJSONAttribute(item.vlocity_cmt__JSONAttribute__c, 'Marca');
                    if(jsonAttribute != null && jsonAttribute.get('value__c') != null){
                            brand = String.valueOf(jsonAttribute.get('value__c'));
                        }
                    jsonAttribute = AssetAttributesUtils.GetJSONAttribute(item.vlocity_cmt__JSONAttribute__c, 'Gama Equipo');
                    if(jsonAttribute != null && jsonAttribute.get('value__c') != null){
                            gama = String.valueOf(jsonAttribute.get('value__c'));
                        } 
                } else {
                    model = 'S8';
                    brand = 'Samsung';
                    gama = 'High';
                }
                 
                jsonInput += model + '|' + brand + '|' + gama + '|' + item.vlocity_cmt__SerialNumber__c;
            }
        }
        jsonInput += '",';
        jsonInput += '"PaymentMethodsHeader": "MethodType|Entity|Bank|Amount|Installments",';
        jsonInput += '"PaymentMethodsValues": "';
        Decimal totalAmount = 0;
        count = 0;
        for (vlocity_cmt__PaymentAdjustment__c payment : payments)
        {
            if (count == 0) count++;
                else jsonInput += ';';

            jsonInput += payment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__MethodType__c + '|' + payment.vlocity_cmt__PaymentMethodId__r.vlocity_cmt__CardType__c + '|' + payment.vlocity_cmt__PaymentMethodId__r.BankEntityName__c + '|' + payment.vlocity_cmt__Amount__c + '|' + payment.vlocity_cmt__TotalInstallments__c;
            totalAmount += payment.vlocity_cmt__Amount__c;
        }
        jsonInput += '",';
        jsonInput += '"FormHeader": "Form",';
        jsonInput += '"FormValues": "';
        List<vlocity_cmt__VlocityAttachment__c> formsUrls = [SELECT vlocity_cmt__UrlLong__c FROM vlocity_cmt__VlocityAttachment__c WHERE vlocity_cmt__ObjectId__c in :productsIds];
        Map<String, String> urlsFound = new Map<String, String>();
        count = 0;
        for (vlocity_cmt__VlocityAttachment__c formUrl : formsUrls)
        {
            String urlAlreadyexists = urlsFound.get(formUrl.vlocity_cmt__UrlLong__c);

            if (urlAlreadyexists != 'SI')
            {
                if (count == 0) count++;
                else jsonInput += ';';

                jsonInput += formUrl.vlocity_cmt__UrlLong__c;
                urlsFound.put(formUrl.vlocity_cmt__UrlLong__c, 'SI');
            }
        }
        jsonInput += '",';
        List<vlocity_cmt__OrderAppliedPromotion__c> promotions = [SELECT vlocity_cmt__PromotionId__r.Name FROM vlocity_cmt__OrderAppliedPromotion__c WHERE vlocity_cmt__OrderId__c = :objOrder.Id];
        jsonInput += '"PromotionHeader": "Promotion",';
        jsonInput += '"PromotionValues": "';
        count = 0;
        for (vlocity_cmt__OrderAppliedPromotion__c promotion : promotions)
        {
            if (count == 0) count++;
                else jsonInput += ';';

            jsonInput += promotion.vlocity_cmt__PromotionId__r.Name;
        }
        jsonInput += '",';
        List<OrderHistory> orderHistoryList = [SELECT CreatedDate, NewValue, OldValue FROM OrderHistory WHERE OrderId = :objOrder.Id AND Field = 'TrackingStatus__c' AND IsDeleted = false ORDER BY CreatedDate];
        jsonInput += '"OrderStatesHeader": "State|Date",';
        jsonInput += '"OrderStatesValues": "';
        count = 0;
        for (OrderHistory orderHistory : orderHistoryList)
        {
            if (orderHistory.NewValue != objOrder.TrackingStatus__c)
            {
                if (count == 0) count++;
                    else jsonInput += ';';

                jsonInput += orderHistory.NewValue + '|' + orderHistory.CreatedDate;
            }
        }
        jsonInput += '",';
        jsonInput += '"Punto de venta": "' + objOrder.OriginStoreLocation__r.Name + ', ' + objOrder.OriginStoreLocation__r.vlocity_cmt__StreetAddress__c + ' ' + objOrder.OriginStoreLocation__r.PointOfSaleAddressNumber__c + ', '+ objOrder.OriginStoreLocation__r.Location__r.StateName__c + '",';
        jsonInput += '"Forma de entrega": "' + objOrder.Delivery_Method__c + '",';
        if (objOrder.Delivery_Method__c == 'Delivery')
        {
            jsonInput += '"Domicilio de entrega": "' + objOrder.ShippingStreet__c + ' ' + objOrder.ShippingStreetNumber__c + ', ' + objOrder.vlocity_cmt__ShippingState__c + '",';
            jsonInput += '"Usuario autorizado": "' + objOrder.vlocity_cmt__ShippingName__c + '",';
        } else if (objOrder.Delivery_Method__c == 'Store Pick Up')
            jsonInput += '"Local de entrega": "' + objOrder.PickUpStoreLocation__r.Name + ', ' + objOrder.PickUpStoreLocation__r.vlocity_cmt__StreetAddress__c + ' ' + objOrder.PickUpStoreLocation__r.PointOfSaleAddressNumber__c + ', ' + objOrder.PickUpStoreLocation__r.Location__r.StateName__c + '",';
        jsonInput += '"Importe facturado": "' + totalAmount + '"';
        jsonInput += '},';
        jsonInput += '"Options": "SYNC","Channel": "Email","processName": "SendSuccesfulOrderClientNotification"}}';

        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        TriggeredSendNotificationService sender = new TriggeredSendNotificationService();
        Map<String,Object> inputMap = (Map<String,Object>) JSON.deserializeUntyped(jsonInput);
        sender.invokeMethod('sendMessage',inputMap, outMap, options);
        System.debug('outMap: ' + outMap);
    }

    private static void getPaymentResponse(Id orderId){
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'EmailToSend'];

        Order o = [SELECT Delivery_Method__c, Account.vlocity_cmt__PrimaryContactId__r.Email FROM Order WHERE Id = :orderId];
        if(o.Delivery_Method__c == 'Store Pick Up'){
            insert new CrossObject__c(Email1__c = o.Account.vlocity_cmt__PrimaryContactId__r.Email, Picklist1__c = 'Detalles de Pickup', RecordTypeId = rt.Id, Order__c = orderId);
        }
    }

    /*// Created for testing bug 4148 - 7441
    public static void testGetSystemURL(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options) {
        
        // String endpoint = System.URL.getSalesforceBaseUrl().toExternalForm();
        // System.debug(endpoint);
        
        String endpoint = System.URL.getCurrentRequestUrl().toExternalForm();
        System.debug(endpoint);

        String endpoint2 = System.URL.getSalesforceBaseUrl().getHost();
        System.debug(endpoint2);

        // System.URL endpoint3 = System.URL.getSalesforceBaseUrl();
        // System.debug(endpoint3);


        Map<String, String> parameters = new Map<String, String>();
        parameters.put('endpoint', endpoint);
        parameters.put('endpoint2', endpoint2);
        // parameters.put('endpoint3', endpoint3);

        outMap.put('parameters', parameters);
    }*/
    
    // Created for Nomination Omniscript 
    public static void prepareOrderForOM(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options) {
        try{
            String orderId = (String) options.get('orderId');
            System.debug('OrderId Nominacion: ' + orderId);
            String accountId = (String) options.get('accountId');
            String assetId = (String) options.get('assetId');
            
            Order orderToNominate = [SELECT Id, Gestion__c FROM Order WHERE Id = :orderId];
            orderToNominate.Gestion__c = 'Nominacion';
            System.debug('Error 0 Nominacion');
            update orderToNominate;
            
            List<orderItem> orderItems = [SELECT Id from orderItem where OrderId = :orderId];

            if(orderItems.size() > 0){
                for (orderItem a: orderItems){
                    a.vlocity_cmt__ProvisioningStatus__c = 'Active';
                    a.vlocity_cmt__Action__c = 'Existing';
                    a.vlocity_cmt__BillingAccountId__c = accountId;
                    a.vlocity_cmt__ServiceAccountId__c = accountId;
                    a.vlocity_cmt__DisconnectDate__c = null;
                }
                System.debug('Error 1 Nominacion');
                Update orderItems;
            }
        }
        catch(Exception ex) {
            system.debug('Error: ' + ex);
            system.debug('LineNumber: ' + ex.getLineNumber());
            
            throw ex;
        }
    }
    
    // Created for Nomination Omniscript 
    public static void callNominationCheckout(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options) {
        try{
            String orderId = (String) options.get('orderId');
            system.debug('Antes de llamar a OM');
            // vlocity_cmt.SimpleDecompositionController.decomposeOrder(orderId);
            // vlocity_cmt.SimpleDecompositionController.startOrchestrationPlan(orderId);
            string s = vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(orderId, false);
            system.debug('Después de llamar a OM: ' + s);
        }
        catch(Exception ex) {

            system.debug('Error en OM: ' + ex);
            system.debug('LineNumber: ' + ex.getLineNumber());
            throw new FuncException('Error en OM. Linea: ' + ex.getLineNumber());
            throw ex;
        }
    }
    
    // Created for Nomination Omniscript 
    public static void getNominationAssets(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options) {
        try{
            System.debug('ORDER id: ' + (String) options.get('OrderId'));
            String assetId = (String) options.get('assetId');
            List<Asset> lstAssets = [SELECT Id, Name, vlocity_cmt__LineNumber__c, vlocity_cmt__RootItemId__c, vlocity_cmt__ActivationDate__c, SerialNumber, Quantity, Status, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__OneTimeTotal__c, MSISDN__c FROM Asset WHERE vlocity_cmt__RootItemId__c =:assetId OR Id =:assetId];
            outMap.put('SelectAsset', lstAssets);
            //for (Asset ass : lstAssets)
        }
        catch(Exception ex) {
            system.debug('Error: ' + ex);
            throw ex;
        }
    }
}