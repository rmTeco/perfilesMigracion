@isTest
private class Attribute_Binding_Class_Test {
	
	@isTest static void test_method_one() {
		Attributes_Binding__c ab = new Attributes_Binding__c();
		ab.Name = 'Attribute Binding';
		ab.Object__c = 'Asset';
		ab.Active__c = true;
		insert ab;

		Account acc = new Account();
		acc.Name = 'Account';
		insert acc;

		List<Asset> assets = new List<Asset>();
		Asset a = new Asset(Name = 'asset', AccountId = acc.Id);
		insert a;
		assets.add(a);

		Map<Id, Asset> oldMap = new Map<Id, Asset>();
		oldMap.put(a.Id, a);


		Test.startTest();

		Attribute_Binding_Class.ins(assets);

		Attribute_Binding_Class.upd(oldMap, assets);

		Test.stopTest();
	}
	
}