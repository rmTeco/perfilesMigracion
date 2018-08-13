@isTest(seeAllData = false)
public with sharing class TaSalesCartContainerControllerTest {

    @testSetup
    static void setup() {
        Account acc = new Account(Name = 'test');
        insert acc;
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c();
        priceList.Name = 'Telecom Price List';
        priceList.vlocity_cmt__Code__c = 'Code-Test';
        insert priceList;
        Order ord = new Order(AccountId = acc.Id, EffectiveDate = date.today(), Status = 'Draft', Delivery_Method__c='Delivery', vlocity_cmt__OriginatingChannel__c='Agentes');
        insert ord;
        vlocity_cmt__Premises__c pre = new vlocity_cmt__Premises__c(vlocity_cmt__PremisesNumber__c = '12345', vlocity_cmt__PremisesIdentifier__c = 'codDeposito');
        insert pre;
        Asset ass = new Asset(Name = 'asset1', vlocity_cmt__PremisesId__c = pre.Id, AccountId = acc.Id);
        insert ass;
    }
    @isTest
     static void callPrefeasibilityRemoteTest(){
        IFS_S094_getSerializedByWarehouseMock mock = new IFS_S094_getSerializedByWarehouseMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
        Order ord = [SELECT Id FROM Order LIMIT 1];
        Asset ass = [SELECT Id FROM Asset LIMIT 1];
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('OrderID', ord.Id);
        Map<String, Object> instAddressMap = new Map<String,Object>();
        Map<String, Object> mainDoor = new Map<String, Object>();
        instAddressMap.put('MainDoor', mainDoor);
        Map<String, Object> typeAndZone = new Map<String, Object>();
        instAddressMap.put('Type&Zone', typeAndZone);
        Map<String, Object> additionalInfo = new Map<String, Object>();
        instAddressMap.put('AdditionalInfo', additionalInfo);
        inputMap.put('AddressInput', instAddressMap);


        Test.startTest();
        taSalesCartContainerController tscc = new taSalesCartContainerController();
        taSalesCartContainerController.CallPrefeasibility(ord.Id, ass.Id);
        Test.stopTest();
    }

  @isTest
  static void callPrefeasibilityRemoteTest2(){
    IFS_S094_getSerializedByWarehouseMock mock = new IFS_S094_getSerializedByWarehouseMock();
    mock.status = 200;
    Test.setMock(HttpCalloutMock.class, mock);
    Order ord = [SELECT Id FROM Order LIMIT 1];
    Asset ass = [SELECT Id FROM Asset LIMIT 1];
    Map<String, Object> inputMap = new Map<String, Object>();
    inputMap.put('OrderID', ord.Id);
    Map<String, Object> instAddressMap = new Map<String,Object>();
    Map<String, Object> mainDoor = new Map<String, Object>();
    instAddressMap.put('MainDoor', mainDoor);
    Map<String, Object> typeAndZone = new Map<String, Object>();
    instAddressMap.put('Type&Zone', typeAndZone);
    Map<String, Object> additionalInfo = new Map<String, Object>();
    instAddressMap.put('AdditionalInfo', additionalInfo);
    inputMap.put('AddressInput', instAddressMap);


        Test.startTest();
        taSalesCartContainerController tscc = new taSalesCartContainerController();
        taSalesCartContainerController.CallPrefeasibility(ord.Id, null);
        Test.stopTest();
    }

  @isTest
   static void callPrefeasibilityInvokeTest(){
    IFS_S094_getSerializedByWarehouseMock mock = new IFS_S094_getSerializedByWarehouseMock();
    mock.status = 200;
    Test.setMock(HttpCalloutMock.class, mock);
    Order ord = [SELECT Id FROM Order LIMIT 1];
    Map<String, Object> inputMap = new Map<String, Object>();
    inputMap.put('OrderID', ord.Id);
    Map<String, Object> instAddressMap = new Map<String,Object>();
    Map<String, Object> mainDoor = new Map<String, Object>();
    instAddressMap.put('MainDoor', mainDoor);
    Map<String, Object> typeAndZone = new Map<String, Object>();
    instAddressMap.put('Type&Zone', typeAndZone);
    Map<String, Object> additionalInfo = new Map<String, Object>();
    instAddressMap.put('AdditionalInfo', additionalInfo);
    inputMap.put('AddressInput', instAddressMap);


        Test.startTest();
        taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('CallPrefeasibility', inputMap, null, null);
        Test.stopTest();
    }

@isTest
  static void callStockMovementTest(){
    IFS_S094_getSerializedByWarehouseMock mock = new IFS_S094_getSerializedByWarehouseMock();
    mock.status = 200;
    Test.setMock(HttpCalloutMock.class, mock);

    Order ord = [SELECT Id FROM Order LIMIT 1];
    Asset ass = [SELECT Id FROM Asset LIMIT 1];
    Account acc = [SELECT Id FROM Account LIMIT 1];
    /*
    Id usId = userinfo.getUserId();
    TestDataFactory.setTeamMember('Test', usId, null);
        List<Account> acc = TestDataFactory.createAccounts(1, 'Consumer');
        Id Usrid = userinfo.getUserId();
        TestDataFactory.setTeamMember('Testasdasdasd', Usrid, null);
        Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc; 
        */
        //Order ord = new Order(AccountId = acc.Id, EffectiveDate = date.today(), Status = 'Draft', Delivery_Method__c = 'Presencial', vlocity_cmt__OriginatingChannel__c = 'Presencial Agente');
        //insert ord;

        Decimal pickUpStore2 = 21;
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c = acc.Id);
        storeLocation.PointOfSaleId__c = pickUpStore2;
        storeLocation.AssociatedWarehouseId__c = 'DFMULT001';
        insert storeLocation;

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('IdOrder', ord.Id);
        Map<String, Object> billingOrderMap = new Map<String, Object>();
        billingOrderMap.put('PickUpStore', String.valueOf(pickUpStore2));
        inputMap.put('BillingOrder', billingOrderMap);

        Test.startTest();
        taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('CallStockMovement', inputMap, null, null);
        ord.vlocity_cmt__OriginatingChannel__c = 'Agentes';
        ord.Delivery_Method__c = 'Presencial';
        update ord;
        tscc.invokeMethod('CallStockMovement', inputMap, null, null);
        //ord.Delivery_Method__c = 'Store Pick Up';
        //update ord;
        //tscc.invokeMethod('CallStockMovement', inputMap, null, null);
        Test.stopTest();
    }

  @isTest
   static void retrievePrefeasibilityResultTest(){
    IFS_S094_getSerializedByWarehouseMock mock = new IFS_S094_getSerializedByWarehouseMock();
    mock.status = 200;
    Test.setMock(HttpCalloutMock.class, mock);
    Order ord = [SELECT Id FROM Order LIMIT 1];
    ord.PrefeasibilityResult__c = '{"tecnologiasAcceso":[{"tecnologia":"TEST","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Un Servicio","standardsTecnico":[{"standardTecnico":"NUMS","medicionDeBajada":0,"disponibilidad":"NO"},{"standardTecnico":"ADSL","medicionDeBajada":0,"disponibilidad":"NO"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"NGN","medicionDeBajada":0,"disponibilidad":"NO"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"},{"tecnologia":"FIBRA","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Internet","standardsTecnico":[{"standardTecnico":"GPON","medicionDeBajada":0,"disponibilidad":"NO"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"GPON","medicionDeBajada":0,"disponibilidad":"NO"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"},{"tecnologia":"GSMF","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Internet","standardsTecnico":[{"standardTecnico":"GSM","medicionDeBajada":0,"disponibilidad":"NO"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"GSM","medicionDeBajada":0,"disponibilidad":"NO"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"}],"servicios":{}}';
    update ord;
    Map<String, Object> inputMap = new Map<String, Object>();
    inputMap.put('OrderID', ord.Id);

        Test.startTest();
        taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('RetrievePrefeasibilityResult', inputMap, null, null);
        Test.stopTest();
    }
    
    
    @isTest
    static void updateAttrib_test() {
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        //TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        //List<Account> account = TestDataFactory.createAccounts(1, 'Consumer');
        
        string args = '{"records":[{"lineItems":{"records":[{"Name":"Test"}]}},{"lineItems":{"records":[{"Name":"Test"}]}},{"lineItems":{"records":[{"Name":"Test"}]}},{"lineItems":{"records":[{"Name":"Test"}]}}]}';
        Map<String,Object> lineItems = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('lineItemsInCart',lineItems); 
        
        options.put('itemName','stringvalue');
        options.put('attribs',lineItems);
        
        //taSalesCartContainerController.updateAttrib(inputMap, outputMap, options);
        taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('updateAttrib', inputMap, outputMap, options);
    }
    
    @isTest
    static void updateNAttribs_test() {
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        //TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        //List<Account> account = TestDataFactory.createAccounts(1, 'Consumer');
        
        string args = '{"lineItemsInCart":{"records":[{"lineItems":{"records":[{"Name":"Test"}]}}]}}';
        Map<String,Object> lineItems = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('lineItemsInCart',lineItems); 
        
        string args2 = '[{"productAttributes": {"records": [{"Id":"asdas"},{"Id2":"asdasd"}]},"Status": "Active","Id": "0016C000008fHeiQAE","Name": "Sandra Ramos Billing 1","$$hashKey": "object:613","vlcSelected": true}]'; 
        List<Object> attrbCat = (List<Object>)JSON.deserializeUntyped(args2);
        
        
        
        options.put('itemName','');
        options.put('attribs','');
        
        taSalesCartContainerController.updateNAttribs(attrbCat, lineItems); 
        
    }
    
   @isTest
    static void update1Attrib_test() {
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        //TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        //List<Account> account = TestDataFactory.createAccounts(1, 'Consumer');
        
        string args = '{"lineItemsInCart":{"records":[{"lineItems":{"records":[{"Name":"Test"}]}}]}}';
        string args2 = '[{"productAttributes": {"records": [{"Id":"asdas"},{"Id2":"asdasd"}]},"Status": "Active","Id": "0016C000008fHeiQAE","Name": "Sandra Ramos Billing 1","$$hashKey": "object:613","vlcSelected": true}]'; 
        Map<String,Object> lineItems = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('lineItemsInCart',lineItems); 
        
        List<Object> attrbCat = (List<Object>)JSON.deserializeUntyped(args2);
        
        options.put('itemName','');
        options.put('attribs','');
        
        taSalesCartContainerController.update1Attrib(attrbCat, 'param2', 'param3'); 
        
    }
    
    @isTest
    static void getCreditLimit_test() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Integer ent = taSalesCartContainerController.getCreditLimit(acc.Id);
        
    }
    
    @isTest
    static void getDunningMark_test() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        acc.Dunning__c = true;
        update acc;
        Boolean bol = taSalesCartContainerController.getDunningMark(acc.Id);
        
    }
    
    @isTest
    static void DeleteCartItems_test() {
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Order ord = [SELECT Id FROM Order LIMIT 1];
        Asset ass = [SELECT Id FROM Asset LIMIT 1];
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        options.put('orderId',ord.Id);
        Boolean bol;
        //bol = taSalesCartContainerController.DeleteCartItems(inputMap, outputMap, options);
        options.put('orderId','ord.Id');
        bol = taSalesCartContainerController.DeleteCartItems(inputMap, outputMap, options);
        
        taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('DeleteCartItems', inputMap, outputMap, options);

  }

  @isTest
  static void AddToCartValidations_CEGTest_Ok() {

      Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

      Order ord = [SELECT Id FROM Order LIMIT 1];
      ord.Gestion__c = 'Cambio en Garantia';
      update ord;

      options.put('IdOrder',ord.Id);
      options.put('ItemToAddProductType','Dispositivo');

      Test.startTest();
      taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('AddToCartValidations', inputMap, outputMap, options);
      Test.stopTest();
      String errorMessage  = (String) outputMap.get('ErrorMessage');
      Boolean isError = String.IsNotBlank(errorMessage);
      System.AssertEquals(false, isError);
  }

  @isTest
  static void AddToCartValidations_NoCEGTest_NOk() {

      MockupFactory.generate();
      Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

      Order ord = [SELECT Id FROM Order WHERE Gestion__c = 'Venta' LIMIT 1];

      options.put('IdOrder',ord.Id);
      options.put('ItemToAddProductType','Simcard');

      Test.startTest();
      taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('AddToCartValidations', inputMap, outputMap, options);
      Test.stopTest();
      String errorMessage  = (String) outputMap.get('ErrorMessage');
      Boolean isError = String.IsNotBlank(errorMessage);
      System.AssertEquals(true, isError);
  }

  @isTest
  static void AddToCartValidations_CEGTest_NOk_NoDispositivo() {

      Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

      Order ord = [SELECT Id FROM Order LIMIT 1];
      ord.Gestion__c = 'Cambio en Garantia';
      update ord;

      options.put('IdOrder',ord.Id);
      options.put('ItemToAddProductType','PEPE');

      Test.startTest();
      taSalesCartContainerController tscc = new taSalesCartContainerController();
        tscc.invokeMethod('AddToCartValidations', inputMap, outputMap, options);
      Test.stopTest();
      String errorMessage  = (String) outputMap.get('ErrorMessage');
      System.debug('AddToCartValidations_CEGTest_NOk_NoDispositivo: ' + errorMessage);
      Boolean isError = String.IsNotBlank(errorMessage);
      System.AssertEquals(true, isError);
  }
}