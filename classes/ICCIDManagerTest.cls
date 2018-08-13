@isTest
public with sharing class ICCIDManagerTest {
    
    @testSetup static void createDataTest(){

        MockupFactory.generate();

        TestDataFactory.createWorkTeam('Test');

        String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

        mockResponse = '{"listaResultado": [],"descripcionResultado": "Liberacion Exitosa","codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S101', mockResponse);
    }

    @isTest
    public static void serialAssignmentTest(){
        String mockResponse = '{"listaDeSeriados": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S094', mockResponse);

        mockResponse = '{"listaNumeroSerie": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S444', mockResponse);

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id FROM Order LIMIT 1];
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithStorePickUp(){
        String mockResponse = '{"listaDeSeriados": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S094', mockResponse);

        mockResponse = '{"listaNumeroSerie": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S444', mockResponse);

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        Map<String,Object> StockAvailableCode_Response = new Map<String,Object>();
        StockAvailableCode_Response.put('StockAvailableCode','StockAvailableCode');
        
        inputMap.put('StockAvailableCode_Response',StockAvailableCode_Response);
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithStorePickUpAndStockAvailableCodeNULL(){
        String mockResponse = '{"listaDeSeriados": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S094', mockResponse);

        mockResponse = '{"listaNumeroSerie": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S444', mockResponse);

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithIsTestListaDeSeriadosTestEmpty(){
        String mockResponse = '{"listaDeSeriados": []}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S094', mockResponse);

        mockResponse = '{"listaNumeroSerie": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"},{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444K","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S444', mockResponse);
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void serialAssignmentWithSimCard()
    {
        String mockResponse = '{"listaDeSeriados": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S094', mockResponse);

        mockResponse = '{"listaNumeroSerie": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S444', mockResponse);

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        
        OrderItem orderItem = [SELECT PricebookEntryId, vlocity_cmt__JSONAttribute__c FROM OrderItem LIMIT 1];
        orderItem.vlocity_cmt__JSONAttribute__c = '{"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pxWDUAY","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSIUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSJUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a1g6C000000ZUQ3QAO","attributeid__c":"a0G6C000000pwIvUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqDsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Nacional","id":10,"value":"N"},{"displayText":"Internacional","id":20,"value":"I"},{"displayText":"Tierra del Fuego","id":30,"value":"T"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSOUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SAP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SAP","id":20,"value":"SAP"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"SAP","id":20,"value":"SAP"},{"displayText":"Infotainment","id":30,"value":"Infotainment"}],"selectedItem":{"displayText":"SAP","id":20,"value":"SAP"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSNUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSMUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSSUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIgUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSPUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIlUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIqUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSRUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null}]}';
        update orderItem;
        
        PricebookEntry pricebookEntry = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id = :orderItem.PricebookEntryId];
        Product2 product = [SELECT vlocity_cmt__Type__c FROM Product2 WHERE Id = :pricebookEntry.Product2Id LIMIT 1];
        product.vlocity_cmt__Type__c = 'Simcard';
        update product;
        
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
            
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();        
    }
    
    @isTest
    public static void serialAssignmentWithSimCardAndSerial()
    {
        String mockResponse = '{"listaDeSeriados": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S094', mockResponse);

        mockResponse = '{"listaNumeroSerie": [{"imsi": "a1s5d4s587sd523","ubicacionPlantilla": "UP1","fechaIngresoPuntoVenta":"201709101145","ki": "ds000001d224a45015s983a21c34a3ds1","stockProducto": "MTCA","codDeposito": "1111","fechaAltaProducto": "201705091015","aduanaIngreso": "AI23","paisProcedencia": "Argentina","paisOrigen": "Brasil","anioImportacion": 2017,"codOrdenDespacho": "A1","numeroSerie": "A1B22C333D4444E","codNMU": "1234"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S444', mockResponse);

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        Account acc = [SELECT Id FROM Account LIMIT 1];
        vlocity_cmt__BusinessSite__c site = new vlocity_cmt__BusinessSite__c (vlocity_cmt__City__c = 'Tigre', PointOfSaleId__c = 1, vlocity_cmt__StreetAddress__c = 'Test', PointOfSaleAddressNumber__c = '1', vlocity_cmt__OrganizationId__c = acc.Id, PointOfSaleType__c  = 'LE');
        insert site;
        
        Order ord = [SELECT Id, Delivery_Method__c FROM Order LIMIT 1];
        ord.Delivery_Method__c = 'Store Pick Up';
        update ord;
        
        OrderItem orderItem = [SELECT PricebookEntryId, vlocity_cmt__JSONAttribute__c FROM OrderItem LIMIT 1];
        orderItem.vlocity_cmt__JSONAttribute__c = '{"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pxWDUAY","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSIUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSJUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a1g6C000000ZUQ3QAO","attributeid__c":"a0G6C000000pwIvUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqDsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Nacional","id":10,"value":"N"},{"displayText":"Internacional","id":20,"value":"I"},{"displayText":"Tierra del Fuego","id":30,"value":"T"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSOUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SAP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SAP","id":20,"value":"SAP"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"SAP","id":20,"value":"SAP"},{"displayText":"Infotainment","id":30,"value":"Infotainment"}],"selectedItem":{"displayText":"SAP","id":20,"value":"SAP"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSNUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSMUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSSUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIgUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSPUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIlUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIqUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSRUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null}]}';
        update orderItem;
        
        PricebookEntry pricebookEntry = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id = :orderItem.PricebookEntryId];
        Product2 product = [SELECT vlocity_cmt__Type__c, Name FROM Product2 WHERE Id = :pricebookEntry.Product2Id LIMIT 1];
        product.vlocity_cmt__Type__c = 'Simcard';
        product.Name = 'IsGetSimcardsSerialTest';
        update product;
        
        options.put('IdOrder', ord.Id);
        Map<String,Object> BillingOrderMap = new Map<String, Object>();
        BillingOrderMap.put('Channel', 'Agentes'  );
        inputMap.put('BillingOrder', BillingOrderMap);
        
        Map<String,Object> orderMap = new Map<String,Object>();
        orderMap.put('IdOrder',ord.Id);
        options.put('Order',orderMap);
      
        Test.startTest();
        ICCIDManager im = new ICCIDManager();
        im.invokeMethod('SerialAssingment', inputMap, outputMap, options);
        Test.stopTest();        
    }
    
    @isTest
    public static void SerialReAssingmentTest()
    {
        String mockResponse = '{"listaNumeroSeries":[{"codNMU":"codNMU","imsi":"imsi","aduanaIngreso":"aduanaIngreso","paisOrigen":"paisOrigen","codOrdenDespacho":"codOrdenDespacho","codDeposito":"codDeposito","stockProducto":"stockProducto","numeroSerie":"serial"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S095', mockResponse);
        
        String nameMethod = 'SerialReAssingment';
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        
        List<Object> serialList = new List<Object>();
        Map<String,Object> orderMap = new Map<String,Object>();

        Order order = [SELECT Id FROM Order LIMIT 1];
        OrderItem oItem = [SELECT Id FROM OrderItem WHERE orderId = :order.Id LIMIT 1];
        
        Map<String,Object> item1 = new Map<String,Object>();
        item1.put('validacionSerial','');
        item1.put('itemId',oItem.Id);
        item1.put('serial','serial');
        item1.put('serialValidado','serialValidado');
        item1.put('productName','productName');
        item1.put('productCode','productCode');
        item1.put('stockProducto','stockProducto');
        
        serialList.add(item1);
        orderMap.put('serialList',serialList);
        
        options.put('Order',orderMap);
        options.put('IdOrder',order.Id);
        
        Map<String,Object> billingOrder = new Map<String,Object>();
        billingOrder.put('Delivery_Method','Presencial');
        billingOrder.put('Channel','Agentes');
        
        inputMap.put('BillingOrder',billingOrder);
        
        ICCIDManager im = new ICCIDManager();
        
        Test.startTest();
        im.invokeMethod(nameMethod, inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void UpdateSalesInvoiceTest()
    {
        String nameMethod = 'UpdateSalesInvoice';
        
        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> outputMap = new Map<String, Object>();
        
        Id IdOrder = [SELECT Id FROM Order LIMIT 1].get(0).Id;
        
        options.put('IdOrder',IdOrder);
                
        ICCIDManager im = new ICCIDManager();
    
        Test.startTest();
        im.invokeMethod(nameMethod, inputMap, outputMap, options);
        Test.stopTest();
    }
    
    @isTest
    public static void setValuesOnJSON2Test()
    {
        String jsonString = '{"list":[{"attributedisplayname__c":"ICCID","attributeRunTimeInfo":{"value":"ICCID"}}]}';
        String iccid = 'iccid';
                
        ICCIDManager im = new ICCIDManager();

        Test.startTest();
        im.setValuesOnJSON2(jsonString, iccid);
        Test.stopTest();
    }

    @isTest
    public static void CreateWrapOrderItem(){
        ICCIDManager.WrapOrderItem orderItem = new ICCIDManager.WrapOrderItem('newICCID', 'newIMSI', 'newKI', 'newAduanaIngreso', 'newPaisOrigen', 'newCodOrdenDespacho', 'newStock', true);
    }
}