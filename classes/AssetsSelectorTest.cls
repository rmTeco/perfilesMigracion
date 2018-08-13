@isTest
public class AssetsSelectorTest{

    public static Set<Id> getAssetsIds()
    {
        Set<Id> assetIds;
        List<Account> listAccount = TestDataFactory.createAccounts(1, 'Consumer');
        for(Account accountObj : listAccount)
        {
            List<Asset> listAsset = TestDataFactory.createAssets(1, accountObj);
            assetIds = new Map<Id, Asset>(listAsset).KeySet();
        }

        return assetIds;
    }

    public static Set<Id> getAccountsIds()
    {
        List<Account> listAccount = TestDataFactory.createAccounts(1, 'Consumer');
        for(Account accountObj : listAccount)
        {
            List<Asset> listAsset = TestDataFactory.createAssets(1, accountObj);
        }

        Set<Id> accountIds = new Map<Id, Account>(listAccount).KeySet();
        return accountIds;
    }

    public static Set<String> getAssetImeis()
    {
        Set<String> assetImeis = new Set<String>();
        Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
        Asset asset = TestDataFactory.createAssets(1, account)[0];
        asset.Imei__c = '834694392850238';
        asset.Status = 'Active';

        update asset;
        
        assetImeis.Add(asset.Imei__c);

        return assetImeis;
    }

    @isTest
    public static void SelectById_Test()
    {
        AssetsSelector assetSelector = new AssetsSelector();
        List<Asset> listAsset = assetSelector.SelectById(getAssetsIds());
        
        System.assert(listAsset.size() == 1);
    }

    @isTest
    public static void SelectByAccountId_Test()
    {
        AssetsSelector assetSelector = new AssetsSelector();
        List<Asset> listAsset = assetSelector.SelectByAccountId(getAccountsIds());

        System.assert(listAsset.size() >= 1);
    }

    @isTest
    public static void SelectByIdWithActiveSuspension_Test()
    {
        AssetsSelector assetSelector = new AssetsSelector();
        List<Asset> listAsset = assetSelector.SelectByIdWithActiveSuspension(getAssetsIds());

        System.assert(listAsset.size() >= 1);
    }

    @isTest
    public static void SelectByIMEI_Test()
    {
        AssetsSelector assetSelector = new AssetsSelector();
        List<Asset> listAsset = assetSelector.SelectByIMEI(getAssetImeis());

        System.assert(listAsset.size() >= 1);
    }
}