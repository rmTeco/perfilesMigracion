@IsTest
private class AssetsTest {
    @IsTest private static void WhenCRUDOnAssetConstructorClassShouldBeCalled() {
        Integer expectedAssetsQuantity = 1;
        Account account = TestDataFactory.CreateAccounts(1)[0];
        Asset asset = TestDataFactory.CreateAssets(expectedAssetsQuantity, account)[0];
        
        List<Asset> assets = [
            SELECT Id
            FROM Asset
            WHERE Id = :asset.Id
        ];

        System.AssertEquals(expectedAssetsQuantity, assets.Size());
    }
}