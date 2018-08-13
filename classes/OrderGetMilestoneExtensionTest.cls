@isTest
private class OrderGetMilestoneExtensionTest {

    static testmethod void getMilestoneTest() {
        Account acc = TestDataFactory.createAccounts(1)[0];
        Order ord = TestDataFactory.createOrders(1,acc)[0];
        OrderManagerIntegrationProperties__c conProp = new OrderManagerIntegrationProperties__c();
        conProp.EndpointGet__c = 'https://api.dev.ta.xom.vloc-dev.com/ordermanagement/v1/orderMilestoneInfo/';
        conProp.EndpointLoginUrl__c = 'https://ui.dev.ta.xom.vloc-dev.com/security/v1/login';
        conProp.Password__c = 'vlocity';
        conProp.User__c = 'admin';
        conProp.Name = 'Milestones';
        insert conProp;
        ApexPages.StandardController stdController = new ApexPages.StandardController(ord);
        OrderGetMilestoneExtension testOrderGetMilestoneExtension = new OrderGetMilestoneExtension(stdController);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorOrderController());
        Test.startTest();
            testOrderGetMilestoneExtension.getMilestone();
        Test.stopTest();
    }
}