@isTest
public class IFS_S443_validateMaxLinesXDocTest {
    static final String K_TIPO_DOCUMENTO_NO_OK = 'dni';
    static final String K_NMRO_DOCUMENTO_NULL = '';
    static final String K_NMRO_DOCUMENTO_NO_OK = 'documento';
    static final String K_TIPO_DOCUMENTO_OK = 'DNI';
    static final String K_NMRO_DOCUMENTO_OK = '12345678';
    static final String K_ACCOUNT_NAME = 'TestS443Acc';

    @isTest static void testResponseStatus200_COMPLETO () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.validateMaxLinesXDoc.tipoDocumento = K_TIPO_DOCUMENTO_OK;
        jsonObj.validateMaxLinesXDoc.numeroDocumento = K_NMRO_DOCUMENTO_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateMaxLinesXDoc/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S443_validateMaxLinesXDoc.getData();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertNotEquals(null, resMap.get('validateMaxLinesXDoc'), 'Devolvio lista vacia de ofertas y se esperaba una oferta.');
        Map<String, Object> maxLineMap = (Map<String, Object>) resMap.get('validateMaxLinesXDoc');
        System.assertEquals(false, maxLineMap.isEmpty(), 'Devolvio estructura de respuesta vacia');

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.validateMaxLinesXDoc.numeroDocumento = K_NMRO_DOCUMENTO_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateMaxLinesXDoc/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        System.debug(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S443_validateMaxLinesXDoc.getData();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertNotEquals(null, resMap.get('validateMaxLinesXDoc'), 'Devolvio lista vacia de ofertas y se esperaba una oferta.');
        Map<String, Object> maxLineMap = (Map<String, Object>) resMap.get('validateMaxLinesXDoc');
        System.assertEquals(false, maxLineMap.isEmpty(), 'Devolvio estructura de respuesta vacia');

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }



    @isTest static void testResponseStatus400 () {
        FromBadJSON jsonObj = new FromBadJSON();

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateMaxLinesXDoc/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S443_validateMaxLinesXDoc.getData();

        System.assertEquals(Integer.valueOf('404'), RestContext.response.statuscode); 
        List<ErrorClass> lstResMap = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        ErrorClass errorResp = (ErrorClass)lstResMap.get(0);
        System.assertEquals(417, Integer.valueOf(errorResp.errorCode));

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus404_tipoDocumento_INVALIDO () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.validateMaxLinesXDoc.tipoDocumento = K_TIPO_DOCUMENTO_NO_OK;
        jsonObj.validateMaxLinesXDoc.numeroDocumento = K_NMRO_DOCUMENTO_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateMaxLinesXDoc/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S443_validateMaxLinesXDoc.getData();

        System.assertEquals(Integer.valueOf('404'), RestContext.response.statuscode); 
        List<ErrorClass> lstResMap = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        ErrorClass errorResp = (ErrorClass)lstResMap.get(0);
        System.assertEquals(417, Integer.valueOf(errorResp.errorCode));

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus404_numeroDocumento_INVALIDO () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.validateMaxLinesXDoc.tipoDocumento = K_TIPO_DOCUMENTO_OK;
        jsonObj.validateMaxLinesXDoc.numeroDocumento = K_NMRO_DOCUMENTO_NO_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateMaxLinesXDoc/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S443_validateMaxLinesXDoc.getData();

        System.assertEquals(Integer.valueOf('404'), RestContext.response.statuscode); 
        List<ErrorClass> lstResMap = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        ErrorClass errorResp = (ErrorClass)lstResMap.get(0);
        System.assertEquals(417, Integer.valueOf(errorResp.errorCode));

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus404_numeroDocumento_NULL () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.validateMaxLinesXDoc.tipoDocumento = K_TIPO_DOCUMENTO_OK;
        jsonObj.validateMaxLinesXDoc.numeroDocumento = '';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateMaxLinesXDoc/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S443_validateMaxLinesXDoc.getData();

        System.assertEquals(Integer.valueOf('404'), RestContext.response.statuscode); 
        List<ErrorClass> lstResMap = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        ErrorClass errorResp = (ErrorClass)lstResMap.get(0);
        System.assertEquals(417, Integer.valueOf(errorResp.errorCode));

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }


    @TestSetup
    static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        Account account = createAccount();
        createContact(account);
        createAssets(account);

        //- Configuracion Usuario -
        //vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        //WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        //createWorkTeamMember (workTeam.Id);
        System.debug('----- Sali de crearDatosPrueba');
    }

    static Account createAccount() {
        System.debug('---------- Entre en createAccount()');
        Account a = new Account(Name=K_ACCOUNT_NAME, AccountIntegrationId__c=String.valueOf(10000));
		a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert a;
        a = [SELECT Id FROM Account WHERE Name = :K_ACCOUNT_NAME];
        System.debug('---------- Sali de createAccount()');
        return a;
    }

	static Contact createContact(Account pAccount){
        System.debug('---------- Entre en createContact()');
		if(pAccount==null) pAccount = createAccount();

		Contact c = new Contact(FirstName='firstName', LastName='lastName', AccountId=pAccount.Id);
        c.DocumentType__c = K_TIPO_DOCUMENTO_OK;
        c.DocumentNumber__c = K_NMRO_DOCUMENTO_OK;
		insert c;
       System.debug('---------- Sali de createContact()');
		return c;
	}

    static Product2 createProduct2(){
        Product2 service = new Product2();
        service.Name='Plan Prepago Repro Nacional';
        service.vlocity_cmt__Type__c='Plan Prepago';
        service.Family='Movil';
        service.recordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        service.vlocity_cmt__IsOrderable__c = true;
        insert service;
        return [SELECT Id FROM Product2 WHERE vlocity_cmt__Type__c = 'Plan Prepago' AND Family = 'Movil'];
    }

	static Asset createAssets(Account pAccount){
        Product2 p = createProduct2();
		Asset a = new Asset(Name='TestAsset', Product2Id=p.Id, AccountId=pAccount.Id);
		insert a;
		return [SELECT Id, Name FROM Asset WHERE Name = 'TestAsset'];
	}

    static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = createOrganization();
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
        insert wtm;
    }

    public class FromJSON {
        public validateMaxLinesXDocClass validateMaxLinesXDoc; 
        public FromJSON() {
            validateMaxLinesXDoc = new validateMaxLinesXDocClass();
        }
    }

    public class validateMaxLinesXDocClass {
        public String numeroDocumento; 
        public String tipoDocumento;
    }

    public class FromJSON2 {
        public validateMaxLinesXDocClass2 validateMaxLinesXDoc; 
        public FromJSON2() {
            validateMaxLinesXDoc = new validateMaxLinesXDocClass2();
        }
    }

    public class validateMaxLinesXDocClass2 {
        public String numeroDocumento; 
    }

    public class FromBadJSON {
        public validateMaxLinesXDocClass validateMaxLinesXDoc; 
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