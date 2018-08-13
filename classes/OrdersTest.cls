@IsTest
private class OrdersTest {
    @IsTest
    private static void WhenComposeSuspensionCallsDomainAndUowRegisterDirty() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
        OrderItems mockOrderItems = (OrderItems) mocks.Mock(OrderItems.Class);

        Id orderId = fflib_IDGenerator.Generate(Order.SObjectType);
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        List<Order> testOrders = (List<Order>) fflib_ApexMocksUtils.MakeRelationship(
            List<Order>.Class,
            new List<Order> { new Order(Id = orderId) },
            OrderItem.OrderId,
            new List<List<OrderItem>> { 
                new List<OrderItem> { new OrderItem(Id = orderItemId) }
            }
        );

        mocks.StartStubbing();
        mocks.When(mockOrderItems.SObjectType()).ThenReturn(OrderItem.SObjectType);
        mocks.StopStubbing();

        Application.UnitOfWork.SetMock(mockUow);
        Application.Domain.SetMock(mockOrderItems);                    

        // When
        Orders orders = new Orders(testOrders);
        orders.ComposeSuspension(mockUow, SuspensionReason.Robo);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        Order.Id => orderId,
                        Order.Gestion__c => OrderType.Suspension.Name()
                    }));
        ((OrderItems) mocks.Verify(mockOrderItems, 1)).SetActionsForSuspension(mockUow, SuspensionReason.Robo);
    }

    @IsTest
    private static void WhenComposeReconnectionCallsDomainAndUowRegisterDirty() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
        OrderItems mockOrderItems = (OrderItems) mocks.Mock(OrderItems.Class);

        Id orderId = fflib_IDGenerator.Generate(Order.SObjectType);
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        List<Order> testOrders = (List<Order>) fflib_ApexMocksUtils.MakeRelationship(
            List<Order>.Class,
            new List<Order> { new Order(Id = orderId) },
            OrderItem.OrderId,
            new List<List<OrderItem>> { 
                new List<OrderItem> { new OrderItem(Id = orderItemId) }
            }
        );

        mocks.StartStubbing();
        mocks.When(mockOrderItems.SObjectType()).ThenReturn(OrderItem.SObjectType);
        mocks.StopStubbing();

        Application.UnitOfWork.SetMock(mockUow);
        Application.Domain.SetMock(mockOrderItems);                    

        // When
        Orders orders = new Orders(testOrders);
        orders.ComposeReconnection(mockUow, null);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        Order.Id => orderId,
                        Order.Gestion__c => OrderType.Resume.Name()
                    }));
        ((OrderItems) mocks.Verify(mockOrderItems, 1)).SetActionsForResume(mockUow, null);
    }

    @IsTest
    private static void WhenOnAfterUpdateSinisterSuspensionOrderTransactionHistoryMustBeCreated() {
        //Given
        Integer ordersQuantityToCreate = 1;
        Account account = TestDataFactory.CreateAccounts(1)[0];
        List<Order> orders = TestDataFactory.CreateOrders(ordersQuantityToCreate, account);
        Asset asset = TestDataFactory.CreateAssets(1, account)[0];
        List<Case> expectedCases = TestDataFactory.CreateCases(2, account.Id, asset.Id, 'TestSubject');
        TestDataFactory.CreateOrderItemsWithAsset(1, orders[0], asset);
        Set<Id> expectedOrderIds = new Map<Id, Order>(orders).KeySet();

        //When
        Test.StartTest();        
        for (Case caseObj : expectedCases) {
            caseObj.Order__c = orders[0].Id;
            caseObj.SubType__c = 'Suspensión siniestro';
        }

        expectedCases[1].ParentId = expectedCases[0].Id;

        update expectedCases;

        for (Order order : orders) {
            order.Status = 'Activated';
            order.Gestion__c = 'Suspension';
        }

        update orders;

        List<Transaction_History__c> suspensions = [
            SELECT Description__c, Type__c, New_Status__c
            FROM Transaction_History__c
            WHERE Asset__c = :asset.Id
        ];
        Test.StopTest();

        //Then
        System.AssertEquals('Suspensión', suspensions[0].Description__c);
        System.AssertEquals('Siniestro', suspensions[0].Type__c);
        System.AssertEquals('Active', suspensions[0].New_Status__c);
    }
}