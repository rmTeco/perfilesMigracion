@IsTest
private class CommunityIntegration_test {
    @IsTest static void invoke_Get_IFS_S439_empty(){
        String methodName = 'Get_IFS_S439';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<String, Object> empty = new Map<String, Object>();

        CommunityIntegration testedClass = new CommunityIntegration();

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        System.debug('outMap '+outMap);
        Test.stopTest();

        System.assertEquals(empty, outMap);
    }

    @IsTest static void invoke_Get_IFS_S439(){
        String methodName = 'Get_IFS_S439';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        CommunityIntegration testedClass = new CommunityIntegration();

        Account acc = new Account(Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', vlocity_cmt__Active__c = 'Yes', vlocity_cmt__Status__c = 'Active');
        insert acc;
        Asset ass = new Asset(Name = 'asset1', MSISDN__c = '1234567890', AccountId = acc.Id);
        insert ass;

        input.put('AssetId',ass.Id);

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        Test.stopTest();  

        System.assert(outMap.get('IPResult') != null);
    }
}