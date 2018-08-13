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

    @isTest
    static void stockMovementTest() {
        String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

        Order order = [SELECT Id FROM Order LIMIT 1];
        Test.startTest();
        StockUtils.StockMovement(order.Id, 'codOperacion', 'codDeposito');
        Test.stopTest();

    }

    @isTest
      static void StockMovementTest2()
      {
        String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

        Map<String,Object> mapSerialNumber = new Map<String,Object>();
        Map<String, Object> serial = new Map<String, Object>();
        serial.put('codOperacion', 'operacion');
        serial.put('codDeposito', 'deposito');
        mapSerialNumber.put('1111111', serial);
        Test.startTest();
          StockUtils.StockMovement(mapSerialNumber);
        Test.stopTest();
      }
    
      @isTest
      static void StockMovementTest3()
      {
        String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

        List<String> listSerials = new List<String>();
        listSerials.add('1111111');
        Test.startTest();
          StockUtils.StockMovement(listSerials, 'codOperacion', 'codDeposito');
        Test.stopTest();
      }

      @isTest
        static void stockMovementErrorTest() {
        String mockResponse = '{"listaResultado":[{"mensajeResultado": "Error al mover el serial","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "ERROR"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

        List<String> listSerials = new List<String>();
        listSerials.add('1111111');
        Test.startTest();
        try
        {
            StockUtils.StockMovement(listSerials, 'codOperacion', 'codDeposito');
        }
        catch (CallOutException e)
        {
            System.assert(e.getMessage().contains('Error al invocar al servicio 105') ? true : false);
        }
        Test.stopTest();
    }

    @isTest
    static void stockMovementErrorTest2() {
        String mockResponse = '{"listaResultado":[{"mensajeResultado": "NOK","codigoResultado": "10","numeroSerie": "99543410307677114097"}],"codigoResultado": "NOK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

        Map<String,Object> mapSerialNumber = new Map<String,Object>();
        Map<String, Object> serial = new Map<String, Object>();
        serial.put('codOperacion', 'operacion');
        serial.put('codDeposito', 'deposito');
        mapSerialNumber.put('1111111', serial);
        Test.startTest();
        try
        {
            StockUtils.StockMovement(mapSerialNumber);
        }
        catch (CallOutException e)
        {
            System.assert(e.getMessage().contains('Error al invocar al servicio 105') ? true : false);
        }
        Test.stopTest();
    }

    @isTest
    static void stockMovementErrorTest3() {
        String mockResponse = '{"listaResultado":[{"mensajeResultado": "NOK","codigoResultado": "10","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

        Map<String,Object> mapSerialNumber = new Map<String,Object>();
        Map<String, Object> serial = new Map<String, Object>();
        serial.put('codOperacion', 'operacion');
        serial.put('codDeposito', 'deposito');
        mapSerialNumber.put('1111111', serial);
        Test.startTest();
        try
        {
            StockUtils.StockMovement(mapSerialNumber);
        }
        catch (CallOutException e)
        {
            System.assert(e.getMessage().contains('Error al invocar al servicio 105') ? true : false);
        }
        Test.stopTest();
    }

      @isTest
      static void StockQuantityManagement_Test_Ok()
      {
        String mockResponse = '{"listaResultado": [],"descripcionResultado": "Liberacion Exitosa","codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S101', mockResponse);

        Map<String, Map<String, Object>> nmus = new Map<String, Map<String, Object>>();
        Map<String, Object> nmu = new Map<String, Object>();
        nmu.put('codDeposito','codDeposito');
        nmu.put('codNMU','PEPE');
        nmu.put('cantidad','cantidad');
        nmus.put('PEPE',nmu);

        Test.startTest();
          StockUtils.StockQuantityManagement(nmus, 'orderId', 'serviceOperation');
        Test.stopTest();
      }

      @isTest
      static void StockQuantityManagement_Test_NOk()
      {
        String mockResponse = '{"listaResultado": [],"descripcionResultado": "Falla el servicio","codigoResultado": "NOK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S101', mockResponse);

        Map<String, Map<String, Object>> nmus = new Map<String, Map<String, Object>>();

        Test.startTest();
        try
        {
            StockUtils.StockQuantityManagement(nmus, 'orderId', 'serviceOperation');
        }
        catch (CallOutException e)
        {
            System.assert(e.getMessage().contains('Error al invocar al servicio 101') ? true : false);
        }
        Test.stopTest();
      }
}