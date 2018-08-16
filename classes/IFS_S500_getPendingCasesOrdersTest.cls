@isTest
public class IFS_S500_getPendingCasesOrdersTest {

    private static final String K_MSISDN_OK    = '47774777';
    private static final String K_MSISDN_NO_OK = '48884888';
    private static final String K_ACCOUNT_NAME = 'TestIFSS500Account';


    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.choiceId.nroLinea = K_MSISDN_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getPendingCasesOrders/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S500_getPendingCasesOrders.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Test.stopTest();
    }


    /**
     * @Objetivo: No mandar parametros obligatorios para forzar el status code 400.
     */
    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.choiceId.nroLinea = K_MSISDN_NO_OK;

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getPendingCasesOrders/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S500_getPendingCasesOrders.getPost();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
        Test.stopTest();
    }    

    /**
     * @Objetivo: No mandar parametros obligatorios para forzar el status code 400.
     */
    @isTest static void testResponseStatus500 () {
        FromJsonBad jsonObj = new FromJsonBad();

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/getPendingCasesOrders/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S500_getPendingCasesOrders.getPost();

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

        List<Asset> lstAssets = TestDataFactory.createAssets(1, account, K_MSISDN_OK);
        TestDataFactory.createCases(1, account.Id, lstAssets.get(0).Id, 'Test-IFS_S500');
        TestDataFactory.createOrders(1, account);

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

        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(Name='Barrio Norte', 
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


    static void createWorkTeamMember (Id pWorkTemaId) {
        System.debug('---------- Entre en createWorkTeamMember()');
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId, Is_Active__c=true);
        wtm.UserRoleAPIName__c='Call Center';
        insert wtm;
        System.debug('---------- Sali de createWorkTeamMember()');
    }


/////////////////////////////////// Datos ///////////////////////////////////
    //-- Clases para soportar el request --//
    private class FromJson {
        public ChoiceClass choiceId;
        public FromJson() {
            choiceId = new ChoiceClass(); 
        }
    }

    private class FromJsonBad {
        public Integer f1;
    }


    private class ChoiceClass {
        public String subscriberId;
        public String nroLinea;
    }

}