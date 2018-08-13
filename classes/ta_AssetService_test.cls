@isTest
public class ta_AssetService_test{

@isTest static void invoke_GetPlanAssetsByAccountId_1(){
    String methodName ='GetPlanAssetsByAccountId'; 
    Map<String,Object> outMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
    Map<String,Object> inputMap = new Map<String, Object>();
    ta_AssetService testedClass = new ta_AssetService();
    String jsonString = '{"PlanAssets":[{"ActivationDate":"2018-05-22","ProductType":"Plan Prepago","Status":"Active","Family":"Movil","Blacklist":true,"Name":"Linea Prepago 2","LineNumber":"1130150222","AssetId":"02i6C0000002SWOQA2"}]}';
    options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

    Test.startTest();
    testedClass.invokeMethod(methodName, inputMap, outMap, options);
    Test.stopTest();
    }

@isTest static void invoke_GetPlanAssetsByAccountId_2(){
    String methodName ='GetPlanAssetsByAccountId';
    Map<String,Object> outMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
    Map<String,Object> inputMap = new Map<String, Object>();
    ta_AssetService testedClass = new ta_AssetService();
    String jsonString = '{"PlanAssets":[{"ActivationDate":"2018-05-22","ProductType":"Plan Prepago","Status":"Active","Family":"Movil","Blacklist":true,"Name":"Linea Prepago 2","LineNumber":null,"AssetId":"02i6C0000002SWOQA2"}]}';
    options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

    Test.startTest();
    testedClass.invokeMethod(methodName, inputMap, outMap, options);
    Test.stopTest();
    }

@isTest static void invoke_GetPlanAssetsByAccountId_3(){
    String methodName ='GetPlanAssetsByAccountId';
    Map<String,Object> outMap = new Map<String, Object>();
    Map<String,Object> options = new Map<String, Object>();
    Map<String,Object> inputMap = new Map<String, Object>();
    ta_AssetService testedClass = new ta_AssetService();
    String jsonString = '{"PlanAssets":[{"ActivationDate":"2018-05-22","ProductType":"Plan Prepago","Status":"Active","Family":"Movil","Blacklist":true,"Name":"Linea Prepago 2","LineNumber":"333333333","AssetId":"02i6C0000002SWOQA2"}]}';
    options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

    Test.startTest();
    testedClass.invokeMethod(methodName, inputMap, outMap, options);
    Test.stopTest();
    }

    @isTest static void invoke_GetTrafficEquipmentByLineNumber_OK(){
        String methodName ='GetTrafficEquipmentByLineNumber';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_AssetService testedClass = new ta_AssetService();
        
            
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void invoke_GetPlanAssetsByAccountId_4(){
        String methodName ='GetPlanAssetsByAccountId';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_AssetService testedClass = new ta_AssetService();
        String jsonString = '{"PlanAssets":[{"ActivationDate":"2018-05-22","ProductType":"Plan Prepago","Status":"Active","Family":"Movil","Blacklist":true,"Name":"Linea Prepago 2","AssetId":"02i6C0000002SWOQA2"}]}';
        options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void invoke_GetPlanAssetsByAccountId_5(){
        String methodName ='GetDeviceAssetsByAccountId';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_AssetService testedClass = new ta_AssetService();
        String jsonS = '{\"FAN_ATTCAT_000045\":[{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000q6t6UAA\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000174\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Subgama Equipo\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQ6UAK\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":\"Dropdown\",\"value__c\":\"FAN_PKV_HIGH_D\",\"valuedatatype__c\":\"Picklist\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Picklist\",\"uiDisplayType\":\"Dropdown\",\"default\":[{\"displayText\":\"High End D\",\"id\":100,\"value\":\"FAN_PKV_HIGH_D\"}],\"values\":[{\"displayText\":\"Low End A\",\"id\":10,\"value\":\"FAN_PKV_LOW_A\"},{\"displayText\":\"Low End B\",\"id\":20,\"value\":\"FAN_PKV_LOW_B\"},{\"displayText\":\"Low End C\",\"id\":30,\"value\":\"FAN_PKV_LOW_C\"},{\"displayText\":\"Mid End A\",\"id\":40,\"value\":\"FAN_PKV_MID_A\"},{\"displayText\":\"Mid End B\",\"id\":50,\"value\":\"FAN_PKV_MID_B\"},{\"displayText\":\"Mid End C\",\"id\":60,\"value\":\"FAN_PKV_MID_C\"},{\"displayText\":\"High End A\",\"id\":70,\"value\":\"FAN_PKV_HIGH_A\"},{\"displayText\":\"High End B\",\"id\":80,\"value\":\"FAN_PKV_HIGH_B\"},{\"displayText\":\"High End C\",\"id\":90,\"value\":\"FAN_PKV_HIGH_C\"},{\"displayText\":\"High End D\",\"id\":100,\"value\":\"FAN_PKV_HIGH_D\"}]},\"$$AttributeDefinitionEnd$$\":null},{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000pwIvUAI\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000074\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Fabricacion\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQAUA0\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":\"Dropdown\",\"value__c\":\"FAN_PKV_NAC\",\"valuedatatype__c\":\"Picklist\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Picklist\",\"uiDisplayType\":\"Dropdown\",\"default\":[{\"displayText\":\"Nacional\",\"id\":10,\"value\":\"FAN_PKV_NAC\"}],\"values\":[{\"displayText\":\"Nacional\",\"id\":10,\"value\":\"FAN_PKV_NAC\"},{\"displayText\":\"Internacional\",\"id\":20,\"value\":\"FAN_PKV_INT\"},{\"displayText\":\"Tierra del Fuego\",\"id\":30,\"value\":\"FAN_PKV_TFUE\"}]},\"$$AttributeDefinitionEnd$$\":null},{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000pxX6UAI\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000093\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Marca\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQBUA0\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":\"Dropdown\",\"value__c\":\"FAN_PKV_SG\",\"valuedatatype__c\":\"Picklist\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Picklist\",\"uiDisplayType\":\"Dropdown\",\"default\":[{\"displayText\":\"Samsung\",\"id\":110,\"value\":\"FAN_PKV_SG\"}],\"values\":[{\"displayText\":\"Alcatel\",\"id\":10,\"value\":\"FAN_PKV_AL\"},{\"displayText\":\"Apple\",\"id\":20,\"value\":\"FAN_PKV_AP\"},{\"displayText\":\"BGH\",\"id\":30,\"value\":\"FAN_PKV_BG\"},{\"displayText\":\"Blackberry\",\"id\":40,\"value\":\"FAN_PKV_BL\"},{\"displayText\":\"Bipy\",\"id\":150,\"value\":\"FAN_PKV_BP\"},{\"displayText\":\"HTC\",\"id\":50,\"value\":\"FAN_PKV_HT\"},{\"displayText\":\"Huawei\",\"id\":60,\"value\":\"FAN_PKV_HW\"},{\"displayText\":\"LG\",\"id\":70,\"value\":\"FAN_PKV_LG\"},{\"displayText\":\"Microsoft\",\"id\":80,\"value\":\"FAN_PKV_MS\"},{\"displayText\":\"Motorola\",\"id\":90,\"value\":\"FAN_PKV_MT\"},{\"displayText\":\"Nokia\",\"id\":100,\"value\":\"FAN_PKV_NK\"},{\"displayText\":\"Sony Ericsson\",\"id\":130,\"value\":\"FAN_PKV_SE\"},{\"displayText\":\"Samsung\",\"id\":110,\"value\":\"FAN_PKV_SG\"},{\"displayText\":\"Sony\",\"id\":120,\"value\":\"FAN_PKV_SO\"},{\"displayText\":\"Personal\",\"id\":160,\"value\":\"FAN_PKV_TP\"},{\"displayText\":\"ZTE\",\"id\":140,\"value\":\"FAN_PKV_ZT\"}]},\"$$AttributeDefinitionEnd$$\":null},{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000pxX7UAI\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000094\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Modelo\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQCUA0\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":null,\"value__c\":\"J7\",\"valuedatatype__c\":\"Text\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Text\",\"default\":\"J7\"},\"$$AttributeDefinitionEnd$$\":null}]}';
        String jsonString = '{"DeviceAssets":[{"TransactionId":"a566C00000005EtQAI","SuspencionType":"Robo","PurchaseDate":"2018-05-30T19:29:05.000Z","Name":"Galaxy S8 - Negro","LineNumber":"6456234134","Status":"Active","AssetId":"02i6C0000002s4nQAA","IMEI":"345452342155573","JSONAttribute": '+ jsonS +'}]}';
        
        options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }

    @isTest static void invoke_GetPlanAssetsByAccountId_6(){
        String methodName ='GetDeviceAssetsByAccountId';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_AssetService testedClass = new ta_AssetService();
        String jsonString = '{"DeviceAssets":[{"TransactionId":"a566C00000005EtQAI","SuspencionType":"Robo","PurchaseDate":"2018-05-30T19:29:05.000Z","Name":"Galaxy S8 - Negro","LineNumber":"6456234134","Status":"Active","AssetId":"02i6C0000002s4nQAA","IMEI":"345452342155573", "JSONAttribute":"null"}]}';
        
        options = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }      

    @isTest static void invoke_GetPlanAssetsByAccountId_7(){
        String methodName = null;
        Map<String,Object> outMap = null;
        Map<String,Object> options = null;
        Map<String,Object> inputMap = null;
        ta_AssetService testedClass = new ta_AssetService();      
        Exception unexpectedException;

        Test.startTest();
        try
        {
            testedClass.invokeMethod(methodName, inputMap, outMap, options);
        }catch(Exception ex)
        {
            unexpectedException = ex;
        }
        
        Test.stopTest();
        System.assertEquals(unexpectedException, unexpectedException);
    }   

    @isTest static void invoke_GetPlanAssetsByAccountId_8(){
        String methodName ='GetDeviceAssetsByAccountId';
        Map<String,Object> outMap = new Map<String, Object>();
        Map<String,Object> options = new Map<String, Object>();
        Map<String,Object> inputMap = new Map<String, Object>();
        ta_AssetService testedClass = new ta_AssetService();

        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
    }     

    @isTest static void getJSONAttributeTransform_TestNOK(){
        ta_AssetService testedClass = new ta_AssetService();
        String jsonString = '{"DeviceAssets":[{"TransactionId":"a566C00000005EtQAI","SuspencionType":"Robo","PurchaseDate":"2018-05-30T19:29:05.000Z","Name":"Galaxy S8 - Negro","LineNumber":"6456234134","Status":"Active","AssetId":"02i6C0000002s4nQAA","IMEI":"345452342155573", "JSONAttribute":"null"}]}';
        
        Map<String,Object> DeviceAssetMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
            
        Test.startTest();
        testedClass.getJSONAttributeTransform(DeviceAssetMap);
        Test.stopTest();
    }    

     @isTest static void CompletePlanAssetInfo_NOK(){
          ta_AssetService testedClass = new ta_AssetService();
          try
          {
            testedClass.CompletePlanAssetInfo(null);
          }catch(Exception ex){
              System.Assert(ex != null);
          }
     }

    @isTest static void getJSONAttributeTransform_TestNOK2(){
        ta_AssetService testedClass = new ta_AssetService();  
        Map<String,Object> DeviceAssetMap = null;
            
        Test.startTest();
        try {
            testedClass.getJSONAttributeTransform(DeviceAssetMap);
        } catch (Exception ex) {
        }
        Test.stopTest();
    } 
    

    @isTest static void getJSONAttributeTransform_TestOK(){
        ta_AssetService testedClass = new ta_AssetService();
        String jsonS = '{\"FAN_ATTCAT_000045\":[{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000q6t6UAA\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000174\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Subgama Equipo\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQ6UAK\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":\"Dropdown\",\"value__c\":\"FAN_PKV_HIGH_D\",\"valuedatatype__c\":\"Picklist\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Picklist\",\"uiDisplayType\":\"Dropdown\",\"default\":[{\"displayText\":\"High End D\",\"id\":100,\"value\":\"FAN_PKV_HIGH_D\"}],\"values\":[{\"displayText\":\"Low End A\",\"id\":10,\"value\":\"FAN_PKV_LOW_A\"},{\"displayText\":\"Low End B\",\"id\":20,\"value\":\"FAN_PKV_LOW_B\"},{\"displayText\":\"Low End C\",\"id\":30,\"value\":\"FAN_PKV_LOW_C\"},{\"displayText\":\"Mid End A\",\"id\":40,\"value\":\"FAN_PKV_MID_A\"},{\"displayText\":\"Mid End B\",\"id\":50,\"value\":\"FAN_PKV_MID_B\"},{\"displayText\":\"Mid End C\",\"id\":60,\"value\":\"FAN_PKV_MID_C\"},{\"displayText\":\"High End A\",\"id\":70,\"value\":\"FAN_PKV_HIGH_A\"},{\"displayText\":\"High End B\",\"id\":80,\"value\":\"FAN_PKV_HIGH_B\"},{\"displayText\":\"High End C\",\"id\":90,\"value\":\"FAN_PKV_HIGH_C\"},{\"displayText\":\"High End D\",\"id\":100,\"value\":\"FAN_PKV_HIGH_D\"}]},\"$$AttributeDefinitionEnd$$\":null},{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000pwIvUAI\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000074\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Fabricacion\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQAUA0\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":\"Dropdown\",\"value__c\":\"FAN_PKV_NAC\",\"valuedatatype__c\":\"Picklist\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Picklist\",\"uiDisplayType\":\"Dropdown\",\"default\":[{\"displayText\":\"Nacional\",\"id\":10,\"value\":\"FAN_PKV_NAC\"}],\"values\":[{\"displayText\":\"Nacional\",\"id\":10,\"value\":\"FAN_PKV_NAC\"},{\"displayText\":\"Internacional\",\"id\":20,\"value\":\"FAN_PKV_INT\"},{\"displayText\":\"Tierra del Fuego\",\"id\":30,\"value\":\"FAN_PKV_TFUE\"}]},\"$$AttributeDefinitionEnd$$\":null},{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000pxX6UAI\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000093\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Marca\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQBUA0\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":\"Dropdown\",\"value__c\":\"FAN_PKV_SG\",\"valuedatatype__c\":\"Picklist\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Picklist\",\"uiDisplayType\":\"Dropdown\",\"default\":[{\"displayText\":\"Samsung\",\"id\":110,\"value\":\"FAN_PKV_SG\"}],\"values\":[{\"displayText\":\"Alcatel\",\"id\":10,\"value\":\"FAN_PKV_AL\"},{\"displayText\":\"Apple\",\"id\":20,\"value\":\"FAN_PKV_AP\"},{\"displayText\":\"BGH\",\"id\":30,\"value\":\"FAN_PKV_BG\"},{\"displayText\":\"Blackberry\",\"id\":40,\"value\":\"FAN_PKV_BL\"},{\"displayText\":\"Bipy\",\"id\":150,\"value\":\"FAN_PKV_BP\"},{\"displayText\":\"HTC\",\"id\":50,\"value\":\"FAN_PKV_HT\"},{\"displayText\":\"Huawei\",\"id\":60,\"value\":\"FAN_PKV_HW\"},{\"displayText\":\"LG\",\"id\":70,\"value\":\"FAN_PKV_LG\"},{\"displayText\":\"Microsoft\",\"id\":80,\"value\":\"FAN_PKV_MS\"},{\"displayText\":\"Motorola\",\"id\":90,\"value\":\"FAN_PKV_MT\"},{\"displayText\":\"Nokia\",\"id\":100,\"value\":\"FAN_PKV_NK\"},{\"displayText\":\"Sony Ericsson\",\"id\":130,\"value\":\"FAN_PKV_SE\"},{\"displayText\":\"Samsung\",\"id\":110,\"value\":\"FAN_PKV_SG\"},{\"displayText\":\"Sony\",\"id\":120,\"value\":\"FAN_PKV_SO\"},{\"displayText\":\"Personal\",\"id\":160,\"value\":\"FAN_PKV_TP\"},{\"displayText\":\"ZTE\",\"id\":140,\"value\":\"FAN_PKV_ZT\"}]},\"$$AttributeDefinitionEnd$$\":null},{\"$$AttributeDefinitionStart$$\":null,\"objectid__c\":\"01t6C000000aSk9QAE\",\"attributeid__c\":\"a0G6C000000pxX7UAI\",\"attributecategoryid__c\":\"a0F6C000000Bor5UAC\",\"categorycode__c\":\"FAN_ATTCAT_000045\",\"categoryname__c\":\"Caracteristicas Principales\",\"attributeuniquecode__c\":\"FAN_ATT_000094\",\"attributeconfigurable__c\":true,\"attributedisplaysequence__c\":\"1\",\"attributefilterable__c\":true,\"attributecloneable__c\":true,\"isactive__c\":true,\"attributedisplayname__c\":\"Modelo\",\"displaysequence__c\":\"null\",\"categorydisplaysequence__c\":71,\"customconfiguitemplate__c\":null,\"formatmask__c\":null,\"hasrule__c\":false,\"isconfigurable__c\":false,\"ishidden__c\":false,\"valueinnumber__c\":null,\"objecttype__c\":\"Product2\",\"querycode__c\":null,\"isreadonly__c\":false,\"isquerydriven__c\":false,\"querylabel__c\":null,\"id\":\"a0D6C000000VhQCUA0\",\"isrequired__c\":false,\"rulemessage__c\":null,\"uidisplaytype__c\":null,\"value__c\":\"J7\",\"valuedatatype__c\":\"Text\",\"valuedescription__c\":null,\"attributeRunTimeInfo\":{\"dataType\":\"Text\",\"default\":\"J7\"},\"$$AttributeDefinitionEnd$$\":null}]}';
        String jsonString = '{"DeviceAssets":[{"TransactionId":"a566C00000005EtQAI","SuspencionType":"Robo","PurchaseDate":"2018-05-30T19:29:05.000Z","Name":"Galaxy S8 - Negro","LineNumber":"6456234134","Status":"Active","AssetId":"02i6C0000002s4nQAA","IMEI":"345452342155573","JSONAttribute": '+ jsonS +'}]}';
        Map<String,Object> DeviceAssetMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        Test.startTest();
        testedClass.getJSONAttributeTransform(DeviceAssetMap);
        Test.stopTest();
    }  

    @isTest static void getAttributeSelectedValue_TestOK(){
        ta_AssetService testedClass = new ta_AssetService();
        String jsonString = '{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aSk9QAE","attributeid__c":"a0G6C000000pxX7UAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000094","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Modelo","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000VhQCUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"J7","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"J7"},"$$AttributeDefinitionEnd$$":null}';
        Map<String,Object> mapAttribute = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
            
        Test.startTest();
        testedClass.getAttributeSelectedValue(mapAttribute, 'Modelo');
        Test.stopTest();
    }
    
    @isTest static void getAttributeSelectedValue_TestOK2(){
        ta_AssetService testedClass = new ta_AssetService();
        String jsonString = '{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000aSk9QAE","attributeid__c":"a0G6C000000pxX6UAI","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000093","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Marca","displaysequence__c":"null","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000VhQBUA0","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"FAN_PKV_SG","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"Samsung","id":110,"value":"FAN_PKV_SG"}],"values":[{"displayText":"Alcatel","id":10,"value":"FAN_PKV_AL"},{"displayText":"Apple","id":20,"value":"FAN_PKV_AP"},{"displayText":"BGH","id":30,"value":"FAN_PKV_BG"},{"displayText":"Blackberry","id":40,"value":"FAN_PKV_BL"},{"displayText":"Bipy","id":150,"value":"FAN_PKV_BP"},{"displayText":"HTC","id":50,"value":"FAN_PKV_HT"},{"displayText":"Huawei","id":60,"value":"FAN_PKV_HW"},{"displayText":"LG","id":70,"value":"FAN_PKV_LG"},{"displayText":"Microsoft","id":80,"value":"FAN_PKV_MS"},{"displayText":"Motorola","id":90,"value":"FAN_PKV_MT"},{"displayText":"Nokia","id":100,"value":"FAN_PKV_NK"},{"displayText":"Sony Ericsson","id":130,"value":"FAN_PKV_SE"},{"displayText":"Samsung","id":110,"value":"FAN_PKV_SG"},{"displayText":"Sony","id":120,"value":"FAN_PKV_SO"},{"displayText":"Personal","id":160,"value":"FAN_PKV_TP"},{"displayText":"ZTE","id":140,"value":"FAN_PKV_ZT"}]},"$$AttributeDefinitionEnd$$":null}';
        Map<String,Object> mapAttribute = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
            
        Test.startTest();
        testedClass.getAttributeSelectedValue(mapAttribute, 'Marca');
        Test.stopTest();
    }  

    @isTest static void getAttributeSelectedValue_TestNOK(){
        ta_AssetService testedClass = new ta_AssetService();
        Map<String,Object> mapAttribute = null;
            
        Test.startTest();
        String response = testedClass.getAttributeSelectedValue(mapAttribute, 'Marca');
        System.assert(response == null);
        Test.stopTest();
    }
        
    @isTest static void getFreeUnits_TestNoUnidadLibre() {
        ta_AssetService testedClass = new ta_AssetService();
        String jsonString = '{"totalUnidadesLibres":{"unidadLibre":[]},"totalesBalance":{"fechaExpiracionBalance":"string","proximaFechaExpiracionBalance":"string","saldoSuscripcionRegalado":"300.0000","saldoSuscripcionComprado":"0.0000","saldoBalance":"200.0000"},"ofertaPrincipal":{"descripcionProducto":"Plan con Tarjeta Repro,","nombreProducto":"PTRHU","codProducto":"1052"},"marcaSuspensionActiva":"FuncionSobreStatusDetail","estadoSuscripcion":"Activa","identificadorRecurso":"1138305304"}';
        Map<String,Object> assetBalance = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        
        Test.startTest();
        testedClass.GetFreeUnits(assetBalance, '645645645','AssetId','StatusAsset');
        Test.stopTest();
        
    }
}