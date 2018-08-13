@isTest
private class ta_techCare_communities_crtl_Test {
	
	@isTest static void ta_techCare_communities_crtl_Test() {		
		
		Account acc = TestDataFactory.createAccounts(1)[0];
		Asset asset = TestDataFactory.createAssets(1,acc)[0];
		Case caso = TestDataFactory.createCases(1,acc.Id, asset.Id,'nuevoCaso1')[0];
		Order orden = TestDataFactory.createOrders(1,acc)[0];
		caso.Order__c = orden.Id;
		update caso;

		ApexPages.StandardController sc = new ApexPages.StandardController(caso); 	             
  			ta_techCare_communities_controller commcontroller = new ta_techCare_communities_controller(sc);	  		
	    
	}

		@isTest static void ta_techCare_communities_crtl_Test1() {		
		
		
		Case caso = createCase1();
		

		ApexPages.StandardController sc = new ApexPages.StandardController(caso); 	             
  			ta_techCare_communities_controller commcontroller = new ta_techCare_communities_controller(sc);
  			commcontroller.noAceptar();		  		
	    
	}

	@isTest static void ta_techCare_communities_crtl_Test2() {		
		
		
		Case caso = createCase2();
		

		ApexPages.StandardController sc = new ApexPages.StandardController(caso); 	             
  			ta_techCare_communities_controller commcontroller = new ta_techCare_communities_controller(sc);
  			commcontroller.noAceptar();		  		
	    
	}

  @isTest static void ta_techCare_communities_crtl_Test3() {    
    
    
    Case caso = createCase1();
    

    ApexPages.StandardController sc = new ApexPages.StandardController(caso);                
        ta_techCare_communities_controller commcontroller = new ta_techCare_communities_controller(sc);
        commcontroller.aceptar();         
      
  }

  @isTest static void ta_techCare_communities_crtl_Test4() {    
    
    
    Case caso = createCase2();
    

    ApexPages.StandardController sc = new ApexPages.StandardController(caso);                
        ta_techCare_communities_controller commcontroller = new ta_techCare_communities_controller(sc);
        commcontroller.aceptar();         
      
  }


public static Account createAccount (){

      Account newAccountExample = new Account();
      newAccountExample.Name='New Account Test Conciliator';

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
  	Subject='New Case Test Conciliator',
  	AccountId = getAsset.AccountId,
  	AssetId = getAsset.Id,
  	Order__c = getOrder.Id,
  	SuppliedEmail = 'os@gmail.com',
	ContactId = getAsset.ContactId,
	Contact_Channel__c = 'Mail',			      
  	Status = 'Informada');

 	insert newCaseExample;


 	return newCaseExample;
   }

     public static Case createCase2(){

     Asset getAsset = createAsset2();
     Order getOrder = createOrder(getAsset);


     Case newCaseExample = new Case(
  	Subject='New Case Test Conciliator',
  	AccountId = getAsset.AccountId,
  	AssetId = getAsset.Id,
  	SuppliedPhone = '11989898989',
  	Order__c = getOrder.Id,
	ContactId = getAsset.ContactId,
	Contact_Channel__c = 'SMS',			      
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

  public static Case updateCase(Case existingCase){
		Id billingRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Technical_Service' AND SobjectType = 'Case' LIMIT 1].Id;
		existingCase.Status = 'En espera de ejecución';
     	existingCase.RecordTypeId = billingRecordTypeId;
		update existingCase;
		return existingCase;
	}

                                    
                                    

}