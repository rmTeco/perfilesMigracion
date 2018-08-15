@isTest(seeAllData = false)
public with sharing class StockUtilsTest {

    @TestSetup
    static void setup() {
        MockupFactory.generate();
        Order order = [SELECT Id FROM Order LIMIT 1];
        List<OrderItem> orderItems = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id];
        for (OrderItem orderItem : orderItems) {
            orderItem.vlocity_cmt__SerialNumber__c = 'algo';
        }
        update orderItems;
    }

    static testMethod void stockMovementTest() {
        Order order = [SELECT Id FROM Order LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        StockUtils.StockMovement(order.Id, 'codOperacion', 'codDeposito');
        Test.stopTest();

    }

    @isTest
      static void StockMovementTest2()
      {
        Map<String,Object> mapSerialNumber = new Map<String,Object>();
        Map<String, Object> serial = new Map<String, Object>();
        serial.put('codOperacion', 'operacion');
        serial.put('codDeposito', 'deposito');
        mapSerialNumber.put('1111111', serial);
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          StockUtils.StockMovement(mapSerialNumber);
        Test.stopTest();
      }

    static testMethod void stockMovementErrorTest() {
        Order order = [SELECT Id FROM Order LIMIT 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseErrorGenerator());
        try
        {
            StockUtils.StockMovement(order.Id, 'codOperacion', 'codDeposito');
        }
        catch (CallOutException e)
        {
            System.assert(e.getMessage().contains('Error en el llamado al servicio') ? true : false);
        }
        Test.stopTest();
    }
    
    
      @isTest
      static void StockMovementTest3()
      {
        List<String> listSerials = new List<String>();
        listSerials.add('1111111');
        Test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          StockUtils.StockMovement(listSerials, 'codOperacion', 'codDeposito');
        Test.stopTest();
      }
}