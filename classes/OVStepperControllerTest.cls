@isTest
private class OVStepperControllerTest {

  static testMethod void OVStepperController() {
  
      List<Account> accounts = TestDataFactory.createAccounts(1,'Consumer');
      vlocity_cmt__PriceList__c taPriceList = TestDataFactory.createPriceList('Telecom Price List');
      test.starttest();
      Order Ord = new order(Name='TestOrder',
                            AccountId=accounts[0].id,
                            EffectiveDate=Date.today(),
                            Status='Draft',
                            Pricebook2Id =Test.getStandardPricebookId(),
                            vlocity_cmt__PriceListId__c=taPriceList.Id);
      insert Ord ;
      ApexPages.StandardController sc = new ApexPages.StandardController(Ord);
      OVStepperController OVS = new OVStepperController(sc);
       test.stoptest();
       }
 }