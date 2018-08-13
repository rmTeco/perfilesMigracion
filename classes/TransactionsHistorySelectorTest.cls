@isTest
public class TransactionsHistorySelectorTest{

    public static Set<Id> getTransactionHistoryIds(){
        List<Transaction_History__c> listTransactionHistory;
        List<Account> listAccount = TestDataFactory.createAccounts(1, 'Consumer');
        for(Account accountObj : listAccount)
        {
            List<Asset> listAsset = TestDataFactory.createAssets(1, accountObj);
            Set<Id> assetIds = new Map<Id, Asset>(listAsset).KeySet();
            listTransactionHistory = TestDataFactory.CreateTransacctionHistory(assetIds, accountObj.Id, 'Active', 'Administrativa');
        }
        
        return new Map<Id, Transaction_History__c>(listTransactionHistory).KeySet();
    }

    public static Set<Id> getTransactionHistoryAssetsIds(){

        List<Transaction_History__c> listTransactionHistory;
        List<Account> listAccount = TestDataFactory.createAccounts(1, 'Consumer');
        Set<Id> assetIds;

        for(Account accountObj : listAccount)
        {
            List<Asset> listAsset = TestDataFactory.createAssets(1, accountObj);
            assetIds = new Map<Id, Asset>(listAsset).KeySet();
            listTransactionHistory = TestDataFactory.CreateTransacctionHistory(assetIds, accountObj.Id, 'Active', 'Administrativa');
        }
                
        return assetIds;
    }

    @isTest
    public static void SelectById_Test(){
        TransactionsHistorySelector tHistorySelector = new TransactionsHistorySelector();
        List<Transaction_History__c> listTransactionHistory = tHistorySelector.SelectById(getTransactionHistoryIds());
 
        System.assert(listTransactionHistory.size() == 1);
    }

    @isTest
    public static void SelectByAssetId_Test(){
        TransactionsHistorySelector tHistorySelector = new TransactionsHistorySelector();
        List<Transaction_History__c> listTransactionHistory = tHistorySelector.SelectByAssetId(getTransactionHistoryAssetsIds());

        System.assert(listTransactionHistory.size() == 1);
    }

    @isTest
    public static void SelectByAssetIdAndStatus_Test(){
        TransactionsHistorySelector tHistorySelector = new TransactionsHistorySelector();
        List<Transaction_History__c> listTransactionHistory = tHistorySelector.SelectByAssetIdAndStatus(getTransactionHistoryAssetsIds(), 'Active');

        System.assert(listTransactionHistory.size() == 1);
    }

    @isTest
    public static void SelectActiveByAssetIdAndType_Test(){
        TransactionsHistorySelector tHistorySelector = new TransactionsHistorySelector();
        List<Transaction_History__c> listTransactionHistory = tHistorySelector.SelectActiveByAssetIdAndType(getTransactionHistoryAssetsIds(), 'Administrativa');

        System.assert(listTransactionHistory.size() == 1);
    }
    
}