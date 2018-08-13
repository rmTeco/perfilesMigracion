@isTest
    public class taOrderControllerTest
    {
        @isTest
        static void testCancelarOrden()
        {
            String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
            VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);
            mockResponse = '{"listaResultado": [],"descripcionResultado": "Liberacion Exitosa","codigoResultado": "OK"}';
            VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S101', mockResponse);
            MockupFactory.generate();
            vlocity_cmt__PriceList__c objPrice = [select Name, vlocity_cmt__Code__c, Id from vlocity_cmt__PriceList__c limit 1];
            Order objOrder = new Order();
            List<Account> AccList = TestDataFactory.createAccounts(1);
            objOrder.AccountId = AccList[0].Id;
            objOrder.Status = 'Draft';
            objOrder.EffectiveDate = Date.today();
            objOrder.vlocity_cmt__OriginatingChannel__c = 'WEB';
            objOrder.Delivery_Method__c = 'Delivery';
            insert objOrder;
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            Test.startTest();
                taOrderController classOrCo = new taOrderController();
                Test.setMock(HttpCalloutMock.class, new OrderControllerMockHttpResponseGenerator());
                taOrderController.CancelOrderAndRedirect(objOrder.id);
                String temp = classOrCo.valor;
            Test.stopTest();
        }

        @isTest
        static void testOrden1()
        {
            List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
            Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
            vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(RecordTypeId=idRecordType, vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default');
            insert StoreLocations;
            FinancialPromotions__c Promo1 = new FinancialPromotions__c(Name='Promo1',Creditcard_Type__c='403', Bank_Code__c='1', Instalments__c='1', CFT__c='test');
            insert Promo1;
            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
            OrdList[0].PaymentMethodType__c ='1001';
            OrdList[0].vlocity_cmt__OriginatingChannel__c ='Presencial Oficina Comercial';
            OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
            OrdList[1].vlocity_cmt__OriginatingChannel__c ='Presencial Oficina Comercial';
            OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
            OrdList[1].PaymentMethodType__c ='1001';
            
            update OrdList;
            List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
            List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);

            PricebookEntry pricebook = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id=:OIList[0].PricebookEntryId];
            System.debug('pricebook');
            System.debug(pricebook);
            Product2 product = [SELECT Id FROM Product2 WHERE Id=:pricebook.Product2Id ];
            System.debug('product');
            System.debug(product);
            product.Name = 'TestName';
            product.ProductCode = 'TestProductCode';
            product.vlocity_cmt__Type__c = 'TestType';
            product.Tangible__c = true;
            update product;

            PricebookEntry pricebook2 = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id=:OIList1[0].PricebookEntryId];
            System.debug('pricebook2');
            System.debug(pricebook2);
            Product2 product2 = [SELECT Id FROM Product2 WHERE Id=:pricebook.Product2Id ];
            System.debug('product2');
            System.debug(product2);
            product2.Name = 'TestName1';
            product2.ProductCode = 'TestProductCode1';
            product2.vlocity_cmt__Type__c = 'TestType1';
            product2.Tangible__c = true;
            product2.FAN_IntegrationKey__c='0';
            //product2.StockKeepingUnit = ''; 
            product2.vlocity_cmt__JSONAttribute__c ='{"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
            product2.Family = 'Dispositivo';
            update product2;
            OIList1[0].vlocity_cmt__EffectiveOneTimeTotal__c=0;
            OIList1[0].vlocity_cmt__EffectiveRecurringTotal__c=0;
            OIList1[0].Huawei_Invoice_Item_Sequence__c = '0';
            OIList1[0].vlocity_cmt__PricingLogData__c='0';
            OIList1[0].IsBillable__c=true;
            OIList1[0].vlocity_cmt__Action__c='Add';

            update OIList1[0];

            TestDataFactory.createPaymentMethodTypes();

            Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c(
                vlocity_cmt__MethodType__c = '1001',
                vlocity_cmt__AccountId__c = AccList[0].Id,
                vlocity_cmt__IsActive__c = true);
            insert objPaymentMethod;

            TestDataFactory.createPaymentAdjustments(1, AccList[0], OrdList[0], objPaymentMethod, 0);

            Map<String,Object> options2 = new Map<String,Object>();
            options2.put('orderId', OrdList[1].Id);
            List<Asset> assetList = TestDataFactory.createAssets(1, AccList[0], '11228808338' );
            assetList[0].vlocity_cmt__AssetReferenceId__c = assetList[0].Id;
            update assetList;
            Map<String,Object> inputMapRD = new Map<String,Object>();
            List<String> lAssetIds = new List<String>();
            lAssetIds.add(assetList[0].Id);
            inputMapRD.put('assetIdList', lAssetIds);
            inputMapRD.put('ContextId', assetList[0].Id);
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> outMapRD = new Map<String,Object>();
            outMapRD.put('assetIdList', lAssetIds);
            outMapRD.put('canCreateFDO', true);
            Map<String,Object> options = new Map<String,Object>();
            Map<String,Object> inputManage = new Map<String,Object>();
            inputManage.put('IdOrder', OrdList[0].Id);        
            inputManage.put('IsMACDValidationIdentitySubmit', true);
            Map<String,Object> inputManage2 = new Map<String,Object>();
            inputManage2.put('IdOrder', OrdList[0].Id);        
            inputManage2.put('isAnnulment', true);
            Map<String,Object> inputManage3 = new Map<String,Object>();
            inputManage3.put('IdOrder', OrdList[0].Id);        
            inputManage3.put('IsMACDValidationIdentityABMSubmit', true);
            Map<String,Object> inputManage4 = new Map<String,Object>();
            inputManage4.put('IdOrder', OrdList[0].Id);        
            inputManage4.put('IsMACDValidationIdentitySubmit', true);
            Map<String,Object> inputManage5 = new Map<String,Object>();
            inputManage5.put('IdOrder', OrdList[0].Id);        
            inputManage5.put('IsNewPackExistingLine', true);
            Map<String,Object> inputManage6 = new Map<String,Object>();
            inputManage6.put('IdOrder', OrdList[0].Id);
            Map<String,Object> inputManage7 = new Map<String,Object>();
            inputManage7.put('IdOrder', OrdList[1].Id);
            test.startTest();
                TaOrderController OrderCtrl = new TaOrderController();
                options.put('orderId',OrdList[0].Id);
                OrderCtrl.invokeMethod('GetManageableIdentityValidation', inputManage, outMap, options);
                OrderCtrl.invokeMethod('GetManageableIdentityValidation', inputManage2, outMap, options);
                OrderCtrl.invokeMethod('GetManageableIdentityValidation', inputManage3, outMap, options);
                OrderCtrl.invokeMethod('GetManageableIdentityValidation', inputManage4, outMap, options);
                OrderCtrl.invokeMethod('GetManageableIdentityValidation', inputManage5, outMap, options);
                OrderCtrl.invokeMethod('GetManageableIdentityValidation', inputManage6, outMap, options);
                OrderCtrl.invokeMethod('GetManageableIdentityValidation', inputManage7, outMap, options);
                OrderCtrl.invokeMethod('OrderPreparationUpdate',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('OrderHandOverUpdate',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('GetProductNMU',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('GetPointOfSaleWarehouse',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('DeleteOrder',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('CancelOrder',inputMap,outMap,options) ;
                OrderCtrl.invokeMethod('GetCreditReChargeAmmount',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('UpdateOrderCreditRefillSOS',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('GetMACDRequestDate',inputMapRD ,outMap,options);
                OrderCtrl.invokeMethod('CancelOrderAndRelease',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('ValidateTelecomNumbers',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('GetPaymentsAdjustments',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('CreateMACD', inputMapRD, outMapRD, options);
                OrderCtrl.invokeMethod('CanUseBalanceDiscount', inputMapRD, outMapRD, options2);
                TaOrderController.CreateMACD2(inputMapRD ,outMapRD,options);
                TaOrderController.GetOrderItemsBillable(OrdList[1].Id);
                TaOrderController.GetInstallmentsByCard('1','403');
                TaOrderController.GetCardsByBank('1');
            test.stopTest();
        }

        @isTest
        static void testOrder2()
        {
            String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
            VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);

            mockResponse = '{"listaResultado": [],"descripcionResultado": "Liberacion Exitosa","codigoResultado": "OK"}';
            VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S101', mockResponse);

            String vlocitycmtJSONAttribute = '{"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"attributeRunTimeInfo":"10","objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}]}';
            List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
            Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
            vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(RecordTypeId=idRecordType, vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
            insert StoreLocations;
            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
            OrdList[0]. vlocity_cmt__OriginatingChannel__c ='Agentes';
            OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
            OrdList[0].Delivery_Method__c ='Store Pick Up';
            OrdList[1]. vlocity_cmt__OriginatingChannel__c ='Agentes';
            OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
            OrdList[1].Delivery_Method__c ='Store Pick Up';
            update OrdList;
            List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
            List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            Map<String,Object> inputCart = new Map<String,Object>();

            string stroperador = 'L';
            Map<String, Object> nmusMap = new Map<String, Object>();
            Map<String, Map<String, Object>> nmusMap2 = new Map<String, Map<String, Object>>();
            String codPuntoDeVenta = '1';
            String codDeposito;
            String orderId = OrdList[0].Id;
            inputCart.put('cartId', orderId);
            inputCart.put('productId', '');
            list<String> lstAsset = new list<String>();
            String attributeC = '{"FAN_ATTCAT_000044":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZudOQAS","attributeid__c":"a0G6C000000pofyUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"FAN_ATTCAT_000044","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"FAN_ATT_000038","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Numero de Linea","displaysequence__c":"null","categorydisplaysequence__c":18,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqfyUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text", "value":"3456787654"},"$$AttributeDefinitionEnd$$":null}]}';
            List<Product2> productsList = new List<Product2>();
            productsList.add(new Product2(Name = 'Plan con tarjeta', Family = 'Movil', vlocity_cmt__Type__c = 'Plan Prepago', vlocity_cmt__JSONAttribute__c=attributeC));
            insert productsList;

            Id pricebookId = Test.getStandardPricebookId();
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productsList.get(0).Id, UnitPrice = 100, IsActive = true);
            insert standardPrice1;

            Order order = new Order(AccountId = AccList[0].Id, Status = 'Draft', Gestion__c = 'Venta', Operation_Code__c = 'VTNLCE', EffectiveDate = Date.today(), Pricebook2Id = pricebookId,vlocity_cmt__OriginatingChannel__c ='Agentes',Delivery_Method__c ='Presencial', Received224_Date__c = Date.Today());
            insert order;
            
            List<OrderItem> ordItemList = new List<OrderItem>();
            ordItemList.add(new OrderItem(OrderId = order.Id, Product2Id = productsList.get(0).Id, Quantity = 10, PricebookEntryId = standardPrice1.Id, UnitPrice = 100));
            insert ordItemList;

            Location__c loc = new Location__c(Name = 'test1', DepartmentCode__c = 'Cod', LocationCode__c = 'Test1', StateCode__c ='B', Status__c = true);
            insert loc;

            /*vlocity_cmt__OrderPriceAdjustment__c opadjustment = new vlocity_cmt__OrderPriceAdjustment__c();
            opadjustment.vlocity_cmt__OrderItemId__c;
            opadjustment.vlocity_cmt__Amount__c;
            opadjustment.vlocity_cmt__PricingVariableCode__c;
            opadjustment.vlocity_cmt__AdjustmentValue__c;
            opadjustment.vlocity_cmt__Sequence__c;
            opadjustment.vlocity_cmt__PriceListEntryId__r;*/ 


            test.startTest();
                nmusMap2.put('test',nmusMap);
                TaOrderController OrderCtrl = new TaOrderController();
                options.put('orderId',OrdList[0].Id);
                options.put('IdOrder',OrdList[0].Id);
                options.put('userId',UserInfo.getUserId());
                //options.put('DeliveryMethod',OrdList[0].Delivery_Method__c);
                //options.put('Channel',OrdList[0].vlocity_cmt__OriginatingChannel__c);
                OrderCtrl.invokeMethod('OrderPreparationUpdate',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('OrderPreparationUpdate',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('ValidateTangibleExistence',inputMap ,outMap,options);
                TaOrderController.GetMACDRequestDate('',lstAsset);
                TaOrderController.OrderTimeOut(OrdList[0].Id);
                taOrderController.ValidateTangibleExistence(orderId);
                taOrderController.GetStockCodeByOperation('','','');
                taOrderController.GetNMU(vlocitycmtJSONAttribute);
                taOrderController.consultingMatrixValidationRequired('','');
                taOrderController.GetDocumentTypes(inputMap);
                taOrderController.PopulateEntidades(inputMap);
                taOrderController.GetMatrixDpfCft('');
                taOrderController.ValidateTelecomNumber('');
                outMap = taOrderController.getFinancialPromotions(options);
                inputMap.put('promotionOptions',outMap.get('options'));
                taOrderController.PopulateEntidadesFromObject(inputMap);
                taOrderController.GetCardsByBankFromObject(inputMap);
                taOrderController.GetPromotionsByBankCardFromObject('','',inputMap);
                taOrderController.GetInstallmentsByPromotion('','','',inputMap);
                taOrderController.PopulateDPFInstallmentsFromObject(inputMap);
                taOrderController.CancelOrderAndRelease(orderId);
                taOrderController.ReleaseLinesFromOrder(order.Id);
                taOrderController.RollbackForRetryPaymentMethods(options);
                taOrderController.GetPaymentsAdjustments(orderId);
                taOrderController.GetCashPayments(orderId);
                taOrderController.GetCardsPayments(orderId);
                taOrderController.GetOrderSerials(orderId);
                taOrderController.GetPaymentAdjustmentsWithCFT(orderId);
                //taOrderController.ManageReservedNmus('MTPL', nmusMap2, '141', 'CP0134001',orderId);
                //TaOrderController.Manag,eReservedNmus(stroperador,nmusMap,codPuntoDeVenta,codDeposito,orderId);
                Test.setMock(HttpCalloutMock.class, new IFS_S101_reserveOrReleaseMock());
                taOrderController.getExpandedPacksItems(orderId,'','');
                taOrderController.getCartsProductsById(inputCart);
                Map<String, Object> inputMapAdd = new Map<String, Object>();
                inputMapAdd.put('cartId', 'randomTestData');
                inputMapAdd.put('itemId', 'randomTestData');
                inputMapAdd.put('parentId', 'randomTestData');
                inputMapAdd.put('parentHierarchyPath', 'randomTestData');
                inputMapAdd.put('product2Id', 'randomTestData');
                inputMapAdd.put('name', 'randomTestData');
                inputMapAdd.put('id', 'randomTestData');
                taOrderController.addToCartItems(inputMapAdd);
                taOrderController.getCarts(orderId);

                Map<String, Object> inputMapDelete = new Map<String, Object>();
                inputMapDelete.put('cartId', 'randomTestData');
                inputMapDelete.put('Id', 'randomTestData');
                inputMapDelete.put('parentHierarchyPath', 'randomTestData');
                inputMapDelete.put('product2Id', 'randomTestData');
                inputMapDelete.put('name', 'randomTestData');
                inputMapDelete.put('groupId', 'randomTestData');
                inputMapDelete.put('inCartQuantityId', 'randomTestData');
                taOrderController.deleteCartItem(inputMapDelete);
                options.put('deleteCartItemRequest', inputMapDelete);
                OrderCtrl.invokeMethod('DeleteCartItem',inputMapDelete ,outMap,options);

                taOrderController.GetPriceAdjustmentsGroupByOrderItem(orderId);

                Map<String,Object> serialNumbersToMove = new Map<String,Object>();
                taOrderController.addSerialToMove(serialNumbersToMove, '99999777799999', 'VTAN', 'ANULARESERVA', 'MTPL', '134', OrdList[0].Delivery_Method__c);
                taOrderController.addSerialToMove(serialNumbersToMove, '77776676767666', 'VTAN', 'ANULARESERVA', 'MCVM', '134', OrdList[0].Delivery_Method__c);
                taOrderController.MoveSerialsStock(serialNumbersToMove);

            test.stoptest();
        }

        @isTest
        static void testOrderTimeOut()
        {
            String mockResponse = '{"listaResultado":[{"mensajeResultado": "OK","codigoResultado": "0","numeroSerie": "99543410307677114097"}],"codigoResultado": "OK"}';
            VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S105', mockResponse);
            mockResponse = '{"listaResultado": [],"descripcionResultado": "Liberacion Exitosa","codigoResultado": "OK"}';
            VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S101', mockResponse);

            List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
            Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
            vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(RecordTypeId=idRecordType, Name='Barrio Norte',
               vlocity_cmt__OrganizationId__c=AccList[0].Id, Status__c='Activo', Type__c='POS', Channel__c='Físico',
                Channel_Type__c='Oficinas Comerciales', Channel_Type_2__c='Oficinas Comerciales', Channel_Type_3__c='Oficinas Comerciales',
                Region__c='AMBA');
            insert StoreLocations;
            TestDataFactory.createPaymentMethodTypes();
            //TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            List<Order>OrdList = TestDataFactory.createOrders(2,AccList[0]);
            //OrdList[0]. vlocity_cmt__OriginatingChannel__c ='Agentes';
            OrdList[0].PickUpStoreLocation__c = StoreLocations.id;
            OrdList[0].Delivery_Method__c ='Store Pick Up';
            //OrdList[1]. vlocity_cmt__OriginatingChannel__c ='Agentes';
            OrdList[1].PickUpStoreLocation__c = StoreLocations.id;
            OrdList[1].Delivery_Method__c ='Store Pick Up';
            update OrdList;
            list<PaymentMethodType__c> lststorelocation = [SELECT Name,Efectivo__c,Tarjeta__c,DebitoProxFactura__c FROM PaymentMethodType__c WHERE Name = 'Agentes' limit 1];
            System.debug('lststorelocation ===> '+lststorelocation);
            List<OrderItem>OIList =TestDataFactory.createOrderItem(2,OrdList[0]);
            List<OrderItem>OIList1 =TestDataFactory.createOrderItem(2,OrdList[1]);
            OIList[0].vlocity_cmt__JSONAttribute__c = '{"TA Linea Basica":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu7wUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Standard Tecnico","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCiUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"NGM","value":"NGM"},{"id":2,"displayText":"TDM","value":"TDM"},{"id":3,"displayText":"GPON","value":"GPON"},{"id":4,"displayText":"MTA","value":"MTA"},{"id":5,"displayText":"2G","value":"2G"},{"id":6,"displayText":"3G","value":"3G"},{"id":7,"displayText":"4G","value":"4G"}],"default":[{"id":5,"displayText":"2G","value":"2G"}],"selectedItem":{"id":5,"displayText":"2G","value":"2G"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pogXUAQ","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"Tecnología","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tecnologia","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhChUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"Cobre","value":"Cobre"},{"id":2,"displayText":"Fibra","value":"Fibra"},{"id":3,"displayText":"MTA","value":"MTA"},{"id":4,"displayText":"GSMF","value":"GSMF"}],"default":[{"id":4,"displayText":"GSMF","value":"GSMF"}],"selectedItem":{"id":4,"displayText":"GSMF","value":"GSMF"}},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"ATT_000110","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCjUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Selected","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"ATTCAT_000200":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5IUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Download Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":10.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCeUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"10","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"10","value":10},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5NUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Velocidad","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCgUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"MB","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"MB","value":"MB"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu58UAA","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000010","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Upload Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCfUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000puAHUAY","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000120","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Real Download Speed","displaysequence__c":"300","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhTlUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"","value__c":"11776_1024","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"11776_1024","value":"11776_1024"},"$$AttributeDefinitionEnd$$":null}]}';
            system.debug(' OIList ====> '+OIList);
            system.debug(' OIList.OIList ====> '+OIList[0].Product2);
            OIList[1].vlocity_cmt__SerialNumber__c = '89543410307680582547';
            OIList[1].FromStock__c = 'MTPL';
            update OIList[0];
            update OIList[1];
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            String orderListId = OrdList[0].Id;
            system.debug(' order list ====> '+orderListId);
            user usernew = new user(ID = UserInfo.getUserID());
            string strIdUser = UserInfo.getUserID();
            WorkTeam__c workTeamParent = new WorkTeam__c(Team_Name__c = 'Test Parent', Name = 'Test Parent');
            insert workTeamParent;
            String manager = UserInfo.getUserId();
            String parent = workTeamParent.Id;
            WorkTeam__c workTeam = new WorkTeam__c(Team_Name__c = 'Test', Name = 'Test');
            Team_Member__c tm = TestDataFactory.setTeamMember('Call Center', userinfo.getUserId(), null);
            options.put('orderId', orderListId);
            taOrderController testedClass = new taOrderController();
                test.startTest();
                    inputMap.put('CreditDiscountPaymentMethod', null);
                    taOrderController.GetPaymentMethods(inputMap);
                    taOrderController.OrderTimeOut(orderListId);
                    inputMap.put('Status', 'Cancelled');
                    inputMap.put('SubStatus', 'Cancelada - Timeout Validacion');
                    inputMap.put('orderId', OIList[1].Id);
                    inputMap.put('IdOrder', OIList[1].Id);
                    testedClass.invokeMethod('UpdateOrderCreditRefillSOS', inputMap, outMap, options);
                    options.put('IsMACDValidationIdentitySubmit', true);
                    testedClass.invokeMethod('CancelOrder', inputMap, outMap, options);
                    //testedClass.invokeMethod('GetManageableIdentityValidation', inputMap, outMap, options);
                test.stopTest();


        }

        @isTest
        static void testOrder3()
        {
            IFS_S038_updateCycleMock mock = new IFS_S038_updateCycleMock();
        mock.status = 200;
        Test.setMock(HttpCalloutMock.class, mock);
            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> optionsCG = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
            List<Product2> lstProduct2 = TestDataFactory.createProduct(1);
            Asset assetTest = new Asset();
            assetTest.Name = 'Test Asset';
            assetTest.AccountId = lstAccount[0].Id;
            assetTest.Product2Id =  lstProduct2[0].Id;
            lstProduct2[0].productCode = 'CHIPPRUEBA';
            update lstProduct2;
            insert assetTest;
            List<Order>OrdList = TestDataFactory.createOrders(2,lstAccount[0]);
            OrdList[0].Delivery_Method__c ='Store Pick Up';
            OrdList[1].Delivery_Method__c ='Store Pick Up';
            OrdList[1].Gestion__c ='Cambio en Garantia';
            update OrdList;
            Map<String,Object> response = TaMatrixUtils.getStockMovementOperation('VTAN','ENTREGA', OrdList[0].Delivery_Method__c, 'NOAPLICA');
            Test.startTest();
            options.put('idOrder',OrdList[0].Id);
            options.put('ProductCode',lstProduct2[0].productCode);
            optionsCG.put('idOrder', OrdList[1].Id);
            optionsCG.put('ProductCode',lstProduct2[0].productCode);
                TaOrderController OrderCtrl = new TaOrderController();
                OrderCtrl.invokeMethod('OrderHandOverUpdate',inputMap,outMap,options);
                OrderCtrl.invokeMethod('OrderHandOverUpdate',inputMap,outMap,optionsCG);
                OrderCtrl.invokeMethod('GetProductNMU',inputMap,outMap,options);
            Test.stopTest();
        }

        @isTest
        static void testOrder()
        {
            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
            List<Product2> lstProduct2 = TestDataFactory.createProduct(1);
            Asset assetTest = new Asset();
            assetTest.Name = 'Test Asset';
            assetTest.AccountId = lstAccount[0].Id;
            assetTest.Product2Id =  lstProduct2[0].Id;
            lstProduct2[0].vlocity_cmt__JSONAttribute__c = '{"TA Linea Basica":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu7wUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Standard Tecnico","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCiUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"NGM","value":"NGM"},{"id":2,"displayText":"TDM","value":"TDM"},{"id":3,"displayText":"GPON","value":"GPON"},{"id":4,"displayText":"MTA","value":"MTA"},{"id":5,"displayText":"2G","value":"2G"},{"id":6,"displayText":"3G","value":"3G"},{"id":7,"displayText":"4G","value":"4G"}],"default":[{"id":5,"displayText":"2G","value":"2G"}],"selectedItem":{"id":5,"displayText":"2G","value":"2G"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pogXUAQ","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"Tecnología","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tecnologia","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhChUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"Cobre","value":"Cobre"},{"id":2,"displayText":"Fibra","value":"Fibra"},{"id":3,"displayText":"MTA","value":"MTA"},{"id":4,"displayText":"GSMF","value":"GSMF"}],"default":[{"id":4,"displayText":"GSMF","value":"GSMF"}],"selectedItem":{"id":4,"displayText":"GSMF","value":"GSMF"}},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"ATT_000110","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCjUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Selected","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"ATTCAT_000200":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5IUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Download Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":10.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCeUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"10","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"10","value":10},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5NUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Velocidad","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCgUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"MB","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"MB","value":"MB"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu58UAA","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000010","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Upload Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCfUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000puAHUAY","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000120","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Real Download Speed","displaysequence__c":"300","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhTlUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"","value__c":"11776_1024","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"11776_1024","value":"11776_1024"},"$$AttributeDefinitionEnd$$":null}]}';
            update lstProduct2;
            List<Order>OrdList = TestDataFactory.createOrders(2,lstAccount[0]);
            OrdList[0].Delivery_Method__c ='Store Pick Up';
            OrdList[1].Delivery_Method__c ='Store Pick Up';
            update OrdList;
            assetTest.PurchaseDate = date.today();
            insert assetTest;
            List<Product2> lstProduct2test = [Select vlocity_cmt__JSONAttribute__c From Product2 Where id ='01t6C000000Zw0h'];
            System.debug('lstProduct2test ===> '+lstProduct2test);
            Test.startTest();
                TaOrderController OrderCtrl = new TaOrderController();
                OrderCtrl.invokeMethod('GetCreditReChargeAmmount',inputMap ,outMap,options);
            Test.stopTest();
        }

        @isTest
        static void testOrder4()
        {
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
            List<Product2> lstProduct2 = TestDataFactory.createProduct(1);
            Asset assetTest = new Asset();
            assetTest.Name = 'Test Asset';
            assetTest.AccountId = lstAccount[0].Id;
            assetTest.Product2Id =  lstProduct2[0].Id;
            List<Order>OrdList = TestDataFactory.createOrders(2,lstAccount[0]);
            OrdList[0].Delivery_Method__c ='Store Pick Up';
            OrdList[1].Delivery_Method__c ='Store Pick Up';
            update OrdList;
            update OrdList;
            assetTest.PurchaseDate = date.today();
            insert assetTest;
            Test.startTest();
                outMap.put('assetIdList',assetTest.Id);
                //inputMap.put('getAccountId',lstAccount[0].id);
                System.debug('outMap ===> '+outMap);
                TaOrderController.CreateMACD2(inputMap,outMap,options);
                //vlocity_cmt.OmniFDOWrapper ow = new vlocity_cmt.OmniFDOWrapper();
                //ow.invokeMethod('getAccountId',inputMap,outMap,options);
            Test.stopTest();
        }

        @isTest
        static void AprobarOrderADVTest(){
          MockupFactory.generate();
          vlocity_cmt__PriceList__c objPrice = [select Name, vlocity_cmt__Code__c, Id from vlocity_cmt__PriceList__c limit 1];
          Order objOrder = new Order();
          List<Account> AccList = TestDataFactory.createAccounts(1);
          objOrder.AccountId = AccList[0].Id;
          objOrder.Status = 'Draft';
          objOrder.EffectiveDate = Date.today();
          objOrder.vlocity_cmt__OriginatingChannel__c = 'WEB';
          objOrder.Delivery_Method__c = 'Delivery';
          insert objOrder;
          PageReference pageRef = Page.pagAprobalADV;
          Test.setCurrentPage(pageRef);
          ApexPages.currentPage().getParameters().put('id',objOrder.id);
          Test.startTest();
            TaOrderController OrderCtrl = new TaOrderController();
            OrderCtrl.aprobarOrderADV();
          Test.stopTest();

        }
        
        static testmethod void devolverRechazarOrderADV(){
            List<Account> AccList = TestDataFactory.createAccounts(1, 'Consumer');
            Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
            vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(RecordTypeId=idRecordType, vlocity_cmt__OrganizationId__c=AccList[0].id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', Channel_Type__c='Agentes' ,Channel_Type_3__c='Agentes' ,Channel_Type_2__c='Agentes' ,Channel__c='Físico');
            insert StoreLocations;
            TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
            Order objOrder = new Order();
            objOrder.AccountId = AccList[0].Id;
            objOrder.Status = 'Draft';
            objOrder.EffectiveDate = Date.today();
            objOrder.vlocity_cmt__OriginatingChannel__c = 'WEB';
            objOrder.Delivery_Method__c = 'Delivery';
            objOrder.OwnerId = userinfo.getUserId();
            objOrder.OrderApprovalStatus__c ='Devuelto al Vendedor';
            objOrder.ApprovalUserMail__c='';
            insert objOrder;
            PageReference pageRef = Page.pagAprobalADV;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',objOrder.id);
            ApexPages.currentPage().getParameters().put('j_id0:j_id1:motivo', 'Ausencia de constancia de Afip');
            ApexPages.currentPage().getParameters().put('j_id0:j_id1:desc', 'randomData');
            Test.startTest();
                TaOrderController OrderCtrl = new TaOrderController();
                OrderCtrl.devolverOrderADV();
                OrderCtrl.rechazarOrderADV();
            Test.stopTest();
        }


        @isTest
        static void testDeliveryMethods(){
            Map<String,Object> inputMap = new Map<String,Object>();
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            List<Account> lstAccount = TestDataFactory.createAccounts(1, 'Consumer');
            List<Order> ordList = TestDataFactory.createOrders(1,lstAccount[0]);
            options.put('orderId', ordList[0].Id);
            options.put('deliveryMethodService','Standard');
            List<Product2> prods = new List<Product2>();
            Product2 a = new Product2(Name='Envio', ProductCode='FAN_ENV_000', Tangible__c = true, vlocity_cmt__Type__c='TestType', IsActive = true);
            prods.add(a);
            Product2 b = new Product2(Name='Envio Standard', ProductCode='FAN_ENV_001', Tangible__c = true, vlocity_cmt__Type__c='TestType', IsActive = true);
            prods.add(b);
            insert prods;

            Pricebook2 standardPB = new Pricebook2(Id = Test.getStandardPricebookId(), Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true); 
            update standardPB;
            List<PricebookEntry> pricebookList = new List<PricebookEntry>();
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prods[0].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            pricebookList.add(standardPrice);
            PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prods[1].Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            pricebookList.add(standardPrice2);
            insert pricebookList;

            Test.startTest();
                TaOrderController OrderCtrl = new TaOrderController();
                OrderCtrl.invokeMethod('AddToCartItemsDelivery',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('AddToCartItemsDeliveryChild',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('DeleteCartItemsDelivery',inputMap ,outMap,options);
                OrderCtrl.invokeMethod('DeleteCartItemsDeliveryChild',inputMap ,outMap,options);
                
            Test.stopTest();
        }
        /*
        static testmethod void CancelOrderAndRelease_Test (){      
          Order objOrder = new Order();
          List<Account> AccList = TestDataFactory.createAccounts(1);
          objOrder.AccountId = AccList[0].Id;
          objOrder.Status = 'Draft';
          objOrder.EffectiveDate = Date.today() - 1 ;
          objOrder.vlocity_cmt__OriginatingChannel__c = 'WEB';
          objOrder.Delivery_Method__c = 'Delivery';
          insert objOrder;
          
          List<Order> ordList = new List<Order>();
          ordList.add(objOrder);
            
          Test.startTest();
              taOrderController.CancelOrderAndRelease(ordList);
          Test.stopTest();
        }
    */
      

    }