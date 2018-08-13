@IsTest
private class OrderItemsTest {
    @IsTest
    private static void WhenSetActionsForSuspensionForRoboCallsUowRegisterDirtyAndSubActionShouldBeSuspendSiniestro() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
       
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        OrderItem orderItemTest = new OrderItem( Id = orderItemId );

        Application.UnitOfWork.SetMock(mockUow);                 

        // When
        OrderItems orderItems = new OrderItems(new List<OrderItem> { orderItemTest });
        orderItems.SetActionsForSuspension(mockUow, SuspensionReason.Robo);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Suspend.Name(),
                        OrderItem.Vlocity_cmt__SubAction__c => 'Suspend-Siniestro'
                    }));
    }

    @IsTest
    private static void WhenSetActionsForSuspensionForAdministrativaCallsUowRegisterDirtyAndSubActionShouldBeSuspendFraude() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
       
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        OrderItem orderItemTest = new OrderItem( Id = orderItemId );

        Application.UnitOfWork.SetMock(mockUow);                 

        // When
        OrderItems orderItems = new OrderItems(new List<OrderItem> { orderItemTest });
        orderItems.SetActionsForSuspension(mockUow, SuspensionReason.Administrativa);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Suspend.Name(),
                        OrderItem.Vlocity_cmt__SubAction__c => 'Suspend-Fraude'
                    }));
    }

    @IsTest
    private static void WhenSetActionsForResumeCallsUowRegisterDirtyAndProvisioningStatusShouldBeResume() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
       
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        OrderItem orderItemTest = new OrderItem( Id = orderItemId );

        Application.UnitOfWork.SetMock(mockUow);                 

        // When
        OrderItems orderItems = new OrderItems(new List<OrderItem> { orderItemTest });
        orderItems.SetActionsForResume(mockUow, null);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Resume.Name()
                    }));
    }

    @IsTest
    private static void WhenSetActionsForSuspensionForTangibleProductAndRoboCorrectStockMovementCodeShouldBeReturned() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
       
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        Id productId = fflib_IDGenerator.Generate(Product2.SObjectType);
        
        List<OrderItem> orderItemsTest = new List<OrderItem> {
            new OrderItem( Id = orderItemId, vlocity_cmt__Product2Id__r = new Product2( Id = productId, Tangible__c = true ) )
        };

        Application.UnitOfWork.SetMock(mockUow);

        // When
        OrderItems orderItems = new OrderItems(orderItemsTest);
        orderItems.SetActionsForSuspension(mockUow, SuspensionReason.Robo);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Suspend.Name(),
                        OrderItem.Vlocity_cmt__SubAction__c => 'Suspend-Siniestro',
                        OrderItem.Codigo_Movimiento_Inventario__c => 'STCR'
                    }));
    }

    @IsTest
    private static void WhenSetActionsForSuspensionForTangibleProductAndHurtoCorrectStockMovementCodeShouldBeReturned() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
       
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        Id productId = fflib_IDGenerator.Generate(Product2.SObjectType);
        
        List<OrderItem> orderItemsTest = new List<OrderItem> {
            new OrderItem( Id = orderItemId, vlocity_cmt__Product2Id__r = new Product2( Id = productId, Tangible__c = true ) )
        };

        Application.UnitOfWork.SetMock(mockUow);

        // When
        OrderItems orderItems = new OrderItems(orderItemsTest);
        orderItems.SetActionsForSuspension(mockUow, SuspensionReason.Hurto);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Suspend.Name(),
                        OrderItem.Vlocity_cmt__SubAction__c => 'Suspend-Siniestro',
                        OrderItem.Codigo_Movimiento_Inventario__c => 'STCH'
                    }));
    }

    @IsTest
    private static void WhenSetActionsForSuspensionForTangibleProductAndExtravioCorrectStockMovementCodeShouldBeReturned() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
       
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        Id productId = fflib_IDGenerator.Generate(Product2.SObjectType);
        
        List<OrderItem> orderItemsTest = new List<OrderItem> {
            new OrderItem( Id = orderItemId, vlocity_cmt__Product2Id__r = new Product2( Id = productId, Tangible__c = true ) )
        };

        Application.UnitOfWork.SetMock(mockUow);

        // When
        OrderItems orderItems = new OrderItems(orderItemsTest);
        orderItems.SetActionsForSuspension(mockUow, SuspensionReason.Extravio);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Suspend.Name(),
                        OrderItem.Vlocity_cmt__SubAction__c => 'Suspend-Siniestro',
                        OrderItem.Codigo_Movimiento_Inventario__c => 'STCE'
                    }));
    }

    @IsTest
    private static void WhenSetActionsForResumeForTangibleProductAndRoboCorrectStockMovementCodeShouldBeReturned() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
        
        Id assetId = fflib_IDGenerator.Generate(Asset.SObjectType);
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        Id productId = fflib_IDGenerator.Generate(Product2.SObjectType);
        Id transactionHistoryEntryId = fflib_IDGenerator.Generate(Transaction_History__c.SObjectType);
        
        List<Asset> assets = (List<Asset>) fflib_ApexMocksUtils.MakeRelationship(
            List<Asset>.Class,
            new List<Asset> { new Asset( Id = assetId ) },
            Transaction_History__c.Asset__c,
            new List<List<Transaction_History__c>> { 
                new List<Transaction_History__c> { new Transaction_History__c( Id = transactionHistoryEntryId, Sinister_type__c = 'Robo' ) }
            }
        );
        Map<Id, Asset> assetsWithActiveSuspension = new Map<Id, Asset>(assets);
                
        List<OrderItem> orderItemsTest = new List<OrderItem> {
            new OrderItem( 
                Id = orderItemId,
                vlocity_cmt__Product2Id__r = new Product2( Id = productId, Tangible__c = true ),
                Vlocity_cmt__AssetId__c = assetId
            )
        };

        Application.UnitOfWork.SetMock(mockUow);

        // When
        OrderItems orderItems = new OrderItems(orderItemsTest);
        orderItems.SetActionsForResume(mockUow, assetsWithActiveSuspension);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Resume.Name(),
                        OrderItem.Codigo_Movimiento_Inventario__c => 'RTCR'
                    }));
    }

    @IsTest
    private static void WhenSetActionsForResumeForTangibleProductAndHurtoCorrectStockMovementCodeShouldBeReturned() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
        
        Id assetId = fflib_IDGenerator.Generate(Asset.SObjectType);
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        Id productId = fflib_IDGenerator.Generate(Product2.SObjectType);
        Id transactionHistoryEntryId = fflib_IDGenerator.Generate(Transaction_History__c.SObjectType);
        
        List<Asset> assets = (List<Asset>) fflib_ApexMocksUtils.MakeRelationship(
            List<Asset>.Class,
            new List<Asset> { new Asset( Id = assetId ) },
            Transaction_History__c.Asset__c,
            new List<List<Transaction_History__c>> { 
                new List<Transaction_History__c> { new Transaction_History__c( Id = transactionHistoryEntryId, Sinister_type__c = 'Hurto' ) }
            }
        );
        Map<Id, Asset> assetsWithActiveSuspension = new Map<Id, Asset>(assets);
                
        List<OrderItem> orderItemsTest = new List<OrderItem> {
            new OrderItem( 
                Id = orderItemId,
                vlocity_cmt__Product2Id__r = new Product2( Id = productId, Tangible__c = true ),
                Vlocity_cmt__AssetId__c = assetId
            )
        };

        Application.UnitOfWork.SetMock(mockUow);

        // When
        OrderItems orderItems = new OrderItems(orderItemsTest);
        orderItems.SetActionsForResume(mockUow, assetsWithActiveSuspension);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Resume.Name(),
                        OrderItem.Codigo_Movimiento_Inventario__c => 'RTCH'
                    }));
    }

    @IsTest
    private static void WhenSetActionsForResumeForTangibleProductAndExtravioCorrectStockMovementCodeShouldBeReturned() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        // Given
        fflib_SObjectUnitOfWork mockUow = (fflib_SObjectUnitOfWork) mocks.Mock(fflib_SObjectUnitOfWork.Class);
        
        Id assetId = fflib_IDGenerator.Generate(Asset.SObjectType);
        Id orderItemId = fflib_IDGenerator.Generate(OrderItem.SObjectType);
        Id productId = fflib_IDGenerator.Generate(Product2.SObjectType);
        Id transactionHistoryEntryId = fflib_IDGenerator.Generate(Transaction_History__c.SObjectType);
        
        List<Asset> assets = (List<Asset>) fflib_ApexMocksUtils.MakeRelationship(
            List<Asset>.Class,
            new List<Asset> { new Asset( Id = assetId ) },
            Transaction_History__c.Asset__c,
            new List<List<Transaction_History__c>> { 
                new List<Transaction_History__c> { new Transaction_History__c( Id = transactionHistoryEntryId, Sinister_type__c = 'Extravio' ) }
            }
        );
        Map<Id, Asset> assetsWithActiveSuspension = new Map<Id, Asset>(assets);
                
        List<OrderItem> orderItemsTest = new List<OrderItem> {
            new OrderItem( 
                Id = orderItemId,
                vlocity_cmt__Product2Id__r = new Product2( Id = productId, Tangible__c = true ),
                Vlocity_cmt__AssetId__c = assetId
            )
        };

        Application.UnitOfWork.SetMock(mockUow);

        // When
        OrderItems orderItems = new OrderItems(orderItemsTest);
        orderItems.SetActionsForResume(mockUow, assetsWithActiveSuspension);
        
        // Then
        ((fflib_SObjectUnitOfWork) 
            mocks.Verify(mockUow, 1)).RegisterDirty(
                fflib_Match.sObjectWith(
                    new Map<SObjectField, Object> { 
                        OrderItem.Id => orderItemId,
                        OrderItem.Vlocity_cmt__Action__c => OrderItemAction.Change.Name(),
                        OrderItem.Vlocity_cmt__ProvisioningStatus__c => OrderItemProvisioningStatus.Resume.Name(),
                        OrderItem.Codigo_Movimiento_Inventario__c => 'RTCE'
                    }));
    }
}