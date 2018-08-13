@isTest
public class ta_care_setAdjustment_test {
    
    @testSetup
    public static void setup(){
        
        Contact contactObj = new Contact(LastName = 'Pepe', Phone = '45454544545');
        insert contactObj;

        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business').getRecordTypeId();
        Account accountObj = new Account (
        vlocity_cmt__PrimaryContactId__c = contactObj.Id,
        Name='Cuenta Test', 
        RecordTypeId = businessRecordTypeId
        );
        insert accountObj;
        
        Product2 prod = new Product2(Name = 'Motorola X Play');
        insert prod;
        
        Asset assetTest = new Asset();
        assetTest.Name = 'Test Asset';
        assetTest.AccountId = accountObj.Id;
        assetTest.Product2Id = prod.Id;
        assetTest.vlocity_cmt__JSONAttribute__c = '{"TA Linea Basica":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu7wUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Standard Tecnico","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCiUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"NGM","value":"NGM"},{"id":2,"displayText":"TDM","value":"TDM"},{"id":3,"displayText":"GPON","value":"GPON"},{"id":4,"displayText":"MTA","value":"MTA"},{"id":5,"displayText":"2G","value":"2G"},{"id":6,"displayText":"3G","value":"3G"},{"id":7,"displayText":"4G","value":"4G"}],"default":[{"id":5,"displayText":"2G","value":"2G"}],"selectedItem":{"id":5,"displayText":"2G","value":"2G"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pogXUAQ","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"Tecnología","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tecnologia","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhChUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"Cobre","value":"Cobre"},{"id":2,"displayText":"Fibra","value":"Fibra"},{"id":3,"displayText":"MTA","value":"MTA"},{"id":4,"displayText":"GSMF","value":"GSMF"}],"default":[{"id":4,"displayText":"GSMF","value":"GSMF"}],"selectedItem":{"id":4,"displayText":"GSMF","value":"GSMF"}},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"ATT_000110","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCjUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Selected","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"ATTCAT_000200":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5IUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Download Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":10.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCeUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"10","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"10","value":10},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5NUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Velocidad","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCgUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"MB","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"MB","value":"MB"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu58UAA","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000010","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Upload Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCfUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000puAHUAY","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000120","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Real Download Speed","displaysequence__c":"300","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhTlUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"","value__c":"11776_1024","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"11776_1024","value":"11776_1024"},"$$AttributeDefinitionEnd$$":null}]}';
        assetTest.PurchaseDate = date.today();
        assetTest.MSISDN__c='156143243';
        assetTest.Subscription_Id__c = '345345345';
        insert assetTest;
    }
    
    @IsTest static void invoke_setAdjustment_empty(){
        Account acc = [SELECT Id FROM Account];
        Asset ass = [SELECT Id FROM Asset];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        Case caseObj = new Case(
        Status = 'En espera de ejecución',
        Origin = 'Personalizado',
        TipoSeleccion__c = 'Servicio',
        TipoConcepto__c = 'CREDITO PREPAGO',
        Tipo__c = 'No aplica Prepago',
        TipoItem__c = 'Consumos de datos',
        TipoAjuste__c = 'Credito',
        TipoOperacionAjuste__c = 'CREDITO',
        vlocity_cmt__Amount__c = 400,
        UnidadAjuste__c = 'Credito',
        AccountId = acc.Id,
        RecordTypeId = recordTypeId,
        CantidadAjuste__c = '01:03:00',
        vlocity_cmt__ServiceId__c = ass.Id
        );
        insert caseObj;

        List<Case> listCase = new List<Case>();
        listCase.add(caseObj);

        //ta_care_setAdjustment ta = new ta_care_setAdjustment();
        Test.startTest();
        ta_care_setAdjustment.setAdjustment(listCase);
        Test.stopTest();
    }
        
    @IsTest static void invoke_setAdjustment_empty2(){
        Account acc = [SELECT Id, AccountIntegrationId__c FROM Account];
        acc.AccountIntegrationId__c = '';
        update acc;
        
        Asset ass = [SELECT Id FROM Asset];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        Case caseObj = new Case(
        Status = 'En espera de ejecución',
        Origin = 'Personalizado',
        TipoConcepto__c = 'CREDITO PREPAGO',
        Tipo__c = 'No aplica Prepago',
        TipoItem__c = 'Consumos de datos',
        TipoAjuste__c = 'Credito',
        TipoOperacionAjuste__c = 'CREDITO',
        vlocity_cmt__Amount__c = 400,
        TipoSeleccion__c = 'Servicio',
        UnidadAjuste__c = 'VOZ',
        AccountId = acc.Id,
        RecordTypeId = recordTypeId,
        CantidadAjuste__c = '01:03:00',
        vlocity_cmt__ServiceId__c = ass.Id
        );
        insert caseObj;

        List<Case> listCase = new List<Case>();
        listCase.add(caseObj);

        Test.startTest();
        //Test with unidadajuste = 'VOZ'
        ta_care_setAdjustment.setAdjustment(listCase);            
        Test.stopTest();
    }
    
    @IsTest static void invoke_setAdjustment_empty3(){
        Account acc = [SELECT Id, AccountIntegrationId__c FROM Account];
        acc.AccountIntegrationId__c = acc.Id;
        update acc;
        
        Asset ass = [SELECT Id FROM Asset];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        Case caseObj = new Case(
        Status = 'En espera de ejecución',
        Origin = 'Personalizado',
        TipoConcepto__c = 'CREDITO POSPAGO',
        Tipo__c = 'No aplica Pospago',
        TipoItem__c = 'Renovacion cuota datos',
        TipoAjuste__c = 'NC/ND',
        TipoOperacionAjuste__c = 'CREDITO',
        vlocity_cmt__Amount__c = 400,
        TipoSeleccion__c = 'Cuenta',
        UnidadAjuste__c = 'Credito',
        AccountId = acc.Id,
        RecordTypeId = recordTypeId,
        CantidadAjuste__c = '01:03:00',
        vlocity_cmt__ServiceId__c = ass.Id
        );
        insert caseObj;

        List<Case> listCase = new List<Case>();
        listCase.add(caseObj);

        Test.startTest();
        //TipoSeleccion != 'Servicio'
        ta_care_setAdjustment.setAdjustment(listCase);
            
        Test.stopTest();
    }

    @IsTest static void invoke_setAdjustment_empty4(){
        Account acc = [SELECT Id, AccountIntegrationId__c FROM Account];
        acc.AccountIntegrationId__c = '';
        update acc;
        
        Asset ass = [SELECT Id FROM Asset];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        Case caseObj = new Case(
        Status = 'En espera de ejecución',
        Origin = 'Personalizado',
        TipoConcepto__c = 'CREDITO PREPAGO',
        Tipo__c = 'No aplica Prepago',
        TipoItem__c = 'Consumos de datos',
        TipoAjuste__c = 'Credito',
        TipoOperacionAjuste__c = 'CREDITO',
        vlocity_cmt__Amount__c = 400,
        TipoSeleccion__c = 'Servicio',
        UnidadAjuste__c = 'SMS',
        AccountId = acc.Id,
        RecordTypeId = recordTypeId,
        CantidadAjuste__c = '01:03:00',
        vlocity_cmt__ServiceId__c = ass.Id
        );
        insert caseObj;

        List<Case> listCase = new List<Case>();
        listCase.add(caseObj);

        Test.startTest();
        //Test with unidadajuste = 'VOZ'
        ta_care_setAdjustment.setAdjustment(listCase);            
        Test.stopTest();
    }

    @IsTest static void invoke_setAdjustment_empty5(){
        Account acc = [SELECT Id, AccountIntegrationId__c FROM Account];
        acc.AccountIntegrationId__c = '';
        update acc;
        
        Asset ass = [SELECT Id FROM Asset];
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Diagnosis').getRecordTypeId();
        Case caseObj = new Case(
        Status = 'En espera de ejecución',
        Origin = 'Personalizado',
        TipoConcepto__c = 'CREDITO PREPAGO',
        Tipo__c = 'No aplica Prepago',
        TipoItem__c = 'Consumos de datos',
        TipoAjuste__c = 'Credito',
        TipoOperacionAjuste__c = 'CREDITO',
        vlocity_cmt__Amount__c = 400,
        TipoSeleccion__c = 'Servicio',
        UnidadAjuste__c = 'Datos(Mb)',
        AccountId = acc.Id,
        RecordTypeId = recordTypeId,
        CantidadAjuste__c = '100',
        vlocity_cmt__ServiceId__c = ass.Id
        );
        insert caseObj;

        List<Case> listCase = new List<Case>();
        listCase.add(caseObj);

        Test.startTest();
        //Test with unidadajuste = 'VOZ'
        ta_care_setAdjustment.setAdjustment(listCase);            
        Test.stopTest();
    }
}