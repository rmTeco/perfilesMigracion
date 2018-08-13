@isTest
public with sharing class ta_sales_productSearchTest {
	public static testmethod void unitTest1() {
		Test.startTest();
		ta_sales_productSearch tssa = new ta_sales_productSearch();
		tssa.invokeMethod('PopulateProductsTypeAhead', null, null, null);
		Test.stopTest();
	}
}