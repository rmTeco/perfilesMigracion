@IsTest
public class ta_integration_test{    
    
    @IsTest static void getIPSessionInformation_CCIP_test1(){
        String methodName = 'getIPSessionInformation_CCIP';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('nroLinea','3743461848');
        string args = '{"nroLinea":"3743461848"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options', nroLin);
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
        Map<String,Object> result = (Map<String,Object>)outMap.get('listaSesion');
        system.assertEquals(result.get('codPortalCautivo'),'102');
        
    }
        @IsTest static void getIPSessionInformation_CCIP_test2(){
        String methodName = 'getIPSessionInformation_CCIP';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('nroLinea','1112121212');
        string args = '{"nroLinea":"1112121212"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options', nroLin);
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
        Map<String,Object> result = (Map<String,Object>)outMap.get('listaSesion');
        system.assertEquals(result.get('codPortalCautivo'),'101');
        
    }
        @IsTest static void getIPSessionInformation_CCIP_test3(){
        String methodName = 'getIPSessionInformation_CCIP';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        string args = '{"nroLinea":"1113131313"}';
        options.put('nroLinea','1113131313');
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options', nroLin);
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
        Map<String,Object> result = (Map<String,Object>)outMap.get('listaSesion');
        system.assertEquals(result.get('codPortalCautivo'),'100');
        
    }
    @IsTest static void getIPSessionInformation_CCIP_test4(){
        String methodName = 'getIPSessionInformation_CCIP';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        options.put('nroLinea','11131313');
        string args = '{"nroLinea":"11131313"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options', nroLin);
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
        Map<String,Object> result = (Map<String,Object>)outMap.get('listaSesion');
        system.assertEquals(result.get('codPortalCautivo'),'0');
        
    }
        @IsTest static void MockS389_test(){
        String methodName = 'MockS389';
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('LineNumber','1164646468');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockS241_test(){
        String methodName = 'MockS241';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('nroLinea','1164646468');
        string args = '{"nroLinea":"1164646468"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options', nroLin);
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockDRMuletoAvailable_test(){
        String methodName = 'MockDRMuletoAvailable';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockGetPortStatus_test(){
        String methodName = 'MockGetPortStatus';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('nroLinea','1164646468');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockGetSessionStatus_test(){
        String methodName = 'MockGetSessionStatus';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('nroLinea','1164646462');
        options.put('flagSession','1');
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockS245_test1(){
        String methodName = 'MockS245';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        string args = '{"nroLinea":"1164646464","codServicio":"11","TxId":"1"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options',nroLin);
        options.put('dias','1');

        options.put('TxId','1');
        options.put('nroLinea','1164646464');
        options.put('codServicio','1');
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockS245_test2(){
        String methodName = 'MockS245';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        string args = '{"nroLinea":"1164646464","codServicio":"11","TxId":"1"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options',nroLin);
        options.put('TxId','1');
        options.put('nroLinea','1164646464');
        options.put('codServicio','1');
        options.put('dias','10');
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockS245_test3(){
        String methodName = 'MockS245';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        string args = '{"nroLinea":"1164646469","codServicio":"11","TxId":"1"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options',nroLin);
        options.put('TxId','1');
        options.put('nroLinea','1164646469');
        options.put('codServicio','11');
        options.put('dias','1');
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockS245_test4(){
        String methodName = 'MockS245';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        string args = '{"nroLinea":"1164646469","codServicio":"11","TxId":"1"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options',nroLin);
        options.put('TxId','1');
        options.put('nroLinea','1164646469');
        options.put('codServicio','11');
        options.put('dias','10');
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockGetServiceLatency_test(){
        String methodName = 'MockGetServiceLatency';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        /*
        string args = '{"nroLinea":"1164646468"}';
        Map<String, Object> nroLin = (Map<String, Object>)JSON.deserializeUntyped(args);
        inputMap.put('options', nroLin);
        */

        options.put('nroLinea','1164646468');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        Map<String,Object> result = (Map<String,Object>)outMap.get('Response');
        system.assertEquals(result.get('DSLAM'),'V8011C');
        
    }

    @IsTest static void MockGetServiceLatency_test2(){
        String methodName = 'MockGetServiceLatency';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        options.put('nroLinea','1164646469');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();

        Map<String,Object> result = (Map<String,Object>)outMap.get('Response');
        system.assertEquals(result.get('DSLAM'),'V9311C');
        
    }

    @IsTest static void createMassiveIncident_test(){

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        options.put('nroLinea','1164646469');
        
        //ta_integration testedClass = new ta_integration();
        List<Account> accountsList = TestDataFactory.createAccounts(1);
        List<String> accIds = new List<String>();

        for(Account acc : accountsList){
                accIds.add(acc.Id);
        }
        
        Test.startTest();
        boolean result = ta_integration.createMassiveIncident('testCode', 'testType', 'testSubType', 'testImpact', 'testInci', 'testProcedure', 'testSpeech', 'incOrigin', 'extCaseType', accIds);
        Test.stopTest();

        system.assertEquals(result, false);
        
    }

    @IsTest static void MockModemReboot_test(){
        String methodName = 'MockModemReboot';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        options.put('cpeIdentifier','0003.0002');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockBlackList_test(){
        String methodName = 'MockBlackList';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('docNumber','37937937');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockGeoData_test1(){
        String methodName = 'MockGeoData';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('lng',-58.4782851);
        options.put('lat',-34.5636586);
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockGeoData_test2(){
        String methodName = 'MockGeoData';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('lng',-58.4723859);
        options.put('lat',-34.56606379999999);
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
    @IsTest static void MockValidateCardRefill_test1(){
        String methodName = 'MockValidateCardRefill';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('lotNumber','1111111111111111');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
        @IsTest static void MockValidateCardRefill_test2(){
        String methodName = 'MockValidateCardRefill';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('lotNumber','2222222222222222');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
        @IsTest static void MockValidateCardRefill_test3(){
        String methodName = 'MockValidateCardRefill';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('lotNumber','3333333333333333');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }
        @IsTest static void MockValidateCardRefill_test4(){
        String methodName = 'MockValidateCardRefill';

        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        
        options.put('lotNumber','1111');
        
        ta_integration testedClass = new ta_integration();
        
        Test.startTest();
        testedClass.invokeMethod(methodName, inputMap, outMap, options);
        Test.stopTest();
        
    }

}