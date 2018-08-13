@IsTest
public class AssetService_test {
	
	@TestSetup static void creatingTestingData() {
		//generate()
		Id consumerRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Consumer' LIMIT 1].Id;
        Id billingRecordTypeForAcc = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'Billing' LIMIT 1].Id;
    	Account acc = new Account(RecordTypeId = consumerRecordTypeForAcc, Name = 'Sample Account', AccountNumber = '1234', DocumentType__c = 'DNI', DocumentNumber__c = '12345678');
        insert acc;

        Asset ass = new Asset(Name = 'asset1', vlocity_cmt__LineNumber__c = '1234567890', AccountId = acc.Id);
        insert ass;

        Contact contact = new Contact(FirstName = 'Contact First Name', LastName = 'Contact LastName', DocumentType__c = 'DNI', DocumentNumber__c = '12345678', Email = 'test@yopmail.com', AccountId = acc.id);
        insert contact;

        acc.vlocity_cmt__PrimaryContactId__c = contact.Id;
        update acc;

        Account billingAcc = new Account(RecordTypeId = billingRecordTypeForAcc, Name = 'Sample Billing Account');
        insert billingAcc;

        Asset ass2 = new Asset(Name = 'asset2', vlocity_cmt__LineNumber__c = '1234567890', AccountId = billingAcc.Id);
        insert ass2;

        List<Product2> productsList = new List<Product2>();
        productsList.add(new Product2(Name = 'Sample Product 1', Family = 'prepaid', vlocity_cmt__Type__c = 'Simcard'));
        productsList.add(new Product2(Name = 'Sample Product 2', Family = 'prepaid', vlocity_cmt__Type__c = 'Simcard'));
        insert productsList;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productsList.get(0).Id, UnitPrice = 100, IsActive = true);
        insert standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = productsList.get(1).Id, UnitPrice = 10, IsActive = true);
        insert standardPrice2;
        
        //Insert priceList
        vlocity_cmt__PriceList__c priceList = new vlocity_cmt__PriceList__c(vlocity_cmt__Code__c = 'Codigo', Name='Telecom Price List');
        insert priceList;
        
        Order order = new Order(Name='TestOrder',
							AccountId=acc.Id,
							EffectiveDate=Date.today(),
							Status='Draft',
							Pricebook2Id =pricebookId,
							vlocity_cmt__PriceListId__c=priceList.Id,
							Delivery_Method__c='Delivery',
							vlocity_cmt__OriginatingChannel__c='Agentes');
        insert order;
        
        List<OrderItem> ordItemList = new List<OrderItem>();
        ordItemList.add(new OrderItem(OrderId = order.Id, Product2Id = productsList.get(0).Id, Quantity = 10, PricebookEntryId = standardPrice1.Id, UnitPrice = 100));
        ordItemList.add(new OrderItem(OrderId = order.Id, Product2Id = productsList.get(1).Id, Quantity = 5, PricebookEntryId = standardPrice2.Id, UnitPrice = 10));
        insert ordItemList;

        Location__c loc = new Location__c(Name = 'test1', DepartmentCode__c = 'Cod', LocationCode__c = 'Test1', StateCode__c ='B', Status__c = true);
        insert loc;
        
        //generatePlanPrepago()
        //Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName = 'Consumer' LIMIT 1];

        Product2 planPrepagoRootProduct = new Product2(Name = 'Plan Prepago Root Product', vlocity_cmt__Type__c = 'Plan Prepago');
        insert planPrepagoRootProduct;
        Product2 planPrepagoFirstChildProduct = new Product2(Name = 'Plan Prepago First Child Product');
        insert planPrepagoFirstChildProduct;
        Product2 planPrepagoSecondChildProduct = new Product2(Name = 'Plan Prepago Second Child Product');
        insert planPrepagoSecondChildProduct;
        Product2 planPrepagoThirdChildProduct = new Product2(Name = 'Plan Prepago Third Child Product');
        insert planPrepagoThirdChildProduct;

        vlocity_cmt__ProductChildItem__c rootProdToFirstChildRelationship = new vlocity_cmt__ProductChildItem__c(vlocity_cmt__ParentProductId__c = planPrepagoRootProduct.Id, vlocity_cmt__ChildProductId__c = planPrepagoFirstChildProduct.Id, vlocity_cmt__ChildLineNumber__c = '1', vlocity_cmt__Quantity__c = 1);
        insert rootProdToFirstChildRelationship;
        vlocity_cmt__ProductChildItem__c firstChildProdToSecondChildRelationship = new vlocity_cmt__ProductChildItem__c(vlocity_cmt__ParentProductId__c = planPrepagoFirstChildProduct.Id, vlocity_cmt__ChildProductId__c = planPrepagoSecondChildProduct.Id, vlocity_cmt__ChildLineNumber__c = '2', vlocity_cmt__Quantity__c = 1);
        insert firstChildProdToSecondChildRelationship;
        vlocity_cmt__ProductChildItem__c secondChildProdToThirdChildRelationship = new vlocity_cmt__ProductChildItem__c(vlocity_cmt__ParentProductId__c = planPrepagoSecondChildProduct.Id, vlocity_cmt__ChildProductId__c = planPrepagoThirdChildProduct.Id, vlocity_cmt__ChildLineNumber__c = '3', vlocity_cmt__Quantity__c = 1);
        insert secondChildProdToThirdChildRelationship;

        //Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = planPrepagoRootProduct.Id, UnitPrice = 10, IsActive = true);
        insert standardPrice3;
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = planPrepagoFirstChildProduct.Id, UnitPrice = 10, IsActive = true);
        insert standardPrice4;
        PricebookEntry standardPrice5 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = planPrepagoSecondChildProduct.Id, UnitPrice = 10, IsActive = true);
        insert standardPrice5;
        PricebookEntry standardPrice6 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = planPrepagoThirdChildProduct.Id, UnitPrice = 10, IsActive = true);
        insert standardPrice6;

        //Order order = new Order(AccountId = acc.Id, Status = 'Draft', EffectiveDate = Date.today(), Pricebook2Id = pricebookId);
        //insert order;

        List<OrderItem> ordItemListPlanPrepago = new List<OrderItem>();
        ordItemListPlanPrepago.add(new OrderItem(OrderId = order.Id, Product2Id = planPrepagoRootProduct.Id, Quantity = 10, PricebookEntryId = standardPrice1.Id, UnitPrice = 100));
        ordItemListPlanPrepago.add(new OrderItem(OrderId = order.Id, Product2Id = planPrepagoFirstChildProduct.Id, Quantity = 5, PricebookEntryId = standardPrice2.Id, UnitPrice = 10));
        ordItemListPlanPrepago.add(new OrderItem(OrderId = order.Id, Product2Id = planPrepagoSecondChildProduct.Id, Quantity = 5, PricebookEntryId = standardPrice3.Id, UnitPrice = 10));
        ordItemListPlanPrepago.add(new OrderItem(OrderId = order.Id, Product2Id = planPrepagoThirdChildProduct.Id, Quantity = 5, PricebookEntryId = standardPrice4.Id, UnitPrice = 10));
        insert ordItemListPlanPrepago;
        
	}
	
	@IsTest static void invoke_GetPlanAssetsByAccountId(){
    	String methodName = 'GetPlanAssetsByAccountId';

        Map<String, Object> input = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();
				//options.put('PlanAssets','[{"Balance":{"totalUnidadesLibres":{"unidadLibre":[{"freeUnitCode":"Voz","remainingSecondaryUnits":38,"remainingPrimaryUnits":107,"fechaVigenciaHastaProdAdq":"2017-10-31 10:10:10","cantUnidadesRemanentes":6458,"codUnidadDeMedida":"SEGUNDOS","codUsoUnidadesLibres":"Voice"},{"freeUnitCode":null,"remainingSecondaryUnits":null,"remainingPrimaryUnits":null,"fechaVigenciaHastaProdAdq":"2017-11-31 10:10:10","cantUnidadesRemanentes":200,"codUnidadDeMedida":"ITEMS","codUsoUnidadesLibres":"SMS"},{"freeUnitCode":"Internet","remainingSecondaryUnits":1014,"remainingPrimaryUnits":56,"fechaVigenciaHastaProdAdq":"2017-12-31 10:10:10","cantUnidadesRemanentes":58358,"codUnidadDeMedida":"KB","codUsoUnidadesLibres":"Data"}]},"totalesBalance":{"fechaExpiracionBalance":"string","proximaFechaExpiracionBalance":"string","saldoSuscripcionRegalado":300,"saldoSuscripcionComprado":0,"saldoBalance":200},"ofertaPrincipal":{"descripcionProducto":" ","nombreProducto":"Plan Nacional Prepago","codProducto":0},"marcaSuspensionActiva":"FuncionSobreStatusDetail","estadoSuscripcion":"Activa","identificadorRecurso":"1138305304"},"Product":{"Name":"Conexión Total Libre M"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Pospago","TipoProducto":"Plan Pospago","Name":"DefaultNewAssets","Family":"Movil","AssetId":"02i6C000000Ehu1QAC","CreatedDate":"2018-02-21T01:30:43.000Z","Blacklist":false,"Sub_Status":"null"},{"Balance":{"totalUnidadesLibres":{"unidadLibre":[{"freeUnitCode":"Voz","remainingSecondaryUnits":38,"remainingPrimaryUnits":107,"fechaVigenciaHastaProdAdq":"2017-10-31 10:10:10","cantUnidadesRemanentes":6458,"codUnidadDeMedida":"SEGUNDOS","codUsoUnidadesLibres":"Voice"},{"freeUnitCode":null,"remainingSecondaryUnits":null,"remainingPrimaryUnits":null,"fechaVigenciaHastaProdAdq":"2017-11-31 10:10:10","cantUnidadesRemanentes":200,"codUnidadDeMedida":"ITEMS","codUsoUnidadesLibres":"SMS"},{"freeUnitCode":"Internet","remainingSecondaryUnits":1014,"remainingPrimaryUnits":56,"fechaVigenciaHastaProdAdq":"2017-12-31 10:10:10","cantUnidadesRemanentes":58358,"codUnidadDeMedida":"KB","codUsoUnidadesLibres":"Data"}]},"totalesBalance":{"fechaExpiracionBalance":"string","proximaFechaExpiracionBalance":"string","saldoSuscripcionRegalado":300,"saldoSuscripcionComprado":0,"saldoBalance":200},"ofertaPrincipal":{"descripcionProducto":" ","nombreProducto":"Plan Nacional Prepago","codProducto":0},"marcaSuspensionActiva":"FuncionSobreStatusDetail","estadoSuscripcion":"Activa","identificadorRecurso":"1138305304"},"Product":{"Name":"Conexión Total Libre M"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Pospago","ActivationDate":"2017-12-13","TipoProducto":"Plan Pospago","Status":"Active","Name":"Plan Pospago Movil","Family":"Movil","AssetId":"02i6C0000002cmMQAQ","CreatedDate":"2017-11-29T14:58:29.000Z","Blacklist":false,"Sub_Status":"null"},{"Product":{"Name":"Plan Internet 10GB"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Pospago","TipoProducto":"Plan Pospago","Status":"Active","Name":"Plan Internet 10GB","Family":"Movil","AssetId":"02i6C0000002cmWQAQ","CreatedDate":"2017-11-29T20:45:33.000Z","LineNumber":"1138305304","Blacklist":false,"Sub_Status":"null"},{"Product":{"Name":"Plan Internet 10GB"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Pospago","TipoProducto":"Plan Pospago","Name":"Plan Internet 10GB","Family":"Movil","AssetId":"02i6C0000002cmRQAQ","CreatedDate":"2017-11-29T20:09:06.000Z","Blacklist":false,"Sub_Status":"null"},{"Product":{"Name":"Black Conexion Total Libre 2XL"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Pospago","TipoProducto":"Plan Pospago","Name":"Black Conexion Total Libre 2XL","Family":"Movil","AssetId":"02i6C0000002eKIQAY","CreatedDate":"2017-12-22T13:17:23.000Z","Blacklist":false,"Sub_Status":"null"},{"Product":{"Name":"Plan Prepago Nacional"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Prepago","TipoProducto":"Plan Prepago","Status":"Active","Name":"Plan Prepago Nacional","Family":"Movil","AssetId":"02i6C0000002h6LQAQ","CreatedDate":"2018-01-22T20:21:28.000Z","LineNumber":"234454","Blacklist":false,"Sub_Status":"null"}]');

				options.put('PlanAssets','[{"Balance":{"totalUnidadesLibres":{"unidadLibre":[{"freeUnitCode":"Voz","remainingSecondaryUnits":38,"remainingPrimaryUnits":107,"fechaVigenciaHastaProdAdq":"2017-10-31 10:10:10","cantUnidadesRemanentes":6458,"codUnidadDeMedida":"SEGUNDOS","codUsoUnidadesLibres":"Voice"},{"freeUnitCode":null,"remainingSecondaryUnits":null,"remainingPrimaryUnits":null,"fechaVigenciaHastaProdAdq":"2017-11-31 10:10:10","cantUnidadesRemanentes":200,"codUnidadDeMedida":"ITEMS","codUsoUnidadesLibres":"SMS"},{"freeUnitCode":"Internet","remainingSecondaryUnits":1014,"remainingPrimaryUnits":56,"fechaVigenciaHastaProdAdq":"2017-12-31 10:10:10","cantUnidadesRemanentes":58358,"codUnidadDeMedida":"KB","codUsoUnidadesLibres":"Data"}]},"totalesBalance":{"fechaExpiracionBalance":"string","proximaFechaExpiracionBalance":"string","saldoSuscripcionRegalado":300,"saldoSuscripcionComprado":0,"saldoBalance":200},"ofertaPrincipal":{"descripcionProducto":" ","nombreProducto":"Plan Nacional Prepago","codProducto":0},"marcaSuspensionActiva":"FuncionSobreStatusDetail","estadoSuscripcion":"Activa","identificadorRecurso":"1138305304"},"Product":{"Name":"Conexión Total Libre M"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Pospago","TipoProducto":"Plan Pospago","Name":"DefaultNewAssets","Family":"Movil","AssetId":"02i6C000000Ehu1QAC","CreatedDate":"2018-02-21T01:30:43.000Z","Blacklist":false,"Sub_Status":"null"}]');
				//MockupFactory.generate();
				//MockupFactory.generatePlanPrepago();

        AssetService asset = new AssetService();

        String mockResponse = '{ "totalUnidadesLibres": { "unidadLibre": [ { "fechaVigenciaHastaProdAdq": "2017-10-31 10:10:10", "cantUnidadesRemanentes": 6458, "codUnidadDeMedida": "SEGUNDOS", "codUsoUnidadesLibres": "Voice" }, { "fechaVigenciaHastaProdAdq": "2017-11-31 10:10:10", "cantUnidadesRemanentes": 200, "codUnidadDeMedida": "ITEMS", "codUsoUnidadesLibres": "SMS" }, { "fechaVigenciaHastaProdAdq": "2017-12-31 10:10:10", "cantUnidadesRemanentes": 58358, "codUnidadDeMedida": "KB", "codUsoUnidadesLibres": "Data" } ] }, "totalesBalance": { "fechaExpiracionBalance": "string", "proximaFechaExpiracionBalance": "string", "saldoSuscripcionRegalado": 300, "saldoSuscripcionComprado": 0, "saldoBalance": 200 }, "ofertaPrincipal": { "descripcionProducto": " ", "nombreProducto": "Plan Nacional Prepago", "codProducto": 0 }, "marcaSuspensionActiva": "FuncionSobreStatusDetail", "estadoSuscripcion": "Activa", "identificadorRecurso": "1138305304" }';
        VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S439', mockResponse);

        Test.startTest();
        asset.invokeMethod(methodName, input, outMap, options);
				asset.CompletePlanAssetInfo(options);
        Test.stopTest();
    }

		@IsTest static void CompletePlanAssetInfo(){
	        Map<String, Object> options = new Map<String, Object>();
					options.put('PlanAssets','[{"Balance":{"totalUnidadesLibres":{"unidadLibre":[{"freeUnitCode":"Voz","remainingSecondaryUnits":38,"remainingPrimaryUnits":107,"fechaVigenciaHastaProdAdq":"2017-10-31 10:10:10","cantUnidadesRemanentes":6458,"codUnidadDeMedida":"SEGUNDOS","codUsoUnidadesLibres":"Voice"},{"freeUnitCode":null,"remainingSecondaryUnits":null,"remainingPrimaryUnits":null,"fechaVigenciaHastaProdAdq":"2017-11-31 10:10:10","cantUnidadesRemanentes":200,"codUnidadDeMedida":"ITEMS","codUsoUnidadesLibres":"SMS"},{"freeUnitCode":"Internet","remainingSecondaryUnits":1014,"remainingPrimaryUnits":56,"fechaVigenciaHastaProdAdq":"2017-12-31 10:10:10","cantUnidadesRemanentes":58358,"codUnidadDeMedida":"KB","codUsoUnidadesLibres":"Data"}]},"totalesBalance":{"fechaExpiracionBalance":"string","proximaFechaExpiracionBalance":"string","saldoSuscripcionRegalado":300,"saldoSuscripcionComprado":0,"saldoBalance":200},"ofertaPrincipal":{"descripcionProducto":" ","nombreProducto":"Plan Nacional Prepago","codProducto":0},"marcaSuspensionActiva":"FuncionSobreStatusDetail","estadoSuscripcion":"Activa","identificadorRecurso":"1138305304"},"Product":{"Name":"Conexión Total Libre M"},"Account":{"Name":"Mariano Hernandez"},"ProductType":"Plan Pospago","TipoProducto":"Plan Pospago","Name":"DefaultNewAssets","Family":"Movil","AssetId":"02i6C000000Ehu1QAC","CreatedDate":"2018-02-21T01:30:43.000Z","Blacklist":false,"Sub_Status":"null"}]');

					//MockupFactory.generate();
					//MockupFactory.generatePlanPrepago();

	        AssetService asset = new AssetService();

            String mockResponse = '{ "totalUnidadesLibres": { "unidadLibre": [ { "fechaVigenciaHastaProdAdq": "2017-10-31 10:10:10", "cantUnidadesRemanentes": 6458, "codUnidadDeMedida": "SEGUNDOS", "codUsoUnidadesLibres": "Voice" }, { "fechaVigenciaHastaProdAdq": "2017-11-31 10:10:10", "cantUnidadesRemanentes": 200, "codUnidadDeMedida": "ITEMS", "codUsoUnidadesLibres": "SMS" }, { "fechaVigenciaHastaProdAdq": "2017-12-31 10:10:10", "cantUnidadesRemanentes": 58358, "codUnidadDeMedida": "KB", "codUsoUnidadesLibres": "Data" } ] }, "totalesBalance": { "fechaExpiracionBalance": "string", "proximaFechaExpiracionBalance": "string", "saldoSuscripcionRegalado": 300, "saldoSuscripcionComprado": 0, "saldoBalance": 200 }, "ofertaPrincipal": { "descripcionProducto": " ", "nombreProducto": "Plan Nacional Prepago", "codProducto": 0 }, "marcaSuspensionActiva": "FuncionSobreStatusDetail", "estadoSuscripcion": "Activa", "identificadorRecurso": "1138305304" }';
            VlocityIntegrationProcedureTestUtility.mockIntegrationProcedure('IFS_S439', mockResponse);

	        Test.startTest();
					asset.CompletePlanAssetInfo(options);
	        Test.stopTest();
	    }
}