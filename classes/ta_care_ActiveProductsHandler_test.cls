@IsTest
private class ta_care_ActiveProductsHandler_test {
    @IsTest static void invoke_GetActiveProductsMain_empty(){
        String methodName = 'GetActiveProductsMain';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        ta_care_ActiveProductsHandler testedClass = new ta_care_ActiveProductsHandler();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        System.debug('outMap '+outMap);
        Test.stopTest();

        System.assertNotEquals(empty, outMap);
    }

    @IsTest static void invoke_GetActiveProductsMain_Cbs(){
        String methodName = 'GetActiveProductsMain';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_care_ActiveProductsHandler testedClass = new ta_care_ActiveProductsHandler();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assert(outMap.get('CbsNode')!=null);
    }

    @IsTest static void invoke_GetActiveProductsMain_InfoteinmentNode(){
        String methodName = 'GetActiveProductsMain';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        ta_care_ActiveProductsHandler testedClass = new ta_care_ActiveProductsHandler();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assert(outMap.get('InfoteinmentNode')!=null);
    }
}