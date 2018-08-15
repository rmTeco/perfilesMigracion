@isTest
public class IFS_S484_QueryBillingInfoTest {
    static final String K_MSISDN = '11453342234';
    static final String K_ASSET_NAME = 'Asset-Test';
    static final String K_ACCOUNT_NAME = 'TestIFSS452Account';

    @isTest static void testResponseStatus200 () {
        Test.startTest();
        FromJSON jsonObj = new FromJSON();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        jsonObj.linea = K_MSISDN;
        req.requestURI = '/v1/integrationprocedure/queryBillingInfo/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S484_QueryBillingInfo.getData();

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Test.stopTest();
    }

    @isTest static void testResponseStatus417 () {
        Test.startTest();
        FromJSON jsonObj = new FromJSON();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        jsonObj.linea = '1143211234';           // <----- Aqui esta el error para que devuelvea 417
        req.requestURI = '/v1/integrationprocedure/queryBillingInfo/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S484_QueryBillingInfo.getData();

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
        Test.stopTest();
    }

    ///////////////// Metodos de Creacion datos de Prueba //////////////////////
    @TestSetup
    private static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        //-- Datos para el servicio.
        Account account = createAccount();
        Asset a = createAsset(getCreatedAccount (K_ACCOUNT_NAME));
        //- Configuracion Usuario -
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        //WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        //createWorkTeamMember (workTeam.Id);
        System.debug('----- Sali de crearDatosPrueba');
    }

    private static Account createAccount() {
        System.debug('---------- Entre en createAccount()');
        List<Account> lstAcc = new List<Account>();
        Account a = new Account(Name=K_ACCOUNT_NAME, AccountIntegrationId__c=String.valueOf(10000));
		a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
        a.AccountIntegrationId__c = '2380001051410001';
        a.BillingState = 'Buenos Aires';
        a.BillingCity = 'B2342';
        a.BillingCountry = 'Argentina';
        a.BillingStateCode = 'B';
        a.CustomerIntegrationId__c = Integer.valueOf('12345');
        lstAcc.add(a);
        Account b = new Account(Name='TelecomTest', AccountIntegrationId__c=String.valueOf(10001));
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        lstAcc.add(b);
        insert lstAcc;
        a = getCreatedAccount('TestIFSS452Account');
        System.debug('---------- Sali de createAccount()');
        return a;
    }

    private static Account getCreatedAccount (String pName) {
        System.debug('-------------- Entre en getCreatedAccount()');
        Account a = [SELECT Id FROM Account WHERE Name = :pName];
        System.debug('-------------- Account Id: ' + a.Id);
        System.debug('-------------- Sali de getCreatedAccount()');
        return a;
    }

    public static Asset createAsset(Account pAccount){
        System.debug('---------- Entre en createAsset()'); 
        Asset a = new Asset();
        a.Product2Id = createPlan().Id;
        a.Accountid = pAccount.Id;
        a.vlocity_cmt__BillingAccountId__c = pAccount.Id;
        a.name = K_ASSET_NAME;
        a.MSISDN__c = K_MSISDN;
        insert a;
        return  [SELECT Id FROM Asset WHERE Accountid = :pAccount.Id AND Name = :K_ASSET_NAME];
    }

    private static Product2 createPlan (){
        System.debug('---------- Entre en createPlan()'); 
        Product2 service = new Product2(Name='Plan - Test', Family='Movil');
        insert service;
        return  [SELECT Id FROM Product2 WHERE Name = 'Plan - Test' AND Family = 'Movil'];
    }


    static vlocity_cmt__BusinessSite__c createStoreLocation () {
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
             Channel_Type__c='Agentes', Channel_Type_2__c='Agentes', Channel_Type_3__c='Agentes', Region__c='AMBA');
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     */
    }

    static WorkTeam__c createWorkTeam (Id pStoreLocationId) {
        System.debug('---------- Entre en createWorkTeam()');
        WorkTeam__c wt = new WorkTeam__c(Name='Ventas', Team_Name__c='Ventas', Is_Active__c=true, Work_Place__c=pStoreLocationId);
        wt.PublicGroupAPIName__c = 'Ventas';
        insert wt;
        return [SELECT Id FROM WorkTeam__c WHERE Name='Ventas'];
    }

    static void createWorkTeamMember (Id pWorkTemaId) {
        System.debug('---------- Entre en createWorkTeamMember()');
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId);
        insert wtm;
    }


    public class FromJSON {
        public String linea;
    }
}