/**
 * Clase que realiza el Test del Servicio: S506
 * Apex Classe: IFS_S506_getAvailableLoansTest.cls
 *
 * @Author: Alejandro Salord (Certa Consulting)
 * @Version: 1.0
 */
@isTest
public class IFS_S506_getAvailableLoansTest {

    static final String K_ACCOUNT_NAME = 'TestIFSS506Account';
    static final String K_MSISDN = '1154775070';
    static final String K_SUBSCRIPTION_ID = '1234567890';
    static final String K_MSISDN_BAD = '1154775069';
    static final String K_PRODUCT_ROOT_NAME = 'Plan Con Tarjeta REPRO';    
    static final String K_PRODUCT_CHILD_NAME = 'Recarga SOS';    
    static final String K_ROOT_ASSET_NAME = 'Plan Con Tarjeta REPRO';

    @isTest static void testResponseStatus200_MSISDN () {
        FromJson jrq = new FromJson();

        jrq.choiceId.nroLinea = K_MSISDN; //--> Asigno el MSISDN

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableLoans/';  
        req.httpMethod = 'POST';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(JSON.serialize(jrq));
        RestContext.request = req;
        RestContext.response = res;

        IFS_S506_getAvailableLoans.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseStatus200_SUBSCRIPTION_ID () {
        FromJson jrq = new FromJson();

        jrq.choiceId.codSuscripcion = K_SUBSCRIPTION_ID; 

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableLoans/';  
        req.httpMethod = 'POST';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(JSON.serialize(jrq));
        RestContext.request = req;
        RestContext.response = res;

        IFS_S506_getAvailableLoans.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseStatus400 () {
        FromJson jrq = new FromJson();

        jrq.choiceId.nroLinea = ''; //--> Asigno el MSISDN
        jrq.choiceId.codSuscripcion = ''; //--> Asigno el subscriptionId

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableLoans/';  
        req.httpMethod = 'POST';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(JSON.serialize(jrq));
        RestContext.request = req;
        RestContext.response = res;

        IFS_S506_getAvailableLoans.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseStatus417 () {
        FromJson jrq = new FromJson();

        jrq.choiceId.nroLinea = K_MSISDN_BAD; //--> Asigno el MSISDN

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableLoans/';  
        req.httpMethod = 'POST';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(JSON.serialize(jrq));
        RestContext.request = req;
        RestContext.response = res;

        IFS_S506_getAvailableLoans.getPost();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseStatus500 () {
        FromBadJson jrq = new FromBadJson();

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableLoans/';  
        req.httpMethod = 'POST';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        req.requestBody = Blob.valueof(JSON.serialize(jrq));
        RestContext.request = req;
        RestContext.response = res;

        IFS_S506_getAvailableLoans.getPost();

        System.assertEquals(Integer.valueOf('500'), RestContext.response.statuscode); 

        Test.stopTest();

    }

    ///////////////// Metodos de Creacion datos de Prueba //////////////////////
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
        Product2 rootProduct = createRootProduct();
        Product2 childProduct = createChildProduct();
        vlocity_cmt__ProductChildItem__c relParentChildProduct = createRelChildParent (rootProduct, childProduct);

        vlocity_cmt__PriceList__c priceList = createPriceList(priceBook.Id);
        PricebookEntry priceBookEntry = createPriceBookEntry(rootProduct, priceBook);
        Asset rootAsset = createRootAsset(account, rootProduct, priceList);
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

    private static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = getCreatedAccount('TelecomTest');
        System.debug('------------ Despues de crear el Account (Organization) ----');
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Centro de Servicio Santa Fe', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA', RecordTypeId=Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId());
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Centro de Servicio Santa Fe'];     

/*        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA');
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     */
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
        wtm.UserRoleAPIName__c = 'Care';
        insert wtm;
    }

    private static vlocity_cmt__PriceList__c createPriceList(Id priceBookId){
        System.debug('---------- Entre en createPriceList()');
        vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c(Name='Telecom Price List', vlocity_cmt__Code__c='PRL_TELCOM',
            vlocity_cmt__Description__c='Create for IFS_S495 Testing', vlocity_cmt__Pricebook2Id__c=priceBookId);

        insert taPriceList;
        return  [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'PRL_TELCOM'];
    }
    
    private static Product2 createRootProduct() {
        System.debug('---------- Entre en createProduct()');
        Product2 prod = new Product2(Name=K_PRODUCT_ROOT_NAME);
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
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000047":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pw2RUAQ","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000057","attributeconfigurable__c":true,"attributedisplaysequence__c":"10","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgNUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyB7UAI","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000129","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tipo Numero Amigo","displaysequence__c":"73","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgOUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"MOVIL","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[],"values":[{"value":"Desconocido","id":10,"displayText":"Desconocido"},{"value":"Onnet","id":20,"displayText":"Onnet"},{"value":"Offnet","id":30,"displayText":"Offnet"},{"value":"Internacional","id":40,"displayText":"Internacional"},{"value":"Linea Fija","id":50,"displayText":"Linea Fija"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pyfcUAA","attributecategoryid__c":"a0F6C000000BoryUAC","categorycode__c":"FAN_ATTCAT_000047","categoryname__c":"Configuracion FnF","attributeuniquecode__c":"FAN_ATT_000142","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Id de Grupo","displaysequence__c":"null","categorydisplaysequence__c":73,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtBVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"FAN_PV_GFNF_VOZ","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"FAN_PV_GFNF_VOZ"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgMUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aBb7QAE","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UrgLUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id FROM Product2 WHERE Name = :K_PRODUCT_ROOT_NAME];
    }

    static Product2 getRootProduct () {
        return  [SELECT Id FROM Product2 WHERE Name = :K_PRODUCT_ROOT_NAME];
    }

    static Product2 getChildProduct () {
        return  [SELECT Id FROM Product2 WHERE Name = :K_PRODUCT_CHILD_NAME];
    }

    private static Product2 createChildProduct() {
        System.debug('---------- Entre en createChildProduct()');
        Product2 prod = new Product2(Name=K_PRODUCT_CHILD_NAME);
        prod.ProductCode = 'FAN_PA_SOS_00001';
        prod.IsActive = true;
        prod.Family = 'Movil';
        prod.vlocity_cmt__Type__c='Prestamo';
        prod.vlocity_cmt__SubType__c='VOZ';
        prod.vlocity_cmt__Status__c='Active';
        prod.vlocity_cmt__SpecificationType__c='Product';
        prod.recordTypeId  = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        prod.vlocity_cmt__IsOrderable__c = true;
        prod.vlocity_cmt__IsConfigurable__c = true;
        prod.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pygGUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000148","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ID de Prestamo","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDhUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"1"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pyfwUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000143","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provision Directa","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000canwUAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDMUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Cargo por Cambio o Baja","id":10,"value":"C_OT_MB_ADMINISTRATIVOS"}],"default":[]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000010":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pyg6UAA","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000146","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Dias de Gracia Prestamo","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDYUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pygBUAQ","attributecategoryid__c":"a0F6C000000BopsUAC","categorycode__c":"FAN_ATTCAT_000010","categoryname__c":"Caracteristicas Uso del Servicio","attributeuniquecode__c":"FAN_ATT_000147","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Penalidad Prestamo","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":5,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDZUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"5","valuedatatype__c":"Currency","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Currency","default":"5"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pyg1UAA","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000145","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Monto del Prestamo","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":20,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDXUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"20","valuedatatype__c":"Currency","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Currency","default":"20"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000EC7qUAG","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000156","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"No Aplica Promocion Financiera","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cdULUAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDTUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDUUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pyG9UAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000139","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Alicuota","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":21,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDVUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"21","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"21"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pyNgUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000140","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Canal","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDWUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"IVR","id":10,"value":"IVR"},{"displayText":"USSD","id":20,"value":"USSD"}],"default":[]},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDSUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aGLEQA2","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtDRUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}';

        insert prod;
        return  [SELECT Id FROM Product2 WHERE Name = :K_PRODUCT_CHILD_NAME];
    }


    private static vlocity_cmt__ProductChildItem__c createRelChildParent (Product2 pParentProduct, Product2 pChildProduct) {
        vlocity_cmt__ProductChildItem__c childProduct = new vlocity_cmt__ProductChildItem__c();
        childProduct.vlocity_cmt__ChildProductId__c = pChildProduct.Id;
        childProduct.vlocity_cmt__CollapseHierarchy__c = false;
        childProduct.vlocity_cmt__Quantity__c = 0.0;
        childProduct.vlocity_cmt__GlobalKey__c = 'a93b84db-6567-ddf5-791e-63d3cd3fb466';
        childProduct.vlocity_cmt__IsOverride__c = false;
        childProduct.vlocity_cmt__IsRootProductChildItem__c = false;
        childProduct.vlocity_cmt__MaximumChildItemQuantity__c = 99999.0;
        childProduct.vlocity_cmt__MaxQuantity__c = 1.0;
        childProduct.vlocity_cmt__MinimumChildItemQuantity__c = 0.0;
        childProduct.vlocity_cmt__MinQuantity__c = 0.0;
        childProduct.vlocity_cmt__ParentProductId__c = pParentProduct.Id;
        childProduct.Price_Included__c = false;
        childProduct.vlocity_cmt__RelationshipType__c = 'Child';
        childProduct.vlocity_cmt__ChildLineNumber__c = '80';
        childProduct.vlocity_cmt__IsVirtualItem__c = false;
        insert childProduct;

        return childProduct;

    }

    public static Asset createRootAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList){
        System.debug('---------- Entre en createRootAsset()'); 
        Asset a = new Asset(Name=K_ROOT_ASSET_NAME);
        a.Product2Id = pProduct.Id;
        a.Accountid = pAccount.Id;
        a.MSISDN__c = K_MSISDN;
        a.Subscription_Id__c = K_SUBSCRIPTION_ID;
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

    public static Asset getRootAsset() {
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

    //-- Clases para soportar el request --//
    private class FromJson {
        public ChoiceClass choiceId;
        public FromJson () {
            choiceId = new ChoiceClass();
        }
    }

    //-- Clases para soportar el request --//
    private class FromBadJson {
        public Integer i1 = 0;
    }

    private class ChoiceClass {
        public String codSuscripcion;
        public String nroLinea;
    }

}