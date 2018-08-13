@isTest(seeAllData = false)
global class TaCpqAppHandlerTest {

    static testMethod void TestGetCartsProducts() {
        System.debug('TestGetCartsProducts');
        MockupFactory.generate();
        taCpqAppHandler appHandler = new taCpqAppHandler();
        Map<String, Object> outMap = new Map<String, Object>();
        Order order = [SELECT Id FROM Order LIMIT 1];
        System.debug('order: ' + order);
        //String prefeasibilityResult = TaCpqAppHandlerInputMapFactoryTest.createPrefeasibilityJson();
        //order.vlocity_cmt__ValidationMessage__c = '1234567890';
        //order.PrefeasibilityResult__c = prefeasibilityResult;
        //update order;
        
        Map<String, Object> inputMap = TaCpqAppHandlerInputMapFactoryTest.generateInputMap();
        inputMap.put('cartId', order.Id);
      
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IFS089DisponibilidadMockHttp());
        appHandler.invokeMethod('getCartsProducts', inputMap, outMap, null);
        appHandler.invokeMethod('processPrefaResult', inputMap, outMap, null);
        appHandler.invokeMethod('getCartsProductsById', inputMap, outMap, null);
        appHandler.invokeMethod(null, inputMap, outMap, null);
        Test.stopTest();
        
        system.debug('CPQ App Handler outMap: '+outMap);
    }


 

}