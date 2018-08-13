@isTest
public class taSalesOrderPaymentInteraction_test
{

    @IsTest static void invoke_ValidatePaymentAdjustment_OK1()
    {
        /*OrderTotal = 0 */
        String methodName = 'ValidatePaymentAdjustment';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
        List<Order> ordList = TestDataFactory.createOrders(1, account);
        Order ord1 = ordList[0];
        List<OrderItem> itemsList = new List<OrderItem>();
        Order order1 = [SELECT Id FROM Order WHERE Id=:ord1.Id];
        List<OrderItem> itemsList1 = TestDataFactory.createOrderItem(1, order1);
        System.debug(itemsList1[0]);
        itemsList1[0].vlocity_cmt__OneTimeTotal__c  = 0;
        itemsList1[0].IsBillable__c = true;
        itemsList1[0].Huawei_Invoice_Item_Sequence__c = '1';
        itemsList1[0].vlocity_cmt__EffectiveOneTimeTotal__c = 0;
        itemsList1[0].vlocity_cmt__EffectiveRecurringTotal__c = 0;
        PricebookEntry pricebook = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id=:itemsList1[0].PricebookEntryId];
        System.debug('pricebook');
        System.debug(pricebook);
        Product2 product = [SELECT Id FROM Product2 WHERE Id=:pricebook.Product2Id ];
        System.debug('product');
        System.debug(product);
        product.vlocity_cmt__Type__c = 'Simcard';
        product.Tangible__c = true;
        product.Alicuota__c = '0.21';
        product.FAN_IntegrationKey__c = 'RandomKey';
        product.NMU__c = 'RandomNMU';
        product.ProductCode = 'RandomCode';
        product.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Requerido","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
        update product;
        itemsList1[0].vlocity_cmt__Product2Id__c=product.Id;
        System.debug('Product after json atrib');
        System.debug(product);
        System.debug('Order Item ');
        System.debug(itemsList1[0]);
        System.debug('Order Item Product ID');
        System.debug(itemsList1[0].Product2Id);
        itemsList.add(itemsList1[0]);
        order1.Name = 'OrderTestVPA1';
        order1.BillSimulationPayload__c = '{"calculoImpuestosRespuesta":{"idCliente":"13800010033","infoResCalculoImpuestos":[{"impuestoxItemInfo":{"secuenciaProductoAdquirido":"1","listaInfoImpuestos":[{"infoImpuesto":{"codImpuesto":"IMP21","importeImpuestoAplicado":"96.67","precioBase":"79.8935","alicuotaImpuesto":"21","tipoCategoriaImpositiva":"IVA","codMoneda":"ARS"}}],"importeItemComprobante":"96.67"}}],"importeComprobante":"96.67"}}';
        update itemsList;
        update order1;
        System.debug(order1);
        taSalesOrderPaymentInteraction testedClass = new taSalesOrderPaymentInteraction();
        options.put('IdOrder', order1.Id);

        InvoiceTypeHuawei__c ivts = new InvoiceTypeHuawei__c();
        ivts.Name='InvoiceTypeHuawei';
        ivts.Electronico__c='12';
        ivts.Fiscal__c='11';
        insert ivts;

        HW_Charge_Code_Taxes_CFT__c cs = new HW_Charge_Code_Taxes_CFT__c();
        cs.Name='Default';
        cs.Charge_Code__c='FAN_CFT_IVA_21';
        cs.Description__c='CFT IVA 21%';
        insert cs;

        Test.startTest();
        testedClass.invokeMethod(methodName, input, outMap, options);
        testedClass.invokeMethod('SendPayment', input, outMap, options);
        Test.stopTest();

        vlocity_cmt__PaymentAdjustment__c paymentAdjustment = [SELECT Id, Order__c FROM vlocity_cmt__PaymentAdjustment__c LIMIT 1 ];

        system.assertEquals(paymentAdjustment.Order__c, order1.Id);

    }

    @IsTest static void invoke_SendPayment_OK1()
    {
        /* OrderTotal > 0 */
        String methodName = 'SendPayment';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
        List<Order> ordList = TestDataFactory.createOrders(1, account);
        Order ord1 = ordList[0];
        List<OrderItem> itemsList = new List<OrderItem>();
        Order order1 = [SELECT Id FROM Order WHERE Id=:ord1.Id];
        List<OrderItem> itemsList1 = TestDataFactory.createOrderItem(1, order1);
        System.debug(itemsList1[0]);
        itemsList1[0].vlocity_cmt__OneTimeTotal__c  = 100;
        itemsList1[0].IsBillable__c = true;
        itemsList1[0].vlocity_cmt__Action__c = 'Add';

        itemsList1[0].Huawei_Invoice_Item_Sequence__c = '1';
        itemsList1[0].vlocity_cmt__EffectiveOneTimeTotal__c =90;
        itemsList1[0].vlocity_cmt__EffectiveRecurringTotal__c = 10;
        PricebookEntry pricebook = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id=:itemsList1[0].PricebookEntryId];
        System.debug('pricebook');
        System.debug(pricebook);
        Product2 product = [SELECT Id FROM Product2 WHERE Id=:pricebook.Product2Id ];
        System.debug('product');
        System.debug(product);
        product.vlocity_cmt__Type__c = 'Simcard';
        product.Tangible__c = true;
        product.Alicuota__c = '0.21';
        product.FAN_IntegrationKey__c = 'RandomKey';
        product.NMU__c = 'RandomNMU';
        product.ProductCode = 'RandomCode';
        product.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Requerido","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
        update product;
        itemsList1[0].vlocity_cmt__Product2Id__c=product.Id;
        itemsList.add(itemsList1[0]);
        order1.Name = 'OrderTestVPA1';
        order1.BillSimulationPayload__c = '{"calculoImpuestosRespuesta":{"idCliente":"13800010033","infoResCalculoImpuestos":[{"impuestoxItemInfo":{"secuenciaProductoAdquirido":"1","listaInfoImpuestos":[{"infoImpuesto":{"codImpuesto":"IMP21","importeImpuestoAplicado":"96.67","precioBase":"79.8935","alicuotaImpuesto":"21","tipoCategoriaImpositiva":"IVA","codMoneda":"ARS"}}],"importeItemComprobante":"96.67"}}],"importeComprobante":"96.67"}}';
        update itemsList;
        update order1;
        System.debug(order1);
        taSalesOrderPaymentInteraction testedClass = new taSalesOrderPaymentInteraction();
        options.put('IdOrder', order1.Id);

        InvoiceTypeHuawei__c ivts = new InvoiceTypeHuawei__c();
        ivts.Name='InvoiceTypeHuawei';
        ivts.Electronico__c='12';
        ivts.Fiscal__c='11';
        insert ivts;

        HW_Charge_Code_Taxes_CFT__c cs = new HW_Charge_Code_Taxes_CFT__c();
        cs.Name='Default';
        cs.Charge_Code__c='FAN_CFT_IVA_21';
        cs.Description__c='CFT IVA 21%';
        insert cs;

        Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '2001',
            vlocity_cmt__AccountId__c = account.Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethod;
        TestDataFactory.createFinancialPromotionsCreditCard();
        FinancialPromotion__c financialP = [SELECT Id FROM FinancialPromotion__c LIMIT 1 ];
        financialP.InstalmentPlan__c = 1;
        update financialP;
        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentList = TestDataFactory.createPaymentAdjustments(1, account, order1, objPaymentMethod, 3);
        paymentAdjustmentList[0].vlocity_cmt__Amount__c = 100;
        paymentAdjustmentList[0].vlocity_cmt__InstallmentAmount__c = 10;
        paymentAdjustmentList[0].Huawei_Invoice_Item_Sequence__c = '1';
        paymentAdjustmentList[0].Financial_Promotion__c = financialP.Id;
        update paymentAdjustmentList;

        Test.startTest();
        testedClass.invokeMethod('SendPayment', input, outMap, options);
        Test.stopTest();

        vlocity_cmt__PaymentAdjustment__c paymentAdjustment = [SELECT Id, Order__c FROM vlocity_cmt__PaymentAdjustment__c LIMIT 1 ];

        system.assertEquals(paymentAdjustment.Order__c, order1.Id);

    }

    @IsTest static void invoke_SendPayment_OK2()
    {
        /* OrderTotal > 0 */
        String methodName = 'SendPayment';
        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
        Map<string, Object> map1 = new Map<string, Object>();
        Map<string, Object> ouput = new Map<string, Object>();
        map1.put('numeroComprobante','565452624');
        options.put('IPResult',map1);
        Account account = TestDataFactory.createAccounts(1, 'Consumer')[0];
        List<Order> ordList = TestDataFactory.createOrders(1, account);
        Order ord1 = ordList[0];
        List<OrderItem> itemsList = new List<OrderItem>();
        Order order1 = [SELECT Id FROM Order WHERE Id=:ord1.Id];
        List<OrderItem> itemsList1 = TestDataFactory.createOrderItem(1, order1);
        System.debug(itemsList1[0]);
        itemsList1[0].vlocity_cmt__OneTimeTotal__c  = 100;
        itemsList1[0].IsBillable__c = true;
        itemsList1[0].vlocity_cmt__Action__c = 'Add';

        itemsList1[0].Huawei_Invoice_Item_Sequence__c = '1';
        itemsList1[0].vlocity_cmt__EffectiveOneTimeTotal__c =90;
        itemsList1[0].vlocity_cmt__EffectiveRecurringTotal__c = 10;
        PricebookEntry pricebook = [SELECT Id, Product2Id FROM PricebookEntry WHERE Id=:itemsList1[0].PricebookEntryId];
        System.debug('pricebook');
        System.debug(pricebook);
        Product2 product = [SELECT Id FROM Product2 WHERE Id=:pricebook.Product2Id ];
        System.debug('product');
        System.debug(product);
        product.vlocity_cmt__Type__c = 'Simcard';
        product.Tangible__c = true;
        product.Alicuota__c = '0.21';
        product.FAN_IntegrationKey__c = 'RandomKey';
        product.NMU__c = 'RandomNMU';
        product.ProductCode = 'RandomCode';
        product.vlocity_cmt__JSONAttribute__c = '{"FAN_ATTCAT_000042":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwkBUAQ","attributecategoryid__c":"a0F6C000000BoqlUAC","categorycode__c":"FAN_ATTCAT_000042","categoryname__c":"Integracion","attributeuniquecode__c":"FAN_ATT_000084","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Charge Code","displaysequence__c":"31","categorydisplaysequence__c":31,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":true,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPvUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":"C_OT_MB_EQUIPMENT_SIM","valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","default":[{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"}],"values":[{"displayText":"Telefono","id":10,"value":"C_OT_MB_EQUIPMENT_PHONES"},{"displayText":"Modem","id":20,"value":"C_OT_MB_EQUIPMENT_MODEMS"},{"displayText":"SIM","id":30,"value":"C_OT_MB_EQUIPMENT_SIM"},{"displayText":"Accesorio","id":40,"value":"C_OT_MB_EQUIPMENT_ACCESORIOS"},{"displayText":"Netbook","id":50,"value":"C_OT_MB_EQUIPMENT_NETBOOK"}]},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000045":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwHOUAY","attributecategoryid__c":"a0F6C000000Bor5UAC","categorycode__c":"FAN_ATTCAT_000045","categoryname__c":"Caracteristicas Principales","attributeuniquecode__c":"FAN_ATT_000068","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Facturable en Venta","displaysequence__c":"71","categorydisplaysequence__c":71,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqPxUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Requerido","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"true"},"$$AttributeDefinitionEnd$$":null}],"FAN_ATTCAT_000048":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZuacQAC","attributeid__c":"a0G6C000000pwIbUAI","attributecategoryid__c":"a0F6C000000BovEUAS","categorycode__c":"FAN_ATTCAT_000048","categoryname__c":"Caracteristicas Simcard","attributeuniquecode__c":"FAN_ATT_000070","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"NMU Simcard","displaysequence__c":"95","categorydisplaysequence__c":95,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UqQ3UAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Simcard Magenta: (3FF Micro SIM)","id":10,"value":"PTP3FFMMI"},{"displayText":"Simcard Cyan: (2FF Bolsita)","id":20,"value":"PTP2FFCCI"},{"displayText":"Simcard Violeta: (4FF Nano SIM)","id":30,"value":"PTP4FFVNI"},{"displayText":"Simcard Cyan 2FF/3FF Bolsita comunes","id":40,"value":"PTP23FFCI"},{"displayText":"Usimcard Triple Corte Bolsita","id":50,"value":"PTPBOLTCI"}],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
        update product;
        itemsList1[0].vlocity_cmt__Product2Id__c=product.Id;
        itemsList.add(itemsList1[0]);
        Id idRecordType = Schema.SObjectType.vlocity_cmt__BusinessSite__c.getRecordTypeInfosByName().get('Punto de venta OC').getRecordTypeId();
        vlocity_cmt__BusinessSite__c StoreLocations = new vlocity_cmt__BusinessSite__c(RecordTypeId=idRecordType, vlocity_cmt__OrganizationId__c=account.id ,PointOfSaleId__c=1.0, AssociatedWarehouseDefault__c='Default', BillingMode__c = 'Fiscal');
        insert StoreLocations;
        order1.Name = 'OrderTestVPA1';
        order1.BillSimulationPayload__c = '{"calculoImpuestosRespuesta":{"idCliente":"13800010033","infoResCalculoImpuestos":[{"impuestoxItemInfo":{"secuenciaProductoAdquirido":"1","listaInfoImpuestos":[{"infoImpuesto":{"codImpuesto":"IMP21","importeImpuestoAplicado":"96.67","precioBase":"79.8935","alicuotaImpuesto":"21","tipoCategoriaImpositiva":"IVA","codMoneda":"ARS"}}],"importeItemComprobante":"96.67"}}],"importeComprobante":"96.67"}}';
        order1.Delivery_Method__c = 'Store Pick Up';
        order1.PickUpStoreLocation__c = StoreLocations.Id; 
        update itemsList;
        update order1;
        System.debug(order1);
        taSalesOrderPaymentInteraction testedClass = new taSalesOrderPaymentInteraction();
        options.put('IdOrder', order1.Id);

        InvoiceTypeHuawei__c ivts = new InvoiceTypeHuawei__c();
        ivts.Name='InvoiceTypeHuawei';
        ivts.Electronico__c='12';
        ivts.Fiscal__c='11';
        insert ivts;

        HW_Charge_Code_Taxes_CFT__c cs = new HW_Charge_Code_Taxes_CFT__c();
        cs.Name='Default';
        cs.Charge_Code__c='FAN_CFT_IVA_21';
        cs.Description__c='CFT IVA 21%';
        insert cs;

        Vlocity_cmt__PaymentMethod__c objPaymentMethod = new Vlocity_cmt__PaymentMethod__c(
            vlocity_cmt__MethodType__c = '2001',
            vlocity_cmt__AccountId__c = account.Id,
            vlocity_cmt__IsActive__c = true);
        insert objPaymentMethod;
        TestDataFactory.createFinancialPromotionsCreditCard();
        FinancialPromotion__c financialP = [SELECT Id FROM FinancialPromotion__c LIMIT 1 ];
        financialP.InstalmentPlan__c = 1;
        update financialP;
        List<vlocity_cmt__PaymentAdjustment__c> paymentAdjustmentList = TestDataFactory.createPaymentAdjustments(1, account, order1, objPaymentMethod, 3);
        paymentAdjustmentList[0].vlocity_cmt__Amount__c = 100;
        paymentAdjustmentList[0].vlocity_cmt__InstallmentAmount__c = 10;
        paymentAdjustmentList[0].Huawei_Invoice_Item_Sequence__c = '1';
        paymentAdjustmentList[0].Financial_Promotion__c = financialP.Id;
        update paymentAdjustmentList;

        Test.startTest();
        testedClass.invokeMethod('SendPayment', input, outMap, options);
        Test.stopTest();

        vlocity_cmt__PaymentAdjustment__c paymentAdjustment = [SELECT Id, Order__c FROM vlocity_cmt__PaymentAdjustment__c LIMIT 1 ];

        system.assertEquals(paymentAdjustment.Order__c, order1.Id);

    }

}