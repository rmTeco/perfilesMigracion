@IsTest
public class ta_care_AssetsMinDateFilter_test {
    @IsTest static void invoke_getAssetMinDate_empty(){
        String methodName = 'getAssetMinDate';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        ta_care_AssetsMinDateFilter testedClass = new ta_care_AssetsMinDateFilter();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        System.assertEquals(empty, outMap);
    }

    @IsTest static void invoke_getAssetMinDate_correct(){
        String methodName = 'getAssetMinDate';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        AssetsMinimalDateFilter__c assetMin = new AssetsMinimalDateFilter__c();
        assetMin.Name = 'FilterDate';
        assetMin.AssetMinDate__c = Date.today();

        ta_care_AssetsMinDateFilter testedClass = new ta_care_AssetsMinDateFilter();

        Test.startTest();
        insert assetMin;
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();

        system.assertEquals(Date.today(), outMap.get('AssetMinDate'));
    }
}