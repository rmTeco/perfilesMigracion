@isTest
public class IFS_S445_getAvailableOffersTest {

    private static String expectedResponse = null;
    private static String response = null;
    private static final String K_MSISDN_OK  = '47774777';
    private static final String K_MSISDN_NOK = '49994999';
    private static final String K_SUBSCRIPTION_ID_OK = '13800001138';
    private static final String K_CUSTOMERINTEGRATIONID_OK_C = '13800001138';
    private static final String K_CUSTOMERINTEGRATIONID_OK_B = '13800001139';
    private static final String K_CUSTOMERINTEGRATIONID_NOK = '13800001140';
    private static final String K_CANAL_OK = 'IVR';
    private static final String K_CANAL_NOK = 'Presencial';
    private static final String K_CODCORTO_OK = 'FAN24';
    private static final String K_TIPO_OK = 'Pack';
    private static final String K_SUBTIPO_OK = 'Movil';

    @isTest 
    static void testResponseStatus200_IDCLIENTE  () {
        FromJSON jsonObj = new FromJSON();
        Account account = getAccount('Consumer');

        jsonObj.idCliente = string.valueof(account.CustomerIntegrationId__c);
        //jsonObj.choiceId.nroLinea = K_MSISDN_OK;
        jsonObj.codCanal = K_CANAL_OK;
        //jsonObj.tipo = K_TIPO_OK;
        //jsonObj.subTipo = K_SUBTIPO_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableOffers/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S445_getAvailableOffers.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertNotEquals(null, resMap.get('lstOferta'), 'Devolvio lista vacia de ofertas y se esperaba una oferta.');
        List<Object> lstOfertas = (List<Object>)resMap.get('lstOferta');
        System.assertNotEquals(0, lstOfertas.size());
        System.assertNotEquals(null, resMap.get('orderId'), 'Devolvio orderId vacio o nulo y se esperaba id de orden.');

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest 
    static void testResponseStatus200_NROLINEA () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.choiceId.nroLinea = K_MSISDN_OK;
        jsonObj.codCanal = K_CANAL_OK;

        Test.startTest();
        RestRequest req = new   RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableOffers/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S445_getAvailableOffers.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.debug('lstOferta: ['+resMap.get('lstOferta')+']');
        System.debug('orderId: ['+resMap.get('orderId')+']');
        System.assertNotEquals(null, resMap.get('lstOferta'), 'Devolvio lista vacia de ofertas y se esperaba una oferta.');
        System.assertNotEquals(null, resMap.get('orderId'), 'Devolvio orderId vacio o nulo y se esperaba id de orden.');

        Test.stopTest();
    }

@isTest 
    static void testResponseStatus200_CODSUSCRIPCION  () {
        FromJSON jsonObj = new FromJSON();
        Account account = getAccount('Consumer');

        
        jsonObj.choiceId.subscriberId = K_SUBSCRIPTION_ID_OK ;
        jsonObj.codCanal = K_CANAL_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableOffers/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S445_getAvailableOffers.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertNotEquals(null, resMap.get('lstOferta'), 'Devolvio lista vacia de ofertas y se esperaba una oferta.');
        List<Object> lstOfertas = (List<Object>)resMap.get('lstOferta');
        System.assertNotEquals(0, lstOfertas.size());
        System.assertNotEquals(null, resMap.get('orderId'), 'Devolvio orderId vacio o nulo y se esperaba id de orden.');

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }
    /**
     * @Objetivo: No mandar parametros obligatorios para forzar el status code 400.
     */
    @isTest static void testResponseStatus400 () {
        FromJSON jsonObj = new FromJSON();
        

        jsonObj.idCliente = K_CUSTOMERINTEGRATIONID_OK_C;
        jsonObj.choiceId.nroLinea = K_MSISDN_OK;
        jsonObj.codCanal = K_CANAL_NOK;         // <---- Aqui esta el error

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableOffers/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S445_getAvailableOffers.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }    


    /**
     * @Objetivo: No mandar parametros obligatorios para forzar el status code 400.
     */
    @isTest static void testResponseStatus400_3 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.idCliente = K_CUSTOMERINTEGRATIONID_OK_C;
        jsonObj.choiceId.nroLinea = K_CANAL_NOK;
        jsonObj.codCanal = '';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableOffers/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S445_getAvailableOffers.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 

        Test.stopTest();
    }    

    /**
     * @Objetivo: Mandar parametros con datos incorrectos para forzar error funcional 417.
     */
    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();
        //Account account = getAccount('TestIFSS445Account');

        jsonObj.idCliente = K_CUSTOMERINTEGRATIONID_NOK;          // <-- Aqui esta el error.
        jsonObj.choiceId.nroLinea = K_MSISDN_NOK;  // <-- Aqui esta el error.
        jsonObj.codCanal = K_CANAL_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getAvailableOffers/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S445_getAvailableOffers.getPost();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 

        Test.stopTest();

    }    

    ///////////////// Metodos de Creacion datos de Prueba //////////////////////
    @TestSetup
    private static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        Id priceBookId = createPriceBook();
        Pricebook2 priceBook2 = createPriceBook2();
        Product2 product = createProduct();
        PricebookEntry priceBookEntry = createPriceBookEntry(product, priceBookId);
        vlocity_cmt__PriceList__c priceList = createPriceList(priceBook2.Id, product.Id);
        vlocity_cmt__Catalog__c catalogo = createCatalog();
        vlocity_cmt__CatalogProductRelationship__c relCatalogProd = createProductCatalogRelationship(catalogo, product);
        //vlocity_cmt__CatalogRelationship__c relCatalog = createCatalogRelationship(catalogo);
        Account account = createAccount();
        Asset rootAsset = createAssetRoot(account, priceList.Id, priceBookEntry.Id);
        //- Configuracion Usuario -
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        createWorkTeamMember (workTeam.Id);
        System.debug('----- Sali de crearDatosPrueba');
    }

    private static Account createAccount() {
        System.debug('---------- Entre en createAccount() tipo: Consumer');
        Account a = new Account(
            Name='Consumer', 
             AccountIntegrationId__c=String.valueOf(10000)
        );
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert a;
        System.debug('---------- Entre en createAccount() tipo: Billing');
        Account b = new Account(
             Name='Billing', 
             AccountIntegrationId__c=String.valueOf(10001)
         );
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        insert b;
        a = getAccount('Consumer');
        System.debug('idCuenta: '+ a.CustomerIntegrationId__c);
        System.debug('---------- Sali de createAccount()');
        return a;
    }

    private static Account getAccount (String pName) {
        System.debug('-------------- Entre en getAccount()');
        Account a = [SELECT Id,CustomerIntegrationId__c FROM Account WHERE Name = :pName];
        System.debug('-------------- Sali de getAccount()');
        return a;
    }

    static vlocity_cmt__PriceList__c createPriceList(Id pPriceBook2Id,Id pProductId){
        System.debug('---------- Entre en createPriceList()');
        vlocity_cmt__PriceList__c taPriceList = new vlocity_cmt__PriceList__c(
            Name='Telecom Price List', 
            vlocity_cmt__Code__c='PRL_TELCOM',
            vlocity_cmt__Description__c='Create for IFS_S445 Testing',
            vlocity_cmt__Pricebook2Id__c = pPriceBook2Id,
            vlocity_cmt__IsActive__c = TRUE,
            vlocity_cmt__CurrencyCode__c = 'ARS',
            vlocity_cmt__EffectiveFromDate__c = Date.valueOf('2017-08-29T07:00:15Z'),
            vlocity_cmt__LoyaltyCode__c = 'PTS'
        );

        insert taPriceList;
        taPriceList = [SELECT Id, Name FROM vlocity_cmt__PriceList__c WHERE vlocity_cmt__Code__c = 'PRL_TELCOM'];

        populatePriceList(taPriceList.Id, pProductId);

        return taPriceList;
    }

   static Pricebook2 createPriceBook2(){
        System.debug('---------- Entre en createPriceBook2()');
        Pricebook2 taPriceBook2 = new PriceBook2(
            IsActive = TRUE,
            CreatedDate = Date.today().addDays(-2),
            vlocity_cmt__IsDefault__c = TRUE,
            vlocity_cmt__IsOpportunityDefault__c = FALSE,
            vlocity_cmt__IsOrderDefault__c = TRUE,
            vlocity_cmt__isQuoteDefault__c = TRUE,
            Name = 'TA Price Book'
        );

        insert taPriceBook2;
        return [SELECT Id FROM PriceBook2 WHERE Name='TA Price Book'];
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

        Vlocity_cmt__PricingElement__c pe = new Vlocity_cmt__PricingElement__c(
            vlocity_cmt__Amount__c = 1.0,
            vlocity_cmt__PricingVariableId__c=pricingVariable.Id, 
            vlocity_cmt__PriceListId__c=pPriceListId, 
            vlocity_cmt__IsActive__c=true,
            vlocity_cmt__ProductId__c=pProductId, 
            vlocity_cmt__Code__c='TestPrElement',
            vlocity_cmt__CalculationType__c = 'Simple',
            vlocity_cmt__CurrencyCode__c = 'ARS',
            vlocity_cmt__DisplayText__c = '111,85 pesos',
            vlocity_cmt__EffectiveFromDate__c = Date.valueOf('2017-10-01T03:00Z'),
            Name = 'TestProduct',
            vlocity_cmt__IsOverride__c = FALSE
            //vlocity_cmt__ObjectTypeId__c = a1g6C000000ZUPJQA4,
        );
        insert pe;
        
        return [SELECT Id, Name FROM Vlocity_cmt__PricingElement__c WHERE vlocity_cmt__Code__c = 'TestPrElement'];
    }


    static void populatePriceList(Id pPriceListId, Id pProductId){
        System.debug('---------- Entre en populatePriceList()');
        Vlocity_cmt__PricingElement__c pricingElement = createPricingElement(pPriceListId, pProductId);

        Vlocity_cmt__PriceListEntry__c priceListEntry = new vlocity_cmt__PriceListEntry__c(
                vlocity_cmt__PricingElementId__c=pricingElement.Id, 
                vlocity_cmt__IsActive__c=true, 
                vlocity_cmt__ProductId__c=pProductId, 
                vlocity_cmt__PriceListId__c=pPriceListId,
                vlocity_cmt__IsBasePrice__c = TRUE,
                vlocity_cmt__EffectiveFromDate__c = Date.today().addDays(-2),
                Name = 'TA Price Entry List'
        );

        insert priceListEntry;
    }

    
    static Product2 createProduct() {
        System.debug('---------- Entre en createProduct()');
        Product2 prod = new Product2(
            Name='TestProduct', 
            IsActive=true,
            vlocity_cmt__IsConfigurable__c=true,
            vlocity_cmt__IsLocationDependent__c=false,
            vlocity_cmt__IsNotAssetizable__c=true,
            vlocity_cmt__IsOrderable__c=true,
            PrefaRequired__c=false,
            SCP_Certa_GC__productoGeneradoPorDelta__c=false,
            Tangible__c=false,
            vlocity_cmt__TrackAsAgreement__c=false,
            vlocity_cmt__CategoryData__c='[{"uiStates":{},"nameResult":{},"messages":[],"fields":{},"displaySequence":-1,"actions":{},"name":"TA Catalog","id":"a0V6C00000064CYUAY","childCategories":[{"uiStates":{},"nameResult":{},"messages":[],"fields":{},"displaySequence":-1,"actions":{},"name":"IVR","id":"a0V6C000000Zm2fUAC","childCategories":[]}]}]',
            vlocity_cmt__EffectiveDate__c=Date.today().addDays(-1),
            Family='Movil',
            ProductCode='FAN_PRDA_00001',
            vlocity_cmt__SpecificationType__c='Product',
            vlocity_cmt__Status__c='Active',
            vlocity_cmt__Type__c='Pack',
            vlocity_cmt__JSONAttribute__c='{"FAN_ATTCAT_000020":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvqFUAQ","attributecategoryid__c":"a0F6C000000BopxUAC","categorycode__c":"FAN_ATTCAT_000020","categoryname__c":"Unidades Libres Otorgadas","attributeuniquecode__c":"FAN_ATT_000016","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Vigencia","displaysequence__c":"60","categorydisplaysequence__c":60,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN1UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"B","id":40,"displayText":"ciclo de facturacion"},{"value":"D","id":20,"displayText":"dia"},{"value":"H","id":10,"displayText":"hora"},{"value":"W","id":30,"displayText":"semana"}],"default":[]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000040":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvqZUAQ","attributecategoryid__c":"a0F6C000000BoqHUAS","categorycode__c":"FAN_ATTCAT_000040","categoryname__c":"Comportamiento Recurrencia","attributeuniquecode__c":"FAN_ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modo de Recurrencia","displaysequence__c":"80","categorydisplaysequence__c":80,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN5UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"C","id":10,"displayText":"Ciclo"}],"values":[{"value":"C","id":10,"displayText":"Ciclo"},{"value":"S","id":30,"displayText":"Mismo que el plan"},{"value":"O","id":20,"displayText":"Unica vez"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvqeUAA","attributecategoryid__c":"a0F6C000000BoqHUAS","categorycode__c":"FAN_ATTCAT_000040","categoryname__c":"Comportamiento Recurrencia","attributeuniquecode__c":"FAN_ATT_000021","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Longitud de Ciclo","displaysequence__c":"80","categorydisplaysequence__c":80,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvqjUAA","attributecategoryid__c":"a0F6C000000BoqHUAS","categorycode__c":"FAN_ATTCAT_000040","categoryname__c":"Comportamiento Recurrencia","attributeuniquecode__c":"FAN_ATT_000022","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Comienzo de Ciclo","displaysequence__c":"80","categorydisplaysequence__c":80,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN2UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"0","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"0","id":10,"displayText":"Con la activación de la oferta"}],"values":[{"value":"0","id":10,"displayText":"Con la activación de la oferta"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvqoUAA","attributecategoryid__c":"a0F6C000000BoqHUAS","categorycode__c":"FAN_ATTCAT_000040","categoryname__c":"Comportamiento Recurrencia","attributeuniquecode__c":"FAN_ATT_000023","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Mitad de Ciclo","displaysequence__c":"80","categorydisplaysequence__c":80,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN4UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"N","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"N","id":10,"displayText":"Prorrateo"}],"values":[{"value":"L","id":20,"displayText":"Ciclo Fijo No Prorrateado"},{"value":"N","id":10,"displayText":"Prorrateo"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000041":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvr3UAA","attributecategoryid__c":"a0F6C000000BoqgUAC","categorycode__c":"FAN_ATTCAT_000041","categoryname__c":"Comportamiento Activacion Servicio","attributeuniquecode__c":"FAN_ATT_000024","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modo de Activacion","displaysequence__c":"21","categorydisplaysequence__c":21,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN7UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"M","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"M","id":10,"displayText":"Manual"}],"values":[{"value":"M","id":10,"displayText":"Manual"},{"value":"U","id":20,"displayText":"Primer uso"},{"value":"A","id":30,"displayText":"Suscripcion"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pwIMUAY","attributecategoryid__c":"a0F6C000000BoqgUAC","categorycode__c":"FAN_ATTCAT_000041","categoryname__c":"Comportamiento Activacion Servicio","attributeuniquecode__c":"FAN_ATT_000069","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modo Realizacion","displaysequence__c":"21","categorydisplaysequence__c":21,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN6UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"I","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"I","id":10,"displayText":"Inmediato"}],"values":[{"value":"I","id":10,"displayText":"Inmediato"},{"value":"N","id":20,"displayText":"Proximo Ciclo"},{"value":"S","id":30,"displayText":"Tiempo Especificado"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvrDUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000033","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Oferta Primaria Facturador","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNEUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvrNUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000034","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Estado Oferta Facturador","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN9UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"R","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"value":"R","id":10,"displayText":"Release"}],"values":[{"value":"R","id":10,"displayText":"Release"},{"value":"I","id":30,"displayText":"Retirado"},{"value":"S","id":20,"displayText":"Suspendido"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvrXUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000035","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Version Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNFUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvrhUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000036","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fecha Creacion Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNAUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"2017-10-01T03:00:00.000Z","valuedatatype__c":"Datetime","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Datetime","default":"2017-10-01T03:00:00.000Z"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvrmUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000037","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fecha Modificacion Sistema Origen","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNBUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Datetime","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Datetime"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pyfwUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000143","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provision Directa","displaysequence__c":"null","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtH7UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pyfrUAA","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000144","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Short Code","displaysequence__c":"null","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtH8UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UtEKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000044":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvs1UAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"FAN_ATTCAT_000044","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"FAN_ATT_000039","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Fecha de Activacion","displaysequence__c":"null","categorydisplaysequence__c":18,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNGUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Datetime","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Datetime"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pvv5UAA","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000045","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modo de Pago","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNJUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Checkbox","value__c":"POS","valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Checkbox","default":[{"value":"POS","id":20,"displayText":"Pospago"}],"values":[{"value":"PRE","id":10,"displayText":"Prepago"},{"value":"POS","id":20,"displayText":"Pospago"}]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pw0QUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000048","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Permite Resuscripcion","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNKUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pweTUAQ","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000083","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Mandatorio","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNIUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pwx0UAA","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000088","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Vigencia Activacion","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNNUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000EC7qUAG","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000156","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"No Aplica Promocion Financiera","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000cdUTUAY","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pwHJUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000067","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Provisionable","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNLUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqNHUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pyG9UAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000139","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Alicuota","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":21,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Us6RUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"21","valuedatatype__c":"Percent","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Percent","default":"21"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pyNgUAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000140","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Canal","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000Us6SUAS","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Multi Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Multi Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqMzUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZyzOQAS","attributeid__c":"a0G6C000000pofZUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"FAN_ATT_000041","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tangible","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqN0UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":false},"$$AttributeDefinitionEnd$$":null}]}',
            vlocity_cmt__Scope__c='Order Item',
            vlocity_cmt__AttributeDefaultValues__c='{"FAN_ATT_000040":true,"FAN_ATT_000041":true,"FAN_ATT_000020":"C","FAN_ATT_000023":"N","FAN_ATT_000021":1,"FAN_ATT_000022":"0","FAN_ATT_000088":null,"FAN_ATT_000042":"Huawei","FAN_ATT_000067":true,"FAN_ATT_000048":true,"FAN_ATT_000156":true,"FAN_ATT_000045":[{"PRE":false},{"POS":true}],"FAN_ATT_000083":true,"FAN_ATT_000068":true,"FAN_ATT_000140":null,"FAN_ATT_000139":21,"FAN_ATT_000035":1,"FAN_ATT_000144":null,"FAN_ATT_000143":true,"FAN_ATT_000033":true,"FAN_ATT_000032":"Pack 250 sms libres A","FAN_ATT_000030":"10000450","FAN_ATT_000037":null,"FAN_ATT_000036":"2017-10-01T03:00:00.000Z","FAN_ATT_000034":"R","FAN_ATT_000031":"SO_SMS_PACK_250_A","FAN_ATT_000084":null,"FAN_ATT_000069":"I","FAN_ATT_000024":"M","FAN_ATT_000039":null}',
            RecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId());
        insert prod;
        return [SELECT Id FROM Product2 WHERE Name = 'TestProduct'];
    }

    static Id createPriceBook(){
        System.debug('---------- Entre en createPriceBook()');
        return Test.getStandardPricebookId();
    }

    static PricebookEntry createPriceBookEntry(Product2 pProd, Id pPriceBookId) {
        System.debug('---------- Entre en createPriceBookEntry()');
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id=pPriceBookId, 
            Product2Id = pProd.Id, UnitPrice=0, vlocity_cmt__RecurringPrice__c=0, IsActive=true, vlocity_cmt__RecurringUOM__c='Monthly');

        insert standardPrice;
        return  standardPrice;
    }    

    static vlocity_cmt__Catalog__c createCatalog () {
      System.debug('---------- Entre en createCatalog()');  
      vlocity_cmt__Catalog__c catalogo = new vlocity_cmt__Catalog__c(
          Name='IVR', vlocity_cmt__IsActive__c=true, vlocity_cmt__IsCatalogRoot__c=true, vlocity_cmt__StartDateTime__c=Date.today().addDays(-1));  
        insert catalogo;
        return  [SELECT Id FROM vlocity_cmt__Catalog__c WHERE Name = 'IVR' ];
    }

    static vlocity_cmt__CatalogProductRelationship__c createProductCatalogRelationship (vlocity_cmt__Catalog__c pCatalogo, Product2 pProd) {
        System.debug('---------- Entre en createProductCatalogRelationship()'); 
        vlocity_cmt__CatalogProductRelationship__c prodCatalogRel = new vlocity_cmt__CatalogProductRelationship__c(
            Name='IVR', 
            vlocity_cmt__CatalogId__c=pCatalogo.Id, 
            vlocity_cmt__IsActive__c=true,
            vlocity_cmt__Product2Id__c=pProd.Id, 
            vlocity_cmt__EffectiveDate__c=Date.today().addDays(-1)
        );
        insert prodCatalogRel;
        return  [SELECT Id FROM vlocity_cmt__CatalogProductRelationship__c WHERE Name='IVR'];
    }

    static vlocity_cmt__CatalogRelationship__c createCatalogRelationship (vlocity_cmt__Catalog__c pCatalogo) {
        System.debug('---------- Entre en createCatalogRelationship()'); 
        vlocity_cmt__CatalogRelationship__c CatalogRel = new vlocity_cmt__CatalogRelationship__c(
            Name='IVR', 
            vlocity_cmt__ChildCatalogId__c = pCatalogo.Id,
            vlocity_cmt__ParentCatalogId__c = pCatalogo.Id
        );
        insert CatalogRel;
        return  [SELECT Id FROM vlocity_cmt__CatalogRelationship__c WHERE Name='IVR'];
    }

    static Asset createAssetRoot(Account pAcc, Id pPriceListId, Id pPriceBookEntryId ){

        //- Name - Account - quantity - msisdn
        System.debug('---------- Entre en createAssetRoot()'); 
        Asset a = new Asset();
        //a.Product2Id = createPlan().Id; // posible error.
        a.Accountid = pAcc.Id;
        a.name = 'RootAsset-Test';
        a.MSISDN__c = K_MSISDN_OK;
        a.vlocity_cmt__PriceListId__c = pPriceListId;
        a.vlocity_cmt__PricebookEntryId__c = pPriceBookEntryId;
        a.Subscription_Id__c = K_SUBSCRIPTION_ID_OK;
        insert a;
        a = [SELECT Id FROM Asset WHERE Accountid = :pAcc.Id AND Name = 'RootAsset-Test'];
        return a;
    }

    static Product2 createPlan (){
        System.debug('---------- Entre en createPlan()'); 
        Product2 plan = new Product2(Name='Plan con Tarjeta', Family='Movil');
        insert plan;
        return  [SELECT Id FROM Product2 WHERE Name='Plan con Tarjeta' AND Family='Movil'];
    }

    static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = getAccount('Billing');
        System.debug('------------ Despues de crear el Account (Organization) ----');

        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Agentes', Channel_Type_2__c='Agentes', Channel_Type_3__c='Agentes',
             Region__c='AMBA');
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     
    }

    static WorkTeam__c createWorkTeam (Id pStoreLocationId) {
        System.debug('---------- Entre en createWorkTeam()');
        WorkTeam__c wt = new WorkTeam__c(Name='Ventas', Team_Name__c='Ventas', Is_Active__c=true, Work_Place__c=pStoreLocationId);
        insert wt;
        System.debug('---------- Sali de createWorkTeam()');
        return [SELECT Id FROM WorkTeam__c WHERE Name='Ventas'];

    }

    static void createWorkTeamMember (Id pWorkTemaId) {
        System.debug('---------- Entre en createWorkTeamMember()');
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId, Is_Active__c=true);
        wtm.UserRoleAPIName__c='Care';
        insert wtm;
        System.debug('---------- Sali de createWorkTeamMember()');
    }

    public static Map<String,Object> getCardsProductsTest()
    {
        String jsonTest = '{"records":[{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000vNk5QAE"},"Product2Id":"01t6C0000004dDwQAI","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"BAM Pack 1Gb x 30 dias"},"UnitPrice":{"label":"List Price","value":"*"},"ProductCode":{"label":"Product Code","value":"FAN_PRDA_00097"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":0},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C0000004dDwQAI","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000Hx2nUAC","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000Hx2nUAC"},"Id":"a2T6C000000Hx2nUAC","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C0000004dDwQAI","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C0000004dDwQAI"},"Id":"01t6C0000004dDwQAI","Name":"BAM Pack 1Gb x 30 dias"}},"productHierarchyPath":"01t6C0000004dDwQAI","name":"BAM Pack 1Gb x 30 dias","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xQQcQAM"},"Product2Id":"01t6C000000a3GfQAI","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"BAM Pack 10GB x 30 dias"},"UnitPrice":{"label":"List Price","value":"219.00"},"ProductCode":{"label":"Product Code","value":"FAN_PRDA_00015"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":0},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C000000a3GfQAI","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000E1krUAC","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000E1krUAC"},"Id":"a2T6C000000E1krUAC","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000a3GfQAI","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000a3GfQAI"},"Id":"01t6C000000a3GfQAI","Name":"BAM Pack 10GB x 30 dias"}},"productHierarchyPath":"01t6C000000a3GfQAI","name":"BAM Pack 10GB x 30 dias","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000vNkZQAU"},"Product2Id":"01t6C0000004dEGQAY","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"BAM Pack 3Gb x 30 dias"},"UnitPrice":{"label":"List Price","value":"*"},"ProductCode":{"label":"Product Code","value":"FAN_PRDA_00098"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":0},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C0000004dEGQAY","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000Hx2sUAC","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000Hx2sUAC"},"Id":"a2T6C000000Hx2sUAC","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C0000004dEGQAY","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C0000004dEGQAY"},"Id":"01t6C0000004dEGQAY","Name":"BAM Pack 3Gb x 30 dias"}},"productHierarchyPath":"01t6C0000004dEGQAY","name":"BAM Pack 3Gb x 30 dias","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xQQlQAM"},"Product2Id":"01t6C000000a3GzQAI","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"BAM Pack 512MB x 30 dias"},"UnitPrice":{"label":"List Price","value":"75.00"},"ProductCode":{"label":"Product Code","value":"FAN_PRDA_00014"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":0},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C000000a3GzQAI","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000E1lTUAS","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000E1lTUAS"},"Id":"a2T6C000000E1lTUAS","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000a3GzQAI","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000a3GzQAI"},"Id":"01t6C000000a3GzQAI","Name":"BAM Pack 512MB x 30 dias"}},"productHierarchyPath":"01t6C000000a3GzQAI","name":"BAM Pack 512MB x 30 dias","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xQQWQA2"},"Product2Id":"01t6C000000a3HiQAI","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"Black Conexion Total Libre 2XL"},"UnitPrice":{"label":"List Price","value":"0.00"},"ProductCode":{"label":"Product Code","value":"FAN_PMAS6"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":721},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C000000a3HiQAI","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000E1n9UAC","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000E1n9UAC"},"Id":"a2T6C000000E1n9UAC","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000a3HiQAI","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000a3HiQAI"},"Id":"01t6C000000a3HiQAI","Name":"Black Conexion Total Libre 2XL"}},"productHierarchyPath":"01t6C000000a3HiQAI","name":"Black Conexion Total Libre 2XL","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xYbIQAU"},"Product2Id":"01t6C000000aDzwQAE","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"Black Conexion Total Libre 2XL Empleados"},"UnitPrice":{"label":"List Price","value":"0.00"},"ProductCode":{"label":"Product Code","value":"DEMO_EMPLEADOS"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":"TEST"},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C000000aDzwQAE","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000EFoiUAG","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000EFoiUAG"},"Id":"a2T6C000000EFoiUAG","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000aDzwQAE","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000aDzwQAE"},"Id":"01t6C000000aDzwQAE","Name":"Black Conexion Total Libre 2XL Empleados"}},"productHierarchyPath":"01t6C000000aDzwQAE","name":"Black Conexion Total Libre 2XL Empleados","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[{"code":"208","severity":"ERROR","message":"La cuenta debe ser Gold"}],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xQQZQA2"},"Product2Id":"01t6C000000a3HjQAI","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"Black Conexion Total Libre 4XL"},"UnitPrice":{"label":"List Price","value":"0.00"},"ProductCode":{"label":"Product Code","value":"FAN_PMAS7"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":976},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C000000a3HjQAI","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000E1nFUAS","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000E1nFUAS"},"Id":"a2T6C000000E1nFUAS","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000a3HjQAI","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000a3HjQAI"},"Id":"01t6C000000a3HjQAI","Name":"Black Conexion Total Libre 4XL"}},"productHierarchyPath":"01t6C000000a3HjQAI","name":"Black Conexion Total Libre 4XL","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Disqualified","failType":"Hard Fail","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xc2OQAQ"},"Product2Id":"01t6C000000aLHgQAM","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"Black Conexion Total Libre 4XL"},"UnitPrice":{"label":"List Price","value":"0.00"},"ProductCode":{"label":"Product Code","value":"FAN_PTIB5"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":"958,72"},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C000000aLHgQAM","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000EO3EUAW","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000EO3EUAW"},"Id":"a2T6C000000EO3EUAW","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000aLHgQAM","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000aLHgQAM"},"Id":"01t6C000000aLHgQAM","Name":"Black Conexion Total Libre 4XL"}},"productHierarchyPath":"01t6C000000aLHgQAM","name":"Black Conexion Total Libre 4XL","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xK2nQAE"},"Product2Id":"01t6C000000ZuYBQA0","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"Cambio de Billing Groups"},"UnitPrice":{"label":"List Price","value":"Precio Estándar de Transacciones de Cambios Administrativos"},"ProductCode":{"label":"Product Code","value":"FAN_PSERV_00005"},"orderActive":true,"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":0},"CurrencyCode":"ARS","productId":"01t6C000000ZuYBQA0","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000EP4pUAG","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000EP4pUAG"},"Id":"a2T6C000000EP4pUAG","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000ZuYBQA0","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000ZuYBQA0"},"Id":"01t6C000000ZuYBQA0","Name":"Cambio de Billing Groups"}},"productHierarchyPath":"01t6C000000ZuYBQA0","name":"Cambio de Billing Groups","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}},{"messages":[],"displaySequence":-1,"Id":{"label":"Price Book Entry ID","value":"01u6C000000xQU8QAM"},"Product2Id":"01t6C000000Zu7jQAC","IsActive":{"label":"Active","value":true},"Name":{"label":"Product Name","value":"Cambio de Ciclo de Facturación"},"UnitPrice":{"label":"List Price","value":"Precio Estándar de Transacciones de Cambios Administrativos"},"ProductCode":{"label":"Product Code","value":"FAN_PSERV_00004"},"vlocity_cmt__RecurringPrice__c":{"label":"Recurring Price","value":0},"orderActive":true,"CurrencyCode":"ARS","productId":"01t6C000000Zu7jQAC","defaultQuantity":1,"minQuantity":0,"maxQuantity":99999,"groupMinQuantity":0,"groupMaxQuantity":99999,"sequenceNumber":1,"productChildItemId":"a2T6C000000EP3SUAW","productChildItemDefinition":{"attributes":{"type":"vlocity_cmt__ProductChildItem__c","url":"/services/data/v43.0/sobjects/vlocity_cmt__ProductChildItem__c/a2T6C000000EP3SUAW"},"Id":"a2T6C000000EP3SUAW","Name":"Root PCI","vlocity_cmt__IsVirtualItem__c":false,"vlocity_cmt__Quantity__c":1,"vlocity_cmt__MaxQuantity__c":99999,"vlocity_cmt__MinQuantity__c":0,"vlocity_cmt__MaximumChildItemQuantity__c":99999,"vlocity_cmt__MinimumChildItemQuantity__c":0,"vlocity_cmt__IsOverride__c":false,"vlocity_cmt__ParentProductId__c":"01t6C000000Zu7jQAC","vlocity_cmt__ChildLineNumber__c":"1","vlocity_cmt__SeqNumber__c":1,"vlocity_cmt__CollapseHierarchy__c":false,"vlocity_cmt__IsRootProductChildItem__c":true,"vlocity_cmt__ParentProductId__r":{"attributes":{"type":"Product2","url":"/services/data/v43.0/sobjects/Product2/01t6C000000Zu7jQAC"},"Id":"01t6C000000Zu7jQAC","Name":"Cambio de Ciclo de Facturación"}},"productHierarchyPath":"01t6C000000Zu7jQAC","name":"Cambio de Ciclo de Facturación","isVirtualItem":false,"attributeValues":{},"hasChildren":false,"itemType":"childProduct","category":"Qualified","productCategories":{"totalSize":0,"messages":[]}}]}';
        vlocity_cmt.JSONResult valor = (vlocity_cmt.JSONResult) JSON.deserialize(jsonTest, vlocity_cmt.JSONResult.class);
        Map<String,Object> mapa = new Map<String,Object>();
        mapa.put(vlocity_cmt.JSONResult.JSON_KEY_RESULT, valor);
        return mapa;
    }

    private class FromJSON {
        public String subTipo;
        public String tipo;
        public String codCanal; 
        public String codCortoOferta;
        public ChoiceClass choiceId;
        public String idCliente;
        public FromJSON () {
            choiceId = new ChoiceClass();
        }
    }

    private class ChoiceClass {
        public String subscriberId;
        public String nroLinea;
    }

    private class FromJSONBad {
        public String clienteId;
        public String canalCod;
    }

}