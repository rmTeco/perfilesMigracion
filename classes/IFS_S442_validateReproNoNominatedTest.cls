@isTest
public class IFS_S442_validateReproNoNominatedTest {
    static final String K_MSISDN_OK = '47774777';
    static final String K_ACCOUNT_NAME = 'TestS443Acc';


    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.validateReproNoNominated.nroLinea = K_MSISDN_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateReproNoNominated/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S442_validateReproNoNominated.getData();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        FromJsonResp resObj = (FromJsonResp)JSON.deserialize(RestContext.response.responseBody.toString(), FromJsonResp.class);
        System.assertNotEquals(null, resObj.validateReproNoNominated);

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

    @isTest static void testResponseStatus404 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.validateReproNoNominated.nroLinea = '';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/validateReproNoNominated/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S442_validateReproNoNominated.getData();

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
        createAssets(account);

        //- Configuracion Usuario -
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        createWorkTeamMember (workTeam.Id);
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
        insert service;
        return [SELECT Id, Name FROM Product2 WHERE Name = 'Test-Plan Prepago Nacional' AND Family = 'Prepaid'];
    }

	static Asset createAssets(Account pAccount){
        Product2 p = createProduct2();
		Asset a = new Asset(Name='TestAsset', Product2Id=p.Id, AccountId=pAccount.Id);
        a.MSISDN__c = K_MSISDN_OK;
		insert a;
		return [SELECT Id, Name FROM Asset WHERE Name = 'TestAsset'];
	}

    static vlocity_cmt__BusinessSite__c createStoreLocation () {
        System.debug('---------- Entre en createStoreLocation()');

        System.debug('------------ Antes de crear el Account (Organization) ----');
        Account orgAcc = createOrganization();
        System.debug('------------ Despues de crear el Account (Organization) ----');
        
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
            vlocity_cmt__OrganizationId__c=orgAcc.Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA');

        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     
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


     public class FromJSON {
        public ValidateReproNoNominatedClass validateReproNoNominated; 
        public FromJSON() {
            validateReproNoNominated = new ValidateReproNoNominatedClass();
        }
    }

    public class ValidateReproNoNominatedClass {
        public String nroLinea; 
    }

    public class FromJsonResp {
        public ValidateReproNoNominatedRespClass validateReproNoNominated;
    }

    public class ValidateReproNoNominatedRespClass {
        public String respuesta;
    }

    public class FromBadJSON {
        public validateReproNoNominatedClass validateReproNoNominated; 
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