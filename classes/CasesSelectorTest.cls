@IsTest
private class CasesSelectorTest {
    @IsTest
    private static void WhenQueryCasesByIdCorrectQuantityMustBeReturned() {
        //Given
        Integer expectedCasesQuantity = 2;
        Integer actualCasesQuantity = 0;
        Id accountId = TestDataFactory.CreateAccounts(1)[0].Id;
        List<Case> expectedCases = TestDataFactory.CreateCases(expectedCasesQuantity, accountId, 'TestSubject');
        Set<Id> caseIds = (new Map<Id, Case>(expectedCases)).KeySet();
        
        //When
        List<Case> actualCases = new CasesSelector().SelectById(caseIds);
        actualCasesQuantity = actualCases.Size();

        //Then
        System.AssertEquals(expectedCasesQuantity, actualCasesQuantity);
    }

    @IsTest
    private static void WhenQueryCasesByOrderIdCorrectQuantityMustBeReturned() {
        //Given
        Integer expectedCasesQuantity = 2;
        Integer actualCasesQuantity = 0;
        Account account = TestDataFactory.CreateAccounts(1)[0];
        Id orderId = TestDataFactory.CreateOrders(1, account)[0].Id;
        List<Case> expectedCases = TestDataFactory.CreateCases(expectedCasesQuantity, account.Id, 'TestSubject');
        
        for (Case caseObj : expectedCases)
            caseObj.Order__c = orderId;

        update expectedCases;

        //When
        List<Case> actualCases = new CasesSelector().SelectByOrderId(new Set<Id> { orderId });
        actualCasesQuantity = actualCases.Size();

        //Then
        System.AssertEquals(expectedCasesQuantity, actualCasesQuantity);
    }

    @IsTest
    private static void WhenQueryCasesByOrderIdWithAssetCorrectAssetIdMustBeReturned() {
        //Given
        Account account = TestDataFactory.CreateAccounts(1)[0];
        Id orderId = TestDataFactory.CreateOrders(1, account)[0].Id;
        Asset asset = TestDataFactory.CreateAssets(1, account)[0];
        List<Case> expectedCases = TestDataFactory.CreateCases(1, account.Id, asset.Id, 'TestSubject');
        Id expectedAssetId = asset.Id;
        Id actualAssetId;
        
        for (Case caseObj : expectedCases)
            caseObj.Order__c = orderId;

        update expectedCases;

        //When
        List<Case> actualCases = new CasesSelector().SelectByOrderIdWithAsset(new Set<Id> { orderId });
        actualAssetId = actualCases[0].Asset.Id;

        //Then
        System.AssertEquals(expectedAssetId, actualAssetId);
    }
}