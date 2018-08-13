/**
 * Created by joaquininurrategui on 10/25/17.
 */

@isTest
public class TestDataFactory {

    public static List<Vlocity_cmt__PricingElement__c> createPricingElement(Integer numPricingElem, Double amount){
        List<Vlocity_cmt__PricingElement__c> listPricingElement = new List<Vlocity_cmt__PricingElement__c>();
        Vlocity_cmt__PricingVariable__c pricingVariable = createPricingVariable();

        for(Integer x = 0; x < numPricingElem; x++){
            listPricingElement.add(new Vlocity_cmt__PricingElement__c(
                                                            vlocity_cmt__Amount__c = amount,
                                                            vlocity_cmt__PricingVariableId__c = pricingVariable.Id
                                                        ));
        }

        insert listPricingElement;

        return listPricingElement;
    }

    public static Vlocity_cmt__PricingVariable__c createPricingVariable(){
        Vlocity_cmt__PricingVariable__c pricingVariable = new Vlocity_cmt__PricingVariable__c();

        pricingVariable.vlocity_cmt__Code__c = '1';

        insert pricingVariable;

        return pricingVariable;
    }

    public static void populatePriceList(String priceListId, Integer numEntries){
        List<vlocity_cmt__PriceListEntry__c> lstPriceListEntry = new List<vlocity_cmt__PriceListEntry__c>();

        List<Vlocity_cmt__PricingElement__c> listPricingElement = createPricingElement(1, 300);
        List<Product2> listProduct = createProduct(1);

        for(Integer x = 0; x<numEntries; x++){
            lstPriceListEntry.add(new vlocity_cmt__PriceListEntry__c(
                                                            vlocity_cmt__PricingElementId__c = listPricingElement[0].Id,
                                                            vlocity_cmt__ProductId__c = listProduct[0].Id,
                                                            vlocity_cmt__PriceListId__c = priceListId));
        }

        insert lstPriceListEntry;
    }

    public static vlocity_cmt__PriceList__c createPriceList(String name){
        //String priceBookId = createPriceBook('TA Price Book').Id;

        vlocity_cmt__PriceList__c taPriceList =
            new vlocity_cmt__PriceList__c(Name=name,
                                                                        vlocity_cmt__Code__c='1',
                                                                        vlocity_cmt__Pricebook2Id__c=Test.getStandardPricebookId());

        insert taPriceList;

        return taPriceList;
    }

    public static vlocity_cmt__PriceList__c createPriceList(String name, Id priceBookId){
        vlocity_cmt__PriceList__c taPriceList =
            new vlocity_cmt__PriceList__c(Name=name,
                                                                        vlocity_cmt__Code__c='1',
                                                                        vlocity_cmt__Pricebook2Id__c=priceBookId);

        insert taPriceList;

        return taPriceList;
    }

    public static Pricebook2 createPriceBook(String name){
        Pricebook2 priceBook = new Pricebook2(Name=name);

        insert priceBook;

        return priceBook;
    }

    public static List<Order> createOrders(Integer numOrders, Account acc) {
        vlocity_cmt__PriceList__c taPriceList = createPriceList('Telecom Price List');
        Id orderRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Order' AND DeveloperName = 'MobilePhoneOrder' LIMIT 1].Id;

        List<Order> orders = new List<Order>();

        for(Integer i=0;i<numOrders;i++) {
            Order o = new Order(Name='TestOrder' + i,
                                                    RecordTypeId = orderRecordTypeForAcc,
                                                    AccountId=acc.Id,
                                                    EffectiveDate=Date.today(),
                                                    Status='Draft',
                                                    Pricebook2Id =Test.getStandardPricebookId(),
                                                    vlocity_cmt__PriceListId__c=taPriceList.Id,
                                                    Delivery_Method__c='Delivery',
                                                    vlocity_cmt__OriginatingChannel__c='Agentes',
                                                    DateTime_Sent_S029__c=Datetime.now());
            orders.add(o);
        }

        insert orders;

        return orders;
    }

    public static List<OrderItem> createOrderItemsWithAsset(Integer numOrders, Order ord, Asset asst){
        List<OrderItem> OIList = new List<OrderItem>();
        List<product2>Prod=createProduct(1);

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id =Test.getStandardPricebookId(),
            Product2Id = prod[0].Id,
            UnitPrice = 10000, IsActive = true
        );

        insert standardPrice;

        for(Integer i=0;i<numOrders;i++) {
            OrderItem oi = new OrderItem(
                OrderId=Ord.id,
                Quantity=decimal.valueof('1'),
                UnitPrice=1,
                PricebookEntryId=standardPrice.id,
                vlocity_cmt__AssetId__c=asst.Id
            );

            OIList.add(oi);
        }

        insert OIList;

        return OIList;
    }

    public static List<OrderItem> createOrderItem(Integer numOrders, Order Ord) {

         List<OrderItem> OIList = new List<OrderItem>();
         List<Product2> prod=createProduct(1);
            PricebookEntry standardPrice = new PricebookEntry(
                        Pricebook2Id =Test.getStandardPricebookId(),
                        Product2Id = prod[0].Id,
                        UnitPrice = 10000, IsActive = true);

                insert standardPrice;
     System.debug(Ord.id);
     for(Integer i=0;i<numOrders;i++) {
            OrderItem oi = new OrderItem(OrderId=Ord.id,Quantity=decimal.valueof('1'),UnitPrice=1,PricebookEntryId=standardPrice.id, Product2Id=Prod[0].Id);

            OIList.add(oi);
        }
        insert OIList;

        return OIList;
    }

    public static List<Contact> createContacts(Integer numContact, Account acc){
        Account testAcc = acc;

        if(acc==null) testAcc = createAccounts(1)[0];

        List<Contact> cts = new List<Contact>();

        for(Integer i=0;i<numContact;i++){
            Contact c = new Contact(
                FirstName='firstName' + i,
                LastName='lastName' + i,
                AccountId=testAcc.Id
            );

            cts.add(c);
        }

        insert cts;
        return cts;
    }

   public static List<Account> createAccounts(Integer numAccts, String recordTypeName) {
        List<Account> accts = new List<Account>();

        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account();

            a.Name='TestAccount' + Math.round(Math.random()*10000);
            a.AccountIntegrationId__c = String.ValueOf(Decimal.valueOf('10000000000')+Datetime.now().millisecond()+i);
            a.CustomerIntegrationId__c = Decimal.valueOf('10000000001')+Datetime.now().millisecond()+i;

            system.debug('AccountIntegrationId__c = '+a.AccountIntegrationId__c);
            system.debug('recordTypeName = '+recordTypeName);

            if(recordTypeName != null)
              a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
               //a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();

            accts.add(a);
        }
        insert accts;

        return accts;
    }

    public static List<vlocity_cmt__PaymentMethod__c> createPaymentMethod(Integer numPayMet, Account acc) {
        Account testAcc = acc;
        List<vlocity_cmt__PaymentMethod__c> paymentMethods = new List<vlocity_cmt__PaymentMethod__c>();

        for(Integer i=0;i<numPayMet;i++) {
            vlocity_cmt__PaymentMethod__c a = new vlocity_cmt__PaymentMethod__c();

            a.vlocity_cmt__CardType__c = 'Master Card';
            a.vlocity_cmt__CardHolderName__c = 'Card Holder Bjorn' + i;
            a.vlocity_cmt__CardNumber__c = '444444444444444' + i;
            a.vlocity_cmt__AccountId__c = testAcc.Id;
            a.vlocity_cmt__IsActive__c = true;
            a.vlocity_cmt__MethodType__c = '2001';
            a.BankEntityName__c = '72';

            paymentMethods.add(a);
        }

        insert paymentMethods;

        return paymentMethods;
    }

    public static List<vlocity_cmt__PaymentAdjustment__c> createPaymentAdjustments(Integer cant, Account acc, Order ord){
        return createPaymentAdjustments(cant, acc, ord, null, 0);
    }

    public static List<vlocity_cmt__PaymentAdjustment__c> createPaymentAdjustments(Integer cant, Account acc, Order ord, Vlocity_cmt__PaymentMethod__c paymMethod, Integer installments){
        List<vlocity_cmt__PaymentAdjustment__c> lstPaymAdj = new List<vlocity_cmt__PaymentAdjustment__c>();

        for(Integer i=0;i<cant;i++) {
            vlocity_cmt__PaymentAdjustment__c paymAdj = new vlocity_cmt__PaymentAdjustment__c();

            paymAdj.Vlocity_cmt__AccountId__c = acc.Id;
            paymAdj.Order__c = ord.Id;
            paymAdj.vlocity_cmt__TotalInstallments__c = installments;

            if(paymMethod != null)
                paymAdj.vlocity_cmt__PaymentMethodId__c = paymMethod.Id;
            else
                paymAdj.vlocity_cmt__PaymentMethodId__c = createPaymentMethod(1, acc)[0].Id;

            lstPaymAdj.add(paymAdj);
        }

        insert lstPaymAdj;
        return lstPaymAdj;
    }

    public static List<Account> createAccounts(Integer numAccts) {
        return createAccounts(numAccts, null);
    }

    public static List<Product2> createProduct(Integer numProd) {
        List<Product2> prods = new List<Product2>();

        for(Integer i=0;i<numProd;i++) {
            Product2 a = new Product2(Name='TestProduct '+i, ProductCode='TestProductCode', Tangible__c = true, vlocity_cmt__Type__c='TestType');
            prods.add(a);
        }

        insert prods;
        system.debug(' prods ====> '+prods);
        return prods;
    }

    public static List<Asset> createAssets(Integer cant, Account acc, String msisdn){
        Product2 prod = createProduct(1)[0];

        List<Asset> assts = new List<Asset>();

        for(Integer i=0;i<cant;i++) {
            Asset a = new Asset(Name='TestAsset' + i, Product2Id=prod.Id, AccountId=acc.Id, MSISDN__c=msisdn);
            assts.add(a);
        }
        insert assts;
        return assts;
    }

    public static List<Asset> createAssets(Integer cant, Account acc){
        Product2 prod = createProduct(1)[0];

        List<Asset> assts = new List<Asset>();

        for(Integer i=0;i<cant;i++) {
            Asset a = new Asset(Name='TestAsset' + i, Product2Id=prod.Id, AccountId=acc.Id);
            assts.add(a);
        }
        insert assts;
        return assts;
    }

    public static List<Asset> createAssets(Integer cant, Product2 prod, Account acc){
        List<Asset> assts = new List<Asset>();

        for(Integer i=0;i<cant;i++) {
            Asset a = new Asset(Name='TestAsset' + i, Product2Id=prod.Id, AccountId=acc.Id);
            assts.add(a);
        }
        insert assts;
        return assts;
    }

    public static Asset createSingleAsset(Product2 prod, Id AccId){
        Asset a = new Asset();
        a.Product2Id = prod.id;
        a.Accountid = AccId;
        a.name = 'TestAsset';
        insert a;
        return a;
    }

    public static List<Asset> createSVAAssets(Id ParentAsset, product2 ProdId, Id AccId, Integer NumAssets){

        List<Asset> newAssets = new List<Asset>();

        for(Integer i=0;i<NumAssets;i++){
            Asset a = new Asset();
            a.name = 'newAsset' + i;
            a.Status = 'Active';
            a.Product2Id = ProdId.id;
            a.vlocity_cmt__ParentItemId__c = ParentAsset;
            a.InstallDate = Date.today();
            a.AccountId = accId;
            newAssets.add(a);

        }
        insert newAssets;
        return newAssets;
    }

    public static String createService(){
                Product2 service = new Product2(Name='Internet', Family='Service Plan');

                insert service;

                return service.Id;
        }

    public static void createContactMotives(Integer cant, String idService){
                List<Contact_Motive__c> motives = new List<Contact_Motive__c>();

                for(Integer x = 0; x<cant; x++){
                        Contact_Motive__c contactMotive = new Contact_Motive__c(
                                Name='ContactMotiveTest '+x, Description__c='Test Description '+x, is_active__c=true,
                                Id_Service__c=idService);

                        motives.add(contactMotive);
                }

                insert motives;
    }

    public static String createContactMotive(boolean isAssociable){
                Contact_Motive__c contactMotive = new Contact_Motive__c(
                        Name='ContactMotiveTest',
                        Description__c='Test Description',
                        Is_Active__c=true,
                        Is_Associable__c=isAssociable);

                insert contactMotive;

                return contactMotive.Id;
    }

    public static List<Case> createCases(Integer cant, String accountId, String assetId, String subject){
            List<Case> cases = new List<Case>();

                for(Integer x = 0; x<cant; x++){
                        Case cse = new Case(
                                Subject='subject'+x,
                                AccountId = accountId,
                                AssetId = assetId);
                        cases.add(cse);
                }

                insert cases;
                return cases;
    }

    public static List<Case> createCases(Integer cant, String accountId, String subject){
            List<Case> cases = new List<Case>();

                for(Integer x = 0; x<cant; x++){
                        Case cse = new Case(
                                Subject='subject'+x,
                                AccountId = accountId);
                        cases.add(cse);
                }

                insert cases;
                return cases;
    }

    public static vlocity_cmt__BusinessSite__c createStoreLocation(String name){
        Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
        // Id idRecordType = [Select Id From RecordType where Name='Punto de venta OC' LIMIT 1].Id;
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
            RecordTypeId = idRecordType,
            Name = name,
            BillingMode__c = 'Fiscal',
            Channel__c = 'Físico',
            Channel_Type__c = 'Oficinas Comerciales',
            Channel_Type_2__c = 'Oficinas Comerciales',
            Channel_Type_3__c = 'Oficinas Comerciales',
            Vlocity_cmt__OrganizationId__c = createAccounts(1)[0].Id
            //Vlocity_cmt__OrganizationId__c = auxAct.Id

        );

        insert storeLocation;

        // storeLocation.Channel__c = 'Físico';
        // storeLocation.Channel_Type__c = 'Oficinas Comerciales';
        // storeLocation.Channel_Type_2__c = 'Oficinas Comerciales';
        // storeLocation.Channel_Type_3__c = 'Oficinas Comerciales';
        // update storeLocation;

        return storeLocation;
    }

    public static vlocity_cmt__BusinessSite__c createStoreLocation(String name, String accountId){
        Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
            RecordTypeId = idRecordType,
            Name = name,
            BillingMode__c = 'Fiscal',
            Channel__c = 'Físico',
            Channel_Type__c = 'Oficinas Comerciales',
            Channel_Type_2__c = 'Oficinas Comerciales',
            Channel_Type_3__c = 'Oficinas Comerciales',
            Vlocity_cmt__OrganizationId__c = accountId
            //Vlocity_cmt__OrganizationId__c = auxAct.Id

        );

        insert storeLocation;
        return storeLocation;
    }

    public static WorkTeam__c createWorkTeam(String name, Vlocity_cmt__BusinessSite__c storeLocation){
        WorkTeam__c wt = new WorkTeam__c(
            Name = name,
            Team_Name__c = 'testWorkTeam',
            Is_Active__c = true
        );

        if(storeLocation != null)
            wt.Work_Place__c = storeLocation.Id;
        else
            wt.Work_Place__c = createStoreLocation('Test').Id;

        insert wt;
        return wt;
    }

    public static WorkTeam__c createWorkTeam(String name){
        WorkTeam__c wt = new WorkTeam__c(
            Name = name,
            Team_Name__c = name,
            Is_Active__c = true
        );
        insert wt;
        return wt;
    }

    public static User createUser(String profile){
        User u;
        try{
            Profile p = [SELECT Id FROM Profile WHERE Name = :profile];
            u = new User(Alias = 'testu', Email='testuser@superhijitus.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='es_AR', ProfileId = p.Id,
            TimeZoneSidKey='America/Argentina/Buenos_Aires', UserName='standarduser@superhijitus.com');
            insert u;
        }
        catch(Exception e){
            System.debug('error: ' + e.getMessage());
            System.debug('errorStackTrace: '+ e.getStackTraceString());
        }

        return u;
    }

    public static Team_Member__c setTeamMember(String name, String usrId, WorkTeam__c workTeam){
        Team_Member__c tm = new Team_Member__c(
            User_Member__c = usrId, UserRoleAPIName__c = 'Call Center', Is_Active__c= true
        );

        if(workTeam != null)
            tm.Work_Team__c = workTeam.Id;
        else
            tm.Work_Team__c = createWorkTeam('Test', null).Id;

        insert tm;
        return tm;
    }

    public static void createExternalBankEntities(){
        List<ExternalBankEntitiesIds__c> lstEbe = new List<ExternalBankEntitiesIds__c>();

        ExternalBankEntitiesIds__c ebe1 = new ExternalBankEntitiesIds__c(
            Name = 'ICBC',
            BankCode__c = '1',
            ParentBankCode__c = null,
            Sequences__c = 1,
            Valid__c = true
        );

        ExternalBankEntitiesIds__c ebe2 = new ExternalBankEntitiesIds__c(
            Name = 'THE ROYAL BANK OF SCOTLAND N.V.',
            BankCode__c = '5',
            ParentBankCode__c = null,
            Sequences__c = 2,
            Valid__c = true
        );

        lstEbe.add(ebe1);
        lstEbe.add(ebe2);

        insert lstEbe;
    }

    public static List<FinancialPromotion__c> createFinancialPromotionsForCreditCard(){
        String idRecordType = Schema.SObjectType.FinancialPromotion__c.getRecordTypeInfosByName().get('Credit Card').getRecordTypeId();

        List<FinancialPromotion__c> lstObjFinProm = new List<FinancialPromotion__c>();

        FinancialPromotion__c objFinProm1 = new FinancialPromotion__c(
            NombrePromocion__c = 'Promo1',
            Interest__c = 1.1137,
            Instalment__c = '11',
            BankEntities__c = '331',
            CreditCards__c = '468',
            PromotionStatus__c = 'Vigente',
            RecordTypeId = idRecordType,
            ChannelPromotion__c = 'Telefónico',
            PaymentMethodPromotion__c = '2001'
        );

        FinancialPromotion__c objFinProm2 = new FinancialPromotion__c(
            NombrePromocion__c = 'Promo2',
            Interest__c = 0,
            Instalment__c = '4',
            BankEntities__c = '299',
            CreditCards__c = '445',
            PromotionStatus__c = 'Vigente',
            RecordTypeId = idRecordType,
            ChannelPromotion__c = 'Telefónico',
            PaymentMethodPromotion__c = '2001'
        );

        lstObjFinProm.add(objFinProm1);
        lstObjFinProm.add(objFinProm2);
        insert lstObjFinProm;
        return lstObjFinProm;
    }

    public static void createFinancialPromotionsCreditCard(){
        createFinancialPromotionsForCreditCard();
    }

    public static void createFinancialPromotionsDPF(){
        String idRecordType = Schema.SObjectType.FinancialPromotion__c.getRecordTypeInfosByName().get('Debit to Next Bill').getRecordTypeId();

        List<FinancialPromotion__c> lstObjFinProm = new List<FinancialPromotion__c>();

        FinancialPromotion__c objFinProm1 = new FinancialPromotion__c(
            NombrePromocion__c = 'DPF Uno',
            Interest__c = 5,
            Instalment__c = '1',
            PromotionStatus__c = 'Vigente',
            RecordTypeId = idRecordType,
            ChannelPromotion__c = 'Telefónico',
            PaymentMethodPromotion__c = '1201'
        );

        FinancialPromotion__c objFinProm2 = new FinancialPromotion__c(
            NombrePromocion__c = 'DPF Dos',
            Interest__c = 7,
            Instalment__c = '2',
            PromotionStatus__c = 'Vigente',
            RecordTypeId = idRecordType,
            ChannelPromotion__c = 'Telefónico',
            PaymentMethodPromotion__c = '1201'
        );

        lstObjFinProm.add(objFinProm1);
        lstObjFinProm.add(objFinProm2);
        insert lstObjFinProm;
    }

    public static void createFinancialPromotions(){
        List<FinancialPromotions__c> lstFinProm = new List<FinancialPromotions__c>();

        FinancialPromotions__c finProm1 = new FinancialPromotions__c(
            Name = 'Promo 1',
            Bank_Code__c = '1',
            Bank_Name__c = 'ICBC',
            CFT__c = '1.3999',
            Creditcard_Name__c = 'MASTERCARD',
            Creditcard_Type__c = '403',
            Installment_Plan__c = '',
            Instalments__c = '1',
            Payment_Method__c = 'Tarjeta'
        );

        FinancialPromotions__c finProm2 = new FinancialPromotions__c(
            Name = 'Promo ',
            Bank_Code__c = '6',
            Bank_Name__c = 'BANCO PATAGONIA S.A',
            CFT__c = '2.9',
            Creditcard_Name__c = 'VISA',
            Creditcard_Type__c = '404',
            Installment_Plan__c = '',
            Instalments__c = '3',
            Payment_Method__c = 'Tarjeta'
        );

        lstFinProm.add(finProm1);
        lstFinProm.add(finProm2);

        insert lstFinProm;
    }

    public static void createPaymentMethodTypes(){
        List<PaymentMethodType__c> pml = new List<PaymentMethodType__c>();

        PaymentMethodType__c pm = new PaymentMethodType__c(
            Name = 'Agentes',
            DebitoProxFactura__c = true,
            Efectivo__c = true,
            Tarjeta__c = true,
            Tarjeta_Debito__c = true,
            PaymentMethodQuantity__c = 3
        );

        PaymentMethodType__c pm1 = new PaymentMethodType__c(
            Name = 'Oficinas Comerciales',
            DebitoProxFactura__c = true,
            Efectivo__c = true,
            Tarjeta__c = true,
            Tarjeta_Debito__c = true,
            PaymentMethodQuantity__c = 3
        );

        PaymentMethodType__c pm2 = new PaymentMethodType__c(
            Name = 'WEB',
            DebitoProxFactura__c = true,
            Efectivo__c = false,
            Tarjeta__c = true,
            Tarjeta_Debito__c = false,
            PaymentMethodQuantity__c = 3
        );

        PaymentMethodType__c pm3 = new PaymentMethodType__c(
            Name = 'Call Center',
            DebitoProxFactura__c = true,
            Efectivo__c = false,
            Tarjeta__c = true,
            Tarjeta_Debito__c = false,
            PaymentMethodQuantity__c = 3
        );

        pml.add(pm);
        pml.add(pm1);
        pml.add(pm2);
        pml.add(pm3);

        insert pml;
    }

    public static void createMessagingConfig(){
            MessagingConfig__c dbe = new MessagingConfig__c();

            dbe.DaysBeforeExpiration__c = 1;
            dbe.Name = 'Default';

            insert dbe;
    }

    public static void createExpectedMessage(){
            SMS_Expected_Response_Type__c exp = new SMS_Expected_Response_Type__c(
                Name='SMS_Expected_Response_Type',
                Ok__c='OK',
                Ko__c='NOK'
            );

            insert exp;
    }

    public static List<Task> createTask(List<Id> WhatId){

            List<Task> TaskList = new List<task>();
            Task T ;
        for(Id WId:WhatId){
            T = new task(
            WhatID = WId,
            Subject='Task',
            Status='New',
            Priority='Normal');
            TaskList.add(T);
        }

            insert TaskList;

            return TaskList;
    }

    public static List<Campaign> createCampaigns(Integer numCampaigns){
        List<Campaign> campaignList = new List<Campaign>();
        for(Integer i = 0; i < numCampaigns ; i++) {
            Campaign cp = new Campaign(Name = 'Test Campaign ' + i, Type = 'Desarrollo',
                                       SubtypeL1__c = 'Fidelización', SubtypeL2__c = 'Club Personal',
                                       Channel_Type__c  = 'OUT', Channel__c  = 'SMS', Destination__c = 'Empresa',
                                       Objetive__c = 'Test Objective', StartDate = Date.today());
            campaignList.add(cp);
        }

        return campaignList;
    }

    /*public static Entitlement CreateEntitlement(){
        Entitlement E = new Entitlement();
        E.Name = 'Test Entitlemnt';
        List<Account> Accts = createAccounts(1);
        E.Account = Accts[0];

    }*/
    /**
     * @Author: Jeisson Rojas (JARN)
     * @Description:
        *Método que se puede utilizar para la llamar los valores de las listas de selección un ejemplo de como usarlo:
            *List<SObject> lstPicklist = TestDataFactory.Picklist('Hogar',Account.SegmentLevel1__c);
        *Method that can be used to call the values ​​of the selection lists an example of how to use it:
            *List<SObject> lstPicklist = TestDataFactory.Picklist('Hogar',Account.SegmentLevel1__c);
    **/
    public static String valPicklist(String strValue,SObjectField strObjectFiel)
    {
        String strValuePick;
        DescribeFieldResult describe = strObjectFiel.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        for(integer i = 0; i < availableValues.size(); i++)
        {
            if(strValue == availableValues[i].getLabel())
            {
                strValuePick = availableValues[i].getLabel();
            }
        }
        return strValuePick;
    }
  //(JARN)
    public static void createSegmentsConfig()
    {
        Segments__c objSegment1 = new Segments__c();
        objSegment1.Name = 'Black';
        objSegment1.segmentLevel1__c = 'Hogar';
        objSegment1.segmentLevel2__c = '1 TV';
        List<Segments__c> lstSegments = new List<Segments__c>();
        lstSegments.add(objSegment1);
        Segments__c objSegment2 = new Segments__c();
        objSegment2.Name = 'Premium';
        objSegment2.segmentLevel1__c = 'Sólo Móvil';
        objSegment2.segmentLevel2__c = 'Black';
        lstSegments.add(objSegment2);
        insert lstSegments;
    }
    //JARN
  public static Location__c createLocations()
    {
        Location__c objLocation = new Location__c();
        objLocation.Postal_Code__c='1643';
        objLocation.Region__c='AMBA';
        objLocation.StateCode__c='B';
        objLocation.StateName__c='BUENOS AIRES';
        objLocation.Status__c=true;
        objLocation.LOCALIDADMU__c='BECCAR';
        objLocation.LocationCode__c='B1603';
        objLocation.Municipality__c='SAN ISIDRO';
        objLocation.Name='BECCAR';
        objLocation.DEPARTAMENTOMU__c='SAN ISIDRO';
        objLocation.DepartmentCode__c='BJR';
        objLocation.CountryCode__c='AR';
        objLocation.CountryName__c='ARGENTINA';
    insert objLocation;
    return objLocation;
    }
  //JARN
  public static Street__c createStreet (String strIdLocation)
  {
    Street__c objStreet = new Street__c();
    objStreet.IsActive__c=true;
    if(strIdLocation != null || strIdLocation != '')
    {
      objStreet.Location__c=strIdLocation;
    }
    objStreet.Name='MENDOZA BP S ISIDRO CATED';
    objStreet.Postal_Code__c='1643';
    objStreet.Range_From__c=1323.0;
    objStreet.Range_To__c=1323.0;
    objStreet.StreetCode__c='B16030016';
    Insert objStreet;
    return objStreet;
  }
  //Jarn
  public static List<Product2> createProduct2(Integer numProd) {
      List<Product2> prods = new List<Product2>();

      for(Integer i=0;i<numProd;i++) {
          Product2 a = new Product2(Name='TestProduct '+i, ProductCode='FAN_ENV_000', Tangible__c = true, vlocity_cmt__Type__c='TestType', IsActive = true);
          prods.add(a);
      }

      insert prods;
      system.debug(' prods ====> '+prods);
      return prods;
  }
  //Jarn
  public static List<OrderItem> createOrderItemgetDeliveryMethod(Integer numOrders, Order Ord) {

       List<OrderItem> OIList = new List<OrderItem>();
       List<Product2> prod = createProduct2(1);
          PricebookEntry standardPrice = new PricebookEntry(
                      Pricebook2Id =Test.getStandardPricebookId(),
                      Product2Id = prod[0].Id,
                      UnitPrice = 10000, IsActive = true);

              insert standardPrice;
   System.debug(Ord.id);
   for(Integer i=0;i<numOrders;i++) {
          OrderItem oi = new OrderItem(OrderId=Ord.id,Quantity=decimal.valueof('1'),UnitPrice=1,PricebookEntryId=standardPrice.id, vlocity_cmt__Product2Id__c=Prod[0].Id);

          OIList.add(oi);
      }
      insert OIList;

      return OIList;
  }
  public static OrderItem CreateOrderItemParent (String orderId, String productId)
  {
    PricebookEntry standardPrice1 = [Select id From PricebookEntry Where Product2Id =: productId];
    OrderItem ord = [Select Id From OrderItem Where OrderId =: orderId LIMIT 1];
    OrderItem objOrderItem = new OrderItem();
    objOrderItem.OrderId = orderId;
    objOrderItem.Quantity = decimal.valueof('1');
    objOrderItem.UnitPrice = 1;
    objOrderItem.PricebookEntryId = standardPrice1.Id;
    insert objOrderItem;
    objOrderItem.vlocity_cmt__ParentItemId__c = ord.Id;
    update objOrderItem;
    return objOrderItem;
  }

    public static List<vlocity_cmt__VlocityTrackingEntry__c> createTrackingEntry(Integer numTrack) {
        List<vlocity_cmt__VlocityTrackingEntry__c> TrackingEntry = new List<vlocity_cmt__VlocityTrackingEntry__c>();

        for(Integer i=0;i<numTrack;i++) {

            vlocity_cmt__VlocityTrackingEntry__c cp = new vlocity_cmt__VlocityTrackingEntry__c(Name = 'Test Campaign ' + i);
            system.debug('vlocity tracking entry = '+cp);
            TrackingEntry.add(cp);
        }

        insert TrackingEntry;

        return TrackingEntry;
    }

    public static List<PlazoEsperaPickup__c> PlazoEsperaPickup (Integer IntCantidadDias, string strName)
    {
      PlazoEsperaPickup__c objPlazoPickup = new PlazoEsperaPickup__c();
      List<PlazoEsperaPickup__c> lstPlazoPickup = new List<PlazoEsperaPickup__c>();
        objPlazoPickup.DiasDeEspera__c = IntCantidadDias;
        objPlazoPickup.Name = strName;
        lstPlazoPickup.add(objPlazoPickup);
      Insert lstPlazoPickup;

      return lstPlazoPickup;
    }

    public static CrossObject__c CrossObject (String strId, string strObjeto)
    {
      RecordType IdRecodType = [SELECT Id FROM RecordType WHERE DeveloperName = 'SMSTemplate' LIMIT 1];
      CrossObject__c CO = new CrossObject__c();
      CO.Picklist1__c='Nominacion exitosa';
      CO.RecordTypeId= IdRecodType.Id;
      CO.String1__c = 'Felicidades la linea ya se encuentra a su nombre';
      CO.Order__c = strId;
      insert CO;
      return CO;
    }

    public static List<Transaction_History__c> CreateTransacctionHistory(Set<Id> assetIds, Id accountId, String new_status, String substatus)
    {
        List<Transaction_History__c> listTransactionHistory = new List<Transaction_History__c>();
        for(Id assetId : assetIds)
        {
            Transaction_History__c transactionHistory = new Transaction_History__c();

            transactionHistory.Asset__c = assetId;
            transactionHistory.Account__c = accountId;
            transactionHistory.New_Status__c = new_status;
            transactionHistory.Type__c = substatus;

            listTransactionHistory.add(transactionHistory);
            Insert  transactionHistory;
        }

        return listTransactionHistory;
    }

    public static List<Transaction_History__c> CreateTransactionHistory(Integer transactionsHistoryToCreate,
        Id accountId, Id assetId, String type, String description, String status) {
        List<Transaction_History__c> listTransactionHistory = new List<Transaction_History__c>();

        for (Integer i = 0; i < transactionsHistoryToCreate; i++) {
            Transaction_History__c transactionHistory = new Transaction_History__c();

            transactionHistory.Asset__c = assetId;
            transactionHistory.Account__c = accountId;
            transactionHistory.Type__c = type;
            transactionHistory.Description__c = description;
            transactionHistory.New_Status__c = status;

            listTransactionHistory.add(transactionHistory);
        }

        insert listTransactionHistory;

        return listTransactionHistory;
    }
    public static List<Transaction_History__c> CreateTransactionHistory(Integer transactionsHistoryToCreate, Id accountId, String type, String description, String newStatus, Id recordTypeId)
    {
        List<Transaction_History__c> listTransactionHistory = new List<Transaction_History__c>();

        for (Integer i = 0; i < transactionsHistoryToCreate; i++) {
            Transaction_History__c transactionHistory = new Transaction_History__c();

            transactionHistory.Account__c = accountId;
            transactionHistory.RecordTypeId = recordTypeId;
            transactionHistory.Type__c = type;
            transactionHistory.Description__c = description;
            transactionHistory.New_Status__c = newStatus;

            listTransactionHistory.add(transactionHistory);
        }

        insert listTransactionHistory;

        return listTransactionHistory;
    }
}