@isTest
public class IFS_S437_activateNominatedServiceTest {
    static final String K_TIPO_DOCUMENTO_OK = 'DNI';
    static final String K_NMRO_DOCUMENTO_OK = '32987652';
    static final String K_NMRO_LINEA_OK = '1138305305';
    static final String K_ACCOUNT_NAME = 'TestS443Acc';

    @isTest static void testResponseStatus200 () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento=K_TIPO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='M';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertNotEquals(null, resMap.get('validateMaxLinesXDoc'), 'Devolvio lista vacia de ofertas y se esperaba una oferta.');
        Map<String, Object> maxLineMap = (Map<String, Object>) resMap.get('validateMaxLinesXDoc');
        System.assertEquals(false, maxLineMap.isEmpty(), 'Devolvio estructura de respuesta vacia');

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400 () {
        FromJson jsonObj = new FromJson();

        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_NRO_DOC () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento='';
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='Masculino';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

       checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_TIPO_DOC () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento='';
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='Masculino';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_TIPO_DOC_VALUE () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento='BAD_TYPE';
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='Masculino';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_NOMBRE () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento=K_TIPO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.nombre='';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='Masculino';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_APELLIDO () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento=K_TIPO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='';
        jsonObj.activateNominatedService.genero='M';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_GENERO_VACIO () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento=K_TIPO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_GENERO_NOVALIDO () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento=K_TIPO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='Masculino';
        jsonObj.activateNominatedService.fechaNacimiento='1996-02-11';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_FEC_NAC_VACIO () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento=K_TIPO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='M';
        jsonObj.activateNominatedService.fechaNacimiento='';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400_FEC_NAC_INVALIDO () {
        FromJson jsonObj = new FromJson();

        jsonObj.activateNominatedService.nroLinea=K_NMRO_LINEA_OK;
        jsonObj.activateNominatedService.numeroDocumento=K_NMRO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.tipoDocumento=K_TIPO_DOCUMENTO_OK;
        jsonObj.activateNominatedService.nombre='Nombre_Test';
        jsonObj.activateNominatedService.apellido='Apellido_Test';
        jsonObj.activateNominatedService.genero='M';
        jsonObj.activateNominatedService.fechaNacimiento='08/72/1984';


        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus404_REQUEST_NOVALIDO() {
       FromBadJSON2 jsonObj = new FromBadJSON2();

        
        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/activateNominatedService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S437_activateNominatedService.getPost();

        checkError(404, 404, RestContext.response.statuscode, RestContext.response.responseBody.toString());

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @TestSetup
    static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        //- Configuracion Usuario -
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        createWorkTeamMember (workTeam.Id);
        Account account = createAccount();
        Product2 product = createProduct2();
        createAssets(account, product);
        //createOrder (account, product);
        System.debug('----- Sali de crearDatosPrueba');
    }


    static Account createAccount() {
        System.debug('---------- Entre en createAccount()');
        Account a = new Account(Name=K_ACCOUNT_NAME, AccountIntegrationId__c=String.valueOf(10000));
		a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        a.UnnamedCustomer__c = true;
        insert a;
        a = [SELECT Id FROM Account WHERE Name = :K_ACCOUNT_NAME];
        System.debug('---------- Sali de createAccount()');
        return a;
    }

    static Product2 createProduct2(){
        Product2 service = new Product2();
        service.Name='Test-Plan Prepago Nacional';
        service.Family='Prepaid';
        service.recordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        service.vlocity_cmt__IsOrderable__c = true;
        service.vlocity_cmt__Type__c = 'Simcard';
        insert service;
        return [SELECT Id, Name FROM Product2 WHERE Name = 'Test-Plan Prepago Nacional' AND Family = 'Prepaid'];
    }

	static Asset createAssets(Account pAccount, Product2 pProduct){
		Asset a = new Asset(Name='TestAsset', Product2Id=pProduct.Id, AccountId=pAccount.Id);
        a.MSISDN__c = K_NMRO_LINEA_OK;
		insert a;
        a = [SELECT Id, Name FROM Asset WHERE Name = 'TestAsset'];
        
		return a;
	}


    static void createOrder (Account pAccount, Product2 pProduct2) {
        System.debug('---------- entre en createOrder');
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry priceBookEntry = createPricebookEntry (pricebookId, pProduct2.Id);
        vlocity_cmt__PriceList__c priceList = createPriceList(pricebookId, pProduct2.Id);
        Order order = new Order(AccountId = pAccount.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pricebookId);
        order.Delivery_Method__c = 'Delivery';
        order.vlocity_cmt__PriceListId__c = priceList.Id; 
        insert order;
        order = [SELECT Id FROM Order WHERE AccountId = :pAccount.Id];
        System.debug('---------- Se creo la order id: ' + order.Id);

        OrderItem ordItem = new OrderItem(OrderId = order.Id, Product2Id = pProduct2.Id, Quantity = 10, PricebookEntryId = priceBookEntry.Id, 
            UnitPrice = 100,
                vlocity_cmt__JSONAttribute__c = '{"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pxWDUAY","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"MSISDN","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"MSISDN","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSIUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSJUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"false","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"a1g6C000000ZUQ3QAO","attributeid__c":"a0G6C000000pwIvUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000074","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fabricacion","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqDsUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Nacional","id":10,"value":"N"},{"displayText":"Internacional","id":20,"value":"I"},{"displayText":"Tierra del Fuego","id":30,"value":"T"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pvsQUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000042","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":false,"attributedisplayname__c":"Sistema Origen","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSOUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"SAP","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SAP","id":20,"value":"SAP"}],"values":[{"displayText":"Huawei","id":10,"value":"Huawei"},{"displayText":"SAP","id":20,"value":"SAP"},{"displayText":"Infotainment","id":30,"value":"Infotainment"}],"selectedItem":{"displayText":"SAP","id":20,"value":"SAP"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSNUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSMUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false,"value":false},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSSUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[],"selectedItem":{}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIgUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000071","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"ICCID","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSPUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIlUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000072","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"IMSI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSQUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudJQAS","attributeid__c":"a0G6C000000pwIqUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000073","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"KI","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqSRUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":null,"valuedescription__c":null,"attributeRunTimeInfo":{"dataType":null,"value":null},"$$AttributeDefinitionEnd$$":null}]}');
        insert ordItem;
        
    }

    static vlocity_cmt__PriceList__c createPriceList(Id pPriceBookId, Id pProductId){
        System.debug('---------- Entre en createPriceList()');
        vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c(Name='Telecom Price List', vlocity_cmt__Code__c='PRL_TELCOM',
            vlocity_cmt__Description__c='Create for IFS_S445 Testing', vlocity_cmt__IsActive__c=true, vlocity_cmt__Pricebook2Id__c=pPriceBookId);
        insert taPriceList;
        taPriceList = [SELECT Id, Name FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'PRL_TELCOM'];

        populatePriceList(taPriceList.Id, pProductId);

        return taPriceList;
    }

	static Vlocity_cmt__PricingVariable__c createPricingVariable(){
        System.debug('---------- Entre en createPricingVariable()');
		Vlocity_cmt__PricingVariable__c pv = new Vlocity_cmt__PricingVariable__c();

		pv.vlocity_cmt__Code__c = '1';
        pv.vlocity_cmt__IsActive__c = true;
        pv.vlocity_cmt__ChargeType__c = 'Recurring';
        pv.vlocity_cmt__RecurringFrequency__c = 'Monthly';
        pv.vlocity_cmt__SubType__c = 'Standard';
        pv.vlocity_cmt__Type__c = 'Price';

		insert pv;

		return [SELECT Id, Name FROM Vlocity_cmt__PricingVariable__c WHERE vlocity_cmt__Code__c = '1'];
	}

    static Vlocity_cmt__PricingElement__c createPricingElement(Id pPriceListId, Id pProductId){ 
        System.debug('---------- Entre en createPricingElement()');

        Vlocity_cmt__PricingVariable__c pricingVariable = createPricingVariable();

		Vlocity_cmt__PricingElement__c pe = new Vlocity_cmt__PricingElement__c(vlocity_cmt__Amount__c = 1.0, vlocity_cmt__PricingVariableId__c=pricingVariable.Id, 
					vlocity_cmt__PriceListId__c=pPriceListId, vlocity_cmt__IsActive__c=true, vlocity_cmt__ProductId__c=pProductId, vlocity_cmt__Code__c='TestPrElement');
		insert pe;
		
		return [SELECT Id, Name FROM Vlocity_cmt__PricingElement__c WHERE vlocity_cmt__Code__c = 'TestPrElement'];
	}

    static void populatePriceList(Id pPriceListId, Id pProductId){
        System.debug('---------- Entre en populatePriceList()');
		Vlocity_cmt__PricingElement__c pricingElement = createPricingElement(pPriceListId, pProductId);

		Vlocity_cmt__PriceListEntry__c priceListEntry = new vlocity_cmt__PriceListEntry__c(
				vlocity_cmt__PricingElementId__c=pricingElement.Id, vlocity_cmt__IsActive__c=true, vlocity_cmt__ProductId__c=pProductId, vlocity_cmt__PriceListId__c=pPriceListId);

		insert priceListEntry;
	}


    static PricebookEntry createPricebookEntry (Id pPricebookEntryId, Id pProduct2Id) {
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pPricebookEntryId, Product2Id = pProduct2Id, 
            UnitPrice = 100, IsActive = true);
        insert standardPrice1;
        return [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :pPricebookEntryId AND Product2Id = :pProduct2Id];
    }

    static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = createOrganization();
        System.debug('------------ Despues de crear el Account (Organization) ----');
        
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Agentes', Channel_Type_2__c='Agentes', Channel_Type_3__c='Agentes',
             Region__c='AMBA');

        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     
    }

    static void checkError(Integer errorHttpCode, Integer errorBodyCode, Integer responseStatusCode, String responseBody){
        System.assertEquals(errorHttpCode, responseStatusCode); 
        List<ErrorClass> lstErrorResp = (List<ErrorClass>)JSON.deserialize(responseBody, List<ErrorClass>.class);
        System.assertEquals(errorBodyCode, Integer.valueOf(lstErrorResp[0].errorCode));
	}

    static Account createOrganization () {
        System.debug('-------------- Entre en createOrganization()');
        Account a = new Account(Name='TelecomTest', AccountIntegrationId__c=String.valueOf(10001));
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert a;

        a = [SELECT Id FROM Account WHERE Name = 'TelecomTest'];

        System.debug('-------------- Account Id: ' + a.Id);
        System.debug('-------------- Sali de createOrganization()');
        return a;
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
        wtm.UserRoleAPIName__c='Care';
        insert wtm;
    }


    private class FromJson {
        public NominatedTag activateNominatedService;
        public FromJson(){
            activateNominatedService = new NominatedTag();
        }
    }

    private class NominatedTag {
        public String codCliente;
        public String ticket;
        public String nroLinea;
        public String numeroDocumento;
        public String tipoDocumento;
        public String codUsuario;
        public String nombre;
        public String apellido;
        public String genero;
        public String fechaNacimiento;
        public String marcaExistenciaPadron;
        public String calle;
        public String altura;
        public String piso;
        public String departamento;
        public String descripcionLocalidad;
        public String codigoPostal;
        public String descripcionProvincia;
        public String codPais;
        public String tipoDireccion;
        public String marcaDireccionVerificada;
        public String codAccionNegocio;
    }


    public class ErrorClass {
        public String errorCode;
        public String message;
    }

    public class FromBadJSON2 {
        public String dummy1; 
        public String dummy2; 
    }


}