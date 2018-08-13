public class AccountTriggers {
    
    private static Id consumerRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Consumer' AND SobjectType = 'Account' LIMIT 1].Id;

    public static void calculateSegments(){
        //Identify updated accounts
        List<Account> accUpdated = new List<Account>();
        
        if(Trigger.isInsert){
            accUpdated = Trigger.New;
        }
        else if(Trigger.isUpdate){
                        
            Map<Id, Account> oldMap = (Map<Id,Account>)Trigger.OldMap;
            Account accOld;
            
            for(Account accNew : (List<Account>)Trigger.New){
                accOld = oldMap.get(accNew.Id);
                if( 
                   //es club member y cambio el segmento 
                   (accNew.ClubMember__c && (accOld.SegmentLevel1__c != accNew.SegmentLevel1__c ||
                   accOld.SegmentLevel2__c != accNew.SegmentLevel2__c))
                  ||
                   //se convirtio en club member
                   (accNew.ClubMember__c == true )){
                    accUpdated.add(accNew);
                }else if(accNew.ClubMember__c == false){
                    accNew.PersonalClubCategory__c = null;
                    
                }
            }
        }
    
        //Query for custom settings
        List<Segments__c> segmentSettings = Segments__c.getAll().Values();
        for(Account acc : accUpdated){
            for(Segments__c settings : segmentSettings){
                if(acc.SegmentLevel1__c == settings.SegmentLevel1__c &&
                   acc.SegmentLevel2__c == settings.SegmentLevel2__c){
                       
                    if(acc.ClubMember__c){
                        acc.PersonalClubCategory__c = settings.ClubPersonalCategory__c;
                    }else{
                        acc.PersonalClubCategory__c = null;
                    }
                       
                }
            }
        }
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to check that if a consumer account is created, it is the only one for the specified contact.
     */
    public static void checkUniqueConsumerAccount() {
        Map<Id, Account> mapContactIdtoConsumerAccount = new Map<Id, Account>();
        Set<Id> setContactIds = new Set<Id>();

        for (Account acc : (List<Account>)Trigger.New) {
            if (acc.RecordTypeId == consumerRecordTypeId) {
                if (acc.vlocity_cmt__PrimaryContactId__c != null) {
                    setContactIds.add(acc.vlocity_cmt__PrimaryContactId__c);
                    mapContactIdtoConsumerAccount.put(acc.vlocity_cmt__PrimaryContactId__c, acc);
                }
            }
        }

        for (Account account : [SELECT Id, RecordTypeId, vlocity_cmt__PrimaryContactId__c
                                FROM Account
                                WHERE vlocity_cmt__PrimaryContactId__c IN :setContactIds]) {
            if (account.RecordTypeId == consumerRecordTypeId) {
                Account accountToCheck = mapContactIdtoConsumerAccount.get(account.vlocity_cmt__PrimaryContactId__c);
                if (account.Id != accountToCheck.Id)
                    accountToCheck.addError(Label.ConsumerAccountNotUniqueError);
            }
        }
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to set the AccountIntegrationId field of new accounts.
     */
    public static void setAccountIntegrationId() {
        System.debug('Set Account Integration Id');
        List<Account> customerAccountsInserted = new List<Account>();
        List<Account> billingAccountsInserted = new List<Account>();
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Billing' AND SobjectType = 'Account' LIMIT 1].Id;
        Id businessRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business' AND SobjectType = 'Account' LIMIT 1].Id;
        
        System.debug('Trigger.New: ' + Trigger.New);

        for (Account acc : (List<Account>)Trigger.New) {
            System.debug('ACC ID: ' + acc.Id);
            if (acc.RecordTypeId == consumerRecordTypeId || acc.RecordTypeId == businessRecordTypeId)
                customerAccountsInserted.add(acc);
            else if (acc.RecordTypeId == billingRecordTypeId && acc.ParentId != null)
                billingAccountsInserted.add(acc);
        }

        if (!customerAccountsInserted.isEmpty()) {
            system.debug('customerAccountsInserted.isEmpty() ');
            List<Account> lastCustomerAccounts = [
                    SELECT Id, CustomerIntegrationId__c
                    FROM Account
                    WHERE (RecordTypeId =: consumerRecordTypeId OR RecordTypeId =: businessRecordTypeId)
                        AND CustomerIntegrationId__c != null
                    ORDER BY CustomerIntegrationId__c DESC
                    LIMIT 1];

            system.debug('lastCustomerAccounts = '+lastCustomerAccounts);
            Decimal customerIntegrationId = Decimal.valueOf('10000000000');
            if (!lastCustomerAccounts.isEmpty() && lastCustomerAccounts.get(0).CustomerIntegrationId__c > customerIntegrationId)
                customerIntegrationId = lastCustomerAccounts.get(0).CustomerIntegrationId__c + 1;
            	system.debug('customerIntegrationId = '+customerIntegrationId);

            for (Account account : customerAccountsInserted) {
                customerIntegrationId++;
                account.CustomerIntegrationId__c = customerIntegrationId;
                account.BillingIntegrationId__c = Decimal.valueOf('10001');
                system.debug('account.CustomerIntegrationId__c = '+account.CustomerIntegrationId__c);
                System.debug('AccountIntegrationId__c: ' + account.AccountIntegrationId__c);
            }
        }
        System.debug('billingAccountsInserted: ' + billingAccountsInserted);
        if (!billingAccountsInserted.isEmpty()) {
            Map<Id, List<Account>> mapParentIdToBillingAccountList = new Map<Id, List<Account>>();
            List<Account> billingAccounts = [
                    SELECT Id, ParentId, BillingIntegrationId__c
                    FROM Account
                    WHERE RecordTypeId =: billingRecordTypeId
                        AND BillingIntegrationId__c != null];

            for (Account account : billingAccounts) {
                if (!mapParentIdToBillingAccountList.containsKey(account.ParentId))
                    mapParentIdToBillingAccountList.put(account.ParentId, new List<Account>());

                mapParentIdToBillingAccountList.get(account.ParentId).add(account);
            }

            for (Account account : billingAccountsInserted) {
                Decimal billingIntegrationId = getLastBillingIntegrationIdFromList(mapParentIdToBillingAccountList.get(account.ParentId));
                billingIntegrationId++;
                account.BillingIntegrationId__c = billingIntegrationId;
                System.debug('billingIntegrationId: ' + account.BillingIntegrationId__c);
            }
        }
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to call the integration services on Account creation.
     */
    public static void callIntegrationServices() {
        System.debug('Call Integration Services');
        Set<Id> customerAccountsInsertedIds = new Set<Id>();
        Set<Id> billingAccountsInsertedIds = new Set<Id>();
        Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Billing' AND SobjectType = 'Account' LIMIT 1].Id;
        Id businessRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Business' AND SobjectType = 'Account' LIMIT 1].Id;

        for (Account acc : (List<Account>) Trigger.New) {
            if (acc.RecordTypeId == consumerRecordTypeId || acc.RecordTypeId == businessRecordTypeId)
                customerAccountsInsertedIds.add(acc.Id);
            else if (acc.RecordTypeId == billingRecordTypeId && acc.ParentId != null)
                billingAccountsInsertedIds.add(acc.Id);
        }
        
        if (!customerAccountsInsertedIds.isEmpty()) {
            callFutureIPS202(customerAccountsInsertedIds);
        }

        if (!billingAccountsInsertedIds.isEmpty()) {
            callFutureIPS015(billingAccountsInsertedIds);
        }
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Future method that will call the Integration Procedure responsable for the Customer Creation.
     */
    @Future(Callout = true)
    public static void callFutureIPS202(Set<Id> customerAccountsInsertedIds) {
        System.debug('Calling IP S202');
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> customerAccountsInserted = [
                SELECT Id, CustomerIntegrationId__c, Type, ParentId, DocumentType__c, DocumentNumber__c, Phone, Fax,
                        vlocity_cmt__PrimaryContactId__r.Title, vlocity_cmt__PrimaryContactId__r.FirstName, vlocity_cmt__PrimaryContactId__r.LastName,
                        vlocity_cmt__PrimaryContactId__r.Gender__c, vlocity_cmt__PrimaryContactId__r.Birthdate, vlocity_cmt__PrimaryContactId__r.Phone,
                        vlocity_cmt__PrimaryContactId__r.MobilePhone, vlocity_cmt__PrimaryContactId__r.Fax, vlocity_cmt__PrimaryContactId__r.Email
                FROM Account
                WHERE Id IN :customerAccountsInsertedIds
        ];

        for (Account account : customerAccountsInserted) {
            String body = IntegrationUtils.createBodyCustomerCreation(account);
            System.debug('Body: ' + body);
            //options.put('body', body);
            try {
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S202', input, output, options);
                Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
                if (!response.isEmpty()) {
                    List<Object> listaDatosAdicionales = (List<Object>) response.get('listaDatosAdicionales');
                    Map<String, Object> datosAdicionalesNode = (Map<String, Object>) listaDatosAdicionales[0];
                    String nombreParametro = (String) datosAdicionalesNode.get('nombreParametro');
                    String valorParametro = (String) datosAdicionalesNode.get('valorParametro');
                    System.debug('Nombre Parametro: ' + nombreParametro);
                    System.debug('Valor Parametro: ' + valorParametro);
                }
            } catch (Exception e) {
                System.debug('Account Trigger:callFutureIPS202 -> exception: ' + e);
            }
        }
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Future method that will call the Integration Procedure responsable for the Billing Account Creation.
     */
    @Future(Callout = true)
    public static void callFutureIPS015(Set<Id> billingAccountsInsertedIds) {
        System.debug('Calling IP S015');
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> billingAccountsInserted = [
                SELECT Id, AccountIntegrationId__c, Type, ParentId, DocumentType__c, DocumentNumber__c, Phone, Fax,
                        vlocity_cmt__PrimaryContactId__r.Title, vlocity_cmt__PrimaryContactId__r.FirstName, vlocity_cmt__PrimaryContactId__r.LastName,
                        vlocity_cmt__PrimaryContactId__r.Phone, vlocity_cmt__PrimaryContactId__r.MobilePhone, vlocity_cmt__PrimaryContactId__r.Fax,
                        vlocity_cmt__PrimaryContactId__r.Email
                FROM Account
                WHERE Id IN :billingAccountsInsertedIds];
        
        for (Account account : billingAccountsInserted) {
            String body = IntegrationUtils.createBodyBillingAccountCreation(account);
            System.debug('Body: ' + body);
            //options.put('body', body);
            try {
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S015', input, output, options);
                Map<String, Object> response = (Map<String, Object>) output.get('IPResult');
                if (!response.isEmpty()) {
                    String respuesta = (String) response.get('respuesta');
                    System.debug('Respuesta: ' + respuesta);
                }
            }
            catch(Exception e){
                System.debug('Account Trigger:callFutureIPS015 -> exception: ' + e);
            }
        }
    }

    /**
     * @Author: Lucas Ramos Oromi
     * @Description: Method to get the last BillingIntegrationId from a List of Accounts.
     * @param: accountList
     */
    private static Decimal getLastBillingIntegrationIdFromList(List<Account> accountList) {
        Decimal billingIntegrationId = Decimal.valueOf('10001');
        if (accountList != null) {
            for (Account account : accountList) {
                if (account.BillingIntegrationId__c != null && account.BillingIntegrationId__c > billingIntegrationId)
                    billingIntegrationId = account.BillingIntegrationId__c;
            }
        }
        return billingIntegrationId;
    }

    /**
     * @Author: Julia Carranza
     * @Description: Method to send a Text Message after Club Member Cancellation.
     */
    //NOT USED AT THE MOMENT.
    /*public static void sendSMSAfterCPCancellation() {

        //VALIDAR A.CONTACTPREFERENCE CONTAINS SMS
        //Account Set Ids identifying which of them are not part of ClubPersonal anymore.
        Set<Id> setAccountId = new Set<Id>();
        Map<Id, Account> accountsOldMap = (Map<Id, Account>)Trigger.OldMap;
        List<Account> accounts = new List<Account>();
        for(Account accountNew : (List<Account>)Trigger.new){
            if(accountNew.ClubMember__c == false && accountsOldMap.get(accountNew.Id).ClubMember__c == true){
                accounts.add(accountNew);
                setAccountId.add(accountNew.Id);
            }
        }

        Map<Id, List<Case>> accountIdToCasesMap = new Map<Id, List<Case>>();
        List<Case> cList = [SELECT Id, Subject, Type, SubType__c, Status, AccountId, ClosedDate, Description FROM Case 
                            WHERE AccountId IN :setAccountId 
                            AND Subject = 'Baja Club Personal Completo'
                            AND Type = 'APP'
                            AND SubType__c = 'Club Personal'
                            AND Status = 'Closed'];

        for (Case c : cList) {
            Id accId = c.AccountId;
            if(accId != Null){
                List<Case> listCases = accountIdToCasesMap.get(accId);
                if(listCases == null){
                    listCases = new List<Case>();
                }
                listCases.add(c);
                accountIdToCasesMap.put(accId, listCases);
            }
        }

        for (Account a : accounts){
            String multiPicklist = a.vlocity_cmt__ContactPreferences__c;
            if(multiPicklist.contains('SMS')){

                List<Case> listCases = accountIdToCasesMap.get(a.Id);
                Datetime closedDate;
                Case currentCase = new Case();
                for (Case c : listCases) {
                    if(closedDate == Null){
                        closedDate = c.ClosedDate;
                        currentCase = c;
                    }
                    else if(c.ClosedDate > closedDate){
                        closedDate = c.ClosedDate;
                        currentCase = c;
                    }
                }

                String cellnumber = a.Phone;
                String text = System.Label.SMSCPCancellation;
                String points = String.valueOf(a.PersonalClubPoints__c);
                String description = currentCase.Description;
                String textComplete = text.replace('$puntos$', points) + ' ' + description;
                String body = '{"body": {"request": {"Target": {"User": {"Celnumber": "'+ cellnumber +'"}}},"communicationText": "'+ textComplete +'"}}';

                System.debug('textComplete: ' + textComplete);

                Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(body);
                Map<String, Object> output = new Map<String, Object>();
                Map<String, Object> options2 = new Map<String, Object>();
                vlocity_cmt.IntegrationProcedureService integProcServ = new vlocity_cmt.IntegrationProcedureService();
                integProcServ.invokeMethod('IFS_S159', input, output, options2);

            }  
        }
    }*/

     /**
     * @Author: Julia Carranza
     * @Description: Method to check all the attributes and put the most important in the Attribute field.
     */
    public static void attributesWeighingValidation() {
        //BILLING ACCOUNTS COULD NOT HAVE A RELATED CONTACT WHEN CREATED.

        //Account Set Ids identifying which of them had their attributes changed.
        Map<Id, Account> accountsOldMap = (Map<Id, Account>)Trigger.OldMap;
        //Map<Id, Contact> contactsMap = new Map<Id, Contact>();
        //Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
        //Set<Id> setContactId = new Set<Id>();
        Set<Id> setaccountId = new Set<Id>();

        //Get Primary Contacts Ids.
        /*for(Account a : (List<Account>)Trigger.new){
            setContactId.add(a.vlocity_cmt__PrimaryContactId__c);
        }*/

        //Map(Contact Id - Contact).
        /*List<Contact> primaryContacts = [SELECT Id, Attribute__c, Attributes__c FROM Contact WHERE Id = :setContactId];
        for (Contact c : primaryContacts) {
            contactsMap.put(c.Id, c);      
        }*/

        //Map Account Id - Primary Contact.
        /*for(Account a : (List<Account>)Trigger.new){
            Contact currentContact = contactsMap.get(a.vlocity_cmt__PrimaryContactId__c);
            accountToContactMap.put(a.id, currentContact);
        }*/

        List<AttributesWeighing__c> awList = [SELECT Attribute__c, Object__c, Weighing__c FROM AttributesWeighing__c WHERE Object__c = 'Account'];

        //INSERT
        if(Trigger.isInsert){
            for(Account a : (List<Account>)Trigger.new){
                /*Contact primaryContact = New Contact();
                if(a.vlocity_cmt__PrimaryContactId__c != Null){
                    primaryContact = accountToContactMap.get(a.Id);
                    //Validates if the Contact Attribute is not Null and if its not the same as the Account Attribute.
                    if(primaryContact.Attribute__c != Null && primaryContact.Attribute__c != a.Attribute__c){
                        a.Attribute__c = primaryContact.Attribute__c;
                    }
                } else {*/
                    //Validates all the Attributes in the Account and looks for the one with more Weighing to apply it on the Attribute field.
                if(a.Attributes__c != Null){
                    Set<String> currentAttributes = new Set<String>(a.Attributes__c.split(';'));
                    Decimal currentWeighing = 0;
                    String currentAttribute = '';
                    for(AttributesWeighing__c aw : awList){
                        if(currentAttributes.contains(aw.Attribute__c)){
                            if(aw.Weighing__c > currentWeighing){
                                currentWeighing = aw.Weighing__c;
                                currentAttribute = aw.Attribute__c;
                            }
                        } 
                    }
                    a.Attribute__c = currentAttribute;
                }
            }
        }
        //UPDATE
        if(Trigger.isUpdate){
            for(Account accountNew : (List<Account>)Trigger.new){
                /*Contact primaryContact = new Contact();
                if(accountNew.vlocity_cmt__PrimaryContactId__c != Null){
                    primaryContact = accountToContactMap.get(accountNew.Id);

                    if((accountNew.Attributes__c != accountsOldMap.get(accountNew.Id).Attributes__c)&&(accountNew.Attribute__c != primaryContact.Attribute__c)){
                        setaccountId.add(accountNew.Id);
                    }
                    else if((accountNew.Attributes__c != accountsOldMap.get(accountNew.Id).Attributes__c)&&(primaryContact.Attribute__c)== Null){
                        setaccountId.add(accountNew.Id);
                    }
                    else if(accountNew.Attribute__c != primaryContact.Attribute__c){
                        setaccountId.add(accountNew.Id);
                    }
                } else {*/
                if(accountNew.Attributes__c != accountsOldMap.get(accountNew.Id).Attributes__c){
                    setaccountId.add(accountNew.Id);
                }
            }

            for(Id accountId : setaccountId){
                Account currentAccount = (Account)(Trigger.newMap.get(accountId));
                //Contact primaryContact = new Contact();
                /*if(currentAccount.vlocity_cmt__PrimaryContactId__c != Null){
                    primaryContact = accountToContactMap.get(currentAccount.Id);
                    //Validates if the Contact Attribute is not Null and if its not the same as the Account Attribute.
                    if(primaryContact.Attribute__c != Null && primaryContact.Attribute__c != currentAccount.Attribute__c){
                        currentAccount.Attribute__c = primaryContact.Attribute__c;
                    } 
                    else if ((currentAccount.Attributes__c != accountsOldMap.get(currentAccount.Id).Attributes__c)&&(primaryContact.Attribute__c)== Null){
                        if(currentAccount.Attributes__c == Null){ //If it does not have attributes, the attribute will be Null.
                            currentAccount.Attribute__c = Null;
                        } else {
                            Set<String> currentAttributes = new Set<String>(currentAccount.Attributes__c.split('; '));
                            Decimal currentWeighing = 0;
                            String currentAttribute = '';
                            for(AttributesWeighing__c aw : awList){
                                if(currentAttributes.contains(aw.Attribute__c)){
                                    if(aw.Weighing__c > currentWeighing){
                                        currentWeighing = aw.Weighing__c;
                                        currentAttribute = aw.Attribute__c;
                                    }
                                } 
                            }
                            currentAccount.Attribute__c = currentAttribute;
                        }
                    }
                } else {*/
                //Validates all the Attributes in the Account and looks for the one with more Weighing to apply it on the Attribute field.
                if(currentAccount.Attributes__c == Null){ //If it does not have attributes, the attribute will be Null.
                    currentAccount.Attribute__c = Null;
                } else {
                    Set<String> currentAttributes = new Set<String>(currentAccount.Attributes__c.split(';'));
                    Decimal currentWeighing = 0;
                    String currentAttribute = '';
                    for(AttributesWeighing__c aw : awList){
                        if(currentAttributes.contains(aw.Attribute__c)){
                            if(aw.Weighing__c > currentWeighing){
                                currentWeighing = aw.Weighing__c;
                                currentAttribute = aw.Attribute__c;
                            }
                        } 
                    }
                    currentAccount.Attribute__c = currentAttribute;
                }   
            }
        } 
    }

    /**
     * @Author: Julia Carranza
     * @Description: Method to update the Account Attribute field once the AfterUpdate Trigger from Contact left it empty.
     * Not used at the moment.
     */
    /*public static void updateAttributeAccountField(){
        Map<Id, Account> AccountOldMap = (Map<Id, Account>)Trigger.OldMap;
        Set<Id> setAccountId = new Set<Id>();
        for(Account AccountNew : (List<Account>)Trigger.new){
            if((AccountNew.Attribute__c == Null) && (AccountNew.Attribute__c != AccountOldMap.get(AccountNew.Id).Attribute__c)){
                setAccountId.add(AccountNew.Id);
            }
        }

        List<Account> accountsToUpdate = new List<Account>(); 
        List<AttributesWeighing__c> awList = [SELECT Attribute__c, Object__c, Weighing__c FROM AttributesWeighing__c WHERE Object__c = 'Account'];
        List<Account> aList = [SELECT Id, Attribute__c, Attributes__c FROM Account WHERE Id IN :setAccountId];
        String currentAttribute = '';
        for(Account a : aList){
            if(a.Attributes__c != Null){
                Set<String> currentAttributes = new Set<String>(a.Attributes__c.split(';')); 
                Decimal currentWeighing = 0;
                for(AttributesWeighing__c aw : awList){
                    if(currentAttributes.contains(aw.Attribute__c)){
                        if(aw.Weighing__c > currentWeighing){
                            currentWeighing = aw.Weighing__c;
                            currentAttribute = aw.Attribute__c;
                        }
                    } 
                }
            }
            accountsToUpdate.add(new Account(Id = a.Id, Attribute__c = currentAttribute));
        }
        update accountsToUpdate;
    }*/
}