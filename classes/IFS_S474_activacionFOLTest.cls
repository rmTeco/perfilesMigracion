@isTest
public class IFS_S474_activacionFOLTest {
    static final String K_ACCOUNT_NAME = 'TestS474Acc';
    static final String K_ACCOUNT_CODE = '1000000000110001';

    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.activacionFOL.idCuenta=K_ACCOUNT_CODE;
        jsonObj.activacionFOL.operacion='A'; 
        jsonObj.activacionFOL.fechaDesde='2018-04-30 00:00:00';

        System.debug('jsonObj: ' + JSON.serialize(jsonObj));

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/Care_activacionFOL/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        // Account a = [SELECT Id, AccountIntegrationId__c FROM Account WHERE Name = :K_ACCOUNT_CODE];

        // System.debug('Valores Cuenta---> :' + a);
        IFS_S474_activacionFOL.getData();

        System.assertEquals(200, RestContext.response.statuscode); 
        Result resultado = (Result)JSON.deserialize(RestContext.response.responseBody.toString(), Result.class);
        System.assertNotEquals(null, resultado);
        System.assertEquals('0', resultado.codResultado);

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }


    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.activacionFOL.idCuenta=K_ACCOUNT_CODE;
        jsonObj.activacionFOL.operacion='C'; 
        jsonObj.activacionFOL.fechaDesde='2018-04-30 00:00:00';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/Care_activacionFOL/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S474_activacionFOL.getData();

        System.assertEquals(417, RestContext.response.statuscode); 
        List<ErrorClass> lstErrors = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        System.assertNotEquals(null, lstErrors);

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus400 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.activacionFOL.idCuenta=K_ACCOUNT_CODE;
        jsonObj.activacionFOL.operacion='A'; 
        jsonObj.activacionFOL.fechaDesde='2018-04-3 00:00:00';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/Care_activacionFOL/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S474_activacionFOL.getData();

        System.assertEquals(400, RestContext.response.statuscode); 
        List<ErrorClass> lstErrors = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        System.assertNotEquals(null, lstErrors);

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
        System.debug('----- Sali de crearDatosPrueba');
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


    static Account createOrganization () {

        System.debug('---------- Entre en createOrganization()');
        List<Account> lstAcc = new List<Account>();

        Account a = new Account(Name=K_ACCOUNT_NAME, AccountIntegrationId__c = K_ACCOUNT_CODE);
        a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        lstAcc.add(a);

        Account b = new Account(Name='TelecomTest', AccountIntegrationId__c=String.valueOf(10001));
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        lstAcc.add(b);
        insert lstAcc;
        System.debug('---------- Salgo de createOrganization()');
        return [SELECT Id FROM Account WHERE Name = 'TelecomTest'];
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

    public class FromJSON {
        public FromJSON_1 activacionFOL; 
        public FromJSON() {
            activacionFOL = new FromJSON_1();
        }
    }

    public class FromJSON_1 {
        public String idCuenta; 
        public String operacion;
        public String fechaDesde;
    }

    public class Result {
        public String codResultado;
        public String descResultado;
    }

    public class ErrorClass {
        public String errorCode;
        public String message;
    }
}