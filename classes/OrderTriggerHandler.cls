/**
* Created by G. Fiore 16/08/2017
* Provides logic support to trigMasterOrder trigger
* Object: Order
*
* Version: 1.0
*/

public class OrderTriggerHandler {
    private static string activated = 'Activated';
    private static string soho = 'SOHO';
    private static string companies = 'Empresas';
    private static string masivo = 'Masivo';
    private static string recentRegistration = 'Alta reciente';

    public static void updateLeadSourceOnOrderCreation (List<Order> triggerNew)  {

        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id = :profileId].Name;

        List<Case_Channel_Configuration__c> cccList = [SELECT Case_Channel__c FROM Case_Channel_Configuration__c WHERE Profile__c = :profileName LIMIT 1];

        for (Case_Channel_Configuration__c ccc : cccList) {
            for (Order o : triggerNew){
                o.vlocity_cmt__LeadSource__c = ccc.Case_Channel__c;
            }
        }
    }

   public static void setTrackingStatus(List<Order> triggerNew){
    for(Order ord: triggerNew){
      ord.TrackingStatus__c = 'Inicial';
    }

    }

    public static void updatePriceListOnOrderCreation (List<Order> triggerNew)  {
        Id TAPriceListId =[select id from vlocity_cmt__PriceList__c where Name='Telecom Price List'].id;
        if(TAPriceListId!=null){
            for(Order ord:triggerNew){
                if(ord.vlocity_cmt__PriceListId__c==null)
                    ord.vlocity_cmt__PriceListId__c = TAPriceListId;
            }
        }
        else{
            System.debug('There is no Telecom Price List in the org');
        }
    }

    public static void setDefaultOrdervalues(List<Order> triggerNew) {
        taSalesCreateOrderController.SetDefaultValues(triggerNew);
    }

     /**
     * @Author: Leandro Estevecorena
     * @Description: Update the Segment 2 value on Account when the related order/s is activated.
     */
    public static void updateAccountSegmentLevel2 (List<Order> triggerNew){
        Set<Id>     setAccountId = new Set<Id>();
        List<Order> ordersToProcess = new List<Order>();

        String accountSegment = '';

        system.debug('Entrando a asignacion de Segmento 2');

        try{
            ordersToProcess = GetOrdersForSegmentLevel2Update(triggerNew);

            if(!ordersToProcess.isEmpty()){
                for (Order o : ordersToProcess) {
                    setAccountId.add(o.AccountId);
                }

                System.debug('Set Accounts' + setAccountId);

                List<Account> accountList = [SELECT Id, CuitNumber__c FROM Account WHERE Id IN :setAccountId];
                for (Account a : accountList) {
                    String firstDigit = '';
                    if(a.CuitNumber__c != Null){
                        firstDigit = String.valueOf(a.CuitNumber__c).substring(0,1);
                    } else {
                        accountSegment = masivo;
                    }

                    if(firstDigit == '2'){
                        accountSegment = soho;
                    } else if (firstDigit == '3'){
                        accountSegment = companies;
                    }
                    System.debug('segmento :' + accountSegment);
                    a.SegmentLevel2__c = accountSegment;
                }
                update accountList;
            }
        }catch(Exception e){
            system.debug('Error en asignacion de segmento 2 de la cuenta Linea:' + e.getLineNumber());
            system.debug('Error en asignacion de segmento 2 de la cuenta Error:' + e);
        }
    }

    public static List<Order> GetOrdersForSegmentLevel2Update (List<Order> ordersNew){
        List<Order> orders = new List<Order>();
        Set<Id> idAccounts = new Set<Id>();

        for(Order o : OrdersNew){
            idAccounts.add(o.AccountId);
        }

        Map<Id, Account> accountsMap = new Map<Id,Account>([SELECT Id, SegmentLevel1__c, SegmentLevel2__c FROM Account WHERE Id IN :idAccounts]);

        for(Order o : ordersNew){
            Account a = accountsMap.get(o.AccountId);
            if(a.SegmentLevel1__c == 'Alta reciente' && a.SegmentLevel2__c == Null){
                orders.add(o);
            }
        }
        return orders;
    }

    public static void updateCanceledOrderStatus (List<Order> triggerUpdate){
        List<Order> ordersToUpdate = getCanceledOrdersToUpdate(triggerUpdate);
        Set<Id> originalOrdersId = new Set<Id>();
        List<Order> originalOrders = new List<Order>();
        try{
            for(Order o : ordersToUpdate){
                originalOrdersId.add(o.AnnulmentParentOrderId__c);
                o.TrackingStatus__c = 'Exitoso';
            }

            originalOrders = [SELECT Status, TrackingStatus__c, Gestion__c FROM Order WHERE Id IN :originalOrdersId];

            system.debug('originalOrders' + originalOrders);

            for(Order o : originalOrders){
                //o.Status = 'Cancelled';
                o.TrackingStatus__c = 'Anulado';
            }

            system.debug('originalOrders updated' + originalOrders);

            update originalOrders;
        }catch(Exception e){
            system.debug('Error en updateCanceledOrderStatus Linea:' + e.getLineNumber());
            system.debug('Error en updateCanceledOrderStatus Error:' + e);
        }
    }

    public static List<Order> getCanceledOrdersToUpdate (List<Order> orders){
        List<Order> ordersToUpdate = new List<Order>();
        Set<Id> idAccounts = new Set<Id>();

        for(Order o : orders){
            if(o.Status == 'Activated' && o.Gestion__c == 'Desconexión')
                ordersToUpdate.add(o);
        }

        system.debug('Orders tu Update' + ordersToUpdate);
        return ordersToUpdate;
    }
    //JARN: PFTA-9426
    public static void getAprobacionAutomaticaADV (List<Order> lstOrders)
    {
        Boolean bolTienAtach;
        String strCodOperaOrder;
        Boolean bolSoloEquipo;
        Boolean bolSoloLinea;
        Boolean bolLineaEquipo;
        Boolean bolCantMovil = false;
        Boolean bolCantSim  = false;
        Boolean bolCantDispositivo  = false;
        Set<id> setIdOrder = new Set<id>();
        List<Order> setOrders = new List<Order>();
        Set<Id> idAccounts = new Set<Id>();
    String gestionOrder;
    String statusOrder;
        List<OrderItem> lstOrderItems = new List<OrderItem>();
    for(Order objOrder : lstOrders)
        {
            setIdOrder.add(objOrder.Id);
            strCodOperaOrder = objOrder.Operation_Code__c;
            idAccounts.add(objOrder.vlocity_cmt__AccountId__c );
      statusOrder = objOrder.Status;
      gestionOrder = objOrder.Gestion__c;
        }
    if(gestionOrder == 'Venta' && statusOrder == 'Activated' )
    {
      lstOrderItems = [SELECT Id, Product2.ProductCode, Product2.Name, Product2.vlocity_cmt__Type__c, FromStock__c, Product2.Tangible__c
                        FROM OrderItem
                        WHERE OrderId IN: setIdOrder
                        and (Product2.vlocity_cmt__Type__c  = 'Dispositivo'
                                or Product2.vlocity_cmt__Type__c = 'Simcard'
                                or Product2.vlocity_cmt__Type__c  = 'Mobile')
                    ];
        for(OrderItem item : lstOrderItems)
        {
            if(item.Product2.vlocity_cmt__Type__c == 'Dispositivo')
            {
                bolCantDispositivo = true;
            }
            else if(item.Product2.vlocity_cmt__Type__c == 'Simcard')
            {
                bolCantSim = true;
            }
            else If(item.Product2.vlocity_cmt__Type__c == 'Mobile')
            {
          bolCantSim = false;
          bolCantMovil = true;
          bolCantDispositivo = false;
            }
        if(bolCantDispositivo == true && bolCantSim == true){
          bolCantSim = false;
          bolCantMovil = true;
          bolCantDispositivo = false;
        }

        }
        List<Attachment> lstAttachment = [SELECT Id,ParentId FROM Attachment WHERE ParentId IN: setIdOrder];
        if(lstAttachment.size() > 0)
        {
            bolTienAtach = True;
            List<OrderADV__c> lstOrderAdv = [
                                                SELECT sales_Tipo_Producto__c,Sales_Estado_ADV__c,
                                                    sales_Codigo_Operacion__c, sales_Documentacion_Adjunta__c,
                                                    sale_Tipo_de_Documento__c, Linea_Equipo__c,
                                                    Solo_Equipo__c, Solo_Linea__c
                                                FROM OrderADV__c
                                            ];
            List<Contact> lstContactos = [
                                            SELECT  Id, AccountId, DocumentType__c
                                            FROM  Contact  WHERE AccountId IN : idAccounts
                ];
            if(lstContactos.size() > 0)
            {
                for(Contact objContac : lstContactos)
                {
                    String strTipoDocumento = objContac.DocumentType__c;
                    for(order order2 : lstOrders)
                    {
                        for(OrderADV__c objOrderAdV : lstOrderAdv)
                        {
                          if(objOrderAdV.sale_Tipo_de_Documento__c == strTipoDocumento && objOrderAdV.sales_Documentacion_Adjunta__c == bolTienAtach && objOrderAdV.sales_Codigo_Operacion__c == strCodOperaOrder)
                            {
                    if(bolCantMovil == objOrderAdV.Linea_Equipo__c && bolCantSim == objOrderAdV.Solo_Linea__c && bolCantDispositivo == objOrderAdV.Solo_Equipo__c )
                                {
                    order2.OrderApprovalStatus__c = objOrderAdV.Sales_Estado_ADV__c;
                                    setOrders.add(order2);
                                }
                            }
                        }
                    }
                }
            }
        }else
      {
        for(order order2 : lstOrders)
        {
          order2.OrderApprovalStatus__c = 'Aprobada automáticamente';
          setOrders.add(order2);
        }
      }
        If(setOrders.size() > 0)
        {
            System.debug('Actualiza');
            update setOrders;
        }
    }
  }

  public static void updateCaseOnOrderConciliate (List<Order> lstOrders){
    Map<String, String> ordersSms = new Map<String, String>();
    Map<String, String> ordersPhone = new Map<String, String>();
    Map<String, Order> conciliations = new Map<String, Order>();
    List<Case> casesToUpdate = new List<Case>();

    //filtering conciliations
    for (Order o : lstOrders) {
      if ((o.Gestion__c).equals('Conciliate')){
        conciliations.put(o.Id, o);
      }
    }

    //getting cases related to conciliations
    casesToUpdate = [SELECT Id, CaseNumber, Account.name, Asset.MSISDN__c, WorkShop__c, Status, Order__c FROM Case WHERE Order__c in :conciliations.keySet()];
    
    for (Case c : casesToUpdate){      
       If((conciliations.get(c.Order__c).TrackingStatus__c).equals('FAILED')){
          c.WorkShop__c = 'Equipo High Tech';
          c.Status = 'En espera de ejecución';   
      }else{
        If((conciliations.get(c.Order__c).TrackingStatus__c).equals('READY_WC')){
          ordersSms.put(c.Id, 'Sr(a). '+c.Account.name+', Con motivo del reclamo '+ c.CaseNumber
          +' realizamos una configuración sobre tu línea numero '+ c.Asset.MSISDN__c
          +' , por favor apaga y encende tu teléfono, luego de esto podrás utilizar' 
          +' el servicio de manera normal.');
        }else{
          ordersSms.put(c.Id, 'Sr(a). '+c.Account.name+', Con motivo del reclamo '+c.CaseNumber
          +' no se observaron inconsistencia en su línea numero '+ c.Asset.MSISDN__c +'.');

        }

        ordersPhone.put(c.Id,c.Asset.MSISDN__c);
        c.Status = 'Realizada exitosa';
      }
    }

    update casesToUpdate;

    if (ordersSms.size()==1) //cuz of the salesforce integration call limits...
      for (String key : ordersSms.keySet()){
        SendSMS(ordersPhone.get(key),ordersSms.get(key));
      }
  }


  private static void SendSMS(String phone, String msj){

    Map<String, Object> output = new Map<String, Object>();
    Map<String, Object> input = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    Map<String, String> parms = new Map<String, String>();

    parms.put('nroLinea', phone);
    input.put('params', parms);

    Map<String, Object> body = new Map<String, Object>();
   
    body.put('communicationText', msj );
    body.put('communicationDate', DateTime.now());
    body.put('channelName', 'SMS');

    input.put('body', body);

    vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
    integProcServ.invokeMethod('IFS_S159', input, output, options);

    Map<String, Object> response = (Map<String, Object>) output.get('IPResult');

    String execCode = (String) response.get('executionCode');

    if(execCode == 'Error')
    throw new FuncException('Error al enviar el SMS: ' + output);

  }
}