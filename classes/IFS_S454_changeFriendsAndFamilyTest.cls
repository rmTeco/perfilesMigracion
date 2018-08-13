@isTest
public class IFS_S454_changeFriendsAndFamilyTest {

    private static final String K_MSISDN_OK  = '47774777';
    private static final String K_MSISDN_NOK = '49994999';
    private static final String K_SUBSCRIPTION_ID_OK  = '1234567890';

    private static final String K_ACCOUNT_NAME = 'TestIFSS453Account';
    private static final String K_PRODUCT_NAME = 'Numero Amigo de Voz';
    private static final String K_PRODUCT_NAME_SMS = 'Numero Amigo de Sms';
    private static final String K_PRODUCT_PLAN_NAME = 'Plan Con Tarjeta REPRO';
    private static final String K_ASSET_NAME = 'Numeros Amigos';
    private static final String K_ROOT_ASSET_NAME = K_PRODUCT_PLAN_NAME;
    private static final String K_ORDER_TEMPLATE_NAME = 'Friends&Family Order Template'; //-- Template Name.

    @isTest static void testResponseMSISDNStatus200 () {
        FromJSON jsonObj = new FromJSON();

        Asset assetVoz = getAsset(K_PRODUCT_NAME);
        Asset assetSms = getAsset(K_PRODUCT_NAME_SMS);
        
        Asset rootAsset = getRootAsset();
        Product2 product2 = getProduct();
        Id priceBookEntryId = getPricebookEntryId (product2);

        LineaClass lineaVoz = new LineaClass();
        lineaVoz.assetId= assetVoz.Id;
        lineaVoz.nroLinea='49994097';
        lineaVoz.tipoLinea='Onnet';

        LineaClass lineaSms = new LineaClass();
        lineaSms.assetId= 'B2'; //assetSms.Id;
        lineaSms.nroLinea='49994098';
        lineaSms.tipoLinea='Onnet';

        OfertaClass ofertaVoz = new OfertaClass();
        ofertaVoz.codOperacion='A';
        ofertaVoz.ofertaId='A211'; //-- rootAsset.Id;
        ofertaVoz.lstLineas.add(lineaVoz);

        OfertaClass ofertaSms = new OfertaClass();
        ofertaSms.codOperacion='B';
        ofertaSms.ofertaId='B211'; //-- rootAsset.Id;
        ofertaSms.lstLineas.add(lineaSms);

        jsonObj.lstOfertas.add(ofertaVoz);
        jsonObj.lstOfertas.add(ofertaSms);

        jsonObj.choiceId.nroLinea = K_MSISDN_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/changeFriendsAndFamily/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S454_changeFriendsAndFamily.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 

        Test.stopTest();
    }


    @isTest static void testResponseSubscriptionIdStatus200 () {
        FromJSON jsonObj = new FromJSON();

        Asset assetVoz = getAsset(K_PRODUCT_NAME);
        Asset assetSms = getAsset(K_PRODUCT_NAME_SMS);
        Asset rootAsset = getRootAsset();
        Product2 product2 = getProduct();
        Id priceBookEntryId = getPricebookEntryId (product2);

        LineaClass linea = new LineaClass();
        linea.assetId= assetVoz.Id;
        linea.nroLinea='49994097';
        linea.tipoLinea='Onnet';

        OfertaClass oferta = new OfertaClass();
        oferta.codOperacion='A';
        oferta.ofertaId='A211'; //-- rootAsset.Id;
        oferta.lstLineas.add(linea);

        jsonObj.lstOfertas.add(oferta);
        jsonObj.choiceId.subscriberId = K_SUBSCRIPTION_ID_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/changeFriendsAndFamily/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S454_changeFriendsAndFamily.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseSubscriptionIdStatus400 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.choiceId.subscriberId = '';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/changeFriendsAndFamily/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S454_changeFriendsAndFamily.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseSubscriptionIdStatus417 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.choiceId.subscriberId = '0123456';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/changeFriendsAndFamily/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S454_changeFriendsAndFamily.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseSubscriptionIdStatus500 () {
        FromJsonBad jsonObj = new FromJsonBad();

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/changeFriendsAndFamily/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S454_changeFriendsAndFamily.getPost();

        System.assertEquals(Integer.valueOf('500'), RestContext.response.statuscode); 

        Test.stopTest();
    }


    ///////////////// Metodos de Creacion datos de Prueba //////////////////////

    @TestSetup
    private static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        Account account = createAccount();
        createCustomFieldMaps();
        //-- Perfiles del usuario --//
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        createWorkTeamMember (workTeam.Id);
        //-- Datos de la prueba
        Pricebook2 priceBook = createPriceBook();
        Product2 prodCharge = createProductCharge();
        createPriceBookEntry(prodCharge);
        Product2 productRoot = createProductPlan();
        Product2 productFnFVozRoot = createFnFRootVozProduct();
        Product2 productFnFSmsRoot = createFnFRootSmsProduct();
        Product2 productGrpFnFVoz = createGrpFnFVozProduct();
        Product2 productGrpFnFSms = createGrpFnFSmsProduct();
        Product2 productChildVoz = createFnFProductVoz();
        Product2 productChildSms = createFnFProductSMS();

        insertProdRel (productRoot, 1, 1, 1);
        insertProdRel (productFnFVozRoot, 1, 1, 1);
        insertProdRel (productFnFSmsRoot, 1, 1, 1);
        insertProdRel (productGrpFnFVoz, 1, 1, 1);
        insertProdRel (productGrpFnFSms, 1, 1, 1);
        insertProdRel (productChildVoz, 0, 1, 0);
        insertProdRel (productChildSms, 0, 1, 0);
        
        vlocity_cmt__PriceList__c priceList = createPriceList(priceBook.Id);
        //PricebookEntry priceBookEntry = createPriceBookEntry(productChildVoz, priceBook);
        Asset rootAsset = createRootAsset(account, productRoot, priceList, createPriceBookEntry(productRoot));

        Asset rootFnFVozAsset = createRootFnFAsset(account, productFnFVozRoot, priceList, rootAsset, rootAsset, createPriceBookEntry(productFnFVozRoot), 'A2');
        Asset rootFnFSmsAsset = createRootFnFAsset(account, productFnFSmsRoot, priceList, rootAsset, rootAsset, createPriceBookEntry(productFnFSmsRoot), 'B2');

        Asset grpFnFVozAsset = createGrpFnFAsset(account, productGrpFnFVoz, priceList, rootAsset, rootFnFVozAsset, createPriceBookEntry(productGrpFnFVoz), 'A21');
        Asset grpFnFSmsAsset = createGrpFnFAsset(account, productGrpFnFSms, priceList, rootAsset, rootFnFSmsAsset, createPriceBookEntry(productGrpFnFSms), 'B21');

        Asset fnFVozAsset = createFnFAsset(account, productChildVoz, priceList, rootAsset, grpFnFVozAsset, createPriceBookEntry(productChildVoz), 'A211');
        Asset fnFSmsAsset = createFnFAsset(account, productChildSms, priceList, rootAsset, grpFnFSmsAsset, createPriceBookEntry(productChildSms), 'B211');

        Order ot = createOrderTemplate (account, priceList);
        List<OrderItem> lstOrderTemplateItems = createOrderItem(ot, rootAsset, fnFVozAsset, fnFSmsAsset);
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
    private static void createCustomFieldMaps() {
        String nsPrefix = 'vlocity_cmt__';
        vlocity_cmt__CustomFieldMap__c customFieldMap1 = new vlocity_cmt__CustomFieldMap__c(  Name='setting 1',
                                                                    vlocity_cmt__SourceFieldName__c = 'Quantity',
                                                                    vlocity_cmt__DestinationFieldName__c ='Quantity',
                                                                    vlocity_cmt__DestinationSObjectType__c='OrderItem',
                                                                    vlocity_cmt__SourceSObjectType__c='Asset');
        insert customFieldMap1;
        vlocity_cmt__CustomFieldMap__c customFieldMap2 = new vlocity_cmt__CustomFieldMap__c(  Name='setting 2',
                                                                    vlocity_cmt__SourceFieldName__c = 'Price',
                                                                    vlocity_cmt__DestinationFieldName__c ='UnitPrice',
                                                                    vlocity_cmt__DestinationSObjectType__c='OrderItem',
                                                                    vlocity_cmt__SourceSObjectType__c='Asset');
        

        insert customFieldMap2;
        vlocity_cmt__CustomFieldMap__c customFieldMap3 = new vlocity_cmt__CustomFieldMap__c(  Name='setting 3',
                                                                    vlocity_cmt__SourceFieldName__c = 'Product2Id',
                                                                    vlocity_cmt__DestinationFieldName__c = nsPrefix + 'Product2Id__c',
                                                                    vlocity_cmt__DestinationSObjectType__c='OrderItem',
                                                                    vlocity_cmt__SourceSObjectType__c='Asset');
        insert customFieldMap3;
        
        vlocity_cmt__CustomFieldMap__c customFieldMap4 = new vlocity_cmt__CustomFieldMap__c(  Name='setting 4',
                                                                    vlocity_cmt__SourceFieldName__c = 'Name',
                                                                    vlocity_cmt__DestinationFieldName__c = 'Name',
                                                                    vlocity_cmt__DestinationSObjectType__c='Order',
                                                                    vlocity_cmt__SourceSObjectType__c='Account');
        insert customFieldMap4;
        
        vlocity_cmt__CustomFieldMap__c customFieldMap5 = new vlocity_cmt__CustomFieldMap__c(  Name='setting 5',
                                                                    vlocity_cmt__SourceFieldName__c =  nsPrefix +'PricebookEntryId__c',
                                                                    vlocity_cmt__DestinationFieldName__c = 'PricebookEntryId',
                                                                    vlocity_cmt__DestinationSObjectType__c='OrderItem',
                                                                    vlocity_cmt__SourceSObjectType__c='Asset');
        insert customFieldMap5;
        
        vlocity_cmt__CustomFieldMap__c customFieldMap6 = new vlocity_cmt__CustomFieldMap__c(  Name='setting 6',
                                                                    vlocity_cmt__SourceFieldName__c =  nsPrefix +'LineNumber__c',
                                                                    vlocity_cmt__DestinationFieldName__c = nsPrefix +'LineNumber__c',
                                                                    vlocity_cmt__DestinationSObjectType__c='OrderItem',
                                                                    vlocity_cmt__SourceSObjectType__c='Asset');  
        insert customFieldMap6;                 
        
        
        vlocity_cmt__CustomFieldMap__c customFieldMapoli7 = new vlocity_cmt__CustomFieldMap__c(   Name='settingOLI 7',
                                                                    vlocity_cmt__SourceFieldName__c = 'Name',
                                                                    vlocity_cmt__DestinationFieldName__c = 'Name',
                                                                    vlocity_cmt__DestinationSObjectType__c=nsPrefix+'AccountPriceAdjustment__c',
                                                                    vlocity_cmt__SourceSObjectType__c=nsPrefix+'OrderPriceAdjustment__c');
        insert customFieldMapoli7;  
        
        vlocity_cmt__CustomFieldMap__c customFieldMapoli8 = new vlocity_cmt__CustomFieldMap__c(   Name='settingOLI 8',
                                                                    vlocity_cmt__SourceFieldName__c = nsPrefix +'AssetReferenceId__c',
                                                                    vlocity_cmt__DestinationFieldName__c = nsPrefix +'AssetReferenceId__c',
                                                                    vlocity_cmt__DestinationSObjectType__c= 'OrderItem',
                                                                    vlocity_cmt__SourceSObjectType__c= 'Asset');
        insert customFieldMapoli8;  
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
    

    private static void insertProdRel (Product2 pProduct, Integer pMin, Integer pMax, Integer pDefault) {
        vlocity_cmt__ProductChildItem__c prodChild = new vlocity_cmt__ProductChildItem__c();
        prodChild.vlocity_cmt__ParentProductId__c = pProduct.Id;
        prodChild.vlocity_cmt__MaxQuantity__c=pMax;
        prodChild.vlocity_cmt__MinQuantity__c=pMin;
        prodChild.vlocity_cmt__MinQuantity__c=pDefault;
        prodChild.vlocity_cmt__CollapseHierarchy__c=false;
        prodChild.CreatedDate=DateTime.now().addDays(-1);
        prodChild.vlocity_cmt__Quantity__c=1.0;
        prodChild.Price_Included__c=false;
        prodChild.Name=pProduct.Name;
        prodChild.vlocity_cmt__ChildLineNumber__c='1';
        prodChild.vlocity_cmt__RelationshipType__c='Child';
        prodChild.vlocity_cmt__IsVirtualItem__c=false;
        insert prodChild;
    }

    private static Product2 createFnFProductVoz() {
        System.debug('---------- Entre en createFnFProductVoz()');
        Product2 prod = new Product2(Name=K_PRODUCT_NAME);
        prod.ProductCode = 'FAN_PV_FNF_00001';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__Type__c='Numeros Amigos';
        prod.vlocity_cmt__SubType__c='VOZ';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = true;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name, vlocity_cmt__JSONAttribute__c FROM Product2 WHERE Name = :K_PRODUCT_NAME];
    }

    private static Product2 createFnFProductSMS() {
        System.debug('---------- Entre en createFnFProductSMS()');
        final String K_PRODUCT_NAME_SMS='Numero Amigo de SMS';
        Product2 prod = new Product2(Name=K_PRODUCT_NAME_SMS);
        prod.ProductCode = 'FAN_PV_FNF_00002';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__Type__c='Numeros Amigos';
        prod.vlocity_cmt__SubType__c='SMS';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = true;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGInQAM","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtCKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_SMS","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_SMS","value":"FAN_PV_GFNF_SMS"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGInQAM","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtCLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":"5555555555"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGInQAM","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtCMUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}],"default":[],"selectedItem":{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGInQAM","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtCEUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGInQAM","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtCFUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name, vlocity_cmt__JSONAttribute__c FROM Product2 WHERE Name = :K_PRODUCT_NAME_SMS];
    }



    private static Product2 createFnFRootVozProduct() {
        System.debug('---------- Entre en createFnFRootVozProduct()');
        final String K_FNF_NAME = 'Numeros gratis a Personal 1 para voz contra recarga';
        Product2 prod = new Product2(Name=K_FNF_NAME);
        prod.ProductCode = 'FAN_PA_FNF_00001';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__Type__c='FAN Producto Friend and Family';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = false;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, vlocity_cmt__JSONAttribute__c, Name FROM Product2 WHERE Name = :K_FNF_NAME];
    }

    private static Product2 createFnFRootSmsProduct() {
        System.debug('---------- Entre en createFnFRootSmsProduct()');
        final String K_FNF_NAME = 'Numeros gratis a Personal 1 para sms contra recarga';
        Product2 prod = new Product2(Name=K_FNF_NAME);
        prod.ProductCode = 'FAN_PA_FNF_00002';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__Type__c='FAN Producto Friend and Family';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = false;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, vlocity_cmt__JSONAttribute__c, Name FROM Product2 WHERE Name = :K_FNF_NAME];
    }

    private static Product2 createGrpFnFVozProduct() {
        System.debug('---------- Entre en createGrpFnFProduct()');
        final String K_FNF_NAME = 'Grupo Numeros Amigos de Voz';
        Product2 prod = new Product2(Name=K_FNF_NAME);
        prod.ProductCode = 'FAN_PV_GFNF_VOZ';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__Type__c='FAN Producto Friend and Family';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = false;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000010":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvpqUAA","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000011","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Cobertura Uso Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgnUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"N","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Nacional","id":20,"value":"N"}],"values":[{"displayText":"DDI Internacional","id":50,"value":"IDDI"},{"displayText":"Internacional","id":30,"value":"I"},{"displayText":"Local","id":10,"value":"L"},{"displayText":"Nacional","id":20,"value":"N"},{"displayText":"Roaming Internacional","id":40,"value":"IROA"}],"selectedItem":{"displayText":"Nacional","id":20,"value":"N"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvpvUAA","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000012","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Red de Uso Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgoUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"ONNET","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"A Personal","id":10,"value":"ONNET"}],"values":[{"displayText":"A Personal","id":10,"value":"ONNET"},{"displayText":"A otras compañias","id":20,"value":"OFFNET"},{"displayText":"Todo Destino","id":30,"value":"NODISTINGUE"}],"selectedItem":{"displayText":"A Personal","id":10,"value":"ONNET"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw0LUAQ","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000047","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Sentido Trafico","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgpUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MO","valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Saliente","id":20,"value":"MO"}],"values":[{"displayText":"Entrante","id":10,"value":"MT"},{"displayText":"Saliente","id":20,"value":"MO"}],"selectedItems":[{"displayText":"Saliente","id":20,"value":"MO"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw2CUAQ","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000055","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo de Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgqUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"VOICE","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Voz","id":10,"value":"VOICE"}],"values":[{"displayText":"Datos","id":40,"value":"DATA"},{"displayText":"MMS","id":30,"value":"MMS"},{"displayText":"SMS","id":20,"value":"SMS"},{"displayText":"Voz","id":10,"value":"VOICE"}],"selectedItem":{"displayText":"Voz","id":10,"value":"VOICE"}},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000030":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw2HUAQ","attributecategoryid__c":"a0F6C000000Boq7UAC","categorycode__c":"FAN_ATTCAT_000030","categoryname__c":"Tarifa de Uso","attributeuniquecode__c":"FAN_ATT_000056","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Porcentaje de Descuento","displaysequence__c":"70","categorydisplaysequence__c":70,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":100,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgrUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"100","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"100","value":100},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvqtUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgsUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"1","value":"1"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvr8UAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000032","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgtUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Numeros amigos de voz","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"Numeros amigos de voz","value":"Numeros amigos de voz"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgwUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Huawei","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Huawei","id":10,"value":"Huawei"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"Infotainment","id":30,"value":"Infotainment"},{"displayText":"SAP","id":20,"value":"SAP"}],"selectedItem":{"displayText":"Huawei","id":10,"value":"Huawei"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgvUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrguUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name, ProductCode FROM Product2 WHERE Name = :K_FNF_NAME];
    }

    private static Product2 createGrpFnFSMSProduct() {
        System.debug('---------- Entre en createGrpFnFProduct()');
        final String K_FNF_NAME = 'Grupo Numeros Amigos de Sms';
        Product2 prod = new Product2(Name=K_FNF_NAME);
        prod.ProductCode = 'FAN_PV_GFNF_SMS';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__Type__c='FAN Producto Friend and Family';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = false;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000010":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvpqUAA","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000011","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Cobertura Uso Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgnUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"N","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Nacional","id":20,"value":"N"}],"values":[{"displayText":"DDI Internacional","id":50,"value":"IDDI"},{"displayText":"Internacional","id":30,"value":"I"},{"displayText":"Local","id":10,"value":"L"},{"displayText":"Nacional","id":20,"value":"N"},{"displayText":"Roaming Internacional","id":40,"value":"IROA"}],"selectedItem":{"displayText":"Nacional","id":20,"value":"N"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvpvUAA","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000012","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Red de Uso Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgoUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"ONNET","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"A Personal","id":10,"value":"ONNET"}],"values":[{"displayText":"A Personal","id":10,"value":"ONNET"},{"displayText":"A otras compañias","id":20,"value":"OFFNET"},{"displayText":"Todo Destino","id":30,"value":"NODISTINGUE"}],"selectedItem":{"displayText":"A Personal","id":10,"value":"ONNET"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw0LUAQ","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000047","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Sentido Trafico","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgpUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MO","valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Saliente","id":20,"value":"MO"}],"values":[{"displayText":"Entrante","id":10,"value":"MT"},{"displayText":"Saliente","id":20,"value":"MO"}],"selectedItems":[{"displayText":"Saliente","id":20,"value":"MO"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw2CUAQ","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000055","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo de Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgqUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"VOICE","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Voz","id":10,"value":"VOICE"}],"values":[{"displayText":"Datos","id":40,"value":"DATA"},{"displayText":"MMS","id":30,"value":"MMS"},{"displayText":"SMS","id":20,"value":"SMS"},{"displayText":"Voz","id":10,"value":"VOICE"}],"selectedItem":{"displayText":"Voz","id":10,"value":"VOICE"}},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000030":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw2HUAQ","attributecategoryid__c":"a0F6C000000Boq7UAC","categorycode__c":"FAN_ATTCAT_000030","categoryname__c":"Tarifa de Uso","attributeuniquecode__c":"FAN_ATT_000056","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Porcentaje de Descuento","displaysequence__c":"70","categorydisplaysequence__c":70,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":100,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgrUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"100","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"100","value":100},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvqtUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgsUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"1","value":"1"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvr8UAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000032","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgtUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Numeros amigos de voz","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"Numeros amigos de voz","value":"Numeros amigos de voz"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgwUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Huawei","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Huawei","id":10,"value":"Huawei"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"Infotainment","id":30,"value":"Infotainment"},{"displayText":"SAP","id":20,"value":"SAP"}],"selectedItem":{"displayText":"Huawei","id":10,"value":"Huawei"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgvUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrguUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name, ProductCode FROM Product2 WHERE Name = :K_FNF_NAME];
    }

    private static Product2 createProductPlan() {
        System.debug('---------- Entre en createProduct()');
        Product2 prod = new Product2(Name=K_PRODUCT_PLAN_NAME);
        prod.ProductCode = 'FAN_PTRHU';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__Type__c='Plan Prepago';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c='Offer';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = true;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name FROM Product2 WHERE Name = :K_PRODUCT_PLAN_NAME];
    }

    private static Product2 createProductCharge() {
        System.debug('---------- Entre en createProductCharge()');
        Product2 prod = new Product2(Name='Cargo por Cambio o Baja Numero Amigo');
        prod.ProductCode = 'FAN_PSERV_00007';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__Type__c='Plan Prepago';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c='Service';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = true;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000EC7qUAG","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000156","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"No Aplica Promocion Financiera","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cdUaUAI","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Ut5kUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Ut5lUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"No Aplica","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Opcional","id":20,"value":"Opcional"}],"values":[{"displayText":"Requerido","id":10,"value":"Requerido"},{"displayText":"Opcional","id":20,"value":"Opcional"},{"displayText":"No Aplica","id":30,"value":"No Aplica"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000pyG9UAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000139","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Alicuota","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":21,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Ut5mUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"21","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"21"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000pyNgUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000140","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Canal","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Ut5nUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"IVR","id":10,"value":"IVR"},{"displayText":"USSD","id":20,"value":"USSD"}],"default":[]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Ut5YUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_ADMINISTRATIVOS","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Cargo por Cambio o Baja","id":10,"value":"C_OT_MB_ADMINISTRATIVOS"}],"values":[{"displayText":"Cargo por Cambio o Baja","id":10,"value":"C_OT_MB_ADMINISTRATIVOS"}]},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Ut5jUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGEzQAM","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Ut5iUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name FROM Product2 WHERE Name = 'Cargo por Cambio o Baja Numero Amigo'];
    }



    static Product2 getProduct () {
        return  [SELECT Id FROM Product2 WHERE Name = :K_PRODUCT_NAME];
    }

    public static Asset createFnFAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList, Asset pRootAsset, Asset pParentAsset, PricebookEntry pPriceBookEntry, String pAssetReferenceId){
        System.debug('---------- Entre en createFnFAsset()'); 
        String K_ASSET_NAME = pProduct.Name;
        Asset a = new Asset(Name=K_ASSET_NAME);
        a.Product2Id = pProduct.Id;
        a.Accountid = pAccount.Id;
        a.Quantity=1.0;
        a.Price = 1.0;
        a.BundleStatus__c='Inactive';
        a.vlocity_cmt__AssetReferenceId__c=pAssetReferenceId;
        a.vlocity_cmt__PricebookEntryId__c = pPriceBookEntry.Id;
        a.vlocity_cmt__Action__c='Existing';
        a.vlocity_cmt__LineNumber__c='0001.0001.0001.0001';
        //a.vlocity_cmt__PricebookEntryId__c = Test.getStandardPricebookId();
        a.vlocity_cmt__EffectiveQuantity__c=1;
        a.vlocity_cmt__EffectiveOneTimeTotal__c=0.0;
        //a.vlocity_cmt__PriceListId__c=pPriceList.Id;
        a.vlocity_cmt__RootItemId__c=pRootAsset.Id;
        a.vlocity_cmt__ParentItemId__c=pParentAsset.Id; 
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000045":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgMUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Provisionable","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000067","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHJUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgLUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Facturable en Venta","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000068","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHOUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}],"FAN_ATTCAT_000047":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"FAN_PV_GFNF_VOZ","default":"FAN_PV_GFNF_VOZ","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":"FAN_PV_GFNF_VOZ","uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UtBVUA0","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"null","attributedisplayname__c":"Id de Grupo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000142","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyfcUAA","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"44444444","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgNUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"10","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000057","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pw2RUAQ","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"selectedItem":{"value":"Offnet","id":30,"displayText":"Offnet"},"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}],"default":[],"uiDisplayType":"Dropdown","dataType":"Picklist"},"valuedescription__c":null,"valuedatatype__c":"Picklist","value__c":"MOVIL","uidisplaytype__c":"Dropdown","rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgOUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Tipo Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000129","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyB7UAI","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}]}';
        insert a;

        a = [SELECT Id, Product2Id, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Name = :K_ASSET_NAME];
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000045":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgMUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Provisionable","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000067","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHJUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgLUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Facturable en Venta","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000068","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHOUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}],"FAN_ATTCAT_000047":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"FAN_PV_GFNF_VOZ","default":"FAN_PV_GFNF_VOZ","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":"FAN_PV_GFNF_VOZ","uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UtBVUA0","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"null","attributedisplayname__c":"Id de Grupo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000142","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyfcUAA","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"44444444","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgNUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"10","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000057","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pw2RUAQ","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"selectedItem":{"value":"Offnet","id":30,"displayText":"Offnet"},"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}],"default":[],"uiDisplayType":"Dropdown","dataType":"Picklist"},"valuedescription__c":null,"valuedatatype__c":"Picklist","value__c":"MOVIL","uidisplaytype__c":"Dropdown","rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgOUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Tipo Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000129","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyB7UAI","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}]}';
        update a;

        return  [SELECT Id, Product2Id, vlocity_cmt__PricebookEntryId__c, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Name = :K_ASSET_NAME];
    }

    public static Asset createGrpFnFAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList, Asset pRootAsset, Asset pParentAsset, PricebookEntry pPriceBookEntry, String pAssetReferenceId){
        System.debug('---------- Entre en createGrpFnFAsset()'); 
        String K_GRP_FNF_ASSET_NAME = pProduct.Name;
        Asset a = new Asset(Name=K_GRP_FNF_ASSET_NAME);
        a.Product2Id = pProduct.Id;
        a.Accountid = pAccount.Id;
        a.Quantity=1.0;
        a.Price = 1.0;
        a.BundleStatus__c='Inactive';
        a.vlocity_cmt__AssetReferenceId__c=pAssetReferenceId;
        a.vlocity_cmt__PricebookEntryId__c = pPriceBookEntry.Id;
        a.vlocity_cmt__Action__c='Existing';
        a.vlocity_cmt__LineNumber__c='0001.0001.0001';
        //a.vlocity_cmt__PricebookEntryId__c = Test.getStandardPricebookId();
        a.vlocity_cmt__EffectiveQuantity__c=1;
        a.vlocity_cmt__EffectiveOneTimeTotal__c=0.0;
        //a.vlocity_cmt__PriceListId__c=pPriceList.Id;
        a.vlocity_cmt__RootItemId__c=pRootAsset.Id;
        a.vlocity_cmt__ParentItemId__c=pParentAsset.Id; 
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000010":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvpqUAA","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000011","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Cobertura Uso Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgnUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"N","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Nacional","id":20,"value":"N"}],"values":[{"displayText":"DDI Internacional","id":50,"value":"IDDI"},{"displayText":"Internacional","id":30,"value":"I"},{"displayText":"Local","id":10,"value":"L"},{"displayText":"Nacional","id":20,"value":"N"},{"displayText":"Roaming Internacional","id":40,"value":"IROA"}],"selectedItem":{"displayText":"Nacional","id":20,"value":"N"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvpvUAA","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000012","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Red de Uso Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgoUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"ONNET","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"A Personal","id":10,"value":"ONNET"}],"values":[{"displayText":"A Personal","id":10,"value":"ONNET"},{"displayText":"A otras compañias","id":20,"value":"OFFNET"},{"displayText":"Todo Destino","id":30,"value":"NODISTINGUE"}],"selectedItem":{"displayText":"A Personal","id":10,"value":"ONNET"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw0LUAQ","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000047","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Sentido Trafico","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgpUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MO","valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Saliente","id":20,"value":"MO"}],"values":[{"displayText":"Entrante","id":10,"value":"MT"},{"displayText":"Saliente","id":20,"value":"MO"}],"selectedItems":[{"displayText":"Saliente","id":20,"value":"MO"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw2CUAQ","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000055","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo de Servicio","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgqUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"VOICE","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Voz","id":10,"value":"VOICE"}],"values":[{"displayText":"Datos","id":40,"value":"DATA"},{"displayText":"MMS","id":30,"value":"MMS"},{"displayText":"SMS","id":20,"value":"SMS"},{"displayText":"Voz","id":10,"value":"VOICE"}],"selectedItem":{"displayText":"Voz","id":10,"value":"VOICE"}},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000030":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pw2HUAQ","attributecategoryid__c":"a0F6C000000Boq7UAC","categorycode__c":"FAN_ATTCAT_000030","categoryname__c":"Tarifa de Uso","attributeuniquecode__c":"FAN_ATT_000056","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Porcentaje de Descuento","displaysequence__c":"70","categorydisplaysequence__c":70,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":100,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgrUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"100","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"100","value":100},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvqtUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgsUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"1","value":"1"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvr8UAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000032","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Nombre Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgtUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Numeros amigos de voz","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"Numeros amigos de voz","value":"Numeros amigos de voz"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgwUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"Huawei","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Huawei","id":10,"value":"Huawei"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"Infotainment","id":30,"value":"Infotainment"},{"displayText":"SAP","id":20,"value":"SAP"}],"selectedItem":{"displayText":"Huawei","id":10,"value":"Huawei"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgvUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBbMQAU","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrguUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}]}';
        insert a;

        return  [SELECT Id FROM Asset WHERE Name = :K_GRP_FNF_ASSET_NAME];
    }

    public static Asset createRootFnFAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList, Asset pRootAsset, Asset pParentAsset, PricebookEntry pPriceBookEntry, String pAssetReferenceId){
        System.debug('---------- Entre en createRootFnFAsset()'); 
        String K_ROOT_FNF_NAME=pProduct.Name;
        Asset a = new Asset(Name=K_ROOT_FNF_NAME);
        a.Product2Id = pProduct.Id;
        a.Accountid = pAccount.Id;
        a.Quantity=1.0;
        a.Price = 1.0;
        a.BundleStatus__c='Inactive';
        a.vlocity_cmt__AssetReferenceId__c=pAssetReferenceId;
        a.vlocity_cmt__PricebookEntryId__c = pPriceBookEntry.Id;
        a.vlocity_cmt__Action__c='Existing';
        a.vlocity_cmt__LineNumber__c='0001.0001';
        //a.vlocity_cmt__PricebookEntryId__c = Test.getStandardPricebookId();
        a.vlocity_cmt__EffectiveQuantity__c=1;
        a.vlocity_cmt__EffectiveOneTimeTotal__c=0.0;
        //a.vlocity_cmt__PriceListId__c=pPriceList.Id;
        a.vlocity_cmt__RootItemId__c=pRootAsset.Id;
        a.vlocity_cmt__ParentItemId__c=pParentAsset.Id; 
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000045":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgMUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Provisionable","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000067","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHJUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgLUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Facturable en Venta","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000068","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHOUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}],"FAN_ATTCAT_000047":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"FAN_PV_GFNF_VOZ","default":"FAN_PV_GFNF_VOZ","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":"FAN_PV_GFNF_VOZ","uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UtBVUA0","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"null","attributedisplayname__c":"Id de Grupo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000142","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyfcUAA","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"44444444","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgNUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"10","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000057","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pw2RUAQ","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"selectedItem":{"value":"Offnet","id":30,"displayText":"Offnet"},"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}],"default":[],"uiDisplayType":"Dropdown","dataType":"Picklist"},"valuedescription__c":null,"valuedatatype__c":"Picklist","value__c":"MOVIL","uidisplaytype__c":"Dropdown","rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgOUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Tipo Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000129","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyB7UAI","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}]}';
        insert a;

        return  [SELECT Id, vlocity_cmt__PricebookEntryId__c, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Name = :K_ROOT_FNF_NAME];
    }

    /**
     * Obtiene el Asset creado
     */
    public static Asset getAsset(String pAssetName) {
        return  [SELECT Id FROM Asset WHERE Name = :pAssetName];
    }

    public static Asset createRootAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList, PricebookEntry pPriceBookEntry){
        System.debug('---------- Entre en createRootAsset()'); 
        Asset a = new Asset(Name=K_ROOT_ASSET_NAME);
        a.Product2Id = pProduct.Id;
        a.Accountid = pAccount.Id;
        a.MSISDN__c=K_MSISDN_OK;
        a.Quantity=1.0;
        a.Price = 1.0;
        a.BundleStatus__c='Active';
        a.vlocity_cmt__AssetReferenceId__c='A1';
        a.vlocity_cmt__PricebookEntryId__c = pPriceBookEntry.Id;
        a.vlocity_cmt__Action__c='Existing';
        a.Subscription_Id__c=K_SUBSCRIPTION_ID_OK;
        a.vlocity_cmt__EffectiveQuantity__c=1;
        a.vlocity_cmt__EffectiveOneTimeTotal__c=0.0;
        //a.vlocity_cmt__PriceListId__c=pPriceList.Id;
        a.vlocity_cmt__LineNumber__c='0001';
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000046":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1iUAA","attributecategoryid__c":"a0F6C000000BortUAC","categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF", "attributeuniquecode__c":"FAN_ATT_000049","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true, "attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Cantidad Maxima de Lineas Total","displaysequence__c":"72", "categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false, "valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null, "id":"a0D6C000000UqaIUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number", "valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null}, {"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1nUAA","attributecategoryid__c":"a0F6C000000BortUAC", "categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000050","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas ONNET","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null, "hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false, "isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaHUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1", "valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null}, {"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1sUAA","attributecategoryid__c":"a0F6C000000BortUAC", "categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000051","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas OFFNET","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null, "hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false, "isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaGUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"0", "valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"0","value":0},"$$AttributeDefinitionEnd$$":null}, {"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw1xUAA","attributecategoryid__c":"a0F6C000000BortUAC", "categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000052","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas DDI","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null,"formatmask__c":null, "hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":0,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null, "isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaDUAS","isrequired__c":false,"rulemessage__c":null, "uidisplaytype__c":null,"value__c":"0","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"0", "value":0},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw22UAA", "attributecategoryid__c":"a0F6C000000BortUAC","categorycode__c":"FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c": "FAN_ATT_000053","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true, "isactive__c":true,"attributedisplayname__c":"Cantidad Maxima de Lineas Fijas","displaysequence__c":"72","categorydisplaysequence__c":72, "customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":0, "objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaEUAS", "isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"0","valuedatatype__c":"Number","valuedescription__c":null, "attributeRunTimeInfo":{"dataType":"Number","default":"0","value":0},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null, "objectid__c":"01t6C000000a3HZQAY","attributeid__c":"a0G6C000000pw27UAA","attributecategoryid__c":"a0F6C000000BortUAC","categorycode__c": "FAN_ATTCAT_000046","categoryname__c":"Caracteristicas FnF","attributeuniquecode__c":"FAN_ATT_000054","attributeconfigurable__c":true, "attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c": "Cantidad Maxima de Lineas Moviles","displaysequence__c":"72","categorydisplaysequence__c":72,"customconfiguitemplate__c":null, "formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2", "querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqaFUAS","isrequired__c":false, "rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo": {"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null}]}';

        insert a;

        a = [SELECT Id FROM Asset WHERE Name = :K_ROOT_ASSET_NAME];
        a.vlocity_cmt__RootItemId__c = a.Id;
        update a;

        return  [SELECT Id, Product2Id, vlocity_cmt__PricebookEntryId__c, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Name = :K_ROOT_ASSET_NAME];
    }

    public static Asset getRootAsset() {
        return  [SELECT Id, Product2Id, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Name = :K_ROOT_ASSET_NAME];
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


    private static PricebookEntry createPriceBookEntry(Product2 pProduct) {
        System.debug('---------- Entre en createPriceBookEntry(1)');
        Id standardPBId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBId,
            Product2Id = pProduct.Id, UnitPrice = 10.00, IsActive = true);

        insert standardPrice;
        return  [SELECT Id FROM PricebookEntry WHERE Product2Id = :pProduct.Id AND IsActive = true AND Pricebook2Id = :standardPBId];
    }    


    private static Id getPricebookEntryId (Product2 pProduct) {
        PricebookEntry priceBookEntry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :pProduct.Id AND IsActive = true AND Pricebook2Id = :Test.getStandardPricebookId()];
        return priceBookEntry.Id;
    }

    private static Order createOrderTemplate (Account acc, vlocity_cmt__PriceList__c taPriceList) {
        Order o = new Order(Name=K_ORDER_TEMPLATE_NAME,
            AccountId=acc.Id, EffectiveDate=Date.today(), Status='Draft',  Pricebook2Id=Test.getStandardPricebookId(),
            vlocity_cmt__PriceListId__c=taPriceList.Id);

        o.Delivery_Method__c='Presencial';
        o.vlocity_cmt__OriginatingChannel__c='Agentes';
        o.Gestion__c='Alta';
        insert o;
        return [SELECT Id FROM Order WHERE Name = :K_ORDER_TEMPLATE_NAME];
    }

    public static List<OrderItem> createOrderItem(Order pOrder, Asset pRootAsset, Asset pChildVozAsset, Asset pChildSmsAsset) {
        System.debug('Entre en createOrderItem () - pOrder --> ' + pOrder + ' - pRootAsset --> ' + pRootAsset + ' - pChildVozAsset --> ' + pChildVozAsset + ' - pChildSmsAsset --> ' + pChildSmsAsset);
        List<OrderItem> OIList = new List<OrderItem>(); 

        OIList.add(new OrderItem(OrderId=pOrder.id, Quantity=decimal.valueof('1'), UnitPrice=1, vlocity_cmt__AssetId__c=pRootAsset.Id,
                PricebookEntryId=pRootAsset.vlocity_cmt__PricebookEntryId__c, vlocity_cmt__Product2Id__c=pRootAsset.Product2Id));
        //OIList.add(new OrderItem(OrderId=pOrder.id, Quantity=decimal.valueof('1'), UnitPrice=1, vlocity_cmt__AssetReferenceId__c='A1',vlocity_cmt__AssetId__c=pRootAsset.Id,
        //        PricebookEntryId=standardPrice.id));


        OrderItem oiChildVoz = new OrderItem(OrderId=pOrder.id);
        oiChildVoz.Quantity=decimal.valueof('1');
        oiChildVoz.UnitPrice=1;
        oiChildVoz.vlocity_cmt__AssetId__c=pChildVozAsset.Id;
        oiChildVoz.PricebookEntryId=pChildVozAsset.vlocity_cmt__PricebookEntryId__c;
        oiChildVoz.vlocity_cmt__JSONAttribute__c=pChildVozAsset.vlocity_cmt__JSONAttribute__c;
        oiChildVoz.vlocity_cmt__Product2Id__c=pChildVozAsset.Product2Id;
        
        OIList.add(oiChildVoz);

        OrderItem oiChildSms = new OrderItem(OrderId=pOrder.id);
        oiChildSms.Quantity=decimal.valueof('1');
        oiChildSms.UnitPrice=1;
        oiChildSms.vlocity_cmt__AssetId__c=pChildSmsAsset.Id;
        oiChildSms.PricebookEntryId=pChildSmsAsset.vlocity_cmt__PricebookEntryId__c;
        oiChildSms.vlocity_cmt__JSONAttribute__c=pChildSmsAsset.vlocity_cmt__JSONAttribute__c;
        oiChildSms.vlocity_cmt__Product2Id__c=pChildSmsAsset.Product2Id;
        
        OIList.add(oiChildSms);

        //OIList.add(new OrderItem(OrderId=pOrder.id, Quantity=decimal.valueof('1'), UnitPrice=1,vlocity_cmt__AssetReferenceId__c='A2', vlocity_cmt__AssetId__c=pChildAsset.Id,
        //        PricebookEntryId=standardPrice.id));

        insert OIList; 

        return OIList;
    }

    private static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = getCreatedAccount('TelecomTest');
        System.debug('------------ Despues de crear el Account (Organization) ----');

        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Telefónico',
             Channel_Type__c='Call Center', Channel_Type_2__c='Ventas', Channel_Type_3__c='Ventas',
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
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId);
        wtm.Is_Active__c=true;
        wtm.UserRoleAPIName__c='Call Center';
        insert wtm;
    }


    private class FromJson {
        public ChoiceClass choiceId;
        List<OfertaClass> lstOfertas;
        public FromJson() {
            choiceId = new ChoiceClass();
            lstOfertas = new List<OfertaClass>();
        }
    }

    private class ChoiceClass {
        public String subscriberId;
        public String nroLinea;
    }

    private class OfertaClass {
        public String codOperacion;
        public String ofertaId;
        List<LineaClass> lstLineas;
        public OfertaClass() {
            lstLineas = new List<LineaClass>();
        }
    }

    private class LineaClass {
        public String assetId;
        public String priceBookEntryId;
        public String nroLinea;
        public String tipoLinea;
    }

    private class FromJsonBad {
        public Integer v = null;
    }


}