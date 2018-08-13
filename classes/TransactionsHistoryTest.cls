@IsTest
public class TransactionsHistoryTest {
    @IsTest
    private static void WhenOnAfterInsertSinisterReconnectionCurrentSinisterSuspensionMustBeDeactivated() {
        //Given
        Account account = TestDataFactory.CreateAccounts(1)[0];
        Asset asset = TestDataFactory.CreateAssets(1, account)[0];
        Transaction_History__c suspension = TestDataFactory.CreateTransactionHistory(
            1, account.Id, asset.Id, 'Siniestro', 'Suspension', 'Active')[0];

        //When
        Test.StartTest();        
        List<Transaction_History__c> reconnections = TestDataFactory.CreateTransactionHistory(
            1, account.Id, asset.Id, 'Siniestro', 'Reconexión', '');

        List<Transaction_History__c> currentSuspension = [
            SELECT New_Status__c
            FROM Transaction_History__c
            WHERE Id = :suspension.Id
        ];
        Test.StopTest();

        //Then
        System.AssertEquals(currentSuspension[0].New_Status__c, 'Inactive');
    }
}