@isTest
public class IFS_S446_addNewProductTest {

    private static String expectedResponse = null;
    private static String response = null;
    private static final String K_MSISDN_OK  = '47774777';
    private static final String K_MSISDN_NOK = '49994999';
    private static final String K_SUBSCRIPTION_ID_OK = '1234567890';
    private static final String K_CANAL_OK = 'IVR';
    private static final String K_CANAL_NOK = 'Presencial';
    private static final String K_ORDER_NAME = 'TestOrderS446';
    private static final String K_CATALOGO_NAME = 'IVR';
    private static final String K_ACCOUNT_NAME = 'TestIFSS446Account';
    private static final String K_ROOT_ASSET_NAME = 'Plan Con Tarjeta REPRO';
    private static final String K_ORDER_TEMPLATE_NAME = 'Pack IVR Order Template'; //-- Template Name.


    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

        Order order = [SELECT Id FROM Order WHERE Name = :K_ORDER_NAME];
        Id priceBookEntryId = getPricebookId();

        jsonObj.orderId = order.Id;
        jsonObj.codCanal = K_CANAL_OK;
        OfertaClass oferta = new OfertaClass();
        oferta.cantidad = '1';
        oferta.idListaPrecio = String.valueOf(priceBookEntryId);
        jsonObj.lstOferta.add(oferta);

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/addNewProduct/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S446_addNewProduct.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 

        Test.stopTest();
    }


    /**
     * @Objetivo: No mandar parametros obligatorios para forzar el status code 400.
     */
    @isTest static void testResponseAnotherStatus400 () {
        FromJSONBad jsonObj = new FromJSONBad();


        jsonObj.idOrden = '0123456';
        jsonObj.canalCod = K_CANAL_NOK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/addNewProduct/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S446_addNewProduct.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }    


    /**
     * @Objetivo: No mandar parametros obligatorios para forzar el status code 400.
     */
    @isTest static void testResponseStatus400 () {
        FromJSON jsonObj = new FromJSON();

        Order order = [SELECT Id FROM Order WHERE Name = :K_ORDER_NAME];
        Id priceBookEntryId = getPricebookId();

        jsonObj.orderId = order.Id;
        jsonObj.codCanal = K_CANAL_NOK;
        OfertaClass oferta = new OfertaClass();
        oferta.cantidad = '1';
        oferta.idListaPrecio = String.valueOf(priceBookEntryId);
        jsonObj.lstOferta.add(oferta);

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/addNewProduct/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S446_addNewProduct.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }    

    /**
     * @Objetivo: Mandar parametros con datos incorrectos para forzar error funcional 417.
     */
    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();

        Order order = [SELECT Id FROM Order WHERE Name = :K_ORDER_NAME];
        Id priceBookEntryId = getPricebookId();

        jsonObj.orderId = '01234567';
        jsonObj.codCanal = K_CANAL_OK;
        OfertaClass oferta = new OfertaClass();
        oferta.cantidad = '1';
        oferta.idListaPrecio = String.valueOf(priceBookEntryId);
        jsonObj.lstOferta.add(oferta);

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/addNewProduct/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S446_addNewProduct.getPost();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 

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
        vlocity_cmt__PriceList__c priceList = createPriceList(priceBook.Id);

        Product2 prodPlan = createProductPlan();
        Product2 packOps = createVirtualProduct('Packs Opcionales', 'FAN_PV_PACK_PRE');
        Product2 packDatos = createVirtualProduct('Packs de Datos', 'FAN_PV_PACK_DATOS_PRE');
        Product2 packInt = createConcreteProduct('Pack Internet x 30 dias', 'FAN_PRDA_00094', 'Pack', 'Datos', 'Offer', true, true);        
        Product2 packBeneficio = createConcreteProduct('Beneficio Internet X Dia', 'FAN_PV_BUL_000013', 'Pack', 'Datos', 'Offer', true, false);        

        insertProdRel (prodPlan, packOps, 1, 1, 1, false);
        insertProdRel (packOps, packDatos, 0, 1, 0, true);
        insertProdRel (packDatos, packInt, 0, 1, 0, true);
        insertProdRel (packInt, packBeneficio, 0, 1, 0, false);
        insertProdRel (packBeneficio, null, 1, 1, 1, false);

        vlocity_cmt__Catalog__c catalogo = createCatalog ();
        vlocity_cmt__CatalogProductRelationship__c relCatalogProd = createProductCatalogRelationship (catalogo, packInt);

        Asset rootAsset = createRootAsset(account, prodPlan, priceList, createPriceBookEntry(prodPlan));
        Asset opsAsset = createAsset(account, packOps, null, priceList, rootAsset, rootAsset, createPriceBookEntry(packOps), 'A11');
        Asset datosAsset = createAsset(account, packDatos, null, priceList, rootAsset, opsAsset, createPriceBookEntry(packDatos), 'A111');
        Asset packAsset = createAsset(account, packInt, '0001.0001', priceList, rootAsset, datosAsset, createPriceBookEntry(packInt), 'A1111');
        Asset beneficioAsset = createAsset(account, packBeneficio, '0001.0001.0001', priceList, rootAsset, packAsset, createPriceBookEntry(packBeneficio), 'A1111');

        createOrder(priceList, account);

        Order ot = createOrderTemplate (account, priceList);
        List<OrderItem> lstOrderTemplateItems = createOrderItem(ot, rootAsset, packAsset, beneficioAsset);

        System.debug('----- Sali de crearDatosPrueba');
    }


    public static Asset createAsset(Account pAccount, Product2 pProduct, String pLineNumber, vlocity_cmt__PriceList__c pPriceList, Asset pRootAsset, Asset pParentAsset, PricebookEntry pPriceBookEntry, String pAssetReferenceId){
        System.debug('---------- Entre en createAsset()'); 
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
        a.vlocity_cmt__LineNumber__c=pLineNumber;
        a.vlocity_cmt__EffectiveQuantity__c=1;
        a.vlocity_cmt__EffectiveOneTimeTotal__c=0.0;
        //a.vlocity_cmt__PriceListId__c=pPriceList.Id;
        a.vlocity_cmt__RootItemId__c=pRootAsset.Id;
        a.vlocity_cmt__ParentItemId__c=pParentAsset.Id; 
        insert a;

        a = [SELECT Id, Product2Id, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Name = :K_ASSET_NAME];
        a.vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000045":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgMUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Provisionable","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000067","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHJUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":false,"default":false,"dataType":"Checkbox"},"valuedescription__c":null,"valuedatatype__c":"Checkbox","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgLUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":71,"displaysequence__c":"71","attributedisplayname__c":"Facturable en Venta","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000068","categoryname__c":"Caracteristicas Principales","categorycode__c":"FAN_ATTCAT_000045","attributecategoryid__c":"a0F6C000000Bor5UAC","attributeid__c":"a0G6C000000pwHOUAY","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}],"FAN_ATTCAT_000047":[{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"FAN_PV_GFNF_VOZ","default":"FAN_PV_GFNF_VOZ","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":"FAN_PV_GFNF_VOZ","uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UtBVUA0","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":false,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"null","attributedisplayname__c":"Id de Grupo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000142","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyfcUAA","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"value":"44444444","dataType":"Text"},"valuedescription__c":null,"valuedatatype__c":"Text","value__c":null,"uidisplaytype__c":null,"rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgNUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"10","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000057","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pw2RUAQ","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null},{"$$AttributeDefinitionEnd$$":null,"attributeRunTimeInfo":{"selectedItem":{"value":"Offnet","id":30,"displayText":"Offnet"},"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}],"default":[],"uiDisplayType":"Dropdown","dataType":"Picklist"},"valuedescription__c":null,"valuedatatype__c":"Picklist","value__c":"MOVIL","uidisplaytype__c":"Dropdown","rulemessage__c":null,"isrequired__c":false,"id":"a0D6C000000UrgOUAS","querylabel__c":null,"isquerydriven__c":false,"isreadonly__c":false,"querycode__c":null,"objecttype__c":"Product2","valueinnumber__c":null,"ishidden__c":false,"isconfigurable__c":true,"hasrule__c":false,"formatmask__c":null,"customconfiguitemplate__c":null,"categorydisplaysequence__c":73,"displaysequence__c":"73","attributedisplayname__c":"Tipo Numero Amigo","isactive__c":true,"attributecloneable__c":true,"attributefilterable__c":true,"attributedisplaysequence__c":"1","attributeconfigurable__c":true,"attributeuniquecode__c":"FAN_ATT_000129","categoryname__c":"Configuracion FnF","categorycode__c":"FAN_ATTCAT_000047","attributecategoryid__c":"a0F6C000000BoryUAC","attributeid__c":"a0G6C000000pyB7UAI","objectid__c":"01t6C000000aBb7QAE","$$AttributeDefinitionStart$$":null}]}';
        update a;

        a = [SELECT Id, Product2Id, vlocity_cmt__LineNumber__c, vlocity_cmt__PricebookEntryId__c, vlocity_cmt__JSONAttribute__c FROM Asset WHERE Name = :K_ASSET_NAME];
        System.debug(a);
        return  a;
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


    private static void insertProdRel (Product2 pProduct, Product2 pChildProduct, Integer pMin, Integer pMax, Integer pDefault, Boolean pIsVirtual) {
        vlocity_cmt__ProductChildItem__c prodChild = new vlocity_cmt__ProductChildItem__c();
        prodChild.vlocity_cmt__ParentProductId__c = pProduct.Id;
        if (pChildProduct != null) {
            prodChild.vlocity_cmt__ChildProductId__c = pChildProduct.Id;
        }
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
        prodChild.vlocity_cmt__IsVirtualItem__c=pIsVirtual;
        insert prodChild;
    }


    private static Product2 createProductPlan() {
        System.debug('---------- Entre en createProductPlan()');
        String K_PRODUCT_PLAN_NAME = 'Plan Con Tarjeta REPRO';
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
    
    private static Product2 createVirtualProduct(String pName, String pCode) {
        System.debug('---------- Entre en createVirtualProduct()');
        String K_PRODUCT_NAME = pName;
        Product2 prod = new Product2(Name=K_PRODUCT_NAME);
        prod.ProductCode = pCode;
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__IsNotAssetizable__c=false;
        prod.vlocity_cmt__Type__c='Pack';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c='Group';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = false;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name FROM Product2 WHERE Name = :K_PRODUCT_NAME];
    }

    private static Product2 createConcreteProduct(String pName, String pCode, String pType, String pSubType, String pSpecificationType, boolean pIsNotAssetizable, boolean pOrderable) {
        System.debug('---------- Entre en createConcreteProduct()');
        String K_PRODUCT_NAME = pName;
        Product2 prod = new Product2(Name=K_PRODUCT_NAME);
        prod.ProductCode = pCode;
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__IsNotAssetizable__c=pIsNotAssetizable;
        prod.vlocity_cmt__Type__c=pType;
        prod.vlocity_cmt__SubType__c=pSubType;
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c=pSpecificationType;
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = pOrderable;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__EffectiveDate__c = Date.today().addDays(-1);
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id, Name FROM Product2 WHERE Name = :K_PRODUCT_NAME];
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
            vlocity_cmt__Description__c='Create for IFS_S445 Testing', vlocity_cmt__Pricebook2Id__c=priceBookId);

        insert taPriceList;
        return  [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'PRL_TELCOM'];
    }
    
    private static Product2 createProduct() {
        System.debug('---------- Entre en createProduct()');
        Product2 prod = new Product2(Name='TestProduct');
        insert prod;
        return  [SELECT Id FROM Product2 WHERE Name = 'TestProduct'];
    }

    private static Pricebook2 createPriceBook(){
        System.debug('---------- Entre en createPriceBook()');
        Pricebook2 priceBook = new Pricebook2(Name='PriceBook for IFS_S446 Testing');
        insert priceBook;
        return  [SELECT Id FROM Pricebook2 WHERE Name = 'PriceBook for IFS_S446 Testing'];
    }

    private static PricebookEntry createPriceBookEntry(Product2 pProd, Pricebook2 pPriceBook2) {
        System.debug('---------- Entre en createPriceBookEntry()');
        Id standardPBId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBId,
            Product2Id = pProd.Id, UnitPrice = 111.85, IsActive = true);

        insert standardPrice;
        return  [SELECT Id FROM PricebookEntry WHERE Product2Id = :pProd.Id AND IsActive = true AND Pricebook2Id = :standardPBId];
    }    

    private static PricebookEntry createPriceBookEntry(Product2 pProduct) {
        System.debug('---------- Entre en createPriceBookEntry(1)');
        Id standardPBId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPBId, Product2Id = pProduct.Id, UnitPrice = 10.00, IsActive = true);
        insert standardPrice;
        return  [SELECT Id FROM PricebookEntry WHERE Product2Id = :pProduct.Id AND IsActive = true AND Pricebook2Id = :standardPBId];
    }    


    private static vlocity_cmt__Catalog__c createCatalog () {
      System.debug('---------- Entre en createCatalog()');  
      vlocity_cmt__Catalog__c catalogo = new vlocity_cmt__Catalog__c(
          Name=K_CATALOGO_NAME, vlocity_cmt__Description__c='Catalog for IFS_S446 Testing', vlocity_cmt__IsActive__c=true);  
        insert catalogo;
        return  [SELECT Id, Name FROM vlocity_cmt__Catalog__c WHERE Name = :catalogo.Name ];
    }

    private static vlocity_cmt__CatalogProductRelationship__c createProductCatalogRelationship (vlocity_cmt__Catalog__c pCatalogo, Product2 pProd) {
        System.debug('---------- Entre en createProductCatalogRelationship()'); 
        vlocity_cmt__CatalogProductRelationship__c prodCatalogRel = new vlocity_cmt__CatalogProductRelationship__c(
            Name=pCatalogo.Name, vlocity_cmt__CatalogId__c=pCatalogo.Id, vlocity_cmt__IsActive__c=true, vlocity_cmt__Product2Id__c=pProd.Id );

        insert prodCatalogRel;
        return  [SELECT Id, vlocity_cmt__Product2Id__c FROM vlocity_cmt__CatalogProductRelationship__c WHERE Name=:pCatalogo.Name];
    }

    public static Asset createAssetRoot(Account pAcc){
        System.debug('---------- Entre en createAssetRoot()'); 
        Asset a = new Asset();
        a.Product2Id = createPlan().Id;
        a.Accountid = pAcc.Id;
        a.name = 'RootAsset-Test';
        a.MSISDN__c = K_MSISDN_OK;
        insert a;
        return  [SELECT Id FROM Asset WHERE Accountid = :pAcc.Id AND Name = 'RootAsset-Test'];
    }

    private static Product2 createPlan (){
        System.debug('---------- Entre en createPlan()'); 
        Product2 service = new Product2(Name='Plan - Test', Family='Movil');
        insert service;
        return  [SELECT Id FROM Product2 WHERE Name = 'Plan - Test' AND Family = 'Movil'];
    }


	static void createOrder(vlocity_cmt__PriceList__c pTAPriceList, Account pAccount) {
		Order order = new Order(Name=K_ORDER_NAME, AccountId=pAccount.Id, EffectiveDate=Date.today(),
									Status='Draft', Pricebook2Id =Test.getStandardPricebookId(),
										vlocity_cmt__PriceListId__c=pTAPriceList.Id, Delivery_Method__c='Delivery',
                                        Description='M:'+ K_MSISDN_OK,
													vlocity_cmt__OriginatingChannel__c='Agentes');

		insert order;
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

    public static List<OrderItem> createOrderItem(Order pOrder, Asset pRootAsset, Asset pChild1Asset, Asset pChild2Asset) {
        System.debug('Entre en createOrderItem () - pOrder --> ' + pOrder + ' - pRootAsset --> ' + pRootAsset + ' - pChild1Asset --> ' + pChild1Asset + ' - pChild2Asset --> ' + pChild2Asset);
        List<OrderItem> OIList = new List<OrderItem>(); 

        OIList.add(new OrderItem(OrderId=pOrder.id, Quantity=decimal.valueof('1'), UnitPrice=1, vlocity_cmt__AssetId__c=pRootAsset.Id,
                PricebookEntryId=pRootAsset.vlocity_cmt__PricebookEntryId__c, vlocity_cmt__Product2Id__c=pRootAsset.Product2Id));
        //OIList.add(new OrderItem(OrderId=pOrder.id, Quantity=decimal.valueof('1'), UnitPrice=1, vlocity_cmt__AssetReferenceId__c='A1',vlocity_cmt__AssetId__c=pRootAsset.Id,
        //        PricebookEntryId=standardPrice.id));


        OrderItem oiChildVoz = new OrderItem(OrderId=pOrder.id);
        oiChildVoz.Quantity=decimal.valueof('1');
        oiChildVoz.UnitPrice=1;
        oiChildVoz.vlocity_cmt__AssetId__c=pChild1Asset.Id;
        oiChildVoz.PricebookEntryId=pChild1Asset.vlocity_cmt__PricebookEntryId__c;
        oiChildVoz.vlocity_cmt__JSONAttribute__c=pChild1Asset.vlocity_cmt__JSONAttribute__c;
        oiChildVoz.vlocity_cmt__Product2Id__c=pChild1Asset.Product2Id;
        oiChildVoz.vlocity_cmt__LineNumber__c=pChild1Asset.vlocity_cmt__LineNumber__c;
        
        OIList.add(oiChildVoz);

        OrderItem oiChildSms = new OrderItem(OrderId=pOrder.id);
        oiChildSms.Quantity=decimal.valueof('1');
        oiChildSms.UnitPrice=1;
        oiChildSms.vlocity_cmt__AssetId__c=pChild2Asset.Id;
        oiChildSms.PricebookEntryId=pChild2Asset.vlocity_cmt__PricebookEntryId__c;
        oiChildSms.vlocity_cmt__JSONAttribute__c=pChild2Asset.vlocity_cmt__JSONAttribute__c;
        oiChildSms.vlocity_cmt__Product2Id__c=pChild2Asset.Product2Id;
        oiChildSms.vlocity_cmt__LineNumber__c=pChild1Asset.vlocity_cmt__LineNumber__c;
        
        OIList.add(oiChildSms);

        //OIList.add(new OrderItem(OrderId=pOrder.id, Quantity=decimal.valueof('1'), UnitPrice=1,vlocity_cmt__AssetReferenceId__c='A2', vlocity_cmt__AssetId__c=pChildAsset.Id,
        //        PricebookEntryId=standardPrice.id));

        insert OIList; 

        return OIList;
    }



    static Id getPricebookId () {
        vlocity_cmt__CatalogProductRelationship__c prodCatalogRel = [SELECT Id, vlocity_cmt__Product2Id__c FROM vlocity_cmt__CatalogProductRelationship__c WHERE Name=:K_CATALOGO_NAME];
        Id productId = prodCatalogRel.vlocity_cmt__Product2Id__c;
        PricebookEntry priceBookEntry = [SELECT Id FROM PricebookEntry WHERE ProductCode = 'FAN_PRDA_00094' AND IsActive = true ];
        return priceBookEntry.Id;
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


    private class FromJSON {
        public String orderId; 
        public String codCanal;
        public String preFactura;
        public List<OfertaClass> lstOferta;
        public FromJSON() {
            lstOferta = new List<OfertaClass>();
        }
    }

    private class OfertaClass {
        public String idListaPrecio;
        public String cantidad;
    }

    private class FromJSONBad {
        public String idOrden; 
        public String canalCod;
    }
    
}