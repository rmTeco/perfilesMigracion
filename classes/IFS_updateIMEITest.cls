@isTest
public class IFS_updateIMEITest {

    @isTest static void testResponseStatus200 () {

        DatoAdicionalClass datoAd1 = new DatoAdicionalClass();
        datoAd1.nombre='IMEI';
        datoAd1.valor='Linea:3886827428 Serie: 358176005195470 N. Desp IC04';

        AditionalDataClass adicionalData = new AditionalDataClass();
        adicionalData.datoAdicional=datoAd1;

        InfoDetailClass infoDetails = new InfoDetailClass();
        infoDetails.codCargo = 'C_OT_MB_EQUIPMENT_SIM';
        infoDetails.secuenciaProd = '12345601';
        infoDetails.datosAdicionales=adicionalData;

        DetailClass detail = new DetailClass();
        detail.infoDetalleModificar=infoDetails;

        FromJSON jsonObj = new FromJSON();

        jsonObj.numeroComprobante = '123467989hfjf';
        jsonObj.codAcceso = '2380001003300002';
        jsonObj.lstDetalle.add(detail);

        jsonObj.lstDetalle.add(detail);

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure//updateIMEI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_updateIMEI.getPost();

        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Result resultado = (Result)JSON.deserialize(RestContext.response.responseBody.toString(), Result.class);
        System.debug('Response: ' + RestContext.response.responseBody.toString());
        Test.stopTest();
    }

     @isTest static void testResponseStatus400_NumComp () {
        DatoAdicionalClass datoAd1 = new DatoAdicionalClass();
        datoAd1.nombre='IMEI';
        datoAd1.valor='Linea:3886827428 Serie: 358176005195470 N. Desp IC04';

        AditionalDataClass adicionalData = new AditionalDataClass();
        adicionalData.datoAdicional=datoAd1;

        InfoDetailClass infoDetails = new InfoDetailClass();
        infoDetails.codCargo = 'C_OT_MB_EQUIPMENT_SIM';
        infoDetails.secuenciaProd = '12345601';
        infoDetails.datosAdicionales=adicionalData;

        DetailClass detail = new DetailClass();
        detail.infoDetalleModificar=infoDetails;

        FromJSON jsonObj = new FromJSON();

        jsonObj.numeroComprobante = '';
        jsonObj.codAcceso = '2380001003300002';
        jsonObj.lstDetalle.add(detail);

        jsonObj.lstDetalle.add(detail);

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure//updateIMEI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_updateIMEI.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 
        List<ErrorClass> lstErrorResp = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        ErrorClass errorResp = lstErrorResp.get(0);
        System.assertEquals(400, Integer.valueOf(errorResp.errorCode));

        System.debug('Response: ' + RestContext.response.responseBody.toString());

        Test.stopTest();
    }

     @isTest static void testResponseStatus400_CodComp () {
        DatoAdicionalClass datoAd1 = new DatoAdicionalClass();
        datoAd1.nombre='IMEI';
        datoAd1.valor='Linea:3886827428 Serie: 358176005195470 N. Desp IC04';

        AditionalDataClass adicionalData = new AditionalDataClass();
        adicionalData.datoAdicional=datoAd1;

        InfoDetailClass infoDetails = new InfoDetailClass();
        infoDetails.codCargo = 'C_OT_MB_EQUIPMENT_SIM';
        infoDetails.secuenciaProd = '12345601';
        infoDetails.datosAdicionales=adicionalData;

        DetailClass detail = new DetailClass();
        detail.infoDetalleModificar=infoDetails;

        FromJSON jsonObj = new FromJSON();

        jsonObj.numeroComprobante = '123467989hfjf';
        jsonObj.codAcceso = '';
        jsonObj.lstDetalle.add(detail);

        jsonObj.lstDetalle.add(detail);

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure//updateIMEI/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_updateIMEI.getPost();

        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 
        List<ErrorClass> lstErrorResp = (List<ErrorClass>)JSON.deserialize(RestContext.response.responseBody.toString(), List<ErrorClass>.class);
        ErrorClass errorResp = lstErrorResp.get(0);
        System.assertEquals(400, Integer.valueOf(errorResp.errorCode));

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
        Team_Member__c wtm = new Team_Member__c(User_member__c=UserInfo.getUserId(), Work_Team__c=pWorkTemaId, UserRoleAPIName__c='Test');
        insert wtm;
    }


    private class FromJSON {
        public String numeroComprobante; 
        public String codAcceso;
        public List<DetailClass> lstDetalle;
        public FromJSON() {
            lstDetalle = new List<DetailClass>();
        }
    }

    private class DetailClass {
        public InfoDetailClass infoDetalleModificar;
        public DetailClass() {
            infoDetalleModificar = new InfoDetailClass();
        }
    }

    private class InfoDetailClass {
        public AditionalDataClass datosAdicionales;
        public String codCargo;
        public String secuenciaProd;
        public InfoDetailClass() {
            datosAdicionales = new AditionalDataClass();
        }
    }

    private class AditionalDataClass {
        public DatoAdicionalClass datoAdicional;
        public AditionalDataClass() {
            datoAdicional = new DatoAdicionalClass();
        }
    }

    private class DatoAdicionalClass {
        public String nombre;
        public String valor;
    }

    public class Result {
        public Integer resultCode=-1;
        public String message;
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