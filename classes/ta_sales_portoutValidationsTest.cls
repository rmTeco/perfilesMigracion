@isTest
global class ta_sales_portoutValidationsTest {
    
    @isTest
  static void test1() {
      
      Map<String,Object> inpMap = new Map<String,Object>();
      Map<String,Object> outMap = new Map<String,Object>();
      Map<String,Object> options = new Map<String,Object>();
      
      Asset ast = new Asset();
      ast.name = 'Astest';
      ast.vlocity_cmt__Action__c = 'Existing';
      ast.AccountId = TestDataFactory.createAccounts(1)[0].Id;
      insert ast;
      
      options.put('assetId', ast.id);
      
      ta_sales_portoutValidations poValidations = new ta_sales_portoutValidations();
      poValidations.invokeMethod('PortoutInProgressNomination', inpMap, outMap, options);
      poValidations.invokeMethod('PortoutInProgressVenta', inpMap, outMap, options);
      poValidations.invokeMethod('PortoutInProgressCompraDePack', inpMap, outMap, options);
      poValidations.invokeMethod('PortoutInProgressCambioDeSim', inpMap, outMap, options);
      poValidations.invokeMethod('PortoutInProgressCambioDeEquipo', inpMap, outMap, options);
      poValidations.invokeMethod('PortoutInProgressCambioDePlan', inpMap, outMap, options);
      poValidations.invokeMethod('PortoutInProgressAltaBajaServicios', inpMap, outMap, options);

  }

}