@isTest
public with sharing class taSalesChangeTerminalInWarrantyTest
{
  public static testmethod void test1()
 {
   List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
   List<Product2> lstProduct2 = TestDataFactory.createProduct(1);
   Map<String,String> serialNumbers = new Map<String,String>();
               serialNumbers.put('99999777799999', 'MTPL');
               serialNumbers.put('77776676767666', 'MCVM');
   Asset assetTest = new Asset();
   assetTest.Name = 'Test Asset';
   assetTest.AccountId = lstAccount[0].Id;
   assetTest.Product2Id =  lstProduct2[0].Id;
   //assetTest.SerialNumber = '99999777799999';
   assetTest.SerialNumber = serialNumbers.get('99999777799999');
   lstProduct2[0].productCode = 'CHIPPRUEBA';
   update lstProduct2;
   insert assetTest;
   vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
     Name = 'Barrio Norte',
     vlocity_cmt__OrganizationId__c = lstAccount[0].Id,
     Status__c = 'Activo',
     Type__c = 'POS',
     Channel__c = 'Físico',
     Channel_Type__c = 'Agentes',
     Channel_Type_2__c = 'Agentes',
     Channel_Type_3__c = 'Agentes',
     vlocity_cmt__State__c = 'C',
     Region__c='AMBA');
   insert storeLocation;

       WorkTeam__c workTeamParent = new WorkTeam__c(
     Team_Name__c = 'Test Parent',
     Name = 'Test Parent');
       insert workTeamParent;

   StockMovementConfiguration__c stockConf = new StockMovementConfiguration__c();
   stockConf.Codigo_Deposito__c = 'VICLIE001';
   stockConf.Material_del_Cliente__c = 'MCTL';
   insert stockConf;



   WarrantyTimeLimit__c objTimeAnnul = new WarrantyTimeLimit__c();
   objTimeAnnul.Channel__c = 'Físico';
   objTimeAnnul.LocationCode__c = 'C';
   objTimeAnnul.Name = 'CABA_Fisico';
   objTimeAnnul.TimeLimit__c = 30.0;
   insert objTimeAnnul;

   User usernew = new user(ID = UserInfo.getUserID());
       String strIdUser = UserInfo.getUserID();

       String manager = UserInfo.getUserId();
       String parent = workTeamParent.Id;
       WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
   Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', UserInfo.getUserId(), null);
   List<Order>OrdList = TestDataFactory.createOrders(2,lstAccount[0]);
   OrdList[0].OriginStoreLocation__c = storeLocation.Id;
   OrdList[0].PaymentMethodType__c ='1001';
   OrdList[0].vlocity_cmt__OriginatingChannel__c ='Agentes';
   OrdList[0].Gestion__c = 'Venta';
   OrdList[0].Delivery_Method__c='Presencial';
   OrdList[1].OriginStoreLocation__c = storeLocation.Id;
   OrdList[1].PaymentMethodType__c ='1001';
   OrdList[1].vlocity_cmt__OriginatingChannel__c ='Agentes';
   OrdList[1].Gestion__c = 'Venta';
   OrdList[1].Delivery_Method__c='Presencial';
   update OrdList;
   List<OrderItem>OIList =TestDataFactory.createOrderItem(1,OrdList[0]);
   OIList[0].FromStock__c = 'MTPL';
   update OIList;
   List<OrderItem>OIList1 =TestDataFactory.createOrderItem(1,OrdList[1]);
   OIList1[0].FromStock__c = 'MTPL';
   //update OIList1;
   assetTest.vlocity_cmt__OrderProductId__c = OIList[0].Id;
   update assetTest;
   Map<String, Object> inputMap = new Map<String, Object>();
   Map<String, Object> outputMap = new Map<String, Object>();
   Map<String, Object> options = new Map<String, Object>();
   options.put('assetId', assetTest.Id);
   inputMap.put('assetId', assetTest.Id);
   String mockResponse = '{"listaNumeroSeries":[{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial"},{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial2"}]}';
  VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S095', mockResponse);
   Test.startTest();
     taSalesChangeTerminalInWarrantyHandler.invokeMethod('ValidateRazonSocial', inputMap, outputMap, options);
     taSalesChangeTerminalInWarrantyHandler.invokeMethod('ValidateTangibleConsignado', inputMap, outputMap, options);
     taSalesChangeTerminalInWarrantyHandler.invokeMethod('validationTimeDefenseConsumer', inputMap, outputMap, options);
     taSalesChangeTerminalInWarrantyHandler.invokeMethod('GetTypesChangeTerminal', inputMap, outputMap, options);
     taSalesChangeTerminalInWarrantyHandler.invokeMethod('ValidateClientMaterial', inputMap, outputMap, options);
     //tsctiw.invokeMethod('ValidateSTEnElPais', inputMap, outputMap, options);
   Test.stopTest();
 }

public static testmethod void test2()
  {
    List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
    List<Product2> lstProduct2 = TestDataFactory.createProduct(1);
    Asset assetTest = new Asset();
    assetTest.Name = 'Test Asset';
    assetTest.AccountId = lstAccount[0].Id;
    assetTest.Product2Id =  lstProduct2[0].Id;
    lstProduct2[0].productCode = 'CHIPPRUEBA';
    update lstProduct2;
    insert assetTest;
    vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
      Name = 'Barrio Norte',
      vlocity_cmt__OrganizationId__c = lstAccount[0].Id,
      Status__c = 'Activo',
      Type__c = 'POS',
      Channel__c = 'Físico',
      Channel_Type__c = 'Agentes',
      Channel_Type_2__c = 'Agentes',
      Channel_Type_3__c = 'Agentes',
      vlocity_cmt__State__c = 'C',
      Region__c='AMBA');
    insert storeLocation;

        WorkTeam__c workTeamParent = new WorkTeam__c(
      Team_Name__c = 'Test Parent',
      Name = 'Test Parent');
        insert workTeamParent;

    WarrantyTimeLimit__c objTimeAnnul = new WarrantyTimeLimit__c();
    objTimeAnnul.LocationCode__c = 'C';
    objTimeAnnul.Name = 'CABA_Fisico';
    objTimeAnnul.TimeLimit__c = 30.0;
    insert objTimeAnnul;

    User usernew = new user(ID = UserInfo.getUserID());
        String strIdUser = UserInfo.getUserID();

        String manager = UserInfo.getUserId();
        String parent = workTeamParent.Id;
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
    Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', UserInfo.getUserId(), null);
    List<Order>OrdList = TestDataFactory.createOrders(2,lstAccount[0]);
    OrdList[0].OriginStoreLocation__c = storeLocation.Id;
    OrdList[0].PaymentMethodType__c ='1001';
    OrdList[0].vlocity_cmt__OriginatingChannel__c ='Agentes';
    OrdList[0].Gestion__c = 'Venta';
    OrdList[0].Delivery_Method__c='Presencial';
    OrdList[1].OriginStoreLocation__c = storeLocation.Id;
    OrdList[1].PaymentMethodType__c ='1001';
    OrdList[1].vlocity_cmt__OriginatingChannel__c ='Agentes';
    OrdList[1].Gestion__c = 'Venta';
    OrdList[1].Delivery_Method__c='Presencial';
    // OrdList[1].SubGestion__c = '';
    update OrdList;
    List<OrderItem>OIList =TestDataFactory.createOrderItem(1,OrdList[0]);
    OIList[0].FromStock__c = 'MTPL';
    update OIList;
    List<OrderItem>OIList1 =TestDataFactory.createOrderItem(1,OrdList[1]);
    OIList1[0].FromStock__c = 'MTPL';
    update OIList1;
    assetTest.vlocity_cmt__OrderProductId__c = OIList[0].Id;
    update assetTest;
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outputMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    options.put('assetId', assetTest.Id);
    Test.startTest();
      taSalesChangeTerminalInWarrantyHandler.invokeMethod('validationTimeDefenseConsumer', inputMap, outputMap, options);
    Test.stopTest();
  }

  public static testmethod void test3()
  {
    List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
    List<Product2> lstProduct2 = TestDataFactory.createProduct(1);
    Asset assetTest = new Asset();
    assetTest.Name = 'Test Asset';
    assetTest.AccountId = lstAccount[0].Id;
    assetTest.Product2Id =  lstProduct2[0].Id;
    lstProduct2[0].productCode = 'CHIPPRUEBA';
    update lstProduct2;
    insert assetTest;
    vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
      Name = 'Barrio Norte',
      vlocity_cmt__OrganizationId__c = lstAccount[0].Id,
      Status__c = 'Activo',
      Type__c = 'POS',
      Channel__c = 'Físico',
      Channel_Type__c = 'Agentes',
      Channel_Type_2__c = 'Agentes',
      Channel_Type_3__c = 'Agentes',
      vlocity_cmt__State__c = 'C',
      Region__c='AMBA');
    insert storeLocation;

        WorkTeam__c workTeamParent = new WorkTeam__c(
      Team_Name__c = 'Test Parent',
      Name = 'Test Parent');
        insert workTeamParent;

    WarrantyTimeLimit__c objTimeAnnul = new WarrantyTimeLimit__c();
    objTimeAnnul.Name = 'CABA_Fisico';
    objTimeAnnul.TimeLimit__c = 30.0;
    insert objTimeAnnul;

    User usernew = new user(ID = UserInfo.getUserID());
        String strIdUser = UserInfo.getUserID();

        String manager = UserInfo.getUserId();
        String parent = workTeamParent.Id;
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
    Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', UserInfo.getUserId(), null);
    List<Order>OrdList = TestDataFactory.createOrders(2,lstAccount[0]);
    OrdList[0].OriginStoreLocation__c = storeLocation.Id;
    OrdList[0].PaymentMethodType__c ='1001';
    OrdList[0].vlocity_cmt__OriginatingChannel__c ='Agentes';
    OrdList[0].Gestion__c = 'Venta';
    OrdList[0].Delivery_Method__c='Presencial';
    OrdList[1].OriginStoreLocation__c = storeLocation.Id;
    OrdList[1].PaymentMethodType__c ='1001';
    OrdList[1].vlocity_cmt__OriginatingChannel__c ='Agentes';
    OrdList[1].Gestion__c = 'Venta';
    OrdList[1].Delivery_Method__c='Presencial';
    update OrdList;
    List<OrderItem>OIList =TestDataFactory.createOrderItem(1,OrdList[0]);
    OIList[0].FromStock__c = 'MTPL';
    update OIList;
    List<OrderItem>OIList1 =TestDataFactory.createOrderItem(1,OrdList[1]);
    OIList1[0].FromStock__c = 'MTPL';
    update OIList1;
    assetTest.vlocity_cmt__OrderProductId__c = OIList[0].Id;
    update assetTest;
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outputMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    options.put('assetId', assetTest.Id);
    Test.startTest();
      taSalesChangeTerminalInWarrantyHandler.invokeMethod('validationTimeDefenseConsumer', inputMap, outputMap, options);
    Test.stopTest();
  }

   public static testmethod void test4()
  {
    List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
    List<Product2> lstProduct2 = TestDataFactory.createProduct(1);
    Asset assetTest = new Asset();
    assetTest.Name = 'Test Asset';
    assetTest.AccountId = lstAccount[0].Id;
    assetTest.Product2Id =  lstProduct2[0].Id;
    lstProduct2[0].productCode = 'CHIPPRUEBA';
    update lstProduct2;
    insert assetTest;
    vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
      Name = 'Barrio Norte',
      vlocity_cmt__OrganizationId__c = lstAccount[0].Id,
      Status__c = 'Activo',
      Type__c = 'POS',
      Channel__c = 'Físico',
      Channel_Type__c = 'Agentes',
      Channel_Type_2__c = 'Agentes',
      Channel_Type_3__c = 'Agentes',
      vlocity_cmt__State__c = 'C',
      Region__c='AMBA');
    insert storeLocation;

        WorkTeam__c workTeamParent = new WorkTeam__c(
      Team_Name__c = 'Test Parent',
      Name = 'Test Parent');
        insert workTeamParent;

    WarrantyTimeLimit__c objTimeAnnul = new WarrantyTimeLimit__c();
    objTimeAnnul.Channel__c = 'Físico';
    objTimeAnnul.LocationCode__c = 'C';
    objTimeAnnul.Name = 'CABA_Fisico';
    objTimeAnnul.TimeLimit__c = 30.0;
    insert objTimeAnnul;

    User usernew = new user(ID = UserInfo.getUserID());
        String strIdUser = UserInfo.getUserID();

        String manager = UserInfo.getUserId();
        String parent = workTeamParent.Id;
        WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
    Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', UserInfo.getUserId(), null);
    List<Order>OrdList = TestDataFactory.createOrders(2,lstAccount[0]);
    OrdList[0].OriginStoreLocation__c = storeLocation.Id;
    OrdList[0].PaymentMethodType__c ='1001';
    OrdList[0].vlocity_cmt__OriginatingChannel__c ='Agentes';
    OrdList[0].Gestion__c = 'Venta';
    OrdList[0].Delivery_Method__c='Store Pick Up';
    OrdList[0].DeliveryDate__c  = System.today();
    OrdList[1].OriginStoreLocation__c = storeLocation.Id;
    OrdList[1].PaymentMethodType__c ='1001';
    OrdList[1].vlocity_cmt__OriginatingChannel__c ='Agentes';
    OrdList[1].Gestion__c = 'Venta';
    OrdList[1].Delivery_Method__c='Store Pick Up';
    OrdList[1].DeliveryDate__c  = System.today();
    update OrdList;
    List<OrderItem>OIList =TestDataFactory.createOrderItem(1,OrdList[0]);
    OIList[0].FromStock__c = 'MTPL';
    update OIList;
    List<OrderItem>OIList1 =TestDataFactory.createOrderItem(1,OrdList[1]);
    OIList1[0].FromStock__c = 'MTPL';
    update OIList1;
    assetTest.vlocity_cmt__OrderProductId__c = OIList[0].Id;
    update assetTest;
    Map<String, Object> inputMap = new Map<String, Object>();
    Map<String, Object> outputMap = new Map<String, Object>();
    Map<String, Object> options = new Map<String, Object>();
    options.put('assetId', assetTest.Id);
    Test.startTest();
      taSalesChangeTerminalInWarrantyHandler.invokeMethod('validationTimeDefenseConsumer', inputMap, outputMap, options);

    Test.stopTest();
  }
}