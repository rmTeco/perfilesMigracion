@isTest
public class IFS_S348_Test {

    private static String expectedResponse = null;
    private static String response = null;
    private static final String K_MSISDN_OK  = '47774777';
    private static final String K_MSISDN_NOK = '49994999';
    private static final String K_CANAL_OK = 'IVR';
    private static final String K_CANAL_NOK = 'Presencial';
    private static final String K_ORDER_NAME = 'TestOrderS446';
    private static final String K_CATALOGO_NAME = 'IVR';
    private static final String K_ACCOUNT_NAME = 'TestIFSS446Account';
    private static String accountID ='';
    private static String IdOrder ='';


    public map<String,Object> generarRespuesta(){
        map<String,Object> resp = new map<String,Object>();
        map<String,Object> IPResult = new map<String,Object>();
        list<Object> pagoRespuesta = new list<Object>();
        map<String,Object>pago = new map<String,Object>();
        map<String,Object>pagoInterior = new map<String,Object>();
        map<String,Object>pagoPapa = new map<String,Object>();
        pago.put('identificadorPagoCanal','PAPA');


        //pagoInterior.put('pagoExitoso','YES');
        pagoInterior.put('codPago','YES');


        pagoPapa.put('pagoExitoso',pagoInterior);
        pago.put('resultadoPago',pagoPapa);

        pagoRespuesta.add(pago);
        IPResult.put('procesarPagosRespuesta',pagoRespuesta[0]);
        resp.put('IPResult',IPResult);
        return resp;
    }

   	@isTest static void TestOK () {
    	//Order ordenTest= new Order();
    	map<String,Object> input = new map<String,Object>();
        map<String,Object> output = new map<String,Object>();
    	map<String,Object> options = new map<String,Object>();
        map<String,Object> PaymentMethod = new map<String,Object>();
        List<Object> PaymentMethods = new List<Object>();
        map<String,Object> payment = new map<String,Object>();
        map<String,Object> payment2 = new map<String,Object>();
        map<String,Object> paymentIn = new map<String,Object>();
		paymentIn.put('CardNumber','1245787878781475');
        paymentIn.put('SecurityCode','124');
        payment.put('CreditCardData',paymentIn);
        payment2.put('DebitCardData',paymentIn);
        PaymentMethods.add(payment);
        PaymentMethods.add(payment2);
        //map<String,Object> output = new map<String,Object>();
        //map<String,Object> output = new map<String,Object>();
        crearDatosPrueba();
        PaymentMethod.put('PaymentMethods',PaymentMethods);
        input.put('SelectPaymentMethodsStep',PaymentMethod);
        input.put('IdOrder',IdOrder);
        input.put('accountId',accountID);
        vlocity_cmt__PaymentAdjustment__c paymentADJ = new vlocity_cmt__PaymentAdjustment__c();
        vlocity_cmt__PaymentMethod__c paymentMethodC = new vlocity_cmt__PaymentMethod__c();
		FinancialPromotion__c financialPromotion = new FinancialPromotion__c();
        paymentMethodC.vlocity_cmt__AccountId__c=accountID;
        paymentMethodC.BankEntityName__c = '405';
        paymentMethodC.vlocity_cmt__CardHolderName__c = 'COMPLETAR';
        paymentMethodC.vlocity_cmt__ExpirationMonth__c = '01';
        paymentMethodC.vlocity_cmt__ExpirationYear__c = '2020';
        paymentMethodC.vlocity_cmt__MethodType__c = 'Efectivo';
        paymentMethodC.vlocity_cmt__IsPrimary__c = true;
        paymentMethodC.vlocity_cmt__RoutingTransitNumber__c = '123';
        paymentMethodC.CardHolderDocumentNumber__c = '12345678';
        paymentMethodC.CardHolderDocumentType__c = 'DNI';
        paymentMethodC.vlocity_cmt__Last4Numbers__c = '1475';

        insert paymentMethodC;

        financialPromotion.CreditCards__c='405';
        financialPromotion.NombrePromocion__c='Ahora 12';
        financialPromotion.InstalmentPlan__c=3;
        financialPromotion.ChannelPromotion__c='Físico';

        insert financialPromotion;

        paymentADJ.vlocity_cmt__AccountId__c=accountID;
        paymentADJ.vlocity_cmt__PaymentMethodId__c=paymentMethodC.id;
        paymentADJ.vlocity_cmt__Amount__c=1000;
        paymentADJ.PaymentCode__c='2219';
        paymentADJ.Order__c=IdOrder;
        paymentADJ.vlocity_cmt__TotalInstallments__c=3;
		paymentADJ.Financial_Promotion__c=financialPromotion.id;
        paymentADJ.vlocity_cmt__PaymentMethodId__r = paymentMethodC;
        insert paymentADJ;

        List<vlocity_cmt__PaymentAdjustment__c> payments = new List<vlocity_cmt__PaymentAdjustment__c>();
        payments.add(paymentADJ);
        options.put('payments', payments);

        Test.startTest();
    	IFS_S348 clase = new IFS_S348();
        clase.invokeMethod('PurchaseIntegration',input,output,options);
        Test.stopTest();
    }


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
        accountID=a.id;
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
        Pricebook2 priceBook = new Pricebook2(Name='PriceBook for IFS_S445 Testing');
        insert priceBook;
        return  [SELECT Id FROM Pricebook2 WHERE Name = 'PriceBook for IFS_S445 Testing'];
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
          Name=K_CATALOGO_NAME, vlocity_cmt__Description__c='Catalog for IFS_S446 Testing', vlocity_cmt__IsActive__c=true);
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
        system.debug(order.id);
   		IdOrder=order.id;

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
        Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(RecordTypeId = idRecordType, Name='Barrio Norte',
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA');/*, Ownership__c='', PointOfSaleType__c='',BillingMode__c='', Momento_PDV__c='', PaymentChannel__c = , Type_of_contact__c,
             vlocity_cmt__Country__c, vlocity_cmt__City__c, vlocity_cmt__StreetAddress__c, vlocity_cmt__State__c, PointOfSaleAddressNumber__c, Location__c
             );*/
        insert storeLocation;
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];
    }

    private static WorkTeam__c createWorkTeam (Id pStoreLocationId) {
        System.debug('---------- Entre en createWorkTeam()');
        WorkTeam__c wt = new WorkTeam__c(Name='Ventas', Team_Name__c='Ventas', Is_Active__c=true, Work_Place__c=pStoreLocationId);
        insert wt;
        return [SELECT Id FROM WorkTeam__c WHERE Name='Ventas'];
    }

    private static void createWorkTeamMember (Id pWorkTemaId) {
        System.debug('---------- Entre en createWorkTeamMember()');
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId, UserRoleAPIName__c='Test');
        insert wtm;
    }

}