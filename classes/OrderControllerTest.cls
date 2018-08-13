@isTest
private class OrderControllerTest {

    @isTest
    private static void TestGetOrderConciliateOM() {
        OrderManagerIntegrationProperties__c conProp = new OrderManagerIntegrationProperties__c();
        conProp.EndpointGet__c = 'https://api.dev.ta.xom.vloc-dev.com/ordermanagement/v1/orderMilestoneInfo/';
        conProp.EndpointLoginUrl__c = 'https://ui.dev.ta.xom.vloc-dev.com/security/v1/login';
        conProp.Password__c = 'vlocity';
        conProp.User__c = 'admin';
        conProp.Name = 'Milestones';
        insert conProp;

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOrderController());
            OrderController testOrderController = new OrderController();
        Test.stopTest();
    }
}