global with sharing class taSalesCreateOrderController implements vlocity_cmt.VlocityOpenInterface
{
    global taSalesCreateOrderController () {}
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try{
            if (methodName.equals('CheckIfPrepaidOrdItems')){
                CheckIfPrepaidOrdItems(inputMap, outMap, options);
            }
            if (methodName.equals('CreateAnnulmentOrder')){
                Map<String, Object> oMap;
                String ordId = (String) inputMap.get('orderId');
                oMap = CloneOrder(ordId, true);
                outMap.put('annulmentOrderId', oMap.get('IdOrder'));
                outMap.put('OrderNumber', oMap.get('OrderNumber'));
            }
            /*
            if (methodName.equals('saveChannelOrder')){
                saveChannelOrder(inputMap, outMap, options);
            }
            */
            result = false;
        }catch(Exception e){
            System.debug('taSalesCreateOrderController:invokeMethod -> exception: '+e);
            result = false;
        }
        return result;
    }

    @RemoteAction
    global static Map<String, Object> CloneOrder(string oldOrderId){
        System.debug('CloneOrder');
        Map<String, Object> outMap;
        outMap = CloneOrder(oldOrderId, false);
        return outMap;
    }

    global static Map<String, Object> CloneOrder(string oldOrderId, Boolean anulacion){
        System.debug('CloneOrder');
        System.debug('oldOrderId: ' + oldOrderId);
        Order oldOrder = [SELECT AccountId,ActivatedById,ActivatedDate,AddressHidden__c,BillingAddress,BillingCity,BillingCountry,BillingCountryCode,BillingGeocodeAccuracy,BillingLatitude,BillingLongitude,BillingPostalCode,BillingState,BillingStateCode,BillingStreet,Billing_Cycles__c,BillSimulationDate__c,BillSimulationPayload__c,CompanyAuthorizedById,ContractId,CreatedById,CreatedDate,CustomerAuthorizedById,Delivery_Method_Service__c,Delivery_Method__c,Description,EffectiveDate,EndDate,Gestion__c,Id,InstalationAddress__c,IsDeleted,IsReductionOrder,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,OriginalOrderId,OutboundSMSLastTryDate__c,OutboundSMSLastTryNumber__c,OutboundSMS__c,OwnerId,PaymentBank__c,PaymentCFT__c,PaymentCreditCard__c,PaymentInstalment__c,PaymentMethodType__c,PickUpStore__c,PrefeasibilityResult__c,Pricebook2Id,RecordTypeId,ShippingAddress,ShippingAditionalInformation__c,ShippingApartment__c,ShippingCity,ShippingCountry,ShippingCountryCode,ShippingEmailContact__c,ShippingFloor__c,ShippingGeocodeAccuracy,ShippingHomePhone__c,ShippingLatitude,ShippingLongitude,ShippingMobilePhone__c,ShippingPostalCode,ShippingPostOffice__c,ShippingRangeHours__c,ShippingState,ShippingStateCode,ShippingStreet,ShippingStreet1__c,ShippingStreet2__c,ShippingStreetNumber__c,ShippingStreet__c,Status,StatusCode,SystemModstamp,TotalAmount,TrackingStatus__c,Type,(SELECT Id, vlocity_cmt__Product2Id__r.Tangible__c FROM OrderItems),vlocity_cmt__AccountId__c,vlocity_cmt__AccountRecordType__c,vlocity_cmt__AccountSLA__c,vlocity_cmt__BillingName__c,vlocity_cmt__CampaignId__c,vlocity_cmt__CreatedByAPI__c,vlocity_cmt__Delivery_Installation_Status__c,vlocity_cmt__Discount__c,vlocity_cmt__DueDate__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__EffectiveOrderTotal__c,vlocity_cmt__EffectiveRecurringTotal__c,vlocity_cmt__Email__c,vlocity_cmt__ExpirationDate__c,vlocity_cmt__Fax__c,vlocity_cmt__FrameContractId__c,vlocity_cmt__FulfilmentStatus__c,vlocity_cmt__IsContractRequired__c,vlocity_cmt__IsSyncing__c,vlocity_cmt__JeopardySafetyInterval__c,vlocity_cmt__JeopardyStatus__c,vlocity_cmt__LeadSource__c,vlocity_cmt__MasterOrderName__c,vlocity_cmt__NumberOfContractedMonths__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OpportunityId__c,vlocity_cmt__OrchestrationPlanId__c,vlocity_cmt__OrchestrationPlanReferenceId__c,vlocity_cmt__OrderGroup__c,vlocity_cmt__OrderTotal__c,vlocity_cmt__OriginatingChannel__c,vlocity_cmt__OriginatingContractId__c,vlocity_cmt__Phone__c,vlocity_cmt__Pricebook__c,vlocity_cmt__PriceListId__c,vlocity_cmt__QuoteId__c,vlocity_cmt__QuoteToCity__c,vlocity_cmt__QuoteToCountry__c,vlocity_cmt__QuoteToName__c,vlocity_cmt__QuoteToPostalCode__c,vlocity_cmt__QuoteToState__c,vlocity_cmt__QuoteToStreet__c,vlocity_cmt__RecurringTotal__c,vlocity_cmt__RequestDate__c,vlocity_cmt__RequestedCompletionDate__c,vlocity_cmt__ShippingName__c,vlocity_cmt__ShippingPostalCode__c,vlocity_cmt__ShippingState__c,vlocity_cmt__StatusImageName__c,vlocity_cmt__Tax__c,vlocity_cmt__TotalMonthlyDiscount__c,vlocity_cmt__TotalOneTimeDiscount__c,Operation_Code__c,vlocity_cmt__TrackingNumber__c,vlocity_cmt__ValidationDate__c,vlocity_cmt__ValidationMessage__c,vlocity_cmt__ValidationStatus__c, AnnulmentParentOrderId__c FROM Order WHERE Id = :oldOrderId];
        String asdf = JSON.serialize(oldOrder);
        // oldOrder.Status = 'Activated'; // se pone en activated para poder crearla como ReductionOrder
        update oldOrder;
        System.debug(asdf);
        Order newOrder = oldOrder.clone(false, true, false, false);
        newOrder.Status = 'Draft';
        insert newOrder;
        
        if(anulacion){
            //DA - 8/1/18: Para ordenes de anulación se setean valores especiales sobre la orden
            newOrder.Gestion__c = 'Desconexión';
            // newOrder.OriginalOrderId = oldOrder.Id;
            // newOrder.IsReductionOrder = true;
            newOrder.AnnulmentParentOrderId__c = oldOrder.Id;
            
            for(OrderItem oi : oldOrder.OrderItems){
                if(oi.vlocity_cmt__Product2Id__r.Tangible__c == true){
                    newOrder.trackingStatus__c = 'Pendiente de Anulacion';
                    break;
                }
            }
        }

        update newOrder;
        List<OrderItem> items = new List<OrderItem>();
        for (OrderItem oldItem : [SELECT AvailableQuantity,CreatedById,CreatedDate,Description,EndDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,ListPrice,NotAnAsset__c,OriginalOrderItemId,PricebookEntryId,Product2Id,ProductCode__c,ProductName__c,Quantity,ServiceDate,SystemModstamp,TotalPrice,UnitPrice,vlocity_cmt__Action__c,vlocity_cmt__ActivationName__c,vlocity_cmt__Additional_Discount__c,vlocity_cmt__AssetId__c,vlocity_cmt__AssetReferenceId__c,vlocity_cmt__BillingAccountId__c,vlocity_cmt__ConnectDate__c,vlocity_cmt__CpqCardinalityMessage__c,vlocity_cmt__CpqMessageData__c,vlocity_cmt__DisconnectDate__c,vlocity_cmt__EffectiveOneTimeTotal__c,vlocity_cmt__EffectiveQuantity__c,vlocity_cmt__EffectiveRecurringTotal__c,vlocity_cmt__ExpectedCompletionDate__c,vlocity_cmt__Filter__c,vlocity_cmt__FulfilmentStatus__c,vlocity_cmt__InCartQuantityMap__c,vlocity_cmt__IsEditable__c,vlocity_cmt__IsProductTrackAgreement__c,vlocity_cmt__ItemName__c,vlocity_cmt__JSONAttribute__c,vlocity_cmt__JSONNode__c,vlocity_cmt__LineItemNumber__c,vlocity_cmt__LineNumber__c,vlocity_cmt__Modification__c,vlocity_cmt__MonthlyTotal__c,vlocity_cmt__MRC__c,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c,vlocity_cmt__OneTimeDiscountPrice__c,vlocity_cmt__OneTimeManualDiscount__c,vlocity_cmt__OneTimeTotal__c,vlocity_cmt__OverageCalculatedPrice__c,vlocity_cmt__OverageCharge__c,vlocity_cmt__OverageDiscountPrice__c,vlocity_cmt__OverageManualDiscount__c,vlocity_cmt__OverageTotal__c,vlocity_cmt__OverageUOM__c,vlocity_cmt__ParentItemId__c,vlocity_cmt__ParentLineItemNumber__c,vlocity_cmt__ParentOrderProduct__c,vlocity_cmt__PremisesId__c,vlocity_cmt__PricingLogData__c,vlocity_cmt__Product2Id__c,vlocity_cmt__ProductAttribXN__c,vlocity_cmt__ProductHierarchyPath__c,vlocity_cmt__ProvisioningStatus__c,vlocity_cmt__Query__c,vlocity_cmt__RecurringCalculatedPrice__c,vlocity_cmt__RecurringCharge__c,vlocity_cmt__RecurringDiscountPrice__c,vlocity_cmt__RecurringManualDiscount__c,vlocity_cmt__RecurringTotal__c,vlocity_cmt__RecurringUOM__c,vlocity_cmt__RelationshipType__c,vlocity_cmt__RequestDate__c,vlocity_cmt__RootItemId__c,vlocity_cmt__SequenceNumber__c,vlocity_cmt__ServiceAccountId__c,vlocity_cmt__SubAction__c FROM OrderItem WHERE OrderId = :oldOrderId]) {
            OrderItem newItem = oldItem.clone(false, true, false, false);
            newItem.OrderId = newOrder.Id;
            
            if(anulacion){
                //DA - 8/1/18: Para ordenes de anulación se setean valores extras sobre los items
                //FP - Para anular ordenes con gestion Cambio en Garantia, si el orderItem tiene action disconnect pasa a add y viceversa
                
               if(oldOrder.Gestion__c != 'Cambio en Garantia'){
                newItem.vlocity_cmt__Action__c = 'Disconnect';
                newItem.vlocity_cmt__ProvisioningStatus__c = 'Inactive';}
                 newItem.OriginalOrderItemId = oldItem.Id;
                 //newItem.Quantity = oldItem.Quantity * -1;
                
                
                if(oldOrder.Gestion__c == 'Cambio en Garantia'){
                    
                    if(oldItem.vlocity_cmt__Action__c == 'Add'){
                        newItem.vlocity_cmt__Action__c = 'Disconnect';
                    }
                    if(oldItem.vlocity_cmt__Action__c == 'Disconnect'){
                        newItem.vlocity_cmt__Action__c = 'Add';
                        //newItem.vlocity_cmt__ProvisioningStatus__c = '????';
                    }
                }
            }
            else{
                //DA - 8/1/18: Para ordenes que no son anulación, se limpia el MSISDN
                Map<String,String> attribs = new Map<String,String>();
                attribs.put('MSISDN', null);
                String jsonAttribute = AssetAttributesUtils.setValuesOnJSON(newItem.vlocity_cmt__JSONAttribute__c, attribs);
                newItem.vlocity_cmt__JSONAttribute__c = jsonAttribute;
                newItem.vlocity_cmt__SerialNumber__c = null;
            }

            items.add(newItem);
        }
        insert items;
        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustments = new List<vlocity_cmt__PaymentAdjustment__c>();
        for (vlocity_cmt__PaymentAdjustment__c oldPayment : [SELECT vlocity_cmt__PaymentMethodId__c, vlocity_cmt__TotalInstallments__c, vlocity_cmt__AccountId__c FROM vlocity_cmt__PaymentAdjustment__c WHERE vlocity_cmt__AccountId__c = :oldOrder.AccountId AND Order__c = :oldOrderId]) {
            vlocity_cmt__PaymentAdjustment__c newPayment = oldPayment.clone(false, true, false, false);
            newPayment.Order__c = newOrder.Id;
            paymentAdjustments.add(newPayment);
        }
        insert paymentAdjustments;
        System.debug(newOrder.Id);
        System.debug(newOrder.AccountId);
        Map<String, Object> outMap = new Map<String, Object>();
        outMap.put('IdOrder', newOrder.Id);
        outMap.put('accountId', newOrder.AccountId);
        Account orderAccount = [SELECT vlocity_cmt__PrimaryContactId__c FROM Account WHERE Id = :newOrder.AccountId];
        outMap.put('contactId', orderAccount.vlocity_cmt__PrimaryContactId__c);
        outMap.put('OrderNumber', newOrder.OrderNumber);
        System.debug(newOrder.Account.vlocity_cmt__PrimaryContactId__c);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> CreateOrder(string idAccount, String operationCode){ //Joshua - PFTA6973
        String orderId = CreateNewOrder(idAccount, operationCode); //Joshua - PFTA6973
        Map<String, Object> outMap = new Map<String, Object>();
        outMap.put('IdOrder', orderId);
        outMap.put('accountId', idAccount);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> CreateOrderAndAccount(string contactId, String operationCode){ //Joshua - PFTA6973
        String accountId;
        //Venkatesh - PFTA-7932
        list<account> accounts = new list<account>();
        accounts = [SELECT Id, RecordTypeId, vlocity_cmt__PrimaryContactId__c
                                FROM Account
                                WHERE vlocity_cmt__PrimaryContactId__c=:contactId];
                                
        if(accounts.size()>0){                        
           accountId = accounts[0].id; 
        }else{
           accountId = CreateAccount(contactId); 
        }
        System.debug('accountId: ' + accountId);
        String orderId = CreateNewOrder(accountId, operationCode); //Joshua - PFTA6973
        Map<String, Object> outMap = new Map<String, Object>();
        outMap.put('IdOrder', orderId);
        outMap.put('accountId', accountId);
        return outMap;
    }

    @RemoteAction
    global static Map<String, Object> CreateOrderAndBillingAccount(string idAccount, String operationCode){ //Joshua - PFTA6973
        String idBillingAccount = CreateBillingAccount(idAccount);
        String orderId = CreateNewOrder(idBillingAccount, operationCode); //Joshua - PFTA6973
        Map<String, Object> outMap = new Map<String, Object>();
        outMap.put('IdOrder', orderId);
        outMap.put('accountId', idAccount);
        outMap.put('billingAccountId', idBillingAccount);
        return outMap;
    }

    @RemoteAction
    global static String CheckClientInBlackList(string accountId, string contactId){
        
        if(String.isNotBlank(accountId) && String.isBlank(contactId))
        {
            Account accountObject = [SELECT id, vlocity_cmt__PrimaryContactId__c FROM Account WHERE Id = :accountId];
            contactId = accountObject.vlocity_cmt__PrimaryContactId__c;
        } 
                    
        Contact contactObject = [SELECT id, DocumentType__c, DocumentNumber__c FROM Contact WHERE Id = :contactId LIMIT 1];         

        System.debug('CheckClientInBlackList');
        System.debug(contactObject.DocumentNumber__c);
        System.debug(contactObject.DocumentType__c);
        String result = taClientSearchController.CheckClientInBlackList(accountId, contactObject.DocumentNumber__c, contactObject.DocumentType__c);
        return result;
    }
    @RemoteAction
    global static Boolean CheckDunningAccount(string accountId){
        
        String integrationId = taClientSearchController.getIntegrationId(accountId);
        Boolean dunning = taClientSearchController.CheckDunning(integrationId);
        return dunning;
        
    }
    global static void UpdateDunningAccount(string accountId, Boolean newDunning){
        taClientSearchController.UpdateDunningFromAccount(accountId, newDunning);
    }
    @RemoteAction
    global static String CheckAccountStatus(string accountId, string contactId){
        
        Boolean dunning = CheckDunningAccount(accountId);
        String result = CheckClientInBlackList(accountId, contactId);
        UpdateDunningAccount(accountId, dunning);

        return result;
        
    }

    /*
    void saveChannelOrder(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        System.debug('saveChannelOrder');
        String idOrder = (String) inputMap.get('DRId_Order');
        System.debug(idOrder);
        Order orderToUpdate = [SELECT Id, vlocity_cmt__OriginatingChannel__c, Delivery_Method__c FROM Order WHERE Id =: idOrder LIMIT 1];

        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        System.debug('Profile: ' + PROFILE);
        String profileName = PROFILE[0].Name;

        if (profileName == 'TA - Agente Venta y Atencion a Clientes' || profileName == 'TA2 - Agente Venta y Atencion a Clientes')
        {
            orderToUpdate.vlocity_cmt__OriginatingChannel__c = 'Presencial Agente';
            orderToUpdate.Delivery_Method__c = 'Presencial';
        }
        else if (profileName == 'TA - OFCOM Venta y Atencion a Clientes' || profileName == 'Vlocity_Developer')
        {
            orderToUpdate.vlocity_cmt__OriginatingChannel__c = 'Presencial Oficina Comercial';
            orderToUpdate.Delivery_Method__c = 'Presencial';
        }
        else if (profileName == 'Test community')
        {
            orderToUpdate.vlocity_cmt__OriginatingChannel__c = 'Web';
            orderToUpdate.Delivery_Method__c = 'Delivery';
        }  
        else {
            orderToUpdate.vlocity_cmt__OriginatingChannel__c = 'Call Center';
            orderToUpdate.Delivery_Method__c = 'Delivery';
        }
        

        try {
            update orderToUpdate;
        }
        catch (Exception e) {
            System.debug('saveChannelOrder: An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
        
    }
    */

    void CheckIfPrepaidOrdItems(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        System.debug('Check If Prepaid Ord Items');

        String idOrder = (String) options.get('idOrder');
        String idBillingAccount = (String) options.get('billingAccountId');

        if (OrdersUtilMethods.OrderItemsAreAllPrepaid(idOrder)) {
            Account billingAccountToDelete = [SELECT Id, ParentId FROM Account WHERE Id =: idBillingAccount LIMIT 1];
            Order orderToUpdate = [SELECT Id, AccountId FROM Order WHERE Id =: idOrder LIMIT 1];

            orderToUpdate.AccountId = billingAccountToDelete.ParentId;
            try {
                update orderToUpdate;
                delete billingAccountToDelete;
            }
            catch (Exception e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
                System.debug(e.getMessage());
            }

            outMap.put('billingAccountId', null);
        }
    }

    public static String CreateNewOrder(string idAccount, String operationCode) //Joshua - PFTA-6973
    {
        try
        {
            System.debug('CreateOrder');
            Order order = new Order();
            order.AccountId = idAccount;
            //order.TrackingStatus__c = 'Inicial'; // Fede - PFTA-9414
            //order.vlocity_cmt__TrackingNumber__c = operationCode; //Joshua - PFTA-6973
            order.Operation_Code__c = operationCode; //Fede - PFTA-8547
            order.Status = 'Draft';
            order.EffectiveDate = Date.today();
            
            //<DA> - PFTA-7803 - 14/12/2017: Set Gestion__c for source identification
            order.Gestion__c = 'Venta';
            
            //</DA>
            insert order;
            System.debug('order.Id: ' + order.Id);
            return order.Id;
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return null;
        }
    }

    public static String CreateAccount(string contactId)
    {
        try
        {
            System.debug('CreateOrderAndAccount');
            Contact contact = [SELECT Name FROM Contact WHERE Id = :contactId];
            Account account = new Account();
            account.Name = contact.Name;
            account.vlocity_cmt__PrimaryContactId__c = contactId;
            RecordType type = [SELECT Id, Name FROM RecordType WHERE Name = 'Consumer' AND SobjectType = 'Account'];
            account.RecordTypeId = type.Id;
            account.vlocity_cmt__Active__c = 'Yes';
            system.debug('cp acc'+account);
            insert account;
            
            contact.AccountId = account.Id; //PFTA-10345 - 25/04/2018
            update contact;                 //PFTA-10345 - 25/04/2018
            
            return account.Id;
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return null;
        }
    }

    public static String CreateBillingAccount(string idAccount)
    {
        try
        {
            System.debug('CreateOrderAndBillingAccount');
            Account account = [SELECT Name, vlocity_cmt__PrimaryContactId__c, HuaweiNotice_S202__c FROM Account WHERE Id = :idAccount];
            RecordType type = [SELECT Id, Name FROM RecordType WHERE Name = 'Billing' AND SobjectType = 'Account'];
            account.RecordTypeId = type.Id;
            account.Id = null;
            account.ParentId = idAccount;
            account.vlocity_cmt__Active__c = 'Yes';
            insert account;
            return account.Id;
        }
        catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return null;
        }
    }
    
    /**
     * Method to get the most actual existing OmniScript instance
     *
     * @param orderId
     *
     * @return url from OmniScriptInstance or null if does not exists
     */
    @RemoteAction
    global static String getExistingOSInstance(string orderId){
        try{
            List<vlocity_cmt__OmniScriptInstance__c> prevInstances = [SELECT Id, vlocity_cmt__ResumeLink__c
                                                                        FROM vlocity_cmt__OmniScriptInstance__c
                                                                       WHERE vlocity_cmt__ObjectId__c = :orderId];
                                                                        
            if(prevInstances.size() > 0){
                return prevInstances[0].vlocity_cmt__ResumeLink__c;
            }
            
            return null;
        } catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
            return null;
        }
    }

    /// Metodo llamado desde trigger posterior a la creacion de ordenes
    public static void SetDefaultValues(List<Order> orders){
        vlocity_cmt__BusinessSite__c storeLocation;
        String licenseName = [SELECT Id, Name, UserLicense.Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1].UserLicense.Name;
        if(licenseName == 'Customer Community'){
            storeLocation = [SELECT Id, Name, Channel_Type__c FROM vlocity_cmt__BusinessSite__c WHERE Channel_Type__c = 'E-Commerce' LIMIT 1 ];
        }else {
            storeLocation = ta_sales_UserUtils.getStoreLocation(userinfo.getUserId());
        }
        System.debug('storeLocation: ' + storeLocation);
        String userChannel = storeLocation.Channel_Type__c;
        Id userStoreLocation = storeLocation.Id;
        for (Order order : orders){
            order.OriginStoreLocation__c = userStoreLocation;
            order.vlocity_cmt__OriginatingChannel__c = userChannel;
            
            if(userChannel == 'Agentes' || userChannel == 'Oficinas Comerciales')
                order.Delivery_Method__c = 'Presencial';
            else
                order.Delivery_Method__c = 'Delivery';

        }
    }
}