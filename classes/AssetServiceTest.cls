@IsTest
private class AssetServiceTest {
    @IsTest
    private static void WhenSuspendAssetOrderIdMustBeGenerated() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
        Orders mockOrders = (Orders) mocks.Mock(Orders.Class);
        OrderServiceImpl mockOrderService = (OrderServiceImpl) mocks.Mock(OrderServiceImpl.Class);
        OrdersSelector mockOrdersSelector = (OrdersSelector) mocks.Mock(OrdersSelector.Class);
        
        Id expectedOrderId = fflib_IDGenerator.Generate(Order.SObjectType);
        Id accountId = fflib_IDGenerator.Generate(Account.SObjectType);
        Id assetId = fflib_IDGenerator.Generate(Asset.SObjectType);
        Set<Id> assetIds = new Set<Id> { assetId };
        Set<Id> orderIds = new Set<Id> { expectedOrderId };
        List<Order> testOrders = new List<Order> { new Order ( Id = expectedOrderId )};

        mocks.StartStubbing();
        mocks.When(mockOrderService.CreateFromAssets(accountId, assetIds)).ThenReturn(expectedOrderId);
        mocks.when(mockOrdersSelector.SObjectType()).ThenReturn(Order.SObjectType);
        mocks.When(mockOrdersSelector.SelectByIdWithOrderItemsAndProducts(orderIds)).ThenReturn(testOrders);
        mocks.When(mockOrders.SObjectType()).ThenReturn(Order.SObjectType);
        mocks.StopStubbing();

        Application.UnitOfWork.SetMock(mockUow);
        Application.Selector.SetMock(mockOrdersSelector);
        Application.Domain.SetMock(mockOrders);
        Application.Service.SetMock(IOrderService.Class, mockOrderService);            

        // When
        Id actualOrderId = AssetService.Suspend(accountId, assetIds, SuspensionReason.Robo);
        
        // Then
        ((fflib_SObjectUnitOfWork) mocks.Verify(mockUow, 1)).CommitWork();
        ((OrderServiceImpl) mocks.Verify(mockOrderService, 1)).CreateFromAssets(accountId, assetIds);
        ((OrdersSelector) mocks.Verify(mockOrdersSelector, 1)).SelectByIdWithOrderItemsAndProducts(orderIds);
        ((Orders) mocks.Verify(mockOrders, 1)).ComposeSuspension(mockUow, SuspensionReason.Robo);
        System.AssertEquals(expectedOrderId, actualOrderId);
    }

    @IsTest
    private static void WhenResumeAssetOrderIdMustBeGenerated() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
        Orders mockOrders = (Orders) mocks.Mock(Orders.Class);
        OrderServiceImpl mockOrderService = (OrderServiceImpl) mocks.Mock(OrderServiceImpl.Class);
        OrdersSelector mockOrdersSelector = (OrdersSelector) mocks.Mock(OrdersSelector.Class);
        AssetsSelector mockAssetsSelector = (AssetsSelector) mocks.Mock(AssetsSelector.Class);
        
        Id expectedOrderId = fflib_IDGenerator.Generate(Order.SObjectType);
        Id accountId = fflib_IDGenerator.Generate(Account.SObjectType);
        Id assetId = fflib_IDGenerator.Generate(Asset.SObjectType);
        Set<Id> assetIds = new Set<Id> { assetId };
        Set<Id> orderIds = new Set<Id> { expectedOrderId };
        List<Order> testOrders = new List<Order> { new Order ( Id = expectedOrderId )};
        List<Asset> testAssets = new List<Asset> { new Asset ( Id = assetId ) };
        Map<Id, Asset> activeSuspensions = new Map<Id, Asset>(testAssets);

        mocks.StartStubbing();
        mocks.When(mockOrderService.CreateFromAssets(accountId, assetIds)).ThenReturn(expectedOrderId);
        mocks.when(mockOrdersSelector.SObjectType()).ThenReturn(Order.SObjectType);
        mocks.When(mockOrdersSelector.SelectByIdWithOrderItemsProductsAndAssets(orderIds)).ThenReturn(testOrders);
        mocks.when(mockAssetsSelector.SObjectType()).ThenReturn(Asset.SObjectType);
        mocks.When(mockAssetsSelector.SelectByIdWithActiveSuspension(assetIds)).ThenReturn(testAssets);
        mocks.When(mockOrders.SObjectType()).ThenReturn(Order.SObjectType);
        mocks.StopStubbing();

        Application.UnitOfWork.SetMock(mockUow);
        Application.Selector.SetMock(mockOrdersSelector);
        Application.Selector.SetMock(mockAssetsSelector);
        Application.Domain.SetMock(mockOrders);
        Application.Service.SetMock(IOrderService.Class, mockOrderService);        

        // When
        Id actualOrderId = AssetService.Resume(accountId, assetIds);
        
        // Then
        ((fflib_SObjectUnitOfWork) mocks.Verify(mockUow, 1)).CommitWork();
        ((OrderServiceImpl) mocks.Verify(mockOrderService, 1)).CreateFromAssets(accountId, assetIds);
        ((OrdersSelector) mocks.Verify(mockOrdersSelector, 1)).SelectByIdWithOrderItemsProductsAndAssets(orderIds);
        ((AssetsSelector) mocks.Verify(mockAssetsSelector, 1)).SelectByIdWithActiveSuspension(assetIds);
        ((Orders) mocks.Verify(mockOrders, 1)).ComposeReconnection(mockUow, activeSuspensions);
        System.AssertEquals(expectedOrderId, actualOrderId);
    }
}