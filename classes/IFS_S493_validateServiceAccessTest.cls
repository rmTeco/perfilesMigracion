@isTest
public class IFS_S493_validateServiceAccessTest {

    private static final String K_MSISDN_OK  = '1168405934';
    private static final String K_MSISDN_NOK = '49994999';

    private static final String K_ACCOUNT_NAME = 'TestIFSS493Account';
    private static final String K_PRODUCT_NAME = 'Numero Amigo de Voz';
    private static final String K_CONTACT_ID = '0036C000007GFcE';
    private static final String K_CONTACT_ID_BAD = '0036C000007T1Tf';
    private static final String K_ASSET_NAME = 'Numeros Amigos';
     private static final String K_ROOT_ASSET_NAME = 'Numeros gratis a Personal 1 para voz contra recarga';


    @isTest static void testResponseStatus200 () {
        Contact contact = getContact ();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateServiceAccess/contacto/obtener/' + contact.Id;  
        req.params.put('numeroLinea', K_MSISDN_OK);
        req.httpMethod = 'GET';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S493_validateServiceAccess.getData();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 

        Test.stopTest();
    }



   @isTest static void testResponseStatus417_ERROR_CONTACT () {



















        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateServiceAccess/contacto/obtener/' + K_CONTACT_ID_BAD;  
        req.params.put('numeroLinea', K_MSISDN_OK);
        req.httpMethod = 'GET';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S493_validateServiceAccess.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 

        Test.stopTest();
    }

   @isTest static void testResponseStatus417_ERROR_MSISDN() {
        Contact contact = getContact ();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        Test.startTest();

        req.requestURI = '/v1/integrationprocedure/validateServiceAccess/contacto/obtener/' + contact.Id;  
        req.params.put('numeroLinea', K_MSISDN_NOK);
        req.httpMethod = 'GET';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S493_validateServiceAccess.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseStatus400 () {
        Contact contact = getContact ();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateServiceAccess/contacto/obtener/' + contact.Id;  
        req.params.put('numeroLinea', '');
        req.httpMethod = 'GET';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S493_validateServiceAccess.getData();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_1 () {
        Contact contact = getContact ();
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateServiceAccess/contacto/obtener/';  
        req.params.put('numeroLinea', K_MSISDN_OK);
        req.httpMethod = 'GET';
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S493_validateServiceAccess.getData();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

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
        //createWorkTeamMember (workTeam.Id);
        //-- Datos de la prueba
        createContact(account);
        Pricebook2 priceBook = createPriceBook();
        Product2 product = createProduct();
        vlocity_cmt__PriceList__c priceList = createPriceList(priceBook.Id);
        PricebookEntry priceBookEntry = createPriceBookEntry(product, priceBook);
        Asset asset = createAsset(account, product, priceList);

        System.debug('----- Sali de crearDatosPrueba');
    }

	static Contact createContact(Account pAccount){
        System.debug('---------- Entre en createContact()');
		if(pAccount==null) pAccount = createAccount();
		Contact c = new Contact(FirstName='Juan', LastName='Perez', AccountId=pAccount.Id);
        c.DocumentType__c = 'DNI';
        c.DocumentNumber__c = '12345678';
		insert c;
        c = getContact ();
        
        pAccount.vlocity_cmt__PrimaryContactId__c = c.Id;
        update pAccount;

       System.debug('---------- Sali de createContact()');
		return c;
	}

    static Contact getContact () {
        System.debug('-------------- Entre en getContact()');
        Contact c = [SELECT Id FROM Contact WHERE FirstName = 'Juan' AND LastName = 'Perez' AND DocumentNumber__c = '12345678'];
        System.debug('-------------- Sali de getContact()');
        return c;
    }


    static Account createAccount() {
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

    static Account getCreatedAccount (String pName) {
        System.debug('-------------- Entre en getCreatedAccount()');
        Account a = [SELECT Id FROM Account WHERE Name = :pName];
        System.debug('-------------- Account Id: ' + a.Id);
        System.debug('-------------- Sali de getCreatedAccount()');
        return a;
    }

    static vlocity_cmt__PriceList__c createPriceList(Id priceBookId){
        System.debug('---------- Entre en createPriceList()');
        vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c(Name='Telecom Price List', vlocity_cmt__Code__c='PRL_TELCOM',
            vlocity_cmt__Description__c='Create for IFS_S453 Testing', vlocity_cmt__Pricebook2Id__c=priceBookId);

        insert taPriceList;
        return  [SELECT id FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'PRL_TELCOM'];
    }
    
    static Product2 createProduct() {
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

    static Asset createAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList){
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


    static Asset createRootAsset(Account pAccount, Product2 pProduct, vlocity_cmt__PriceList__c pPriceList){
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

    static Pricebook2 createPriceBook(){
        System.debug('---------- Entre en createPriceBook()');
        Pricebook2 priceBook = new Pricebook2(Name='PriceBook for IFS_S453 Testing');
        insert priceBook;
        return  [SELECT Id FROM Pricebook2 WHERE Name = 'PriceBook for IFS_S453 Testing'];
    }

    static PricebookEntry createPriceBookEntry(Product2 pProduct, Pricebook2 pPriceBook2) {
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

    static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = getCreatedAccount('TelecomTest');
        System.debug('------------ Despues de crear el Account (Organization) ----');

        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA');
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     
    }

    static WorkTeam__c createWorkTeam (Id pStoreLocationId) {
        System.debug('---------- Entre en createWorkTeam()');
        WorkTeam__c wt = new WorkTeam__c(Name='Ventas', Team_Name__c='Ventas', Is_Active__c=true, Work_Place__c=pStoreLocationId);
        insert wt;
        return [SELECT Id FROM WorkTeam__c WHERE Name='Ventas'];
    }

    static void createWorkTeamMember (Id pWorkTemaId) {
        System.debug('---------- Entre en createWorkTeamMember()');
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId);
        insert wtm;
    }


}