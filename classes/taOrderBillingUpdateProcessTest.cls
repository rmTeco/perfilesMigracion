@isTest
public class taOrderBillingUpdateProcessTest
{
  static testMethod void Test1()
  {
    List<Order> lstOrder = new List<Order>();
    List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
    vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default');
    insert StoreLocations;
    FinancialPromotions__c Promo1 = new FinancialPromotions__c(Name='Promo1',Creditcard_Type__c='403', Bank_Code__c='1', Instalments__c='1', CFT__c='test');
    insert Promo1;
    TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
    List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
    OrdList[0].PaymentMethodType__c ='1001';
    OrdList[0].vlocity_cmt__OriginatingChannel__c ='Presencial Oficina Comercial';
    OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
    OrdList[1].vlocity_cmt__OriginatingChannel__c ='Presencial Oficina Comercial';
    OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
    update OrdList;
    List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
    List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
    //generateMockupData();
    Test.startTest();
      Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());
      taOrderBillingUpdateProcess.BillUpdateOrder(OrdList[0].Id);
    Test.stopTest();
  }
    static testMethod void Test2()
    {
      List<Order> lstOrder = new List<Order>();
      List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
      vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default');
      insert StoreLocations;
      StoreLocations.Channel_Type_3__c = 'Agentes';
      StoreLocations.Channel_Type_2__c = 'Agentes';
      StoreLocations.Channel_Type__c = 'Agentes';
      update StoreLocations;
      FinancialPromotions__c Promo1 = new FinancialPromotions__c(Name='Promo1',Creditcard_Type__c='403', Bank_Code__c='1', Instalments__c='1', CFT__c='test');
      insert Promo1;
      TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
      List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
      OrdList[0].PaymentMethodType__c ='1001';
      OrdList[0].vlocity_cmt__OriginatingChannel__c ='Agentes';
      OrdList[0].OriginStoreLocation__c = StoreLocations.id;
      OrdList[1].vlocity_cmt__OriginatingChannel__c ='Agentes';
      OrdList[1].OriginStoreLocation__c = StoreLocations.id;
      update OrdList;
      List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
      List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
      //generateMockupData();
      Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());
        taOrderBillingUpdateProcess.BillUpdateOrder(OrdList[0].Id);
      Test.stopTest();
      }
      static testMethod void Test3()
      {
        List<Order> lstOrder = new List<Order>();
        List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default');
        insert StoreLocations;
        StoreLocations.Channel_Type_3__c = 'Agentes';
        StoreLocations.Channel_Type_2__c = 'Agentes';
        StoreLocations.Channel_Type__c = 'Agentes';
        update StoreLocations;
        FinancialPromotions__c Promo1 = new FinancialPromotions__c(Name='Promo1',Creditcard_Type__c='403', Bank_Code__c='1', Instalments__c='1', CFT__c='test');
        insert Promo1;
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
        OrdList[0].PaymentMethodType__c ='1001';
        OrdList[0].vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[0].OriginStoreLocation__c = StoreLocations.id;
        OrdList[0].Delivery_Method__c = 'Store Pick Up';
        OrdList[1].vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[1].OriginStoreLocation__c = StoreLocations.id;
        OrdList[1].Delivery_Method__c = 'Store Pick Up';
        update OrdList;
        List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
        List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
        //generateMockupData();
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());
          taOrderBillingUpdateProcess.BillUpdateOrder(OrdList[0].Id);
        Test.stopTest();
      }
}