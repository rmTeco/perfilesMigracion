@isTest
public class taSalesNominacionExtranjeroCtrTest {
    
    @isTest static void constructorExtrCtrTest(){
        Account acc = TestDataFactory.createAccounts(1,'Consumer')[0];    
        TestDataFactory.setTeamMember('Test', userinfo.getUserId(), null);
        Order ord = TestDataFactory.createOrders(1, acc)[0];
        
        ApexPages.currentPage().getParameters().put('accountId',acc.id);
        ApexPages.StandardController stdLead = new ApexPages.StandardController(ord);
        
        taSalesNominacionExtranjeroController testNomExtrCntrl = new taSalesNominacionExtranjeroController();
        
        System.assertEquals(testNomExtrCntrl.document, acc.DocumentNumber__c);
    }
}