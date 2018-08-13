@isTest(seeAllData = false)
public class LinesManagerTest {
    
    static testMethod void TestGetLinesWithLine() {
        LinesManager lineManager = new LinesManager();
        Map<String, Object> outMap = new Map<String, Object>();

        CpqMobileNumbering__c mobileNumberingSetting = new CpqMobileNumbering__c();
        mobileNumberingSetting.Name='Default';
        insert mobileNumberingSetting;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());
        Map<String,Object> inputMap = LinesManagerInputMapFactoryTest.generateInputMap();
        System.debug('>>>>> inputMap Options +++++ ' + inputMap);
        Map<String,Object> options = new Map<String,Object> ();
        Map<String,Object> Order = (Map<String, Object>)inputMap.get('Order');
        options.put('Account',inputMap.get('Account'));
        options.put('Order',Order);
        lineManager.invokeMethod('GetLines', inputMap, outMap, options);
        System.debug('>>>>> outMap Options +++++ ' + outMap);
	    Test.stopTest(); 
        
        Map<String,Object> optionsMap = (Map<String,Object>) outMap.get('options');
		System.debug('>>>>> +++++ ' + optionsMap);        
        List<Object> planesList = (List<Object>) optionsMap.get('planes');
        Map<String,Object> planesMap = (Map<String,Object>) planesList[0];

		List<Object> lineasList = (List<Object>) planesMap.get('lineas'); 
        Map<String,Object> lineaMap = (Map<String,Object>) lineasList[0];
        
		system.assertEquals(true, optionsMap.get('lineasReservadas'));
        system.assertEquals(true, lineaMap.get('isSelected'));
        system.assertEquals('1148745678', lineaMap.get('linea'));
        system.assertEquals(null, lineaMap.get('validacionLinea'));
        system.assertEquals('SomeRandomValues', lineaMap.get('location'));
    }
    
    static testMethod void TestGetLinesWithNoLine() {
        LinesManager lineManager = new LinesManager();
        Map<String, Object> outMap = new Map<String, Object>();

        CpqMobileNumbering__c mobileNumberingSetting = new CpqMobileNumbering__c();
        mobileNumberingSetting.Name='Default';
        insert mobileNumberingSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());

        Map<String,Object> inputMap =LinesManagerInputMapFactoryTest.generateInputMap();
        Map<String,Object> options = new Map<String,Object> ();
        Map<String,Object> Order = (Map<String, Object>)inputMap.get('Order');
        options.put('Account',inputMap.get('Account'));
        options.put('Order',Order);

        lineManager.invokeMethod('GetLines', inputMap, outMap, options);
		Test.stopTest();        
        
        
        Map<String,Object> optionsMap = (Map<String,Object>) outMap.get('options');

        List<Object> planesList = (List<Object>) optionsMap.get('planes');
        Map<String,Object> planesMap = (Map<String,Object>) planesList[0];

		List<Object> lineasList = (List<Object>) planesMap.get('lineas'); 
        Map<String,Object> lineaMap = (Map<String,Object>) lineasList[0];
        
		system.assertEquals(false, optionsMap.get('lineasReservadas'));
        system.assertEquals(true, lineaMap.get('isSelected'));
        system.assertEquals(null, lineaMap.get('linea'));
        system.assertEquals('No se encontro linea disponible', lineaMap.get('validacionLinea'));
    }
    
    static testMethod void TestGetLinesForGeographyWithNoLine() {
        LinesManager lineManager = new LinesManager();
        Map<String, Object> outMap = new Map<String, Object>();
        CpqMobileNumbering__c mobileNumberingSetting = new CpqMobileNumbering__c();
        mobileNumberingSetting.Name='Default';
        insert mobileNumberingSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());
        lineManager.invokeMethod('GetLinesForGeography', LinesManagerInputMapFactoryTest.generateInputMap(), outMap, null);
		Test.stopTest(); 
        
        List<Object> optionsList = (List<Object>) outMap.get('options');
        Map<String,Object> optionsMap = (Map<String,Object>) optionsList[0];
        
        List<Object> planesList = (List<Object>) optionsMap.get('planes');
        Map<String,Object> planesMap = (Map<String,Object>) planesList[0];

		List<Object> lineasList = (List<Object>) planesMap.get('lineas'); 
        Map<String,Object> lineaMap = (Map<String,Object>) lineasList[0];
       
        system.assertEquals(false, optionsMap.get('lineasReservadas'));
        system.assertEquals(true, lineaMap.get('isSelected'));
        system.assertEquals(null, lineaMap.get('linea'));
        system.assertEquals('No se encontro linea disponible', lineaMap.get('validacionLinea'));
    }
    
    static testMethod void TestGetLinesForGeographyWithLine() {
        LinesManager lineManager = new LinesManager();
        Map<String, Object> outMap = new Map<String, Object>();
        CpqMobileNumbering__c mobileNumberingSetting = new CpqMobileNumbering__c();
        mobileNumberingSetting.Name='Default';
        insert mobileNumberingSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());
        lineManager.invokeMethod('GetLinesForGeography', LinesManagerInputMapFactoryTest.generateInputMap(), outMap, null);
		Test.stopTest(); 
        
        List<Object> optionsList = (List<Object>) outMap.get('options');
        Map<String,Object> optionsMap = (Map<String,Object>) optionsList[0];
        
        List<Object> planesList = (List<Object>) optionsMap.get('planes');
        Map<String,Object> planesMap = (Map<String,Object>) planesList[0];

		List<Object> lineasList = (List<Object>) planesMap.get('lineas'); 
        Map<String,Object> lineaMap = (Map<String,Object>) lineasList[0];
        
		system.assertEquals(true, optionsMap.get('lineasReservadas'));
        system.assertEquals(true, lineaMap.get('isSelected'));
        system.assertEquals('1148745678', lineaMap.get('linea'));
        system.assertEquals(null, lineaMap.get('validacionLinea'));
    }

    static testMethod void TestValidateLinesQtty() {
        MockupFactory.generate();
        LinesSetting__c linesSetting = new LinesSetting__c(SetupOwnerId = UserInfo.getOrganizationId(), CantidadDeLineas__c = 5);
        insert linesSetting;
        Map<String, Object> outMap = new Map<String, Object>();

        Map<String, Object> optionsMap = new Map<String, Object>();

        Account acc = [SELECT Id FROM Account LIMIT 1];
        optionsMap.put('IdAccount', acc.Id);

        Map<String, Object> inputMap = new Map<String, Object>();
        Product2 product = [SELECT Id FROM Product2 LIMIT 1];
        PricebookEntry pricebookEntry = [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE Product2Id =: product.Id LIMIT 1];

        Order order = new Order(AccountId = acc.Id, EffectiveDate = Date.today(), Status = 'Draft', Pricebook2Id = pricebookEntry.Pricebook2Id, Delivery_Method__c='Delivery', vlocity_cmt__OriginatingChannel__c='Agentes');
        insert order;
        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = order.Id, Product2Id = product.Id, Quantity = 100, PricebookEntryId = pricebookEntry.Id, UnitPrice = 500));
        insert ordItemList;

        optionsMap.put('IdOrder', order.Id);

        LinesManager lineManager = new LinesManager();
        Test.startTest();
        lineManager.invokeMethod('ValidateLinesQtty', inputMap, outMap, optionsMap);
        Test.stopTest();
    }
    
    static testMethod void TestGetLinesForGeographyTypeAheadWithLine() {
        LinesManager lineManager = new LinesManager();
        Map<String, Object> outMap = new Map<String, Object>();
        CpqMobileNumbering__c mobileNumberingSetting = new CpqMobileNumbering__c();
        mobileNumberingSetting.Name='Default';
        insert mobileNumberingSetting;
        
        Map<String, Object> inputMap = LinesManagerInputMapFactoryTest.generateInputMap();
        Map<String, Object> lineAssignmentMap = (Map<String,Object>) inputMap.get('LineAssignment');
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap = (Map<String, Object>) lineAssignmentMap.get('SearchBlock');
        lineAssignmentMap.put('TypeAhead2-Block', auxMap);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());        
        lineManager.invokeMethod('GetLinesForGeographyTypeAhead', inputMap, outMap, null);
		Test.stopTest(); 
        
        List<Object> optionsList = (List<Object>) outMap.get('options');
        Map<String,Object> optionsMap = (Map<String,Object>) optionsList[0];
        
        List<Object> planesList = (List<Object>) optionsMap.get('planes');
        Map<String,Object> planesMap = (Map<String,Object>) planesList[0];

		List<Object> lineasList = (List<Object>) planesMap.get('lineas'); 
        Map<String,Object> lineaMap = (Map<String,Object>) lineasList[0];
        
		system.assertEquals(true, optionsMap.get('lineasReservadas'));
        system.assertEquals(true, lineaMap.get('isSelected'));
        system.assertEquals('1148745678', lineaMap.get('linea'));
        system.assertEquals(null, lineaMap.get('validacionLinea'));
    }

    static testMethod void TestUpdateOrderLineItems() {
        MockupFactory.generate();
        OrderItem ordItem = [SELECT Id FROM OrderItem LIMIT 1];
        LinesManager lineManager = new LinesManager();
        
        Map<String, Object> options = LinesManagerInputMapFactoryTest.generateInputMap();
        Map<String, Object> orderMap = (Map<String, Object>) options.get('Order');
        List<Object> planesList = (List<Object>) orderMap.get('planes');
        Map<String, Object> planMap = (Map<String, Object>) planesList.get(0);
        List<Object> lineaList = (List<Object>) planMap.get('lineas');
        Map<String, Object> lineaMap = (Map<String, Object>) lineaList.get(0);
        lineaMap.put('orderItemId', ordItem.Id);

        Test.startTest();
        lineManager.invokeMethod('UpdateOrderLineItems', null, null, options);       
		Test.stopTest();
    }

    static testMethod void TestCreditRechargeOK() {
        LinesManager lineManager = new LinesManager();

        String mockResponse = '{"txId" : "260174721"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S143', mockResponse);

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        options.put('nroLinea', '123123');
        options.put('subscriptionId', '123123');
        options.put('ChargeAmmount', 123.123);
        
        Test.startTest();        
        lineManager.invokeMethod('CreditRecharge', null, outMap, options);
		Test.stopTest();

        System.assertEquals('260174721', outMap.get('txId'));
    }

    static testMethod void TestCreditRechargeNoOK() {
        LinesManager lineManager = new LinesManager();

        String mockResponse = '{"txId" : "260174721", "mensaje" : "fallo el servicio"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S143', mockResponse);

        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();

        options.put('nroLinea', '123123');
        options.put('subscriptionId', '123123');
        options.put('ChargeAmmount', 123.123);
        
        Test.startTest();        
        lineManager.invokeMethod('CreditRecharge', null, outMap, options);
		Test.stopTest();

        System.assertEquals('fallo el servicio', outMap.get('Error'));
    }
}