@IsTest
public class ta_care_queryAdjustmentsHelper_test {
    @IsTest static void invoke_queryAdjustmentHelper_OK(){
        String methodName = 'GetAdjustmentHistory';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();

        String jsonInputString = '{"body": {"cantidadItemsConsulta": 5,"cantidadMaxConsulta": 5,"cuenta":{"codigoAcceso": {"codSuscripcion": ""}},"infoDetalle": {},"referenciaItemPaginado": 0},"codSuscript": "20140527145410"}';
        String body ='{"listaDetalleAjuste":[{"fechaAjuste":"2014/05/27 15:30:30","codCuentaTasacion":"a13600434101","codSuscripcion":"20140527145411","identificadorRecurso":"13600434101","codCanal":"4","txId":"1849199","listaAjusteBalanceInfo":[{"codBalance":"1123243343","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"CREDITO","montoAjuste":324,"codMoneda":"ARS","fechaAltaBalance":"2014/05/27 15:30:30","fechaExpiracionBalance":"2014/06/27 15:30:30"}],"codMotivoAjuste":"5"},{"fechaAjuste":"2014/07/27 15:30:30","codCuentaTasacion":"b13600434101","codSuscripcion":"20150527145411","identificadorRecurso":"13600434101","codCanal":"5","txId":"1849200","listaAjusteBalanceInfo":[{"codBalance":"1123243344","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"CREDITO","montoAjuste":122,"codMoneda":"ARS","fechaAltaBalance":"2014/05/01 15:30:30","fechaExpiracionBalance":"2014/06/13 15:30:30"}],"codMotivoAjuste":"5"},{"fechaAjuste":"2015/01/27 15:30:30","codCuentaTasacion":"c13600434101","codSuscripcion":"20330527145411","identificadorRecurso":"13600434101","codCanal":"4","txId":"1849211","listaAjusteBalanceInfo":[{"codBalance":"11443243344","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"DEBITO","montoAjuste":54.07,"codMoneda":"ARS","fechaAltaBalance":"2014/05/24 15:30:30","fechaExpiracionBalance":"2014/06/13 15:30:30"},{"codBalance":"11443243345","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"DEBITO","montoAjuste":134.67,"codMoneda":"ARS","fechaAltaBalance":"2014/05/24 15:30:30","fechaExpiracionBalance":"2014/06/13 15:30:30"},{"codBalance":"11443243346","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"DEBITO","montoAjuste":345.27,"codMoneda":"ARS","fechaAltaBalance":"2016/05/24 15:30:30","fechaExpiracionBalance":"2016/06/13 15:30:30"}],"listaInfoAjusteUnidadesLibres":[{"fechaAjusteVigenciaHasta":"2014/08/13 15:30:30","fechaAjusteVigenciaDesde":"2014/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":150,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1000"},{"fechaAjusteVigenciaHasta":"2015/08/13 15:30:30","fechaAjusteVigenciaDesde":"2015/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":275,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1001"},{"fechaAjusteVigenciaHasta":"2016/08/13 15:30:30","fechaAjusteVigenciaDesde":"2016/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":56,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1002"}],"codMotivoAjuste":"5"}],"cantidadItemsConsulta":3,"referenciaItemPaginado":0,"cantidadMaxConsulta":5}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> inputMapN1 = (Map<String, Object>) JSON.deserializeUntyped(jsonInputString);
        outMap.put('IPResult', responseNode);
        System.debug('inputMapN1 __'+ inputMapN1 );
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();

        getAdjustments_CBS__c setting = new getAdjustments_CBS__c();
        setting.Name = '5';
        setting.ServiceCode__c = 5;
        setting.ServiceMessage__c = '5';
        insert setting;


        Test.startTest();
        testedClass.invokeMethod(methodName, inputMapN1, outMap, options);
        Test.stopTest();

        Map<String,Object> IPRes = (Map<String,Object>) outMap.get('IPResult');
        List<Object> listaDetalleAjuste = (List<Object>) IPRes.get('listaDetalleAjuste');
        Map<String,Object> recordMap = (Map<String,Object>) listaDetalleAjuste[0];

        system.assertEquals('4', recordMap.get('codCanal'));
        system.assertEquals('5', recordMap.get('motivoAjuste'));
        system.assertEquals('1849199', recordMap.get('txId'));
    }
    @IsTest static void invoke_GetAdjustmentHistoryForOS_OK(){
        String methodName = 'GetAdjustmentHistoryForOS';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();

        String jsonInputString = '{"body": {"cantidadItemsConsulta": 5,"cantidadMaxConsulta": 5,"cuenta":{"codigoAcceso": {"codSuscripcion": ""}},"infoDetalle": {},"referenciaItemPaginado": 0},"codSuscript": "20140527145410"}';
        inputMap = (Map<String, Object>) JSON.deserializeUntyped(jsonInputString);
        String body ='{"listaDetalleAjuste":[{"fechaAjuste":"2014/05/27 15:30:30","codCuentaTasacion":"a13600434101","codSuscripcion":"20140527145411","identificadorRecurso":"13600434101","codCanal":"4","txId":"1849199","listaAjusteBalanceInfo":[{"codBalance":"1123243343","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"CREDITO","montoAjuste":324,"codMoneda":"ARS","fechaAltaBalance":"2014/05/27 15:30:30","fechaExpiracionBalance":"2014/06/27 15:30:30"}],"codMotivoAjuste":"5"},{"fechaAjuste":"2014/07/27 15:30:30","codCuentaTasacion":"b13600434101","codSuscripcion":"20150527145411","identificadorRecurso":"13600434101","codCanal":"5","txId":"1849200","listaAjusteBalanceInfo":[{"codBalance":"1123243344","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"CREDITO","montoAjuste":122,"codMoneda":"ARS","fechaAltaBalance":"2014/05/01 15:30:30","fechaExpiracionBalance":"2014/06/13 15:30:30"}],"codMotivoAjuste":"5"},{"fechaAjuste":"2015/01/27 15:30:30","codCuentaTasacion":"c13600434101","codSuscripcion":"20330527145411","identificadorRecurso":"13600434101","codCanal":"4","txId":"1849211","listaAjusteBalanceInfo":[{"codBalance":"11443243344","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"DEBITO","montoAjuste":54.07,"codMoneda":"ARS","fechaAltaBalance":"2014/05/24 15:30:30","fechaExpiracionBalance":"2014/06/13 15:30:30"},{"codBalance":"11443243345","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"DEBITO","montoAjuste":134.67,"codMoneda":"ARS","fechaAltaBalance":"2014/05/24 15:30:30","fechaExpiracionBalance":"2014/06/13 15:30:30"},{"codBalance":"11443243346","codTipoBalance":"C_MAIN_ACCOUNT ","tipoAjuste":"DEBITO","montoAjuste":345.27,"codMoneda":"ARS","fechaAltaBalance":"2016/05/24 15:30:30","fechaExpiracionBalance":"2016/06/13 15:30:30"}],"listaInfoAjusteUnidadesLibres":[{"fechaAjusteVigenciaHasta":"2014/08/13 15:30:30","fechaAjusteVigenciaDesde":"2014/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":150,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1000"},{"fechaAjusteVigenciaHasta":"2015/08/13 15:30:30","fechaAjusteVigenciaDesde":"2015/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":275,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1001"},{"fechaAjusteVigenciaHasta":"2016/08/13 15:30:30","fechaAjusteVigenciaDesde":"2016/06/13 15:30:30","codUnidadDeMedida":"MB","montoAjuste":56,"tipoAjuste":"CREDITO","codUsoUnidadesLibres":"string","codPaqueteUnidadesLibres":"1002"}],"codMotivoAjuste":"5"}],"cantidadItemsConsulta":3,"referenciaItemPaginado":0,"cantidadMaxConsulta":5}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(body);
        outMap.put('IPResult', responseNode);
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();

        getAdjustments_CBS__c setting = new getAdjustments_CBS__c();
        setting.Name = '5';
        setting.ServiceCode__c = 5;
        setting.ServiceMessage__c = '5';
        insert setting;


        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        Map<String,Object> IPRes = (Map<String,Object>) outMap.get('IPResult');
        List<Object> listaDetalleAjuste = (List<Object>) IPRes.get('listaDetalleAjuste');
        Map<String,Object> recordMap = (Map<String,Object>) listaDetalleAjuste[0];
        system.debug(recordMap);
        system.assertEquals('13600434101', recordMap.get('identificadorRecurso'));
    }
    @isTest static void invoke_GetWorkTeamHierarchy_ERROR_102(){
        String methodName ='GetWorkTeamHierarchy';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();

        options.put('approvalProfile','TA - Gerente 2da Dependencia');
        //options.put('workteamID','a4l6C0000000790');

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();


        Map<String,Object> result = (Map<String,Object>) outMap.get('result');
        system.assertEquals('102',(string)result.get('codError'));
    }
    @isTest static void invoke_GetWorkTeamHierarchy_ERROR_101(){
        String methodName ='GetWorkTeamHierarchy';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();

        //options.put('approvalProfile','TA - Gerente 2da Dependencia');
        options.put('workteamID','a4l6C0000000790');

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();


        Map<String,Object> result = (Map<String,Object>) outMap.get('result');
        string codError = (string)result.get('codError');
        system.assertEquals('101',codError);
    }
    @isTest
    static void invoke_GetWorkTeamHierarchy_OK(){
        String methodName ='GetWorkTeamHierarchy';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();

        //String profileName = 'FAN - Gerente 1ra Dep';
        //Id profileId = [SELECT Id FROM Profile WHERE name =: profileName].Id;
        //system.debug('Id Perfil: '+ profileId);
        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId].Name;

        User MG = new User();
        MG.ProfileId = profileId;
        MG.Username = 'claseTest@gmail.com';
        MG.Email = 'claseTest@gmail.com';
        MG.LastName = 'Test';
        MG.Alias = 'cTest';
        MG.CommunityNickname = 'CMN';
        MG.TimeZoneSidKey = 'America/Argentina/Buenos_Aires';
        MG.LocaleSidKey = 'es_AR';
        MG.EmailEncodingKey = 'ISO-8859-1';
        MG.LanguageLocaleKey = 'en_US';
        insert MG;

        system.debug('Id Perfil Manager: '+MG.profileId);
        system.debug('Manager: '+MG);

        WorkTeam__c WTParent = new WorkTeam__c();
        WTParent.Manager__c = MG.Id;
        WTParent.Team_Name__c='La Plata';
        WTParent.Name = 'La Plata';
        upsert WTParent;


        WorkTeam__c WT = new WorkTeam__c();
        WT.Manager__c = MG.Id;
        WT.Parent_Team__c = WTParent.Id;
        WT.Team_Name__c='Buenos Aires';
        WT.Name = 'Buenos Aires';
        upsert WT;

        options.put('approvalProfile',profileName);
        options.put('workteamID',WT.Id);

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        Map<String,Object> result = (Map<String,Object>) outMap.get('result');
        system.assertEquals('0',(string)result.get('codError'));
    }
    @isTest
    static void invoke_GetWorkTeamHierarchy_Parent(){
        String methodName ='GetWorkTeamHierarchy';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();


        //String profileName = 'FAN - Gerente 1ra Dep';
        //Id profileId = [SELECT Id FROM Profile WHERE name =: profileName].Id;
        //system.debug('Id Perfil: '+ profileId);
        Id profileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id = :profileId].Name;

        User MG = new User();
        MG.ProfileId = profileId;
        MG.Username = 'claseTest@gmail.com';
        MG.Email = 'claseTest@gmail.com';
        MG.LastName = 'Test';
        MG.Alias = 'cTest';
        MG.CommunityNickname = 'CMN';
        MG.TimeZoneSidKey = 'America/Argentina/Buenos_Aires';
        MG.LocaleSidKey = 'es_AR';
        MG.EmailEncodingKey = 'ISO-8859-1';
        MG.LanguageLocaleKey = 'en_US';
        insert MG;

        system.debug('Id Perfil Manager: '+MG.profileId);
        system.debug('Manager: '+MG);

        WorkTeam__c WTParent = new WorkTeam__c();
        WTParent.Manager__c = MG.Id;
        WTParent.Team_Name__c='La Plata';
        WTParent.Name = 'Test';
        upsert WTParent;

        options.put('approvalProfile', 'TA');
        options.put('workteamID',WTParent.Id);

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        Map<String,Object> result = (Map<String,Object>) outMap.get('result');
        system.assertEquals('103',(string)result.get('codError'));
    }

    @isTest
    static void invoke_RecallApprovalProcess(){
        String methodName ='RecallApprovalProcess';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();


        //Creacion del contacto
        Contact contactObj = new Contact(
            LastName = 'Pepe',
            Phone = '45454544545'
        );
        insert contactObj;

        //Creacion del account
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
            vlocity_cmt__PrimaryContactId__c = contactObj.Id,
            Name='Cuenta Test',
            RecordTypeId = businessRecordTypeId,
            AccountIntegrationId__c = '0016C000009I5zg' //Ver cual existe en huawei
        );
        insert accountObj;

        //Creacion del producto
        Product2 productoObj = new Product2(
            Name='TestProduct',
            ProductCode='TestProductCode'
        );
        insert productoObj;

        //Creacion del Asset
        Asset assetObj = new Asset(
            Name='TestAsset',
            Product2Id=productoObj.Id,
            AccountId=accountObj.Id,
            MSISDN__c='156143243',
            Subscription_Id__c = '345345345' //Ver cual existe en huawei
        );
        insert assetObj;

        WorkTeam__c workTeamObj = new WorkTeam__c(
            Name='Back Office GGCC',
            Team_Name__c = 'Back Office GGCC',
            Team_queue__c = 'Back_Office_Centralizado'
        );
        Insert workTeamObj;

        Id workTeamId = [SELECT Id FROM WorkTeam__c WHERE Name='Back Office GGCC'].Id;

        //Creacion  del caso
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        Case caseObj = new Case(
            Status = 'En autorización',
            Origin = 'Personalizado',
            TipoSeleccion__c = 'Servicio',
            TipoConcepto__c = 'CREDITO PREPAGO',
            Tipo__c = 'No aplica Prepago',
            TipoItem__c = 'Consumos de datos',
            TipoAjuste__c = 'Credito',
            TipoOperacionAjuste__c = 'CREDITO',
            vlocity_cmt__Amount__c = 4001,
            UnidadAjuste__c = 'Credito',
            AccountId = accountObj.Id,
            RecordTypeId = recordTypeId,
            OwnerId = (Id)UserInfo.getUserId(), //Federico
            Subject = 'Inconvenientes con cargos tasados y facturados',
            vlocity_cmt__ServiceId__c = assetObj.Id,
            AssetId = assetObj.Id,
            //LastModifiedById = '0056C000000gQeF',
            //CreatedDate = date.today(),
            Owner_Team__c = workTeamId //'Back_Office_GGCC'
        );

        insert caseObj;

        Id idCase = [SELECT Id, Subject FROM Case WHERE Subject = 'Inconvenientes con cargos tasados y facturados' AND vlocity_cmt__Amount__c = 4001 Limit 1].Id;

        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Envio de pedido de aprobación.');
            req1.setObjectId(idCase);
            req1.setSubmitterId(UserInfo.getUserId());
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId('RAV_Escalamiento_a_Equipo');
            req1.setSkipEntryCriteria(true);

        try{
            Approval.ProcessResult processResult = Approval.process(req1);
        }catch(Exception ex){}
        options.put('id', idCase);
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        Map<String,Object> result = (Map<String,Object>) outMap.get('result');
    }

    @isTest
    static void invoke_AmountLimitForUser(){
        String methodName ='AmountLimitForUser';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();


        //Creacion del contacto
        Contact contactObj = new Contact(
            LastName = 'Pepe',
            Phone = '45454544545'
        );
        Insert contactObj;

        //Creacion del account
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
            vlocity_cmt__PrimaryContactId__c = contactObj.Id,
            Name='Cuenta Test',
            RecordTypeId = businessRecordTypeId,
            AccountIntegrationId__c = '0016C000009I5zg' //Ver cual existe en huawei
        );
        Insert accountObj;

        //Creacion del producto
        Product2 productoObj = new Product2(
            Name='TestProduct',
            ProductCode='TestProductCode'
        );
        Insert productoObj;

        //Creacion del Asset
        Asset assetObj = new Asset(
            Name='TestAsset',
            Product2Id=productoObj.Id,
            AccountId=accountObj.Id,
            MSISDN__c='156143243',
            Subscription_Id__c = '345345345' //Ver cual existe en huawei
        );
        Insert assetObj;

        WorkTeam__c workTeamObj = new WorkTeam__c(
            Name='Back Office GGCC',
            Team_Name__c = 'Back Office GGCC',
            Team_queue__c = 'Back_Office_Centralizado'
        );
        Insert workTeamObj;

        Id workTeamId = [SELECT Id FROM WorkTeam__c WHERE Name='Back Office GGCC'].Id;
        //Creacion  del caso
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        Case caseObj = new Case(
            Status = 'En autorización',
            Origin = 'Personalizado',
            TipoSeleccion__c = 'Servicio',
            TipoConcepto__c = 'CREDITO PREPAGO',
            Tipo__c = 'No aplica Prepago',
            TipoItem__c = 'Consumos de datos',
            TipoAjuste__c = 'Credito',
            TipoOperacionAjuste__c = 'CREDITO',
            vlocity_cmt__Amount__c = 4000,
            UnidadAjuste__c = 'Credito',
            AccountId = accountObj.Id,
            RecordTypeId = recordTypeId,
            OwnerId = (Id)UserInfo.getUserId(), //'0056C000000gQeF', //Federico
            Subject = 'Inconvenientes con cargos tasados y facturados',
            vlocity_cmt__ServiceId__c = assetObj.Id,
            AssetId = assetObj.Id,
            //LastModifiedById = '0056C000000gQeF',
            //CreatedDate = date.today(),
            Owner_Team__c = workTeamId//'Back_Office_GGCC'
        );

        insert caseObj;

        Case objCaso = [SELECT Id, Subject, vlocity_cmt__ServiceId__c, vlocity_cmt__Amount__c, TipoSeleccion__c FROM Case WHERE Subject = 'Inconvenientes con cargos tasados y facturados' AND vlocity_cmt__Amount__c = 4000 Limit 1];

        options.put('Amount', objCaso.vlocity_cmt__Amount__c);
        options.put('approvalProfile', '');
        options.put('TipoSeleccion', objCaso.TipoSeleccion__c);
        options.put('ServiceId', objCaso.vlocity_cmt__ServiceId__c);
        options.put('caseId', objCaso.Id);


        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        Map<String,Object> result = (Map<String,Object>) outMap.get('result');
    }
    @IsTest static void getAdjustmentsHelper_OtherCase(){
        String methodName = 'GetAdjustmentHistory';

        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();

         String jsonInputString = '{"body": {"cantidadItemsConsulta": 5,"cantidadMaxConsulta": 5,"cuenta":{"codigoAcceso": {"codSuscripcion": ""}},"infoDetalle": {},"referenciaItemPaginado": 0},"codSuscript": "20140527145410"}';
        String jsonString = '{"codigo":"DP-007001", "detalle":[{"campo":"118030306", "mensaje":"Account 13800010002 does not exist"}], "mensaje":"Error de datos"}';
        Map<String, Object> outMap2 = (Map<String, Object>)JSON.deserializeUntyped(jsonString);
        Map<String, Object> inputMap1 = (Map<String, Object>) JSON.deserializeUntyped(jsonInputString);
        outMap.put('IPResult', outMap2);
        System.debug('inputMap1 _ _ ' + inputMap1);
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap1, outMap, options);
        Test.stopTest();


        Map<String, Object> result = (Map<String, Object>)outMap.get('IPResult');
        Map<String, Object> resultFinish = (Map<String, Object>) result.get('listaDetalleAjuste');
        System.debug(' result_-' +  resultFinish);
        //System.assertEquals('DP-007001', resultFinish.get('codigo'));
    }
}