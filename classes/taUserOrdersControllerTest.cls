@isTest(seeAllData = false)
public with sharing class taUserOrdersControllerTest {

  @isTest
  static void getOrdersTestOK(){
    TestDataFactory.createOrders(1, TestDataFactory.createAccounts(1)[0]);

    Test.startTest();
    TaUserOrdersController ctrl = new TaUserOrdersController();
    List<Order> lstOrders = ctrl.getOrders();
    Test.stopTest();

    System.assertEquals(1, lstOrders.size());
  }
}