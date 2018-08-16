@isTest
public with sharing class TaEmailsTest {
private static final String K_ACCOUNT_NAME = 'TestIFSS453Account';

    public static testmethod void unitTest1(){
        Test.startTest();
        taEmails tae = new taEmails();
        tae.invokeMethod('getEmails', null, null, null);
        tae.invokeMethod('sendEmailToWorkteamManager', null, null, null);
        Test.stopTest();
    }


    public static testmethod void unitTest2(){
        Map<String,Object> inputMap = new  Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Case getCase = createCase1();
        options.put('caseId', (String)getCase.Id);

        Test.startTest();
        createWorkTeamNew();
        taEmails tae = new taEmails();
        tae.invokeMethod('sendEmailToWorkteamManager', inputMap, outMap, options);
        Test.stopTest();
    }


    public static Account createAccount (){

      Account newAccountExample = new Account();
      newAccountExample.Name='New Account Test mail';

      insert newAccountExample;
      return newAccountExample;
    }

    public static Asset createAsset1(){

      Account accountExample = createAccount();
      Product2 prod = createProduct(1)[0];
      Contact contactExample = createContactsForMail(accountExample);

      Asset newAssetExample = new Asset(Name='New Asset Test', Product2Id=prod.Id, AccountId=accountExample.Id, ContactId=contactExample.Id);

      insert newAssetExample;
      return newAssetExample;
    }

    public static Asset createAsset2(){

      Account accountExample = createAccount();
      Product2 prod = createProduct(1)[0];
      Contact contactExample = createContactsForSms(accountExample);

      Asset newAssetExample = new Asset(Name='New Asset Test', Product2Id=prod.Id, AccountId=accountExample.Id, ContactId=contactExample.Id);

      insert newAssetExample;
      return newAssetExample;
    }

    public static Case createCase1(){

     Asset getAsset = createAsset1();
     Order getOrder = createOrder(getAsset);


     Case newCaseExample = new Case(
    Subject='New Case Test mail',
    AccountId = getAsset.AccountId,
    AssetId = getAsset.Id,
    Order__c = getOrder.Id,
    ContactId = getAsset.ContactId,
    Status = 'Informada');

    insert newCaseExample;


    return newCaseExample;
   }

     public static Case createCase2(){

     Asset getAsset = createAsset2();
     Order getOrder = createOrder(getAsset);


     Case newCaseExample = new Case(
    Subject='New Case Test mail',
    AccountId = getAsset.AccountId,
    AssetId = getAsset.Id,
    SuppliedPhone = '11989898989',
    Order__c = getOrder.Id,
    ContactId = getAsset.ContactId,
    Status = 'Informada');

    insert newCaseExample;


    return newCaseExample;
   }


   public static Order createOrder (Asset assetTest){


    Contract contractExample = new Contract(Name='New Order Test mail1',StartDate=Date.Today(),Status = 'Draft', AccountId = assetTest.AccountId,  ContractTerm = 4);
    insert contractExample;

    vlocity_cmt__PriceList__c taPriceList = createPriceList('Telecom Price List');

    Order orderExample = new Order();
    orderExample.Name = 'test order email';
    orderExample.AccountId = assetTest.AccountId;
    orderExample.ContractId = contractExample.Id;
    orderExample.Pricebook2Id =Test.getStandardPricebookId();
    orderExample.EffectiveDate = Date.Today();
    orderExample.Status = 'Draft';
    orderExample.vlocity_cmt__PriceListId__c=taPriceList.Id;
    orderExample.Delivery_Method__c = 'Presencial';
    orderExample.vlocity_cmt__OriginatingChannel__c='Agentes';

    insert orderExample;

    createOrderItem(2, orderExample);

    return orderExample;

  }


  public static vlocity_cmt__PriceList__c createPriceList(String name){
    String priceBookId = createPriceBook('TA Price Book').Id;

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

  public static void createOrderItem(Integer numOrders, Order Ord) {

     List<OrderItem> OIList = new List<OrderItem>();
     List<product2>Prod=createProduct(1);
     PricebookEntry standardPrice = new PricebookEntry(
      Pricebook2Id =Test.getStandardPricebookId(),
      Product2Id = prod[0].Id,
      UnitPrice = 10000, IsActive = true);

     insert standardPrice;

     for(Integer i=0;i<numOrders;i++) {
       OrderItem oi = new OrderItem(OrderId=Ord.id,Quantity=decimal.valueof('1'),UnitPrice=1,PricebookEntryId=standardPrice.id);

       OIList.add(oi);
     }

     insert OIList;

  }

   public static List<Product2> createProduct(Integer numProd) {
      List<Product2> prods = new List<Product2>();

      for(Integer i=0;i<numProd;i++) {
        Product2 a = new Product2(Name='TestProduct '+i, ProductCode='TestProductCode');
        prods.add(a);
      }

      insert prods;

      return prods;
  }


  public static Contact createContactsForMail(Account acc){

   Contact newContact = new Contact(FirstName='firstNameTest',
                                    LastName='lastNameTest',
                                    AccountId=acc.Id, Email ='emailTest@test.com');

    insert newContact;
   return newContact;

  }

  public static Contact createContactsForSms(Account acc){

   Contact newContact = new Contact(FirstName='firstNameTest',
                                    LastName='lastNameTest',
                                    AccountId=acc.Id, MobilePhone ='11234567890');

    insert newContact;
   return newContact;

  }

    public static WorkTeam__c createWorkTeamNew(){
    User getUser = createUser('System Administrator');
        String wtUserId = (String)getUser.Id;
    WorkTeam__c wt = new WorkTeam__c(Name='EquipoTst', Team_Name__c='EquipoTst', Is_Active__c=true, Manager__c=wtUserId);
        insert wt;
        return wt;
    }


    public static WorkTeam__c createWorkTeam(){
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation();
        Id storelocationId = storeLocation.Id;
        User getUser = createUser('System Administrator Test');
        System.debug('getUser ' + getUser);
        String wtUserId = (String)getUser.Id;
        System.debug('(String)getUser.Id ' + (String)getUser.Id);
        WorkTeam__c wt = new WorkTeam__c(Name='EquipoTst', Team_Name__c='EquipoTst', Is_Active__c=true, Work_Place__c=storelocationId, Manager__c=wtUserId);
        insert wt;
        return wt;
    }


      private static Account createWtAccount() {

        List<Account> lstAcc = new List<Account>();

        Account b = new Account(Name='nvprb', AccountIntegrationId__c=String.valueOf(10012));
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        lstAcc.add(b);
        insert lstAcc;
        return getCreatedAccount1('nvprb');
    }


    private static Account getCreatedAccount1 (String pName) {
        Account a = [SELECT Id FROM Account WHERE Name = :pName];

        return a;
    }

    private static vlocity_cmt__BusinessSite__c createStoreLocation () {
        Account orgAcc = createWtAccount();

        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte1',
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA');
        insert storeLocation;
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte1'];
    }

     public static User createUser(String profile){
        User u;

        try{
            Id p = [SELECT Id FROM Profile WHERE Name =: profile].Id;
            u = new User(Alias = 'testu', Email='testuser@superhijitus.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='es_AR', ProfileId = p,
            TimeZoneSidKey='America/Argentina/Buenos_Aires', UserName='osPrueba');
            insert u;
        }
        catch(Exception e){
            System.debug('error: ' + e.getMessage());
            System.debug('errorStackTrace: '+ e.getStackTraceString());
        }

        return u;
    }


/*
    public static testmethod void unitTest3(){
        User user = new User();
        String userId = (String)user.Id;
        String subject = 'Notificacion de Prueba';
        String htmlBody = '<p><b>Este mensaje es enviado como notificacion de una prueba de la clase TaEmailsTest</b></p>';
        Test.startTest();
        taEmails tae = new taEmails();
       // tae.sendInternalEmail(userId, subject, htmlBody);
        Test.stopTest();
    }


@isTest static void invoke_sendEmailToWorkteamManager_OK(){
    String methodName ='sendEmailToWorkteamManager';
    Map<String,Object> outMap = new Map<String, Object>();
    Map<String, Object> empty = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
    Map<String,Object> inputMap = new Map<String, Object>();
    taEmails testedClass = new taEmails();

    //Creacion del contacto
    Contact contactObj = new Contact(
        LastName = 'Pepe',
        Phone = '45454544545'
    );
    insert contactObj;

    //Creacion del account
    Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
    Account accountObj = new Account (
        vlocity_cmt__PrimaryContactId__c = contactObj.Id,
        Name='Cuenta Test',
        RecordTypeId = businessRecordTypeId,
        AccountIntegrationId__c = '0016C000009I5zg' //Ver cual existe en huawei
    );
    insert accountObj;

        String profileName = 'pepe';
        Id profileId = [SELECT Id FROM Profile WHERE name =: profileName].Id;
        User tstManager = new User();
        tstManager.ProfileId = profileId;
        tstManager.Username = 'claseTest@gmail.com';
        tstManager.Email = 'gfiorechapman@teco.com.ar';
        tstManager.LastName = 'Test';
        tstManager.Alias = 'cTest';
        tstManager.CommunityNickname = 'CMN';
        tstManager.TimeZoneSidKey = 'America/Argentina/Buenos_Aires';
        tstManager.LocaleSidKey = 'es_AR';
        tstManager.EmailEncodingKey = 'ISO-8859-1';
        tstManager.LanguageLocaleKey = 'en_US';
        insert tstManager;

    WorkTeam__c tstTeam = new WorkTeam__c();
    tstTeam.Name = 'EquipoTst';
    tstTeam.Team_Name__c = 'EquipoTst';
    insert tstTeam;

    Case caseObj = new Case(
            Status = 'En autorización',
            Origin = 'Personalizado',
            TipoSeleccion__c = 'Servicio',
            TipoConcepto__c = 'CREDITO PREPAGO',
            Tipo__c = 'No aplica Prepago',
            TipoItem__c = 'Consumos de datos',
            TipoAjuste__c = 'Credito',
            TipoOperacionAjuste__c = 'CREDITO',
            vlocity_cmt__Amount__c = 400,
            UnidadAjuste__c = 'Credito',
            AccountId = accountObj.Id,
            OwnerId = '0056C000000gQeF', //Federico
            Subject = 'Inconvenientes con cargos tasados y facturados',
            AssetId = '02i6C0000002g8n',
            Owner_Team__c = tstTeam.Id
        );
    insert caseObj;

    Case casoTest = [SELECT Id, Subject FROM Case WHERE Subject = 'Inconvenientes con cargos tasados y facturados' Limit 1];
    options.put('caseId', casoTest.Id );
    Test.startTest();
    testedClass.invokeMethod(methodName, inputMap, outMap, options);
    Test.stopTest();

    Map<String,Object> result = (Map<String,Object>) outMap.get('result');
    system.assertEquals('0',(string)result.get('codError'));


    outMap = new Map<String, Object>();
    options = new Map<String, Object>();
    WorkTeam__c tst2 = [SELECT Id, Manager__c, Team_Name__c FROM WorkTeam__c WHERE Name='EquipoTst' Limit 1];
    tst2.Manager__c = '';
    options.put('caseId', casoTest.Id );

    Test.startTest();
    testedClass.invokeMethod(methodName, inputMap, outMap, options);
    Test.stopTest();

  }
*/
}