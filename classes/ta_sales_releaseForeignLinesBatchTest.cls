@IsTest(SeeAllData=false)
public class ta_sales_releaseForeignLinesBatchTest
{
  public static void cargaDatos()
  {
      MockupFactory.generate();

    //Account
    List<Account> accts = new List<Account>();
    Account a = new Account();
    a.Name='TestAccount' + Math.round(Math.random()*10000);
    a.AccountIntegrationId__c = String.ValueOf(Decimal.valueOf('10000000000')+Datetime.now().millisecond());
    a.CustomerIntegrationId__c = Decimal.valueOf('10000000001')+Datetime.now().millisecond();
    system.debug('AccountIntegrationId__c = '+a.AccountIntegrationId__c);
    accts.add(a);
    insert accts;
    //Product
    List<Product2> prods = new List<Product2>();
    //Pricebook2 pb = TestDataFactory.createPriceBook('TA Price Book');
    for(Integer i=0;i < 3;i++)
    {
      Product2 product = new Product2(Name='TestProduct '+i, ProductCode='TestProductCode', Tangible__c = true, vlocity_cmt__Type__c='TestType');
      prods.add(product);
    }
    insert prods;
    //Order
    List<Order> orders = new List<Order>();
    //vlocity_cmt__PriceList__c taPriceList = TestDataFactory.createPriceList('Telecom Price List');

    List<vlocity_cmt__PriceList__c> taPrices = new List<vlocity_cmt__PriceList__c>();
    taPrices = [select id, name from vlocity_cmt__PriceList__c where name= 'Telecom Price List' LIMIT 1];
    vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c();
    taPriceList=taPrices[0];

    for(Integer i=0;i<2;i++)
    {
      Order o = new Order(Name='TestOrder' + i,
                AccountId=accts[0].Id,
                EffectiveDate=Date.today(),
                Status='Draft',
                Pricebook2Id =Test.getStandardPricebookId(),
                vlocity_cmt__PriceListId__c= taPriceList.Id,
                Delivery_Method__c='Delivery',
                vlocity_cmt__OriginatingChannel__c='Agentes',
                DateTime_Sent_S029__c=Datetime.now());
      orders.add(o);
    }
    insert orders;
    //Contact
    Contact cont = new Contact(LastName ='TestName', AccountId = accts[0].Id,PermanencyDueDate__c = Date.newInstance(2018,2,27),DocumentType__c = 'PAS');
    insert cont;
    //Asset
    Asset asse = new Asset(Name='TestAsset', Product2Id=prods[0].Id, AccountId=accts[0].Id, MSISDN__c='test', ContactId = cont.Id);
    insert asse;
    pricebook2 pb = new Pricebook2 (id=Test.getStandardPricebookId(), isActive=true);
    update pb;
    //Pricebook2 pb = [SELECT Id, Name, IsActive FROM PriceBook2 where isActive= true LIMIT 1];
    PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = prods[0].Id, UnitPrice = 1000, IsActive = true);
    insert standardPBE;
  }
   static testmethod void test()
  {
    cargaDatos();
    Test.startTest();
      ta_sales_releaseForeignLinesBatch taSalesRealease = new ta_sales_releaseForeignLinesBatch();
      String sch = '0 0 23 * * ?';
      System.schedule('TestSales Realease Line', sch, taSalesRealease);
    Test.stopTest();
  }
}