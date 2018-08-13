@isTest
public with sharing class taSalesStockAvailabilityTest {

	public static testmethod void unitTest1() {
		Map<String,Object> inputMap = new Map<String,Object>();
		Map<String,Object> typeAheadBlock = new Map<String,Object>();
		String id = 'Test';
		typeAheadBlock.put('Id', id);
		inputMap.put('TypeAheadProducto-Block',typeAheadBlock);
		Test.startTest();
		taSalesStockAvailability tssa = new taSalesStockAvailability();
		tssa.invokeMethod('SearchProduct', inputMap, null, null);
		tssa.invokeMethod('SearchProduct', null, null, null);
		tssa.invokeMethod(' ', null, null, null);
		tssa.invokeMethod(null, null, null, null);
		Test.stopTest();

		
	}
    
	public static testmethod void unitTest2() {
		Map<String,Object> inputMap = new Map<String,Object>();
		Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>(); 
		Map<String,Object> typeAheadBlock = new Map<String,Object>();
		String id = 'Test';
        // ProdutCode, stockProdCode
		typeAheadBlock.put('Id', id);
        options.put('ProdutCode', '123');
        options.put('stockProdCode', '123');
		inputMap.put('TypeAheadProducto-Block',typeAheadBlock);
		string args = '[{"codDeposito":"123456","listaCodNMU":[{"listaPorCodigoStock":[{"stockProducto":"123","cantidadDiponible":123}],"codNMU":"123"}]}]';
		List<Object> lstDeposito = (List<Object>)JSON.deserializeUntyped(args);
		options.put('listaDepositosConDisponibilidad',lstDeposito);
		
		//TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        List<Account> account = TestDataFactory.createAccounts(1, 'Consumer');
		
		
		vlocity_cmt__BusinessSite__c bs = new vlocity_cmt__BusinessSite__c();
		bs.Name = 'NameWarehouse';
		bs.AssociatedWarehouseId__c = '123456';
		bs.vlocity_cmt__OrganizationId__c=account[0].Id;
		insert bs; 
		
		Test.startTest();
		taSalesStockAvailability tssa = new taSalesStockAvailability();
		tssa.invokeMethod('ParseIF221', inputMap, outMap, options);
		tssa.invokeMethod('ParseIF221', null, null, null);
		tssa.invokeMethod(' ', null, null, null);
		tssa.invokeMethod(null, null, null, null);
		Test.stopTest();

		
	}
}