@isTest
private class GP_Reglas_ListController_test {
    private static testMethod void testQuery() {
        GP_Regla__c testRegla = new GP_Regla__c();
        testRegla.Name = 'regla 1';
        insert testRegla;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(testRegla);
        GP_Reglas_ListController testClass = new GP_Reglas_ListController(sc);
        
		System.assert( testClass.listaReglas  != null);
        test.stopTest();
    }
    
    /*
    private static testMethod void testSave() {
        GP_Regla__c testRegla = new GP_Regla__c();
        testRegla.Name = 'regla 1';
        insert testRegla;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(testRegla);
        GP_Reglas_ListController testClass = new GP_Reglas_ListController(sc);
        PageReference result = testClass.saveAndReturnToList();
        system.assert( result != null );
        test.stopTest();
    }
    */

    private static testMethod void testDelete() {
        GP_Regla__c testRegla = new GP_Regla__c();
        testRegla.Name = 'regla 1';
        insert testRegla;
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(testRegla);
        GP_Reglas_ListController testClass = new GP_Reglas_ListController(sc);
        testClass.IdRegla = testRegla.Id;
        testClass.borrarRegla();
        Integer cantReglas = [Select Count() From GP_Regla__c Where Id = :testRegla.Id];
        system.assert( cantReglas == 0 );
        test.stopTest();
    }

}