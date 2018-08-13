@isTest
public class ta_techCare_diagnosis_test {

    //Invocación a método dummy de obtención de info movil (Estado de antenas, etc)
    @isTest static void invokeObtenerInfoMovil_true(){
        String methodName = 'ObtenerInfoMovil';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> optOutMap = (Map<String, Object>) outMap.get('options');

        boolean statusFlag = (boolean)optOutMap.get('statusFlag');

    //    system.assert(true, statusFlag);
    }

    //Obtener Motivos de contacto
    @isTest static void invokePopulateMotives_getAllMotives(){
        String methodName = 'PopulateMotives';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        String idService = TestDataFactory.createService();

        TestDataFactory.createContactMotives(5, idService);

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, List<Map<String, String>>> selectListItems = 
            (Map<String, List<Map<String, String>>>) outMap.get('dependency');

        List<Map<String, String>> listItems = selectListItems.get(idService);

    //    system.assertNotEquals(0, listItems.size());
    }

//  Test de Método GetServiceAttributes (OK)
    @isTest static void invokeGetServiceAttributes_Ok(){
        String methodName = 'GetServiceAttributes';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Account accountTest = new Account();
        accountTest.Name = 'AccTest';
        insert accountTest;

        Asset assetTest = new Asset();

        assetTest.Name = 'Test Asset';
        assetTest.AccountId = accountTest.Id;
        //assetTest.Product2Id = '01t6C000000ZhAp';
        assetTest.vlocity_cmt__JSONAttribute__c = '{"TA Linea Basica":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu7wUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Standard Tecnico","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCiUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"NGM","value":"NGM"},{"id":2,"displayText":"TDM","value":"TDM"},{"id":3,"displayText":"GPON","value":"GPON"},{"id":4,"displayText":"MTA","value":"MTA"},{"id":5,"displayText":"2G","value":"2G"},{"id":6,"displayText":"3G","value":"3G"},{"id":7,"displayText":"4G","value":"4G"}],"default":[{"id":5,"displayText":"2G","value":"2G"}],"selectedItem":{"id":5,"displayText":"2G","value":"2G"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pogXUAQ","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"Tecnología","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tecnologia","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhChUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"Cobre","value":"Cobre"},{"id":2,"displayText":"Fibra","value":"Fibra"},{"id":3,"displayText":"MTA","value":"MTA"},{"id":4,"displayText":"GSMF","value":"GSMF"}],"default":[{"id":4,"displayText":"GSMF","value":"GSMF"}],"selectedItem":{"id":4,"displayText":"GSMF","value":"GSMF"}},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"ATT_000110","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCjUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Selected","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"ATTCAT_000200":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5IUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Download Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":10.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCeUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"10","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"10","value":10},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5NUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Velocidad","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCgUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"MB","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"MB","value":"MB"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu58UAA","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000010","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Upload Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCfUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000puAHUAY","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000120","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Real Download Speed","displaysequence__c":"300","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhTlUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"","value__c":"11776_1024","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"11776_1024","value":"11776_1024"},"$$AttributeDefinitionEnd$$":null}]}';
        assetTest.PurchaseDate = date.today();
        insert assetTest;

        options.put('AssetId', assetTest.Id);

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> result = (Map<String, Object>) outMap.get('ServiceAttributes');
        Map<String, Object> aux = (Map<String, Object>) result.get('Tecnologia');

    //    system.assertEquals(null, result.get('error'));
    //    system.assertEquals('11776_1024', result.get('Real Download Speed'));
    //    system.assertEquals('GSMF', aux.get('value'));
    }

//  Test de Método GetServiceAttributes con AssetId null (Error)
    @isTest static void invokeGetServiceAttributes_Exception1(){
        String methodName = 'GetServiceAttributes';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        options.put('AssetId','01t6C000000ZhAp');

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

    //    system.assertEquals('No se a encontrado el servicio seleccionado', (String) options.get('error'));
    }

//  Test de Método GetServiceAttributes con Asset sin Atributos (Error)
    @isTest static void invokeGetServiceAttributes_Exception2(){
        String methodName = 'GetServiceAttributes';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Account accountTest = new Account();
        accountTest.Name = 'AccTest';
        insert accountTest;

        Asset assetTest = new Asset();
        assetTest.Name = 'Test Asset';
        assetTest.AccountId = accountTest.Id;
        //assetTest.Product2Id = '01t6C000000ZhAp';
        assetTest.vlocity_cmt__JSONAttribute__c = '';
        assetTest.PurchaseDate = date.today();
            insert assetTest;

        options.put('AssetId', assetTest.Id);

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

    //    system.assertEquals(new Map<String, Object>(), outMap.get('ServiceAttributes'));
    }

    @isTest static void invokeGetServiceAttributes_Exception3(){
        String methodName = 'GetServiceAttributes';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        options.put('AssetId','');

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

    //    system.assertNotEquals(null, (String) options.get('error'));
    }

    @isTest static void invokeGetCpeIdentifierByModemAssetId_OK(){
        String methodName = 'GetCpeIdentifierByModemAssetId';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Account accountTest = new Account();
        accountTest.Name = 'AccTest';
        insert accountTest;

        Asset assetTest = new Asset();

        assetTest.Name = 'Test Asset';
        assetTest.AccountId = accountTest.Id;
        //assetTest.Product2Id = '01t6C000000ZhAp';
        assetTest.vlocity_cmt__JSONAttribute__c = '{"TA Linea Basica":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu7wUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Standard Tecnico","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCiUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"NGM","value":"NGM"},{"id":2,"displayText":"TDM","value":"TDM"},{"id":3,"displayText":"GPON","value":"GPON"},{"id":4,"displayText":"MTA","value":"MTA"},{"id":5,"displayText":"2G","value":"2G"},{"id":6,"displayText":"3G","value":"3G"},{"id":7,"displayText":"4G","value":"4G"}],"default":[{"id":5,"displayText":"2G","value":"2G"}],"selectedItem":{"id":5,"displayText":"2G","value":"2G"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pogXUAQ","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"Tecnología","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tecnologia","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhChUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"Cobre","value":"Cobre"},{"id":2,"displayText":"Fibra","value":"Fibra"},{"id":3,"displayText":"MTA","value":"MTA"},{"id":4,"displayText":"GSMF","value":"GSMF"}],"default":[{"id":4,"displayText":"GSMF","value":"GSMF"}],"selectedItem":{"id":4,"displayText":"GSMF","value":"GSMF"}},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZdgKQAS","attributeid__c":"a0G6C000000pobIUAQ","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"Serial Number","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Serial Number","displaysequence__c":"100","categorydisplaysequence__c":100,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000GNYeUAO","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"0003.0002","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","value":"0003.0002"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"ATT_000110","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCjUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Selected","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"ATTCAT_000200":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5IUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Download Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":10.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCeUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"10","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"10","value":10},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5NUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Velocidad","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCgUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"MB","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"MB","value":"MB"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu58UAA","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000010","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Upload Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCfUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000puAHUAY","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000120","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Real Download Speed","displaysequence__c":"300","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhTlUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"","value__c":"11776_1024","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"11776_1024","value":"11776_1024"},"$$AttributeDefinitionEnd$$":null}]}';
        assetTest.PurchaseDate = date.today();
        insert assetTest;

        options.put('ModemAssetId', assetTest.Id);

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        Map<String, Object> result = (Map<String, Object>) outMap.get('ModemAttributes');

    //    system.assertEquals(null, result.get('error'));
    //    system.assertEquals('0003.0002', result.get('Serial Number'));
    }

    @isTest static void invokeGetCpeIdentifierByModemAssetId_Exception1(){
        String methodName = 'GetCpeIdentifierByModemAssetId';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        options.put('ModemAssetId','01t6C000000ZhAp');

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

    //    system.assertEquals('No se a encontrado el servicio seleccionado', (String) options.get('error'));
    }

    @isTest static void invokeGetCpeIdentifierByModemAssetId_Exception2(){
        String methodName = 'GetCpeIdentifierByModemAssetId';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Account accountTest = new Account();
        accountTest.Name = 'AccTest';
        insert accountTest;

        Asset assetTest = new Asset();

        assetTest.Name = 'Test Asset';
        assetTest.AccountId = accountTest.Id;
        assetTest.PurchaseDate = date.today();
        insert assetTest;

        options.put('ModemAssetId', assetTest.Id);

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

    //    system.assertEquals(new Map<String, Object>(), outMap.get('ModemAttributes'));
    //    system.assertEquals(null, outMap.get('error'));
    }

    @isTest static void invokeGetCpeIdentifierByModemAssetId_Exception3(){
        String methodName = 'GetCpeIdentifierByModemAssetId';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        options.put('ModemAssetId','');

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

    //    system.assertNotEquals(null, (String) options.get('error'));
    }

    @isTest static void invokeUpdateOrderToOM(){
        String methodName = 'updateOrderToOM';

        Account accountTest = TestDataFactory.createAccounts(1)[0];
        Order orderTest = TestDataFactory.createOrders(1, accountTest)[0];
        Asset assetTest = TestDataFactory.createAssets(1 , accountTest)[0];

        list <OrderItem> orderItemsTest = TestDataFactory.createOrderItemsWithAsset(1, orderTest , assetTest );

        String orderFdoId = (String) orderTest.Id;

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        options.put('gestionOrder','Desconexión');
        options.put('actionOrder','Disconnect');
        options.put('subActionOrder','') ; 
        options.put('provisioningStatusOrder','Deleted'); 
        options.put('orderFdoId',orderFdoId); 
        options.put('assetIdList', orderItemsTest); 
        
        

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

       
    }

    
    @isTest static void invokeSendOrderToOM(){
        String methodName = 'sendOrderToOM';

        Account accountTest = TestDataFactory.createAccounts(1)[0];
        Order orderTest = TestDataFactory.createOrders(1, accountTest)[0];
       
        String orderFdoId = (String) orderTest.Id;

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        options.put('sendOrderFdoId',orderFdoId); 

        Test.startTest();
        diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
       
    }


    @isTest static void invokeGetNewGuid(){
        String methodName = 'getNewGuid';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_techCare_diagnosis diagn = new ta_techCare_diagnosis();

        Test.startTest();
            diagn.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();
       
    }
}