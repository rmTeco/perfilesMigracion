@isTest
public class ta_blackList_batch_test{

    @isTest
    static void test() {        

        Account accTest = new Account(Name='Account Test');
        insert accTest;

        Asset asset1 = new Asset(Name='Asset 1',
                                 Blacklist__c=true,
                                 Blacklist_Remove_Date__c=Date.today(),
                                 AccountId = accTest.Id);
        Asset asset2 = new Asset(Name='Asset 2',
                                 Blacklist__c=true,
                                 Blacklist_Remove_Date__c=Date.today().addDays(2),
                                 AccountId = accTest.Id);

        insert asset1;
        insert asset2;

        Test.startTest();
        ta_blackList_batch blackListBatch = new ta_blackList_batch();
        Id batchId = Database.executeBatch(blackListBatch);
        Test.stopTest();

        List<Asset> updatedAssets = [SELECT Name FROM Asset WHERE Blacklist__c = false AND Blacklist_Remove_Date__c = null];
        List<Asset> noUpdatedAssets = [SELECT Name FROM Asset WHERE Blacklist__c = true AND Blacklist_Remove_Date__c != null];

        System.assertEquals(1, updatedAssets.size());
        System.assertEquals(1, noUpdatedAssets.size());
    }
}