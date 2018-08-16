@isTest
public class IFS_S158_pinValidationSMSTest {
    static final String K_ACCOUNT_NAME = 'TestS443Acc';
    static final String K_MSISDN = '1148238764';

    public class FromJSON {
        public FromJSON_1 pinValidationSMS; 
        public FromJSON() {
            pinValidationSMS = new FromJSON_1();
        }
    }

     public class FromJSON_1 {
        public String nroLinea; 
        public String mensaje; 
    }


    public class ErrorClass {
        public String errorCode;
        public String message;
    }
    

    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.pinValidationSMS.nroLinea = '1234567890';
        jsonObj.pinValidationSMS.mensaje = 'Cambio Plan Nacional Prepago';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CustomerCare_CustomerValidation_pinValidationSMS/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S158_pinValidationSMS.getData();

        //System.debug('Response: ' + RestContext.response.responseBody.toString());

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 

        Test.stopTest();
    }


    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.pinValidationSMS.nroLinea = K_MSISDN;
        jsonObj.pinValidationSMS.mensaje = '';

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CustomerCare_CustomerValidation_pinValidationSMS/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S158_pinValidationSMS.getData();

        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
        List<ErrorClass> lstResMap = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        ErrorClass errorResp = (ErrorClass)lstResMap.get(0);
        System.assertEquals(417, Integer.valueOf(errorResp.errorCode));

        //System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }


    @TestSetup
    static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        Team_Member__c teamMember = setTeamMember('Test', userinfo.getUserId(), null);
        createExpectedMessage();
        
        Account acc = createAccounts(1,'Business')[0];
        Order ord = createOrders(1, acc)[0];
        acc.phone = '1234567890';
        update acc; 
        
        String smsRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Template').getRecordTypeId();
        String logRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('Log Identity Validation').getRecordTypeId();
        String trkRecordType = Schema.SObjectType.CrossObject__c.getRecordTypeInfosByName().get('SMS Tracking').getRecordTypeId();
        
        DateTime fechaLimiteVencimiento = Datetime.Now().addMinutes(300);
        
        insert new CrossObject__c(PickList1__c = 'Verificación de identidad en una orden de venta', RecordTypeId = smsRecordType, Integer1__c=300, Integer2__c=3); 
        
        insert new CrossObject__c(PickList1__c = 'Sms', Account__c = acc.Id, Order__c = ord.Id, Checkbox1__c = false, DateTime1__c = fechaLimiteVencimiento,
            RecordTypeId = logRecordType);
        
        insert new CrossObject__c(Account__c = acc.Id, Order__c = ord.Id, String1__c = '1234567890', Status__c = 'Pendiente', Integer1__c = 3, DateTime1__c = fechaLimiteVencimiento,
            RecordTypeId = trkRecordType);
    }

    public static List<Account> createAccounts(Integer numAccts, String recordTypeName) {
        System.debug('----- Entre en createAccounts');
        List<Account> accts = new List<Account>();

        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account();

            a.Name='TestAccount' + i;
            a.AccountIntegrationId__c = String.ValueOf(Decimal.valueOf('10000000000')+Datetime.now().millisecond()+i);
            a.CustomerIntegrationId__c = Decimal.valueOf('10000000000')+Datetime.now().millisecond()+i; 
            
            system.debug('recordTypeName = '+recordTypeName);

            if(recordTypeName != null)
               a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();

            accts.add(a);
        }
        insert accts;

        return accts;
    }

    public static List<Account> createAccounts(Integer numAccts) {
        return createAccounts(numAccts, null);
    }


    public static vlocity_cmt__BusinessSite__c createStoreLocation(String name){
        System.debug('----- Entre en createStoreLocation');
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c(
            Name = name,
            BillingMode__c = 'Fiscal',
            Channel__c = 'Físico',
            Channel_Type__c = 'Agentes',
            Channel_Type_2__c = 'Agentes',
            Channel_Type_3__c = 'Agentes',
            Vlocity_cmt__OrganizationId__c = createAccounts(1)[0].Id
        );

        insert storeLocation;
        return storeLocation;
    }

    static Team_Member__c setTeamMember(String name, String usrId, WorkTeam__c workTeam){
        System.debug('----- Entre en setTeamMember');
        Team_Member__c tm = new Team_Member__c(User_Member__c = usrId );

        if(workTeam != null)
            tm.Work_Team__c = workTeam.Id;
        else
            tm.Work_Team__c = createWorkTeam('Test', null).Id;
       tm.UserRoleAPIName__c='Care';
 
        insert tm;
        return tm;
    }

    public static WorkTeam__c createWorkTeam(String name, Vlocity_cmt__BusinessSite__c storeLocation){
        System.debug('----- Entre en createWorkTeam');
        WorkTeam__c wt = new WorkTeam__c( Name = 'Test', Team_Name__c = 'Test' );

        if(storeLocation != null)
            wt.Work_Place__c = storeLocation.Id;
        else
            wt.Work_Place__c = createStoreLocation('Test').Id;
        insert wt;
        return wt;
    }

    static void createExpectedMessage(){
        System.debug('----- Entre en createExpectedMessage');
        SMS_Expected_Response_Type__c exp = new SMS_Expected_Response_Type__c(Name='SMS_Expected_Response_Type', Ok__c='OK', Ko__c='NOK');
        insert exp;
    }

    public static List<Order> createOrders(Integer numOrders, Account acc) {
        System.debug('----- Entre en createOrders');

        vlocity_cmt__PriceList__c taPriceList = createPriceList('Telecom Price List');

        List<Order> orders = new List<Order>();

        for(Integer i=0;i<numOrders;i++) {
            Order o = new Order(Name='TestOrder' + i,
                                                    AccountId=acc.Id,
                                                    EffectiveDate=Date.today(),
                                                    Status='Draft',
                                                    Pricebook2Id =Test.getStandardPricebookId(),
                                                    vlocity_cmt__PriceListId__c=taPriceList.Id,
                                                    Delivery_Method__c='Delivery',
                                                    vlocity_cmt__OriginatingChannel__c='Agentes');
            orders.add(o);
        }

        insert orders;

        return orders;
    }

    public static vlocity_cmt__PriceList__c createPriceList(String name){
        System.debug('----- Entre en createPriceList');
        String priceBookId = createPriceBook('TA Price Book').Id;

        vlocity_cmt__PriceList__c taPriceList =
            new vlocity_cmt__PriceList__c(Name=name,
                                                                        vlocity_cmt__Code__c='1',
                                                                        vlocity_cmt__Pricebook2Id__c=priceBookId);

        insert taPriceList;

        return taPriceList;
    }

    public static Pricebook2 createPriceBook(String name){
        System.debug('----- Entre en createPriceBook');
        Pricebook2 priceBook = new Pricebook2(Name=name);

        insert priceBook;

        return priceBook;
    }




}