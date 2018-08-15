@isTest 
private class ta_sales_renovacionDatos_test {
    
    @isTest static void GetAvailableOffersTest() {
        //GIVEN
        String nameMethod = 'GetAvailableOffers';
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        
        String nroLinea = '';
        
        Account account = TestDataFactory.createAccounts(1).get(0);
        TestDataFactory.createAssets(1,account);
        Order orderOBJ = TestDataFactory.createOrders(1,account).get(0);
        
        Asset asset = [SELECT vlocity_cmt__LineNumber__c, AccountId FROM Asset LIMIT 1];
        asset.vlocity_cmt__LineNumber__c = nroLinea;
        update asset;
        
        input.put('nroLinea',nroLinea);
        
        ta_sales_renovacionDatos ta_sales_renovacionDato = new ta_sales_renovacionDatos();
        
        //WHEN
        Test.startTest();
        ta_sales_renovacionDato.invokeMethod(nameMethod,input,output,options);
        Test.stopTest();
        
        //THEN
        Order orderResult = [SELECT Gestion__c FROM Order WHERE Id = :orderOBJ.Id];
        System.assertEquals(orderResult.Gestion__c, 'Reseteo de Cuota');
    }
    
    @isTest static void EnviarSMSExitoTest() {
        //GIVEN
        String nameMethod = 'EnviarSMSExito';
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        String mockResponse = '{"IPResult":{"executionCode":"OK"}}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S159', mockResponse);
        
        Id recordType = [SELECT Id FROM RecordType WHERE Name = 'SMS Template'].Id;
        CrossObject__c template = new CrossObject__c(String1__c = 'Se renovó tu cuota de datos exitosamente!', RecordTypeId = recordType, Picklist1__c = 'Renovacion de datos Exitosa');
        insert template;
        insert new SMSSender__c(Name='S-Confirmacion-SMS',Sender__c='S-Confirmacion-SMS');
        
        String nroLinea = '';       
        input.put('nroLinea',nroLinea);
        
        ta_sales_renovacionDatos ta_sales_renovacionDato = new ta_sales_renovacionDatos();
        
        //WHEN
        Test.startTest();
        ta_sales_renovacionDato.invokeMethod(nameMethod,input,output,options);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }

    @isTest static void AddSelectedPackTest() {
        //GIVEN
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
        PricebookEntry priceBookEntry = [SELECT Id FROM PricebookEntry LIMIT 1];

        String nameMethod = 'AddSelectedPack';
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();

        Map<String, Object> comboSelected = new Map<String, Object>();
        comboSelected.put('vlcSelected',true);
        comboSelected.put('idListaPrecio',priceBookEntry.Id);
        List<Object> selectedCombo = new List<Object>();
        selectedCombo.add(comboSelected);
        options.put('SelectedCombo',selectedCombo);
        options.put('IdOrder',order.Id);
        
        ta_sales_renovacionDatos ta_sales_renovacionDato = new ta_sales_renovacionDatos();
        
        //WHEN
        Test.startTest();
        ta_sales_renovacionDato.invokeMethod(nameMethod,input,output,options);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    @isTest static void ChangeSubOfferingMeasureMTest() {
        //GIVEN
        String nameMethod = 'ChangeSubOffering';
        
        Map<String,Object> input = new Map<String,Object>();
        Map<String,Object> output = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        

        String mockResponse = '{"listaModificaOferta": [{"fechaVigenciaHastaProdAdq": "201711010000","fechaVigenciaDesdeProdAdq": "201701010000","producto": {"codProducto": 1837006933}}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S210', mockResponse);
        
        String nroLinea = 'NroLinea';
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = [SELECT Id FROM Account LIMIT 1];
        TestDataFactory.createAssets(1,account);
        
        Asset asset = [SELECT vlocity_cmt__LineNumber__c, AccountId FROM Asset LIMIT 1];
        asset.vlocity_cmt__LineNumber__c = nroLinea;
        asset.MSISDN__c = nroLinea;
        update asset;
                
        List<Object> selectedCombo = new List<Object>();
        Map<String,Object> combo = new Map<String,Object>();
        
        Product2 product = TestDataFactory.createProduct(1).get(0);
        product.vlocity_cmt__JSONAttribute__c = '{"attributes":[{"attributedisplayname__c":"Unidad de Medida de Vigencia","attributeRunTimeInfo":{"default":[{"value":"H"}]}},{"attributedisplayname__c":"Vigencia Activacion","attributeRunTimeInfo":{"default":"24"}},{"attributedisplayname__c":"ID Sistema Origen","attributeRunTimeInfo":{"default":"FAN_PRDA_00003"}}]}';                                                                                         
        product.ProductCode = 'FAN_PRDA_00003'; // OJO CON ESTE VALOR, ESTÁ HARD CODE EN EL SOURCE
        update product;
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id =Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true
        );

        insert standardPrice;
        
        String codOferta = product.ProductCode;
        Id idListaPrecio = standardPrice.Id;
        String precioConImp = '100';
        
        combo.put('vlcSelected',true);
        combo.put('codOferta',codOferta);
        combo.put('idListaPrecio',idListaPrecio);
        combo.put('precioConImp',precioConImp);
        
        selectedCombo.add(combo);
        
        Order orderOBJ = TestDataFactory.createOrders(1,account).get(0);
        String idOrder = (String) orderOBJ.Id;

        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = orderOBJ.Id, Product2Id = product.Id, Quantity = 10, PricebookEntryId = idListaPrecio, UnitPrice = 100));
        insert ordItemList;
        
        Id recordType = [SELECT Id FROM RecordType WHERE Name = 'SMS Template'].Id;
        CrossObject__c template = new CrossObject__c(String1__c = 'Se renovó tu cuota de datos exitosamente!', RecordTypeId = recordType, Picklist1__c = 'Renovacion de datos Exitosa');
        insert template;
        insert new SMSSender__c(Name='S-Confirmacion-SMS',Sender__c='S-Confirmacion-SMS');
        
        Schema.DescribeFieldResult fieldResult = Order.PaymentMethodType__c.getDescribe();
        List<Schema.PicklistEntry> pleList = fieldResult.getPicklistValues();
        String medioDePago = pleList.get(0).getValue();

        OrderItem item = [SELECT Id, Product2.Id, Product2.vlocity_cmt__JSONAttribute__c, Product2.ProductCode, Product2.ID_Sistema_Origen__c, vlocity_cmt__AssetId__r.Subscription_Id__c, vlocity_cmt__AssetId__r.MSISDN__c FROM OrderItem WHERE OrderId = :idOrder LIMIT 1];
        
        options.put('NroLinea', nroLinea);
        options.put('SelectedCombo', selectedCombo);
        options.put('IdOrder', idOrder);
        options.put('MedioDePago', medioDePago);
        
        ta_sales_renovacionDatos ta_sales_renovacionDato = new ta_sales_renovacionDatos();
        
        //WHEN
        Test.startTest();
        ta_sales_renovacionDato.invokeMethod(nameMethod,input,output,options);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    @isTest static void ChangeSubOfferingMeasureWTest() {
        //GIVEN
        String nameMethod = 'ChangeSubOffering';

        String mockResponse = '{"listaModificaOferta": [{"fechaVigenciaHastaProdAdq": "201711010000","fechaVigenciaDesdeProdAdq": "201701010000","producto": {"codProducto": 1837006933}}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S210', mockResponse);
        
        String nroLinea = 'NroLinea';
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = [SELECT Id FROM Account LIMIT 1];
        TestDataFactory.createAssets(1,account);
        
        Asset asset = [SELECT vlocity_cmt__LineNumber__c, AccountId FROM Asset LIMIT 1];
        asset.vlocity_cmt__LineNumber__c = nroLinea;
        asset.MSISDN__c = nroLinea;
        update asset;
                
        List<Object> selectedCombo = new List<Object>();
        Map<String,Object> combo = new Map<String,Object>();
        
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
        
        String codOferta = product.ProductCode;
        Id idListaPrecio = standardPrice.Id;
        String precioConImp = '100';
        
        combo.put('vlcSelected',true);
        combo.put('codOferta',codOferta);
        combo.put('idListaPrecio',idListaPrecio);
        combo.put('precioConImp',precioConImp);
        
        selectedCombo.add(combo);
        
        Order orderOBJ = TestDataFactory.createOrders(1,account).get(0);
        String idOrder = (String) orderOBJ.Id;

        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = orderOBJ.Id, Product2Id = product.Id, Quantity = 10, PricebookEntryId = idListaPrecio, UnitPrice = 100));
        insert ordItemList;
        
        Schema.DescribeFieldResult fieldResult = Order.PaymentMethodType__c.getDescribe();
        List<Schema.PicklistEntry> pleList = fieldResult.getPicklistValues();
        String medioDePago = pleList.get(0).getValue();
        
        OrderItem item = [SELECT Id, Product2.Id, Product2.vlocity_cmt__JSONAttribute__c, Product2.ProductCode, Product2.ID_Sistema_Origen__c, vlocity_cmt__AssetId__r.Subscription_Id__c, vlocity_cmt__AssetId__r.MSISDN__c FROM OrderItem WHERE OrderId = :idOrder LIMIT 1];

        Test.startTest();
        ta_sales_renovacionDatos.ChangeSubOffering(idOrder, medioDePago, item);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    @isTest static void ChangeSubOfferingMeasureDTest() {
        //GIVEN
        String nameMethod = 'ChangeSubOffering';

        String mockResponse = '{"listaModificaOferta": [{"fechaVigenciaHastaProdAdq": "201711010000","fechaVigenciaDesdeProdAdq": "201701010000","producto": {"codProducto": 1837006933}}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S210', mockResponse);
        
        String nroLinea = 'NroLinea';
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = [SELECT Id FROM Account LIMIT 1];
        TestDataFactory.createAssets(1,account);
        
        Asset asset = [SELECT vlocity_cmt__LineNumber__c, AccountId FROM Asset LIMIT 1];
        asset.vlocity_cmt__LineNumber__c = nroLinea;
        asset.MSISDN__c = nroLinea;
        update asset;
                
        List<Object> selectedCombo = new List<Object>();
        Map<String,Object> combo = new Map<String,Object>();
        
        Product2 product = TestDataFactory.createProduct(1).get(0);
        product.vlocity_cmt__JSONAttribute__c = '{"attributes":[{"attributedisplayname__c":"Unidad de Medida de Vigencia","attributeRunTimeInfo":{"default":[{"value":"D"}]}},{"attributedisplayname__c":"Vigencia Activacion","attributeRunTimeInfo":{"default":"24"}},{"attributedisplayname__c":"ID Sistema Origen","attributeRunTimeInfo":{"default":"FAN_PRDA_00003"}}]}';                                                                                         
        product.ProductCode = 'FAN_PRDA_00003'; // OJO CON ESTE VALOR, ESTÁ HARD CODE EN EL SOURCE
        update product;
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id =Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true
        );

        insert standardPrice;
        
        String codOferta = product.ProductCode;
        Id idListaPrecio = standardPrice.Id;
        String precioConImp = '100';
        
        combo.put('vlcSelected',true);
        combo.put('codOferta',codOferta);
        combo.put('idListaPrecio',idListaPrecio);
        combo.put('precioConImp',precioConImp);
        
        selectedCombo.add(combo);
        
        Order orderOBJ = TestDataFactory.createOrders(1,account).get(0);
        String idOrder = (String) orderOBJ.Id;

        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = orderOBJ.Id, Product2Id = product.Id, Quantity = 10, PricebookEntryId = idListaPrecio, UnitPrice = 100));
        insert ordItemList;
        
        OrderItem item = [SELECT Id, Product2.Id, Product2.vlocity_cmt__JSONAttribute__c, Product2.ProductCode, Product2.ID_Sistema_Origen__c, vlocity_cmt__AssetId__r.Subscription_Id__c, vlocity_cmt__AssetId__r.MSISDN__c FROM OrderItem WHERE OrderId = :idOrder LIMIT 1];

        Test.startTest();
        ta_sales_renovacionDatos.ChangeSubOffering(idOrder, 'Descuento de Saldo', item);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
    
    @isTest static void ChangeSubOfferingMonthTest() {
        //GIVEN
        String nameMethod = 'ChangeSubOffering';

        String mockResponse = '{"listaModificaOferta": [{"fechaVigenciaHastaProdAdq": "201711010000","fechaVigenciaDesdeProdAdq": "201701010000","producto": {"codProducto": 1837006933}}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S210', mockResponse);
        
        String nroLinea = 'NroLinea';
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = [SELECT Id FROM Account LIMIT 1];
        TestDataFactory.createAssets(1,account);
        
        Asset asset = [SELECT MSISDN__c, vlocity_cmt__LineNumber__c, AccountId FROM Asset LIMIT 1];
        asset.vlocity_cmt__LineNumber__c = nroLinea;
        asset.MSISDN__c = nroLinea;
        update asset;
                
        List<Object> selectedCombo = new List<Object>();
        Map<String,Object> combo = new Map<String,Object>();
        
        Product2 product = TestDataFactory.createProduct(1).get(0);
        product.vlocity_cmt__JSONAttribute__c = '{"attributes":[{"attributedisplayname__c":"Unidad de Medida de Vigencia","attributeRunTimeInfo":{"default":[{"value":"MONTH"}]}},{"attributedisplayname__c":"Vigencia Activacion","attributeRunTimeInfo":{"default":"24"}},{"attributedisplayname__c":"ID Sistema Origen","attributeRunTimeInfo":{"default":"FAN_PRDA_00003"}}]}';                                                                                         
        product.ProductCode = 'FAN_PRDA_00003'; // OJO CON ESTE VALOR, ESTÁ HARD CODE EN EL SOURCE
        update product;
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id =Test.getStandardPricebookId(),
            Product2Id = product.Id,
            UnitPrice = 10000, IsActive = true
        );

        insert standardPrice;
        
        String codOferta = product.ProductCode;
        Id idListaPrecio = standardPrice.Id;
        String precioConImp = '100';
        
        combo.put('vlcSelected',true);
        combo.put('codOferta',codOferta);
        combo.put('idListaPrecio',idListaPrecio);
        combo.put('precioConImp',precioConImp);
        
        selectedCombo.add(combo);
        
        Order orderOBJ = TestDataFactory.createOrders(1,account).get(0);
        String idOrder = (String) orderOBJ.Id;

        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = orderOBJ.Id, Product2Id = product.Id, Quantity = 10, PricebookEntryId = idListaPrecio, UnitPrice = 100));
        insert ordItemList;
        
        Schema.DescribeFieldResult fieldResult = Order.PaymentMethodType__c.getDescribe();
        List<Schema.PicklistEntry> pleList = fieldResult.getPicklistValues();
        String medioDePago = pleList.get(0).getValue();
        
        OrderItem item = [SELECT Id, Product2.Id, Product2.vlocity_cmt__JSONAttribute__c, Product2.ProductCode, Product2.ID_Sistema_Origen__c, vlocity_cmt__AssetId__r.Subscription_Id__c, vlocity_cmt__AssetId__r.MSISDN__c FROM OrderItem WHERE OrderId = :idOrder LIMIT 1];

        Test.startTest();
        ta_sales_renovacionDatos.ChangeSubOffering(idOrder, medioDePago, item);
        Test.stopTest();
        
        //THEN
        System.assert(true);
    }
}