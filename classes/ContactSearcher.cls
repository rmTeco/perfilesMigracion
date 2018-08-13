global with sharing class ContactSearcher implements vlocity_cmt.VlocityOpenInterface
{
    global ContactSearcher() {}
    
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options)
    {
        Boolean result = true;
        try
        {
            if (methodName.equals('GetClients'))
            {
                GetClients(inputMap, outMap, options);
            }
            if (methodName.equals('GetNoNominatedLines'))
            {
                GetNoNominatedLines(inputMap, outMap, options);
            }
            result = false;
        }catch(Exception e)
        {
            System.debug('ContactSearcher:invokeMethod -> exception: '+e);
            System.debug('Stack Trace: ' + e.getStackTraceString());
            result = false;
        }
        return result;
    }
    
    void GetClients(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options)
    {
        String contactFirstName = (String)options.get('ContactFirstName');
        String contactLastName = (String)options.get('ContactLastName');
        String phone = (String)options.get('PhoneNumber');
        String accountName = (String)options.get('AccountName');
        String documentType = (String)options.get('DocumentType');
        String documentNumber = (String)options.get('DocumentNumber');
        String accountNumber = (String)options.get('AccountNumber');
        String email = (String)options.get('Email');
        system.debug('Phone'+phone+'options'+options);
        List<Account> accounts = new List<Account>();
        Map<Id, List<Asset>> assetsWithLineNumberByAcc = new Map<Id, List<Asset>>();
        Map<Id, List<Asset>> assetsNoLineNumberByAcc = new Map<Id, List<Asset>>();
        Map<Id, List<Account>> parentAccountIdToBillingAccountMap = new Map<Id, List<Account>>();
        Map<Id, List<Asset>> assetsWithLineNumberByBillingAcc = new Map<Id, List<Asset>>();
         //Start code 
        Map<String, Object> validateSearch = new Map<String, Object>();
        if((String.isBlank(documentNumber))) documentNumber = null;
        if((String.isBlank(documentType))) documentType = null;
        if((String.isBlank(contactFirstName)))contactFirstName = null;
        if((String.isBlank(contactLastName))) contactLastName = null;
        if((String.isBlank(phone))) phone = null;
        if((String.isBlank(accountName))) accountName = null;
        if((String.isBlank(accountNumber))) accountNumber = null;
        if((String.isBlank(email))) email = null;
        validateSearch.put('contactFirstName',contactFirstName);
        validateSearch.put('contactLastName',contactLastName);
        validateSearch.put('phone',phone);
        validateSearch.put('accountName',accountName);
        validateSearch.put('documentType',documentType);
        validateSearch.put('documentNumber',documentNumber);
        validateSearch.put('accountNumber',accountNumber);
        validateSearch.put('email',email);        
        //end code 
        Id AppId = [SELECT ApplicationId,Name,Label FROM AppMenuItem where Name='Consola_FAN'].ApplicationId;
        Boolean firstCondition = true;
        String query;
        if (String.isNotBlank(phone))
        {
            //query = 'SELECT Name, MSISDN__c, Account.Id, Account.Name, Account.AccountNumber, Account.Phone, Account.vlocity_cmt__PrimaryContactId__r.DocumentType__c, Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c, Account.vlocity_cmt__PrimaryContactId__r.Email, Account.vlocity_cmt__PrimaryContactId__r.Last_Modified_Email_Date__c, Account.vlocity_cmt__PrimaryContactId__c ,Account.vlocity_cmt__PrimaryContactId__r.Name, Account.vlocity_cmt__Active__c, Account.UnnamedCustomer__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode  FROM Asset WHERE MSISDN__c = \'' + phone + '\'';//Account.Phone =: phone';
            //query = 'SELECT Name, MSISDN__c, Parent.Name, Account.Id, Account.Name, Account.AccountNumber, Account.Phone, Account.vlocity_cmt__PrimaryContactId__r.DocumentType__c, Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c, Account.vlocity_cmt__PrimaryContactId__r.Email, Account.vlocity_cmt__PrimaryContactId__r.Last_Modified_Email_Date__c, Account.vlocity_cmt__PrimaryContactId__c ,Account.vlocity_cmt__PrimaryContactId__r.Name, Account.vlocity_cmt__Active__c, Account.UnnamedCustomer__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode  FROM Asset WHERE MSISDN__c = \'%' + phone + '\'';//Account.Phone =: phone';
            query = 'SELECT Name, MSISDN__c, Parent.Name, Account.Id, Account.Name, Account.AccountIntegrationId__c, Account.Phone, Account.vlocity_cmt__PrimaryContactId__r.DocumentType__c, Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c, Account.vlocity_cmt__PrimaryContactId__r.Email, Account.vlocity_cmt__PrimaryContactId__r.Last_Modified_Email_Date__c, Account.vlocity_cmt__PrimaryContactId__c ,Account.vlocity_cmt__PrimaryContactId__r.Name, Account.vlocity_cmt__Active__c, Account.UnnamedCustomer__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, vlocity_cmt__ParentItemId__c  FROM Asset WHERE MSISDN__c like \'%' + phone + '\'';//Account.Phone =: phone';
            firstCondition = false;
        }
        else
        {
            query = 'SELECT Id, Name, AccountIntegrationId__c, Phone, vlocity_cmt__PrimaryContactId__r.DocumentType__c, vlocity_cmt__PrimaryContactId__r.DocumentNumber__c, vlocity_cmt__PrimaryContactId__r.Email, vlocity_cmt__PrimaryContactId__r.Last_Modified_Email_Date__c, vlocity_cmt__PrimaryContactId__c ,vlocity_cmt__PrimaryContactId__r.Name, vlocity_cmt__Active__c, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE ';
        }
        if (String.isNotBlank(documentType))
        {
            if (!firstCondition) query += ' AND ';
            query += (String.isNotBlank(phone) ? 'Account.' : '') + 'vlocity_cmt__PrimaryContactId__r.DocumentType__c = \'' + documentType + '\'';
            firstCondition = false;
        }
        
        if (String.isNotBlank(documentNumber))
        {
            if (!firstCondition) query += ' AND ';
            query += (String.isNotBlank(phone) ? 'Account.' : '') + 'vlocity_cmt__PrimaryContactId__r.DocumentNumber__c like \'%' + documentNumber + '%\'';
            firstCondition = false;
        }
        
        if((String.isBlank(documentType) && String.isBlank(documentNumber)) || (String.isNotBlank(documentType) && String.isBlank(documentNumber)) )
        {
            if (String.isNotBlank(contactFirstName))
            {
                if (!firstCondition) query += ' AND ';
                query += (String.isNotBlank(phone) ? 'Account.' : '') + 'vlocity_cmt__PrimaryContactId__r.FirstName like \'%' + contactFirstName + '%\'';
                firstCondition = false;
            }
            
            if (String.isNotBlank(contactLastName))
            {
                if (!firstCondition) query += ' AND ';
                query += (String.isNotBlank(phone) ? 'Account.' : '') + 'vlocity_cmt__PrimaryContactId__r.LastName like \'%' + contactLastName + '%\'';
                firstCondition = false;
            }
            
            if (String.isNotBlank(accountName))
            {
                if (!firstCondition) query += ' AND ';
                query += (String.isNotBlank(phone) ? 'Account.' : '') + 'Name like \'%' + accountName + '%\'';
                firstCondition = false;
            }
    
            if (String.isNotBlank(email))
            {
                if (!firstCondition) query += ' AND ';
                query += (String.isNotBlank(phone) ? 'Account.' : '') + 'vlocity_cmt__PrimaryContactId__r.Email like \'%' + email + '%\'';
            }
            
            if (String.isNotBlank(accountNumber))
            {
                if (!firstCondition) query += ' AND ';
                query += (String.isNotBlank(accountNumber) ? 'Account.' : '') + 'AccountIntegrationId__c like \'%' + accountNumber + '%\'';
            }
        }
        System.debug('Lets print the query ');
        System.debug(query);
        Boolean queryingAccounts;
        if (String.isNotBlank(phone))
        {
            List<Asset> lineas = Database.query(query);
            queryingAccounts = false;
            system.debug('pruebas ===>'+lineas);
            for(Asset linea: lineas)
            {
                system.debug('prueba ===>'+linea);
                List<Asset> assets = assetsWithLineNumberByAcc.get(linea.Account.Id);
                if(assets == null)
                {
                    assets = new List<Asset>();
                    accounts.add(linea.Account);
                }
                assets.add(linea);
                assetsWithLineNumberByAcc.put(linea.Account.Id, assets);
            }
        }
        else
        {
            Map<Id, Account> accountsById = new Map<Id, Account>();
            List<Account> accs = Database.query(query);
            Object obj=(object)accs;
            system.debug('Query: ' +query);
            system.debug('Querycp: ' +JSON.serialize(obj));
            system.debug('Accounts : ' + accs);
            queryingAccounts = true;
            
            for(Account acc: accs)
            {
                
                accountsById.put(acc.Id, acc);
                accounts.add(acc);
            }
            Set<Id> billingAccountIds = new Set<Id>();
            Id billingAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Billing' AND sObjectType = 'Account' LIMIT 1].Id;
            List<Account> billingAccounts = [SELECT Id, ParentId, Name FROM Account WHERE RecordTypeId =: billingAccountRecordTypeId AND ParentId IN :accountsById.keySet()];
            for (Account acc : billingAccounts)
            {
                billingAccountIds.add(acc.Id);
                List<Account> billingAccountsOfAccount = parentAccountIdToBillingAccountMap.get(acc.ParentId);
                if (billingAccountsOfAccount == null)
                {
                    billingAccountsOfAccount = new List<Account>();
                }
                billingAccountsOfAccount.add(acc);
                parentAccountIdToBillingAccountMap.put(acc.ParentId, billingAccountsOfAccount);
            }
            
            List<Asset> assets = [SELECT Id, Name, MSISDN__c, Parent.Name, Account.Id, Account.Name, Account.AccountIntegrationId__c, Account.ParentId, Account.vlocity_cmt__PrimaryContactId__r.DocumentType__c, Account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c, Account.vlocity_cmt__PrimaryContactId__r.Email, Account.vlocity_cmt__PrimaryContactId__c, Account.vlocity_cmt__PrimaryContactId__r.Last_Modified_Email_Date__c, Account.vlocity_cmt__PrimaryContactId__r.Name, Account.vlocity_cmt__Active__c, Account.UnnamedCustomer__c, vlocity_cmt__ParentItemId__c FROM Asset WHERE (Account.Id IN :accountsById.keySet() OR Account.Id IN :billingAccountIds) AND MSISDN__c != null];
            for(Asset ass: assets)
            {
                if (ass.Account.ParentId == null || !billingAccountIds.contains(ass.Account.Id))
                {
                    List<Asset> assetsAcc = assetsNoLineNumberByAcc.get(ass.Account.Id);
                    if (assetsAcc == null)
                    {
                        assetsAcc = new List<Asset>();
                    }
                    assetsAcc.add(ass);
                    assetsNoLineNumberByAcc.put(ass.Account.Id, assetsAcc);
                    
                    if (ass.MSISDN__c != NULL) 
                    {
                        assetsAcc = assetsWithLineNumberByAcc.get(ass.Account.Id);
                        if (assetsAcc == null)
                        {
                            assetsAcc = new List<Asset>();
                        }
                        assetsAcc.add(ass);
                        assetsWithLineNumberByAcc.put(ass.Account.Id, assetsAcc);
                    }
                }
                else
                {
                    if (ass.MSISDN__c != NULL) 
                    {
                        List<Asset> assetsAcc = assetsWithLineNumberByBillingAcc.get(ass.Account.Id);
                        if(assetsAcc == null)
                        {
                            assetsAcc = new List<Asset>();
                        }
                        assetsAcc.add(ass);
                        assetsWithLineNumberByBillingAcc.put(ass.Account.Id, assetsAcc);
                    }
                }
            }
        }
        
        List<Map<String, Object>>  returnList = new List<Map<String,Object>>();
        
        List<Map<String, Object>>  activeClientes = new List<Map<String,Object>>();
        List<Map<String, Object>>  inActiveClientes = new List<Map<String,Object>>();
        List<Map<String, Object>> contactsWhithOutAccounts = new List<Map<String, Object>>();
        List<Id> unfinishedAccountsContactIds = new List<Id>();
        
        Map<String, Object> tempMap;
        for (Account account : accounts)
        {
            if (!queryingAccounts || assetsNoLineNumberByAcc.containsKey(account.Id))
            {
                tempMap = CreateCollectionNode(account.Id, account.Name, account.AccountIntegrationId__c, account.vlocity_cmt__PrimaryContactId__c,
                account.Phone, account.vlocity_cmt__PrimaryContactId__r.Name, account.vlocity_cmt__PrimaryContactId__r.DocumentType__c,
                account.vlocity_cmt__PrimaryContactId__r.DocumentNumber__c, account.vlocity_cmt__PrimaryContactId__r.Email,
                account.vlocity_cmt__PrimaryContactId__r.Last_Modified_Email_Date__c);
                if (parentAccountIdToBillingAccountMap.containsKey(account.Id)) 
                {
                    List<Object> billingAccountsList = new List<Object>();
                    for (Account billingAccount : parentAccountIdToBillingAccountMap.get(account.Id)) 
                    {
                        Map<String, Object> billingAccountDataMap = new Map<String, Object>();
                        billingAccountDataMap.put('BillingAccountId', billingAccount.Id);
                        billingAccountDataMap.put('BillingAccountName', billingAccount.Name);
                        billingAccountDataMap.put('LineasBillingAccount', assetsWithLineNumberByBillingAcc.get(billingAccount.Id));
                        billingAccountsList.add(billingAccountDataMap);
                    }
                    tempMap.put('BillingAccounts', billingAccountsList);
                }
            tempMap.put('Lineas', assetsWithLineNumberByAcc.get(account.Id));
            
            if (String.isBlank(account.BillingStreet) == true && String.isBlank(account.BillingCity) == true && String.isBlank(account.BillingState) == true && String.isBlank(account.BillingPostalCode) == true)
            {
                unfinishedAccountsContactIds.add(account.vlocity_cmt__PrimaryContactId__c);
            }
            else
            {
                if(account.vlocity_cmt__Active__c == 'Yes')
                    activeClientes.add(tempMap);
                else
                    inActiveClientes.add(tempMap);
            }
        }
        else
        {
            unfinishedAccountsContactIds.add(account.vlocity_cmt__PrimaryContactId__c);}
        }
        system.debug('Active Clients'+activeClientes);
        system.debug('InActive Clients'+InActiveClientes);
        
        tempMap = new Map<String, Object>();
        tempMap.put('activeClientes', activeClientes);
        tempMap.put('inActiveClientes', inActiveClientes);
        if (String.isBlank(phone))
        {
            contactsWhithOutAccounts = GetContactsWhithOutAccounts(contactFirstName, contactLastName, phone, accountName, documentType,
            documentNumber, accountNumber, email, unfinishedAccountsContactIds);
            system.debug('Contacts'+contactsWhithOutAccounts);
            tempMap.put('contactsWhithOutAccounts', contactsWhithOutAccounts);
        }
        tempMap.put('AplicationId',AppId);
        returnList.add(tempMap);
        //outMap.put('options', returnList);
        Integer clientsCount = activeClientes.size() + inActiveClientes.size() + contactsWhithOutAccounts.size();
        outMap.put('Clients', returnList);
        outMap.put('ClientsSearchCount', clientsCount);
        outMap.put('validateSearch',validateSearch);
        
        //INICIO PFTA-10461
        if(String.isNotBlank(documentNumber) && String.isNotBlank(documentType)){
	        outMap.put('isInBlacklist',taClientSearchController.CheckClientInBlackList('',documentNumber,documentType));
	    }
	    //FIN PFTA-10461
	    
        System.debug('Out Map: ' + JSON.serialize(outMap));
    }
    
    List<Map<String, Object>> GetContactsWhithOutAccounts(String contactFirstName, String contactLastName, String phone, String accountName, String documentType,
    String documentNumber, String accountNumber, String email, List<Id>unfinishedAccounts)
    {
        system.debug('Unfinished Accounts: ' + unfinishedAccounts);
        List<Map<String, Object>>  contactsWhithOutAccounts = new List<Map<String,Object>>();
        
        String query = 'SELECT Id, DocumentType__c, DocumentNumber__c, Email, Last_Modified_Email_Date__c, Name FROM Contact WHERE Id not in (select vlocity_cmt__PrimaryContactId__c from Account)';
        
        if (String.isNotBlank(documentType))
        {
            query += ' AND DocumentType__c like \'%' + documentType + '%\'';
        }       
        if (String.isNotBlank(documentNumber))
        {
            query += ' AND DocumentNumber__c like \'%' + documentNumber + '%\'';
        }       
        if((String.isBlank(documentType) && String.isBlank(documentNumber)) || (String.isNotBlank(documentType) && String.isBlank(documentNumber)) )
        {
            if (String.isNotBlank(contactFirstName))
            {
                query += ' AND FirstName like \'%' + contactFirstName + '%\'';
            }           
            if (String.isNotBlank(contactLastName))
            {
                query += ' AND LastName like \'%' + contactLastName + '%\'';
            }           
            if (String.isNotBlank(email))
            {
                query += ' AND Email like \'%' + email + '%\'';
            }
        }
        System.debug('Print queryUnion on Contact without account');
        System.debug(query);
        List<Contact> contacts = Database.query(query);
        Map<String, Object> tempMap;
        for (Contact contact : contacts)
        {
            tempMap = CreateCollectionNode(null, null, null, contact.Id, null, contact.Name, contact.DocumentType__c, contact.DocumentNumber__c,
            contact.Email,contact.Last_Modified_Email_Date__c);
            tempMap.put('Lineas', null);
            contactsWhithOutAccounts.add(tempMap);
        }
        String queryUnion = 'SELECT Id, DocumentType__c, DocumentNumber__c, Email, Last_Modified_Email_Date__c, Name FROM Contact WHERE Id IN :unfinishedAccounts';
        if (String.isNotBlank(documentType))
        {
            queryUnion += ' AND DocumentType__c like \'%' + documentType + '%\'';
        }
        if (String.isNotBlank(documentNumber))
        {
            queryUnion += ' AND DocumentNumber__c like \'%' + documentNumber + '%\'';
        }
        if((String.isBlank(documentType) && String.isBlank(documentNumber)) || (String.isNotBlank(documentType) && String.isBlank(documentNumber)) )
        {
            if (String.isNotBlank(contactFirstName))
            {
                queryUnion += ' AND FirstName like \'%' + contactFirstName + '%\'';
            }
            if (String.isNotBlank(contactLastName))
            {
                queryUnion += ' AND LastName like \'%' + contactLastName + '%\'';
            }
            if (String.isNotBlank(email))
            {
                queryUnion += ' AND Email like \'%' + email + '%\'';
            }
        }
        System.debug('Print queryUnion on Contact without account unfinishedAccounts');
        System.debug(queryUnion);
        List<Contact> contactsUnion = Database.query(queryUnion);
        Map<String, Object> tempMapUnion;
        for (Contact contactUnion : contactsUnion)
        {
            tempMapUnion = CreateCollectionNode(null, null, null, contactUnion.Id, null, contactUnion.Name, contactUnion.DocumentType__c, contactUnion.DocumentNumber__c,
            contactUnion.Email,contactUnion.Last_Modified_Email_Date__c);
            tempMapUnion.put('Lineas', null);
            contactsWhithOutAccounts.add(tempMapUnion);
        }
        return contactsWhithOutAccounts;
    }
    
    Map<String, Object> CreateCollectionNode(String accountId, String accountName, String accountNumber, String primaryContactId,
    String phone, String primaryContactName, String documentType, String documentNumber, String email,
    Date primaryContactLastModifiedEmailDate)
    {
        
        Date twoYearsAgo = Date.today().addYears(-2);
        Boolean eMailValid = twoYearsAgo < primaryContactLastModifiedEmailDate;
        
        Map<String, Object> tempMap = new Map<String, Object>();
        tempMap.put('AccountId', accountId);
        tempMap.put('AccountName', accountName);
        tempMap.put('AccountNumber', accountNumber);
        tempMap.put('PrimaryContactId', primaryContactId) ;
        tempMap.put('Phone', phone);
        tempMap.put('PrimaryContactName', primaryContactName) ;
        tempMap.put('DocumentType', documentType);
        tempMap.put('DocumentNumber', documentNumber);
        tempMap.put('Email', email);
        tempMap.put('ValidEmail', eMailValid);
        
        return tempMap;
    }
    
    void GetNoNominatedLines(Map<String,Object> inputMap, Map<String, Object> outMap, Map<String,Object> options)
    {
        try
        {
            System.debug('GetNoNominatedLines');
            String phone = (String)options.get('PhoneNumber');
            String userAccountId = (String)options.get('userAccountId');
            System.debug('userAccountId:' + userAccountId);
            outMap.put('assetId', null);
            outMap.put('OriginAccountId', '');
            outMap.put('originAccountName', '');
            outMap.put('SearchLineMessage', '' );
            if (String.isNotBlank(phone))
            {
                    List<Asset> lineas = [SELECT Id, Name, MSISDN__c, Account.Id, Account.Name, Account.UnnamedCustomer__c FROM Asset WHERE MSISDN__c = :phone];
                    if (lineas.size() > 0 )
                    {//Existe linea
                        Asset linea = lineas[0];
                        if (linea.Account.UnnamedCustomer__c)
                        {//Linea No Nominada
                            Account userAccount = [SELECT Id, Name, vlocity_cmt__PrimaryContactId__r.DocumentType__c FROM Account WHERE Id =: userAccountId];
                            outMap.put('assetId', linea.Id);
                            outMap.put('OriginAccountId', linea.Account.Id);
                            outMap.put('originAccountName', linea.Account.Name);
                            outMap.put('SearchLineMessage', 'Se va a nomimar la línea ' + phone + ' para el cliente ' + userAccount.Name);
                            if (userAccount.vlocity_cmt__PrimaryContactId__r.DocumentType__c != 'PAS') 
                            {
                                outMap.put('SearchLineMessage', 'Se va a nomimar la línea ' + phone + ' para el cliente ' + userAccount.Name);
                            }
                            else
                            {
                                outMap.put('SearchLineMessage', 'La línea no se puede nominar. Por favor comuníquese al *111  o preséntese en una oficina');
                                outMap.put('SearchLineReason', 'Cliente Extranjero');
                            }
                        }
                        else
                        {//Linea ya fue Nominada
                            outMap.put('SearchLineMessage', 'La línea no se puede nominar. Por favor comuníquese al *111  o preséntese en una oficina');
                            outMap.put('SearchLineReason', 'Linea ya fue Nominada');
                        }
                    }
                    else
                    {//No existe linea
                        outMap.put('SearchLineMessage', 'La línea no se puede nominar. Por favor comuníquese al *111  o preséntese en una oficina');
                        outMap.put('SearchLineReason', 'Linea Inexistente');
                    }//end if
            }//end if
        }
        catch(Exception e)
        {
            System.debug('Exception Msg: ' + e.getMessage());
            System.debug('Exception Cause: ' + e.getCause());
            System.debug('Exception Stack Trace: ' + e.getStackTraceString());
        }
    }//end GetNoNominatedLine
}