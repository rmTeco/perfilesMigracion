@IsTest
public class OrderServiceTest {
    @IsTest
    private static void WhenCreateOrderFromAssetsCalledCpqAPIIsInvoked() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        //Given
        CPQServiceImpl mockCPQService = (CPQServiceImpl) mocks.Mock(CPQServiceImpl.Class);

        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Id expectedOrderId = fflib_IDGenerator.generate(Order.SObjectType);
        Set<Id> assetIds = new Set<Id> { fflib_IDGenerator.generate(Asset.SObjectType) };
        DateTime requestDate = DateTime.Now();
       
        mocks.StartStubbing();
        mocks.When(mockCPQService.AssetToOrder(accountId, requestDate, assetIds)).ThenReturn(expectedOrderId);
        mocks.StopStubbing();

        Application.Service.SetMock(ICPQService.Class, mockCPQService);    

        //When
        Id actualOrderId = OrderService.CreateFromAssets(accountId, assetIds);

        //Then
        //((CPQServiceImpl) mocks.Verify(mockCPQService, 1)).AssetToOrder(accountId, requestDate, assetIds);
        System.AssertEquals(expectedOrderId, actualOrderId);
    }

    @IsTest
    private static void WhenSubmitOrderOMProcessIsCalled() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        //Given
        CPQServiceImpl mockCPQService = (CPQServiceImpl) mocks.Mock(CPQServiceImpl.Class);

        Id accountId = fflib_IDGenerator.generate(Account.SObjectType);
        Id expectedOrderId = fflib_IDGenerator.generate(Order.SObjectType);
        Set<Id> assetIds = new Set<Id> { fflib_IDGenerator.generate(Asset.SObjectType) };
        Set<Id> orderIds = new Set<Id> { expectedOrderId };
        DateTime requestDate = DateTime.Now();
       
        mocks.StartStubbing();
        mocks.When(mockCPQService.SubmitOrder(expectedOrderId)).ThenReturn('OK');
        mocks.StopStubbing();

        Application.Service.SetMock(ICPQService.Class, mockCPQService);    

        //When
        OrderService.Submit(orderIds);

        //Then
        ((CPQServiceImpl) mocks.Verify(mockCPQService, 1)).SubmitOrder(expectedOrderId);
    }
}