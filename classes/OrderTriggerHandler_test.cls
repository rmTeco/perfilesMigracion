@isTest
public class OrderTriggerHandler_test
{
  static testmethod void testOrder1()
  {
      //MockupFactory.generate();
      //vlocity_cmt__PriceList__c objPrice = [select Name, vlocity_cmt__Code__c, Id from vlocity_cmt__PriceList__c limit 1];
      Order objOrder = new Order();
      List<Account> AccList = TestDataFactory.createAccounts(1);
      objOrder.AccountId = AccList[0].Id;
      objOrder.Status = 'Draft';
      objOrder.EffectiveDate = Date.today();
      objOrder.vlocity_cmt__OriginatingChannel__c = 'WEB';
      objOrder.Delivery_Method__c = 'Delivery';
      insert objOrder;
      Map<String,Object> inputMap = new Map<String,Object>();
      Map<String,Object> outMap = new Map<String,Object>();
      Map<String,Object> options = new Map<String,Object>();
    }
    static testmethod void testOrder2()
    {
        List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
        insert StoreLocations;
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
        OrdList[0]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[0].Delivery_Method__c ='Store Pick Up';
        OrdList[0].Status = 'Activated';
        OrdList[0].Gestion__c = 'Venta';
        OrdList[1]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[1].Delivery_Method__c ='Store Pick Up';
        OrdList[1].Status = 'Activated';
        OrdList[1].Gestion__c = 'Venta';
        List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
        List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
        list<product2> lstProd = [select id,vlocity_cmt__Type__c from product2];
        for(product2 objProd : lstProd)
        {
          objProd.vlocity_cmt__Type__c = 'Dispositivo';
          update objProd;
        }
        update OrdList;
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf('Unit Test Attachment Body');
        attachment.Name = String.valueOf('test.png');
        List<order> lstorderId = [select id from Order];
        Set<Id> setorderId = new Set<Id>();
        for(Order objOrder: lstorderId)
        {
          attachment.ParentId = objOrder.Id;
          setorderId.add(objOrder.Id);
        }
        insert attachment;
        List<Attachment> attachments=[select id,name from Attachment where parent.id IN :setorderId];
        System.assertEquals(1, attachments.size());

    }
    static testmethod void testOrder3()
    {
        List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
        insert StoreLocations;
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
        OrdList[0]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[0].Delivery_Method__c ='Store Pick Up';
        OrdList[0].Status = 'Activated';
        OrdList[0].Gestion__c = 'Venta';
        OrdList[1]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[1].Delivery_Method__c ='Store Pick Up';
        OrdList[1].Status = 'Activated';
        OrdList[1].Gestion__c = 'Venta';
        List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
        List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
        list<product2> lstProd = [select id,vlocity_cmt__Type__c from product2];
        for(product2 objProd : lstProd)
        {
          objProd.vlocity_cmt__Type__c = 'Simcard';
          update objProd;
        }
        update OrdList;
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf('Unit Test Attachment Body');
        attachment.Name = String.valueOf('test.png');
        List<order> lstorderId = [select id from Order];
        Set<Id> setorderId = new Set<Id>();
        for(Order objOrder: lstorderId)
        {
          attachment.ParentId = objOrder.Id;
          setorderId.add(objOrder.Id);
        }
        insert attachment;
        List<Attachment> attachments=[select id,name from Attachment where parent.id IN :setorderId];
        System.assertEquals(1, attachments.size());

    }
    static testmethod void testOrder4()
    {
        List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
        insert StoreLocations;
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
        OrdList[0]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[0].Delivery_Method__c ='Store Pick Up';
        OrdList[0].Status = 'Activated';
        OrdList[0].Gestion__c = 'Venta';
        OrdList[1]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[1].Delivery_Method__c ='Store Pick Up';
        OrdList[1].Status = 'Activated';
        OrdList[1].Gestion__c = 'Venta';
        List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
        List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
        list<product2> lstProd = [select id,vlocity_cmt__Type__c from product2];
        for(product2 objProd : lstProd)
        {
          objProd.vlocity_cmt__Type__c = 'Mobile';
          update objProd;
        }
        update OrdList;
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf('Unit Test Attachment Body');
        attachment.Name = String.valueOf('test.png');
        List<order> lstorderId = [select id from Order];
        Set<Id> setorderId = new Set<Id>();
        for(Order objOrder: lstorderId)
        {
          attachment.ParentId = objOrder.Id;
          setorderId.add(objOrder.Id);
        }
        insert attachment;
        List<Attachment> attachments=[select id,name from Attachment where parent.id IN :setorderId];
        System.assertEquals(1, attachments.size());
    }
    static testmethod void testOrder5()
    {
        List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
        insert StoreLocations;
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
        OrdList[0]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[0].Delivery_Method__c ='Store Pick Up';
        OrdList[0].Status = 'Activated';
        OrdList[0].Gestion__c = 'Venta';
        OrdList[1]. vlocity_cmt__OriginatingChannel__c ='Agentes';
        OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
        OrdList[1].Delivery_Method__c ='Store Pick Up';
        OrdList[1].Status = 'Activated';
        OrdList[1].Gestion__c = 'Venta';
        List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
        List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
        list<product2> lstProd = [select id,vlocity_cmt__Type__c from product2];
        for(product2 objProd : lstProd)
        {
          objProd.vlocity_cmt__Type__c = 'Mobile';
          update objProd;
        }
        update OrdList;
        Attachment attachment = new Attachment();
        attachment.Body = Blob.valueOf('Unit Test Attachment Body');
        attachment.Name = String.valueOf('test.png');
        List<order> lstorderId = [select id from Order];
        Set<Id> setorderId = new Set<Id>();
        for(Order objOrder: lstorderId)
        {
          attachment.ParentId = objOrder.Id;
          setorderId.add(objOrder.Id);
        }
        insert attachment;
        List<Attachment> attachments=[select id,name from Attachment where parent.id IN :setorderId];
        System.assertEquals(1, attachments.size());
    }

    static testmethod void testOrder6()
    {

        List<Account> accountList = TestDataFactory.createAccounts(1);

        Order orderTest = new Order();
            orderTest.Name = 'test order conciliator';
            orderTest.AccountId =  accountList[0].Id;
            orderTest.EffectiveDate = Date.Today();
            orderTest.Status = 'Draft';
            orderTest.Delivery_Method__c = 'Presencial';
            orderTest.vlocity_cmt__OriginatingChannel__c='Agentes';   
            orderTest.TrackingStatus__c ='Inicial';
            orderTest.Gestion__c = 'Conciliate'; 
        insert orderTest;
    
        List<Asset> assetList = TestDataFactory.createAssets(1, accountList[0], '1122336655');
  
        Case newCaseExample = new Case(
            Subject='New Case Test Conciliator',
            AccountId = accountList[0].Id,
            AssetId =  assetList[0].Id,
            Order__c = orderTest.Id,
            Status = 'Informada');
        insert newCaseExample;

        orderTest.TrackingStatus__c ='READY_WC';
     update orderTest;

    }    
}