@isTest
public class taSalesNominacionArgentinoCtrTest {
    @isTest static void constructorArgCtrTest() {
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);

        Account acc = [SELECT Id FROM Account LIMIT 1];
        Order ord = TestDataFactory.createOrders(1, acc)[0];
        
        Date day = Date.today();
        
        ApexPages.currentPage().getParameters().put('accountId',acc.id);
        ApexPages.StandardController stdLead = new ApexPages.StandardController(ord);

        Test.startTest();
            taSalesNominacionArgentinoController testNominacionArg = new taSalesNominacionArgentinoController();
        Test.stopTest();
    }
}