global with sharing class taClientSearchController implements vlocity_cmt.VlocityOpenInterface{

    public String valor { get; set; }

    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        Boolean result = true;
        try{
            if (methodName.equals('SearchContacts')){
                SearchContacts(inputMap, outMap, options);
            }

            result = false;  
        } catch(Exception e){
            System.debug('taOrderController:invokeMethod -> exception: '+e);
            result = false;
        }

        return result;
    }

    @RemoteAction
    global static void UpdateContact(String contactId, String newEmail){
        Id contId = Id.valueOf(contactId);
        Contact contact = [SELECT Id FROM Contact WHERE Id =: contId LIMIT 1];
        contact.Email = newEmail;
        update contact;
    }

    @RemoteAction
    global static String CheckClientInBlackList(String accountId, String accountDocumentNumber, String accountDocumentType ) {
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        String remoteActionResponse = '';
        
        Map<String, Object> params = new Map<String, Object>();
        // System.debug('accountDocumentType con IntegrationUtils: ' + IntegrationUtils.ParseDocumentType(accountDocumentType));
        params.put('numeroDocumento', accountDocumentNumber);
        params.put('tipoDocumento', IntegrationUtils.ParseDocumentType(accountDocumentType));
        
        options.put('params', params);
        
        input.put('params', params);
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        
        integProcServ.invokeMethod('IFS_S218', input, output, options);
        System.debug('service: ' + input);

        //System.debug('output: ' + output);
        Map<String, Object> response = (Map<String, Object>) output.get('IPResult');

        //System.debug('response: ' + response);
        
        if (!response.isEmpty()) {
            String respuesta = (String) response.get('marcaEnListaNegra');
            System.debug('Respuesta: ' + respuesta);
            remoteActionResponse = respuesta;
        }

        return remoteActionResponse;
    }

    @RemoteAction
    global static Boolean CheckDunning(String integrationId) {
        System.debug('CheckDunning');
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        /*DateTime actualDate = date.today();
        String actualDateReplace = (String) actualDate.replace('-', '');*/
        Datetime dt = Datetime.now();
        String actualDate = dt.format('yyyyMMddHHmmss');
        //DateTime actualDate = DateTime.newInstance(dt.year(), dt.month(), dt.day(), dt.hour(), dt.minute(), dt.second(), 0);
        //String ipResponse = '';
        Boolean dunning = false;

        Map<String, Object> body = new Map<String, Object>();
        options.put('body', body);
        Map<String, Object> acctAccessCode = new Map<String, Object>();
        body.put('acctAccessCode', acctAccessCode);
        acctAccessCode.put('identificadorRecurso', integrationId);
        body.put('fechaDesde', actualDate);
        body.put('fechaHasta', actualDate);

        //System.debug('Body:' + body);
        input.put('body', body);
        vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
        integProcServ.invokeMethod('IFS_S055', input, output, options);
        //System.debug('IP output: ' + output);
        Map<String, Object> response = (Map<String, Object>) output.get('IPResult');

        if (!response.isEmpty()) {
            List<Object> collectionInfoList = (List<Object>) response.get('collectionInfoList');
            //System.debug('responseIP' + response);
            //System.debug('collectionInfoList' + collectionInfoList);
            //System.debug('collectionInfoList.size()' + collectionInfoList.size());
            if (collectionInfoList != null && collectionInfoList.size() > 0) {
                dunning = true;
            }
        }

        return dunning;
    }

    @RemoteAction
    global static String CheckAccountsStatus(String accountId, String accountDocumentNumber, String accountDocumentType ) {
        String remoteActionR;
        String integrationId;
        Boolean dunning;
        try{
            System.debug('CheckAccounts');
            System.debug('accountId: ' + accountId);
            integrationId = getIntegrationId(accountId);
            System.debug('integrationId:' + integrationId);
            dunning = CheckDunning(integrationId);
            System.debug('dunning:' + dunning);
            System.debug('accountId:' + accountId);
            UpdateDunningFromAccount(accountId, dunning);
        }catch(Exception e){
            System.debug('CheckDunning Error' + e);
        }

        try{
            remoteActionR = CheckClientInBlackList(accountId, accountDocumentNumber, accountDocumentType);
            System.debug('remoteActionR:' + remoteActionR);
            //DA-17/11/2017: Srpint 13. PFTA-7279: Create an Order for the record
            if (remoteActionR == 'true')
                createOrder(accountId);
            
        }
        catch(Exception e){
            System.debug('CheckClientInBlackList Error' + e);
        }

        return remoteActionR;
    }

    public static void createOrder(String accountId)
    {
        //DA-17/11/2017: Srpint 13. PFTA-7279: Create an Order with a Cancelleds status and Fraude resason
        System.debug('Entering createOrder()');
        System.debug('Inputs: ' + accountId);
        //Order order = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pricebookId);
        Order ord;

        try{
            ord = new Order(
                AccountId = accountId, 
                Status = 'Cancelled', 
                TrackingStatus__c= 'Fraude', 
                Gestion__c='Venta', 
                EffectiveDate = Date.today()
            );
            insert ord;
        }
        catch(Exception e){
            System.debug('createOrder Error' + e);
        }
    } 

    global static String getIntegrationId(String accountId) {
        System.debug('get IntegrationId');
        System.debug('accountId:' + accountId);
        String integrationId;
        Id accId = Id.valueOf(accountId);

        for(Account a : [SELECT AccountIntegrationId__c FROM Account WHERE Id = :accId LIMIT 1])
        {
            System.debug('IN FOR a.AccountIntegrationId__c: ' + a.AccountIntegrationId__c);
            integrationId = a.AccountIntegrationId__c;
        }
        System.debug('fin integrationId:' + integrationId);
        return integrationId;
    }
/*
    global static Boolean getDunningFromAccount(String accountId) {
        System.debug('get Dunning From Account');
        Boolean dunningAcc = false;
        Id accountId = Id.valueOf(accountId);

        for(Account a : [SELECT Dunning__c FROM Account WHERE Id = :accountId LIMIT 1])
        {
            dunningAcc = (Integer) a.Dunning__c;
        }
        return dunningAcc;
    }
*/
    @RemoteAction
    global static void UpdateDunningFromAccount(String accountId, Boolean newDunning){
        //System.debug('Update Dunning from Account');
        Id accId = Id.valueOf(accountId);
        //System.debug('accId ' + accId);
        //System.debug('newDunning ' + newDunning);
        Account actualAccount = new Account();//[SELECT Dunning__c FROM Account WHERE Id = :accId LIMIT 1];
        actualAccount.Id = accId;
        //System.debug('actualAccount ' + actualAccount);
        actualAccount.Dunning__c = newDunning;
        //System.debug('actualAccount.Dunning__c ' + actualAccount.Dunning__c);
        update actualAccount;
    }

    void SearchContacts(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        System.debug('SearchContacts');
        try
        {
            Map<String, Object> contactSearch = (Map<String, Object>) inputMap.get('ContactSearch');
            String documentTypeSearch = (String) options.get('DocumentTypeSearch');
            String documentInputSearch = (String) options.get('DocumentInputSearch');
            String genderSearch = (String) options.get('GenderSearch');
            String dataJson = '{"GenderSearch":"' + genderSearch + '", "DocumentTypeSearch":"' + documentTypeSearch + '", "DocumentInputSearch":"' + documentInputSearch + '"}';
            //String dataJson = '{"GenderSearch":"Jaime", "DocumentTypeSearch":"DNI", "DocumentInputSearch":"32123123"}';
            vlocity_cmt.DRProcessResult result = vlocity_cmt.DRGlobal.processObjectsJSON(dataJson, 'ta-sales-DR-SearchContact');
            Map<String, Object> resultMap = result.convertToMap();
            Map<String, Object> returnResultsData = (Map<String, Object>) resultMap.get('returnResultsData');
            Map<String, Object> contact = (Map<String, Object>) returnResultsData.get('Contact');
            System.debug('contact: ' + contact);
            Map<String, Object> businessAccount;
            String contactId = (String) contact.get('Id');
            if (String.isNotBlank(contactId))
            {
                System.debug(JSON.serialize(contact));
                //0036C000007Ib6pQAC
                //0016C0000095FDpQAM
                dataJson = '{"Id":"' + contactId + '"}';
                result = vlocity_cmt.DRGlobal.processObjectsJSON(dataJson, 'ta-sales-DR-getAccountsByContactId');
                resultMap = result.convertToMap();
                returnResultsData = (Map<String, Object>) resultMap.get('returnResultsData');
                businessAccount = (Map<String, Object>) returnResultsData.get('BusinessAccount');
                if (businessAccount != null)
                {
                    System.debug(JSON.serialize(businessAccount));
                }
                else
                {
                    System.debug('No hay billings');
                }
            }
            else
            {
                System.debug('No existe el contacto');
            }
            String body = '{"params":{"numeroDocumento": "' + documentInputSearch + '","tipoDocumento": "' + documentTypeSearch + '"}}';
            String listanegra;
            Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options2 = new Map<String, Object>();

            vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
            integProcServ.invokeMethod('IFS_S218', input, output, options2);
            System.debug('service: ' + input);

            Map<String,Object> result2 = (Map<String,Object>) output.get('result');
            if (result2 == null){
                Map<String,Object> ipResult = (Map<String,Object>) output.get('IPResult');
                System.debug('ipResult: ' + ipResult);
                listanegra = (String) ipResult.get('marcaEnListaNegra');
                System.debug('listanegra: ' + listanegra);
            }else{
                System.debug('response: ' + result2);
            }
            //outmap.put('Contact', contact);
            //contactSearch.put('Contact', contact);
            contactSearch.put('FirstName', (String) contact.get('FirstName'));
            contactSearch.put('LastName', (String) contact.get('LastName'));
            contactSearch.put('Birthdate', (Date) contact.get('Birthdate'));
            contactSearch.put('Email', (String) contact.get('Email'));
            contactSearch.put('AccountId', (String) contact.get('AccountId'));
            System.debug('contactSearch: ' + contactSearch);
            outmap.put('ContactSearch', contactSearch);
            outmap.put('BusinessAccount', businessAccount);
            outmap.put('listanegra', listanegra);
            outmap.put('searchDone', true);
            System.debug('outmap: ' + outmap);
        }
        catch(Exception e) {
            throw new FuncException('An unexpected error has occurred: ' + e.getMessage());
            System.debug(e.getMessage());
        }
    }
}