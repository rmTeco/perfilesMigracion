@IsTest
public class ta_care_queryAdjustmentsHelper_test {
    @IsTest static void invoke_queryAdjustmentHelper_OK(){
        String methodName = 'GetAdjustmentHistory';
        Map<String,Object> outputMap = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        
        String jsonInputString = '{"body":{"cantidadItemsConsulta":0,"cantidadMaxConsulta":5,"cuenta":{"codigoAcceso":{"codSuscripcion":"54726279-0157-44b9-94e8-484a8a440966"}},"fechaDesde":"2018-07-01 00:00:00","fechaHasta":"2018-08-01 00:00:00","infoDetalle":{},"referenciaItemPaginado":0}}';
        String body ='{"cantidadMaxConsulta":5,"referenciaItemPaginado":0,"cantidadItemsConsulta":18,"listaDetalleAjuste":[{"listaDatosAdicionales":[{"valorParametro":"11120000","nombreParametro":"FREE_UNIT_TYPE_ID"},{"valorParametro":"100000000000125875","nombreParametro":"OWNERID"},{"valorParametro":"130","nombreParametro":"C_LOGINSYSTEMCODE"},{"valorParametro":"S","nombreParametro":"OWNERTYPE"},{"valorParametro":"1","nombreParametro":"ADJOPERTYPE"},{"valorParametro":"null","nombreParametro":"POINT_SALE_ID"}],"codMotivoAjuste":"","listaInfoAjusteUnidadesLibres":[{"fechaAjusteVigenciaHasta":"","fechaAjusteVigenciaDesde":"","codUnidadDeMedida":"SEGUNDOS","montoAjuste":"0.0000","tipoAjuste":"CREDITO","codUsoUnidadesLibres":"C_FU_VMO_NACIONAL"}],"codAjuste":"CBSAR218327","codCanal":"3","identificadorRecurso":"3574409239","codSuscripcion":"54726279-0157-44b9-94e8-484a8a440966","codCuentaTasacion":"9983a3c0-f0dc-47dd-ad3c-cf97e740ec89","fechaAjuste":"2018-07-31 15:47:51"},{"listaDatosAdicionales":[{"valorParametro":"11120000","nombreParametro":"FREE_UNIT_TYPE_ID"},{"valorParametro":"100000000000125875","nombreParametro":"OWNERID"},{"valorParametro":"130","nombreParametro":"C_LOGINSYSTEMCODE"},{"valorParametro":"S","nombreParametro":"OWNERTYPE"},{"valorParametro":"1","nombreParametro":"ADJOPERTYPE"},{"valorParametro":"null","nombreParametro":"POINT_SALE_ID"}],"codMotivoAjuste":"","listaInfoAjusteUnidadesLibres":[{"fechaAjusteVigenciaHasta":"","fechaAjusteVigenciaDesde":"","codUnidadDeMedida":"SEGUNDOS","montoAjuste":"0.0000","tipoAjuste":"CREDITO","codUsoUnidadesLibres":"C_FU_VMO_NACIONAL"}],"codAjuste":"CBSAR218303","codCanal":"3","identificadorRecurso":"3574409239","codSuscripcion":"54726279-0157-44b9-94e8-484a8a440966","codCuentaTasacion":"9983a3c0-f0dc-47dd-ad3c-cf97e740ec89","fechaAjuste":"2018-07-31 15:11:31"},{"listaDatosAdicionales":[{"valorParametro":"11120000","nombreParametro":"FREE_UNIT_TYPE_ID"},{"valorParametro":"100000000000125875","nombreParametro":"OWNERID"},{"valorParametro":"130","nombreParametro":"C_LOGINSYSTEMCODE"},{"valorParametro":"S","nombreParametro":"OWNERTYPE"},{"valorParametro":"1","nombreParametro":"ADJOPERTYPE"},{"valorParametro":"null","nombreParametro":"POINT_SALE_ID"}],"codMotivoAjuste":"","listaInfoAjusteUnidadesLibres":[{"fechaAjusteVigenciaHasta":"","fechaAjusteVigenciaDesde":"","codUnidadDeMedida":"SEGUNDOS","montoAjuste":"0.0000","tipoAjuste":"CREDITO","codUsoUnidadesLibres":"C_FU_VMO_NACIONAL"}],"codAjuste":"CBSAR218301","codCanal":"3","identificadorRecurso":"3574409239","codSuscripcion":"54726279-0157-44b9-94e8-484a8a440966","codCuentaTasacion":"9983a3c0-f0dc-47dd-ad3c-cf97e740ec89","fechaAjuste":"2018-07-31 15:10:01"},{"listaDatosAdicionales":[{"valorParametro":"100000000000125875","nombreParametro":"OWNERID"},{"valorParametro":"130","nombreParametro":"C_LOGINSYSTEMCODE"},{"valorParametro":"S","nombreParametro":"OWNERTYPE"},{"valorParametro":"1","nombreParametro":"ADJOPERTYPE"},{"valorParametro":"null","nombreParametro":"POINT_SALE_ID"}],"codMotivoAjuste":"Ajuste por error en la asignacion de Credito","listaAjusteBalanceInfo":[{"codMoneda":"ARS","montoAjuste":"10.0000","tipoAjuste":"CREDITO","codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"701000000000074310"}],"codAjuste":"12559","codCanal":"3","identificadorRecurso":"3574409239","codSuscripcion":"54726279-0157-44b9-94e8-484a8a440966","codCuentaTasacion":"9983a3c0-f0dc-47dd-ad3c-cf97e740ec89","fechaAjuste":"2018-07-27 12:14:09"},{"listaDatosAdicionales":[{"valorParametro":"100000000000125875","nombreParametro":"OWNERID"},{"valorParametro":"130","nombreParametro":"C_LOGINSYSTEMCODE"},{"valorParametro":"S","nombreParametro":"OWNERTYPE"},{"valorParametro":"1","nombreParametro":"ADJOPERTYPE"},{"valorParametro":"null","nombreParametro":"POINT_SALE_ID"}],"codMotivoAjuste":"Ajuste por error en la asignacion de Credito","listaAjusteBalanceInfo":[{"codMoneda":"ARS","montoAjuste":"10.0000","tipoAjuste":"CREDITO","codTipoBalance":"C_MAIN_ACCOUNT","codBalance":"701000000000074310"}],"codAjuste":"12a9","codCanal":"3","identificadorRecurso":"3574409239","codSuscripcion":"54726279-0157-44b9-94e8-484a8a440966","codCuentaTasacion":"9983a3c0-f0dc-47dd-ad3c-cf97e740ec89","fechaAjuste":"2018-07-27 12:01:58"}]}';
        Map<String, Object> responseNode = (Map<String, Object>) JSON.deserializeUntyped(body);
        Map<String, Object> inputMapN1 = (Map<String, Object>) JSON.deserializeUntyped(jsonInputString);
        outputMap.put('IPResult', responseNode);
        System.debug('inputMapN1 __'+ inputMapN1 );
        ta_care_queryAdjustmentsHelper testedClass = new ta_care_queryAdjustmentsHelper();
        
        getAdjustments_CBS__c setting = new getAdjustments_CBS__c();
        setting.Name = '5';
        setting.ServiceCode__c = 5;
        setting.ServiceMessage__c = '5';
        insert setting;

        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMapN1, outputMap, options);
        Test.stopTest();
        
        Map<String,Object> IPRes = (Map<String,Object>) outputMap.get('IPResult');
        List<Object> listaDetalleAjuste = (List<Object>) IPRes.get('listaDetalleAjuste');
        Map<String,Object> recordMap = (Map<String,Object>) listaDetalleAjuste[0];
        
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
        
        String profileName = 'FAN - Gerente 1ra Dep';
        Id profileId = [SELECT Id FROM Profile WHERE name =: profileName].Id; 
        system.debug('Id Perfil: '+ profileId);
        
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
        
        
        String profileName = 'FAN - Gerente 1ra Dep';
        Id profileId = [SELECT Id FROM Profile WHERE name =: profileName].Id; 
        system.debug('Id Perfil: '+ profileId);
        
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
}