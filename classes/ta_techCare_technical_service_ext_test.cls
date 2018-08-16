@isTest
private class ta_techCare_technical_service_ext_test {
  
  @isTest 
  static void test_ta_techCare_technical_service_ext_ctrl() {

    Account acc = TestDataFactory.createAccounts(1)[0];
    Asset asset = TestDataFactory.createAssets(1,acc)[0];
    Case caso = TestDataFactory.createCases(1,acc.Id, asset.Id,'testCase')[0];
    Order orden = TestDataFactory.createOrders(1,acc)[0];
    caso.Order__c = orden.Id;
    update caso;

    ApexPages.StandardController sc = new ApexPages.StandardController(caso);
    ta_techCare_technical_service_ext_ctrl testTech = new ta_techCare_technical_service_ext_ctrl(sc);
  }

}