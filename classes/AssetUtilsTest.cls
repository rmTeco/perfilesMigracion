@isTest
public class AssetUtilsTest {
    
    @testSetup private static void gerenateData() {
        
        AssetsMinimalDateFilter__c assetMin = new AssetsMinimalDateFilter__c(Name = 'FilterDate', AssetMinDate__c = Date.today());
        insert assetMin;
        
        Account acc = new Account(Name = 'Customer', vlocity_cmt__EnableAutopay__c = true, vlocity_cmt__AutoPaymentAmount__c  = 'Full Balance', Phone = '123245');
        insert acc;
        
        Asset asst = new Asset(Name = 'Asset', AccountId = acc.Id);
        insert asst;
        
        Case c = new Case(AssetId = asst.Id);
        insert c;
    }
    
    @isTest private static void testInvoke() {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options;
        
        Id assId = [SELECT Id FROM Asset LIMIT 1].Id;
        inputMap.put('Id', assId);

        AssetUtils au = new AssetUtils();

        Test.startTest();
        	au.invokeMethod('getNegotiations', inputMap, outMap, options);
        Test.stopTest();
    }
    
    @isTest private static void testNegotiation(){
        
        AssetUtils.Negotiation assUtil = new AssetUtils.Negotiation();
        
        assUtil.Name = '';
        assUtil.negDate = Date.today();
        assUtil.negNumber = '';
        assUtil.negType = '';
        assUtil.status = '';
    }
}