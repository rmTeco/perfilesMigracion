global with sharing class SaleManager implements vlocity_cmt.VlocityOpenInterface
{
    static final String internetFamily = 'Internet';
    static final String voiceFamily = 'Fixed';
    
    global SaleManager() {}

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try
        {
            if (methodName.equals('GetOrderValidations')) {
              GetOrderValidations(inputMap, outMap, options);
            }

            if (methodName.equals('ReserveProducts')) {
              ReserveProducts(inputMap, outMap, options);
            }

            if (methodName.equals('GetCustomSetting')) {
              GetCustomSetting(inputMap, outMap, options);
            }

            if (methodName.equals('GetCustomSettingAtribute')) {
              GetCustomSettingAtribute(inputMap, outMap, options);
            }

            if (methodName.equals('AssingProductsToServiceAccount')) {
              AssingProductsToServiceAccount(inputMap, outMap, options);
            }

            if (methodName.equals('ValidateEmailSettings')) {
              ValidateEmailSettings(inputMap, outMap, options);
            }

            if (methodName.equals('SetStockMovementCodes')) {
              SetStockMovementCodes(inputMap, outMap, options);
            }

            if (methodName.equals('SendPickUpInformationEmail')) {
              SendPickUpInformationEmail(inputMap, outMap, options);
            }

            if(methodName.equals('GetAmountInfoRefillSOS')) {
                GetAmountInfoRefillSOS(inputMap, outMap, options);
            }

            if (methodName.equals('GetDeliveryMethodOptions')) {
                GetDeliveryMethodOptions(inputMap, outMap, options);
            }

            if (methodName.equals('GetNewGuid')) {
                GetNewGuid(inputMap, outMap, options);
            }

            result = false;
        }
        catch(Exception e)
        {
            System.debug('SaleManager:invokeMethod -> exception: ' + e);
            result = false;
        }
        return result;
    }

    void GetNewGuid(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options){
        String idUnico = GuidUtil.NewGuid();
        outMap.put('X-Consumer-Transaction-ID', idUnico);
    }

    Boolean ValidateServicePlanExistence(String orderId) {
      List<OrderItem> items = [select Product2.Name from OrderItem where OrderId = :orderId and (Product2.Family = 'Service Plan' or Product2.Family = :internetFamily or Product2.Family = :voiceFamily)];
      Boolean serviceExists = false ;
      if (items.size() > 0)
        serviceExists = true;
      return serviceExists;
    }

    Boolean ValidateFamilyExistence(String orderId, String family) {
      List<OrderItem> items = [select Product2.Name from OrderItem where OrderId = :orderId and Product2.Family = :family];
      Boolean exists = false;
      if (items.size() > 0)
        exists = true;
      return exists;
    }

    String GetCategoryService(String orderId) {
      String categoryService;
      Boolean bafExists = ValidateFamilyExistence(orderId, internetFamily);
      Boolean voiceExists = ValidateFamilyExistence(orderId, voiceFamily);
      if (!bafExists && !voiceExists)
        categoryService = null;
      else if (bafExists)
        categoryService = internetFamily;
        else categoryService = 'Voz';
      return categoryService;
    }

    Boolean getAppointmentRequired(String idOrder) {
        System.debug('getAppointmentRequired');
        Boolean appointmentRequired = false;
        System.debug('idOrder: ' + idOrder);
        List<OrderItem> items = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId = :idOrder];
        Integer itemsCount = 0;
        while(!appointmentRequired && itemsCount < items.size())
        {
            if (items[itemsCount].vlocity_cmt__JSONAttribute__c != null)
            {
              Map<String, Object> mapa = (Map<String, Object>) JSON.deserializeUntyped(items[itemsCount].vlocity_cmt__JSONAttribute__c);
              List<Object> characteristics = (List<Object>) mapa.get('CHAR');
              if (characteristics != null)
              {
                Map<String, Object> susceptibleCita = (Map<String, Object>) characteristics[0];
                if(susceptibleCita.get('value__c') == 'Selected')
                {
                    appointmentRequired = true;
                } else {
                    appointmentRequired = false;
                }
              }
            }
            itemsCount++;
        }

        System.debug('appointmentRequired: ' + appointmentRequired);
        //outMap.put('appointmentRequired', appointmentRequired);
        return appointmentRequired;
    }

    public void GetOrderValidations(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options) {
        /*
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        *   SaleManager.GetOrderValidations
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * Description:  DEPRECATED - Method to get preliminary validations for delivery method change
        * Date:         2018-06-04
        * Params:       options.orderId
        * Return:       outMap.userChannel,
        *               outMap.hasTangibles
        */
        try {
            ta_sales_UserUtils userUtils = new ta_sales_UserUtils();
            options.put('userId', System.UserInfo.getUserId());
            userUtils.invokeMethod('getUserChannel', null, options, options);

            outMap.put('hasTangibles', taOrderController.ValidateTangibleExistence(String.ValueOf(options.get('orderId'))));
            outMap.put('userChannel', options.get('UserChannel'));
        }
        catch (Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
  
    /*void GenerateJson(Map<String,Object> inputMap, Map<String, Object> outMap){
       String idOrder = (String) inputMap.get('IdOrder');
       List<OrderItem> plansCollection = [select Id, Product2.Name from OrderItem where Product2.ProductCode = 'PTNAC' and OrderId = :idOrder order by Product2.Name];
       List<Map<String, Object>>  plans = new List<Map<String,Object>>();
       List<Map<String, Object>> lines;
       //Empiezan los cambios
       String aux = '';
       for (OrderItem orderItem : plansCollection){
          if (aux != orderItem.Product2.Name){
              Map<String, Object> plan = new Map<String, Object>();
              lines = new List<Map<String,Object>>();
              plan.put('nombre', orderItem.Product2.Name);
              plan.put('isSelected', false);
              plan.put('lineas', lines);
              plans.add(plan);
              aux = orderItem.Product2.Name;
          }
          List<OrderItem> items = [select Product2.Name, Product2.ProductCode from OrderItem where Product2.Family = 'Simcard' and vlocity_cmt__ParentItemId__c = :orderItem.Id];
          for(OrderItem lineItem : items){
                  Map<String, Object> tempMapLine = new Map<String, Object>();
                  tempMapLine.put('isSelected', false);
                  tempMapLine.put('linea', null);
                  tempMapLine.put('validacionLinea', null);
                  tempMapLine.put('NMU', lineItem.Product2.ProductCode);
                  tempMapLine.put('serial', null);
                  tempMapLine.put('validacionSerial', null) ;

                  lines.add(tempMapLine);                                       
              }
        }

       Map<String, Object> principalNode = new Map<String, Object>();
               principalNode.put('lineasReservadas', false);
               principalNode.put('planes', plans);
               principalNode.put('serialesReservados', false); 

       List<Map<String, Object>>  returnList = new List<Map<String,Object>>();

        returnList.add(principalNode);
        outMap.put('options', returnList);
    }*/

    void GetCustomSetting(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('GetCustomSetting');
        String csName = (String) options.get('CSName');
        List<Object> csFields = (List<Object>) options.get('CSFields');

        System.debug('csFields= ' + csFields);

        String QueryStr1 = 'SELECT ';
        Map<String,Object> mapField;
        String strField;

        for (Object objField:csFields){
            mapField = (Map<String,Object>) objField;
            strField = (String) mapField.get('field');
            QueryStr1 += strField+ ', ';
        }

        QueryStr1 = QueryStr1.substringBeforeLast(',');
        QueryStr1 +=' FROM ' + csName + ' LIMIT 1';

        System.debug('QueryStr1= ' + QueryStr1);

        List<Object> csValues = Database.query(QueryStr1);

        outMap.put('CSValues', csValues[0]);

    }
    
    void GetCustomSettingAtribute(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        /**
        * ─────────────────────────────────────────────────────────────────────────────────────────────────
        * @description Retrieve the fields listed in CSFields array from the Custom Setting Atribute CSAtribute 
        * in the Custom Setting CSName
        * ──────────────────────────────────────────────────────────────────────────────────────────────────
        * @author   Damian Avrij
        * @date     2018-01-12
        * @param    CSName the Custom Setting need you want to retrieve
        * @param    CSAtribute the CS atribute you want to retrieve
        * @param    CSFields the list of fields you want to retrieve
        * @return   CSValues a map wiht the field values
        */
        System.debug('GetCustomSettingInstance');
        String csName = (String) options.get('CSName');
        String csAtribute = (String) options.get('CSAtribute');
        List<Object> csFields = (List<Object>) options.get('CSFields');

        System.debug('csFields= ' + csFields);

        String QueryStr1 = 'SELECT ';
        Map<String,Object> mapField;
        String strField;

        for (Object objField:csFields){
            mapField = (Map<String,Object>) objField;
            strField = (String) mapField.get('field');
            QueryStr1 += strField+ ', ';
        }

        QueryStr1 = QueryStr1.substringBeforeLast(',');
        QueryStr1 +=' FROM ' + csName + ' WHERE Name =\''+ csAtribute +'\' LIMIT 1';

        System.debug('QueryStr1= ' + QueryStr1);

        List<Object> csValues = Database.query(QueryStr1);

        outMap.put('CSValues', csValues[0]);

    }

    void ReserveProducts(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try
        {
            System.debug('ReserveProducts');
            String orderId = (String) options.get('IdOrder');
            Map<String,String> getPointOfSaleWarehouseResponse = taOrderController.GetPointOfSaleWarehouse(orderId);
            String codPuntoDeVenta = getPointOfSaleWarehouseResponse.get('codPuntoDeVenta');
            String codDeposito = getPointOfSaleWarehouseResponse.get('codDeposito');
            String codAplicacion = '2';

            List<Map<String, Object>>  plans = new List<Map<String,Object>>();
            List<Map<String, Object>>  returnList = new List<Map<String,Object>>();

            Set<Id> oiIds = new Set<Id>();

            Map<String, Object> billingOrder = (Map<String, Object>) inputMap.get('BillingOrder');
            Map<String, List<OrderItem>> itemsByProductName = new Map<String, List<OrderItem>>();
            Map<String, Integer> groupedNmus = new Map<String, Integer>();
            Map<String, Map<String, Object>> nmus = new Map<String, Map<String, Object>>();
            Map<String, Object> principalNode = new Map<String, Object>();
            Map<String, Object> plan = new Map<String, Object>();
            Map<String, String> planNames = new Map<String, String>();
            Map<String, String> itemParents = new Map<String, String>();

            //List<OrderItem> plansCollection = [SELECT Id, Product2.Name FROM OrderItem WHERE Product2.ProductCode = 'FAN_TSEG1' AND OrderId = :orderId ORDER BY Product2.Name];
            //Added By Venkatesh - PFTA-7872
            List<OrderItem> plansCollection = [SELECT Id, Product2.Name FROM OrderItem WHERE Product2.vlocity_cmt__Type__c = 'Plan Prepago' AND OrderId = :orderId ORDER BY Product2.Name];
            
            System.debug('PlansCollection: ' + plansCollection);

            for(OrderItem orderItem : plansCollection){
                oiIds.add(orderItem.Id);
                planNames.put(orderItem.Id, orderItem.Product2.Name);
            }

            //List<OrderItem> items = [select Product2.Name, Product2.ProductCode, Quantity, vlocity_cmt__ParentItemId__c from OrderItem where Product2.Family = 'Simcard' and vlocity_cmt__ParentItemId__c IN :oiIds];
            //List<OrderItem> items = [select Id, Product2.Name, Product2.ProductCode, Quantity, vlocity_cmt__ParentItemId__c from OrderItem where Product2.ProductCode = 'FAN_PSIM_STANDARD' and vlocity_cmt__ParentItemId__c IN :oiIds];
            List<OrderItem> items = [select Id, Product2.Name, Product2.ProductCode, Quantity, vlocity_cmt__ParentItemId__c from OrderItem where Product2.vlocity_cmt__Type__c = 'Simcard' and vlocity_cmt__ParentItemId__c IN :oiIds];
            for(OrderItem item: items){
                //List<OrderItem> children = itemsByProductName.get(item.Product2.Name);
                //if(planNames.contains(items.vlocity_cmt__ParentItemId__c))
                List<OrderItem> children = itemsByProductName.get(planNames.get(item.vlocity_cmt__ParentItemId__c));
                if(children == null){
                    children = new List<OrderItem>();
                }
                children.add(item);
                itemParents.put(item.Product2.Name, item.vlocity_cmt__ParentItemId__c);
                itemsByProductName.put(planNames.get(item.vlocity_cmt__ParentItemId__c), children);
            }

            System.debug('itemsByProductName'+itemsByProductName+'.keySet()'+itemsByProductName.keySet());
            for(String productName: itemsByProductName.keySet()){
                plan = new Map<String, Object>();
                List<Map<String, Object>> lines = new List<Map<String, Object>>();
                for(OrderItem item: (List<OrderItem>)itemsByProductName.get(productName)){
                    Map<String, Object> tempMapLine = new Map<String, Object>();
                    tempMapLine.put('isSelected', false);
                    tempMapLine.put('linea', null);
                    tempMapLine.put('validacionLinea', null);
                    tempMapLine.put('NMU', productName);
                    tempMapLine.put('serial', null);
                    tempMapLine.put('validacionSerial', null);
                    tempMapLine.put('orderItemId', item.Id) ;
                    tempMapLine.put('orderItemParentId', item.vlocity_cmt__ParentItemId__c) ;
                    lines.add(tempMapLine);
                }
                  
                //plan.put('nombre', planNames.get(itemParents.get(productName)));
                plan.put('nombre', productName);
                plan.put('isSelected', false);
                plan.put('lineas', lines);
                plans.add(plan);
                System.debug('Plan'+Plan);
            }

            for(OrderItem item: items){
                Integer i = groupedNmus.get(item.Product2.ProductCode);
                if(i == null){
                    i = 0;
                }
                i += (Integer)item.Quantity;
                groupedNmus.put(item.Product2.ProductCode, i);
            }

            for(String s: groupedNmus.keySet()){
                Map<String, Object> nmu = new Map<String, Object>();
                nmu.put('codNMU', s);
                nmu.put('codDeposito', codDeposito);
                nmu.put('cantidad', groupedNmus.get(s));
                nmus.put(s, nmu);
            }

            System.debug('nmus: ' + nmus);

            /* DA - 6/11/2017: PFTA-6749. Se quita el paso de reserva por NMU de las SIMCards.
            Cuando se realice reserva de otro tipo de producto hay que revisar el código.  
            */
            try
            {
                //PFTA - 10326 - Se envia siempre punto de venta 0
                String idUnicoTransaccion = GuidUtil.NewGuid();
                System.debug('SaleManager:idUnicoTransaccion: ' + idUnicoTransaccion);
                Map<String,Object> response = IFS_S101_reserveOrRelease.reserveOrRelease('R', codAplicacion, orderId, '0', idUnicoTransaccion, nmus);

                String httpResponseCode = (String) response.get('httpStatusCode');
                if (httpResponseCode != '200' && httpResponseCode != '201')
                    throw new FuncException('Error al invocar al servicio de reserva por NMU. ' + response);
            }
            catch(Exception e){}
          
            principalNode.put('lineasReservadas', false);
            principalNode.put('planes', plans);
            principalNode.put('serialesReservados', false);

            returnList.add(principalNode);
            outMap.put('options', returnList[0]);

            System.debug('Fin ReserveProducts' + returnList);
        }
        catch(Exception e){
            System.debug('SaleManager:invokeMethod -> exception: '+e);
        }
    }

    void AssingProductsToServiceAccount(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try
        {
            System.debug('AssingLinesToDiferentUser');
            String orderId = (String) options.get('IdOrder');
            String accountId = (String) options.get('accountId');
            String serviceContactId = (String) options.get('serviceContactId');
            String userPermissionLevel = (String) options.get('userPermissionLevel');

            System.debug('userPermissionLevel: ' + userPermissionLevel);

            RecordType recordType = [SELECT Id from RecordType WHERE Name = 'Service' AND SobjectType = 'Account'];

            Account serviceAccount = [SELECT BillingAddress,BillingAddressStore__c,BillingLatitude,BillingLongitude,BillingPostalCode,
            Billing_Day__c,ClubMember__c,CuitNumber__c,CuitType__c,Dunning__c,vlocity_cmt__BillDeliveryMethod__c,Name,ParentId,PersonalClubCategory__c,
            PersonalClubPoints__c,ShippingAddress,ShippingAddressStore__c,ShippingLatitude,ShippingLongitude,SocialPlan__c,
            ValidatedBillingAddress__c,ValidatedShippingAddress__c,vlocity_cmt__Active__c,vlocity_cmt__ContactPreferences__c,
            vlocity_cmt__Status__c, UserLevel__c FROM Account WHERE Id = :accountId];
            serviceAccount.vlocity_cmt__PrimaryContactId__c = serviceContactId;
            serviceAccount.RecordTypeId = recordType.Id;
            serviceAccount.Id = null;
            serviceAccount.UserLevel__c = (userPermissionLevel <> '') ? userPermissionLevel : 'High';

            System.debug('userPermissionLevel: ' + userPermissionLevel);

            insert serviceAccount;

            List<OrderItem> itemsCollection = [SELECT Id FROM OrderItem WHERE OrderId = :orderId];
            for(OrderItem item : itemsCollection)
            {
                item.vlocity_cmt__ServiceAccountId__c = serviceAccount.Id;
            }
            update itemsCollection;
        }
        catch(Exception e){
            System.debug('SaleManager:invokeMethod -> exception: '+e);
        }
    }

    void ValidateEmailSettings(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        String fieldEmail = (String) options.get('FieldEmail');
        List<Map<String, Object>>  returnList = new List<Map<String,Object>>();
        Map<String, Object> principalNode = new Map<String, Object>();
        Boolean emailDomain = false;
        Boolean emailValidated = true;
        if (String.isBlank(fieldEmail) == false) {
            List<ValidEmailDomain__c> domainList = ValidEmailDomain__c.getall().values();
            String strDomain = fieldEmail.split('@').get(1);
            
            for (ValidEmailDomain__c mydomain : domainList) {
                if (mydomain.Name == '@' + strDomain) {
                    emailDomain = true;
                }
            }
            
            if (emailDomain == true) {
                List<AggregateResult> result  = [SELECT Count(Id) total FROM Contact WHERE Email =:fieldEmail];
                Decimal intExistingEmails = (Decimal) result[0].get('total');
                EmailsSetting__c mhc = EmailsSetting__c.getInstance();
                Decimal maxEmails = mhc.CantidadDeEmails__c;
                if ((intExistingEmails + 1 ) > maxEmails) {
                    emailValidated = false;
                }
            }
            
            principalNode.put('emailMax', emailValidated);
            principalNode.put('emailDomain', emailDomain);
            
            try{
                Map<String, Object> responseNode = IFS_S171_validateEMail.validateEMail(fieldEmail);
                principalNode.put('emailValidation', (String)responseNode.get('CodeEstado'));
                principalNode.put('emailHistoryValidation', fieldEmail);
    
            } catch(Exception ex){
                principalNode.put('emailValidation', 'ERROR');
                principalNode.put('emailHistoryValidation', 'N/A');
                throw ex;
            }
            
        }
        else {
            principalNode.put('emailMax', true);
            principalNode.put('emailDomain', true);
            principalNode.put('emailValidation', 1);
            principalNode.put('emailHistoryValidation', fieldEmail);
        }
        
        returnList.add(principalNode);
        outMap.put('options', returnList[0]);
        
    }
    
    void SetStockMovementCodes(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        String deliveryMethod = (String) options.get('DeliveryMethod');
        String orderId = (String) options.get('IdOrder');
        
        Map<string, Object> response = TaMatrixUtils.getStockMovementOperation('VTAN','ENTREGA', deliveryMethod, 'NOAPLICA');
        String codOperation =  (String) response.get('StockMovementOperation__OperationCode');
        String destinationDepositCode = (String) response.get('StockMovementOperation__DestinationDepositCode');
        
        if(destinationDepositCode == 'VICLIE')
            destinationDepositCode = 'VICLIE0001';
        
        //List<OrderItem> itemsCollection = [SELECT Id, Operation_Code__c, Deposit_Code__c FROM OrderItem WHERE OrderId = :orderId];
        List<OrderItem> itemsCollection = taOrderController.GetOrderSerials(orderId);
        for(OrderItem item : itemsCollection)
        {
            item.Operation_Code__c = codOperation;
            item.Deposit_Code__c = destinationDepositCode;
        }
        update itemsCollection;
    }

    void SendPickUpInformationEmail(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('Send PickUp Information Email');
        String orderId = (String) options.get('IdOrder');
        String emailToSend = (String) options.get('EmailToSend');
        
        if (emailToSend != null && emailToSend != '') {
            RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'EmailToSend'];
            
            CrossObject__c crossObj = new CrossObject__c(Email1__c = emailToSend, RecordTypeId = rt.Id, Picklist1__c = 'Detalles de Pickup', Order__c = orderId);
            insert crossObj;
        }
    }

    void GetAmountInfoRefillSOS(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        System.debug('GetAmountInfoRefillSOS');
        String idOrder = (String) inputMap.get('IdOrder');
        Map<String,Object> result = new Map<String,Object>();
        System.debug('idOrder: ' + idOrder);
        List<OrderItem> items = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId = :idOrder];
        Integer itemsCount = 0;
        while(itemsCount < items.size())
        {
            System.debug('vlocity_cmt__JSONAttribute__c: ' + items[itemsCount].vlocity_cmt__JSONAttribute__c);
            if (items[itemsCount].vlocity_cmt__JSONAttribute__c != null)
            {

                result = AssetAttributesUtils.GetJSONAttribute(items[itemsCount].vlocity_cmt__JSONAttribute__c, 'Monto del Prestamo');

            }
            itemsCount++;
        }

        System.debug(result);

        outMap.put('RefillAmount',result);

    }

    void GetDeliveryMethodOptions(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        try {
            System.debug('GetDeliveryMethodOptions inputMap: ' + inputMap);
            System.debug('GetDeliveryMethodOptions outMap: ' + outMap);
            System.debug('GetDeliveryMethodOptions options: ' + options);
        }
        catch (Exception e) {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
            throw e;
        }
    }
}