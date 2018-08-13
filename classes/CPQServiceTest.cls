@IsTest
public class CPQServiceTest {
    @IsTest
    public static void WhenAssetToOrderCalledOrderIdIsReturned() {
        //Given
        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Set<Id> assetIds = new Set<Id> { fflib_IDGenerator.generate(Asset.SObjectType) };
        Id expectedOrderId = '8016C0000000hj1';
        
        //When
        Id actualOrderId = CPQService.AssetToOrder(accountId, DateTime.Now(), assetIds);

        //Then
        System.AssertEquals(expectedOrderId, actualOrderId);
    }

    @IsTest
    public static void WhenInvalidInputPassedToAssetToOrderExceptionMustBeThrowned() {
        //Given
        Id accountId = null;
        Set<Id> assetIds = null;
        DateTime requestDate = null;
        String expectedExceptionTypeName = 'System.NullPointerException';
        String actualExceptionTypeName;
        
        //When
        try {
            Id orderId = CPQService.AssetToOrder(accountId, requestDate, assetIds);
        }
        catch (Exception ex) {
            actualExceptionTypeName = ex.GetTypeName();
        }

        //Then
        System.AssertEquals(expectedExceptionTypeName, actualExceptionTypeName, 'Incorrect exception type throwned.');
    }

    /*@IsTest
    public static void GenerateAssetToOrderInputJSONShouldReturnValidInput() {
        //Given
        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Id assetId = fflib_IDGenerator.generate(Asset.SObjectType);
        Set<Id> assetIds = new Set<Id> { assetId };
        DateTime requestDate = DateTime.Now();

        Map<String, Object> expectedResult = new Map<String, Object>();
        expectedResult.put('id', String.ValueOf(assetId));
        expectedResult.put('accountId', String.ValueOf(accountId));
        expectedResult.put('requestDate', requestDate.format('YYYY-MM-dd'));
        expectedResult.put('subaction','assetToOrder');
        expectedResult.put('methodName', 'assetToOrder');
    
        //When
        Map<String, Object> actualResult = CPQService.GenerateAssetToOrderInputJSON(accountId, assetIds, requestDate);

        //Then
        System.AssertEquals(expectedResult, actualResult, 'Invalid Input generated.');
    }*/

    /*@IsTest
    public static void WhenInvalidInputPassedToGenerateAssetToOrderInputJSONExceptionMustBeThrowned() {
        //Given
        Id accountId = null;
        Set<Id> assetIds = null;
        DateTime requestDate = null;
        String expectedExceptionTypeName = 'System.NullPointerException';
        String actualExceptionTypeName;
        
        //When
        try {
            Map<String, Object> result = CPQService.GenerateAssetToOrderInputJSON(accountId, assetIds, requestDate);
        }
        catch (Exception ex) {
            actualExceptionTypeName = ex.GetTypeName();
        }

        //Then
        System.AssertEquals(expectedExceptionTypeName, actualExceptionTypeName, 'Incorrect exception type throwned.');
    }*/

    @IsTest
    public static void WhenSubmitOrderCalledOKMessageIsReturned() {
        //Given
        Id orderId = fflib_IDGenerator.generate(Order.SObjectType);
        String expectedMessageResult = 'OK';

        //When
        String actualMessageResult = CPQService.SubmitOrder(orderId);

        //Then
        System.AssertEquals(expectedMessageResult, actualMessageResult, 'Message returned is incorrect.');
    }
}