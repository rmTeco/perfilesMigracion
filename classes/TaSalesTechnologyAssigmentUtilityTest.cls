@isTest
public with sharing class TaSalesTechnologyAssigmentUtilityTest {
	public static testmethod void testGetHighestPriority(){
		Map<String,Object> inputMap = new Map<String,Object>();
		List<Object> priorities = new List<Object>();
		Map<String, Object> priority1 = new Map<String, Object>();
		priority1.put('Prioridad', 1);
		priorities.add(priority1);
		inputMap.put('priorities', priorities);
		Test.startTest();
		TaSalesTechnologyAssigmentUtility tasta = new TaSalesTechnologyAssigmentUtility();
		tasta.invokeMethod('nothing', null, null, null);
		tasta.invokeMethod('GetHighestPriority', inputMap, null, null);
		Test.stopTest();
	}

	public static testmethod void testGetPrefeasibilityResultTransform(){
		Account acc = new Account(Name = 'test');
		insert acc;
		Order ord = new Order(AccountId = acc.Id, EffectiveDate = date.today(), Status = 'Draft');
		ord.PrefeasibilityResult__c = '{"tecnologiasAcceso":[{"tecnologia":"TEST","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Un Servicio","standardsTecnico":[{"standardTecnico":"NUMS","medicionDeBajada":0,"disponibilidad":"NO"},{"standardTecnico":"ADSL","medicionDeBajada":0,"disponibilidad":"NO"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"NGN","medicionDeBajada":0,"disponibilidad":"NO"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"},{"tecnologia":"FIBRA","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Internet","standardsTecnico":[{"standardTecnico":"GPON","medicionDeBajada":0,"disponibilidad":"SI"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"GPON","medicionDeBajada":0,"disponibilidad":"F"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"},{"tecnologia":"GSMF","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Internet","standardsTecnico":[{"standardTecnico":"GSM","medicionDeBajada":0,"disponibilidad":"NO"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"GSM","medicionDeBajada":0,"disponibilidad":"NO"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"}],"servicios":{}}';
		
		insert ord;
		//Map<String,Object> inputMap = new Map<String,Object>();
		Map<String, Object> options = new Map<String,Object>();
		options.put('OrderId', ord.Id);
		options.put('CategoryService', 'Internet');
		Test.startTest();
		TaSalesTechnologyAssigmentUtility tasta = new TaSalesTechnologyAssigmentUtility();
		tasta.invokeMethod('GetPrefeasibilityResultTransform', null, null, options);
		Test.stopTest();
	}

	public static testmethod void testAssingTechnology(){
		String jsonattr = '{"TA Linea Basica":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu7wUAA","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"ATT_000040","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Standard Tecnico","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCiUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"NGM","value":"NGM"},{"id":2,"displayText":"TDM","value":"TDM"},{"id":3,"displayText":"GPON","value":"GPON"},{"id":4,"displayText":"MTA","value":"MTA"},{"id":5,"displayText":"2G","value":"2G"},{"id":6,"displayText":"3G","value":"3G"},{"id":7,"displayText":"4G","value":"4G"}],"default":[{"id":5,"displayText":"2G","value":"2G"}],"selectedItem":{"id":5,"displayText":"2G","value":"2G"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pogXUAQ","attributecategoryid__c":"a0F6C000000BaAWUA0","categorycode__c":"TA Linea Basica","categoryname__c":"TA Linea Basica","attributeuniquecode__c":"Tecnología","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tecnologia","displaysequence__c":"11","categorydisplaysequence__c":11.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhChUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"id":1,"displayText":"Cobre","value":"Cobre"},{"id":2,"displayText":"Fibra","value":"Fibra"},{"id":3,"displayText":"MTA","value":"MTA"},{"id":4,"displayText":"GSMF","value":"GSMF"}],"default":[{"id":4,"displayText":"GSMF","value":"GSMF"}],"selectedItem":{"id":4,"displayText":"GSMF","value":"GSMF"}},"$$AttributeDefinitionEnd$$":null}],"CHAR":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu9iUAA","attributecategoryid__c":"a0F6C000000Ba5dUAC","categorycode__c":"CHAR","categoryname__c":"Characteristics","attributeuniquecode__c":"ATT_000110","attributeconfigurable__c":true,"attributedisplaysequence__c":"20","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Susceptible de Cita","displaysequence__c":"100","categorydisplaysequence__c":100.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCjUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"Selected","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null}],"ATTCAT_000200":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5IUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000020","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Download Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":10.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCeUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"10","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"10","value":10},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu5NUAQ","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000030","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Unidad de Medida de Velocidad","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCgUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"MB","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"MB","value":"MB"},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000pu58UAA","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000010","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Upload Speed","displaysequence__c":"30","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":1.0,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhCfUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"1","valuedatatype__c":"Number","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Number","default":"1","value":1},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t6C000000ZhApQAK","attributeid__c":"a0G6C000000puAHUAY","attributecategoryid__c":"a0F6C000000BnUFUA0","categorycode__c":"ATTCAT_000200","categoryname__c":"FAN Velocidad","attributeuniquecode__c":"ATT_000120","attributeconfigurable__c":true,"attributedisplaysequence__c":"30","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Real Download Speed","displaysequence__c":"300","categorydisplaysequence__c":300.0,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D6C000000UhTlUAK","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"","value__c":"11776_1024","valuedatatype__c":"Text","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Text","default":"11776_1024","value":"11776_1024"},"$$AttributeDefinitionEnd$$":null}]}';
		Account acc = new Account(Name = 'test');
		insert acc;
		Pricebook2 standardPB = new Pricebook2(Id = Test.getStandardPricebookId(), Name = 'Standard Price Book', Description = 'Price Book Products', IsActive = true); 
		update standardPB;

		Product2 prod = new Product2(Name='Internet', Family='Service Plan', IsActive = true, Tipo_de_Bien_de_Uso__c = 'Tangible', ProductCode = 'MODEMWIFI');
        insert prod;
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;

        Product2 prod2 = new Product2(Name='Internet', Family='Internet', IsActive = true, Tipo_de_Bien_de_Uso__c = 'Tangible');
        insert prod2;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod2.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice2;

        Order ord = new Order(AccountId = acc.Id, EffectiveDate = date.today(), Status = 'Draft', Pricebook2Id = standardPB.Id);
        ord.PrefeasibilityResult__c = '{"tecnologiasAcceso":[{"tecnologia":"TEST","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Un Servicio","standardsTecnico":[{"standardTecnico":"NUMS","medicionDeBajada":0,"disponibilidad":"NO"},{"standardTecnico":"ADSL","medicionDeBajada":0,"disponibilidad":"NO"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"NGN","medicionDeBajada":0,"disponibilidad":"NO"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"},{"tecnologia":"FIBRA","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Internet","standardsTecnico":[{"standardTecnico":"GPON","medicionDeBajada":0,"disponibilidad":"SI"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"GPON","medicionDeBajada":0,"disponibilidad":"F"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"},{"tecnologia":"GSMF","ebos":"null","armario":"null","autoconmutador":"null","cdo":{},"terminal":{},"servicios":[{"servicio":"Internet","standardsTecnico":[{"standardTecnico":"GSM","medicionDeBajada":0,"disponibilidad":"NO"}]},{"servicio":"Voz","standardsTecnico":[{"standardTecnico":"GSM","medicionDeBajada":0,"disponibilidad":"NO"}]}],"centrales":{},"codigoMensaje":"null","descMensaje":"null"}],"servicios":{}}';
        insert ord;
        OrderItem oi = new OrderItem(OrderId = ord.Id, PricebookEntryId = standardPrice.Id, Quantity = 5, UnitPrice = 10);
        oi.vlocity_cmt__JSONAttribute__c = jsonattr;
        
		insert oi;

		OrderItem oi2 = new OrderItem(OrderId = ord.Id, PricebookEntryId = standardPrice2.Id, Quantity = 5, UnitPrice = 10);
        oi2.vlocity_cmt__JSONAttribute__c = jsonattr;
        
		insert oi2;

		Product2 prod3 = new Product2(Name='Internet', Family='Fixed', IsActive = true, Tipo_de_Bien_de_Uso__c = 'Tangible');
        insert prod3;
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = prod3.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice3;

		OrderItem oi3 = new OrderItem(OrderId = ord.Id, PricebookEntryId = standardPrice3.Id, Quantity = 5, UnitPrice = 10);
        oi3.vlocity_cmt__JSONAttribute__c = jsonattr;
        
		insert oi3;

		Map<String,Object> inputMap = new Map<String,Object>();
		Map<String, Object> options = new Map<String,Object>();
		Map<String, Object> getHighestPriority = new Map<String, Object>();
		Map<String, Object> resultado = new Map<String, Object>();
		resultado.put('acceso', 'FIBRA');
		getHighestPriority.put('resultado', resultado);
		inputMap.put('GetHighestPriority', getHighestPriority);
		options.put('OrderId', ord.Id);
		Test.startTest();
		TaSalesTechnologyAssigmentUtility tasta = new TaSalesTechnologyAssigmentUtility();
		tasta.invokeMethod('AssingTechnology', inputMap, null, options);
		Test.stopTest();
	}
}