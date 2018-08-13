@isTest
public class TaCareCancelProcessControllerTest{
    public static List<Case> CreateCases()
    {
        Set<Id> assetIds;
        String accountId;
        String assetId;

        for(Account accountObj : TestDataFactory.createAccounts(1, 'Consumer'))
        {
            List<Asset> listAsset = TestDataFactory.createAssets(1, accountObj);
            assetIds = new Map<Id, Asset>(listAsset).KeySet();
            accountId = String.valueOf(accountObj.Id);
            assetId = String.valueOf(listAsset[0].Id);
        }
        return TestDataFactory.createCases(1, accountId, assetId, 'Test');
    }

    @isTest
    public static void closeCase_Test()
    {
       boolean request = false;
       List<Case> listCases = CreateCases();
       Id idCase = listCases[0].Id;

       request = TaCareCancelProcessController.closeCase(idCase);

       System.assert(request == true);
    }
}