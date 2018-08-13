@isTest
private class AssetConciliatorTriggerTest {
	
	@isTest static void TestCaseUpdate() {
		
		 Map<String,Object> inputMap = new Map<String,Object>();
      Map<String,Object> outMap = new Map<String,Object>();
      Map<String,Object> options = new Map<String,Object>();

      AssetConciliator assetConciliator = new AssetConciliator();

      Case getCase = createCase ();
     
  		String orderId =  getCase.Order__c;
        Order orderTest = [SELECT Id, Gestion__c, Status, TrackingStatus__c FROM Order where Id = :orderId];

      Test.startTest();
       
        orderTest.TrackingStatus__c = 'READY_WC';
      
        Database.SaveResult result2 = Database.update(orderTest,false);
      Test.stopTest();


	}
	
  public static Account createAccount (){

      Account newAccountExample = new Account();
      newAccountExample.Name='New Account Test Conciliator';

      insert newAccountExample;
      return newAccountExample;
    }

    public static Asset createAsset(){

      Account accountExample = createAccount();
      Product2 prod = createProduct(1)[0];
      Contact contactExample = createContacts(accountExample);

      Asset newAssetExample = new Asset(Name='New Asset Test', Product2Id=prod.Id, AccountId=accountExample.Id, ContactId=contactExample.Id, MSISDN__c='1123568749');

      insert newAssetExample;
      return newAssetExample;
    }

    public static Case createCase(){

     Asset getAsset = createAsset();
     Order getOrder = createOrder(getAsset);


     Case newCaseExample = new Case(
      Subject='New Case Test Conciliator',
      AccountId = getAsset.AccountId,
      AssetId = getAsset.Id,
      Order__c = getOrder.Id,
      Status = 'Informada');

     insert newCaseExample;


     return newCaseExample;
   }

   public static Order createOrder (Asset assetTest){


    Contract contractExample = new Contract(Name='New Order Test Conciliator',StartDate=Date.Today(),Status = 'Draft', AccountId = assetTest.AccountId,  ContractTerm = 4);
    insert contractExample;

    vlocity_cmt__PriceList__c taPriceList = createPriceList('Telecom Price List');

    Order orderExample = new Order();
    orderExample.Name = 'test order conciliator';
    orderExample.AccountId = assetTest.AccountId;
    orderExample.ContractId = contractExample.Id;
    orderExample.Pricebook2Id =Test.getStandardPricebookId();
    orderExample.EffectiveDate = Date.Today();
    orderExample.Status = 'Draft';
    orderExample.vlocity_cmt__PriceListId__c=taPriceList.Id;
    orderExample.Delivery_Method__c = 'Presencial';
    orderExample.vlocity_cmt__OriginatingChannel__c='Agentes';   
    orderExample.TrackingStatus__c ='Inicial';
	orderExample.Gestion__c = 'Conciliate'; 

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


  public static Contact createContacts(Account acc){

   Contact newContact = new Contact(FirstName='firstNameTest',
                                    LastName='lastNameTest',
                                    AccountId=acc.Id);

    insert newContact;
   return newContact;

  }
	
}