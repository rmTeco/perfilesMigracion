@isTest
public class IFS_S184_recievesFromBDOTest {
    static final String K_ACCOUNT_NAME = 'TestS195Acc';

    @isTest static void testResponseStatus200 () {

        createData();
        
        FromJSON jsonObj = new FromJSON();

        FromJSON_2 json2 = new FromJSON_2 ();
        json2.comentario='Esto es comentario';
        json2.datosDocumento='Datos Documento'; 
        json2.tipoDocumentacionPortacion='Tipo Documento'; 
        json2.nombreArchivoPortacion='Nombre Archivo'; 
        json2.tipoProcesoPortacion='ALEX';

        
        jsonObj.requestFromBDO.nroSolicitudPortacion = 1;
        jsonObj.requestFromBDO.nroUnicoSolicitudPortacion='';
        jsonObj.requestFromBDO.codOperadoraDonante='5777';
        jsonObj.requestFromBDO.codOperadoraReceptora= '5666';
		jsonObj.requestFromBDO.tipoRed='MOVIL';
		jsonObj.requestFromBDO.tipoProcesoPortacion='ALEX';
		jsonObj.requestFromBDO.estadoProcesoPortacion='AREC';
		jsonObj.requestFromBDO.subEstadoProcesoPortacion='RESI';
		jsonObj.requestFromBDO.descripcionEstadoProcesoPortacion='Alta Rechazada Operacionales';
		jsonObj.requestFromBDO.fechaEstadoProcesoPortacion='2015-06-21 03:21:00';
		jsonObj.requestFromBDO.codMercadoDonante='PRE';
		jsonObj.requestFromBDO.fechaVentanaPortacion='';
		jsonObj.requestFromBDO.lineasPortacion='3482539260|1122334455|2233445566|3344556677|4455667788';
		jsonObj.requestFromBDO.cantidadLineasPortacion=1;
		jsonObj.requestFromBDO.nroLinea='3482539260';
		jsonObj.requestFromBDO.PINPortacion='';
		jsonObj.requestFromBDO.codCausaRechazoPortacion='MAN5005';
        jsonObj.requestFromBDO.documentacionLista.add(json2);
		jsonObj.requestFromBDO.apoderado.tipoDocumento = 'DNI';
		jsonObj.requestFromBDO.apoderado.numeroDocumento = '4455667788';
		jsonObj.requestFromBDO.apoderado.nombre = 'pepe';
		jsonObj.requestFromBDO.apoderado.apellido = 'pepe';


        System.debug('--------- <body> ------------');
        System.debug(jsonObj);
        System.debug('--------- </body> ------------');

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CustomerCare_Portability_recievesFromBDO/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res; 

        IFS_S184_recievesFromBDO.getData();
        System.debug('Response: ' + RestContext.response.responseBody.toString());
        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Test.stopTest();
    }

    @isTest static void testResponseStatus200_update () {

        createData();

        FromJSON jsonObj = new FromJSON();

         FromJSON_2 json2 = new FromJSON_2 ();
        json2.comentario='Esto es comentario';
        json2.datosDocumento='Datos Documento'; 
        json2.tipoDocumentacionPortacion='Tipo Documento'; 
        json2.nombreArchivoPortacion='Nombre Archivo'; 
        json2.tipoProcesoPortacion='ALEX';

        
        jsonObj.requestFromBDO.nroSolicitudPortacion = 1;
        jsonObj.requestFromBDO.nroUnicoSolicitudPortacion='';
        jsonObj.requestFromBDO.codOperadoraDonante='5777';
        jsonObj.requestFromBDO.codOperadoraReceptora= '5666';
		jsonObj.requestFromBDO.tipoRed='MOVIL';
		jsonObj.requestFromBDO.tipoProcesoPortacion='ALEX';
		jsonObj.requestFromBDO.estadoProcesoPortacion='AREC';
		jsonObj.requestFromBDO.subEstadoProcesoPortacion='RESI';
		jsonObj.requestFromBDO.descripcionEstadoProcesoPortacion='Alta Rechazada Operacionales';
		jsonObj.requestFromBDO.fechaEstadoProcesoPortacion='2015-06-21 03:21:00';
		jsonObj.requestFromBDO.codMercadoDonante='PRE';
		jsonObj.requestFromBDO.fechaVentanaPortacion='';
		jsonObj.requestFromBDO.lineasPortacion='3482539260';
		jsonObj.requestFromBDO.cantidadLineasPortacion=1;
		jsonObj.requestFromBDO.nroLinea='3482539260';
		jsonObj.requestFromBDO.PINPortacion='';
		jsonObj.requestFromBDO.codCausaRechazoPortacion='MAN5005';
        jsonObj.requestFromBDO.documentacionLista.add(json2);
		jsonObj.requestFromBDO.apoderado.tipoDocumento = 'DNI';
		jsonObj.requestFromBDO.apoderado.numeroDocumento = '4455667788';
		jsonObj.requestFromBDO.apoderado.nombre = 'pepe';
		jsonObj.requestFromBDO.apoderado.apellido = 'pepe';


        System.debug('--------- <body> ------------');
        System.debug(jsonObj);
        System.debug('--------- </body> ------------');

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CustomerCare_Portability_recievesFromBDO/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S184_recievesFromBDO.getData();

        jsonObj.requestFromBDO.estadoProcesoPortacion='ASOL';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));

        IFS_S184_recievesFromBDO.getData();


        System.debug('Response: ' + RestContext.response.responseBody.toString());
        System.assertEquals(Integer.valueOf('200'), RestContext.response.statuscode); 
        Test.stopTest();
    }



    @isTest static void testResponseStatus417_01 () {
        FromJSON jsonObj = new FromJSON();

        FromJSON_2 json2 = new FromJSON_2 ();
        json2.comentario='Esto es comentario';
        json2.datosDocumento='Datos Documento'; 
        json2.tipoDocumentacionPortacion='Tipo Documento'; 
        json2.nombreArchivoPortacion='Nombre Archivo'; 
        json2.tipoProcesoPortacion='ALEX';

        
        jsonObj.requestFromBDO.nroSolicitudPortacion = 1;
        jsonObj.requestFromBDO.nroUnicoSolicitudPortacion='';
        jsonObj.requestFromBDO.codOperadoraDonante='5777';
        jsonObj.requestFromBDO.codOperadoraReceptora= '5666';
		jsonObj.requestFromBDO.tipoRed='MOVIL';
		jsonObj.requestFromBDO.tipoProcesoPortacion='ALEX';
		jsonObj.requestFromBDO.estadoProcesoPortacion='AREC';
		jsonObj.requestFromBDO.subEstadoProcesoPortacion='RESI';
		jsonObj.requestFromBDO.descripcionEstadoProcesoPortacion='Alta Rechazada Operacionales';
		jsonObj.requestFromBDO.fechaEstadoProcesoPortacion='2015-06-21 03:21:00';
		jsonObj.requestFromBDO.codMercadoDonante='PRE';
		jsonObj.requestFromBDO.fechaVentanaPortacion='';
		jsonObj.requestFromBDO.lineasPortacion='3482539260';
		jsonObj.requestFromBDO.cantidadLineasPortacion=1;
		jsonObj.requestFromBDO.nroLinea='3482539260';
		jsonObj.requestFromBDO.PINPortacion='';
		jsonObj.requestFromBDO.codCausaRechazoPortacion='MAN5005';
        jsonObj.requestFromBDO.documentacionLista.add(json2);


        System.debug('--------- <body> ------------');
        System.debug(jsonObj);
        System.debug('--------- </body> ------------');

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CustomerCare_Portability_recievesFromBDO/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S184_recievesFromBDO.getData();
        IFS_S184_recievesFromBDO.getData();
        System.debug('Response: ' + RestContext.response.responseBody.toString());
        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
        Test.stopTest();
    }

 
    @isTest static void testResponseStatus417 () {
        FromJSON jsonObj = new FromJSON();

        FromJSON_2 json2 = new FromJSON_2 ();
        json2.comentario='Esto es comentario';
        json2.datosDocumento='Datos Documento'; 
        json2.tipoDocumentacionPortacion='Tipo Documento'; 
        json2.nombreArchivoPortacion='Nombre Archivo'; 
        json2.tipoProcesoPortacion='ALEX';

        
        jsonObj.requestFromBDO.nroSolicitudPortacion = 1;
        jsonObj.requestFromBDO.nroUnicoSolicitudPortacion='';
        jsonObj.requestFromBDO.codOperadoraDonante='';
        jsonObj.requestFromBDO.codOperadoraReceptora= '5666';
		jsonObj.requestFromBDO.tipoRed='';
		jsonObj.requestFromBDO.tipoProcesoPortacion='';
		jsonObj.requestFromBDO.estadoProcesoPortacion='AREC';
		jsonObj.requestFromBDO.subEstadoProcesoPortacion='RESI';
		jsonObj.requestFromBDO.descripcionEstadoProcesoPortacion='Alta Rechazada Operacionales';
		jsonObj.requestFromBDO.fechaEstadoProcesoPortacion='2015-06-21 03:21:00';
		jsonObj.requestFromBDO.codMercadoDonante='PRE';
		jsonObj.requestFromBDO.fechaVentanaPortacion='';
		jsonObj.requestFromBDO.lineasPortacion='3482539260';
		jsonObj.requestFromBDO.cantidadLineasPortacion=1;
		jsonObj.requestFromBDO.nroLinea='3482539260';
		jsonObj.requestFromBDO.PINPortacion='';
		jsonObj.requestFromBDO.codCausaRechazoPortacion='MAN5005';
        jsonObj.requestFromBDO.documentacionLista.add(json2);


        System.debug('--------- <body> ------------');
        System.debug(jsonObj);
        System.debug('--------- </body> ------------');

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CustomerCare_Portability_recievesFromBDO/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S184_recievesFromBDO.getData();

        System.debug('Response: ' + RestContext.response.responseBody.toString());
        System.assertEquals(Integer.valueOf('417'), RestContext.response.statuscode); 
        Test.stopTest();
    }

    @isTest static void testResponseStatus400 () {
        FromJSON jsonObj = new FromJSON();

        FromJSON_2 json2 = new FromJSON_2 ();
        json2.comentario='Esto es comentario';
        json2.datosDocumento='Datos Documento'; 
        json2.tipoDocumentacionPortacion='Tipo Documento'; 
        json2.nombreArchivoPortacion='Nombre Archivo'; 
        json2.tipoProcesoPortacion='ALEX';

        
        jsonObj.requestFromBDO.nroSolicitudPortacion = 1;
        jsonObj.requestFromBDO.nroUnicoSolicitudPortacion='';
        jsonObj.requestFromBDO.codOperadoraDonante='5777';
        jsonObj.requestFromBDO.codOperadoraReceptora= '5666';
		jsonObj.requestFromBDO.tipoRed='MOVIL';
		jsonObj.requestFromBDO.tipoProcesoPortacion='ALEX';
		jsonObj.requestFromBDO.estadoProcesoPortacion='AREC';
		jsonObj.requestFromBDO.subEstadoProcesoPortacion='RESI';
//		jsonObj.requestFromBDO.descripcionEstadoProcesoPortacion='Alta Rechazada Operacionales';
		jsonObj.requestFromBDO.fechaEstadoProcesoPortacion='2015-06-21 03:21:00';
		jsonObj.requestFromBDO.codMercadoDonante='PRE';
		jsonObj.requestFromBDO.fechaVentanaPortacion='';
		jsonObj.requestFromBDO.lineasPortacion='3482539260';
		jsonObj.requestFromBDO.cantidadLineasPortacion=1;
		jsonObj.requestFromBDO.nroLinea='3482539260';
		jsonObj.requestFromBDO.PINPortacion='';
		jsonObj.requestFromBDO.codCausaRechazoPortacion='MAN5005';
        jsonObj.requestFromBDO.documentacionLista.add(json2);


        System.debug('--------- <body> ------------');
        System.debug(jsonObj);
        System.debug('--------- </body> ------------');

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/v1/integrationprocedure/CustomerCare_Portability_recievesFromBDO/';  
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSON.serialize(jsonObj));
        req.headers.put('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.headers.put('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;

        IFS_S184_recievesFromBDO.getData();

        System.debug('Response: ' + RestContext.response.responseBody.toString());
        System.assertEquals(Integer.valueOf('400'), RestContext.response.statuscode); 
        Test.stopTest();
    }



    @TestSetup
    static void crearDatosPrueba () {
        System.debug('----- Entre en crearDatosPrueba');
        //- Configuracion Usuario -
        vlocity_cmt__BusinessSite__c storeLocation = createStoreLocation ();
        //WorkTeam__c workTeam = createWorkTeam (storeLocation.Id);
        //createWorkTeamMember (workTeam.Id);
        Account account = createAccount();
        System.debug('----- Sali de crearDatosPrueba');
    }

    public static void createData(){

        Contact contactObj;
        Account accountObj;
        Product2 productoObj;
        Asset assetObj;

        //custom settings creation
        List<TASalesCodeValue__c> csList = new List<TASalesCodeValue__c>();
        TASalesCodeValue__c cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_DaysFrom';
        cs.Value__c = '90';
        csList.add(cs);
        cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_NonTPLines';
        cs.Value__c = 'A01';
        csList.add(cs);
        cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_PREbutPos';
        cs.Value__c = 'A04';
        csList.add(cs);
        cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_POSbutPre';
        cs.Value__c = 'A03';
        csList.add(cs);
        cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_PREDontMeet';
        cs.Value__c = 'M58';
        csList.add(cs);
        cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_StayLimit';
        cs.Value__c = 'A02';
        csList.add(cs);
        cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_StayLimitDays';
        cs.Value__c = '60';
        csList.add(cs);
        cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_MinBalance';
        cs.Value__c = '32.1';
        csList.add(cs);

        insert csList;

        //Contact creation
        contactObj = new Contact(
            LastName = 'DA Contact Test '+Math.round(Math.random()*10000),
            Phone = '45454544545'
        );
        insert contactObj;

        //Account creation
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        accountObj = new Account (
            vlocity_cmt__PrimaryContactId__c = contactObj.Id,
            Name='DA CuentaTest'+Math.round(Math.random()*10000),
            RecordTypeId = businessRecordTypeId,
            AccountIntegrationId__c = '345345345'+Math.round(Math.random()*10000)
        );
        insert accountObj;

        //Product creation
        productoObj = new Product2(
            Name='DA TestProduct' + Math.round(Math.random()*10000),
            ProductCode='TestProductCode' + + Math.round(Math.random()*10000),
            vlocity_cmt__Type__c = 'Plan Prepago'
        );
        insert productoObj;
        //Creo un asset Pre 3435161523
        assetObj = new Asset(
            Name='DA TestAsset'+ Math.round(Math.random()*10000),
            Product2Id=productoObj.Id, 
            AccountId=accountObj.Id, 
            MSISDN__c='3435161523',
            Status = 'Active',
            Subscription_Id__c = '345345345'
        );
        insert assetObj;

        //Creo un asset Pre 1190876234
        assetObj = new Asset(
            Name='DA TestAsset'+ Math.round(Math.random()*10000),
            Product2Id=productoObj.Id, 
            AccountId=accountObj.Id, 
            MSISDN__c='1190876234',
            Status = 'Active',
            Subscription_Id__c = '345345345'
        );
        insert assetObj;

        //Asset otros asset pre 1135678927
        assetObj = new Asset(
            Name='DA TestAsset'+ Math.round(Math.random()*10000),
            Product2Id=productoObj.Id, 
            AccountId=accountObj.Id, 
            MSISDN__c='1135678927',
            Status = 'Active',
            Subscription_Id__c = '3453412345'
        );
        insert assetObj;

        //Creo un asset Pre OK 3435161649
        assetObj = new Asset(
            Name='DA TestAsset'+ Math.round(Math.random()*10000),
            Product2Id=productoObj.Id, 
            AccountId=accountObj.Id, 
            MSISDN__c='3435161649',
            //vlocity_cmt__ActivationDate__c = Date.today().addDays(-70),
            Status = 'Active',
            Subscription_Id__c = '345345345'
        );
        insert assetObj;

        //Asset otros asset pre permanencia <60 113678259
        assetObj = new Asset(
            Name='DA TestAsset'+ Math.round(Math.random()*10000),
            Product2Id=productoObj.Id, 
            AccountId=accountObj.Id, 
            MSISDN__c='113678259',
            Status = 'Active',
            vlocity_cmt__ActivationDate__c = Date.today(),
            Subscription_Id__c = '3453412345'
        );
        insert assetObj;

        //Product creation
        productoObj = new Product2(
            Name='DA TestProduct' + Math.round(Math.random()*10000),
            ProductCode='TestProductCode' + + Math.round(Math.random()*10000),
            vlocity_cmt__Type__c = 'Plan Pospago'
        );
        insert productoObj;
        
        assetObj = new Asset(
            Name='DA TestAsset'+ Math.round(Math.random()*10000),
            Product2Id=productoObj.Id, 
            AccountId=accountObj.Id, 
            MSISDN__c='1123409872',
            Status = 'Active',
            Subscription_Id__c = '342094345'
        );
        insert assetObj;

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
        public FromJSON_1 requestFromBDO; 
        public FromJSON() {
            requestFromBDO = new FromJSON_1();
        }
    }


    public class FromJSON_1 {
        public Long nroSolicitudPortacion; 
        public String nroUnicoSolicitudPortacion;
        public String codOperadoraDonante;
        public String codOperadoraReceptora;
        public String tipoRed;
        public String tipoProcesoPortacion;
        public String estadoProcesoPortacion;
        public String subEstadoProcesoPortacion;
        public String descripcionEstadoProcesoPortacion;
        public String fechaEstadoProcesoPortacion;
        public String codMercadoDonante;
        public String fechaVentanaPortacion;
        public String lineasPortacion;
        public Integer cantidadLineasPortacion;
        public String nroLinea;
        public String PINPortacion;
        public String codCausaRechazoPortacion;
        public List<FromJSON_2> documentacionLista;
        public FromJSON_3 reversion;
        public FromJSON_4 apoderado;
        public FromJSON_1 () {
            documentacionLista = new List<FromJSON_2>();
            apoderado = new FromJSON_4();
        }
    }
     public class FromJSON_2 {
        public String comentario; 
        public String datosDocumento; 
        public String tipoDocumentacionPortacion; 
        public String nombreArchivoPortacion; 
        public String tipoProcesoPortacion; 
    }
     public class FromJSON_3 {
        public Long nroSolicitudPortacion; 
    }
     public class FromJSON_4 {
        public String tipoDocumento;
        public String numeroDocumento;
        public String nombre;
        public String apellido;
    }

    public class ErrorClass {
        public String errorCode;
        public String message;
    }

}