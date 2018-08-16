@isTest
public class IFS_S465_asociarTarjetaTest {
        //private static final String idCliAux = String.valueOf(10000);
       // private static final String idCliAux = '0016C000008fDM6QAM';
       private static final String idCliAux = '00';

    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

		//jsonObj.asociarTarjeta.idCliente='0016C000008fDM6QAM';
        // String idCliAux = String.valueOf(10000);
        jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='2';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }


    /**
     * @Objetivo: No mandar parametros obligatorios para forzar el status code 400.
     */
    @isTest static void testResponseAnotherStatus417_ID_CLIENTE () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente='';
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='02';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
    //    Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
    //    System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }    
        @isTest static void testResponseAnotherStatus417_CARD_NUMBER () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='02';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
//        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
//        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }    
        @isTest static void testResponseAnotherStatus417_EXPIRATION_YEAR () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='02';
		jsonObj.asociarTarjeta.expirationYear='';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
//        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
//        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }    

        @isTest static void testResponseAnotherStatus417_LAST_4_NUMBERS () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='02';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
//        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
//        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }    

        @isTest static void testResponseAnotherStatus417_EXPIRATION_MONTH () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
//        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
//        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    } 

       @isTest static void testASOCIAR_TRARJ_PRIM_NULL () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='02';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary= null;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
    //    Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
    //    System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    } 

       @isTest static void testVALIDAR_EXPIRATION_MONTH () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='17';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary= true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
 //       Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
 //       System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }

       @isTest static void testVALIDAR_EXPIRATION_YEAR () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='17';
		jsonObj.asociarTarjeta.expirationYear='2014';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary= true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
//        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
//        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }

      @isTest static void testVALIDAR_4_NUMBERS () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='MASTERCARD';
		jsonObj.asociarTarjeta.expirationMonth='02';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='22';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
//        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
//        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }

    @isTest static void testVALIDAR_CARD_TYPE () {
        FromJSON jsonObj = new FromJSON();

		jsonObj.asociarTarjeta.idCliente= idCliAux;
		jsonObj.asociarTarjeta.cardHolderName='Juan Perez';
		jsonObj.asociarTarjeta.cardNumber='XXXXXXXXXXXX2222';
		jsonObj.asociarTarjeta.cardType='TRUCHA';
		jsonObj.asociarTarjeta.expirationMonth='02';
		jsonObj.asociarTarjeta.expirationYear='2018';
		jsonObj.asociarTarjeta.last4Numbers='2222';
		jsonObj.asociarTarjeta.isPrimary=true;
		jsonObj.asociarTarjeta.securityCode='333';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/asociarTarjeta/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S465_asociarTarjeta.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
//        Map<String, Object> resMap = (Map<String, Object>)JSON.deserializeUntyped(RestContext.response.responseBody.toString());
//        System.assertEquals('OK', resMap.get('resultado'));

        Test.stopTest();
    }

////////////////////////////////////////
    @TestSetup
    private static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        Account account = createAccount();
        vlocity_cmt__PaymentMethod__c payMet = creaPayMet(account);
        //- Configuracion Usuario -
        // vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        // WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        // createWorkTeamMember (workTeam.Id);
        System.debug('----- Sali de crearDatosPrueba');
    }

   private static Account createAccount() {
        System.debug('---------- Entre en createAccount() id:' + String.valueOf(10000));
        List<Account> lstAcc = new List<Account>();
        Account a = new Account();
        a.Name='TestIFSS445Account';
        a.AccountIntegrationId__c= idCliAux;
	//	a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        lstAcc.add(a);
        insert lstAcc;
        a = getCreatedAccount('TestIFSS445Account');
        System.debug('---------- Sali de createAccount()');
        return a;
    }

    private static Account getCreatedAccount (String pName) {
        System.debug('-------------- Entre en getCreatedAccount()');
        Account a = [SELECT Id, AccountIntegrationId__c FROM Account WHERE Name = :pName];
        System.debug('-------------- Account Id: ' + a.Id);
        System.debug('-------------- AccountIntegrationId: ' + a.AccountIntegrationId__c);
        System.debug('-------------- Sali de getCreatedAccount()');
        return a;
    }

    private static vlocity_cmt__PaymentMethod__c creaPayMet(Account cuenta) {
        vlocity_cmt__PaymentMethod__c payMet = new vlocity_cmt__PaymentMethod__c();
        payMet.vlocity_cmt__AccountId__c = cuenta.Id;
        payMet.vlocity_cmt__IsActive__c = true;
        payMet.vlocity_cmt__CardHolderName__c = 'Juan Perez';
        payMet.vlocity_cmt__CardType__c = 'MASTERCARD';
        payMet.vlocity_cmt__ExpirationMonth__c = '02';
        payMet.vlocity_cmt__ExpirationYear__c = '2018';
        payMet.vlocity_cmt__Last4Numbers__c = '2222';
        insert payMet;
        return payMet;
    }
//////////////////////////////////////

    public class FromJSON {
        public FromJSON_1 asociarTarjeta; 
        public FromJSON() {
            asociarTarjeta = new FromJSON_1();
        }
    }
    public class FromJSON_1 {
        public String idCliente; 
        public String cardHolderName;
        public String cardNumber;
        public String cardType;
        public String expirationMonth;
        public String expirationYear;
        public String last4Numbers;
        public Boolean isPrimary;
        public String securityCode;
    }

}