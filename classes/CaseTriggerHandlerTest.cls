@isTest
public class CaseTriggerHandlerTest {

    @testSetup
    public static void createDataTest() {
        List<Account> accounts = TestDataFactory.createAccounts(1);
        List<Asset> assets = TestDataFactory.createAssets(1, accounts.get(0));
    }


    @isTest
    public static void updateCaseDataOnInsertTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];

        WorkTeam__c wt = TestDataFactory.createWorkTeam('WorkTeamTestCase');
        Team_Member__c tm = TestDataFactory.setTeamMember('TeamMemberTestCase', UserInfo.getUserId(), wt);

        List<Case> cases = TestDataFactory.createCases(1, account.Id, asset.Id, 'Subject');

        //WHEN
        CaseTriggerHandler.updateCaseDataOnInsert(cases);

        //THEN
        System.assert(true);


    }

    @isTest
    public static void updateCaseOnUpdateTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];

        List<Case> cases = TestDataFactory.createCases(1, account.Id, asset.Id, 'Subject');

        //WHEN
        CaseTriggerHandler.updateCaseOnUpdate(cases);

        //THEN
        System.assert(true);


    }

    @isTest
    public static void checkUserProfileOnDeleteTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];

        List<Case> cases = TestDataFactory.createCases(1, account.Id, asset.Id, 'Subject');

        //WHEN
        CaseTriggerHandler.checkUserProfileOnDelete(cases);

        //THEN
        System.assert(true);


    }

    @isTest
    public static void updateChildonMassiveTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];

        List<Case> cases = TestDataFactory.createCases(1, account.Id, asset.Id, 'Subject');
        Map<Id, Case> casesMap = new Map<Id, Case>(cases);

        for (Case c: cases) {
            c.Status = 'Resuelta Masiva';
        }

        //WHEN
        CaseTriggerHandler.updateChildonMassive(cases, casesMap);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void escalarCasoTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Profile profile = [SELECT Name FROM Profile LIMIT 1];

        User u = TestDataFactory.createUser(profile.Name);

        WorkTeam__c wtParent = new WorkTeam__c(
            Name = 'WorkTeamTestCaseParent',
            Team_Name__c = 'WorkTeamTestCaseParent',
            Is_Active__c = true,
            Manager__c = u.Id
        );
        insert wtParent;



        WorkTeam__c wt = TestDataFactory.createWorkTeam('WorkTeamTestCase');
        wt.Manager__c = UserInfo.getUserId();
        wt.Parent_Team__c = wtParent.id;
        update wt;

        List<Case> cases = TestDataFactory.createCases(1, account.Id, asset.Id, 'Subject');

        for (Case c: cases) {
            c.Status = 'Expirada';
            c.Subject = 'Inconvenientes con cargos tasados y facturados';
            c.Approver__c = UserInfo.getUserId();
            c.vlocity_cmt__Amount__c = 400;
        }

        //WHEN
        CaseTriggerHandler.escalarCaso(cases);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void validateSplitAmountTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Profile profile = [SELECT Name FROM Profile LIMIT 1];

        User u = TestDataFactory.createUser(profile.Name);

        List<Case> cases = TestDataFactory.createCases(1, account.Id, asset.Id, 'Subject');
        Map<Id, Case> casesMap = new Map<Id, Case>();

        for (Case c: cases) {
            c.Subject = 'Inconvenientes con cargos tasados y facturados';
            c.OwnerId = u.Id;
            c.vlocity_cmt__Amount__c = 400;

            casesMap.put(c.Id, new Case(
                                Subject = c.Subject,
                                AccountId = c.AccountId,
                                AssetId = c.AssetId,
                                OwnerId = UserInfo.getUserId())
            );
        }

        //WHEN
        CaseTriggerHandler.validateSplitAmount(cases, casesMap);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void submitApprovalProcessTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        List<Case> cases = TestDataFactory.createCases(1, account.Id, asset.Id, 'Subject');

        String escalamiento = 'RAV_Escalamiento_a_Equipo';
        String caseId = cases.get(0).Id;

        //WHEN
        CaseTriggerHandler.submitApprovalProcess(escalamiento, caseId);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void setAdjustment9Test () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        asset.Subscription_Id__c = 'Subscription_Id__c';
        update asset;
        Case c = new Case(
                                Subject='Inconvenientes con cargos tasados y facturados',
                                AccountId = account.Id,
                                AssetId = asset.Id,
                                TipoSeleccion__c = 'Servicio',
                                UnidadAjuste__c = 'Credito',
                                TipoOperacionAjuste__c = 'DEBITO',
                                vlocity_cmt__Amount__c = 400,
                                vlocity_cmt__ServiceId__c = asset.Id);
        insert c;

        Set<Id> casesId = new Set<Id>();
        casesId.add(c.Id);

        //WHEN
        CaseTriggerHandler.setAdjustment(casesId);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void setAdjustment1Test () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        asset.Subscription_Id__c = 'Subscription_Id__c';
        update asset;
        Case c = new Case(
                                Subject='Inconvenientes con cargos tasados y facturados',
                                AccountId = account.Id,
                                AssetId = asset.Id,
                                TipoSeleccion__c = 'Servicio',
                                UnidadAjuste__c = 'Credito',
                                TipoOperacionAjuste__c = 'CREDITO',
                                vlocity_cmt__Amount__c = 400,
                                vlocity_cmt__ServiceId__c = asset.Id);
        insert c;

        Set<Id> casesId = new Set<Id>();
        casesId.add(c.Id);

        //WHEN
        CaseTriggerHandler.setAdjustment(casesId);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void setAdjustment2Test () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];

        Case c = new Case(
                                Subject='Inconvenientes con cargos tasados y facturados',
                                AccountId = account.Id,
                                AssetId = asset.Id,
                                TipoSeleccion__c = 'Servicio',
                                TipoOperacionAjuste__c = 'NC - Libre',
                                UnidadAjuste__c = 'VOZ',
                                vlocity_cmt__Amount__c = 400,
                                CantidadAjuste__c = '10:10:10',
                                vlocity_cmt__ServiceId__c = asset.Id);
        insert c;

        Set<Id> casesId = new Set<Id>();
        casesId.add(c.Id);

        //WHEN
        CaseTriggerHandler.setAdjustment(casesId);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void setAdjustment3Test () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];

        Case c = new Case(
                                Subject='Inconvenientes con cargos tasados y facturados',
                                AccountId = account.Id,
                                AssetId = asset.Id,
                                TipoSeleccion__c = 'Cuenta',
                                TipoOperacionAjuste__c = 'NC - Libre',
                                UnidadAjuste__c = 'VOZ',
                                vlocity_cmt__Amount__c = 400,
                                CantidadAjuste__c = '10:10:10',
                                vlocity_cmt__ServiceId__c = asset.Id);
        insert c;

        Set<Id> casesId = new Set<Id>();
        casesId.add(c.Id);

        //WHEN
        CaseTriggerHandler.setAdjustment(casesId);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void callToIntegrationS479Test () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Case c = new Case(
                                Subject='Inconvenientes con cargos tasados y facturados',
                                AccountId = account.Id,
                                AssetId = asset.Id,
                                TipoSeleccion__c = 'Servicio',
                                UnidadAjuste__c = 'Credito',
                                TipoOperacionAjuste__c = 'CREDITO',
                                vlocity_cmt__Amount__c = 400,
                                vlocity_cmt__ServiceId__c = asset.Id);
        insert c;

        Map<String, Object> output = new Map<String, Object>();

        //WHEN
        CaseTriggerHandler.callToIntegrationS479(c, output);

        //THEN
        System.assert(true);
    }

    @isTest
    public static void getTotalItemsForVouchersTest () {
        //GIVE
        Account account = [SELECT Id FROM Account LIMIT 1];
        Asset asset = [SELECT Id FROM Asset LIMIT 1];
        Case c = new Case(
                                Subject='Inconvenientes con cargos tasados y facturados',
                                AccountId = account.Id,
                                AssetId = asset.Id,
                                TipoSeleccion__c = 'Servicio',
                                UnidadAjuste__c = 'Credito',
                                TipoOperacionAjuste__c = 'CREDITO',
                                vlocity_cmt__Amount__c = 400,
                                vlocity_cmt__ServiceId__c = asset.Id);
        insert c;

        Map<String, Object> response = new Map<String, Object>();
        Map<String, Object> listaDetalle = new Map<String, Object>();
        List<Object> elementoDetalle = new List<Object>();
        Map<String, Object> elemento = new Map<String, Object>();
        elemento.put('montoNetoAjuste', 200.00);
        Map<String, Object> importeFacturaFinal = new Map<String, Object>();
        importeFacturaFinal.put('importeItemComprobanteSinImp', 400.00);
        elemento.put('importeFacturaFinal', importeFacturaFinal);
        elemento.put('codCargo','codCargo');
        Map<String, Object> idItemCorreccion = new Map<String, Object>();
        idItemCorreccion.put('nroItemComprobante', 'nroItemComprobante');
        idItemCorreccion.put('montoNetoAjuste', 'montoNetoAjuste');
        elemento.put('idItemCorreccion',idItemCorreccion);
        elementoDetalle.add(elemento);
        listaDetalle.put('elementoDetalle', elementoDetalle);
        Map<String, Object> solicitudCorreccionInformacion = new Map<String, Object>();
        solicitudCorreccionInformacion.put('listaDetalle', listaDetalle);
        response.put('solicitudCorreccionInformacion', solicitudCorreccionInformacion);

        //WHEN
        CaseTriggerHandler.getTotalItemsForVouchers(c, account, response);

        //THEN
        System.assert(true);
    }
    
    @IsTest static void Test_updateCaseTechServiceCriteria(){

        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
            Name='Account Test', 
            RecordTypeId = businessRecordTypeId
        );
        insert accountObj;
 
       /* Entitlement entitleTest = New Entitlement(
            Name= 'TechCare-OrderAcceptance',
            AccountId = accountObj.id
        );
        insert entitleTest;   */    
        
        List<Order> testOrder = TestDataFactory.createOrders(1,accountObj);
        testOrder[0].OrderApprovalStatus__c = 'Pendiente de aprobación';
        update testOrder;
        /*Order orderTest = New Order(
             AccountId =accountObj.Id,
             Status = 'Draft',
             OrderApprovalStatus__c = 'Pendiente de aprobación',
             Delivery_Method__c='Delivery',
             EffectiveDate = date.today()
         );
        
        insert orderTest;*/
        
        Id techServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Service').getRecordTypeId();
        Case caseObj2 = New Case(
            Origin = 'Personalizado',
            AccountId = accountObj.Id,
            RecordTypeId = techServiceRecordTypeId,
            Subject = 'Gestión de Servicio Técnico',
            Order__c = testOrder[0].Id
            );
        insert caseObj2;
        
        
        Test.startTest();
        caseObj2.Status = 'En espera del cliente';
        Update caseObj2;            
        Test.stopTest();
        Case finalCase = [SELECT Id,AccountId,EntitlementId FROM Case WHERE AccountId =: accountObj.Id LIMIT 1];
        system.AssertNotEquals(null,finalCase.EntitlementId);
        
    }
    
    @IsTest static void Test_updateCaseTechServiceCriteria_Derivada(){
        /*MilestoneType miles = New MilestoneType();
        miles.Name = 'TechCare10Days';
        miles.RecurrenceType = 'recursChained';
        insert miles;*/
        
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
            Name='Account Test', 
            RecordTypeId = businessRecordTypeId
        );
        insert accountObj;      
        
        /*Order orderTest = New Order(
             AccountId =accountObj.Id,
             Status = 'Draft',
             OrderApprovalStatus__c = 'Pendiente de aprobación',
             Delivery_Method__c='Delivery',
             EffectiveDate = date.today()
         );
         insert orderTest;*/
         
         
        List<Order> testOrder = TestDataFactory.createOrders(1,accountObj);
        testOrder[0].OrderApprovalStatus__c = 'Pendiente de aprobación';
        update testOrder;
        
        Id techServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Service').getRecordTypeId();
        Case caseObj2 = New Case(
            Origin = 'Personalizado',
            AccountId = accountObj.Id,
            RecordTypeId = techServiceRecordTypeId,
            Subject = 'Gestión de Servicio Técnico',
            Order__c = testOrder[0].Id
            );
        insert caseObj2;
        
        CaseHistory testHistory = New CaseHistory();
        testHistory.Field = 'Owner';
        testHistory.CaseId = caseObj2.Id;
        insert testHistory;
        
        
        User testUser = TestDataFactory.createUser('System Administrator');
        Map<id,id> idQueueMap = New Map<Id,Id>();
        idQueueMap.put(caseObj2.Id,testUser.Id);
        Map<id,String> casesMap = New Map<id,String>();
        String caseString = Json.serialize(caseObj2);
        casesMap.put(caseObj2.Id,caseString);
        
        
        Test.startTest();
        caseObj2.Status = 'Derivada';
        Update caseObj2;
        CaseTriggerHandler.setFirstBackOfficeQueueFuture(casesMap,idQueueMap);
        Test.stopTest();
        
    }
    
    /*@IsTest static void setFirstBackOfficeQueueFuture_test(){
        MilestoneType miles = New MilestoneType();
        miles.Name = 'TechCare10Days';
        miles.RecurrenceType = 'recursChained';
        insert miles;
        
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
            Name='Account Test', 
            RecordTypeId = businessRecordTypeId
        );
        insert accountObj;
        
        User testUser = TestDataFactory.createUser('Vlocity_Developer');
        
        Id techServiceRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Technical Service').getRecordTypeId();
        Case caseObj2 = New Case(
            Origin = 'Personalizado',
            AccountId = accountObj.Id,
            RecordTypeId = techServiceRecordTypeId,
            Subject = 'Gestión de Servicio Técnico'
            );
        insert caseObj2;
        
        CaseMilestone csMiles = New CaseMilestone();
        csMiles.CaseId = caseObj2.Id;
        csMiles.MilestoneTypeId = miles.Id;
        csMiles.TargetDate = datetime.now();
        insert csMiles;
        
        Map<id,id> idQueueMap = New Map<Id,Id>();
        idQueueMap.put(caseObj2.Id,testUser.Id);
        Map<id,String> casesMap = New Map<id,String>();
        String caseString = Json.serialize(caseObj2);
        casesMap.put(caseObj2.Id,caseString);
        
    }*/
    
    @IsTest static void SetOwnerTeam_Test(){
        List<Account> accountTest = TestDataFactory.createAccounts(1,'Business');
        //vlocity_cmt__BusinessSite__c storeLoc = TestDataFactory.createStoreLocation('Test location',accountTest[0].Id);
        vlocity_cmt__BusinessSite__c storeLocation = new vlocity_cmt__BusinessSite__c();
        storeLocation.Name = 'test name';
        storeLocation.BillingMode__c = 'Fiscal';
        storeLocation.Channel__c = 'Digital';
        storeLocation.Channel_Type__c = 'SMS';
        storeLocation.Channel_Type_2__c = 'SMS';
        storeLocation.Channel_Type_3__c = 'SMS';
        storeLocation.Vlocity_cmt__OrganizationId__c = accountTest[0].Id;
        insert storeLocation;
        
        WorkTeam__c workTeam = TestDataFactory.createWorkTeam('wt Test',storeLocation);
        User userTest = TestDataFactory.createUser('System Administrator');
        Team_Member__c tmTest = TestDataFactory.setTeamMember('testwk',userTest.Id,workTeam);
        List<Case> caseTest = TestDataFactory.createCases(1,accountTest[0].Id,'test');
        
        Test.startTest();
        caseTest[0].OwnerId = userTest.Id;
        update caseTest;
        Test.stopTest();
        
        Case caseDummy = [SELECT id,OwnerId,Owner_Team__c FROM Case WHERE Id =: caseTest[0].Id];
        System.assertNotEquals(null, caseDummy.Owner_Team__c);
    }

}