@isTest
public class PortabilityHandleTest {

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

    @isTest 
    public static void ProcessPortability_LineaPREOkTest(){
        createData();


        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        //Case 1
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '12312344',
            VoucherNumber__c = '213124',
            SuppliedPhone = '3435161523',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'PRE',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'APSI',
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Linea PRE Ok'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '3435161523';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;

        List<Id> cases = new List<Id>();
        cases.add(caseObj.Id);

        // Set Mock by Integration Procedure Key
        String mockResponse= '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S141', mockResponse);

        Test.startTest();
        PortabilityHandler.ProcessPortability(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        //system.assertEquals(ca.Port_Rejection_Reason__c, 'M58');
        //system.assertEquals(ca.Status, 'Rechazada Pendiente ABD');
    }

    @isTest 
    public static void ProcessPortability_LineaPREAssetPOSTest(){
        createData();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case 2
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '12312321',
            VoucherNumber__c = '213234124',
            SuppliedPhone = '1123409872',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'PRE',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'APSI',
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Linea PRE, Asset POS'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '1123409872';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;
        
        cases.add(caseObj.Id);

        // Set Mock by Integration Procedure Key
        String mockResponse= '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S141', mockResponse);


        Test.startTest();
        PortabilityHandler.ProcessPortability(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        system.assertEquals(ca.Port_Rejection_Reason__c, 'A04');
        system.assertEquals(ca.Status, 'Rechazada Pendiente ABD');
    }

    @isTest 
    public static void ProcessPortability_TwoPRELinesTest(){
        createData();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case 3 (2 lineas)
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '1231212321',
            VoucherNumber__c = '215534124',
            SuppliedPhone = '1135678927',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'PRE',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'APSI',
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Case informa PRE, pero tiene 2 lineas'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '1135678927';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;

        com= new CaseComment();
        com.CommentBody = '3435161523';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;
        cases.add(caseObj.Id);


        // Set Mock by Integration Procedure Key
        String mockResponse= '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S141', mockResponse);


        Test.startTest();
        PortabilityHandler.ProcessPortability(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        system.assertEquals(ca.Port_Rejection_Reason__c, 'M58');
        system.assertEquals(ca.Status, 'Rechazada Pendiente ABD');
    }

    @isTest 
    public static void ProcessPortability_LineaPRELimiteTest(){
        createData();
        
        TASalesCodeValue__c cs = new TASalesCodeValue__c();
        cs.name = 'PortOutReject_MinBalance';
        cs.Value__c = '60.1';
        upsert cs;

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case 4 - 1190876234
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '123134121',
            VoucherNumber__c = '213234124',
            SuppliedPhone = '1190876234',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'PRE',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'APSI',
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Linea PRE limite'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '1190876234';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;
        cases.add(caseObj.Id);

        // Set Mock by Integration Procedure Key
        String mockResponse= '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S141', mockResponse);

        Test.startTest();
        PortabilityHandler.ProcessPortability(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        //system.assertEquals(ca.Port_Rejection_Reason__c, 'M58');
        //system.assertEquals(ca.Status, 'Rechazada Pendiente ABD');
    }

    @isTest 
    public static void ProcessPortability_LineaDaysLimitTest(){
        createData();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case 5 - 113678259
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '6576',
            VoucherNumber__c = '2902334124',
            SuppliedPhone = '113678259',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'PRE',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'APSI',
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Linea PRE activa < 60'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '113678259';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;
        cases.add(caseObj.Id);

        // Set Mock by Integration Procedure Key
        String mockResponse= '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S141', mockResponse);

        Test.startTest();
        PortabilityHandler.ProcessPortability(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        system.assertEquals(ca.Port_Rejection_Reason__c, 'A02');
        system.assertEquals(ca.Status, 'Rechazada Pendiente ABD');
    }

    @isTest 
    public static void ProcessPortability_PosButPreTest(){
        createData();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case Pos but pre
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '12987344',
            VoucherNumber__c = '2908124',
            SuppliedPhone = '3435161649',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'POS',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'APSI',
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Linea PRE indica POS'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '3435161649';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;

        cases.add(caseObj.Id);

        // Set Mock by Integration Procedure Key
        String mockResponse= '{"ListInfoRecarga":[{"fechaRecarga":"2017-11-07 19:22:00","idCuenta":"PPS_129049450","codSuscripcion":"129049450","identificadorRecurso":"3435161523","codCuentaTasacion":"PPS_129049450","txId":"NROL_507374864","montoRecarga":"36.00","codMoneda":"ARS","importePago":"36.00","codTipoRecarga":"237","codCanal":"ROL","codMotivoRecarga":"1","codRespuesta":"0","PeriodoRecarga":{"ListaBonusBalance":{"BonusBalance":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","codMoneda":"ARS","saldoBalance":1040,"nombreBalance":"Credito de Recargas","codBalance":"710400000011669684","codTipoBalance":"C_MAIN_ACCOUNT"}]},"ListaInfoUnidadesLibres":{"InfoUnidadLibre":[{"fechaVigenciaHastaProdAdq":"2017-12-07 19:22:00","fechaVigenciaDesdeProdAdq":"2017-10-07 19:22:00","saldoBalance":450,"descUnidadMedida":"ARS","codUnidadDeMedida":"ARS","descUsoUnidadesLibres":"Inter-network free call","codUsoUnidadesLibres":"IFC","codPaqueteUnidadesLibres":"0001"}]}},"cicloDeVida":{"ListInfoCicloDeVidaAnterior":[{"codEstadoSuscripcion":"1","fechaExpiracionSuscripcion":"1969-12-31 21:00:00","estadoSuscripcion":"Creada"}],"periodoRecarga":"0"},"ListInfoBalance":[{"codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"710400000011669684","nombreBalance":"Credito de Recargas","saldoBalanceAnterior":{"saldoBalance":"0.0000"},"nuevoSaldoBalance":{"saldoBalance":"36.0000"},"codMoneda":"ARS"}],"listDatosAdicionales":[{"nombreParametro":"RechargeAreaCode","valorParametro":"0"}],"listInfoCredito":[{"tipoPerfilCrediticio":"Recarga","limiteCreditoOriginal":"20.000","limiteCreditoActual":"36.000","codUnidadDeMedida":"ARS"}],"cantidadItemsConsulta":"1","referenciaItemPaginado":"0","cantidadMaxConsulta":"1"}]}';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S141', mockResponse);

        Test.startTest();
        PortabilityHandler.ProcessPortability(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        system.assertEquals(ca.Port_Rejection_Reason__c, 'A03');
        system.assertEquals(ca.Status, 'Rechazada Pendiente ABD');
    }
    @isTest 
    public static void ProcessPortability_RESITest(){
        createData();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '129983344',
            VoucherNumber__c = '2908124',
            SuppliedPhone = '3435161239',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'POS',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'RESI',
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Substatus RESI'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '3435161239';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;

        cases.add(caseObj.Id);


        Test.startTest();
        PortabilityHandler.ProcessPortability(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];
        system.assertEquals(ca.Status, 'Rechazada Pendiente ABD');
    }

    @isTest 
    public static void UpdatePortabilityCases_Aceptada(){
        createData();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case 1
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '12312344',
            VoucherNumber__c = '213124',
            SuppliedPhone = '3435161523',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'PRE',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AREC',
            Subarea__c = 'NULL',
            Modified_Date__c = Date.today().addDays(-1),
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Rechazo aceptado'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '3435161523';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;

        cases.add(caseObj.Id);

        Test.startTest();
        PortabilityHandler.UpdatePortabilityCases(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        system.assertEquals(ca.Status, 'Rechazada');
    }
    
    @isTest 
    public static void UpdatePortabilityCases_Rechazada(){
        createData();

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portability').getRecordTypeId();
        List<Case> caseLista = [SELECT Id FROM Case WHERE RecordTypeId = :recordTypeId];

        List<Id> cases = new List<Id>();

        //Case 2
        Case caseObj = new Case(
            RecordTypeId = recordTypeId,
            ExternalCaseId__c = '45482344',
            VoucherNumber__c = '21323444',
            SuppliedPhone = '3435161908',
            Port_Doc_Type__c = 'DNI',
            Port_Doc_No__c = 30987125,
            Port_Market__c = 'PRE',
            Port_Donor_Cod__c = 'TP00',
            Port_Receiver_Cod__c = 'MOVI',
            Origin = 'ALEX',
            Type = 'Movil',
            Area__c = 'AACE',
            Subarea__c = 'RIMP',
            Modified_Date__c = Date.today().addDays(-1),
            Speech__c = 'Alta Rechazada Operacionales',
            Subject = 'Rechazo rechazado'
        );
        insert caseObj;

        CaseComment com= new CaseComment();
        com.CommentBody = '3435161908';
        com.IsPublished = TRUE;
        com.ParentId = caseObj.Id;
        insert com;

        cases.add(caseObj.Id);

        Test.startTest();
        PortabilityHandler.UpdatePortabilityCases(cases);
        Test.stopTest();

        Case ca = [Select Port_Rejection_Reason__c, Status From Case Where Id = :caseObj.Id LIMIT 1];

        system.assertEquals(ca.Status, 'Aprobada Pendiente de Portación');
    }
    

}