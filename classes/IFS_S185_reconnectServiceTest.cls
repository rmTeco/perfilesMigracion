@isTest
public class IFS_S185_reconnectServiceTest {
    static final String K_ACCOUNT_NAME = 'TestS195Acc';

    @isTest static void testResponseStatus200 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.reconnectService.WorkOrderType='4';
        jsonObj.reconnectService.OrderObjType='S';
        jsonObj.reconnectService.OrderObjKey='sk11924885';
        jsonObj.reconnectService.OrderObjCode='11924885';

        FromJSON_2 orderParam = new FromJSON_2();
        orderParam.Code='OpType';
        orderParam.value='30';
        jsonObj.reconnectService.OrderParam.add(orderParam);

        FromJSON_2 orderParam1 = new FromJSON_2();
        orderParam1.Code='OldStatus';
        orderParam1.value='4';
        jsonObj.reconnectService.OrderParam.add(orderParam1);

        FromJSON_2 orderParam2 = new FromJSON_2();
        orderParam2.Code='NewStatus';
        orderParam2.Value='2';
        jsonObj.reconnectService.OrderParam.add(orderParam2);

        FromJSON_2 orderParam3 = new FromJSON_2();
        orderParam3.Code='StatusTime';
        orderParam3.value='20141120085457';
        jsonObj.reconnectService.OrderParam.add(orderParam3);
        
        System.debug('--------- <body> ------------');
        System.debug(jsonObj);
        System.debug('--------- </body> ------------');

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CollectionAndBilling_Collection_reconnectService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S185_reconnectService.getData();
        System.debug('Response: ' + RestContext.response.responseBody.toString());
        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Test.stopTest();
    }

    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();

        jsonObj.reconnectService.WorkOrderType='4';
        jsonObj.reconnectService.OrderObjType='S';
        jsonObj.reconnectService.OrderObjKey='sk11924885';
        jsonObj.reconnectService.OrderObjCode='11924885';

        FromJSON_2 orderParam = new FromJSON_2();
        orderParam.Code='OpType';
        orderParam.value='30';
        jsonObj.reconnectService.OrderParam.add(orderParam);

        FromJSON_2 orderParam1 = new FromJSON_2();
        orderParam1.Code='OldStatus';
        orderParam1.value='2';
        jsonObj.reconnectService.OrderParam.add(orderParam1);

        FromJSON_2 orderParam2 = new FromJSON_2();
        orderParam2.Code='NewStatus';
        orderParam2.value='4';
        jsonObj.reconnectService.OrderParam.add(orderParam2);

        FromJSON_2 orderParam3 = new FromJSON_2();
        orderParam3.Code='OpTStatusTimeype';
        orderParam3.value='20141120085457';
       jsonObj.reconnectService.OrderParam.add(orderParam3);
        
        System.debug('--------- <body> ------------');
        System.debug(jsonObj);
        System.debug('--------- </body> ------------');

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CollectionAndBilling_Collection_reconnectService/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S185_reconnectService.getData();
        System.debug('Response: ' + RestContext.response.responseBody.toString());
        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
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
        System.debug('----- Sali de crearDatosPrueba');
    }


    static Account createAccount() {
        System.debug('---------- Entre en createAccount()');
        Account a = new Account(Name=K_ACCOUNT_NAME, AccountIntegrationId__c=String.valueOf(10000));
		a.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        a.ClubMember__c = true;
        a.PersonalClubCategory__c = 'Classic';
        a.vlocity_cmt__AccountPaymentType__c = 'Prepaid';
        insert a;
        a = [SELECT Id FROM Account WHERE Name = :K_ACCOUNT_NAME];
        System.debug('---------- Sali de createAccount()');
        return a;
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
        public FromJSON_1 reconnectService; 
        public FromJSON() {
            reconnectService = new FromJSON_1();
        }
    }

    public class FromJSON_to {
        public FromJSON_to(){
            lines = new  List<FromJSON_1>();
        }
        public String typeOfJob;
        public List<FromJSON_1> lines; 
    }
    
    public class FromJSON_1 {
        public String WorkOrderType; 
        public String OrderObjType;
        public String OrderObjKey;
        public String OrderObjCode;
        public List<FromJSON_2> OrderParam;
        public FromJSON_1() {
            OrderParam = new List<FromJSON_2>();
        }
    }

    public class FromJSON_2 {
        public String Code;
        public String Value;
        public List<FromJSON_2> Param;
        public List<FromJSON_4> ObjParam;
    }

    public class FromJSON_4 {
        public String Value;
        public List<FromJSON_2> Param;
        public List<FromJSON_4> ObjParam;
        public FromJSON_4() {
            Param = new List<FromJSON_2>();
            ObjParam = new List<FromJSON_4>();
        }
    }

    public class ErrorClass {
        public String errorCode;
        public String message;
    }


}