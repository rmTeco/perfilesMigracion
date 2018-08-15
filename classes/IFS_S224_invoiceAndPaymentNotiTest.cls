@isTest
public class IFS_S224_invoiceAndPaymentNotiTest {
    static final String K_TIPO_DOCUMENTO_OK = 'DNI';
    static final String K_NMRO_DOCUMENTO_OK = '32987652';
    static final String K_NMRO_LINEA_OK = '1138305305';
    static final String K_ACCOUNT_NAME = 'TestS224Acc';

    private static final String K_MSISDN_OK  = '47774777';
    private static final String K_MSISDN_NOK = '49994999';
    private static final String K_CANAL_OK = 'IVR';
    private static final String K_CANAL_NOK = 'Presencial';
    private static final String K_ORDER_NAME = 'TestOrderS224';
    private static final String K_CATALOGO_NAME = 'IVR';


    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

        Account account = getAccountId ();
        Order order = [SELECT Id FROM Order WHERE AccountId = :account.Id];
        jsonObj.invoiceAndPaymentNotification.LegalInvoiceNumber='A0001-48484848';
        jsonObj.invoiceAndPaymentNotification.SalesOrderId=order.Id; 
        jsonObj.invoiceAndPaymentNotification.Status='Payment succeed';
        jsonObj.invoiceAndPaymentNotification.StatusInvoice='Invoice succeed';

        jsonObj.invoiceAndPaymentNotification.ReasonCode='Reason';
        jsonObj.invoiceAndPaymentNotification.ReasonCodeName='Reason';
        jsonObj.invoiceAndPaymentNotification.TotalInvoiceAmount=0;
        jsonObj.invoiceAndPaymentNotification.LegalInvoiceNumber='';

        System.debug('jsonObj: ' + JSON.serialize(jsonObj));

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure//Sales_CollectionAndBilling_invoiceAndPaymentNotification/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S224_invoiceAndPaymentNotification.getData();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Result resultado = (Result)JSON.deserialize(RestContext.response.responseBody.toString(), Result.class);
        System.assertNotEquals(null, resultado);
        System.assertEquals(0, resultado.resultCode);

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }


    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();

        Account account = getAccountId ();
        Order order = [SELECT Id FROM Order WHERE AccountId = :account.Id];
        jsonObj.invoiceAndPaymentNotification.SalesOrderId=''; 
        jsonObj.invoiceAndPaymentNotification.Status='Payment succeed';
        jsonObj.invoiceAndPaymentNotification.StatusInvoice='';
        jsonObj.invoiceAndPaymentNotification.ReasonCode='';
        jsonObj.invoiceAndPaymentNotification.Comments='';
        jsonObj.invoiceAndPaymentNotification.ReasonCodeName='';
        jsonObj.invoiceAndPaymentNotification.TotalInvoiceAmount=0;
        jsonObj.invoiceAndPaymentNotification.LegalInvoiceNumber='';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure//Sales_CollectionAndBilling_invoiceAndPaymentNotification/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S224_invoiceAndPaymentNotification.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
        List<ErrorClass> lstErrors = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        System.assertNotEquals(null, lstErrors);

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }


    ///////////////// Metodos de Creacion datos de Prueba //////////////////////

    @TestSetup
    private static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        Account account = createAccount();
        //-- Perfiles del usuario --//
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        createWorkTeamMember (workTeam.Id);
        //-- Datos de la prueba
        Pricebook2 priceBook = createPriceBook();
        Product2 product = createProduct();
        vlocity_cmt__PriceList__c priceList = createPriceList(priceBook.Id);
        PricebookEntry priceBookEntry = createPriceBookEntry(product, priceBook);
        vlocity_cmt__Catalog__c catalogo = createCatalog ();
        vlocity_cmt__CatalogProductRelationship__c relCatalogProd = createProductCatalogRelationship (catalogo, product);
        Asset rootAsset = createAssetRoot(account);

        createOrder(priceList, account);

        System.debug('----- Sali de crearDatosPrueba');
    }

    static Account getAccountId () {
        return [SELECT Id FROM Account WHERE Name = :K_ACCOUNT_NAME];
    }


    private static Account createAccount() {
        System.debug('---------- Entre en createAccount()');
        List<Account> lstAcc = new List<Account>();
        Account a = new Account(Name=K_ACCOUNT_NAME, AccountIntegrationId__c=String.valueOf(10000));
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        lstAcc.add(a);
        Account b = new Account(Name='TelecomTest', AccountIntegrationId__c=String.valueOf(10001));
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        lstAcc.add(b);
        insert lstAcc;
        return getCreatedAccount(K_ACCOUNT_NAME);
    }

    private static Account getCreatedAccount (String pName) {
        System.debug('-------------- Entre en getCreatedAccount()');
        Account a = [SELECT Id FROM Account WHERE Name = :pName];
        System.debug('-------------- Account Id: ' + a.Id);
        System.debug('-------------- Sali de getCreatedAccount()');
        return a;
    }

    private static vlocity_cmt__PriceList__c createPriceList(Id priceBookId){
        System.debug('---------- Entre en createPriceList()');
        vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c(Name='Telecom Price List', vlocity_cmt__Code__c='PRL_TELCOM',
            vlocity_cmt__Description__c='Create for IFS_S445 Testing', vlocity_cmt__Pricebook2Id__c=priceBookId);

        insert taPriceList;
        return  [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'PRL_TELCOM'];
    }
    
    private static Product2 createProduct() {
        System.debug('---------- Entre en createProduct()');
        Product2 prod = new Product2(Name='TestProduct');
        insert prod;
        return  [SELECT Id FROM Product2 WHERE Name = 'TestProduct'];
    }

    private static Pricebook2 createPriceBook(){
        System.debug('---------- Entre en createPriceBook()');
        Pricebook2 priceBook = new Pricebook2(Name='PriceBook for IFS_S224 Testing');
        insert priceBook;
        return  [SELECT Id FROM Pricebook2 WHERE Name = 'PriceBook for IFS_S224 Testing'];
    }

    private static PricebookEntry createPriceBookEntry(Product2 pProd, Pricebook2 pPriceBook2) {
        System.debug('---------- Entre en createPriceBookEntry()');
        Id standardPBId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBId,
            Product2Id = pProd.Id, UnitPrice = 111.85, IsActive = true);

        insert standardPrice;
        return  [SELECT Id FROM PricebookEntry WHERE Product2Id = :pProd.Id AND IsActive = true AND Pricebook2Id = :standardPBId];
    }    

    private static vlocity_cmt__Catalog__c createCatalog () {
      System.debug('---------- Entre en createCatalog()');  
      vlocity_cmt__Catalog__c catalogo = new vlocity_cmt__Catalog__c(
          Name=K_CATALOGO_NAME, vlocity_cmt__Description__c='Catalog for IFS_S224 Testing', vlocity_cmt__IsActive__c=true);  
        insert catalogo;
        return  [SELECT Id, Name FROM vlocity_cmt__Catalog__c WHERE Name = :catalogo.Name ];
    }

    private static vlocity_cmt__CatalogProductRelationship__c createProductCatalogRelationship (vlocity_cmt__Catalog__c pCatalogo, Product2 pProd) {
        System.debug('---------- Entre en createProductCatalogRelationship()'); 
        vlocity_cmt__CatalogProductRelationship__c prodCatalogRel = new vlocity_cmt__CatalogProductRelationship__c(
            Name=pCatalogo.Name, vlocity_cmt__CatalogId__c=pCatalogo.Id, vlocity_cmt__IsActive__c=true, vlocity_cmt__Product2Id__c=pProd.Id );

        insert prodCatalogRel;
        return  [SELECT Id, vlocity_cmt__Product2Id__c FROM vlocity_cmt__CatalogProductRelationship__c WHERE Name=:pCatalogo.Name];
    }

    public static Asset createAssetRoot(Account pAcc){
        System.debug('---------- Entre en createAssetRoot()'); 
        Asset a = new Asset();
        a.Product2Id = createPlan().Id;
        a.Accountid = pAcc.Id;
        a.name = 'RootAsset-Test';
        a.MSISDN__c = K_MSISDN_OK;
        insert a;
        return  [SELECT Id FROM Asset WHERE Accountid = :pAcc.Id AND Name = 'RootAsset-Test'];
    }

    private static Product2 createPlan (){
        System.debug('---------- Entre en createPlan()'); 
        Product2 service = new Product2(Name='Plan - Test', Family='Movil');
        insert service;
        return  [SELECT Id FROM Product2 WHERE Name = 'Plan - Test' AND Family = 'Movil'];
    }


    static void createOrder(vlocity_cmt__PriceList__c pTAPriceList, Account pAccount) {
        Order order = new Order(Name=K_ORDER_NAME, AccountId=pAccount.Id, EffectiveDate=Date.today(),
                                    Status='Draft', Pricebook2Id =Test.getStandardPricebookId(),
                                        vlocity_cmt__PriceListId__c=pTAPriceList.Id, Delivery_Method__c='Delivery',
                                                    vlocity_cmt__OriginatingChannel__c='Agentes');

        insert order;
    }


    static Id getPricebookId () {
        vlocity_cmt__CatalogProductRelationship__c prodCatalogRel = [SELECT Id, vlocity_cmt__Product2Id__c FROM vlocity_cmt__CatalogProductRelationship__c WHERE Name=:K_CATALOGO_NAME];
        Id productId = prodCatalogRel.vlocity_cmt__Product2Id__c;
        PricebookEntry priceBookEntry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :productId AND IsActive = true AND Pricebook2Id = :Test.getStandardPricebookId()];
        return priceBookEntry.Id;
    }

    private static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = getCreatedAccount('TelecomTest');
        System.debug('------------ Despues de crear el Account (Organization) ----');
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Centro de Servicio Santa Fe', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA', RecordTypeId=Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId());
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Centro de Servicio Santa Fe'];     

/*        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Agentes', Channel_Type_2__c='Agentes', Channel_Type_3__c='Agentes',
             Region__c='AMBA');
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];    */
}

    private static WorkTeam__c createWorkTeam (Id pStoreLocationId) {
        System.debug('---------- Entre en createWorkTeam()');
        WorkTeam__c wt = new WorkTeam__c(Name='Ventas', Team_Name__c='Ventas', Is_Active__c=true, Work_Place__c=pStoreLocationId);
        insert wt;
        return [SELECT Id FROM WorkTeam__c WHERE Name='Ventas'];
    }

    private static void createWorkTeamMember (Id pWorkTemaId) {
        System.debug('---------- Entre en createWorkTeamMember()');
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId);
        wtm.UserRoleAPIName__c='Care';

        insert wtm;
    }


    public class FromJSON {
        public FromJSON_1 invoiceAndPaymentNotification; 
        public FromJSON() {
            invoiceAndPaymentNotification = new FromJSON_1();
        }
    }

    public class FromJSON_1 {
        public String SalesOrderId; 
        public String Status;
        public String StatusInvoice;
        public String ReasonCode;
        public String Comments;
        public String ReasonCodeName;
        public Decimal TotalInvoiceAmount;
        public String LegalInvoiceNumber;
    }

    public class Result {
        public Integer resultCode=-1;
        public String message;
    }

    public class ErrorClass {
        public String errorCode;
        public String message;
    }

    public class FromBadJSON2 {
        public String dummy1; 
        public String dummy2; 
    }


}