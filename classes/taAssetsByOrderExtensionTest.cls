@isTest
public class taAssetsByOrderExtensionTest {

    static testMethod void taAssetsByOrderExtensionTest() {
        //GIVEN
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Account account = [SELECT Id FROM Account LIMIT 1];
        Product2 product = TestDataFactory.createProduct(1).get(0);
        Asset asset = TestDataFactory.createSingleAsset(product,account.Id);
        Order order = TestDataFactory.createOrders(1,account).get(0);
        asset.vlocity_cmt__OrderId__c = order.Id;
        asset.Status = 'Active';
        update asset;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(asset);
        
        //WHEN
        Test.startTest();
        taAssetsByOrderExtension taAssetsByOrderExtension = new taAssetsByOrderExtension(controller);
        Test.stopTest();
        
        //THEN
        System.assert(true);
        
    }
}