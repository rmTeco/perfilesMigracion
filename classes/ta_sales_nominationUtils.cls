public class ta_sales_nominationUtils{
    
    public static void nominateClient(String jsonString){
        
        RecordType consumerAccountRecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1];
        
        Map<String, Object> theMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        Map<String, Object> activateNominatedService = (Map<String,Object>) theMap.get('activateNominatedService');
        
        // The ORIGIN ACCOUNT is retrieved using the Asset
        String assetLineNumber = (String)activateNominatedService.get('nroLinea');
        Asset asset = [
            SELECT Id, AccountId, Name, Quantity, SerialNumber, Status, vlocity_cmt__ActivationDate__c, MSISDN__c, vlocity_cmt__OneTimeTotal__c, vlocity_cmt__ProvisioningStatus__c, vlocity_cmt__RecurringTotal__c, vlocity_cmt__RootItemId__c
            FROM Asset 
            WHERE MSISDN__c =: assetLineNumber 
            LIMIT 1];
        
        if (asset != null) {
            System.debug('Asset Exists: ' + asset);
            String originAccountId = asset.AccountId;
            
            Account acc = [SELECT Id, UnnamedCustomer__c FROM Account WHERE Id =: originAccountId LIMIT 1];
            
            //Check that the ORIGIN Account is a WHOLESALE Account 
            if (acc != null && acc.UnnamedCustomer__c) {
                System.debug('Origin Account is WHOLESALE: ' + acc);
                
                //---------------CONTACT----------------
                Boolean previouslyExistingContact = false;
                
                Contact thisContact;
                
                String documentType = (String)activateNominatedService.get('tipoDocumento');
                String documentNumber = (String)activateNominatedService.get('numeroDocumento');
                Date birthDate = Date.parse((String)activateNominatedService.get('fechaNacimiento'));
                
                List<Contact> contacts = [SELECT Id, BirthDate, Gender__c FROM Contact WHERE DocumentType__c = :documentType AND DocumentNumber__c = :documentNumber];
                
                if(contacts.size() == 0){ //it is a nonexistant contact
                    thisContact = new Contact(
                        BirthDate = birthDate,
                        DocumentNumber__c = documentNumber,
                        DocumentType__c = documentType,
                        FirstName = (String)activateNominatedService.get('nombre'),
                        Gender__c = (String)activateNominatedService.get('genero'),
                        LastName = (String)activateNominatedService.get('apellido')
                    );
                }else if(contacts.size() > 2){ //if 3 or more contacts with same DNI need to find which is the right one
                    for(Contact con: contacts){
                        if(con.BirthDate == birthDate){
                            thisContact = con;
                            previouslyExistingContact = true;
                            break;
                        }
                    }
                    if(!previouslyExistingContact){
                        enviarSMS((String)activateNominatedService.get('nroLinea'));
                    }
                }else if(contacts.size() == 2){ // 2 contacts with same DNI happens with male/female person
                    String gender = (String)activateNominatedService.get('genero');
                    if (contacts[0].Gender__c == gender) thisContact = contacts[0];
                    else thisContact = contacts[1];
                    previouslyExistingContact = true;
                }else{ //only one contact matched
                    previouslyExistingContact = true;
                    thisContact = contacts[0];
                }
                //--get fields that may have been modified
                String checkName = (String)activateNominatedService.get('nombre');
                if (!String.isEmpty(checkName)) {
                    thisContact.FirstName = checkName;
                }
                String checkLastname = (String)activateNominatedService.get('apellido');
                if (!String.isEmpty(checkLastname)) {
                    thisContact.LastName = checkLastname;
                }
                String checkBDate = (String)activateNominatedService.get('fechaNacimiento');
                if (!String.isEmpty(checkBDate)) {
                    thisContact.Birthdate = Date.parse(checkBDate); 
                }
                String checkStreet = (String)activateNominatedService.get('calle');
                if (!String.isEmpty(checkStreet)) {
                    thisContact.MailingStreet = checkStreet;
                }
                system.debug('activateNominatedService......' + activateNominatedService);
                upsert thisContact;
                
                //---------------ACCOUNT----------------
                
                Account thisAccount;
                Boolean isNewAccount = false;
                
                if(previouslyExistingContact){
                    List<Account> accounts = [SELECT Id, UnnamedCustomer__c FROM Account WHERE vlocity_cmt__PrimaryContactId__c = :thisContact.Id];
                    if(accounts.size() > 0){
                        thisAccount = accounts[0];
                    }
                }
                
                if(thisAccount == null){
                    thisAccount = new Account(
                        CreditLimit__c = 0, //TODO
                        CreditRisk__c = '', //TODO
                        ContactPreferencePhone__c = (String)activateNominatedService.get('nroLinea'),
                        BillingCity = (String)activateNominatedService.get('descripcionLocalidad'),
                        BillingAddressStore__c = false, //TODO
                        BillingPostalCode = (String)activateNominatedService.get('codigoPostal'),
                        BillingStateCode = '', //TODO
                        BillingStreet = (String)activateNominatedService.get('calle') + ' ' + (String)activateNominatedService.get('altura') + ' ' + (String)activateNominatedService.get('piso') + ' ' + (String)activateNominatedService.get('departamento'),
                        Name = (String)activateNominatedService.get('nombre') + ' ' + (String)activateNominatedService.get('apellido'),
                        CuitNumber__c = 0, //TODO
                        vlocity_cmt__BillingEmailAddress__c = '', //TODO
                        ShippingCity = (String)activateNominatedService.get('descripcionLocalidad'),
                        ShippingPostalCode = (String)activateNominatedService.get('codigoPostal'),
                        ShippingStreet = (String)activateNominatedService.get('calle') + ' ' + (String)activateNominatedService.get('altura') + ' ' + (String)activateNominatedService.get('piso') + ' ' + (String)activateNominatedService.get('departamento'),
                        ShippingAddressStore__c = false, //TODO
                        DocumentNumber__c = (String)activateNominatedService.get('numeroDocumento'),
                        DocumentType__c = (String)activateNominatedService.get('tipoDocumento'),
                        ValidatedBillingAddress__c = false, //TODO
                        ValidatedShippingAddress__c = false, //TODO
                        vlocity_cmt__ContactPreferences__c = '', //TODO
                        ShippingStateCode = '', //TODO
                        RecordTypeId = consumerAccountRecordType.Id,
                        vlocity_cmt__PrimaryContactId__c = thisContact.Id, 
                        BillingCountryCode = (String)activateNominatedService.get('codPais'), 
                        ShippingCountryCode = (String)activateNominatedService.get('codPais')
                    );
                    system.debug('Nominacion cuenta a insertar');
                    system.debug(thisAccount);
                    insert thisAccount;
                    isNewAccount = true;
                }
                
                //Create Customer in Huawei
                if (isNewAccount) {
                    System.debug('Creating Customer in Huawei');
                    Map<String, Object> inputMap = new Map<String, Object>();
                    Map<String, Object> outputMap = new Map<String, Object>();
                    Map<String, Object> optionsMap = new Map<String, Object>();
                    
                    optionsMap.put('AccountId', thisAccount.Id);
                    
                    taSalesSimulationInvoiceHandler.Call_S202_Create_Customer(inputMap, outputMap, optionsMap);
                }
                
                //---------------TAX CONDITION----------------
                
                TaxCondition__c thisTaxCondition = new TaxCondition__c(
                    Status__c = 'Activo',
                    Account__c = thisAccount.Id
                );
                
                insert thisTaxCondition;
                
                //---------------TAX CONDITION DETAIL----------------
                
                TaxConditionDetail__c thisTaxConditionDetail = new TaxConditionDetail__c(
                    Type__c = 'IVA',
                    TaxCondition__c = thisTaxCondition.Id,
                    Category__c = '' //TODO AccountData.ImpositiveCondition
                );
                
                insert thisTaxConditionDetail;
                
                //---------------ATTACHMENT----------------
                
                Attachment thisAttachment = new Attachment(
                    ParentId = thisAccount.Id,
                    Name = '' //TODO ImageFile.filename
                    //TODO Body = ImageFile.data
                );
                
                //insert thisAttachment;
                
                //---------------ORDER----------------
                
                Map<String, Object> input = new Map<String, Object>();
                Map<String, Object> output = new Map<String, Object>();
                Map<String, Object> options = new Map<String, Object>();
                
                vlocity_cmt.OmniMoveAssetWrapper omaw = new vlocity_cmt.OmniMoveAssetWrapper();
                
                Map<String, Object> selectInOutDate = new Map<String, Object>();
                selectInOutDate.put('MoveInDate', String.valueOf(DateTime.now()));
                selectInOutDate.put('MoveOutDate', String.valueOf(DateTime.now()));
                
                input.put('moveInAccountId', thisAccount.Id);
                input.put('moveOutAccountId', originAccountId);
                input.put('SelectInOutDate', selectInOutDate);
                
                omaw.invokeMethod('createOrder', input, output, options);
                
                //Create Billing Account in Huawei
                if (isNewAccount) {
                    System.debug('Creating Billing Account in Huawei');
                    Map<String, Object> inputMap2 = new Map<String, Object>();
                    Map<String, Object> outputMap2 = new Map<String, Object>();
                    Map<String, Object> optionsMap2 = new Map<String, Object>();
                    
                    optionsMap2.put('AccountId', thisAccount.Id);
                    optionsMap2.put('OrderId', (String) output.get('OrderId'));
                    
                    if(!Test.isRunningTest()){taSalesSimulationInvoiceHandler.Call_S015_Create_Billing_Account(inputMap2, outputMap2, optionsMap2);}
                }
                
                Map<String, Object> assetInfo = new Map<String, Object>();
                String availability = 'Available';
                String vlcSelected = 'true';
                String level = '1';
                String isRoot = 'true';
                String isExpanded = 'false';
                
                assetInfo.put('Product Name', asset.Name);
                assetInfo.put('RootItemId', asset.vlocity_cmt__RootItemId__c);
                assetInfo.put('Recurring Total', 'ARS0,00');//asset.vlocity_cmt__RecurringTotal__c
                assetInfo.put('Availability', availability);
                assetInfo.put('vlcSelected', vlcSelected);
                assetInfo.put('level', level);
                assetInfo.put('isRoot', isRoot);
                assetInfo.put('isExpanded', isExpanded);
                assetInfo.put('Id', asset.Id);
                assetInfo.put('Asset Name', asset.Name);
                assetInfo.put('Quantity', asset.Quantity);
                //assetInfo.put('Serial Number', asset.SerialNumber);
                //assetInfo.put('Status', asset.Status);
                //assetInfo.put('Activation Date', asset.vlocity_cmt__ActivationDate__c);
                assetInfo.put('LineNumber', asset.MSISDN__c);
                assetInfo.put('One Time Total', 'ARS0,00');//asset.vlocity_cmt__OneTimeTotal__c
                assetInfo.put('Provisioning Status', asset.vlocity_cmt__ProvisioningStatus__c);
                
                List<Object> filteredAsset = new List<Object>();
                filteredAsset.add(assetInfo);
                
                options.put('JSON Node', 'FilteredAsset');
                options.put('jsonPath', 'FilteredAsset');
                options.put('assetId', asset.Id);
                
                input.put('Asset Info', assetInfo);
                input.put('FilteredAsset', filteredAsset);
                
                System.debug('Order Id: ' + (String) output.get('OrderId'));
                input.put('OrderId', (String) output.get('OrderId'));
                
                System.debug('Asset Info: ' + JSON.serialize(assetInfo));
                System.debug('Filtered Asset: ' + JSON.serialize(filteredAsset));
                System.debug('Options: ' + options);
                System.debug('JSON Node: ' + options.get('JSON Node'));
                System.debug('jsonPath: ' + options.get('jsonPath'));
                
                if(!Test.isRunningTest()){
                    //omaw.invokeMethod('moveNewAssets', input, output, options);
                    BillingResponseHandler.getNominationAssets(input, output, options);
                    Map<String, Object> selectAssets = new Map<String, Object>();
                    selectAssets.put('SelectAssets', output.get('SelectAsset'));
                    input.put('JSON Node', filteredAsset);
                    input.put('JSON Node', selectAssets);
                    omaw.invokeMethod('moveAssets', input, output, options);
                    
                }
                if(Test.isRunningTest()){output.put('OrderId',(String)activateNominatedService.get('OrderId'));}
                
                //Get the OrderId created by method createOrder
                String orderId = (String) output.get('OrderId');
                List<OrderItem> orderItems = [
                    SELECT Id, Description, ProductCode__c, ProductName__c, vlocity_cmt__SerialNumber__c,vlocity_cmt__JSONAttribute__c 
                    FROM OrderItem 
                    WHERE OrderId =: orderId];
                
                if (!orderItems.isEmpty()) {
                    Order order = new Order(Id = orderId, Gestion__c = 'Nominacion');
                    for(OrderItem ordItem : orderItems) {
                        ordItem.vlocity_cmt__Action__c = 'Change';
                        ordItem.vlocity_cmt__ProvisioningStatus__c = 'Active';
                        Map<String,String> attribs = new Map<String,String>();
                        attribs.put('MSISDN', asset.MSISDN__c);
                        String jsonAttribute = AssetAttributesUtils.setValuesOnJSON(ordItem.vlocity_cmt__JSONAttribute__c, attribs);
                        ordItem.vlocity_cmt__JSONAttribute__c = jsonAttribute;
                    }
                    update order;
                    update orderItems;
                }
                
                /*input.put('cartId', orderId);
                input.put('ContextId', orderId);
                vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
                cpqAppHandler.invokeMethod('checkout', input, output, options);*/
                
                /*vlocity_cmt.SimpleDecompositionManager.startOrderProcessing(orderId);
                vlocity_cmt.SimpleDecompositionController.decomposeOrder(orderId);*/
                vlocity_cmt.SimpleDecompositionController.decomposeAndCreatePlanEx(orderId, false);
            }
        }
    }
    
    private static void enviarSMS(String cellNumber){
        CrossObject__c template = [SELECT Id, String1__c FROM CrossObject__c WHERE Picklist1__c = 'Error de nominacion' AND RecordType.Name = 'SMS Template' LIMIT 1];
        String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ template.String1__c +'"}}';
        Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        integProcServ.invokeMethod('IFS_S159', input, output, options2);
    }
    
    public static void enviarSMSExito(String cellNumber){
        CrossObject__c template = [SELECT Id, String1__c FROM CrossObject__c WHERE Picklist1__c = 'Nominacion exitosa' AND RecordType.Name = 'SMS Template' LIMIT 1];
        String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ template.String1__c +'"}}';
        Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options2 = new Map<String, Object>();
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        integProcServ.invokeMethod('IFS_S159', input, output, options2);
        
        RecordType trackingrt = [SELECT Id FROM RecordType WHERE SObjectType = 'CrossObject__c' AND DeveloperName = 'SMSTracking'];
        
        insert new CrossObject__c(String1__c = cellNumber, String2__c = template.String1__c, RecordTypeId = trackingrt.Id, DateTime1__c = System.now(), Picklist1__c = 'Nominacion exitosa', Status__c = 'Pendiente', MarkForDeletion__c = true);
    }
}