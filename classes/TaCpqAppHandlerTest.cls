@isTest(seeAllData = false)
global class TaCpqAppHandlerTest {

    @isTest
    static void TestGetCartsProducts_NoQuery() {
        System.debug('TestGetCartsProducts_NoQuery');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);
        
        String mockResponse = '{"listaExistencias":[{"listaPorCodigoStock":[{"cantidadDisponible":"1","cantidadExistente":"1","stockProducto":"MTPL"}],"codDeposito":"CA0001001","codFamiliaProducto":"GDAL","marcaProducto":"SI","codNMU":"BSI0A76AK"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S089', mockResponse);
        
        MockupFactory.generate();
        taCpqAppHandler appHandler = new taCpqAppHandler();
        Map<String, Object> outMap = new Map<String, Object>();
        Order order = [SELECT Id FROM Order LIMIT 1];
        System.debug('order: ' + order);
        //String prefeasibilityResult = TaCpqAppHandlerInputMapFactoryTest.createPrefeasibilityJson();
        //order.vlocity_cmt__ValidationMessage__c = '1234567890';
        //order.PrefeasibilityResult__c = prefeasibilityResult;
        //update order;

        
        List<Product2> listProductos = [SELECT Id FROM Product2 LIMIT 1];
        Id pricebookId = Test.getStandardPricebookId();
        List<PriceBookEntry> entriesToUpdate = new List<PriceBookEntry>();
        List<PriceBookEntry> entries = [SELECT Product2Id, vlocity_cmt__RecurringPrice__c, UnitPrice, OneTime_Price_w_o_VAT__c FROM PriceBookEntry ];
        for(PriceBookEntry entry: entries){
            entry.vlocity_cmt__RecurringPrice__c = 10;
            entriesToUpdate.add(entry);
            System.debug('Entry to update: ' + entry);
        }
        
        update entriesToUpdate;

        Map<String, Object> inputMap = TaCpqAppHandlerInputMapFactoryTest.generateInputMap();
        inputMap.put('cartId', order.Id);
        inputMap.put('query','');
      
        Test.startTest();
        appHandler.invokeMethod('getCartsProducts', inputMap, outMap, null);
        Test.stopTest();
        
        system.debug('CPQ App Handler outMap: '+outMap);
    }

    @isTest
    static void TestGetCartsProducts_WithQuery() {
        System.debug('TestGetCartsProducts_WithQuery');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);
        
        String mockResponse = '{"listaExistencias":[{"listaPorCodigoStock":[{"cantidadDisponible":"1","cantidadExistente":"1","stockProducto":"MTPL"}],"codDeposito":"CA0001001","codFamiliaProducto":"GDAL","marcaProducto":"SI","codNMU":"BSI0A76AK"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S089', mockResponse);
        
        MockupFactory.generate();
        taCpqAppHandler appHandler = new taCpqAppHandler();
        Map<String, Object> outMap = new Map<String, Object>();
        Order order = [SELECT Id FROM Order LIMIT 1];
        System.debug('order: ' + order);
        
        Map<String, Object> inputMap = TaCpqAppHandlerInputMapFactoryTest.generateInputMap();
        inputMap.put('cartId', order.Id);
        inputMap.put('query','SAMSUNG');
      
        Test.startTest();
        appHandler.invokeMethod('getCartsProducts', inputMap, outMap, null);
        Test.stopTest();
        
        system.debug('CPQ App Handler outMap: '+outMap);
    }

    @isTest
    static void TestGetCartsProducts_NullQuery() {
        System.debug('TestGetCartsProducts_NullQuery');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);
        
        String mockResponse = '{"listaExistencias":[{"listaPorCodigoStock":[{"cantidadDisponible":"1","cantidadExistente":"1","stockProducto":"MTPL"}],"codDeposito":"CA0001001","codFamiliaProducto":"GDAL","marcaProducto":"SI","codNMU":"BSI0A76AK"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S089', mockResponse);
        
        MockupFactory.generate();
        taCpqAppHandler appHandler = new taCpqAppHandler();
        Map<String, Object> outMap = new Map<String, Object>();
        Order order = [SELECT Id FROM Order LIMIT 1];
        System.debug('order: ' + order);
        
        Map<String, Object> inputMap = TaCpqAppHandlerInputMapFactoryTest.generateInputMap();
        inputMap.put('cartId', order.Id);
        inputMap.put('query',null);
      
        Test.startTest();
        appHandler.invokeMethod('getCartsProducts', inputMap, outMap, null);
        Test.stopTest();
        
        system.debug('CPQ App Handler outMap: '+outMap);
    }

    @isTest
    static void TestFilterQuery() {
        System.debug('TestFilterQuery');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);
        
        String mockResponse = '{"listaExistencias":[{"listaPorCodigoStock":[{"cantidadDisponible":"1","cantidadExistente":"1","stockProducto":"MTPL"}],"codDeposito":"CA0001001","codFamiliaProducto":"GDAL","marcaProducto":"SI","codNMU":"BSI0A76AK"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S089', mockResponse);
        
        MockupFactory.generate();
        Order order = [SELECT Id FROM Order LIMIT 1];
        Map<String, Object> inputMap = TaCpqAppHandlerInputMapFactoryTest.generateInputMap();
        Map<String, Object> outMap = new Map<String, Object>();
        inputMap.put('cartId', order.Id);
        inputMap.put('query','a');
        vlocity_cmt.CpqAppHandler cpqAppHandler = new vlocity_cmt.CpqAppHandler();
                Object cpqAppHandlerReturn = cpqAppHandler.invokeMethod('getCartsProducts', inputMap, outMap, null);
            system.debug('outMap: ' + outMap);
            vlocity_cmt.JSONResult result = (vlocity_cmt.JSONResult)outMap.get(vlocity_cmt.JSONResult.JSON_KEY_RESULT);
            List<vlocity_cmt.JSONRecord> pbeList  =  (List<vlocity_cmt.JSONRecord>)result.records;

        vlocity_cmt.JSONRecord p = pbeList[0];

        System.debug('order: ' + order);
      
        Test.startTest();
        tacpqAppHandler tacpqAppHandlerobj = new tacpqAppHandler();
        Boolean asdf = tacpqAppHandlerobj.filterRecord(p,'a');
        Test.stopTest();
        
        system.debug('CPQ App Handler outMap: '+outMap);
    }
    /*
    @isTest
    static void TestGetCartsProductsById() {
        System.debug('TestGetCartsProductsById');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);
        
        String mockResponse = '{"listaExistencias":[{"listaPorCodigoStock":[{"cantidadDisponible":"1","cantidadExistente":"1","stockProducto":"MTPL"}],"codDeposito":"CA0001001","codFamiliaProducto":"GDAL","marcaProducto":"SI","codNMU":"BSI0A76AK"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S089', mockResponse);
        
        MockupFactory.generate();
        taCpqAppHandler appHandler = new taCpqAppHandler();
        Map<String, Object> outMap = new Map<String, Object>();
        Order order = [SELECT Id FROM Order LIMIT 1];
        System.debug('order: ' + order);
        
        Map<String, Object> inputMap = TaCpqAppHandlerInputMapFactoryTest.generateInputMap();
        inputMap.put('cartId', order.Id);
      
        Test.startTest();
        appHandler.invokeMethod('getCartsProductsById', inputMap, outMap, null);
        Test.stopTest();
        
        system.debug('CPQ App Handler outMap: '+outMap);
    }
    */

    @isTest
    static void TestCreateOrder() {
        System.debug('TestCreateOrder');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);
        
        MockupFactory.generate();

        List<Map<String, Object>> inputFields = new List<Map<String, Object>>();
        Map<String, Object> aux = new Map<String, Object>();
        aux.put('effectivedate', Date.today());
        inputFields.add(aux);

        Map<String, Object> aux1 = new Map<String, Object>();
        aux1.put('status', 'Draft');
        inputFields.add(aux1);

        Map<String, Object> aux2 = new Map<String, Object>();
        aux2.put('Name', 'Telus');
        inputFields.add(aux2);

        Account acc = [SELECT Id FROM Account LIMIT 1];
        Map<String, Object> aux3 = new Map<String, Object>();
        aux3.put('AccountId', acc.Id);
        inputFields.add(aux3);
      
        Test.startTest();
        String idOrder = taCpqAppHandler.CreateOrder(inputFields);
        Test.stopTest();
        
        system.assertNotEquals(null, idOrder);
    }
    
    @isTest
    static void TestAddOrderItem() {
        System.debug('TestAddOrderItem');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);     
        MockupFactory.generate();

        //PricebookEntry pbEntry = [SELECT Id FROM PricebookEntry LIMIT 1];

        List<Product2> listProductos = [SELECT Id FROM Product2 LIMIT 1];
        System.debug('listProductos: ' + listProductos);
        Id pricebookId = Test.getStandardPricebookId();
        List<PricebookEntry> listPricebookEntry = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :pricebookId AND Product2Id = :listProductos[0].Id];
        System.debug('listPricebookEntry: ' + listPricebookEntry);

        Order order = [SELECT Id FROM Order LIMIT 1];
      
        Test.startTest();
        //String response = taCpqAppHandler.AddItemToOrder(pbEntry.Id, order.Id);
        String response = taCpqAppHandler.AddItemToOrder(listPricebookEntry[0].Id, order.Id);
        Test.stopTest();
        
        system.assertEquals(null, response);
    }

    @isTest
    static void TestRemoveOrderItem() {
        System.debug('TestRemoveOrderItem');
        vlocity_cmt__CpqConfigurationSetup__c mySetting = new vlocity_cmt__CpqConfigurationSetup__c(Name='CacheEnabled', vlocity_cmt__SetupValue__c='false');
        vlocity_cmt__CpqConfigurationSetup__c mySetting2 = new vlocity_cmt__CpqConfigurationSetup__c(Name='ContextRulesEnabled', vlocity_cmt__SetupValue__c='false');
        insert mySetting;
        insert mySetting2;
        
        vlocity_cmt__CustomClassImplementation__c customClassImplementation = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductAvailabilityOpen',vlocity_cmt__ClassName__c='DefaultAvailabilityOpenImplementation');
        vlocity_cmt__CustomClassImplementation__c customClassImplementation1 = new vlocity_cmt__CustomClassImplementation__c
        (Name='ProductEligibilityOpen',vlocity_cmt__ClassName__c='DefaultEligibilityOpenImplementation');
        insert customClassImplementation;
        insert customClassImplementation1;
        Id usId = userinfo.getUserId();
        TestDataFactory.setTeamMember('Test', usId, null);        
        MockupFactory.generate();

        Order order = [SELECT Id FROM Order LIMIT 1];
        OrderItem item = [SELECT Id FROM OrderItem WHERE OrderId = :order.Id LIMIT 1];

        Test.startTest();
        Boolean response = taCpqAppHandler.RemoveOrderItem(item.Id, order.Id);
        Test.stopTest();
        
        system.assertEquals(false, response);
    }

    @isTest
    static void TestNullCall() {
        System.debug('TestNullCall');
        taCpqAppHandler appHandler = new taCpqAppHandler();
        Map<String, Object> outMap = new Map<String, Object>();
        MockupFactory.generate();
      
        Map<String, Object> inputMap = TaCpqAppHandlerInputMapFactoryTest.generateInputMap();
        inputMap.put('cartId', order.Id);
        inputMap.put('query','SAMSUNG');
      
        Test.startTest();
        Boolean result = appHandler.invokeMethod(null, inputMap, outMap, null);
        Test.stopTest();
        
        system.assertEquals(false, result);
    }
}