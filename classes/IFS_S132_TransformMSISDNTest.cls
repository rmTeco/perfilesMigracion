@isTest
public class IFS_S132_TransformMSISDNTest {
    static final String K_ACCOUNT_NAME = 'TestS132Acc';

    @isTest static void testResponseStatus200 () {

        createData();
        
        Map<String, Object> pInputMap = new Map<String, Object>();
        Map<String, Object> body = new Map<String, Object>();
        Map<String, Object> pOutputMap = new Map<String, Object>();

        body.put('valorConsulta','1130150222');
        pInputMap.put('body',body);
        System.debug('----- mapa para pInputMap  : ' + JSON.serialize(pInputMap));
 
        Test.startTest();
 
        IFS_S132_TransformMSISDN clase = new IFS_S132_TransformMSISDN();

        Boolean isOk = clase.invokeMethod('getTransformParam', pInputMap, pOutputMap, null);
        System.debug('----- mapa para isOk ' + isOk);

        System.assertEquals(true, isOk); 
        Test.stopTest();
    }

    @isTest static void testResponse2 () {

        createData();
        
        Map<String, Object> pInputMap = new Map<String, Object>();
        Map<String, Object> body = new Map<String, Object>();

        body.put('valorConsulta1','1130150222');
        pInputMap.put('body',body);
        System.debug('----- mapa para pInputMap  : ' + JSON.serialize(pInputMap));
 
        Test.startTest();
 
        IFS_S132_TransformMSISDN clase = new IFS_S132_TransformMSISDN();

        Boolean isOk = clase.invokeMethod('getTransformParam', pInputMap, null, null);
        System.debug('----- mapa para isOk ' + isOk);

        System.assertEquals(false, isOk); 
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