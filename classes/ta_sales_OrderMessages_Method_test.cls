@isTest
public class ta_sales_OrderMessages_Method_test {

    private static final String K_MSISDN_OK  = '47774777';
    private static final String K_MSISDN_NOK = '49994999';

    private static final String K_ACCOUNT_NAME = 'TestIFSS453Account';
    private static final String K_PRODUCT_NAME = 'Numero Amigo de Voz';
    private static final String K_ASSET_NAME = 'Numeros Amigos';
     private static final String K_ROOT_ASSET_NAME = 'Numeros gratis a Personal 1 para voz contra recarga';


    @isTest
    static void CheckFriendsNumber_test() {
        
        //crear Product2 con distintos ProductCode, OrderItem con vlocity_cmt__Product2Id__c = Product2.Id, vlocity_cmt__ParentItemId__c = otro Order,  
        
        String methodName = 'CheckFriendsNumber';
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();
        
        //necesario para crear ordenes
        //TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> parentOrders = TestDataFactory.createOrders(1, accs[0]);
        List<OrderItem> parentOrderItems = new List<OrderItem>();
        List<OrderItem> childOrderItems = new List<OrderItem>();
        List<Product2> prods = TestDataFactory.createProduct(5);
        prods[0].ProductCode = 'FAN_PV_FNF_00001';
        prods[1].ProductCode = 'FAN_PV_FNF_00002';
        prods[2].ProductCode = 'FAN_PV_GFNF_VOZ';
        prods[3].ProductCode = 'FAN_PV_GFNF_SMS';
        prods[4].ProductCode = 'FAN_PSIM_STANDARD';
        update prods;
        String attributeC = '{"FAN_ATTCAT_000044":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudOQAS","attributeid__c":"a0G6C000000pofyUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"FAN_ATTCAT_000044","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"FAN_ATT_000038","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero de Linea","displaysequence__c":"null","categorydisplaysequence__c":18,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqfyUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text", "value":"3456787654"},"$$AttributeDefinitionEnd$$":null}]}';
        
        for (Integer i = 0;i<parentOrders.size();i++) {
            List<OrderItem> parentOrderItemsAux = TestDataFactory.createOrderItem(1, parentOrders[0]);
            List<OrderItem> childOrderItemsAux = TestDataFactory.createOrderItem(1, parentOrders[0]);
            List<OrderItem> childOrderItemsAux2 = TestDataFactory.createOrderItem(1, parentOrders[0]);
            parentOrderItemsAux[0].vlocity_cmt__ParentItemId__c = childOrderItemsAux2[0].Id;
            parentOrderItemsAux[0].vlocity_cmt__Product2Id__c = prods[i].Id;    
            parentOrderItemsAux[0].vlocity_cmt__JSONAttribute__c = attributeC;    
            parentOrderItems.add(parentOrderItemsAux[0]);
            childOrderItemsAux[0].vlocity_cmt__ParentItemId__c = parentOrderItemsAux[0].Id;
			childOrderItemsAux[0].vlocity_cmt__Product2Id__c = prods[i].Id;            
			childOrderItemsAux[0].vlocity_cmt__JSONAttribute__c = attributeC;            
            childOrderItems.add(childOrderItemsAux[0]);
            childOrderItemsAux2[0].vlocity_cmt__ParentItemId__c = childOrderItemsAux[0].Id;
			childOrderItemsAux2[0].vlocity_cmt__Product2Id__c = prods[i].Id;            
			childOrderItemsAux2[0].vlocity_cmt__JSONAttribute__c = attributeC;            
            childOrderItems.add(childOrderItemsAux2[0]);
        }

        
        update parentOrderItems;
        update childOrderItems;
        
		options.put('IdOrder',parentOrders[0].Id);
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
    }
    
    @isTest
    static void SaveNumbers_test() {
        
        String methodName = 'SaveNumbers';
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();
        //TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> parentOrders = TestDataFactory.createOrders(1, accs[0]);
        List<OrderItem> parentOrderItemsAux = TestDataFactory.createOrderItem(1, parentOrders[0]);
        parentOrderItemsAux[0].vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":1111111111,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}]}';
        update parentOrderItemsAux;
        String args = '[{"numerosAmigoVoz": [{"id":"'+parentOrderItemsAux[0].Id+'","linenumber":"43543532342","validated":true},{"id":"'+parentOrderItemsAux[0].Id+'","linenumber":"47564532342","validated":false}], "numerosAmigoSms": [{"id":"'+parentOrderItemsAux[0].Id+'","linenumber":"43543532342","validated":true}]}],"numerosAmigoVoz": [{"id":"'+parentOrderItemsAux[0].Id+'","linenumber":"43543532342","validated":true},{"id":"'+parentOrderItemsAux[0].Id+'","linenumber":"47564532342","validated":false}], "numerosAmigoSms": [{"id":"'+parentOrderItemsAux[0].Id+'","linenumber":"43543532342","validated":true}]';
        List<Object> numAmigos = (List<Object>)JSON.deserializeUntyped(args);   
        options.put('numerosAmigosXPlan',numAmigos);
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
    }

    @isTest
    static void CheckFriendsNumberFromAsset_test() {
        
        String methodName = 'CheckFriendsNumberFromAsset';
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        options.put('lineNumber', '477747777');
        string jsonResult = '{"subscriberId":null,"lstOfertas":[{"tipoServicio":"SMS","ofertaId":"02i6C0000002h1bQAA","lstLineas":[{"tipo":"Linea Fija","nroLinea":"5555555555","assetId":"02i6C0000002h1dQAA"}],"cantMaxLineasTotal":"1","cantMaxLineasOnNet":"1","cantMaxLineasOffNet":"0","cantMaxLineasMoviles":"1","cantMaxLineasFijas":"0","cantMaxLineasDDI":"0"},{"tipoServicio":"VOZ","ofertaId":"02i6C0000002h1YQAQ","lstLineas":[{"tipo":"Offnet","nroLinea":"4444444444","assetId":"02i6C0000002h1aQAA"}],"cantMaxLineasTotal":"1","cantMaxLineasOnNet":"1","cantMaxLineasOffNet":"0","cantMaxLineasMoviles":"1","cantMaxLineasFijas":"0","cantMaxLineasDDI":"0"}]}';
        options.put('jsonResult',jsonResult);
        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
    }
    
    @isTest
    static void SaveNumbersFromAsset_test() {
        String methodName = 'SaveNumbersFromAsset';

        Map<String,Object> inputMap = new Map<String, Object>();
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Product2 prod = TestDataFactory.createProduct(1)[0];
        prod.ProductCode = 'TestPC';
        update prod;
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> parentOrders = TestDataFactory.createOrders(1, accs[0]);
        List<Asset> assetAux = TestDataFactory.createAssets(1, prod, accs[0]);
        List<OrderItem> parentOrderItemsAux = TestDataFactory.createOrderItem(1, parentOrders[0]);
        Product2 product = [SELECT Id FROM Product2 where Id=:parentOrderItemsAux[0].Product2Id LIMIT 1];
        product.ProductCode = 'TestPC';
        update product;
        parentOrderItemsAux[0].vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":1111111111,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
        update parentOrderItemsAux;
        Asset assetId = assetAux[0];
        System.debug('assetId: ' + assetId.Id);

        String args = '[{"numerosAmigosXPlan":[{"numerosAmigoVoz": [{"id":"'+parentOrderItemsAux[0].Id+'","lineNumber":"43543532342","validated":true},{"id":"'+parentOrderItemsAux[0].Id+'","lineNumber":"47564532342","validated":false}], "numerosAmigoSms": [{"id":"'+parentOrderItemsAux[0].Id+'","lineNumber":"43543532342","validated":true}]}],"numerosAmigoVoz": [{"id":"'+parentOrderItemsAux[0].Id+'","lineNumber":"43543532342","validated":true,"modified":true,"originalLine":"1111111111","ofertaId":"'+String.ValueOf(assetId.Id)+'","assetId":"'+String.ValueOf(assetId.Id)+'"},{"id":"'+parentOrderItemsAux[0].Id+'","lineNumber":"47564532342","validated":false}], "numerosAmigoSms": [{"id":"'+parentOrderItemsAux[0].Id+'","lineNumber":"43543532342","validated":true}]}]';
        List<Object> numAmigos = (List<Object>) JSON.deserializeUntyped(args);
        options.put('numerosAmigosXPlan', numAmigos);

        options.put('orderId', parentOrders[0].Id);

        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();

        Test.startTest();
            testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest
    static void TransformFFIF454_test() {
        
        String methodName = 'TransformFFIF454';
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();
        List<Account> accs = TestDataFactory.createAccounts(1, 'Consumer');
        List<Order> parentOrders = TestDataFactory.createOrders(1, accs[0]);
        List<OrderItem> parentOrderItemsAux = TestDataFactory.createOrderItem(1, parentOrders[0]);
        String args = '[{"numerosAmigosXPlan":[{"numerosAmigoVoz": [{"id":"'+parentOrderItemsAux[0].Id+'","originalLine":"43543532341","lineNumber":"43543532342","assetId":"02i6C0000002h1dQAA","validated":true,"ofertaId":"02i6C0000002h1bQAA","modified":true},{"id":"'+parentOrderItemsAux[0].Id+'","originalLine":"43543532341","lineNumber":"47564532342","assetId":"02i6C0000002h1dQAA","validated":false,"ofertaId":"02i6C0000002h1bQAA","modified":true}], "numerosAmigoSms": [{"id":"'+parentOrderItemsAux[0].Id+'","originalLine":"43543532341","lineNumber":"43543532342","assetId":"02i6C0000002h1dQAA","validated":true,"ofertaId":"02i6C0000002h1bQAA","modified":true}]}],"numerosAmigoVoz": [{"id":"'+parentOrderItemsAux[0].Id+'","originalLine":"43543532341","lineNumber":"43543532342","assetId":"02i6C0000002h1dQAA","validated":true,"ofertaId":"02i6C0000002h1bQAA","modified":true},{"id":"'+parentOrderItemsAux[0].Id+'","originalLine":"43543532341","lineNumber":"47564532342","assetId":"02i6C0000002h1dQAA","validated":false,"ofertaId":"02i6C0000002h1bQAA","modified":true}], "numerosAmigoSms": [{"id":"'+parentOrderItemsAux[0].Id+'","originalLine":"43543532341","lineNumber":"43543532342","assetId":"02i6C0000002h1dQAA","validated7":true,"ofertaId":"02i6C0000002h1bQAA","modified":true}]}]';
        List<Object> numAmigos = (List<Object>)JSON.deserializeUntyped(args);   
        inputMap.put('numerosAmigosXPlan',numAmigos);
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
    }

    @isTest
    static void CallIF454_test() {
        
        String methodName = 'CallIF454';
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
    }

    @isTest
    static void sendSMSFFChanged_test() {
        
        String methodName = 'sendSMSFFChanged';
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest(); 
    }

    @isTest
    static void AddChargeCBS_test() {
        
        Map<String,Object> outMap = new Map<String, Object>();
		Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_sales_OrderMessages_Method testedClass = new ta_sales_OrderMessages_Method();
        Test.startTest();
        testedClass.AddChargeCBS();
        Test.stopTest(); 
    }

    @TestSetup
    private static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        Account account = createAccount();
        //-- Perfiles del usuario --//
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        createWorkTeamMember (workTeam.Id);
        //-- Datos de la prueba
        Pricebook2 priceBook = createPriceBook();
        Product2 product = createProduct();
        vlocity_cmt__PriceList__c priceList = createPriceList(priceBook.Id);
        PricebookEntry priceBookEntry = createPriceBookEntry(product, priceBook);
        Asset asset = createAsset(account, product, priceList);

        System.debug('----- Sali de crearDatosPrueba');
    }

    private static Account createAccount() {
        System.debug('---------- Entre en createAccount()');
        List<Account> lstAcc = new List<Account>();
        Account a = new Account(Name=K_ACCOUNT_NAME, AccountIntegrationId__c=String.valueOf(10000));
		a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        lstAcc.add(a);
        Account b = new Account(Name='TelecomTest', AccountIntegrationId__c=String.valueOf(10001));
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        lstAcc.add(b);
        insert lstAcc;
        return getCreatedAccount(K_ACCOUNT_NAME);
    }

    private static Account getCreatedAccount (String pName) {
        System.debug('-------------- Entre en getCreatedAccount()');
        Account a = [SELECT Id FROM Account WHERE Name = :pName];
        System.debug('-------------- Account Id: ' + a.Id);
        System.debug('-------------- Sali de getCreatedAccount()');
        return a;
    }

    private static vlocity_cmt__PriceList__c createPriceList(Id priceBookId){
        System.debug('---------- Entre en createPriceList()');
        vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c(Name='Telecom Price List', vlocity_cmt__Code__c='PRL_TELCOM',
            vlocity_cmt__Description__c='Create for IFS_S453 Testing', vlocity_cmt__Pricebook2Id__c=priceBookId);

        insert taPriceList;
        return  [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'PRL_TELCOM'];
    }
    
    private static Product2 createProduct() {
        System.debug('---------- Entre en createProduct()');
        Product2 prod = new Product2(Name=K_PRODUCT_NAME);
        prod.ProductCode = 'FAN_PV_FNF_00001';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__Type__c='Numeros Amigos';
        prod.vlocity_cmt__SubType__c='VOZ';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = true;
        prod.vlocity_cmt__IsConfigurable__c = true;
        //prod.vlocity_cmt__ObjectTypeId__c = 'FAN Numero Friend and Family';
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id FROM Product2 WHERE Name = :K_PRODUCT_NAME];
    }

    public static Asset createAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList){
        Asset rootAsset = createRootAsset(pAccount, pProduct, pPriceList);
        System.debug('---------- Entre en createAsset()'); 
        Asset a = new Asset(Name=K_ASSET_NAME);
        a.Product2Id = pProduct.Id;
        a.Accountid = pAccount.Id;
        a.MSISDN__c = K_MSISDN_OK;
        a.vlocity_cmt__PricebookEntryId__c = Test.getStandardPricebookId();
        a.vlocity_cmt__EffectiveQuantity__c=1;
        a.vlocity_cmt__EffectiveOneTimeTotal__c=0.0;
        a.vlocity_cmt__PriceListId__c=pPriceList.Id;
        a.vlocity_cmt__RootItemId__c=rootAsset.Id;
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000045":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgMUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Provisionable","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000067","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHJUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgLUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Facturable en Venta","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000068","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHOUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}],"FAN_ATTCAT_000047":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"FAN_PV_GFNF_VOZ","default":"FAN_PV_GFNF_VOZ","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":"FAN_PV_GFNF_VOZ","uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UtBVUA0","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"null","attributedisplayname__c":"Id de Grupo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000142","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyfcUAA","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"44444444","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgNUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"10","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000057","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pw2RUAQ","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"selectedItem":{"value":"Offnet","id":30,"displayText":"Offnet"},"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}],"default":[],"uiDisplayType":"Dropdown","dataType":"Picklist"},"valuedescription__c":null,"valuedatatype__c":"Picklist","value__c":"MOVIL","uidisplaytype__c":"Dropdown","rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgOUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Tipo Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000129","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyB7UAI","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}]}';
        insert a;

        return  [SELECT Id FROM Asset WHERE MSISDN__c = :K_MSISDN_OK AND Name = :K_ASSET_NAME];
    }


    public static Asset createRootAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList){
        System.debug('---------- Entre en createRootAsset()'); 
        Asset a = new Asset(Name=K_ROOT_ASSET_NAME);
        a.Product2Id = pProduct.Id;
        a.Accountid = pAccount.Id;
        a.vlocity_cmt__PricebookEntryId__c = Test.getStandardPricebookId();
        a.vlocity_cmt__EffectiveQuantity__c=1;
        a.vlocity_cmt__EffectiveOneTimeTotal__c=0.0;
        a.vlocity_cmt__PriceListId__c=pPriceList.Id;
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000046":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1iUAA","attributecategoryid__c":"a0F6C000000BortUAC","categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF", "attributeuniquecode__c":"FAN_ATT_000049","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true, "attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Cantidad Maxima de Lineas Total","displaysequence__c":"72", "categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false, "valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null, "id":"a0D6C000000UqaIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number", "valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null}, {"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1nUAA","attributecategoryid__c":"a0F6C000000BortUAC", "categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000050","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas ONNET","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null, "hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false, "isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaHUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1", "valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null}, {"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1sUAA","attributecategoryid__c":"a0F6C000000BortUAC", "categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000051","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas OFFNET","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null, "hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false, "isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaGUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"0", "valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"0","value":0},"$$AttributeDefinitionEnd$$":null}, {"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1xUAA","attributecategoryid__c":"a0F6C000000BortUAC", "categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000052","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas DDI","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null, "hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":0,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null, "isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaDUAS","isrequired__c":false,"rulemessage__c":null, "uidisplaytype__c":null,"value__c":"0","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"0", "value":0},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw22UAA", "attributecategoryid__c":"a0F6C000000BortUAC","categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c": "FAN_ATT_000053","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true, "isactive__c":true,"attributedisplayname__c":"Cantidad Maxima de Lineas Fijas","displaysequence__c":"72","categorydisplaysequence__c":72, "customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":0, "objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaEUAS", "isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"0","valuedatatype__c":"Number","valuedescription__c":null, "attributeRunTimeInfo":{"dataType":"Number","default":"0","value":0},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null, "objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw27UAA","attributecategoryid__c":"a0F6C000000BortUAC","categorycode__c": "FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000054","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas Moviles","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null, "formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2", "querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaFUAS","isrequired__c":false, "rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo": {"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null}]}';

        insert a;

        a = [SELECT Id FROM Asset WHERE Name = :K_ROOT_ASSET_NAME];
        a.vlocity_cmt__RootItemId__c = a.Id;
        update a;

        return  [SELECT Id FROM Asset WHERE Name = :K_ROOT_ASSET_NAME];
    }

    private static Pricebook2 createPriceBook(){
        System.debug('---------- Entre en createPriceBook()');
        Pricebook2 priceBook = new Pricebook2(Name='PriceBook for IFS_S453 Testing');
        insert priceBook;
        return  [SELECT Id FROM Pricebook2 WHERE Name = 'PriceBook for IFS_S453 Testing'];
    }

    private static PricebookEntry createPriceBookEntry(Product2 pProduct, Pricebook2 pPriceBook2) {
        System.debug('---------- Entre en createPriceBookEntry()');
        Id standardPBId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBId,
            Product2Id = pProduct.Id, UnitPrice = 111.85, IsActive = true);

        insert standardPrice;
        return  [SELECT Id FROM PricebookEntry WHERE Product2Id = :pProduct.Id AND IsActive = true AND Pricebook2Id = :standardPBId];
    }    


    static Id getPricebookEntryId (Product2 pProduct) {
        PricebookEntry priceBookEntry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :pProduct.Id AND IsActive = true AND Pricebook2Id = :Test.getStandardPricebookId()];
        return priceBookEntry.Id;
    }

    private static vlocity_cmt__BusinessSite__c createStoreLocation () {
        Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = getCreatedAccount('TelecomTest');
        System.debug('------------ Despues de crear el Account (Organization) ----');

        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(RecordTypeId=idRecordType, Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA');
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     
    }

    private static WorkTeam__c createWorkTeam (Id pStoreLocationId) {
        System.debug('---------- Entre en createWorkTeam()');
        WorkTeam__c wt = new WorkTeam__c(Name='Ventas', Team_Name__c='Ventas', Is_Active__c=true, Work_Place__c=pStoreLocationId);
        insert wt;
        return [SELECT Id FROM WorkTeam__c WHERE Name='Ventas'];
    }

    private static void createWorkTeamMember (Id pWorkTemaId) {
        System.debug('---------- Entre en createWorkTeamMember()');
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId, UserRoleAPIName__c='Test');
        insert wtm;
    }


    private class FromJSON {
        public ChoiceClass choiceId;
        public FromJSON() {
            choiceId = new ChoiceClass();
        }
    }

    private class ChoiceClass {
        public String subscriberId;
        public String nroLinea;
    }

    private class FromJSONBad {
        public String idOrden; 
        public String canalCod;
    }  
}