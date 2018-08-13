@isTest(seeAllData = false)
public class SaleManagerTest {
    
    @isTest
    static void reserveProductsTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Order ord = [SELECT Id FROM Order LIMIT 1];
        options.put('IdOrder', ord.Id);
        List<OrderItem> oldOrderItems = [SELECT Id FROM OrderItem];
        PricebookEntry pbe = [SELECT Id FROM PricebookEntry LIMIT 1];

        List<Product2> productsList = new List<Product2>();
        productsList.add(new Product2(Name = 'Product 1', Family = 'prepaid', vlocity_cmt__Type__c = 'Plan Prepago'));
        productsList.add(new Product2(Name = 'Product 2', Family = 'prepaid', vlocity_cmt__Type__c = 'Plan Prepago'));
        insert productsList;
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productsList.get(0).Id, UnitPrice = 100, IsActive = true);
        insert standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productsList.get(1).Id, UnitPrice = 10, IsActive = true);
        insert standardPrice2;
        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = ord.Id, Product2Id = productsList.get(0).Id, Quantity = 10, PricebookEntryId = standardPrice1.Id, UnitPrice = 100));
        ordItemList.add(new OrderItem(OrderId = ord.Id, Product2Id = productsList.get(1).Id, Quantity = 5, PricebookEntryId = standardPrice2.Id, UnitPrice = 10));
        insert ordItemList;
        
        for(OrderItem ordItem : oldOrderItems) {
            ordItem.vlocity_cmt__ParentItemId__c = ordItemList.get(0).Id;
        }
        update oldOrderItems;

        String mockResponse = '{"listaResultado": [],"descripcionResultado": "Liberacion Exitosa","codigoResultado": "OK"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S101', mockResponse);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());
        saleManager.invokeMethod('ReserveProducts', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, options);
        Test.stopTest();
    }

    @isTest
    static void getOrderValidationsTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Order ord = [SELECT Id FROM Order LIMIT 1];
        List<OrderItem> items = [SELECT Id, vlocity_cmt__JSONAttribute__c FROM OrderItem WHERE OrderId =: ord.Id];
        Map<String, Object> auxMap = new Map<String, Object>();
        List<Object> auxList = new List<Object>();
        Map<String, Object> auxMap2 = new Map<String, Object>();
        auxMap2.put('value__c', 'Selected');
        auxMap2.put('value__c', 'Not Selected');
        auxList.add(auxMap2);
        auxMap.put('CHAR', auxList);
        
        for(OrderItem ordItem : items) {
            ordItem.vlocity_cmt__JSONAttribute__c = JSON.serialize(auxMap);
        }
        update items;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());
        saleManager.invokeMethod('GetOrderValidations', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, SaleManagerInputMapFactoryTest.generateOptionsMap());
        Test.stopTest();
    }

    @isTest
    static void getOrderValidationsBadOrderIdTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('IdOrder',' ');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121NoLineMockHttpResponseGeneretor());
        saleManager.invokeMethod('GetOrderValidations', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, options);
        Test.stopTest();
    }

    @isTest
    static void getCustomSettingTest() {
        MockupFactory.generate();
        //Get a random Custom Setting to test
        Segments__c  customSetting = new Segments__c (Name = 'name', ClubPersonalCategory__c  = 'clubPersonalCategory', SegmentLevel1__c  = 'segmentLevel1', SegmentLevel2__c = 'segmentLevel2');
        insert customSetting;
        
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('CSName', 'Segments__c');
        List<Object> auxList = new List<Object>();
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap.put('field', 'ClubPersonalCategory__c');
        auxList.add(auxMap);
        Map<String, Object> auxMap2 = new Map<String, Object>();
        auxMap2.put('field', 'SegmentLevel1__c');        
        auxList.add(auxMap2);
        Map<String, Object> auxMap3 = new Map<String, Object>();
        auxMap3.put('field', 'SegmentLevel2__c');        
        auxList.add(auxMap3);
        options.put('CSFields', auxList);        
        
        Test.startTest();
        saleManager.invokeMethod('GetCustomSetting', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, options);
        Test.stopTest();
    }

    @isTest
    static void assingProductsToServiceAccountTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        
        Test.startTest();
        saleManager.invokeMethod('AssingProductsToServiceAccount', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, SaleManagerInputMapFactoryTest.generateOptionsMap());
        Test.stopTest();
    }

    @isTest
    static void validateEmailSettingsTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        Contact cont = [SELECT Id, Email FROM Contact LIMIT 1];
        cont.Email = 'anemail@email.com';
        update cont;
        
        ValidEmailDomain__c csEmailValid = new ValidEmailDomain__c(Name = '@email.com');
        insert csEmailValid;
        EmailsSetting__c csEmailSetting = new EmailsSetting__c(CantidadDeEmails__c = 5);
        insert csEmailSetting;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());
        saleManager.invokeMethod('ValidateEmailSettings', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, SaleManagerInputMapFactoryTest.generateOptionsMap());
        
        Map<String, Object> options = new Map<String, Object>();
        options.put('FieldEmail', '');
        saleManager.invokeMethod('ValidateEmailSettings', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, options);
        Test.stopTest();
    }

    @isTest
    static void setStockMovementCodesTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());
        saleManager.invokeMethod('SetStockMovementCodes', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, SaleManagerInputMapFactoryTest.generateOptionsMap());
        Test.stopTest();
    }

    @isTest
    static void SendPickUpInformationEmailTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('IdOrder','123412341324');
        options.put('EmailToSend','EmailToSend');
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());
        saleManager.invokeMethod('SendPickUpInformationEmail', input, outMap, options);
        Test.stopTest();
    }

    @isTest
    static void GetAmountInfoRefillSOSTest() {
        MockupFactory.generate();
        SaleManager saleManager = new SaleManager();
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        Contact contact = new Contact();
        contact.FirstName = 'Pepe';
        contact.LastName = 'Pepe';
        insert contact;
        Map<String, Object> orderRet = taSalesCreateOrderController.CreateOrderAndAccount(contact.Id, 'VLCE');
        String IdOrder = (String) orderRet.get('IdOrder');
        /*
        Map<String, Object> inMap = new Map<String, Object>();
            Map<String, Object> outMap = new Map<String, Object>();
            List<Map<String, Object>> lstInputParamsAlta = new List<Map<String, Object>>();
            Map<String, Object> item = new Map<String, Object>();
            lstInputParamsAlta.add(item);

            inMap.put('price', true);
            inMap.put('validate', true);
            inMap.put('includeAttachment', false);
            inMap.put('pagesize', 20);
            inMap.put('hierarchy', -1);
            inMap.put('items', pLstItems);
            inMap.put('cartId', pOrderId);
            inMap.put('methodName', 'postCartsItems');

            vlocity_cmt.CpqAppHandler appHandler = new vlocity_cmt.CpqAppHandler();
            printDebug('--- antes de llamar al invokeMethod - inMap --> ' + JSON.serialize(inMap));
            appHandler.invokeMethod('postCartsItems', inMap, outMap, null);

        Order order = [SELECT vlocity_cmt__JSONAttribute__c from Order WHERE Id = :IdOrder];
        Map<String,String> attribs = new Map<String,String>();
        attribs.put('Monto del Prestamo', 123);
        String jsonAttribute = AssetAttributesUtils.setValuesOnJSON(order.vlocity_cmt__JSONAttribute__c, attribs);
        order.vlocity_cmt__JSONAttribute__c = jsonAttribute;
        insert orderItem;
        */
        input.put('IdOrder',IdOrder);
        //Test.setMock(HttpCalloutMock.class, new IFS121MockHttpResponseGenerator());
        saleManager.invokeMethod('GetAmountInfoRefillSOS', input, outMap, options);
        Test.stopTest();
    }

    @isTest
    static void getCustomSettingAtributeTest() {
        MockupFactory.generate();
        //Get a random Custom Setting to test
        Segments__c  customSetting = new Segments__c (Name = 'name', ClubPersonalCategory__c  = 'clubPersonalCategory', SegmentLevel1__c  = 'segmentLevel1', SegmentLevel2__c = 'segmentLevel2');
        insert customSetting;
        
        SaleManager saleManager = new SaleManager();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('CSName', 'Segments__c');
        options.put('CSAtribute', 'name');
        List<Object> auxList = new List<Object>();
        Map<String, Object> auxMap = new Map<String, Object>();
        auxMap.put('field', 'ClubPersonalCategory__c');
        auxList.add(auxMap);
        Map<String, Object> auxMap2 = new Map<String, Object>();
        auxMap2.put('field', 'SegmentLevel1__c');        
        auxList.add(auxMap2);
        Map<String, Object> auxMap3 = new Map<String, Object>();
        auxMap3.put('field', 'SegmentLevel2__c');        
        auxList.add(auxMap3);
        options.put('CSFields', auxList);        
        
        Test.startTest();
        saleManager.invokeMethod('GetCustomSettingAtribute', SaleManagerInputMapFactoryTest.generateInputMap(), outMap, options);
        Test.stopTest();
    }

    @isTest
    static void GetNewGuid_Test() {
        MockupFactory.generate();
        
        SaleManager saleManager = new SaleManager();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();     
        
        Test.startTest();
        saleManager.invokeMethod('GetNewGuid', inputMap, outMap, options);
        Test.stopTest();
    }
}