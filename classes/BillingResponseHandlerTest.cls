@isTest
public with sharing class BillingResponseHandlerTest {
    
    @testSetup static void createDataTest(){
        //List<Account> accounts = TestDataFactory.createAccounts(1,'Consumer');
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        /*
        List<Order> orders = new List<Order>();
        for (Account a: accounts) {
            orders.addAll(TestDataFactory.createOrders(1,a));
        }
        */
        MockUpFactory.generate();
    }
    
    @isTest
    static void BillingResponse_Handler() {
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, String>();
        options.put('ContactFirstName', 'Contact First Name');
        options.put('ContactLastName', 'Contact LastName');
        options.put('AccountName', 'Sample Account');
        options.put('DocumentType', 'DNI');
        options.put('DocumentNumber', '12345678');
        options.put('AccountNumber', '1234');
        options.put('Email', 'test@yopmail.com');
        options.put('PhoneNumber', '1234567890');
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod('callBackService224', inputMap, outMap, options);
        BResp.invokeMethod('testGetSystemURL', inputMap, outMap, options);
        //BResp.invokeMethod('callNominationCheckout', inputMap, outMap, options);
        BResp.invokeMethod('getNominationAssets', inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest static void callBackService224_OKWithOrderStatusSucced() {
        //GIVEN
        String methodName = 'callBackService224';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [SELECT Id, OrderNumber FROM Order LIMIT 1];
        
        String JSONResponse = '{"invoiceAndPaymentNotification":{"SalesOrderId":"'+order.OrderNumber+'","Status":"payment succeed","StatusInvoice":"invoice succeed","LegalInvoiceNumber":"LegalInvoiceNumber"}}';
        
        options.put('JSONResponse',JSONResponse);
        
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest static void callBackService224_OKWithOrderStatusSuccedRecarga() {
        //GIVEN
        String methodName = 'callBackService224';
        
        String mockResponse = '{"txId":"12345"}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S143', mockResponse);

        mockResponse = '{"IPResult":{"executionCode":"OK"}}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S159', mockResponse);
        
        Id recordType = [SELECT Id FROM RecordType WHERE Name = 'SMS Template'].Id;
        CrossObject__c template = new CrossObject__c(String1__c = 'pepe', RecordTypeId = recordType, Picklist1__c = 'Recarga Exitosa');
        insert template;
        insert new SMSSender__c(Name='S-Confirmacion-SMS',Sender__c='S-Confirmacion-SMS');
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        /*Order order = [SELECT Id, Gestion__c, OriginStoreLocation__c, OrderNumber FROM Order LIMIT 1];
        order.Gestion__c = 'Recarga';
        update order;*/
        Account account = [SELECT Id FROM Account LIMIT 1];
        Id pricebookId = Test.getStandardPricebookId();
        Order orderNew = new Order(AccountId = account.Id, Status = 'Draft', Gestion__c = 'Recarga', Operation_Code__c = 'VTNLCE', EffectiveDate = Date.today(), Pricebook2Id = pricebookId,vlocity_cmt__OriginatingChannel__c ='Agentes',Delivery_Method__c ='Presencial', Received224_Date__c = Date.Today());
        insert orderNew;
        
        Order order = [SELECT Id, Gestion__c, OriginStoreLocation__c, OrderNumber FROM Order WHERE Id=:orderNew.Id];

        System.debug('callBackService224_OKWithOrderStatusSuccedRecarga: ' + order);
        
        List<Product2> product = TestDataFactory.createProduct(1);
        List<Asset> assets = TestDataFactory.createAssets(1,account,'453343636363');
        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithAsset(1,order,assets.get(0));
        String MSISDN = '{"MSISDN":[{"attributedisplayname__c":"MSISDN","attributeRunTimeInfo":{"value":"nroLinea"}}]}';
        orderItems.get(0).vlocity_cmt__JSONAttribute__c = MSISDN;
        update orderItems.get(0);
        
        String JSONResponse = '{"invoiceAndPaymentNotification":{"SalesOrderId":"'+order.OrderNumber+'","Status":"payment succeed","StatusInvoice":"invoice succeed","LegalInvoiceNumber":"LegalInvoiceNumber"}}';
        
        options.put('JSONResponse',JSONResponse);
        
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest static void callBackService224_OKWithOrderIdNull() {
        //GIVEN
        String methodName = 'callBackService224';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [SELECT Id, OrderNumber FROM Order LIMIT 1];
        
        String ReasonCode = 'ReasonCode';
        
        insert new Order_Failed_Payment_Messages__c(Name = 'Error_Code__c', Error_Code__c=ReasonCode);
                
        String JSONResponse = '{"invoiceAndPaymentNotification":{"SalesOrderId":"'+order.OrderNumber+'","ReasonCode":"'+ReasonCode+'","Status":"Draft","LegalInvoiceNumber":"LegalInvoiceNumber"}}';
        
        options.put('JSONResponse',JSONResponse);
        
        //WHEN
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
    @isTest static void callBackService224_Error001() {
        //GIVEN
        String methodName = 'callBackService224';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [SELECT Id, OrderNumber FROM Order LIMIT 1];
        
        TASalesCodeValue__c cod2 = new TASalesCodeValue__c();
        cod2.Name= 'IF224ReasonAnulada';
        cod2.Value__c = '2';
        insert cod2;
        
        String ReasonCode = '2';
        insert new Order_Failed_Payment_Messages__c(Name = 'Error_Code__c', Error_Code__c=ReasonCode);
                
        String JSONResponse = '{"invoiceAndPaymentNotification":{"SalesOrderId":"'+order.OrderNumber+'","ReasonCode":"'+ReasonCode+'","Status":"payment failed","LegalInvoiceNumber":"LegalInvoiceNumber"}}';
        
        options.put('JSONResponse',JSONResponse);
        
        //WHEN
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void callBackService224_Error002() {
        //GIVEN
        String methodName = 'callBackService224';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [SELECT Id, OrderNumber FROM Order LIMIT 1];
        
        TASalesCodeValue__c cod3 = new TASalesCodeValue__c();
        cod3.Name= 'IF224ReasonCancelada';
        cod3.Value__c = '3';
        insert cod3;
        
        String ReasonCode = '3';
        insert new Order_Failed_Payment_Messages__c(Name = 'Error_Code__c', Error_Code__c=ReasonCode);
                
        String JSONResponse = '{"invoiceAndPaymentNotification":{"SalesOrderId":"'+order.OrderNumber+'","ReasonCode":"'+ReasonCode+'","Status":"payment failed","LegalInvoiceNumber":"LegalInvoiceNumber"}}';
        
        options.put('JSONResponse',JSONResponse);
        
        //WHEN
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void callBackService224_OKWithOrderDeliveryMethodStorePickUp() {
        //GIVEN
        String methodName = 'callBackService224';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [SELECT Id, OrderNumber FROM Order LIMIT 1];
        order.Delivery_Method__c = 'Store Pick Up';
        update order;
        
        String ReasonCode = 'ReasonCode';
        insert new Order_Failed_Payment_Messages__c(Name = 'Error_Code__c', Error_Code__c=ReasonCode);
                
        String JSONResponse = '{"invoiceAndPaymentNotification":{"SalesOrderId":"'+order.OrderNumber+'","Status":"payment succeed","StatusInvoice":"invoice succeed","LegalInvoiceNumber":"LegalInvoiceNumber"}}';
        
        options.put('JSONResponse',JSONResponse);
        
        //WHEN
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest static void callNominationCheckoutOK() {
        //GIVEN
        String methodName = 'callNominationCheckout';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [SELECT Id FROM Order LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        List<Product2> product = TestDataFactory.createProduct(1);
        List<Asset> assets = TestDataFactory.createAssets(1,product.get(0),account);
        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithAsset(1,order,assets.get(0));
        
        options.put('orderId', order.Id);
        options.put('accountId', account.Id);
        options.put('assetId', assets.get(0).Id);
        
        //WHEN
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest static void prepareOrderForOM() {
        //GIVEN
        String methodName = 'prepareOrderForOM';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Order order = [SELECT Id FROM Order LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        List<Product2> product = TestDataFactory.createProduct(1);
        List<Asset> assets = TestDataFactory.createAssets(1,product.get(0),account);
        List<OrderItem> orderItems = TestDataFactory.createOrderItemsWithAsset(1,order,assets.get(0));
        
        options.put('orderId', order.Id);
        options.put('accountId', account.Id);
        options.put('assetId', assets.get(0).Id);
        
        //WHEN
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest
    static void SendSuccesfulOrderClientNotification() {
        Test.startTest();
        Order order = [SELECT Id FROM Order LIMIT 1];
        BillingResponseHandler.SendSuccesfulOrderClientNotification(order.Id);
        Test.stopTest();
    }

    @isTest
    static void SendSuccesfulPaymentClientNotification() {
        Test.startTest();
        Order order = [SELECT Id FROM Order LIMIT 1];
        BillingResponseHandler.SendSuccesfulPaymentClientNotification(order.Id);
        Test.stopTest();
    }
    
    @isTest static void callBackService224_NullException() {
       
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        try
        {
            BResp.invokeMethod(null, inputMap, outMap, options);
        }
        catch (Exception ex)
        {
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Attempt to de-reference a null object') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }

    @isTest static void callNominationCheckout_Exception() {
        String methodName = 'callNominationCheckout';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        BResp.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void getNominationAssets_Exception() {
        String methodName = 'getNominationAssets';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = null;
        Map<String, Object> options = new Map<String, Object>();
        
        Test.startTest();
        BillingResponseHandler BResp = new BillingResponseHandler();
        try
        {
            BResp.invokeMethod(methodName, inputMap, outMap, options);
        }
        catch (Exception ex)
        {
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Attempt to de-reference a null object') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }
    
    @isTest static void processInternetPackReset_Test() {
        String methodName = 'processInternetPackReset_Test';

        String nroLinea = 'NroLinea';
        //TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = [SELECT Id FROM Account LIMIT 1];
        TestDataFactory.createAssets(1,account);
        
        Asset asset = [SELECT vlocity_cmt__LineNumber__c, AccountId FROM Asset LIMIT 1];
        asset.vlocity_cmt__LineNumber__c = nroLinea;
        asset.MSISDN__c = nroLinea;
        update asset;
        
        Product2 product = TestDataFactory.createProduct(1).get(0);
        product.vlocity_cmt__JSONAttribute__c = '{"attributes":[{"attributedisplayname__c":"Unidad de Medida de Vigencia","attributeRunTimeInfo":{"default":[{"value":"W"}]}},{"attributedisplayname__c":"Vigencia Activacion","attributeRunTimeInfo":{"default":"24"}},{"attributedisplayname__c":"ID Sistema Origen","attributeRunTimeInfo":{"default":"FAN_PRDA_00003"}}]}';                                                                                         
        product.ProductCode = 'FAN_PRDA_00003'; // OJO CON ESTE VALOR, ESTÁ HARD CODE EN EL SOURCE
        update product;
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id =Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true
        );

        insert standardPrice;
        
        Order orderOBJ = TestDataFactory.createOrders(1,account).get(0);
        String idOrder = (String) orderOBJ.Id;

        TestDataFactory.createPaymentAdjustments(1, account, orderOBJ);

        Id recordType = [SELECT Id FROM RecordType WHERE Name = 'SMS Template'].Id;
        CrossObject__c template = new CrossObject__c(String1__c = 'Se renovó tu cuota de datos exitosamente!', RecordTypeId = recordType, Picklist1__c = 'Renovacion de datos Exitosa');
        insert template;
        insert new SMSSender__c(Name='S-Confirmacion-SMS',Sender__c='S-Confirmacion-SMS');

        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = orderOBJ.Id, vlocity_cmt__AssetId__c = asset.Id, Product2Id = product.Id, Quantity = 10, PricebookEntryId = standardPrice.Id, UnitPrice = 100));
        insert ordItemList;
        
        Test.startTest();
        BillingResponseHandler.processInternetPackReset(orderOBJ);
        Test.stopTest();
    }
 }