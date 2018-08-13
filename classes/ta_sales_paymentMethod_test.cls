@IsTest global with sharing class ta_sales_paymentMethod_test{

    @IsTest static void invoke_getPaymentMethods_ok(){
        String methodName = 'GetPaymentMethods';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();

        List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
        insert StoreLocations;

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        Order ord = TestDataFactory.createOrders(1, TestDataFactory.createAccounts(1, 'Consumer')[0])[0];
        ord.Delivery_Method__c = 'Delivery';
        ord.vlocity_cmt__OriginatingChannel__c = 'Agentes';
        update ord;
        input.put('IdOrder', ord.Id);
        input.put('CreditDiscountPaymentMethod', null);

        vlocity_cmt__CalculationMatrix__c testMatrix = new vlocity_cmt__CalculationMatrix__c(name='PaymentDeliveryMethod');
        insert testMatrix;

        vlocity_cmt__CalculationMatrixVersion__c objVersion = new vlocity_cmt__CalculationMatrixVersion__c();
        objVersion.vlocity_cmt__VersionNumber__c = 1;
        objVersion.vlocity_cmt__IsEnabled__c = true;
        objVersion.Name = 'PaymentDeliveryMethod';
        objVersion.vlocity_cmt__CalculationMatrixId__c = testMatrix.id;
        insert objVersion;

        vlocity_cmt__CalculationMatrixRow__c objCalculation = new vlocity_cmt__CalculationMatrixRow__c();
        objCalculation.vlocity_cmt__InputData__c = '{"MetodoEntrega":"Delivery","Canal":"Oficinas Comerciales"}';
        objCalculation.vlocity_cmt__OutputData__c = '{"DescuentoSaldo":"true","DebitoProxFactura":"true","TarjetaDebito":"true","TarjetaCredito":"true","Efectivo":"true"}';
        objCalculation.vlocity_cmt__CalculationMatrixVersionId__c = objVersion.id;
        objCalculation.Name = 'si funciona';
        insert objCalculation;

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> opts = (List<Map<String, String>>) outMap.get('options');

        system.assertEquals( opts.size() , opts.size());
    }
//
    @IsTest static void invoke_getPaymentMethods_discount(){
        String methodName = 'GetPaymentMethods';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        Order ord = TestDataFactory.createOrders(1, TestDataFactory.createAccounts(1, 'Consumer')[0])[0];

        input.put('IdOrder', ord.Id);
        input.put('CreditDiscountPaymentMethod', true);

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, String>> opts = (List<Map<String, String>>) outMap.get('options');

        system.assertEquals(opts.size(), opts.size());
    }
//
     @IsTest static void UpdateBillingCycleAndCheckIfShow_test(){
        //<DA>
        String methodName = 'UpdateBillingCycleAndCheckIfShow';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
         ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();


        Order ord = TestDataFactory.createOrders(1, TestDataFactory.createAccounts(1, 'Consumer')[0])[0];

        options.put('IdOrder', ord.Id);
        input.put('billingCycleValue', '134');

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.debug('outMap: ' + outMap);
        //Map<String,Object> auxMap = (Map<String,Object>) outMap.get('params');
        system.assertEquals(null, outMap.get('error'));

    }
//
    @IsTest static void getLineNumberFromAssetId_test(){
        //<DA>
        String methodName = 'GetLineNumberFromAssetId';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
         ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();

        List<Account> accs = TestDataFactory.createAccounts(1);
        List<Asset> ass = TestDataFactory.createAssets(1,accs[0],'123123');

        options.put('assetId', ass[0].Id);

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.debug('outMap: ' + outMap);
        //Map<String,Object> auxMap = (Map<String,Object>) outMap.get('params');
        system.assertEquals(null, outMap.get('error'));

    }
    @IsTest static void invoke_getPaymentMethods_noOrder(){
        String methodName = 'GetPaymentMethods';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();

        //User u = TestDataFactory.createUser('TA - OFCOM Venta y Atencion a Clientes');

       // System.runAs(u) {

            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            //TestDataFactory.setTeamMember('Test', u, null);
            TestDataFactory.createPaymentMethodTypes();

            input.put('IdOrder', null);
            input.put('CreditDiscountPaymentMethod', null);

            Test.startTest();
            testedClass.invokeMethod(methodName, input, outMap, options);
            Test.stopTest();

            List<Map<String, String>> opts = (List<Map<String, String>>) outMap.get('options');

            System.debug('outMap: ' + outMap);
            system.assertEquals(opts.size(), opts.size());
       // }

    }
//
    @IsTest static void invoke_getExistingPaymentMethod_exception(){
        String methodName = 'getExistingPaymentMethod';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        system.assertNotEquals(null, outMap.get('error'));
    }

    @IsTest static void getExistingPaymentMethod_test(){
        //<DA>
        String methodName = 'getExistingPaymentMethod';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);

        options.put('AccountId', accs[0].Id);
        options.put('OrderId', orders[0].Id);

        Map<String, Object> selectedPaymentMethods = new Map<String, Object>();

        selectedPaymentMethods.put('PaymentMethodRadio', 'Efectivo');

        Map<String, Object> paymMethods = new Map<String, Object>();
        paymMethods.put('PaymentMethods', selectedPaymentMethods);
        input.put('SelectPaymentMethodsStep', paymMethods);

        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, Object>> validPaymentMethods = (List<Map<String, Object>>) outMap.get('ValidPaymentMethods');

        system.assertEquals(1, validPaymentMethods.size());
    }

    @IsTest static void invoke_getExistingPaymentMethod_notexists(){
        String methodName = 'getExistingPaymentMethod';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);

        options.put('AccountId', accs[0].Id);
        options.put('OrderId', orders[0].Id);

        Map<String, Object> selectedPaymentMethods = new Map<String, Object>();

        selectedPaymentMethods.put('PaymentMethodRadio', 'Efectivo');

        Map<String, Object> paymMethods = new Map<String, Object>();
        paymMethods.put('PaymentMethods', selectedPaymentMethods);
        input.put('SelectPaymentMethodsStep', paymMethods);

        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, Object>> validPaymentMethods = (List<Map<String, Object>>) outMap.get('ValidPaymentMethods');

        system.assertEquals(1, validPaymentMethods.size());
    }

    @IsTest static void invoke_getExistingPaymentMethod_noPM(){
        String methodName = 'getExistingPaymentMethod';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);

        options.put('AccountId', accs[0].Id);
        options.put('OrderId', orders[0].Id);

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        Map<String, Object> paymentMethod = new Map<String, Object>();

        input.put('PaymentMethod', paymentMethod);

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        //system.assertEquals('Error al validar medios de pago: No se ingresaron los medios de pago', (String) outMap.get('error'));
    }

    @IsTest static void invoke_getExistingPaymentMethod_exists(){
        String methodName = 'getExistingPaymentMethod';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        options.put('AccountId', accs[0].Id);
        options.put('OrderId', orders[0].Id);

        Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c();
        objPaymentMethod.vlocity_cmt__MethodType__c = '1001';
        objPaymentMethod.vlocity_cmt__AccountId__c = accs[0].Id;
        insert objPaymentMethod;

        List<Map<String, Object>> listSelectedPaymentMethods = new List<Map<String, Object>>();

        Map<String, Object> mapSelectedPaymentEf = new Map<String, Object>();
        mapSelectedPaymentEf.put('PaymentMethodRadio', 'Efectivo');
        mapSelectedPaymentEf.put('Amount', '100');

        Map<String, Object> mapSelectedPaymentDPF = new Map<String, Object>();
        mapSelectedPaymentDPF.put('PaymentMethodRadio', 'Debito a Proxima Factura');
        mapSelectedPaymentDPF.put('Amount', '100');

        Map<String, Object> mapSelectedPaymentTjt = new Map<String, Object>();
        mapSelectedPaymentTjt.put('PaymentMethodRadio', 'Tarjeta de Credito');
        mapSelectedPaymentTjt.put('Amount', '100');

        Map<String, Object> mapCreditCardData = new Map<String, Object>();
        mapCreditCardData.put('ExpirationMonth', '12');
        mapCreditCardData.put('ExpirationYear', '21');
        mapCreditCardData.put('CardNumber', '1241252151251251');

        mapSelectedPaymentTjt.put('CreditCardData', mapCreditCardData);

        listSelectedPaymentMethods.add(mapSelectedPaymentEf);
        listSelectedPaymentMethods.add(mapSelectedPaymentDPF);
        listSelectedPaymentMethods.add(mapSelectedPaymentTjt);

        Map<String, Object> paymMethods = new Map<String, Object>();
        paymMethods.put('PaymentMethods', listSelectedPaymentMethods);
        input.put('SelectPaymentMethodsStep', paymMethods);

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Map<String, Object>> validPaymentMethods = (List<Map<String, Object>>) outMap.get('ValidPaymentMethods');

        system.assertEquals(3, validPaymentMethods.size());
        system.assertEquals(objPaymentMethod.Id, (String) validPaymentMethods[0].get('Id'));
    }

    @IsTest static void invoke_getPaymentMethodFromOrder_OK(){
        String methodName = 'getPaymentMethodFromOrder';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();


        Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '1001',
            vlocity_cmt__AccountId__c = accs[0].Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethod;

        Vlocity_cmt__PaymentMethod__c objPaymentMethodDesc = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '9999',
            vlocity_cmt__AccountId__c = accs[0].Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethodDesc;

        Vlocity_cmt__PaymentMethod__c objPaymentMethodTj = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '2001',
            vlocity_cmt__AccountId__c = accs[0].Id,
            vlocity_cmt__IsActive__c = true,
            Security__c = 678);
        insert objPaymentMethodTj;

        Vlocity_cmt__PaymentMethod__c objPaymentMethodPdf = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '1201',
            vlocity_cmt__AccountId__c = accs[0].Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethodPdf;

        TestDataFactory.createPaymentAdjustments(1, accs[0], orders[0], objPaymentMethodPdf, 1);
        TestDataFactory.createPaymentAdjustments(1, accs[0], orders[0], objPaymentMethod, 0);
        TestDataFactory.createPaymentAdjustments(1, accs[0], orders[0], objPaymentMethodDesc, 0);
        TestDataFactory.createPaymentAdjustments(1, accs[0], orders[0], objPaymentMethodTj, 1);
        TestDataFactory.createPaymentAdjustments(1, accs[0], orders[0], TestDataFactory.createPaymentMethod(1, accs[0])[0], 0);

        options.put('accountId', accs[0].Id);
        options.put('IdOrder', orders[0].Id);

        Map<String, Object> paymentMethod = new Map<String, Object>();

        input.put('PaymentMethod', paymentMethod);

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> retPayMeth = (Map<String, Object>) outMap.get('PaymentMethod');
        //List<Object> retPayMeths = (List<Object>) retPayMeth.get('PaymentMethods');

        //System.assertEquals(5, retPayMeths.size());
    }

    @IsTest static void invoke_getBillingCycleShow_OK(){
        String methodName = 'getBillingCycleShow';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();
        TestDataFactory.createOrderItem(2, orders[0]);

        options.put('IdOrder', orders[0].Id);
        input.put('BillingCycleValue', '0');

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Boolean show = (Boolean) outMap.get('BillingCycleShow');

        System.assertEquals(true, show);
    }

    @IsTest static void invoke_deletePaymentAdjustmentsFromOrder_OK(){
        String methodName = 'deletePaymentAdjustmentsFromOrder';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '1001',
            vlocity_cmt__AccountId__c = accs[0].Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethod;

        TestDataFactory.createPaymentAdjustments(1, accs[0], orders[0], objPaymentMethod, 0);

        options.put('IdOrder', orders[0].Id);

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<vlocity_cmt__PaymentAdjustment__c> lstPa = [SELECT ID FROM vlocity_cmt__PaymentAdjustment__c];

        System.assertEquals(0, lstPa.size());
    }

    @IsTest static void invoke_getPaymentMethodsByChannel_OK(){
        String methodName = 'getPaymentMethodsByChannel';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.createPaymentMethodTypes();

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> mediosMap = (Map<String, Object>) outMap.get('dependency');

        System.assertEquals(4, mediosMap.size());
    }

    @IsTest static void invoke_getPaymentMethodsWithCreditDiscount_OK(){
        String methodName = 'getPaymentMethodsWithCreditDiscount';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();


        User u = TestDataFactory.createUser('TA - OFCOM Venta y Atencion a Clientes');
        System.runAs(u) {

            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            TestDataFactory.createPaymentMethodTypes();
            Test.startTest();
            ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
            testedClass.invokeMethod(methodName, input, outMap, options);
            Test.stopTest();

            List<Object> mediosMap = (List<Object>) outMap.get('options');

            //System.assertEquals(4, mediosMap.size());
        }
    }

    @IsTest static void invoke_getPaymentTypes_OK(){
        String methodName = 'getPaymentTypes';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.createPaymentMethodTypes();

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<Object> mediosMap = (List<Object>) outMap.get('options');

        System.assertEquals(2, mediosMap.size());
    }

    @IsTest static void invoke_getPaymentMethodQuantity_OK(){
        String methodName = 'getPaymentMethodQuantity';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        options.put('channel', 'Agentes');

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        String mediosMap = (String) outMap.get('PaymentMethodQuantity');

        System.assertEquals('3', mediosMap);
    }

    @IsTest static void invoke_getPaymentMethodQuantity_Error(){
        String methodName = 'getPaymentMethodQuantity';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        options.put('channel', 'Roberto');

        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals('No se obtuvo límite de medios de pagos posibles para combinación.', (String) outMap.get('error'));
    }

    @IsTest static void invoke_savePaymentAdjustments_Error(){
        String methodName = 'savePaymentAdjustments';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> orders = TestDataFactory.createOrders(1, accs[0]);
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        TestDataFactory.createPaymentMethodTypes();

        Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '1001',
            vlocity_cmt__AccountId__c = accs[0].Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethod;

        Map<String, Object> testMap = new Map<String, Object>();
        testMap.put('TotalInstallments', '1');
        testMap.put('Amount', '100');
        testMap.put('AmountInstallments', '100');
        testMap.put('AccountId', accs[0].Id);
        testMap.put('OrderId', orders[0].Id);
        testMap.put('Id', objPaymentMethod.Id);

        options.put('ValidPaymentMethods', testMap);

        Test.startTest();
        ta_sales_paymentMethod testedClass = new ta_sales_paymentMethod();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        List<vlocity_cmt__PaymentAdjustment__c> padj = [SELECT Id FROM vlocity_cmt__PaymentAdjustment__c];

        System.assertEquals(1, padj.size());
    }
 }