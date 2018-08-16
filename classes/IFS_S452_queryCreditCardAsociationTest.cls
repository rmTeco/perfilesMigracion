@isTest
public class IFS_S452_queryCreditCardAsociationTest {
    static final String K_ID_CLIENTE = String.valueOf(10000);

    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();
        Account account1 = createAccount();
        createContact(account1);
        Account account = getCreatedAccount('TestIFSS452Account');
        createPaymentMethod (account);

        jsonObj.queryCreditCardAsociation.choiceId.idCliente=String.valueOf(10000);

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/queryCreditCardAsociation/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S452_queryCreditCardAsociation.getData();

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
    
        Test.stopTest();
    }


    @isTest static void testResponseStatus400 () {
        FromJSON jsonObj = new FromJSON();
        Account account1 = createAccount();
        createContact(account1);
        Account account = getCreatedAccount('TestIFSS452Account');

        jsonObj.queryCreditCardAsociation.choiceId.idCliente='';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/queryCreditCardAsociation/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S452_queryCreditCardAsociation.getData();

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 
        List<Object> lstMapErrs = (List<Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertNotEquals(0, lstMapErrs.size());

        Test.stopTest();
    }

    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();
//        Account account = getCreatedAccount('TestIFSS452Account');

        jsonObj.queryCreditCardAsociation.choiceId.idCliente='100000';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/queryCreditCardAsociation/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S452_queryCreditCardAsociation.getData();

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
        List<Object> lstMapErrs = (List<Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertNotEquals(0, lstMapErrs.size());

        Test.stopTest();
    }

    ///////////////// Metodos de Creacion datos de Prueba //////////////////////

    @TestSetup
    private static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        //-- Datos para el servicio.
//        createPaymentMethod (account);
        //- Configuracion Usuario -
        Account b = new Account(Name='TelecomTest', AccountIntegrationId__c=String.valueOf(10001));
        b.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Billing').getRecordTypeId();
//        lstAcc.add(b);
        insert b;
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        createWorkTeamMember (workTeam.Id);

        System.debug('----- Sali de crearDatosPrueba');
    }

    private static Account createAccount() {
        System.debug('---------- Entre en createAccount()');
        List<Account> lstAcc = new List<Account>();
        Account a = new Account(Name='TestIFSS452Account', AccountIntegrationId__c=String.valueOf(10000));
		a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert a;

        lstAcc.add(a);

        Account c = new Account(Name='TestIFSS452Account_1', AccountIntegrationId__c=String.valueOf(10003));
		c.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        insert c;


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

    private static void createPaymentMethod (Account pAccount) {
        System.debug('--- Entre en createPaymentMethod');

        vlocity_cmt__PaymentMethod__c pm = new vlocity_cmt__PaymentMethod__c();
        pm.vlocity_cmt__AccountId__c=pAccount.Id;
        pm.vlocity_cmt__IsActive__c=true; 
        pm.vlocity_cmt__CardNumber__c='4546232356772222'; 
        pm.vlocity_cmt__CardHolderName__c='Juan Perez'; 
        pm.vlocity_cmt__CardType__c='VISA'; 
        pm.vlocity_cmt__ExpirationMonth__c='02'; 
        pm.vlocity_cmt__ExpirationYear__c='2022'; 
        pm.vlocity_cmt__Last4Numbers__c='2222'; 
        pm.vlocity_cmt__isPrimary__c=true; 
        pm.Security__c=333;
        pm.vlocity_cmt__MethodType__c='Credit Card';

        insert pm;
    
        System.debug('--- Sali de createPaymentMethod');
    }

	static Contact createContact(Account pAccount){
        System.debug('---------- Entre en createContact()');
		if(pAccount==null) pAccount = createAccount();

		Contact c = new Contact(FirstName='Juan', LastName='Perez', AccountId=pAccount.Id);
        c.DocumentType__c = 'DNI';
        c.DocumentNumber__c = '12345678';
		insert c;
       System.debug('---------- Sali de createContact()');
		return c;
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
             Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
             Region__c='AMBA');
        insert storeLocation;     
        return [SELECT Id FROM vlocity_cmt__BusinessSite__c WHERE Name='Barrio Norte'];     */
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
        wtm.UserRoleAPIName__c = 'Care';
        insert wtm;
    }

    private class FromJSON {
        public FromJSON_1 queryCreditCardAsociation; 
        public FromJSON () {
            queryCreditCardAsociation = new FromJSON_1();
        }
    }

    private class FromJSON_1 {
        public ChoiceClass choiceId; 
        public FromJSON_1 () {
            choiceId = new ChoiceClass(); 
        }
    }

    private class ChoiceClass {
        public String idCliente;
        public String nroLinea;
    }


    private class FromJSONBad {
        public String clienteId;
        public String canalCod;
    }

}